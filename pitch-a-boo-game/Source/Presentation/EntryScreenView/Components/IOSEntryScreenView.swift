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
    
    var scannerSheet: some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    entryViewModel.setScannedCode(with: code.string)
                    self.isPresentingScanner = false
                    entryViewModel.subscribeToService()
                }
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(entryViewModel.scannedCode)
            
            Button("Scan QR Code") {
                self.isPresentingScanner = true
            }.sheet(isPresented: $isPresentingScanner) {
                self.scannerSheet
            }
        }
    }
}
#endif
