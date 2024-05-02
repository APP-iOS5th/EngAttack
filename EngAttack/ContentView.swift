//
//  ContentView.swift
//  WordChainApp
//
//  Created by Yachae on 4/28/24.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var viewModel: ContentViewViewModel
	@Binding var timeRemaining: Double
	
	
	var body: some View {
		NavigationStack {
			VStack {
				Text("남은 시간: \(String(format: "%.1f", viewModel.timeRemaining))초")
					.font(.title)
					.padding()
				// 타이머 바
				ProgressView(value: max(0, min(viewModel.timeRemaining, 60.0)), total: timeRemaining)
					.padding()
				
				Text(viewModel.currentWord)
					.padding()
				
				// 입력창
				TextField("Enter next word", text: $viewModel.userInput, onCommit: { viewModel.submitButton()
					viewModel.timeRemaining = timeRemaining})
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding()
				
				// 북마크 버튼
				Button("북마크하기") {
					viewModel.bookmarkCurrentWord()
				}
				.padding()
				
				Text("Score: \(viewModel.score)")
				
				// 북마크 가기
				NavigationLink(destination: BookmarksView(viewModel: viewModel)) {
					Text("북마크 보기")
				}
				.padding()
				
				// 게임 종료시 알림창
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
			}
			.onDisappear {
				viewModel.stopTimer()
			}
		}
	}
	
	
}


#Preview {
	ContentView(timeRemaining: .constant(5))
		.environmentObject(ContentViewViewModel())
}
