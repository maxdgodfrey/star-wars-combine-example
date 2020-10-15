//
//  Model.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 15/10/20.
//
import Foundation
import Combine

struct StarWarsAPI {
    var getPlanets: () -> AnyPublisher<[Planet], Error>
    var getResidentsOnPlanet: (Planet) -> AnyPublisher<[Resident], Error>
}

extension StarWarsAPI {
    
    static let live: StarWarsAPI = {
        let client = APIClient()
        return StarWarsAPI(
            getPlanets: client.getPlanets,
            getResidentsOnPlanet: client.getResidents(on:)
        )
    }()
}

extension JSONDecoder {
    static let `default` = JSONDecoder()
}

final class APIClient {
    
    let baseURL = URL(staticString: "https://swapi.dev/api/")
    let session: URLSession
    let decoder: JSONDecoder
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = .default
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    func getPlanets() -> AnyPublisher<[Planet], Error> {
        let planetList: AnyPublisher<APIList<Planet>, Error> = get(path: "planets")
        return planetList.map(\.results).eraseToAnyPublisher()
    }
    
    func getResidents(on planet: Planet) -> AnyPublisher<[Resident], Error> {
        let residents: [AnyPublisher<Resident, Error>] = planet.residentEndpoints.map(get(url:))
        // Zip sucks in Combine :(
        guard let first = residents.first else {
            return Just([Resident]())
            .mapError { $0 }
                .eraseToAnyPublisher()
        }
        return residents.dropFirst()
            .reduce(first.map { [$0] }.eraseToAnyPublisher()) { current, next in
                current.zip(next) { a, b -> [Resident] in
                    a + [b]
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func get<T: Decodable>(path: String) -> AnyPublisher<T, Error> {
        get(url: baseURL.appendingPathComponent(path))
    }
    
    private func get<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
