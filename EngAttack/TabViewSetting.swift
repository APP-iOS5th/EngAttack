//
//  TabViewSetting.swift
//  EngAttack
//
//  Created by 홍준범 on 5/1/24.
//

import SwiftUI
import SwiftData

struct TabViewSetting: View {
    @StateObject var signViewModel: SignViewModel = SignViewModel()
	@State private var selection: String = "끝말잇기"
	
	var body: some View {
		VStack {
			if viewModel.isLoading {
                ContentView(timeRemaining: .constant(30)).launchScreenView
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
							withAnimation {
								viewModel.isLoading = false
							}
						}
					}
			} else if !viewModel.gameStarted {
				NavigationStack {
					GameStartView()
						.onAppear {
							withAnimation {
								viewModel.gameStarted = true
							}
						}
				}
			} else {
				mainTabView
			}
		}
        .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
    }
	
	var mainTabView: some View {
		TabView(selection: $selection) {
			WordBookmarkView()
				.tabItem {
					Image(systemName: "bookmark.fill")
					Text("북마크")
				}
				.tag("북마크")
				.modelContainer(for: TempModel.self)
			WordDictionaryView()
				.tabItem {
					Image(systemName: "character.book.closed.fill")
					Text("사전")
				}
				.tag("사전")
				.modelContainer(for: TempModel.self)
			GameStartView(signViewModel: signViewModel)
				.tabItem {
					Image(systemName: "gamecontroller")
					Text("끝말잇기")
				}
				.tag("끝말잇기")
			RankingView()
				.tabItem {
					Image (systemName: "chart.bar.xaxis.ascending")
					Text("랭킹")
				}
				.tag("랭킹")
            SettingView(signViewModel: signViewModel)
            
				.tabItem {
					Image(systemName: "person.crop.circle.fill")
					Text("마이페이지")
				}
				.tag("마이페이지")
		}
	}
}


#Preview {
	TabViewSetting()
		.environmentObject(ContentViewViewModel())
        .environmentObject(SettingViewModel())
}
