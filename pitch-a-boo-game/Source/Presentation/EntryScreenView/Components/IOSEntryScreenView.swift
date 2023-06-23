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
    @State var serverHostname: String = ""
    
    var scannerSheet: some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    entryViewModel.setScannedCode(with: code.string)
                    self.isPresentingScanner = false
                    // Verify if network is granted before subscribe!!!!x
                    entryViewModel.subscribeToService()
                }
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Seu player: \(entryViewModel.localUser.name)")
            Text(entryViewModel.scannedCode)
            
            Button("Scan QR Code") {
                self.isPresentingScanner = true
            }.sheet(isPresented: $isPresentingScanner) {
                self.scannerSheet
            }
            
            TextField("hostname", text: $serverHostname)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .frame(width: 300, height: 50)
                .textFieldStyle(.roundedBorder)
                .padding(8)
                .padding([.horizontal], 150)
                .padding([.bottom], 50)
            
            Button {
                entryViewModel.setScannedCode(with: serverHostname)
                entryViewModel.subscribeToService()
            } label: {
                Text("Conectar")
                    .padding(12)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(12)
                    .frame(width: 150, height: 50)
            }
            .disabled(serverHostname == "")
        }
    }
}
#endif
