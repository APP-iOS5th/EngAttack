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
    @EnvironmentObject var contentsViewModel: ContentViewViewModel
    @EnvironmentObject var setViewModel: SettingViewModel
    @StateObject var signViewModel : SignViewModel = SignViewModel()
    @State var settingsSound = false
    @State var isprofileLoad = false
    //@State var backVolume = 0.0
    let effectVol = 0.3
    
    var body: some View {
        VStack {
            // Title
            Text(contentsViewModel.isKR ? "Setting" : "설정")
                .font(.system(size: 25))
                .bold()
            Form {
                // MARK: 마이페이지
                Section(header: Text(contentsViewModel.isKR ? "Mypage" : "마이 페이지").font(.system(size: 18))) {
                    Button {
                        self.isprofileLoad = true
                    } label: {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Text(signViewModel.name)
                                .foregroundStyle(contentsViewModel.isDarkMode ? .white : .black)
                                .padding(.leading, 5)
                                .fontWeight(.semibold)
                                .font(.system(size: 21))
                        }
                        .frame(height: 70)
                        .sheet(isPresented: $isprofileLoad) {
                            ProfileSettingView(isprofileLoad: $isprofileLoad)
                        }
                    }
                }
                // MARK: 환경 설정
                Section(header: Text(contentsViewModel.isKR ? "Preferences" : "환경설정").font(.system(size: 18))) {
                    Toggle(isOn: $contentsViewModel.isKR) {
                        Text(contentsViewModel.isKR ? "English" : "한글")
                    }
                    Toggle(isOn: $contentsViewModel.isDarkMode) {
                        if contentsViewModel.isKR  {
                            Text(contentsViewModel.isDarkMode ? "Dark" : "White" )
                        }
                        else {
                            Text(contentsViewModel.isDarkMode ? "다크모드" : "화이트모드")
                        }
                    }
                    DisclosureGroup(contentsViewModel.isKR ? "Sound" : "음향", isExpanded: $settingsSound) {
                        Toggle(isOn: $setViewModel.isEffect) {
                            if contentsViewModel.isKR  {
                                Text(setViewModel.isEffect ? "Effect OFF" : "Effect ON")
                            }
                            else {
                                Text(setViewModel.isEffect ? "효과음 OFF" : "효과음 ON")
                            }
                        }
                        HStack {
                            Text(contentsViewModel.isKR ? "Background" : "배경음")
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
                                try await signViewModel.signOut()
                                signViewModel.Signstate = .signedOut
                                signViewModel.uid = ""
                                signViewModel.name = ""
                                print(signViewModel.Signstate)
                                return
                            } catch let error {
                                print(error)
                            }
                        }
                    } label: {
                        HStack {
                            Text(contentsViewModel.isKR ? "Logout" : "로그아웃")
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
}
