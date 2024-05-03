//
//  WordBookmarkViewModel.swift
//  EngAttack
//
//  Created by MadCow on 2024/5/3.
//

import Foundation
import SwiftData
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth
import Firebase

class WorkBookmarkViewModel {
    
    func addBookmark(word : String ,description :String) {
        let db = Firestore.firestore()
        let bookmark = BookMark(word: word, description: description)
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("BookMark").document(userID).updateData(["List": FieldValue.arrayUnion([bookmark.addBookMarkNumber])])
        
    }
    
    func deleteBookMark(word: String, description: String) {
        let db = Firestore.firestore()
        let bookMark = BookMark(word: word, description: description)
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("BookMark").document(userID).updateData([
            "List" : FieldValue.arrayRemove([bookMark.deleteBookMarkNumber])])
        
        
    }
}
