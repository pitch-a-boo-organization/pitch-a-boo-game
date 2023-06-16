//
//  iOSConnectionView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 15/06/23.
//

#if os(iOS)
import Foundation
import SwiftUI

struct iOSConnectionView: View {
    @EnvironmentObject var viewModel: ConnectionViewModel
    @State var serverHostname = ""
    
    var body: some View {
        VStack {
            if viewModel.connected {
                VStack {
                    Text("Conectado")
                        .font(.title)
                        .padding([.bottom], 10)
                    Text("Aguardando jogadores...")
                        .font(.body)
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
                    let client = PitchABooSocketClient.shared
                    client.defineServerURL(hostname: serverHostname)
                    client.delegate = viewModel
                    client.subscribeToService()
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
}
#endif
