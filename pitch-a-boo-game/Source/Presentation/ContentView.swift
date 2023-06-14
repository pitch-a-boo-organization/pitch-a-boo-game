//
//  ContentView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Start Server") {
                let socket = try! PitchABooWebSocketServer(port: 8080)
                socket.startServer { error in
                    if let _ = error {
                        print("Erro!")
                    } else {
                        print("Conectado com sucesso!")
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
