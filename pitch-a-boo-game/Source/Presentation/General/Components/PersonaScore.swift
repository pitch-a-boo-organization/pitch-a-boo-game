//
//  PersonaScore.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 26/06/23.
//
#if os(tvOS)
import SwiftUI
import PitchABooServer

struct PersonaScore: View {
    let imageCoin = "BoneCoin"
    let tombstone = "whiteTombstone"
    let player: PitchABooServer.Player

    var body: some View {
        VStack {
            Text(player.name)
                .foregroundColor(.black)
                .font(.title3)
            Image(player.persona.name)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 87,maxHeight: 87)
            HStack(spacing: 6) {
                Image(imageCoin)
                    .resizable()
                    .frame(width: 58.25, height: 53.67)
                Text("\(player.bones)")
                    .bold()
                    .foregroundColor(.black)
                    .font(.title3)
            }
        }
    }
}
#endif
