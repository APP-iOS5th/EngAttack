//
//  Rank.swift
//  EngAttack
//
//  Created by mosi on 5/3/24.
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

//struct RankData {
//    var name: Sting
//    var 
//}
