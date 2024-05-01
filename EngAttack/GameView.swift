//
//  GameView.swift
//  EngAttack
//
//  Created by 홍준범 on 4/30/24.
//

import SwiftUI

struct GameView: View {
    var times = ["3s", "5s", "7s", "10s", "15s", "20s", "30s", "60s"]
    @State var selectedTime = ""
    
    var body: some View {
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
                ForEach(times, id: \.self) {
                    Text($0)
                }
            }
            .frame(width: 250, height: 100)
            .pickerStyle(.wheel)
            .background(.yellow)
            .cornerRadius(15)
            .padding()
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Start")
                Image(systemName: "arrowshape.right.fill")
            }
            .font(.system(size: 30))
            
            Spacer()
        }
    }
}

#Preview {
    GameView()
}
