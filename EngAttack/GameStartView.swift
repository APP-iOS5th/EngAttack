//
//  GameView.swift
//  EngAttack
//
//  Created by 홍준범 on 4/30/24.
//

import SwiftUI


struct GameStartView: View {
    @State var isGameViewPresented = false
    @State var isCountDownPresented = false
    var times: [Double] = [3, 5, 7, 10, 15, 20, 30, 60]
    @State var selectedTime: Double = 3
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButton : some View {
        Button{
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "house.fill")
                    .aspectRatio(contentMode: .fit)
                    .font(.system(size: 25))
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                VStack {
                    Text("Ready for game")
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                        .padding(.top, 20)
                    Spacer()
                    Image(systemName: "figure.run")
                        .font(.system(size: 150))
                        .foregroundStyle(.gray)
                    Spacer()
                    Text("Choose Limit Time")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                    Picker("Choose time", selection: $selectedTime) {
                        ForEach(times, id: \.self) { time in
                            Text(String(format: "%.0f", Double(time)) + "s").tag(time)
                        }
                    }
                    .frame(width: 250, height: 100)
                    .pickerStyle(.wheel)
                    .background(.yellow)
                    .cornerRadius(15)
                    .padding()
                    
                    Text("You chose \(Int(selectedTime))s")
                        .font(.custom("SOYO Maple Bold", size: 15))
                    
                    Spacer()
                    
                    Button("Start Game") {
                        isCountDownPresented = true // 사용자가 게임 시작 버튼을 눌렀을 때
                    }
                    .fullScreenCover(isPresented: $isCountDownPresented) { // 카운트다운 화면 표시
                        CountDownView(isPresented: $isCountDownPresented)
                    }
                    .fullScreenCover(isPresented: $isGameViewPresented) { // 게임 화면 표시
                        ContentView(timeRemaining: $selectedTime)
                    }
                }
                .onChange(of: isCountDownPresented) { newValue, _ in
                    if !newValue { // newValue가 false(카운트다운 뷰가 사라짐)일 때
                        isGameViewPresented = true // 게임 화면으로 전환
                    }
                }
                .font(.system(size: 30))
                
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        }
    }
}


#Preview {
    GameStartView()
        .environmentObject(ContentViewViewModel())
}
