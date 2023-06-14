//
//  ContentView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import SwiftUI

struct ContentView: View {
    @State var serverValue: String = ""
    
    var body: some View {
        VStack {
            #if os(macOS)
            Button("Start Server") {
                let server = try! PitchABooWebSocketServer(port: 8080)
                server.startServer { error in
                    if let error = error {
                        print("Error! \(error)")
                    } else {
                        print("Initializing Server")
                    }
                }
            }
            #else
            Text("Server Value: \(serverValue)")
                .padding(60)
            
            Button("Start Listening") {
                let client = PitchABooSocketClient.shared
                client.subscribeToService { data in
                    guard let data = data else { return }
                    serverValue = data
                }
            }
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
