//
//  WordDictionaryViewModel.swift
//  EngAttack
//
//  Created by MadCow on 2024/4/30.
//

import SwiftUI
import SwiftData

class WordDictionaryViewModel: ObservableObject {
    
    @Published private var words: [(String, String)] = []
    private let session = URLSession.shared
    
    func getWords() -> [(String, String)] {
        return words
    }
    
    // TODO: url Request 중복 부분 합치기
    func isExistWord(word: String) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var isExist: Bool = false
        
        let str = "https://suggest.dic.daum.net/language/v1/search.json?cate=eng&q=\(word)"
        
        guard let url = URL(string: str) else { return false }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            defer {
                semaphore.signal()
            }
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
                            if key == word {
                                let splitItem = itemText.split(separator: "|")
                                let value = String(splitItem[splitItem.count - 1])
                                wordList.append((key.lowercased(), value))
                                break
                            }
                        }
                    }
                }
                isExist = wordList.count > 0
            } catch {
                print("error > \(error.localizedDescription)")
            }
        }
        task.resume()
        semaphore.wait()
        return isExist
    }
    
    func searchString(searchWord: String) {
        // https://dic.daum.net/index.do?dic=eng
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
                            if key.starts(with: searchWord) && key.count > 2 && !key.contains("-") {
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
    
    func recommendWordList(alphabet: String, wordList: [String], complete: @escaping (_ recommendList: [(String, String)]) -> Void) {
        let exceptWordList: String = wordList.joined(separator: ", ")
        let apiKey = "YourAPIKey"
        let requestText = "\(alphabet.lowercased())로 시작하는 5글자 이상의 소문자 영어단어 (\"단어:한글뜻\") 형태로 앞에 \(exceptWordList) 제외하고 다양하게 5개정도 알려줘"
        let endpoint = "https://api.openai.com/v1/chat/completions"
        let requestData: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "user",
                    "content": requestText
                ]
            ]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: requestData)
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                var result: [(String, String)] = []
                content.split(separator: "\n").map{ $0.components(separatedBy: ":") }.forEach{ word in
                    let engWord = word[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let meaning = word[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    result.append((engWord, meaning))
                }
                
                complete(result)
            } else {
                print("Failed to extract content from JSON")
            }
        }

        task.resume()
    }
}
