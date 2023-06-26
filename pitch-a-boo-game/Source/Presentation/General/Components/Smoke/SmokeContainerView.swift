//
//  SmokeContainerView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 25/06/23.
//

import SwiftUI
import SpriteKit

struct SmokeContainerView: View {

    var proxy: GeometryProxy
    var config: SmokeConfig

    var body: some View {
        SpriteView(
            scene: createScene(of: proxy.size),
            options: [.allowsTransparency]
        )
    }

    func createScene(of size: CGSize) -> SKScene {
        return SmokeScene(size: size, config: config)

    }
}
