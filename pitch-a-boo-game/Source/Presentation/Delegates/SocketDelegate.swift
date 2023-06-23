//
//  SocketDelegate.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation

protocol SocketDelegate: AnyObject {
    func saveChosenPlayer(_ chosenPlayer: ChosenPlayer)
}
