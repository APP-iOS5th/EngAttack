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
			VStack {
                Text("\(setViewModel.backVol)")
				Text("남은 시간: \(String(format: "%.1f", viewModel.timeRemaining))초")
					.font(.title)
					.padding()
				
                ProgressView(value: max(0, min(viewModel.timeRemaining, 60.0)), total: timeRemaining)
					.padding()
				
				Text(viewModel.currentWord)
					.padding()
				
				TextField("Enter next word", text: $viewModel.userInput, onCommit: { viewModel.submitButton()
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
				.padding()
				
				Button("북마크하기") {
					viewModel.bookmarkCurrentWord()
				}
				.padding()
				
				Text("Score: \(viewModel.score)")
				
				NavigationLink(destination: BookmarksView(viewModel: viewModel)) {
					Text("북마크 보기")
				}
				.padding()
				
				.alert(isPresented: $viewModel.showAlert) {
					Alert(title: Text("Game Over"),
						 message: Text("당신의 점수는 \(viewModel.score)점 입니다."),
						 primaryButton: .default(Text("다시하기"), action: {
						viewModel.resetGame()
					}),
						 secondaryButton: .destructive(Text("그만하기"), action: {
						viewModel.resetGame()
						viewModel.stopTimer()
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
				viewModel.stopTimer()
			}
		}
	}
}


#Preview {
    ContentView(timeRemaining: .constant(30))
		.environmentObject(ContentViewViewModel())
        .environmentObject(SettingViewModel())
}
