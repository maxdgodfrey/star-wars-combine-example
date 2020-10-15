//
//  ContentView.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 15/10/20.
//

import SwiftUI
import Combine

struct ContentView: View {
        
    let planets: [Planet] = Planet.mocks
    
    var body: some View {
        NavigationView {
            List(planets, id: \.name) { planet in
                NavigationLink(planet.name, destination: ResidentListView(planet: planet))
            }
            .navigationTitle("Planets")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
