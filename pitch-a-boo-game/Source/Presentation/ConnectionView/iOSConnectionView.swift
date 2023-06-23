//
//  iOSConnectionView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 15/06/23.
//

#if os(iOS)
import SwiftUI
import CodeScanner

struct iOSConnectionView: View {
    @EnvironmentObject var iOSViewModel: IOSViewModel
    @State var serverHostname = ""
    @State var isPresentingScanner = false
    
    var scannerSheet: some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    iOSViewModel.setScannedCode(with: code.string)
                    isPresentingScanner = false
                }
            }
        )
    }
    
    var body: some View {
        VStack {
            if iOSViewModel.connected {
                VStack {
                    Text("Conectado")
                        .font(.title)
                        .padding([.bottom], 10)
                    Text("Aguardando jogadores...")
                        .font(.body)
                    
                    Button {
                        iOSViewModel.client.sendStartGameFlowToServer()
                    } label: {
                        Text("Conectar")
                            .padding(12)
                            .foregroundColor(.white)
                            .background(.black)
                            .cornerRadius(12)
                            .frame(width: 150, height: 50)
                    }
                }
            } else {
                Text("Conectar a uma sessão!")
                    .font(.title)
                    .padding([.bottom], 50)
                
                TextField("hostname", text: $serverHostname)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .frame(width: 300, height: 50)
                    .textFieldStyle(.roundedBorder)
                    .padding(8)
                    .padding([.horizontal], 150)
                    .padding([.bottom], 50)
                
                Button {
                    iOSViewModel.client.defineServerURL(hostname: serverHostname)
                    iOSViewModel.client.subscribeToService()
                } label: {
                    Text("Conectar")
                        .padding(12)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(12)
                        .frame(width: 150, height: 50)
                }
                .disabled(serverHostname == "")
                
                Text(UIDevice.current.identifierForVendor?.uuidString ?? "")
                
                Button("Scan the QR Code from your AppleTV") {
                    isPresentingScanner = true
                }.sheet(isPresented: $isPresentingScanner) {
                    scannerSheet
                }
            }
            
            
          
        }
    }
}
#endif
