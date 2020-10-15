//
//  StarWarsViewerTests.swift
//  StarWarsViewerTests
//
//  Created by Max Godfrey on 15/10/20.
//

import XCTest
import Combine
@testable import StarWarsViewer

class StarWarsViewerTests: XCTestCase {

    func testSingle() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = XCTestExpectation()
        let cancel = StarWarsAPI.live.getPlanets().sink { (completion) in
            print(completion)
            switch completion {
            case .finished: break
            case .failure(let error):
                XCTFail("Failed")
            }
        } receiveValue: { planets in
            print(planets)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
    }
    
    func testZip() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = XCTestExpectation()
        let cancel = StarWarsAPI.live.getPlanets().flatMap { planets in
            planets.first.flatMap(StarWarsAPI.live.getResidentsOnPlanet) ?? Just([Resident]()).mapError { $0 }.eraseToAnyPublisher()
        }.sink { (completion) in
            switch completion {
            case .failure(let error):
                print(error)
                XCTFail()
            case .finished: break
            }
        } receiveValue: { (residents) in
            print(residents)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
    }
}
