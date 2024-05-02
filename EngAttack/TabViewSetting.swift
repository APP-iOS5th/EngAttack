//
//  TabViewSetting.swift
//  EngAttack
//
//  Created by 홍준범 on 5/1/24.
//

import SwiftUI

struct TabViewSetting: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image (systemName: "chart.bar.xaxis.ascending")
                    Text("Main")
                }
            GameView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Game")
                }
            Text("Dictionary page")
                .tabItem {
                    Image(systemName: "character.book.closed.fill")
                    Text("Dict")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("MY")
                }
        }
    }
}

#Preview {
    TabViewSetting()
}
