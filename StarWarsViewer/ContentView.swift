//
//  ContentView.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 15/10/20.
//

import SwiftUI
import Combine

struct PlanetListViewState {
    
    let planets: [Planet]
}

final class PlanetViewModel: ObservableObject {
    
    @Published var viewState: PlanetListViewState?
    private let appeared = PassthroughSubject<Void, Never>()
    
    init() {
        appeared.map(PlanetListViewState?.init).flatMap { _ in
            StarWarsAPI.live.getPlanets().replaceError(with: []).map { planets -> PlanetListViewState in
                PlanetListViewState(
                    planets: planets
                )
            }.map(Optional.some)
        }
        .receive(on: DispatchQueue.main)
        .assign(to: &$viewState)
    }
    
    func onAppear() {
        appeared.send(())
    }
}

struct ContentView: View {
    
    @StateObject var viewModel = PlanetViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if let viewState = viewModel.viewState {
                    List(viewState.planets, id: \.name) { planet in
                        NavigationLink(planet.name, destination: ResidentListView(planet: planet))
                    }
                } else {
                    ProgressView("Loading...")
                }
            }.navigationTitle("Planets")
        }
        .onAppear { viewModel.onAppear() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
