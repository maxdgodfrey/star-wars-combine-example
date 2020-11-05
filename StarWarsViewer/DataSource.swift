//
//  DataSource.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 30/10/20.
//

import Foundation
import Combine

class DataSource: ObservableObject {
//    private let planets: [Planet] = Planet.mocks
    
    @Published var planets: [Planet] = []
    var cancellable: AnyCancellable?
    
    func fetchPlanets() {
        cancellable = StarWarsAPI.live.getPlanets()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { planets in
                self.planets = planets
            }
    }
    
    // Success - "Yay"
    // fails - > "Boo"
    func foo() -> AnyPublisher<String, Never> {
        let a = Publishers.Map(upstream: URLSession.shared.dataTaskPublisher(for: URL(string: "fkjhkhjg")!), transform: { $0.data })
        
        
        let b = URLSession.shared.dataTaskPublisher(for: URL(string: "fkjhkhjg")!)
            .map(\.data) // <Data, Error>
            
            .decode(type: String.self, decoder: JSONDecoder()) // <String, Error>
            .replaceError(with: "Booo")
            .eraseToAnyPublisher()
    }
}

struct FooSequence<Element>: Sequence {
    
    typealias Element = Element
}

FooSequence<Int>
FooSequence<String>
let a = AnySequence(FooSequence<bazdfhj>)


func bla() -> Bool {
    
}
