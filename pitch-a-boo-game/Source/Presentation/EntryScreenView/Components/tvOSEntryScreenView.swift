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

    let textConnections = "EVERYBODY'S IN"
    private let textScan = "Scan to Play!"

    var body: some View {
        NavigationStack {
            HStack {
                VStack {
                    Spacer()
                    VStack {
                        PlayersGrid()
                    }
                }
                VStack {
                    VStack(spacing: 95) {
                        Image(logoImage)
                            .resizable()
                            .frame(maxWidth: 472, maxHeight: 203.04)
                        Spacer()
                        VStack {
                            NavigationLink(destination: PreparePitchView(), label: {
                                Text("\(textConnections)")
                                    .foregroundColor(.black)

                            })
                        }
                        Spacer()
                        VStack {
                            Image(uiImage: entryViewModel.generateQRCode()!)
                                .resizable()
                                .interpolation(.none)
                                .frame(maxWidth: 150, maxHeight: 150)
                                .foregroundColor(.white)
                        }
                        .scaleEffect(2)
                        Text("\(textScan)")
                            .font(.title2)
                    }
                }
                VStack {
                    Spacer()
                    VStack {
                        PlayersGrid()
                    }
                }
            }
        }
    }
}

struct tvOSEntryScreenView_Previews: PreviewProvider {
    static var previews: some View {
        tvOSEntryScreenView()
    }
}
