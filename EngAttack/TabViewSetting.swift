//
//  TabViewSetting.swift
//  EngAttack
//
//  Created by 홍준범 on 5/1/24.
//

import SwiftUI
import SwiftData

struct TabViewSetting: View {
    @State private var selection: String = "끝말잇기"
    
    var body: some View {
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
            GameView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("끝말잇기")
                }
                .tag("끝말잇기")
            MainView()
                .tabItem {
                    Image (systemName: "chart.bar.xaxis.ascending")
                    Text("랭킹")
                }
                .tag("랭킹")
            SettingView()
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
}
