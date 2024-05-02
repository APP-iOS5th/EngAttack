//
//  HomeView.swift
//  EngAttack
//
//  Created by mosi on 5/1/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel : SignViewModel
    var body: some View {
        VStack{
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut() 
                        viewModel.Signstate = .signedOut
                    } catch {
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
