//
//  Router.swift
//  GitHubTest
//
//  Created by Manjeet on 02/04/24.
//

import SwiftUI

struct RouterView<T: Hashable, Content: View>: View {

    @ObservedObject
    var router: Router<T>

    @ViewBuilder var buildView: (T) -> Content
    var body: some View {
        NavigationStack(path: $router.paths) {
            buildView(router.root)
            .navigationDestination(for: T.self) { path in
                buildView(path)
            }
        }
        .environmentObject(router)
    }
}

final class Router<T: Hashable>: ObservableObject {

    @Published var root: T
    @Published var paths: [T] = []

    init(root: T) {
        self.root = root
    }

    func push(_ path: T) {
        paths.append(path)
    }

    func pop() {
        paths.removeLast()
    }

    func updateRoot(root: T) {
        self.root = root
    }

    func popToRoot(){
       paths = []
    }
    
    func popTo(_ path: T) {
        if let index = paths.lastIndex(of: path) {
            while (paths.count - 1) != index {
                paths.removeLast()
            }
        }
    }
}

// MARK: - Routes

enum AppRoute: Hashable {
    
    case Search
    case RepoDetails
}
