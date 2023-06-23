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
        }
    }
}

class LocalNetworkPrivacy : NSObject {
    let service: NetService
    var completion: ((Bool) -> Void)?
    var timer: Timer?
    var publishing = false
    
    init(hostname: String) {
        service = .init(
            domain: "\(hostname).local",
            type:"_lnp._tcp.",
            name: "LocalNetworkPrivacy",
            port: 8080
        )
        super.init()
    }
    
    @objc
    func checkAccessState(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        
        timer = .scheduledTimer(withTimeInterval: 2, repeats: true, block: { timer in
            guard UIApplication.shared.applicationState == .active else {
                return
            }
            
            if self.publishing {
                self.timer?.invalidate()
                self.completion?(false)
            }
            else {
                self.publishing = true
                self.service.delegate = self
                self.service.publish()
                
            }
        })
    }
    
    deinit {
        service.stop()
    }
}

extension LocalNetworkPrivacy : NetServiceDelegate {
    
    func netServiceDidPublish(_ sender: NetService) {
        timer?.invalidate()
        completion?(true)
    }
}

#endif
