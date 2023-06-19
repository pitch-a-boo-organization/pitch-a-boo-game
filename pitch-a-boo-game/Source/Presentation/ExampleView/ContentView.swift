//
//  ContentView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import SwiftUI
import PitchABooServer

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var serverName = ""
    @State var hostname = ""
    
    var body: some View {
        VStack {
            #if os(macOS)
            Text("Connect to hostname: \(hostname)")
                .font(.title)
                .padding([.bottom], 50)
            
            Button("Start Server") {
                let server = try! PitchABooWebSocketServer(port: 8080)
                server.startServer { error in
                    if let error = error {
                        print("Error! \(error)")
                        return
                    }
                    hostname = server.getServerHostname() ?? ""
                }
            }
            #else
            Text("Server Status: \(viewModel.connectionStatus)")
                .font(.title)
                .padding([.bottom], 150)
            
            Text("Receive From Server: \(viewModel.receiveFromServer)")
                .font(.title3)
                .padding([.bottom], 150)
            
            TextField(text: $serverName, label: {
                Text("Server Name")
                    .font(.title3)
            })
            
            Button("Start Listening") {
                let client = PitchABooSocketClient.shared
                client.defineServerURL(hostname: serverName)
                client.delegate = viewModel
                client.subscribeToService()
            }
            .disabled(serverName == "")
            #endif
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
