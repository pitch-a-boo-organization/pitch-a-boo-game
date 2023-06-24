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
                    Text("Item: \(prepareViewModel.chosenPlayer.sellingItem.name)")
                    Text("Value: \(prepareViewModel.chosenPlayer.sellingItem.value)")
                }
            } else {
                Text("Look for TV!")
                    .font(.title2)
                    .bold()
            }
        }
        .onAppear { bindViewModel() }
        .navigationDestination(isPresented: $goToPitchView) {
            IOSPitchView()
        }
    }
    
    func bindViewModel() {
        prepareViewModel.$currentStage.sink { value in
            print("RECEIVE VALUE: \(value)")
            goToPitchView = (value == 33)
        }
        .store(in: &prepareViewModel.cancellable)
    }
}
#endif
