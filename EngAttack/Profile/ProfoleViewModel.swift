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


final class ProfileViewModel: ObservableObject {

    func saveProfileImage(item: PhotosPickerItem){
        Task {
                guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let (path, name) = try await StorageManager.shared.saveImage(data: data, userID: Auth.auth().currentUser!.uid )
                print("Success!")
                print(path)
                print(name)
            }
    }
}
