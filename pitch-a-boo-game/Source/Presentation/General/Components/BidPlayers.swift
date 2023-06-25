//
//  BidPlayers.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 25/06/23.
//

import SwiftUI

struct BidPlayers: View {
    var player: BidPlayer

//    @State var numberCoins = "5"
//    @State var namePlayer = "LittleWing"

    var body: some View {
        HStack(spacing: 6) {
            Image("BoneCoin")
                .resizable()
                .frame(width: 37, height: 37)
            Text(String(player.bidSent))
                .bold()
            Text(player.namePlayer)
                .bold()
        }
        .frame(maxWidth: 215, maxHeight: 38)
    }
}
