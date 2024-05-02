//
//  ContentView.swift
//  WordChainApp
//
//  Created by Yachae on 4/28/24.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var viewModel: ContentViewViewModel
	
	var body: some View {
		Group {
			// Launch Screen
			if viewModel.isLoading {
				launchScreenView
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
							viewModel.isLoading.toggle()
						})
					}
				
			} else if !viewModel.gameStarted {
				NavigationStack {
					VStack {
						Button(action: {
							viewModel.startGame()
						}, label: {
							Text("게임 시작")
						})
					}
					.navigationTitle("끝말잇기 게임")
					.toolbar {
						ToolbarItem(placement: .topBarTrailing) {
							NavigationLink(destination: SettingView()) {
								Image(systemName: "gearshape.fill")
							}
						}
					}
				}
			} else {
				NavigationView {
					VStack {
						Text("남은 시간: \(String(format: "%.1f", viewModel.timeRemaining))초")
							.font(.title)
							.padding()
						
						ProgressView(value: max(0, min(viewModel.timeRemaining, 10.0)), total: 10.0)
							.padding()
						
						Text(viewModel.currentWord)
							.padding()
						
						TextField("Enter next word", text: $viewModel.userInput, onCommit: { viewModel.submitButton()
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
						viewModel.startTimer()
					}
					.onDisappear {
						viewModel.stopTimer()
					}
				}
			}
		}
		// 다크모드전환상태 유지
		.preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
	}
}

#Preview {
	ContentView()
		.environmentObject(ContentViewViewModel())
}
