//
//  WordChainLogic.swift
//  WordChainApp
//
//  Created by Yachae on 4/28/24.
//

import SwiftUI


class ContentViewViewModel: ObservableObject {
	let starterWords = ["apple", "banana", "cherry", "date", "elderberry"]
	@Published var currentWord = ""
	@Published var userInput = ""
	@Published var score = 0
	@Published var alertTitle = ""
	@Published var showAlert = false
	@Published var usedWords = Set<String>()
	@Published var bookmarkedWords = Set<String>()
	@Published var isDarkMode: Bool {
		didSet {
			UserDefaults.standard.set(isDarkMode, forKey: "darkModeKey")
		}
	}
    @Published var isKR : Bool  {
        didSet {
            UserDefaults.standard.set(isKR, forKey: "isKR")
        }
    }
	@Published var timeRemaining = 1.0
	@Published var timerIsActive = false
	@Published var isLoading: Bool = true
	@Published var gameStarted = false
	@Published var countdown: Int = 3
	@Published var isCorrect: Bool = false
    @Published var recommendWordList: [(String, String)] = []
	var countdownTimer: Timer?
	var gameTimer: Timer?
	let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
	private var wordManager = WordManager()
	
	
	init() {
		self.isDarkMode = UserDefaults.standard.bool(forKey: "darkModeKey")
        self.isKR = UserDefaults.standard.bool(forKey: "isKR")
		pickRandomWord()
	}
	
	func pickRandomWord() {
		self.currentWord = wordManager.pickRandomWord()
	}
	
    func submitButton(_ result: @escaping (Bool) -> Void) {
		let word = userInput.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		let word2 = currentWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		// 입력한 단어가 비어있는 경우
		guard word.count > 0 else {
			gameTimer?.invalidate()
            self.alertTitle = isKR ?  "No input word" : "입력된 단어가 없습니다"
			self.isCorrect = false
			self.showAlert = true
			self.userInput = ""
			
			return
		}
        
        guard word.count != 1 else {
            gameTimer?.invalidate()
            self.alertTitle = isKR ? "Please enter at least 2 characters" : "2글자 이상 입력해주세요"
            self.isCorrect = false
            self.showAlert = true
            self.userInput = ""
            
            return
        }
		
		// 입력한 단어가 이전에 사용된 단어인 경우,
		guard !usedWords.contains(word) else {
			gameTimer?.invalidate()
			self.alertTitle = isKR ? "It's a word that's already been used" : "이미 사용된 단어입니다"
			self.isCorrect = false
			self.showAlert = true
			self.userInput = ""
			
			return
		}
		
		// 입력한 단어가 현재의 단어와 동일한 경우
		guard word != currentWord else {
			gameTimer?.invalidate()
			self.alertTitle = isKR ? "It's same word" : "제시된 단어와 같은 단어입니다"
			self.isCorrect = false
			self.showAlert = true
			self.userInput = ""
			
			return
		}
        
		// 단어의 끝 알파벳과 입력한 단어의 첫 알파벳이 일치하는지 검사
		guard let lastChar = word2.last, let firstChar = word.first, lastChar == firstChar else {
			gameTimer?.invalidate()
			self.alertTitle = isKR ? "The first letter of the word does not match the last letter of the previous word." : "단어의 첫 글자가 이전 단어의 마지막 글자와 일치하지 않습니다."
			self.isCorrect = false
			self.showAlert = true
			self.userInput = ""
			
			return
		}
		
		// 유효성 검사
		fetchWordInfo(word: word) { isValid in
			if isValid {
				DispatchQueue.main.async {
					self.usedWords.insert(word)
					self.currentWord = word
					self.score += 1
					self.isCorrect = true
					self.userInput = ""
                    
                    result(self.isCorrect)
				}
			} else {
				DispatchQueue.main.async { [self] in
					gameTimer?.invalidate()
					alertTitle = isKR ? "That's the wrong word" : "잘못된 단어입니다."
					isCorrect = false
					showAlert = true
                    
                    result(self.isCorrect)
				}
			}
		}
		
		self.isCorrect = true
		self.userInput = "" // 입력 초기화
		startTimer()
	}
	
	func gameDuration(selectedTime: Double) {
		timeRemaining = selectedTime
	}
	
	
	// 타이머 기능
	func startTimer() {
		
		timerIsActive = true
		
		gameTimer?.invalidate() // 기존 타이머가 있다면 취소
		gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
			DispatchQueue.main.async {
				guard let self = self else { return }
				if self.timeRemaining > 0.1 {
					self.timeRemaining -= 0.1
				} else {
					self.gameTimer?.invalidate()
					self.timerIsActive = false
					self.timerExpired()
				}
			}
		}
	}
	// 타이머 종료
	func stopTimer() {
		gameTimer?.invalidate()
		gameTimer = nil
		timerIsActive = false
	}
	
	// 타이머 제한시간 만료, 타이머 재시작
	func timerExpired() {
		DispatchQueue.main.async {
            self.alertTitle = self.isKR ? "Time out" : "제한 시간 초과"
			self.showAlert = true
			// 타이머를 정지합니다.
			self.timerIsActive = false
		}
	}
    
	// 게임 종료 알람
	func gameEndAlert() -> Alert {
        var isKRs = isKR
		return Alert(
			title: Text(isKRs ? "Time out" : "제한 시간 초과"),
			message: Text(isKRs ? "Your score is \(score)" : "당신의 점수는 \(score)점 입니다."),
            primaryButton: .default(Text(isKRs ? "Regame" : "다시하기"), action: {
				self.resetGame()
			}),
			secondaryButton: .cancel(Text(isKRs ? "Stop" : "그만하기"), action: {
				
			})
		)
	}
	
	// 북마크 기능
	func bookmarkCurrentWord() {
		bookmarkedWords.insert(currentWord)
	}
	// 영구저장
	func saveBookmarks() {
		UserDefaults.standard.set(Array(bookmarkedWords), forKey: "BookmarkedWords")
	}
	// 북마크 불러오기
//	func loadBookmarks() {
//		if let savedWords = UserDefaults.standard.array(forKey: "BookmarkedWords") as? [String] {
//			bookmarkedWords = Set(savedWords)
//			if bookmarkedWords.isEmpty {
//				self.alertTitle = "북마크가 없습니다."
//				self.showAlert = true
//			} else {
//				self.alertTitle = "북마크가 없습니다"
//				self.showAlert = true
//			}
//		}
//	}
	// 게임 초기화
	func resetGame() {
		stopTimer()
		countdownTimer?.invalidate()
		gameStarted = false
		score = 0
		timeRemaining = 10.0
	}
	
	// 게임 시작
	func startGame() {
		self.resetGame()
		gameStarted = true
	}
	
	
	// 게임 종료
	func stopGame() {
		userInput = ""
		score = 0
	}
}
