//
//  ProfileSettingView.swift
//  EngAttack
//
//  Created by mosi on 5/4/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileSettingView: View {
    @EnvironmentObject var contentViewModel : ContentViewViewModel
    @StateObject var signViewModel : SignViewModel
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?
    @FocusState private var focusedField: Field?
    @Binding  var name :  String
    @Binding  var email : String
    @State private var messageString: String = ""
    @State private var password : String = ""
    @State private var isValidEmails: Bool = false
    @State private var isValidPasswords: Bool = false
    @State private var emailCheck: Bool = false
    @State private var isError: Bool = false
    @Binding  var isUpdateDone : Bool
    @State  var isAlert : Bool = false
    @State  var isDone : Bool = false
 
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
                        Text(name)
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
                        Text(email)
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
                            if contentViewModel.isKR  {
                                Text("Show password")
                                    .frame(width: 180, height: 35)
                                    .foregroundStyle(.primary)
                            } else {
                                Text("비밀번호 보기")
                                    .frame(width: 150, height: 35)
                                    .foregroundStyle(.primary)
                            }
                        }
                        else {
                            if contentViewModel.isKR  {
                                Text("Hide password")
                                    .frame(width: 180, height: 35)
                                    .foregroundStyle(.primary)
                            } else {
                                Text("비밀번호 가리기")
                                    .frame(width: 150, height: 35)
                                    .foregroundStyle(.primary)
                            }
                            
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
                    } label: {
                        if contentViewModel.isKR  {
                            Text("Password Change")
                                .frame(width: 180, height: 35)
                        } else {
                            Text("비밀번호 변경하기")
                            .frame(width: 150, height: 35)
                        }
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
    
    //아이디 형식검사
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    //비밀번호 형식 검사 -> 소문자, 대문자, 숫자 8자리 이상
    func isValidPassword(pwd: String) -> Bool {
        let passwordRegex = "^[a-zA-Z0-9]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: pwd)
    }
    
    func emailCheck(email: String) -> Bool {
        var result = false
        
        let userDB = Firestore.firestore().collection("USER")
        let query  =  userDB.whereField("email", isEqualTo: email)
        query.getDocuments() { (qs, err) in
            if qs!.documents.isEmpty {
                result = true
            } else {
                result = false
            }
        }
        return result
    }
}

