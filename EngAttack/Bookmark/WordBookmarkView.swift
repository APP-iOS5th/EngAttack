//
//  WordBookmarkView.swift
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

struct WordBookmarkView: View {
    
    @Query private var storedWords: [TempModel]
    @Environment(\.modelContext) var modelContext
    
    @State var firebaseWords: [(String, String, Bool)] = []
    private let bookMarkViewModel = WorkBookmarkViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(0..<firebaseWords.count, id: \.self) { index in
                        HStack {
                            let word = firebaseWords[index]
                            Text(word.2 ? word.0 : word.1)
                            Spacer()
                            Button(word.2 ? "뜻 보기" : "단어 보기") {
                                firebaseWords[index].2.toggle()
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        guard let index = indexSet.first else { return }
                        guard let storedIndex = storedWords.map({ $0.word.components(separatedBy: "--")[0] }).firstIndex(of: firebaseWords[index].0) else { return }
                        modelContext.delete(storedWords[storedIndex])
                        bookMarkViewModel.deleteBookMark(word: firebaseWords[index].0, description: firebaseWords[index].1)
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
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let db = Firestore.firestore()
            db.collection("BookMark").document(userID).getDocument { (doc, error) in
                if let error = error {
                    print("error > \(error.localizedDescription)")
                } else {
                    guard let document = doc else { return }
                    if document.exists {
                        guard let words = document.data(), let list = words["List"] as? [[String: Any]] else { return }

                        for item in list {
                            guard let word = item["word"] as? String else { continue }
                            guard let description = item["description"] as? String else { continue }
                            
                            if !word.isEmpty && !description.isEmpty {
                                firebaseWords.append((word, description, true))
                            }
                        }
                    }
                }
            }
        }
        .onDisappear {
            firebaseWords = []
        }
    }
}

#Preview {
    WordBookmarkView()
}

/*
 MARK: TODO -
    1. SwiftData에 저장된 Bookmark 단어 표시 ✅ -> 좀 더 정보 전달이 명확하도록 수정(우선순위 중간)
    2. SwiftData에 저장된 Bookmark 단어 삭제 ✅
    3. 지금은 단어 : 뜻 으로 표시되어 있는데 처음에는 단어만 표시되고 select하면 뜻이 보이도록 수정(하는거 맞나..?) ✅
 */
