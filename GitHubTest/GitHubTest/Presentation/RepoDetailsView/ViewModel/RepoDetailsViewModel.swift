//
//  RepoDetailsViewModel.swift
//  GitHubTest
//
//  Created by Manjeet on 02/04/24.
//

import Foundation

class RepoDetailsViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var model: [ContributorModel] = []
    
    // MARK: - API Functions
 
    func getContributors(_ link: String) async -> String? {
        
        guard let url = URL(string: link) else {
            return ""
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode([ContributorModel].self, from: data)
            DispatchQueue.main.async {
                self.model = decodedResponse
            }
            return model.count > 0 ? nil : "No data found"
        } catch {
            print(error)
            return error.localizedDescription
        }
    }
}
