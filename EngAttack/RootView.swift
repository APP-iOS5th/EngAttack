//
//  ContentView.swift
//  EngAttack
//
//  Created by JIHYE SEOK on 4/30/24.
//


import SwiftUI
import FirebaseCore
import FirebaseAuth

struct RootView: View {
    @StateObject var viewModel : SignViewModel = SignViewModel()
    var body: some View {
        VStack {
            if viewModel.Signstate == .signedIn {
                TabViewSetting(signViewModel: viewModel)
                    .environmentObject(ContentViewViewModel())
                    .environmentObject(SettingViewModel())
                    .modelContainer(for: TempModel.self)
            } else {
                SignInView(signViewModel: viewModel)
                    .environmentObject(ContentViewViewModel())
            }
        }
        .onAppear {
            if viewModel.currentUser != nil  {
                viewModel.Signstate = .signedIn
                print("테스트")
            }
        }
    }
    
}
