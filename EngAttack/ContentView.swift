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



struct ContentView: View {
	@EnvironmentObject var viewModel: ContentViewViewModel
	@EnvironmentObject var setViewModel: SettingViewModel
	
	@Binding var timeRemaining: Double
	let effectVol = 0.3
	
   
    
	var body: some View {
		NavigationStack {
			VStack {
				Text("남은 시간: \(String(format: "%.1f", viewModel.timeRemaining))초")
					.font(.title)
					.padding()
				
				ProgressView(value: max(0, min(viewModel.timeRemaining, 60.0)), total: timeRemaining)
					.padding()
				
				Text(viewModel.currentWord)
					.padding()
				
				TextField("단어 입력하기", text: $viewModel.userInput, onCommit: { viewModel.submitButton()
					viewModel.timeRemaining = timeRemaining
					if viewModel.isCorrect {
						// correct sound
						SoundSetting.instance.setVolume(setViewModel.isEffect ? Float(effectVol) : 0)
						SoundSetting.instance.playSound(sound: .correct)
					}
					else {
						// fail sound
						SoundSetting.instance.setVolume(setViewModel.isEffect ? Float(effectVol) : 0)
						SoundSetting.instance.playSound(sound: .error)
					}
				})
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.background()
				.padding()
			}
			
			Button("북마크하기") {
				viewModel.bookmarkCurrentWord()
			}
			.padding()
			
			Text("Score: \(viewModel.score)")
			
			
				.alert(isPresented: $viewModel.showAlert) {
					Alert(title: Text(viewModel.alertTitle),
						  message: Text("당신의 점수는 \(viewModel.score)점 입니다."),
						  primaryButton: .default(Text("다시하기"), action: {
                        addRank(name: "테스트", score: viewModel.score)
						viewModel.resetGame()
						viewModel.userInput = ""
					}),
						  secondaryButton: .destructive(Text("그만하기"), action: {
                        addRank(name: "테스트", score: viewModel.score)
						viewModel.resetGame()
						viewModel.stopTimer()
						viewModel.userInput = ""
					}))
				}
		}
		.onAppear {
			viewModel.pickRandomWord()
			viewModel.timeRemaining = timeRemaining
			viewModel.startTimer()
		}
		.onDisappear {
			viewModel.stopTimer()
		}
	}
}



#Preview {
	ContentView(timeRemaining: .constant(5))
		.environmentObject(ContentViewViewModel())
		.environmentObject(SettingViewModel())
}


extension ContentView {
    func addRank(name: String, score: Int) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let rank = Rank(name: "비어있음", score: viewModel.score)
                db.collection("Rank").document(userID).updateData(["List": FieldValue.arrayUnion([rank.addRank])])
    }
}
