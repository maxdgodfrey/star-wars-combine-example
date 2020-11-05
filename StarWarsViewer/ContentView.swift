//
//  ContentView.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 15/10/20.
//

import SwiftUI
import Combine

struct ContentView: View {
  
    @ObservedObject var dataSource = DataSource()
    
    var body: some View {
        NavigationView {
            List(self.dataSource.planets, id: \.name) { planet in
                NavigationLink(planet.name, destination: ResidentListView(planet: planet))
            }
            .navigationTitle("Planets")
        }.onAppear(perform: self.dataSource.fetchPlanets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
