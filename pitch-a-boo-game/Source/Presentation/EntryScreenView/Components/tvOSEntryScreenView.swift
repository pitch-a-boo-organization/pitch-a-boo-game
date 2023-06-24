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
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    VStack(spacing: 95) {
                        Image(logoImage)
                            .resizable()
                            .frame(width: 488, height: 356.45154)
                        
                        Text(entryViewModel.server.getServerHostname() ?? "none")
                        
                        if entryViewModel.isMatchReady {
                            VStack {
                                Button {
                                    entryViewModel.sendStartPitchStage(31)
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
        }.background(Color("EntryBackground"))
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
