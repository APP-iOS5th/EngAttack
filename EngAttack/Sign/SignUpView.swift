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
    @EnvironmentObject  var viewModels : SignViewModel
    @State private var  email = ""
    @State private var  password = ""
    @State private var isValidEmails: Bool = false
    @State private var isValidPasswords: Bool = false
    @State private var emailCheck: Bool = false
    @State private var isError: Bool = false
    @State private var SignIn = false
    @State private var messageString: String = ""
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack(spacing: 28) {
                    VStack(alignment: .leading, spacing: 11) {
                        Text("이메일")
                            .font(.system(size: 13, weight: .light))
                            .foregroundStyle(.secondary)
                            .frame(height: 15, alignment: .leading)
                        TextField("", text: $email)
                            .keyboardType(.emailAddress)
                            .font(.system(size: 17, weight: .thin))
                            .textInputAutocapitalization(.never)
                            .foregroundStyle(.primary)
                            .frame(height: 44)
                            .padding(.horizontal, 12)
                            .background(Color.white)
                            .cornerRadius(4.0)
                            .focused($focusedField, equals: .id)
                            .onSubmit { focusedField = .password }
                    }
                    VStack(alignment: .leading, spacing: 11) {
                        Text("비밀번호")
                            .font(.system(size: 13, weight: .light))
                            .foregroundStyle(.secondary)
                            .frame(height: 15, alignment: .leading)
                        
                        SecureField("", text: $password)
                            .font(.system(size: 17, weight: .thin))
                            .foregroundStyle(.primary)
                            .frame(height: 44)
                            .padding(.horizontal, 12)
                            .background(Color.white)
                            .cornerRadius(4.0)
                            .focused($focusedField, equals: .password)
                            .onSubmit { focusedField = nil }
                    }
                    VStack(alignment: .center, spacing: 20) {
                        Button {
                            Task {
                                do {
                                    viewModels.email = email
                                    viewModels.password = password
                                    try await viewModels.signUp()
                                    let db = Firestore.firestore()
                                    guard let userID = Auth.auth().currentUser?.uid else { return }
                                    try await db.collection("USER").document(userID).setData(["email": viewModels.email, "name": "비어있음"])
                                    SignIn.toggle()
                                    return
                                } catch {
                                    isValidEmails = isValidEmail(email: email)
                                    isValidPasswords = isValidPassword(pwd: password)
                                    emailCheck = emailCheck(email: email)
                                    
                                    if !isValidEmails || !isValidPasswords || !emailCheck {
                                        isError = true
                                        if !isValidEmails && isValidPasswords {
                                            messageString = "이메일 형식을 확인해주세요"
                                        }
                                        else if !isValidPasswords && isValidEmails  {
                                            messageString = "비밀번호가 대,소문자 8자리이상이 아닙니다"
                                        }
                                        else if !isValidEmails && !isValidPasswords  {
                                            messageString = "이메일,비밀번호를 확인해주세요"
                                        }
                                        else if !emailCheck {
                                            messageString = "이미가입된 이메일입니다."
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text("회원 가입")
                        }
                        .alert(isPresented: $isError) {
                            Alert(title: Text("경고"), message: Text(messageString), dismissButton: .default(Text("확인")))
                        }
                        Button("홈으로") {
                            SignIn.toggle()
                        }
                    }
                }
            }
                .padding()
        }.navigationBarBackButtonHidden(true)
        NavigationLink(destination: SignInView(), isActive: $SignIn){
            EmptyView()
        }
        
    }
    
    
    
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
