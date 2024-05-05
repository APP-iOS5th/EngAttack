//
//  SignInView.swift
//  EngAttack
//
//  Created by mosi on 5/1/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct SignInView: View {
    @EnvironmentObject var contentViewModel: ContentViewViewModel
    
    @StateObject  var signViewModel : SignViewModel
    @EnvironmentObject var setViewModel: SettingViewModel
    @State private var correctLogin = false
    @State private var email = ""
    @State private var password = ""
    @State private var loginActive = false
    @State private var isSignUpActive = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            Form {
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
                            .textInputAutocapitalization(.never)
                            .font(.system(size: 17))
                            .foregroundStyle(contentViewModel.isDarkMode ? .white : .black)
                            .focused($focusedField, equals: .password)
                            .onSubmit { focusedField = nil }
                }
                
                Section {
                    Button {
                        Task {
                            do {
                                try await signViewModel.signIn(email: email, password: password)
                                guard let userID = Auth.auth().currentUser?.uid else { return }
                                signViewModel.uid = userID
                                signViewModel.email = email
                                signViewModel.password = password
                                signViewModel.Signstate = .signedIn
                                loadName(userID: userID)
                                loginActive = true
                                    return
                            } catch {
                                correctLogin = true
                            }
                        }
                    } label: {
                        Text(contentViewModel.isKR ? "Login" : "로그인")
                            .frame(width: 100, height: 35)
                    }
                    .alert(isPresented: $correctLogin) {
                        Alert(title: Text(contentViewModel.isKR ? "Error" : "에러"), message: Text(contentViewModel.isKR ? "Email or Password not correct!" : "이메일 또는 비밀번호가 맞지않습니다."), dismissButton: .default(Text(contentViewModel.isKR ? "Done" : "확인")))
                    }
                    .disabled( !isValidEmail(email:email) )
                    .padding(.horizontal, 100)
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        self.isSignUpActive = true
                    } label: {
                        Text(contentViewModel.isKR ? "Sign Up" : "회원 가입")
                    }
                    .sheet(isPresented: $isSignUpActive) {
                        SignUpView(signViewModel: signViewModel, isSignUpActive: $isSignUpActive)
                    }
                    .padding(.leading, 120)
                }
                .listRowBackground(Color.clear)
                
            }
            .navigationTitle(contentViewModel.isKR ? "Login" : "로그인")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .preferredColorScheme(contentViewModel.isDarkMode ? .dark : .light)
        }
        NavigationLink(destination: TabViewSetting(signViewModel: signViewModel)
            .environmentObject(SettingViewModel())
            .environmentObject(ContentViewViewModel())
            , isActive: $loginActive) {
                EmptyView()
            }
    }
}

extension SignInView {
    
    //아이디 형식검사
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func loadName(userID :String)   {
         var names = ""
         let db = Firestore.firestore()
         db.collection("USER").document(userID).getDocument { (doc, error) in
             guard error == nil else {
                 print("error", error ?? "")
                 return
             }
             if let doc = doc, doc.exists {
                 let data = doc.data()
                 if let data = data {
                     let name = data["name"] as? String ?? ""
                     if signViewModel.name == "" {
                         signViewModel.name = name
                         return
                     }
                     
                 }
             }
         }
         
     }
}
