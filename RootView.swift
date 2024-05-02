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
    @EnvironmentObject var viewModel : SignViewModel
    var body: some View {
        VStack {
            if viewModel.Signstate == .signedIn {
                HomeView()
            } else {
                SignInView()
            }
        }
        .onAppear {
            if viewModel.currentUser != nil  {
                viewModel.Signstate = .signedIn
            }
        }
    }
    
}
