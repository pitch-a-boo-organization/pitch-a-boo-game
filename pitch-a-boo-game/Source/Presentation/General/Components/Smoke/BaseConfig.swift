//
//  BaseConfig.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 25/06/23.
//

import SwiftUI

protocol BaseConfig {
    var content: [Content] { get }
    var backgroundColor: Color { get }
    var intensity: Intensity { get }
    var lifetime: Lifetime { get }
    var initialVelocity: InitialVelocity { get }
    var fadeOut: FadeOut { get }
    var spreadRadius: SpreadRadius { get }
    var birthRateValue: Float { get }
    var lifetimeValue: Float { get }
    var velocityValue: CGFloat { get }
    var alphaSpeedValue: Float { get }
    var spreadRadiusValue: CGFloat { get }
}
