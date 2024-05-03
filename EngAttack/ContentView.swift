//
//  ContentView.swift
//  WordChainApp
//
//  Created by Yachae on 4/28/24.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var viewModel: ContentViewViewModel
	@EnvironmentObject var setViewModel: SettingViewModel
	
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
				
				TextField("Enter the word", text: $viewModel.userInput, onCommit: { viewModel.submitButton()
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
				.shadow(radius: 4.0, x: 1.0, y: 2.0)
				.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color.lightgray, lineWidth: 3)
				)
				.padding()
			}
			.frame(maxHeight:.infinity, alignment: .top)
			
			Button("북마크하기") {
				viewModel.bookmarkCurrentWord()
			}
			.padding()
			
				.alert(isPresented: $viewModel.showAlert) {
					Alert(title: Text(viewModel.alertTitle),
						  message: Text("당신의 점수는 \(viewModel.score)점 입니다."),
						  primaryButton: .default(Text("다시하기"), action: {
						viewModel.resetGame()
						viewModel.userInput = ""
					}),
						  secondaryButton: .destructive(Text("그만하기"), action: {
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
