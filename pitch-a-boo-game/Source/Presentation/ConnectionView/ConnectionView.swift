//
//  ConnectionView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 15/06/23.
//

//import SwiftUI
//import PitchABooServer
//
//struct ConnectionView: View {
//    private var server: PitchABooWebSocketServer = try! PitchABooWebSocketServer(port: 8080)
//    @ObservedObject var tvOSViewModel =  TvOSViewModel()
//    @ObservedObject var iOSViewModel = IOSViewModel()
//    
//    var body: some View {
//        Group {
//            #if os(tvOS)
//                TvOSConnectionView()
//            #else
//                iOSConnectionView()
//            #endif
//        }
//        .onAppear {
//            tvOSViewModel.server = server
//            iOSViewModel.server = server
//            
//            iOSViewModel.client.iOSDelegate = iOSViewModel
//            tvOSViewModel.client.tvOSDelegate = tvOSViewModel
//        }
//        .environmentObject(iOSViewModel)
//        .environmentObject(tvOSViewModel)
//    }
//}
