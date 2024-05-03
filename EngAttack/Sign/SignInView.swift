//
//  SignInView.swift
//  EngAttack
//
//  Created by mosi on 5/1/24.
//

import SwiftUI
import FirebaseAuth


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
                Section(header: Text("아이디")
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    .bold()) {
                        TextField("", text: $email)
                            .keyboardType(.emailAddress)
                            .font(.system(size: 17))
                            .textInputAutocapitalization(.never)
                            .foregroundStyle(.black)
                            .focused($focusedField, equals: .id)
                            .onSubmit { focusedField = .password }
                }
                
                Section(header: Text("패스워드")
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    .bold()) {
                        SecureField("", text: $password)
                            .textInputAutocapitalization(.never)
                            .font(.system(size: 17))
                            .foregroundStyle(.black)
                            .focused($focusedField, equals: .password)
                            .onSubmit { focusedField = nil }
                }
                
                Section {
                    Button {
                        Task {
                            do {
                                signViewModel.email = email
                                signViewModel.password = password
                                try await signViewModel.signIn()
                                guard let userID = Auth.auth().currentUser?.uid else { return }
                                signViewModel.uid = userID
                                signViewModel.Signstate = .signedIn
                                loginActive = true
                                    return
                            } catch {
                                correctLogin = true
                            }
                        }
                    } label: {
                        Text("로그인")
                            .frame(width: 100, height: 35)
                    }
                    .alert(isPresented: $correctLogin) {
                        Alert(title: Text("주의"), message: Text("이메일 또는 비밀번호가 맞지않습니다."), dismissButton: .default(Text("확인")))
                    }
                    .disabled( !checkEmailForm(email:email) )
                    .padding(.horizontal, 100)
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        self.isSignUpActive = true
                    } label: {
                        Text("회원 가입")
                    }
                    .sheet(isPresented: $isSignUpActive) {
                        SignUpView(viewModels: signViewModel)
                    }
                    .padding(.leading, 120)
                }
                .listRowBackground(Color.clear)
                
            }
            .navigationTitle("로그인")
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
    
    private func checkEmailForm(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
