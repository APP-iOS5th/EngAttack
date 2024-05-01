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
			LinearGradient(gradient: Gradient(colors: [Color("PrimaryColor"), Color("SubPrimaryColor")]),
						   startPoint: .top, endPoint: .bottom)
			.edgesIgnoringSafeArea(.all)
			
			VStack(){
				Image(systemName: "gamecontroller")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 100)
					.foregroundStyle(.gameController)
					.offset(y:-100)
				Text("EngAttack")
					.font(.largeTitle)
					.bold()
			}
		}
	}
}


#Preview {
	ContentView().launchScreenView
}
