//
//  RepoDetailsView.swift
//  GitHubTest
//
//  Created by Manjeet on 02/04/24.
//

import SwiftUI
import WebKit

// I had to use this approach to pass data from one view to another because i was facing some unexpected error and didn't had enough time to solve it
var currentRepo = Item()
let screenWidth = UIScreen.main.bounds.width

struct RepoDetailsView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = RepoDetailsViewModel()
    @State var repoDetails: Item = .init()
    @State private var showLoader = false
    @State private var showWebView = false
    
    // MARK: - Main View
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                AsyncImage(url: .init(string: repoDetails.owner?.avatarURL ?? "")) { image in
                    image
                        .image?.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth)
                        .frame(height: 200)
                        .clipped()
                        .padding(.bottom, 10)
                }
                
                VStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("Name :-")
                            .font(.system(size: 14, weight: .bold))
                        Text(repoDetails.name ?? "")
                            .font(.system(size: 14, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Description :-")
                            .font(.system(size: 14, weight: .bold))
                        Text(repoDetails.description ?? "")
                            .font(.system(size: 14, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Link :-")
                            .font(.system(size: 14, weight: .bold))
                        Text(repoDetails.htmlURL ?? "")
                            .underline()
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                if let link = repoDetails.htmlURL,
                                   let _ = URL(string: link) {
                                    showWebView = true
                                }
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contributors :-")
                            .font(.system(size: 14, weight: .bold))
                        
                        if !viewModel.model.isEmpty {
                            ForEach(0..<viewModel.model.count, id: \.self) { index in
                                HStack {
                                    AsyncImage(url: .init(string: viewModel.model[index].avatarURL ?? "")) { image in
                                        image
                                            .image?.resizable()
                                            .frame(width: 24, height: 24)
                                            .clipped()
                                    }

                                    Text(viewModel.model[index].login ?? "")
                                        .font(.system(size: 14, weight: .regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
            }
        }
        .frame(width: screenWidth)
        .navigationTitle("Details")
        .task {
            self.repoDetails = currentRepo
            showLoader = true
            callGetContributorsAPI()
        }
        .sheet(isPresented: $showWebView, content: {
            if let url = URL(string: repoDetails.htmlURL ?? "") {
                WebView(url: url)
            }
        })
        .overlay {
            if showLoader {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
            
    }
}

// MARK: - API Functions

private extension RepoDetailsView {
    
    func callGetContributorsAPI() {
        Task {
            if let error = await viewModel.getContributors(repoDetails.contributorsURL ?? "") {
                print(error)
            } else {
               
            }
            showLoader = false
        }
    }
}

// MARK: - Preview

#Preview {
    RepoDetailsView()
}

// MARK: - UIKit WebView

struct WebView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
