//
//  SettingView.swift
//  EngAttack
//
//  Created by JIHYE SEOK on 4/30/24.
//

import SwiftUI

struct SettingView: View {
    @State var isDarkMode = false
    //@ObservedObject var viewModel = ContentViewViewModel()
    
    var body: some View {
        VStack {
            Text("설정")
                .font(.largeTitle)
                .bold()
            HStack {
                // Text("다크모드/화이트모드")
                Toggle(isOn: $isDarkMode) {
                    
                    Text(isDarkMode ? "라이트모드" : "다크모드")
                        .foregroundColor(isDarkMode ? .white : .black)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                        .font(.system(size: 20))
                        .bold()
                }
                .padding()
            }
        }
    }
}

#Preview {
    SettingView()
}
