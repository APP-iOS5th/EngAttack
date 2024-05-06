//
//  ViewModel.swift
//  EngAttack
//
//  Created by mosi on 5/1/24.

//
//  ViewModel.swift
//  LoginSignIn
//
//  Created by mosi on 5/1/24.
//

import SwiftUI
import Firebase
import Foundation
import FirebaseAuth


@MainActor
final class SignViewModel : ObservableObject {
    @AppStorage("uid") var uid = ""
    @AppStorage("name") var name = ""
    @AppStorage("email") var email = ""
    @Published var emails = ""
    @Published var password = ""
    @Published var Signstate :SignInState = .signedOut
    @Published var currentUser: Firebase.User?
    @Published var authUser: AuthDataResultModel?  =  nil
    
    
    init() {
        currentUser = Auth.auth().currentUser
    }
    
    
    func loadName() async throws {
        guard let userID = Auth.auth().currentUser?.uid else { return }
         let db = Firestore.firestore()
                try await db.collection("USER").document(userID).getDocument { (doc, error) in
                    guard error == nil else {
                        print("error", error ?? "")
                        return
                    }
                    if let doc = doc, doc.exists {
                        let data = doc.data()
                        if let data = data {
                            for i in data  {
                                let email = data["email"] as? String ?? ""
                                self.name = data["name"] as? String ?? ""
                                let photoUrl = data["photoUrl"] as? String ?? ""
                                if self.name != "" {
                                    return
                                }
                            }
                        }
                        else {
                            return
                        }
                    }
                     if self.name != "" {
                         return
                     }
                }
   
        
     }
    
    func signIn(email: String, password: String) async throws  {
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        print("로그인 완료")
    }
    
    func signUp(email: String, password: String) async throws {
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        print("회원가입 완료")
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try  AuthenticationManager.shared.signOut()
        currentUser = nil
        print("로그아웃 완료")
    }
    
    func updatePassword(password :String) async throws {
        try await AuthenticationManager.shared.updatePassword(passwords: password)
        print("비밀변경완료")
    }
    
    func deleteUser() async throws {
        try await AuthenticationManager.shared.deleteUser()
        print("회원탈퇴완료")
    }
    
}
