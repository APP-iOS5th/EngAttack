//
//  Launch Screen.swift
//  EngAttack
//
//  Created by Yachae on 5/1/24.
//

import SwiftUI

extension ContentView {
	var launchScreenView: some View {
		ZStack(alignment: .center) {
			LinearGradient(gradient: Gradient(colors: [Color("FirstColor"), Color(.white)]),
						   startPoint: .top, endPoint: .bottom)
			.edgesIgnoringSafeArea(.all)
			
			VStack(){
				Image(systemName: "gamecontroller")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 150)
					.foregroundStyle(.gameController)
					.offset(y:-100)
				Text("EngAttack")
                    .font(.custom("SOYO Maple Bold", size: 60))
                    .foregroundStyle(.brown)
					.font(.largeTitle)
					.bold()
                    .padding(.bottom, 30)
			}
		}
	}
}


//#Preview {
//	ContentView().launchScreenView
//}
