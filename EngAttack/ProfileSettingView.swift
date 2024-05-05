//
//  ProfileSettingView.swift
//  EngAttack
//
//  Created by mosi on 5/4/24.
//

import SwiftUI

struct ProfileSettingView: View {
    @EnvironmentObject var contentViewModel : ContentViewViewModel
    @StateObject var signViewModel : SignViewModel
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?
    @FocusState private var focusedField: Field?
    @Binding var isprofileLoad : Bool
    @Binding  var name :  String
    @Binding  var email : String
    @State private var password : String = ""
    @State private var pwdisShowing = false
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button {
                        showImagePicker.toggle()
                    } label: {
                        if let image = image {
                            image
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width: 100, height: 100)
                        }
                        
                        
                        
                    }
                    .listRowBackground(Color.clear)
                    .padding(.horizontal, 100)
                    .sheet(isPresented: $showImagePicker, onDismiss: {
                        loadImage()
                    }) {
                        ImagePicker(image: $selectedUIImage)
                    }
                }
                Section(header: Text(contentViewModel.isKR ? "Name" : "이름")
                    .font(.system(size: 15))
                    .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                    .bold()) {
                        TextField("", text: $name)
                            .keyboardType(.emailAddress)
                            .font(.system(size: 17))
                            .textInputAutocapitalization(.never)
                            .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                            .focused($focusedField, equals: .name)
                            .onSubmit { focusedField = .id }
                    }
                
                Section(header: Text(contentViewModel.isKR ? "Email" : "이메일")
                    .font(.system(size: 15))
                    .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                    .bold()) {
                        TextField("", text: $email)
                            .keyboardType(.emailAddress)
                            .font(.system(size: 17))
                            .textInputAutocapitalization(.never)
                            .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                            .focused($focusedField, equals: .id)
                            .onSubmit { focusedField = .password }
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
                        
                        
                    } label: {
                        Text(contentViewModel.isKR ? "Submit" : "변경하기")
                            .frame(width: 100, height: 35)
                        
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



