//
//  WordBookmarkView.swift
//  EngAttack
//
//  Created by MadCow on 2024/4/30.
//

import SwiftUI
import SwiftData

struct WordBookmarkView: View {
    
    @Query private var storedWords: [TempModel]
    @Environment(\.modelContext) var modelContext
    
    @State private var bookMarkList: [(String, String, Bool)] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(0..<bookMarkList.count, id: \.self) { index in
                        HStack {
                            let word = bookMarkList[index]
                            Text(word.2 ? word.0 : word.1)
                            Spacer()
                            Button(word.2 ? "뜻 보기" : "단어 보기") {
                                bookMarkList[index].2.toggle()
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        guard let index = indexSet.first else { return }
                        modelContext.delete(storedWords[index])
                    })
                }
            }
            .navigationTitle("Word Book Mark")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
        .onAppear {
            let words = storedWords.map{ $0.word.components(separatedBy: "--") }
            bookMarkList = words.map{ ($0[0], $0[1], true) }
        }
    }
}

#Preview {
    WordBookmarkView()
        .modelContainer(for: TempModel.self)
}

/*
 MARK: TODO -
    1. SwiftData에 저장된 Bookmark 단어 표시 ✅ -> 좀 더 정보 전달이 명확하도록 수정(우선순위 중간)
    2. SwiftData에 저장된 Bookmark 단어 삭제 ✅
    3. 지금은 단어 : 뜻 으로 표시되어 있는데 처음에는 단어만 표시되고 select하면 뜻이 보이도록 수정(하는거 맞나..?) ✅
 */
