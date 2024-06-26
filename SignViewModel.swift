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
    @Published var uid = ""
    @Published var email = ""
    @Published var password = ""
    @Published var Signstate :SignInState = .signedOut
    @Published var currentUser: Firebase.User?
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    init() {
        currentUser = Auth.auth().currentUser
    }
    
    func signIn() async throws {
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        print("로그인 완료")
    }
    
    func signUp() async throws {
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
        currentUser = nil
        print("로그아웃 완료")
    }
    
   
}
