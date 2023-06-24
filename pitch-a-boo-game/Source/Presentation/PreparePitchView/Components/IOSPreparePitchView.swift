//
//  IOSPreparePitchView.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import SwiftUI

struct IOSPreparePitchView: View {
    @EnvironmentObject var prepareViewModel: IOSViewModel
    
    var body: some View {
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
        }
    }
}

struct IOSPreparePitchView_Previews: PreviewProvider {
    static var previews: some View {
        IOSPreparePitchView()
    }
}
