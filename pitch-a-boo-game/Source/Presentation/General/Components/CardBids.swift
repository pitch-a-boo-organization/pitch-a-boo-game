//
//  CardBids.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 25/06/23.
//

import SwiftUI

struct CardBids: View {
    @State var colorCard = "ColorCard"
    @State var nameItem = "Name of item"
    @State var coinImageName = "BoneCoin"
    @State var numberOfCoins = "5"
    @State private var degrees = 180.0
//    @State var bidPlayers[]

    @EnvironmentObject var viewModel: TvOSViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(colorCard))
                .frame(width: 321.49, height: 523.57)

            VStack(alignment: .center,spacing: 26) {
                Image("LogoNegative")
                    .resizable()
                    .frame(width: 104, height: 75)
                    .padding(.top, 34)
                List {
                    ForEach(viewModel.bidPlayersSent, id: \.id ) { player in
                        BidPlayers(player: player)
                    }

                }
            }
            .padding(.leading, 33)
            .frame(width: 321.49, height: 523.57)
        }
    }
}
