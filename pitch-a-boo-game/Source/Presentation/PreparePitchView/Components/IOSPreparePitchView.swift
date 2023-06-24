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
        .navigationDestination(isPresented: $goToPitchView) {
            IOSPitchView()
        }
        .onReceive(prepareViewModel.$currentStage) { value in
            goToPitchView =  prepareViewModel.currentStage == 33
        }
    }
}
#endif
