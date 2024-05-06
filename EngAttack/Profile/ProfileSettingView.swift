//
//  ProfileSettingView.swift
//  EngAttack
//
//  Created by mosi on 5/4/24.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct ProfileSettingView: View {
    @EnvironmentObject var contentViewModel : ContentViewViewModel
    @StateObject var signViewModel : SignViewModel
    @StateObject var profileViewModel = ProfileViewModel()
    @State var showImagePicker = false
    @State var selectedUIImage: PhotosPickerItem? = nil
    @State var image: UIImage?
    @Binding var url : URL?
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
                        if let url {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 100, height: 100)
                                        .padding(.leading ,100)
                                }
                                else if phase.error != nil{
                                    ProgressView()
                                        .padding(.leading, 200)
                                        .frame(width: 100, height: 100)
                                } else {
                                    ProgressView()
                                        .padding(.leading, 200)
                                        .frame(width: 100, height: 100)
                                }
                            }
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width: 100, height: 100)
                                .padding(.leading ,100)
                        }
                    }
                    .onChange(of: selectedUIImage, perform: { newValue in
                        if let newValue {
                            profileViewModel.saveProfileImage(item: selectedUIImage!, email: email, names: name)
                        }
                        
                    })
                    .task{
                        do {
                            try await profileViewModel.loadCurrentUser()
                            let path = "\(signViewModel.uid).jpeg"
                            let urls = try await StorageManager.shared.getUrlForImage(path:path)
                            self.url = urls
                        } catch let error {
                            print(error)
                        }
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
                            .onSubmit { focusedField = .password }
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
                                let db = Firestore.firestore()
                                try await db.collection("USER").document(signViewModel.uid).updateData(["name" : name])
                                messageString = contentViewModel.isKR ? "\(signViewModel.name)s information has been update. please sign in again" : "\(signViewModel.name)의 정보가 변경되었습니다. 다시 로그인 해주세요."
                                signViewModel.uid = ""
                                signViewModel.email = ""
                                signViewModel.name = ""
                                try await signViewModel.signOut()
                                signViewModel.Signstate = .signedOut
                                return
                            } catch {
                                isValidPasswords = isValidPassword(pwd: password)
                                if !isValidPasswords   {
                                    messageString = contentViewModel.isKR ? "The password must be at least 8 uppercase characters long" : "패스워드는 대소문자 8자리 이상이어야 합니다"
                                }
                                    messageString = contentViewModel.isKR ? "An unknown error occurred. Please try again." : "알수 없는 오류가 발생했습니다. 다시 시도해주세요."
                                
                                isAlert = true
                                isError = true
                            }
                        }
                    }label: {
                        Text(contentViewModel.isKR ? "Update" : "수정하기")
                            .frame(width: 150, height: 35)
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



