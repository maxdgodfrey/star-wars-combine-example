//
//  ResidentListView.swift
//  StarWarsViewer
//
//  Created by Max Godfrey on 15/10/20.
//

import SwiftUI
import Combine

enum LoadableResult<T, E> where E: Equatable & Error {
    case result(Result<T, E>)
    case loading
    
    var isLoading: Bool {
        switch self {
        case .loading: return true
        case .result: return false
        }
    }
}

extension LoadableResult: Equatable where T: Equatable {
    static func == (lhs: LoadableResult<T, E>, rhs: LoadableResult<T, E>) -> Bool {
        switch (lhs, rhs) {
        case let (.result(l), .result(r)):
            return l == r
        case (.loading, .loading): return true
        default: return false
        }
    }
}

enum APIError: Error, Equatable {
    case failed
}

struct Row: Identifiable, Equatable {
    let id = UUID()
    let value: LoadableResult<String, APIError>
}

struct ResidentListViewState: Equatable {
    let planetName: String
    let residents: [Row]
}

final class ResidentListViewModel: ObservableObject {
    
    @Published var viewState: ResidentListViewState
    private let appeared = PassthroughSubject<Void, Never>()
    private var cancelSet = Set<AnyCancellable>()
    
    init(planet: Planet) {
        viewState = ResidentListViewState(planetName: planet.name, residents: [])
        
        appeared.zip(Just(viewState)).map { _, viewState in viewState }
            .flatMap { viewState in
                StarWarsAPI.live.getResidentForURL(planet)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                // TODO:
                print(value)
            }.store(in: &cancelSet)
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
    
    func foo(_ a: LoadableResult<String, APIError>) -> some View {
        switch a {
        case .result(let result):
            return Text("Loaded")
        case .loading:
            return Text("Loading")
        }
    }
    
    var body: some View {
        Group {
            if viewModel.viewState.residents.isEmpty == false {
                List(viewModel.viewState.residents) { loadableResult in
                    Group {
                        foo(loadableResult.value)
                    }
//                    switch loadableResult.row {
//                    case let .result(a):
//                        Text("Loaded")
//                    case .loading:
//                        Text("Loading").redacted(reason: .placeholder)
//                    }
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
