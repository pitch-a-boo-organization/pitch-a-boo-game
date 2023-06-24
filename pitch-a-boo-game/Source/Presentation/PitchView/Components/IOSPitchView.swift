//
//  IOSPitchView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 24/06/23.
//

#if os(iOS)
import SwiftUI

struct IOSPitchView: View {
    @EnvironmentObject var iosPitchViewModel: IOSViewModel
    
    var body: some View {
        if iosPitchViewModel.amIChosen {
            Text("Look to TV to know the remaing time of your apresentation!")
                .font(.title2)
                .bold()
        } else {
            VStack {
                Text("Pay attention in presentation of player: \(iosPitchViewModel.chosenPlayer.player.name) \n Feel free to bid any value during the player's presentation")
                    .font(.title2)
                    .bold()
                
                BidView()
            }
            
        }
    }
}
#endif
