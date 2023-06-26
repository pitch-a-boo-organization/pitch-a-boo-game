//
//  IOSEntryScreenView.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

#if os(iOS)
import SwiftUI
import CodeScanner

struct IOSEntryScreenView: View {
    @EnvironmentObject var entryViewModel: IOSViewModel
    @State var isPresentingScanner = false
    @State var serverHostname: String = "thiagos-mac.local"
    @State var showConnectionError: Bool = false
    
    var scannerSheet: some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { response in
                switch response {
                case .success(let result):
                    entryViewModel.setScannedCode(with: result.string)
                    self.isPresentingScanner = false
                    entryViewModel.subscribeToService()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack{

                Image("GhostBackground")
                    .resizable()
                    .scaledToFill()
                    .background(Color("EntryBackground"))
                    .ignoresSafeArea(.all)

                VStack(spacing: 10) {
                    if (entryViewModel.localUser.name == "Undefined") {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(.bottom, 100)
                    }

                    if entryViewModel.localUser.name != "Undefined" {

                            Text("You are a\n")
                                .font(.title2)
                                .bold()
                            Text("\(entryViewModel.localUser.persona.name)")
                                .padding(.top, -40)
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .shadow(radius: 10)

                            Image("\(entryViewModel.localUser.persona.name)")
                                .resizable()
                                .frame(width: 258.7, height: 293)
                                .scaledToFit()
                        VStack(alignment: .leading) {

                            Text("Your name is: \(entryViewModel.localUser.name)")
                                .bold()
                            HStack(spacing: 1) {
                                Text("You have: ")
                                    .bold()
                                Image("BoneCoin")
                                    .resizable()
                                    .frame(width: 19, height: 19)
                                    .scaledToFit()
                                Text("\(entryViewModel.localUser.bones) bones to use")
                                    .bold()
                            }
                        }
                        Text("You are connected!")
                            .font(.caption)
                    } else {
                        Button {
                            self.isPresentingScanner = true
                        } label: {
                            HStack {
                                Image(systemName: "qrcode.viewfinder")
                                Text("Scan QR Code")
                            }
                            .padding(12)
                            .foregroundColor(.white)
                            .background(Color("Red"))
                            .cornerRadius(12)
                            .frame(height: 50)

                        }
                        .sheet(isPresented: $isPresentingScanner) {
                            self.scannerSheet
                        }.alert("Failed to connect, please try again", isPresented: $showConnectionError) {

                        }
                    }



                }
                .onAppear {
                    bindConnectionError()
                }
                .navigationDestination(isPresented: $entryViewModel.matchIsReady) {
                    IOSPreparePitchView()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink (destination: {
                            List {
                                Section("CodeScanner") {
                                    VStack {
                                        Link(destination: URL(string: "https://github.com/twostraws/CodeScanner.git")!) {
                                            Text("CodeScanner was made by Paul Hudson, who writes free Swift tutorials over at Hacking with Swift. It’s available under the MIT license, which permits commercial use, modification, distribution, and private use.")
                                        }.buttonStyle(.plain)
                                    }
                                }
                            }.navigationTitle("Used Package Credits")
                        }) {
                            Label("", systemImage: "info.circle.fill")
                                .foregroundColor(.white)
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink (destination: {
                            List {
                                Section("Rules") {
                                    VStack {
                                        Link(destination: URL(string: "https://github.com/pitch-a-boo-organization/pitch-a-boo-game")!) {
                                            Text("""
                    Challenge:
                    Selling Objects to Other Personas

                    Mechanics: Sales Pitch and Bidding

                    Objective:

                    Seller: Sell the object to a specific persona (defined at the beginning of the sale) or obtain the highest possible value for the sale.
                    Buyer: Purchase an object that makes sense for their persona at the lowest possible price.
                    Reward:

                    Seller: Receives the value from the object sale.
                    Seller (fulfilling the specific objective): Receives an additional bonus.
                    Here's the game flow:

                    Preparation:

                    Players choose their personas (vampire, werewolf, zombie, etc.).
                    Each player receives a random starting object (e.g., a pen) and a specific persona to sell the object to.
                    Sales Pitch:

                    The player selling the object has 3 minutes to craft a convincing sales pitch to persuade the other players to buy the object.
                    During this time, the player can highlight the unique features of the object and how it can be useful to the buyer's persona.
                    Bidding:

                    After the sales pitch, all interested players make bids to purchase the object.
                    Each player assigns a monetary value to the object, representing how much they are willing to pay for it.
                    Determining the Winner:

                    The player who offers the highest value to buy the object is the winner and completes the purchase.
                    The player who sold the object receives the sale value.
                    If the selling player manages to fulfill the objective of selling to the specific persona, they receive an additional bonus.
                    New Round:

                    Players receive new random objects to sell and new specific personas.
                    The game continues with the sales pitch, bidding, and determining the winner stages.
                    The game proceeds in a continuous cycle, allowing players to sell different objects to different personas in each round. The main objective for the seller is to obtain the highest possible value for the sale, while the buyer's objective is to acquire an object that makes sense for their persona at the lowest possible price.

                    """)

                                        }.buttonStyle(.plain)
                                    }
                                }
                            }.navigationTitle("How to play?")
                        }) {
                            Label("", systemImage: "gamecontroller.fill")
                                .foregroundColor(.white)
                        }
                    }

                                                            

                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    func bindConnectionError() {
        entryViewModel.$errorInSubscriving.sink { error in
            if error == true {
                self.showConnectionError = true
            }
        }.store(in: &entryViewModel.cancellable)
    }
}

#endif
