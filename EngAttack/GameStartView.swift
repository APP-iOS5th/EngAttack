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
    @StateObject var signViewModel: SignViewModel = SignViewModel()
    @EnvironmentObject var contentViewModel : ContentViewViewModel
	var body: some View {
		NavigationStack {
			
			ZStack {
				VStack {
					Text(contentViewModel.isKR ? "Ready for game" : "게임 준비")
						.font(.largeTitle)
						.foregroundStyle(.blue)
						.padding(.top, 20)
					Spacer()
					Image(systemName: "figure.run")
						.font(.system(size: 130))
						.foregroundStyle(.gray)
					Spacer()
					Text(contentViewModel.isKR ? "Choose Limit Time" : "제한 시간을 선택해주세요")
						.font(.system(size: 25))
						.fontWeight(.bold)
						.foregroundStyle(.green)
					Picker(contentViewModel.isKR ? "Choose time" : "선택 시간", selection: $selectedTime) {
						ForEach(times, id: \.self) { time in
							Text(String(format: "%.0f", Double(time)) + "\(contentViewModel.isKR ? "S" : "초")").tag(time)
								.foregroundStyle(Color("PickerFontColor"))
						}
					}
					.frame(width: 250, height: 100)
					.pickerStyle(.wheel)
					.background(.yellow)
					.cornerRadius(15)
					.padding()
					
					Text(contentViewModel.isKR ? "You choose " : "너의 선택은 ")
						.font(.custom("SOYO Maple Bold", size: 20)) +
					Text("\(Int(selectedTime))")
						.foregroundColor(.red)
						.font(.custom("SOYO Maple Bold", size: 20)) +
					Text(contentViewModel.isKR ? "s" : "초")
						.font(.custom("SOYO Maple Bold", size: 20))
					Spacer()
					Button(contentViewModel.isKR ? "Game Start" : "게임 시작") {
						isCountDownPresented = true // 사용자가 게임 시작 버튼을 눌렀을 때
					}
				}
				.font(.system(size: 50))
				
				.padding(.bottom, 100)
				.fullScreenCover(isPresented: $isCountDownPresented) { // 카운트다운 화면 표시
					CountDownView(isPresented: $isCountDownPresented)
				}
				.fullScreenCover(isPresented: $isGameViewPresented) { // 게임 화면 표시
                    ContentView(timeRemaining: $selectedTime)
				}
			}
			.onChange(of: isCountDownPresented) { newValue, _ in
				if !newValue {
					isGameViewPresented = true // 게임 화면으로 전환
				}
			}
			.font(.custom("SOYO Maple Bold", size: 30))
			.bold()
			
			Spacer()
			
		}
		.navigationBarBackButtonHidden(true)
	}
}


#Preview {
	GameStartView()
		.environmentObject(ContentViewViewModel())
}
