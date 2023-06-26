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
                Text("Look for TV!")
                    .font(.title2)
                    .bold()
            }
        }
        .navigationDestination(isPresented: $goToPitchView) {
            IOSPitchView()
        }
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
