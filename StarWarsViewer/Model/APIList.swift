//
//  APIList.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 16/10/20.
//

import Foundation

/**
 GET https://swapi.dev/api/planets/
 {
     "count": 60,
     "next": "http://swapi.dev/api/planets",
     "previous": null,
     "results": [
         {
             "name": "Tatooine",
             "rotation_period": "23",
             "orbital_period": "304",
             "diameter": "10465",
             "climate": "arid",
             "gravity": "1 standard",
             "terrain": "desert",
             "surface_water": "1",
             "population": "200000",
             "residents": [
                 "http://swapi.dev/api/people/1/",
                 "http://swapi.dev/api/people/2/",
                 "http://swapi.dev/api/people/4/",
                 "http://swapi.dev/api/people/6/",
                 "http://swapi.dev/api/people/7/",
                 "http://swapi.dev/api/people/8/",
                 "http://swapi.dev/api/people/9/",
                 "http://swapi.dev/api/people/11/",
                 "http://swapi.dev/api/people/43/",
                 "http://swapi.dev/api/people/62/"
             ],
 etc...
 */
struct APIList<T: Decodable>: Decodable {
    let count: Int
    let results: [T]
}
