//
//  EngAttackApp.swift
//  EngAttack
//
//  Created by JIHYE SEOK on 4/30/24.
//

import SwiftUI

@main
struct EngAttackApp: App {
	
	var viewModel = ContentViewViewModel()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(viewModel)
		}
	}
}
