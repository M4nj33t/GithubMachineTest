//
//  SearchView.swift
//  GitHubTest
//
//  Created by Manjeet on 01/04/24.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var router: Router<AppRoute>
    @State private var searchQuery = ""
    @State private var searchIsActive = false
    @State private var showLoader = false
    
    // MARK: - Main View
    
    var body: some View {
        VStack {
            List {
                if let model = viewModel.model?.items {
                    ForEach(0..<model.count, id: \.self) { index in
                        VStack {
                            Text("Name - \(model[index].name ?? "")").frame(maxWidth: .infinity, alignment: .leading)
                            Text("Description - \(model[index].description ?? "")").frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear {
                            handlePagination(index)
                        }
                        .onTapGesture {
                            currentRepo = model[index]
                            router.push(.RepoDetails)
                        }
                    }
                }
            }
            .listRowSpacing(8)
        }
        .searchable(text: $searchQuery, isPresented: $searchIsActive)
        .onSubmit(of: .search) {
            showLoader = true
            callSearchAPI()
        }
        .navigationTitle("Search")
        .overlay {
            if showLoader {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

// MARK: - API

private extension SearchView {
    
    func handlePagination(_ index: Int) {
        if viewModel.shouldPaginate(index) {
            viewModel.isPaginating = true
            callSearchAPI()
        }
    }
    
    func callSearchAPI() {
        Task {
            if let error = await viewModel.getRepoSearchResult(searchQuery.trimmingCharacters(in: .whitespaces)) {
                print(error)
            } else {
               
            }
            showLoader = false
        }
    }
}

// MARK: - Preview

#Preview {
    SearchView()
}
