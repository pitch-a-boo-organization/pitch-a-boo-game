//
//  IOSPreparePitchView.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

#if os(iOS)
import SwiftUI

struct IOSPreparePitchView: View {
    @EnvironmentObject var prepareViewModel: IOSViewModel
    @State private var goToPitchView: Bool = false
    
    var body: some View {
        Group {
            if prepareViewModel.amIChosen {
                VStack {
                    Text("You're the seller!")
                        .font(.title2)
                        .bold()
                        .padding(26)
                    Text("Prepare Pitch...")
                        .padding(8)
                    CardItem(nameItem: prepareViewModel.chosenPlayer.sellingItem.name , numberOfCoins: prepareViewModel.chosenPlayer.sellingItem.value
                    ).scaledToFit()
                        .padding(.bottom, 20)
                }
            } else {
                VStack {
                    HStack {
                        Spacer()
                        Image("BoneCoin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text("\(prepareViewModel.localUser.bones)")
                            .bold()
                            .font(.title)
                    }
                    .padding(30)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color("ColorCard"))
                            .frame(width: 321.49, height: 523.57)
                        Text("Look for TV!")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                    }
                    HStack(spacing: 1) {
                        Text("You are a: ")
                            .font(.title)
                        Text("\(prepareViewModel.localUser.persona.name)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $goToPitchView) {
            IOSPitchView()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { bindViewModel() }
    }
    
    func bindViewModel() {
        prepareViewModel.$currentStage.sink { value in
            print("RECEIVING NEW VALUE: \(value)")
            if value == 33 {
                print("INSIDE IF")
                goToPitchView = true
                prepareViewModel.cancellable.forEach { cancelable in
                    cancelable.cancel()
                }
            }
        }
        .store(in: &prepareViewModel.cancellable)
    }
}
#endif
