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
    @EnvironmentObject  var viewModel : SignViewModel
    @EnvironmentObject var setViewModel: SettingViewModel
    @State private var correctLogin = false
    @State private var email = ""
    @State private var password = ""
    @State private var loginActive = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("아이디")
                        .font(.system(size: 13, weight: .light))
                        .foregroundColor(.secondary)
                        .frame(height: 15)
                    TextField("", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .font(.system(size: 17, weight: .thin))
                        .foregroundStyle(.black)
                        .frame(height: 50)
                        .padding(.horizontal, 12)
                        .background(Color.white)
                        .cornerRadius(4.0)
                        .focused($focusedField, equals: .id)
                        .onSubmit { focusedField = .password}
                }
                VStack(alignment: .leading) {
                    Text("패스워드")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(.secondary)
                        .frame(height: 15)
                    SecureField("", text: $password)
                        .textInputAutocapitalization(.never)
                        .font(.system(size: 17, weight: .thin))
                        .foregroundStyle(.black)
                        .frame(height: 44)
                        .padding(.horizontal, 12)
                        .background(Color.white)
                        .cornerRadius(4.0)
                        .focused($focusedField, equals: .password)
                        .onSubmit { focusedField = nil }
                }
            }
            Button {
                Task {
                    do {
                        viewModel.email = email
                        viewModel.password = password
                        try await viewModel.signIn()
                        guard let userID = Auth.auth().currentUser?.uid else { return }
                        viewModel.uid = userID
                        viewModel.Signstate = .signedIn
                        loginActive = true
                            return
                    } catch {
                        correctLogin = true
                    }
                }
            } label: {
                Text("로그인")
                    .frame(width: 300, height: 30)
            }
            .alert(isPresented: $correctLogin) {
                Alert(title: Text("주의"), message: Text("이메일 또는 비밀번호가 맞지않습니다."), dismissButton: .default(Text("확인")))
            }
            .disabled( !checkEmailForm(email:email) )
            .buttonStyle(.borderedProminent)
            .padding()
            NavigationLink(destination: SignUpView(viewModels: SignViewModel())){
                Text("회원 가입")
            }
        }.navigationBarBackButtonHidden(true)
        .preferredColorScheme(contentViewModel.isDarkMode ? .dark : .light)
        
        NavigationLink(destination: TabViewSetting()
            .environmentObject(SettingViewModel())
            .environmentObject(ContentViewViewModel())
            , isActive: $loginActive){
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
