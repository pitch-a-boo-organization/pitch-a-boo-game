//
//  tvOSEntryScreenView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 20/06/23.
//
#if os(tvOS)
import SwiftUI
import CoreImage.CIFilterBuiltins

struct TvOSEntryScreenView: View {
    @State var context = CIContext()
    @State var filter = CIFilter.qrCodeGenerator()
    private let logoImage = "Logo"
    let textConnections = "Everybody's connected"
    private let textScan = "Scan to Play!"
    @EnvironmentObject var entryViewModel: TvOSViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Image("GhostBackground")
                    .resizable()
                    .scaledToFill()
                    .background(Color("EntryBackground"))
                    .ignoresSafeArea(.all)

                SmokeView(
                    config: SmokeConfig(
                        content: [
                            .image(UIImage(imageLiteralResourceName: "spark"), .init(white: 1, alpha: 0.2), 2)

//                            .shape(.triangle, .white, 10.0),
//                            .shape(.square, .white, 10.0),
//                            .shape(.circle, .white, 10.0),

                        ],
                        intensity: .high,
                        lifetime: .long,
                        initialVelocity: .fast,
                        fadeOut: .slow,
                        spreadRadius: .high
                    )
                )

                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        VStack(spacing: 95) {
                            Image(logoImage)
                                .resizable()
                                .frame(width: 488, height: 356.45154)

//                            Text(entryViewModel.server.getServerHostname() ?? "none")

                            if entryViewModel.isMatchReady {
                                VStack {
                                    Button {
                                        entryViewModel.sendStartStage(31)
                                    } label: {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .background(Color(red: 0.11, green: 0.11, blue: 0.11))
                                                .cornerRadius(13.86969)
                                                .frame(width: 388, height: 81.5864)

                                            Text("\(textConnections)")
                                        }
                                    }
                                    
                                    .buttonStyle(.card)
                                }.navigationDestination(isPresented: $entryViewModel.inningHasStarted) {
                                    TvOSPreparePitchView()
                                }
                            } else {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .background(Color(red: 0.11, green: 0.11, blue: 0.11))
                                        .cornerRadius(13.86969)
                                        .frame(width: 388, height: 81.5864)
                                        .opacity(0.5)

                                    Text("\(textConnections)")
                                        .foregroundColor(Color.init(white: 0.8))
                                }
                            }



                            VStack(spacing: 5) {
                                Image(
                                    uiImage: generateQRCode(
                                        serverHostname: entryViewModel.server.getServerHostname()!
                                    )!
                                )
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
                        PlayersGrid(players: entryViewModel.players)


                    }
                    Spacer()
                }
            }
        }

    }
    
    public func generateQRCode(serverHostname: String) -> UIImage? {
        filter.message = Data(serverHostname.utf8)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
}
#endif
