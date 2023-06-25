//
//  PlayerScore.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

#if os(tvOS)
import SwiftUI
import PitchABooServer

struct PlayerScore: View {
    let imageCoin = "BoneCoin"
    let tombstone = "whiteTombstone"
    let player: PitchABooServer.Player
    
    var body: some View {
        VStack {
            Text(player.name)
                .font(.title3)
            Image(tombstone)
                .resizable()
                .frame(width: 87,height: 87)
            HStack(spacing: 6) {
                Image(imageCoin)
                    .resizable()
                    .frame(width: 58.25, height: 53.67)
                Text("\(player.bones)")
                    .bold()
                    .font(.title3)
            }
        }
    }
}
#endif
