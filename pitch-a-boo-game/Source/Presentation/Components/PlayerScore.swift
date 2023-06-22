//
//  PlayerScore.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct PlayerScore: View {
    let name = "Zumbi"
    let imageCoin = "BoneCoin"
    let tombstone = "whiteTombstone"
    let numberOfCoins = "5"
    var body: some View {
        VStack {
            Text("\(name)")
                .font(.title3)
            Image(tombstone)
                .resizable()
                .frame(width: 87,height: 87)
            HStack(spacing: 6) {
                Image(imageCoin)
                    .resizable()
                    .frame(width: 58.25, height: 53.67)
                Text(numberOfCoins)
                    .bold()
                    .font(.title3)
            }
        }
    }
}

struct PlayerScore_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScore()
    }
}
