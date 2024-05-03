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
	@EnvironmentObject var viewModel: ContentViewViewModel
	@EnvironmentObject var setViewModel: SettingViewModel

    @StateObject var viewModels: SignViewModel = SignViewModel()

    @State private var isShowRecommendWordList: Bool = false

	
	@Binding var timeRemaining: Double
	let effectVol = 0.3
	
	var body: some View {
		NavigationStack {
			VStack() {
				Text("Score: \(viewModel.score)")
					.padding(.bottom)
					.bold()
				
				Text("남은 시간: \(String(format: "%.1f", viewModel.timeRemaining))초")
					.font(.custom("SOYO Maple Bold", size: 30))
					.padding()
				
				ProgressView(value: max(0, min(viewModel.timeRemaining, 60.0)), total: timeRemaining)
					.progressViewStyle(DarkBlueShadowProgressViewStyle())
					.padding()
				
				Text(viewModel.currentWord)
					.font(.title)
					.bold()
					.padding()
				
				TextField("Enter the word", text: $viewModel.userInput, onCommit: { 
                    viewModel.timeRemaining = timeRemaining
                    viewModel.submitButton { result in
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
					Text("북마크 보기")
				}
				.padding()
				
				.alert(isPresented: $viewModel.showAlert) {
					Alert(title: Text(viewModel.alertTitle),
						  message: Text("당신의 점수는 \(viewModel.score)점 입니다."),
						  primaryButton: .default(Text("그만하기"), action: {
                        addRank(name: viewModels.name, score: viewModel.score)
						viewModel.resetGame()
						viewModel.userInput = ""
					}),
						 secondaryButton: .destructive(Text("추천 단어 보기"), action: {
//						viewModel.resetGame()
//						viewModel.stopTimer()
//						viewModel.userInput = ""
                        addRank(name: viewModels.name, score: viewModel.score)
                        isShowRecommendWordList = true
					}))
				}
			}
			.onAppear {
				viewModel.pickRandomWord()
				viewModel.timeRemaining = timeRemaining
				viewModel.startTimer()
                SoundSetting.instance.playSound(sound: .background)
			}
			.onDisappear {
                addRank(viewModels.name, viewModel.score)
				viewModel.stopTimer()
                SoundSetting.instance.stopMusic()
			}
            .sheet(isPresented: $isShowRecommendWordList, content: {
                DictionaryView(lastWord: String(viewModel.currentWord.last!))
                    .modelContainer(for: TempModel.self)
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Text("< 뒤로")
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
    func addRank(_: String, _ : Int) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let rank = Rank(name: viewModels.name, score: viewModel.score)
                db.collection("Rank").document(userID).updateData(["List": FieldValue.arrayUnion([rank.addRank])])
    }
}
