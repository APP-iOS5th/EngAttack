//
//  GameView.swift
//  EngAttack
//
//  Created by 홍준범 on 4/30/24.
//

import SwiftUI


struct GameView: View {
    @State var isGameViewPresented = false
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
                
                Button {
                    isGameViewPresented = true
                } label: {
                    Text("Start")
                    Image(systemName: "arrowshape.right.fill")
                }
                .navigationDestination(isPresented: $isGameViewPresented) {
                    ContentView(timeRemaining: $selectedTime)
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
    GameView()
}
