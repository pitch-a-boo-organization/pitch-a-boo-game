//
//  GameRouter.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 11/07/23.
//

import Foundation
import SwiftUI

enum Interaction {
    case entryScreen
    case preparePitch
    case pitch
    case reviewItem
    case scoreView
}

class GameRouter: ObservableObject {
    var iOSViewModel: IOSViewModel? {
        didSet {
            bindViewModel()
        }
    }
    @Published private(set) var currentInteraction: Interaction = .entryScreen

    func bindViewModel() {
        guard let viewModel = iOSViewModel else { return }
        viewModel.$currentStage.sink { [weak self] value in
            self?.handleStageChange(value)
        }
        .store(in: &viewModel.cancellable)
    }
    
    func handleStageChange(_ stage: Int) {
        switch stage {
            case 31:
                currentInteraction = .preparePitch
            case 33:
                currentInteraction = .pitch
            case 34:
                currentInteraction = .reviewItem
            case 35:
                currentInteraction = .scoreView
            default:
                currentInteraction = .entryScreen
        }
    }
}
