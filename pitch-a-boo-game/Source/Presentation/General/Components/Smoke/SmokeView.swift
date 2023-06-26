//
//  SmokeView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 25/06/23.
//

import SwiftUI

struct SmokeView: View {
    private var config: SmokeConfig

    public init(config: SmokeConfig = SmokeConfig()) {
        self.config = config
    }

    public var body: some View {
        GeometryReader { proxy in
            SmokeContainerView(proxy: proxy, config: config)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
