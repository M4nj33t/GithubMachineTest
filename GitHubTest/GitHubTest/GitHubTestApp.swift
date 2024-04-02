//
//  GitHubTestApp.swift
//  GitHubTest
//
//  Created by Manjeet on 01/04/24.
//

import SwiftUI

@main
struct GitHubTestApp: App {
    
    @StateObject var router = Router(root: AppRoute.Search)
    
    var body: some Scene {
        WindowGroup {
            RouterView(router: router) { path in
                switch path {
                case .Search:
                    SearchView()
                case .RepoDetails:
                    RepoDetailsView()
                }
            }
            .environmentObject(router)
        }
    }
}
