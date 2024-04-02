//
//  SearchViewModel.swift
//  GitHubTest
//
//  Created by Manjeet on 02/04/24.
//

import Foundation

class SearchViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var model: RepoSearchModel?
    private let pageSize = 10
    var pageIndex = 1
    var isPaginating = false
    
    // MARK: - API Functions
    
    func shouldPaginate(_ index: Int) -> Bool {
        guard let count = model?.items?.count,
              let totalElement = model?.totalCount,
              count < totalElement else {
            return false
        }
        return count == (index + 1) && !isPaginating
    }
 
    func getRepoSearchResult(_ query: String) async -> String? {
        let strURL = "https://api.github.com/search/repositories?q=\(query)&per_page=\(pageSize)&page=\(pageIndex)"
        guard let url = URL(string: strURL) else {
            return ""
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(RepoSearchModel.self, from: data)
            isPaginating = false
            if pageIndex == 1 {
                DispatchQueue.main.async {
                    self.model = decodedResponse
                }
            } else {
                DispatchQueue.main.async {
                    let oldResultArr = self.model?.items ?? []
                    let newResultArr = decodedResponse.items ?? []
                    self.model?.items = []
                    self.model?.items = oldResultArr + newResultArr
                }
            }
            pageIndex += 1
            print("URL - \(strURL)")
            return (model?.items?.count ?? 0) > 0 ? nil : "No data found"
        } catch {
            print("URL - \(strURL)")
            print("error - \(error)")
            return error.localizedDescription
        }
    }
}
