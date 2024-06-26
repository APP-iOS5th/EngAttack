//
//  WordDictionaryView.swift
//  EngAttack
//
//  Created by MadCow on 2024/4/30.
//

import SwiftUI
import SwiftData
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth
import Firebase

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
    @StateObject private var dictionaryViewModel: WordDictionaryViewModel = WordDictionaryViewModel()
    @EnvironmentObject var contentViewModel : ContentViewViewModel
    @State private var searchString: String = ""
    private let bookMarkViewModel = WorkBookmarkViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(dictionaryViewModel.getWords(), id: \.0) { word in
                        let temp: String = "\(word.0)--\(word.1)"
                        let result = temp.components(separatedBy: "--")
                        let bookmarkedWords: [TempModel] = storedWords.filter{ $0.word == "\(word.0)--\(word.1)" }
                        HStack {
                            Text(word.0)
                                .frame(alignment: .leading)
                            Spacer()
                            Text(word.1)
                                .frame(alignment: .leading)
                            Spacer()
                            Button {
                                if bookmarkedWords.count > 0 {
                                    bookMarkViewModel.deleteBookMark(word: result[0], description: result[1])
                                    modelContext.delete(bookmarkedWords[0])
                                } else {
                                    bookMarkViewModel.addBookmark(word: result[0], description: result[1])
                                    modelContext.insert(TempModel(word: "\(word.0)--\(word.1)"))
                                }
                            } label: {
                                Image(systemName: bookmarkedWords.count > 0 ? "bookmark.circle.fill" : "bookmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                            }
                        }
                        .font(.system(size: 15))
                    }
                }
            }
            .navigationTitle(contentViewModel.isKR ? "Word Dictionary" : "단어 사전")
        }
        .searchable(text: $searchString, prompt: contentViewModel.isKR ? "Search Word" : "단어 검색")
        .onSubmit(of: .search) {
            if !searchString.isEmpty {
                dictionaryViewModel.searchString(searchWord: searchString.lowercased())
            } else {
                dictionaryViewModel.saveSearchResult(words: [])
            }
        }
        .onDisappear {
            searchString = ""
            dictionaryViewModel.saveSearchResult(words: [])
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
