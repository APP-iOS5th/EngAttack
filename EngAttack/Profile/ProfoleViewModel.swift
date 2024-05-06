//
//  ProfoleViewModel.swift
//  EngAttack
//
//  Created by mosi on 5/6/24.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseAuth
import Firebase

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: AuthDataResultModel? = nil
    
     func loadCurrentUser() throws {
        self.user = try AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func saveProfileImage(item: PhotosPickerItem, email: String, names: String){
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let (path, name) = try await StorageManager.shared.saveImage(data: data, userID: Auth.auth().currentUser!.uid )
            print("Success!")
            print(path)
            print(name)
            try await StorageManager.shared.updateUserProfileImagePath(userId: Auth.auth().currentUser!.uid, email: email, name: names, path: name)
            
        }
    }
    
}
