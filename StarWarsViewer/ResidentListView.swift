//
//  ResidentListView.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 15/10/20.
//

import SwiftUI
import Combine

struct ResidentListViewState: Equatable {
    let planetName: String
    let residents: [String]
}

struct ResidentListView: View {
        
    let viewState: ResidentListViewState
    
    init(planet: Planet) {
        viewState = .init(planetName: planet.name, residents: Resident.fakes.map(\.name))
    }
    
    var body: some View {
        List(viewState.residents, id: \.self) {
            Text($0)
        }
        .navigationTitle(viewState.planetName)
    }
}
