//
//  Resident.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 16/10/20.
//

import Foundation

struct Resident: Decodable {
    let name: String
}

extension Resident {
    
    static let fakes: [Resident] = [
        .init(name: "Foo barson"),
        .init(name: "Mock fooson"),
    ]
}
