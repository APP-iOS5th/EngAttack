//
//  Rank.swift
//  EngAttack
//
//  Created by mosi on 5/4/24.
//

import Foundation



struct Rank: Codable, Hashable {
    var name: String
    var score: Int
    
    
    var addRank: [String:Any] {
        return [
            "name": self.name,
            "score" : self.score
        ]
    }
    
  
}
