//
//  AuthenticationManager.swift
//  EngAttack
//
//  Created by mosi on 5/1/24.
//

import Foundation
import FirebaseAuth
import Firebase




struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

@MainActor
final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init () { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user:user)
    }
    
    func createUser(email:String, password: String) async  throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
        
    func updatePassword(passwords: String) async throws  {
        try await Auth.auth().currentUser?.updatePassword(to: passwords)
    }
    
    func deleteUser() async throws {
        try await Auth.auth().currentUser?.delete()
    }
   
}
