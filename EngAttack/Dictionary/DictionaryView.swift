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
    var lastWord: String
    private let viewModel = WordDictionaryViewModel()
    @State var tempWord: [String] = []
    
    var body: some View {
        List {
            ForEach(recommendWordList, id: \.self.0) { word in
                HStack {
                    Text("\(word.0) - \(word.1)")
                    Spacer()
                    Button(tempWord.contains("\(word.0)--\(word.1)") ? "저장 완료" : "북마크 저장") {
                        modelContext.insert(TempModel(word: "\(word.0)--\(word.1)"))
                        self.tempWord.append("\(word.0)--\(word.1)")
                    }
                }
            }
        }
        .onAppear {
            viewModel.recommendWordList(alphabet: lastWord, wordList: []) { recommendList in
                self.recommendWordList = recommendList
            }
        }
    }
}

#Preview {
    DictionaryView(lastWord: "")
        .modelContainer(for: TempModel.self)
}
