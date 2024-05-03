//
//  BookMark.swift
//  EngAttack
//
//  Created by mosi on 5/3/24.
//

import Foundation

struct BookMark: Codable, Hashable {
    var word: String
    var description: String
    
    
    var addBookMarkNumber: [String:Any] {
        return [
            "word": self.word,
            "description" : self.description
        ]
    }
    
    var deleteBookMarkNumber: [String:Any] {
        return [
            "word": self.word,
            "description" : self.description
        ]
    }
}
