//
//  EngAttackApp.swift
//  EngAttack
//
//  Created by JIHYE SEOK on 4/30/24.
//

import SwiftUI

@main
struct EngAttackApp: App {

    var body: some Scene {
        WindowGroup {
		   TabViewSetting()
			   .environmentObject(ContentViewViewModel())
               .environmentObject(SettingViewModel())
        }
    }
}
