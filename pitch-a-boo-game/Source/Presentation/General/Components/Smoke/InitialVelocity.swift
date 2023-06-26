//
//  InitialVelocity.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 25/06/23.
//

import Foundation

/// InitialVelocity controls how fast the single elements for the effect will be emitted onto the screen.
///
/// You can think of the initialVelocity as the initial speed with which each of the particles that the effect has will be released.
///
/// The 3 possible values are:
/// - `.slow`: elements move in a slow way.
/// - `.medium`: elements will move with mediocre initialVelocity. Default.
/// - `.fast`: elements will move fast on screen.
public enum InitialVelocity {
    case slow, medium, fast
}

public enum FadeOut {
    case none, slow, medium, fast
}

public enum Lifetime {
    case short, medium, long
}

public enum SpreadRadius {
    case low, medium, high
}
