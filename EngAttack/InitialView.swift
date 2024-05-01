//
//  InitialView.swift
//  EngAttack
//
//  Created by 홍준범 on 4/30/24.
//

import SwiftUI


struct InitialView: View {
    var body: some View {
        NavigationStack {
            VStack{
                Text("EngAttack")
                    .font(.system(size: 50))
                    .padding(.top, 60)
                    .foregroundStyle(.black)
                Spacer()
                Text("Ranking")
                    .font(.system(size: 60))
                    .padding(.bottom, 20)
                    .foregroundStyle(.gray)
                Image(systemName: "chart.bar.xaxis.ascending")
                    .font(.system(size: 150))
                Spacer()
                HStack{
                    
                    NavigationLink(destination: GameView()) {
                        
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 90))
                        
                        NavigationLink(destination: DictionaryView()) {
                            Image(systemName: "character.book.closed.fill")
                                .font(.system(size: 90))
                            
                            NavigationLink(destination: DictionaryView()) {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 90))
                                
                                
                            }
                        }
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            
                        } label: {
                            Text("계정")
                        }
                    }
                }
                .font(.system(size: 25))
                
                Spacer()
            }
        }
    }
}
#Preview {
    InitialView()
}
