//
//  CountDownView'.swift
//  EngAttack
//
//  Created by Yachae on 5/2/24.
//

import SwiftUI

struct CountDownView: View {
	@Binding var isPresented: Bool
	@State private var timeLeft = 3
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	var body: some View {
		ZStack {
			Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
			Text("\(timeLeft)")
				.font(.system(size: 100, weight: .bold))
				.foregroundColor(.white)
				.onReceive(timer) { _ in
					if timeLeft > 0 {
						timeLeft -= 1
					} else {
						isPresented = false
					}
				}
		}
	}
}
