//
//  URL+Extensions.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 16/10/20.
//

import Foundation

extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        self = url
    }
}
