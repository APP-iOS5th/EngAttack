//
//  WordDictionaryViewModel.swift
//  EngAttack
//
//  Created by MadCow on 2024/4/30.
//

import SwiftUI

class WordDictionaryViewModel: ObservableObject {
//    @Published private var findWord: String = ""
    @Published private var words: [String] = ["word"]
    
    func getWords() -> [String] {
        return words
    }
    
    func searchString(searchWord: String) {
        let session = URLSession.shared
        var str = "https://iapi.glosbe.com/iapi3/similar/similarPhrasesMany?p="
            str += searchWord
            str += "&l1=en&l2=ko&removeDuplicates=true&searchCriteria="
            str += "WORDLIST-ALPHABETICALLY-2-s%3BPREFIX-PRIORITY-2-s%3B"
            str += "TRANSLITERATED-PRIORITY-2-s%3BFUZZY-PRIORITY-2-s%3B&"
    //        str += "WORDLIST-ALPHABETICALLY-2-r%3BPREFIX-PRIORITY-2-r%3B"
    //        str += "TRANSLITERATED-PRIORITY-2-r%3BFUZZY-PRIORITY-2-r&"
            str += "env=ko"
        
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
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let phrases = json["phrases"] as? [[String: Any]] {
                    var wordList: [String] = []
                    for phrase in phrases {
                        if let word = phrase["phrase"] as? String {
                            if word.starts(with: searchWord) && word.count > 2 && !word.contains(" ") {
                                wordList.append(word)
                            }
                        }
                    }
                    self.words = wordList
                }
            } catch {
                print("error > \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func saveSearchResult(words: [String]) {
        DispatchQueue.main.async {
            self.words = words
        }
    }
}
