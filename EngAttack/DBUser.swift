//
//  DBUser.swift
//  EngAttack
//
//  Created by mosi on 5/6/24.
//

import Foundation


struct DBUser: Codable {
    let userID: String
    let email: String?
    let photoUrl: String?
    
    
    init(auth: AuthDataResultModel) {
        self.userID = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
    }
}
