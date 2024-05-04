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
    @StateObject var signViewModel : SignViewModel = SignViewModel()
    var body: some View {
        VStack {
            if signViewModel.Signstate == .signedIn {
                TabViewSetting(signViewModel: signViewModel)
                    .environmentObject(ContentViewViewModel())
                    .environmentObject(SettingViewModel())
                    .modelContainer(for: TempModel.self)
            } else {
                SignInView(signViewModel: signViewModel)
                    .environmentObject(ContentViewViewModel())
            }
        }
        .onAppear {
            if signViewModel.currentUser != nil && signViewModel.uid != "" {
                signViewModel.Signstate = .signedIn
                print("테스트")
            }
        }
    }
    
}
