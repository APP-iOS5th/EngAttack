//
//  WordDictionaryView.swift
//  EngAttack
//
//  Created by MadCow on 2024/4/30.
//

import SwiftUI

struct WordDictionaryView: View {
    
    @StateObject private var viewModel: WordDictionaryViewModel = WordDictionaryViewModel()
    @State private var searchString: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.getWords(), id: \.self) { word in
                        HStack {
                            Text(word)
                            Spacer()
                            Image(systemName: "bookmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                        }
                    }
                }
            }
            .navigationTitle("Word Dictionary")
        }
        .searchable(text: $searchString, prompt: "Search Word")
        .onSubmit(of: .search) {
            if !searchString.isEmpty {
                viewModel.searchString(searchWord: searchString.lowercased())
            } else {
                viewModel.saveSearchResult(words: [])
            }
        }
    }
}

#Preview {
    WordDictionaryView()
}
