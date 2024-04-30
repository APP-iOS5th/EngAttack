//
//  WordDictionaryViewModel.swift
//  EngAttack
//
//  Created by MadCow on 2024/4/30.
//

import SwiftUI

class WordDictionaryViewModel: ObservableObject {
    @Published private var words: [(String, String)] = []
    private let session = URLSession.shared
    
    func getWords() -> [(String, String)] {
        return words
    }
    
    func searchString(searchWord: String) {
        let str = "https://suggest.dic.daum.net/language/v1/search.json?cate=eng&q=\(searchWord)"
        
        guard let url = URL(string: str) else { return }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error 발생 >> \(error!.localizedDescription)")
                self.words = []
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Network에러 발생")
                self.words = []
                return
            }
            
            guard let data = data else {
                print("결과 없음!")
                self.words = []
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Failed to parse JSON")
                    return
                }
                
                var wordList: [(String, String)] = []
                if let items = json["items"] as? [String: Any], let eng = items["eng"] as? [[String: Any]] {
                    for item in eng {
                        if let key = item["key"] as? String, let itemText = item["item"] as? String {
                            if key.starts(with: searchWord) && key.count > 1 {
                                let splitItem = itemText.split(separator: "|")
                                let value = String(splitItem[splitItem.count - 1])
                                wordList.append((key.lowercased(), value))
                            }
                        }
                    }
                }
                self.saveSearchResult(words: wordList)
            } catch {
                print("error > \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func saveSearchResult(words: [(String, String)]) {
        DispatchQueue.main.async {
            self.words = words
        }
    }
}
