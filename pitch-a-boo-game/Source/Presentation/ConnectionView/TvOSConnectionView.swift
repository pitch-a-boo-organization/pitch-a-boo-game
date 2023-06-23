//
//  TvOSConnectionView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 15/06/23.
//

#if os(tvOS)
import Foundation
import SwiftUI

struct TvOSConnectionView: View {
    @EnvironmentObject var tvOSViewModel: TvOSViewModel
    @State var hostname = ""
    
    var body: some View {
            Text("Conecte-se ao hostname: \(hostname)")
                .font(.title)
                .padding([.bottom], 25)
        
        .opacity(hostname == "" ? 0 : 1)
        .padding([.bottom], 10  )
        
        Button {
            tvOSViewModel.server.startServer { error in
                if let error = error {
                    print("Error! \(error)")
                    return
                }
                hostname = tvOSViewModel.server.getServerHostname() ?? ""
            }
        } label: {
            Text("Iniciar Sessão")
                .font(.title2)
                .padding(12)
                .background(.black)
                .cornerRadius(12)
                .frame(width: 300, height: 150)
        }
        .buttonStyle(.plain)
    }
}
#endif
