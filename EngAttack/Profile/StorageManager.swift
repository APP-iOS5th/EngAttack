//
//  StorageManager.swift
//  EngAttack
//
//  Created by mosi on 5/6/24.
//

import Foundation
import FirebaseStorage



final class StorageManager {
    
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference()
    
    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    private func userReference(userID: String) -> StorageReference {
        storage.child("users").child(userID)
    }
    
    func saveImage(data: Data, userID : String) async throws ->(path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userReference(userID: userID).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }
}
