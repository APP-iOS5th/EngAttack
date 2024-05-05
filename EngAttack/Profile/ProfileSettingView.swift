//
//  ProfileSettingView.swift
//  EngAttack
//
//  Created by mosi on 5/4/24.
//

import SwiftUI
import PhotosUI

struct ProfileSettingView: View {
    @EnvironmentObject var contentViewModel : ContentViewViewModel
    @StateObject var signViewModel : SignViewModel
    @StateObject var profileViewModel = ProfileViewModel()
    @State var showImagePicker = false
    @State var selectedUIImage: PhotosPickerItem? = nil
    @State var image: Data?
    @FocusState private var focusedField: Field?
    @Binding  var name : String
    @Binding  var email : String
    @State private var messageString: String = ""
    @State private var password : String = ""
    @State private var pwdisShowing = false
    @State private var isValidPasswords: Bool = false
    @State private var isError: Bool = false
    @Binding  var isUpdateDone : Bool
    @State  var isAlert : Bool = false
    @State  var isDone : Bool = false
   
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotosPicker(selection:$selectedUIImage, matching: .images, photoLibrary: .shared()) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 100, height: 100)
                        
                    }
                    .padding(.leading ,100)
                    .onChange(of: selectedUIImage, perform: { newValue in
                        if let newValue {
                            profileViewModel.saveProfileImage(item:newValue)
                        }
                    })
                }
                Section(header: Text(contentViewModel.isKR ? "Name" : "이름")
                    .font(.system(size: 15))
                    .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                    .bold()) {
                        Text(name)
                            .font(.system(size: 17))
                            .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                    }
                Section(header: Text(contentViewModel.isKR ? "Email" : "이메일")
                    .font(.system(size: 15))
                    .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                    .bold()) {
                        Text(email)
                            .font(.system(size: 17))
                            .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                    }
                
                Section(header: Text(contentViewModel.isKR ? "Password" : "비밀번호")
                    .font(.system(size: 15))
                    .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                    .bold()) {
                        if pwdisShowing {
                            SecureField("", text: $password)
                                .font(.system(size: 17))
                                .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                                .focused($focusedField, equals: .password)
                                .onSubmit { focusedField = nil }
                        } else {
                            TextField("", text: $password)
                                .font(.system(size: 17))
                                .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                                .focused($focusedField, equals: .password)
                                .onSubmit { focusedField = nil }
                        }
                    }
                Section {
                    Button {
                        pwdisShowing.toggle()
                    } label: {
                        if pwdisShowing  {
                            Text(contentViewModel.isKR ? "Show password" : "패스워드 보기" )
                                .frame(width: 150, height: 35)
                                .foregroundStyle(.primary)
                        }
                        else {
                            Text(contentViewModel.isKR ? "Hide password" : "패스워드 가리기")
                                .frame(width: 150, height: 35)
                                .foregroundStyle(.primary)
                        }
                        
                    }
                    .accentColor(pwdisShowing ? .blue : .gray)
                    .padding(.horizontal, 100)
                    .buttonStyle(.borderedProminent)
                    Button {
                        Task {
                            do {
                                try await signViewModel.updatePassword(password: password)
                                isAlert = true
                                isDone = true
                                messageString = contentViewModel.isKR ? "Your password change has been completed" : "비밀번호 변경이 완료되었습니다."
                                return
                            } catch {
                                isValidPasswords = isValidPassword(pwd: password)
                                if !isValidPasswords   {
                                    isAlert = true
                                    isError = true
                                    messageString = contentViewModel.isKR ? "The password must be at least 8 uppercase characters long" : "패스워드는 대소문자 8자리 이상이어야 합니다"
                                }
                            }
                        }
                    }label: {
                        Text(contentViewModel.isKR ? "Update" : "수정하기")
                            .frame(width: 100, height: 35)
                    }
                    .alert(isPresented: $isAlert) {
                        Alert(title: Text(contentViewModel.isKR ? "Notification" : "알림"), message: Text(messageString), dismissButton: .default(Text(contentViewModel.isKR ? "Done" : "확인"), action: {
                            if isError  {
                                isAlert = false
                                isError = false
                                isDone  = false
                            }
                            else if isDone {
                                isUpdateDone = false
                            }
                        }))
                    }

                    .disabled(name.isEmpty)
                    .padding(.horizontal, 100)
                    .buttonStyle(.borderedProminent)
                }
                .listRowBackground(Color.clear)
            }
        }
    }
    
}

extension ProfileSettingView {
    
    //비밀번호 형식 검사 -> 소문자, 대문자, 숫자 8자리 이상
    func isValidPassword(pwd: String) -> Bool {
        let passwordRegex = "^[a-zA-Z0-9]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: pwd)
    }
}



