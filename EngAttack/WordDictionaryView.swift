//
//  WordDictionaryView.swift
//  EngAttack
//
//  Created by MadCow on 2024/4/30.
//

import SwiftUI
import SwiftData

@Model
class TempModel {
    let id: UUID = UUID()
    let word: String
    
    init(word: String) {
        self.word = word
    }
}

struct WordDictionaryView: View {
    
    @Query private var storedWords: [TempModel]
    @Environment(\.modelContext) var modelContext
    
    @StateObject private var viewModel: WordDictionaryViewModel = WordDictionaryViewModel()
    @State private var searchString: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.getWords(), id: \.0) { word in
                        let alreadExistWord: [TempModel] = storedWords.filter{ $0.word == "\(word.0)--\(word.1)" }
                        HStack {
                            Text(word.0)
                            Spacer()
                            Text(word.1)
                            Spacer()
                            Button {
                                if alreadExistWord.count > 0 {
                                    modelContext.delete(alreadExistWord[0])
                                } else {
                                    let newWord: TempModel = TempModel(word: "\(word.0)--\(word.1)")
                                    modelContext.insert(newWord)
                                }
                            } label: {
                                Image(systemName: alreadExistWord.count > 0 ? "bookmark.circle.fill" : "bookmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                            }
                        }
                        .font(.system(size: 15))
                    }
                }
            }
            .navigationTitle("Word Dictionary")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Test") {
                        if storedWords.count > 0 {
                            let bookmarkEngWords: [String] = storedWords.map{ String($0.word.split(separator: "--")[0]) }
                            
                            viewModel.recommendWordList(alphabet: "c", wordList: bookmarkEngWords) { wordList in
                                print(wordList)
                            }
                        }
                    }
                }
            }
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
        .modelContainer(for: TempModel.self)
}

/*
 MARK: - TODO
    1. 영어 단어 검색, 사전에 있는 단어면 뜻과 같이 출력 ✅
    2. 출력된 단어 List에 북마크로 추가할 수 있는 버튼 ✅
    3. 버튼을 누르면 북마크에 추가 ✅
    4. 이미 북마크에 있는 단어면 별도로 표시 ✅
    5. ViewModel로 이동할 기능들 정리
    6. Return되는 단어 개수를 늘릴 순 없나..?
 */
