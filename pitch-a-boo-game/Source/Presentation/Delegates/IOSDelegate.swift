//
//  PitchABooiOSDelegate.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation

protocol IOSDelegate: AnyObject {
    func didConnectSuccessFully()
    func errorWhileSubscribingInService(_ error: ClientError)
    func saveLocalPlayerIdentifier(_ player: Player)
}
