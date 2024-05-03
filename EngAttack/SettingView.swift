//
//  SettingView.swift
//  EngAttack
//
//  Created by JIHYE SEOK on 4/30/24.
//

import SwiftUI
import AVKit
import FirebaseAuth

struct SettingView: View {
    @EnvironmentObject var viewModel: ContentViewViewModel
    @EnvironmentObject var setViewModel: SettingViewModel
    @EnvironmentObject var signViewModel : SignViewModel
    @State var settingsSound = false
    //@State var backVolume = 0.0
    let effectVol = 0.3
    
    var body: some View {
        VStack {
            // Title
            Text("설정")
                .font(.system(size: 25))
                .bold()
            Form {
                // MARK: 마이페이지
                Section(header: Text("마이페이지").font(.system(size: 18))) {
                    Button {
                        // TODO: 회원정보 수정 페이지 이동
                        print("mypage view")
                    } label: {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Text(signViewModel.uid)
                                .foregroundStyle(viewModel.isDarkMode ? .white : .black)
                                .padding(.leading, 5)
                                .fontWeight(.semibold)
                                .font(.system(size: 21))
                        }
                        .frame(height: 70)
                    }
                }
                // MARK: 환경 설정
                Section(header: Text("환경설정").font(.system(size: 18))) {
                    Toggle(isOn: $viewModel.isDarkMode) {
                        Text(viewModel.isDarkMode ? "라이트모드" : "다크모드")
                    }
                    DisclosureGroup("음향", isExpanded: $settingsSound) {
                        Toggle(isOn: $setViewModel.isEffect) {
                            Text(setViewModel.isEffect ? "효과음 OFF" : "효과음 ON")
                        }
                        HStack {
                            Text("배경음")
                                .padding(.trailing)
                            Spacer()
                            Slider(value: $setViewModel.backVol, in: 0...100, step: 1)
                                .onChange(of: setViewModel.backVol) {
                                    SoundSetting.instance.setVolume(Float(setViewModel.backVol) * 0.1)
                                }
                        }
                    }
                }
                Section {
                    Button {
                        Task {
                            do{
                                try signViewModel.signOut()
                                signViewModel.Signstate = .signedOut
                                return
                            }
                        }
                    } label: {
                        HStack {
                            Text("로그아웃")
                                .foregroundStyle(.red)
                                .padding(.leading, 5)
                                .font(.system(size: 21))
                        }
                        .frame(height: 25)
                    }
                }
            }
        }
        .font(.system(size: 20))
        
    }
}

#Preview {
    SettingView()
        .environmentObject(ContentViewViewModel())
        .environmentObject(SettingViewModel())
        .environmentObject(SignViewModel())
}
