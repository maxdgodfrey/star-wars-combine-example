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

final class ResidentListViewModel: ObservableObject {
    
    @Published var viewState: ResidentListViewState
    private let appeared = PassthroughSubject<Void, Never>()
    
    init(planet: Planet) {
        viewState = ResidentListViewState(planetName: planet.name, residents: [])
        
        appeared.zip(Just(viewState)).map { _, viewState in viewState }
        .flatMap { viewState in
            StarWarsAPI.live.getResidentsOnPlanet(planet).replaceError(with: []).map { residents -> ResidentListViewState in
                ResidentListViewState(
                    planetName: viewState.planetName,
                    residents: residents.map(\.name)
                )
            }
        }
        
        .removeDuplicates()
        .receive(on: DispatchQueue.main)
        .assign(to: &$viewState)
    }
    
    func onAppear() {
        appeared.send(())
    }
}

struct ResidentListView: View {
    
    @ObservedObject var viewModel: ResidentListViewModel
    
    init(planet: Planet) {
        self.viewModel = .init(planet: planet)
    }
    
    var body: some View {
        Group {
            if viewModel.viewState.residents.isEmpty == false {
                List(viewModel.viewState.residents, id: \.self) {
                    Text($0)
                }
            } else {
                ProgressView("Loading Residents")
            }
        }
        .onAppear { viewModel.onAppear() }
        .navigationTitle(viewModel.viewState.planetName)
    }
}
//
//struct ResidentListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResidentListView(planet: .init(name: "Foobar", residentURLs: []))
//    }
//}
