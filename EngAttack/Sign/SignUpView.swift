//
//  SignUpView.swift
//  EngAttack
//
//  Created by mosi on 5/1/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SignUpView: View {
    @StateObject  var signViewModel : SignViewModel
    @EnvironmentObject var contentViewModel: ContentViewViewModel
    @State private var  name = ""
    @State private var  email = ""
    @State private var  password = ""
    @State private var isValidEmails: Bool = false
    @State private var isValidPasswords: Bool = false
    @State private var emailCheck: Bool = false
    @State private var isError: Bool = false
    @Binding var isSignUpActive : Bool
    @State var  isAlertActive = false
    @State var  isDoneActive = false
    @State private var messageString: String = ""
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        NavigationStack {
            Form {
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
                
                Section(header: Text(contentViewModel.isKR ? "Password" : "패스워드")
                    .font(.system(size: 15))
                    .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                    .bold()) {
                        SecureField("", text: $password)
                            .font(.system(size: 17))
                            .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                            .focused($focusedField, equals: .password)
                            .onSubmit { focusedField = nil }
                    }
                Section {
                    Button {
                        Task {
                            do {
                                try await signViewModel .signUp(email: email, password: password)
                                let db = Firestore.firestore()
                                guard let userID = Auth.auth().currentUser?.uid else { return }
                                try await db.collection("USER").document(userID).setData(["email": email, "name": name])
                                try await db.collection("BookMark").document(userID).setData(["List": FieldValue.arrayUnion([["word":"", "description" : ""]])])
                                try await db.collection("Rank").document(userID).setData(["List": FieldValue.arrayUnion([["name":name, "score": 0]])])
                                isAlertActive.toggle()
                                isDoneActive.toggle()
                                messageString = contentViewModel.isKR ? "Sign up is correct" : "회원가입이 완료되었습니다."
                                return
                            } catch {
                                isValidEmails = isValidEmail(email: email)
                                isValidPasswords = isValidPassword(pwd: password)
                                emailCheck = emailCheck(email: email)
                                
                                if !isValidEmails || !isValidPasswords || !emailCheck  {
                                    if !isValidEmails && isValidPasswords   {
                                        messageString = contentViewModel.isKR ? "Please check the email form" : "이메일 양식을 확인해주세요"
                                    }
                                    else if !isValidPasswords && isValidEmails   {
                                        messageString = contentViewModel.isKR ? "The password must be at least 8 uppercase characters long" : "패스워드는 대소문자 8자리 이상이어야 합니다"
                                    }
                                    else if !isValidEmails && !isValidPasswords {
                                        messageString = contentViewModel.isKR ? "Please check the e-mail form and password of 8 characters or more" : "이메일양식, 패스워드8자 이상을 확인해주세요"
                                    }
                                    else if !emailCheck {
                                        messageString = contentViewModel.isKR ? "This Email is already sign up" : "이미 가입된 이메일 입니다"
                                    }
                                    isAlertActive.toggle()
                                    isError.toggle()
                                }
                            }
                        }
                    } label: {
                        Text(contentViewModel.isKR ? "Sign up" : "회원가입")
                            .frame(width: 100, height: 35)
                        
                    }
                    .alert(isPresented: $isAlertActive) {
                        Alert(title: Text(contentViewModel.isKR ? "Notification" : "알림"), message: Text(messageString), dismissButton: .default(Text(contentViewModel.isKR ? "Done" : "확인"), action: {
                            if isDoneActive {
                                isSignUpActive.toggle()
                                isAlertActive = false
                                isDoneActive  = false
                            }
                            else {
                                isAlertActive = false
                                isError = false
                            }
                        }))
                    }
                    .disabled(name.isEmpty)
                    .padding(.horizontal, 100)
                    .buttonStyle(.borderedProminent)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle(contentViewModel.isKR ? "Sign up" : "회원가입")
            .navigationBarTitleDisplayMode(.inline)
            
            
        }
    }
}


extension SignUpView {
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
    
    //이메일 중복가입 여부확인
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
