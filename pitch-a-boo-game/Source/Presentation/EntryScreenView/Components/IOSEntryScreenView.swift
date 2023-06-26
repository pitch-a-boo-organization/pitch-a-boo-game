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
                            .foregroundColor(.red)

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
                        Label("", systemImage: "info.circle")
                            .foregroundColor(Color(.systemGray))
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
