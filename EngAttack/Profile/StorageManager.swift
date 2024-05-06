//
//  StorageManager.swift
//  EngAttack
//
//  Created by mosi on 5/6/24.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import UIKit


final class StorageManager {
    
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference()
                    
    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    private func userReference(userID: String) -> StorageReference {
        storage
    }
    
    func getUrlForImage(path: String) async throws -> URL {
        try await Storage.storage().reference(withPath: path).downloadURL()
    }
    
    func updateUserProfileImagePath(userId: String, email: String, name: String ,path: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("USER").document(userId).updateData(["email" : email, "name" : name, "photoUrl" : path])
    }
    
    
    func saveImage(data: Data, userID: String) async throws ->(path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(userID).jpeg"
        let returnedMetaData = try await userReference(userID: userID).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }
    
    func saveImage(image: UIImage, userId: String) async throws -> (path: String, name: String) {
        // image.pngData() 이미지 Png면 이렇게 쓰기
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        
        return try await saveImage(image: image, userId: userId)
    }
  
    
    func getData(userID: String, path:String) async throws -> Data {
        try await userReference(userID: userID).child(path).data(maxSize: 3 * 1024 * 1024)
    }
    
    
    func getImage(userID: String, path: String) async throws -> UIImage {
        let data = try await getData (userID: userID, path: path)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
    }
}
