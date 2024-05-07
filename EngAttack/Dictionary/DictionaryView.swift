//
//  DictionaryView.swift
//  EngAttack
//
//  Created by 홍준범 on 4/30/24.
//

import SwiftUI
import SwiftData

struct DictionaryView: View {
    
    @Query private var storedWords: [TempModel]
    @Environment(\.modelContext) var modelContext
    @State var recommendWordList: [(String, String)] = []
    @State var tempWord: [String] = []
    var lastWord: String
    private let dictionaryViewModel = WordDictionaryViewModel()
    private let bookMarkViewMdoel = WorkBookmarkViewModel()
    
    var body: some View {
        VStack {
            if recommendWordList.count > 0 {
                List {
                    ForEach(recommendWordList, id: \.self.0) { word in
                        HStack {
                            Text("\(word.0) - \(word.1)")
                            Spacer()
                            Button(tempWord.contains("\(word.0)--\(word.1)") ? "저장 완료" : "북마크 저장") {
                                modelContext.insert(TempModel(word: "\(word.0)--\(word.1)"))
                                bookMarkViewMdoel.addBookmark(word: word.0, description: word.1)
                                self.tempWord.append("\(word.0)--\(word.1)")
                            }
                        }
                    }
                }
            } else {
                ProgressView()
                    .font(.largeTitle)
            }
        }
        .onAppear {
            dictionaryViewModel.recommendWordList(alphabet: lastWord, wordList: []) { recommendList in
                self.recommendWordList = recommendList
            }
        }
    }
}

#Preview {
    DictionaryView(lastWord: "")
        .modelContainer(for: TempModel.self)
}
