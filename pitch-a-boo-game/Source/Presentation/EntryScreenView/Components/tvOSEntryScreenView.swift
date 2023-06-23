//
//  tvOSEntryScreenView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 20/06/23.
//

import SwiftUI

struct tvOSEntryScreenView: View {
    @EnvironmentObject var entryViewModel: EntryScreenViewModel

    private let logoImage = "Logo"

    let textConnections = "Everybody's connected"
    private let textScan = "Scan to Play!"

    var body: some View {
        NavigationStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    VStack(spacing: 95) {
                        Image(logoImage)
                            .resizable()
                            .frame(width: 488, height: 356.45154)

                        VStack {
                            NavigationLink(destination: PreparePitchView(), label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .background(Color(red: 0.11, green: 0.11, blue: 0.11))
                                        .cornerRadius(13.86969)
                                        .frame(width: 388, height: 81.5864)

                                    Text("\(textConnections)")
                                }
                            })
                            .buttonStyle(.card)
                        }

                        VStack(spacing: 5) {
                            Image(uiImage: entryViewModel.generateQRCode()!)
                                .resizable()
                                .interpolation(.none)
                                .frame(width: 250, height: 250)
                                .foregroundColor(.white)
                            Text("\(textScan)")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.leading, 166)
                }
                Spacer()

                VStack {
                    VStack {
                        PlayersGrid(players: entryViewModel.players)
//                            .frame(maxWidth: 491, maxHeight: 418.38889)
                    }

                }
                Spacer()
            }
        }.background(Color("EntryBackground"))
    }
}

struct tvOSEntryScreenView_Previews: PreviewProvider {
    static var previews: some View {
        tvOSEntryScreenView()
    }
}
