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
    
    static let mock: StarWarsAPI = {
        StarWarsAPI(
            getPlanets: {
                Just(Planet.mocks)
                    .mapError { $0 }
                    .eraseToAnyPublisher()
            },
            getResidentsOnPlanet: { planet in
                Just(Resident.fakes)
                    .mapError { $0 }
                    .eraseToAnyPublisher()
            }
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
        fatalError("Not implemented")
    }
    
    func getResidents(on planet: Planet) -> AnyPublisher<[Resident], Error> {
        fatalError("Not implemented")
    }
}
