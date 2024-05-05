//
//  SettingView.swift
//  EngAttack
//
//  Created by JIHYE SEOK on 4/30/24.
//

import SwiftUI
import AVKit
import FirebaseAuth
import FirebaseFirestore

struct SettingView: View {
    @EnvironmentObject var contentsViewModel: ContentViewViewModel
    @EnvironmentObject var setViewModel: SettingViewModel
    @StateObject var signViewModel : SignViewModel = SignViewModel()
    @State var settingsSound = false
    @State var isUpdateDone = false
    @State var isUnregister = false
    @State var isSignOut = false
    @State var name  = ""
    @State var email = ""
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
                Section(header: Text(contentsViewModel.isKR ? "Mypage" : "마이페이지").font(.system(size: 18))) {
                    Button {
                        name = signViewModel.name
                        email = signViewModel.email
                        self.isUpdateDone = true
                    } label: {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Text(signViewModel.name)
                                .foregroundStyle(contentsViewModel.isDarkMode ? .white : .black)
                                .padding(.leading, 20)
                                .fontWeight(.semibold)
                                .font(.system(size: 25))
                            
                        }
                        .frame(height: 70)
                        .sheet(isPresented: $isUpdateDone) {
                            ProfileSettingView(signViewModel: SignViewModel(), name:$name, email: $email, isUpdateDone: $isUpdateDone)
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
                        isUnregister.toggle()
                    } label: {
                        HStack {
                            Text(contentsViewModel.isKR ? "Unregister" : "회원탈퇴")
                                .foregroundStyle(.red)
                                .padding(.leading, 5)
                                .font(.system(size: 21))
                        }
                        .frame(height: 25)
                    }
                    .alert(isPresented: $isUnregister) {
                        Alert(title: Text(contentsViewModel.isKR ? "Warning" : "경고"),
                              message: Text(contentsViewModel.isKR ? "Do you really want to cancel your membership?" : "정말로 회원탈퇴 하시겠습니까?"),
                              primaryButton: .default(Text(contentsViewModel.isKR ?  "Cancel" : "취소하기"), action: {
                            isUnregister = false
                        }),
                              secondaryButton: .destructive(Text(contentsViewModel.isKR ?  "Delete" : "삭제"), action: {
                            Task {
                                let db = Firestore.firestore()
                                guard let userID = Auth.auth().currentUser?.uid else { return }
                                try await signViewModel.deleteUser()
                                try await db.collection("USER").document(userID).delete()
                                try await db.collection("Rank").document(userID).delete()
                                try await db.collection("BookMark").document(userID).delete()
                                signViewModel.uid = ""
                                signViewModel.name = ""
                                signViewModel.email = ""
                                signViewModel.Signstate = .signedOut
                            }
                        }))
                    }
                    Button {
                        isSignOut = true
                    } label: {
                        HStack {
                            Text(contentsViewModel.isKR ? "Logout" : "로그아웃")
                                .foregroundStyle(.red)
                                .padding(.leading, 5)
                                .font(.system(size: 21))
                        }
                        .alert(isPresented: $isSignOut) {
                            Alert(title: Text(contentsViewModel.isKR ? "Warning" : "경고"),
                                  message: Text(contentsViewModel.isKR ? "Do you want really sign out?" : "정말로 로그아웃 하시겠습니까?"),
                                  primaryButton: .default(Text(contentsViewModel.isKR ?  "Cancel" : "취소하기"), action: {
                                isSignOut = false
                            }),
                                  secondaryButton: .destructive(Text(contentsViewModel.isKR ?  "Done" : "확인"), action: {
                                Task {
                                    do{
                                        try await signViewModel.signOut()
                                        signViewModel.Signstate = .signedOut
                                        signViewModel.uid = ""
                                        signViewModel.email = ""
                                        signViewModel.name = ""
                                        return
                                    } catch let error {
                                        print(error)
                                    }
                                }
                            }))
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
