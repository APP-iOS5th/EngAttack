//
//  ContentView.swift
//  WordChainApp
//
//  Created by Yachae on 4/28/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftData



struct ContentView: View {
	@EnvironmentObject var contentViewModel: ContentViewViewModel
	@EnvironmentObject var setViewModel: SettingViewModel

    @StateObject var singViewModel: SignViewModel = SignViewModel()

    @State private var isShowRecommendWordList: Bool = false

	
	@Binding var timeRemaining: Double
	let effectVol = 0.3
	
	var body: some View {
		NavigationStack {
			VStack() {
                
				Text(contentViewModel.isKR ? "Score: \(contentViewModel.score)" : "스코어: \(contentViewModel.score)")
					.padding(.bottom)
					.bold()
                
				Text(contentViewModel.isKR ? "Time: \(String(format: "%.1f", contentViewModel.timeRemaining))s" : "남은 시간: \(String(format: "%.1f", contentViewModel.timeRemaining))초")
					.font(.custom("SOYO Maple Bold", size: 30))
					.padding()
				
				ProgressView(value: max(0, min(contentViewModel.timeRemaining, 60.0)), total: timeRemaining)
					.progressViewStyle(DarkBlueShadowProgressViewStyle())
					.padding()
				
				Text(contentViewModel.currentWord)
					.font(.title)
					.bold()
					.padding()
				
                TextField(contentViewModel.isKR ? "Enter the word" : "단어를 입력하세요", text: $contentViewModel.userInput, onCommit: {
                    contentViewModel.timeRemaining = timeRemaining
                    contentViewModel.submitButton { result in
                        if result {
                            // correct sound
                            SoundSetting.instance.setVolume(setViewModel.isEffect ? Float(effectVol) : 0)
                            SoundSetting.instance.playSound(sound: .correct)
                        }
                        else {
                            // fail sound
                            SoundSetting.instance.setVolume(setViewModel.isEffect ? Float(effectVol) : 0)
                            SoundSetting.instance.playSound(sound: .error)
                        }
                    }
				})
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.shadow(radius: 4.0, x: 1.0, y: 2.0)
				.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color.lightgray, lineWidth: 3)
				)
				.padding()
				
                NavigationLink(destination: WordBookmarkView().modelContainer(for: TempModel.self)) {
					Text(contentViewModel.isKR ? "Bookmark" : "북마크 보기")
				}
				.padding()
				
				.alert(isPresented: $contentViewModel.showAlert) {
					Alert(title: Text(contentViewModel.alertTitle),
                          message: Text(contentViewModel.isKR ? "Your score is \(contentViewModel.score)" : "당신의 점수는 \(contentViewModel.score)점 입니다."),
                          primaryButton: .default(Text(contentViewModel.isKR ? "Stop" : "그만하기"), action: {
                        contentViewModel.resetGame()
                        contentViewModel.userInput = ""
					}),
						 secondaryButton: .destructive(Text(contentViewModel.isKR ? "Recomended word" : "추천 단어 보기"), action: {
//						viewModel.resetGame()
//						viewModel.stopTimer()
//						viewModel.userInput = ""
                       
                        isShowRecommendWordList = true
					}))
				}
			}
			.onAppear {
                contentViewModel.pickRandomWord()
                contentViewModel.timeRemaining = timeRemaining
                contentViewModel.startTimer()
                SoundSetting.instance.playSound(sound: .background)
			}
			.onDisappear {
               // addRank(names:singViewModel.name, scores:contentViewModel.score)
                contentViewModel.stopTimer()
                SoundSetting.instance.stopMusic()
			}
            .sheet(isPresented: $isShowRecommendWordList, content: {
                DictionaryView(lastWord: String(contentViewModel.currentWord.last!))
                    .modelContainer(for: TempModel.self)
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Text(contentViewModel.isKR ? "< Back" : "< 뒤로")
                    }
                }
            }
		}
	}
}


// 진행바 스타일
struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .scaleEffect(x: 1, y: 3, anchor: .center)
            .shadow(color: Color(red: 0, green: 0, blue: 0.2),
                    radius: 4.0, x: 1.0, y: 2.0)
    }
}

#Preview {
    ContentView(timeRemaining: .constant(5))
        .environmentObject(ContentViewViewModel())
        .environmentObject(SettingViewModel())
}


extension ContentView {
    func addRank(names : String, scores: Int) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let rank = Rank(name: names, score: scores)
                db.collection("Rank").document(userID).updateData(["List": FieldValue.arrayUnion([rank.addRank])])
    }
}
