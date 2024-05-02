//
//  GameView.swift
//  EngAttack
//
//  Created by 홍준범 on 4/30/24.
//

import SwiftUI

struct GameStartView: View {
    @State var isGameViewPresented = false
    var times = ["3s", "5s", "7s", "10s", "15s", "20s", "30s", "60s"]
    @State var selectedTime = ""
    
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
                    isGameViewPresented = true
                } label: {
                    Text("Start")
                    Image(systemName: "arrowshape.right.fill")
                }
                .navigationDestination(isPresented: $isGameViewPresented) {
                    ContentView()
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
