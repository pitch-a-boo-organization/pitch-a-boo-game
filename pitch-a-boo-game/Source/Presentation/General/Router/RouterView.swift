//
//  MainView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 11/07/23.
//

#if os(iOS)
import Foundation
import SwiftUI

struct RouterView: View {
    @ObservedObject var iOSViewModel = IOSViewModel(client: PitchABooSocketClient.shared)
    @ObservedObject var router: GameRouter = GameRouter()
    @Environment(\.scenePhase) var scenePhase
    private var sceneHandler = ApplicationSceneHandler()

    init() {
        iOSViewModel.client.output = iOSViewModel
        sceneHandler.viewModel = iOSViewModel
        router.iOSViewModel = iOSViewModel
    }
    
    var body: some View {
        ZStack {
            switch router.currentInteraction {
                case .entryScreen:
                    IOSEntryScreenView()
                case .preparePitch:
                    IOSPreparePitchView()
                case .pitch:
                    IOSPitchView()
                case .reviewItem:
                    IOSReviewItemView()
                case .scoreView:
                    IOSScoreView()
            }
        }
        .onChange(of: scenePhase, perform: sceneHandler.handle)
        .environmentObject(iOSViewModel)
    }
}
#endif
