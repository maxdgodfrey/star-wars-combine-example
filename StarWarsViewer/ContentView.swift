//
//  ContentView.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 15/10/20.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    
    var body: some View {
        NavigationView {
            List(viewModel.planets, id: \.name) { planet in
                NavigationLink(planet.name, destination: ResidentListView(planet: planet))
            }
            .navigationTitle("Planets")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}

class ContentViewModel: ObservableObject {
    @Published var planets: [Planet] = []
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable =
            StarWarsAPI
                .live
                .getPlanets()
                .sink { (result) in
                    print(result)
                } receiveValue: { [weak self] (planetList) in
                    self?.planets = planetList
                }
    }
}
