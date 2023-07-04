//
//  TvOSViewModelTests.swift
//  pitch-a-boo-gameTests
//
//  Created by Joan Wilson Oliveira on 26/06/23.
//

import XCTest
@testable import pitch_a_boo_game
@testable import PitchABooServer

final class TvOSViewModelTests: XCTestCase {
    
    var sut: TvOSViewModel?

    override func setUp() {
        sut = TvOSViewModel()
    }

    override func tearDown() {
        sut = nil
    }

//    func test_rewardBonusToSeller_ShouldReturnTrue() {
//        let item = PitchABooServer.Item(id: 0, name: "sda", value: 5, characteristc: .dumb)
//        let sellerPlayer = PitchABooServer.Player.createAnUndefinedPlayer()
//        let result = sut?.rewardBonustoSeller(item: item, buyer: sellerPlayer)
//        XCTAssertEqual(result, true)
//    }
//    
//    func test_rewardBonusToSeller_ShouldReturnFalse() {
//        let item = PitchABooServer.Item(id: 0, name: "sda", value: 5, characteristc: .athletic)
//        let sellerPlayer = PitchABooServer.Player.createAnUndefinedPlayer()
//        let result = sut?.rewardBonustoSeller(item: item, buyer: sellerPlayer)
//        XCTAssertEqual(result, false)
//    }

}
