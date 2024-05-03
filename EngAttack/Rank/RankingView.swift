//
//  MainView.swift
//  EngAttack
//
//  Created by 홍준범 on 5/1/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RankingView: View {
   
    
    var body: some View {
        VStack {
            Text("EngAttack")
                .font(.custom("SOYO Maple Bold", size: 60))
                .foregroundStyle(.brown)
                .padding(.top, 140)
                .font(.system(size: 100))
                
           
            Text("Ranking")
                .font(.custom("SOYO Maple Regular", size: 40))
                .padding()
                .foregroundStyle(.gray)
            Image(systemName: "chart.bar.xaxis.ascending")
                .font(.system(size: 150))
            Text("(랭킹표 넣을거면 랭킹표 넣을 곳)")
            Spacer()
        }
    }
}


//extension RankingView {
//    func loadRank() {
//        db.collection("Rank").document
//    }
//}

//#Preview {
//	RankingView()
//}
