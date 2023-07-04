//
//  PitchABooClientTest.swift
//  pitch-a-boo-gameTests
//
//  Created by Thiago Henrique on 03/07/23.
//
// 
import XCTest
@testable import pitch_a_boo_game

final class PitchABooClientTest: XCTestCase {
    func test_init_should_initialize_pause_false() {
        let sut = makeSUT()
        XCTAssertFalse(sut.pause)
    }
    
    func test_init_should_initialize_open_false() {
        let sut = makeSUT()
        XCTAssertFalse(sut.opened)
    }
    
    func test_defineServerURL_should_change_baseURL_value() {
        let sut = makeSUT()
        let inputHostname = "testHostname"
        sut.defineServerURL(hostname: inputHostname)
        XCTAssertEqual("ws://\(inputHostname):8080", sut.baseURL)
    }
}

extension PitchABooClientTest: Testing {
    typealias SutAndDoubles = PitchABooSocketClient
    
    func makeSUT() -> SutAndDoubles {
        let client = PitchABooSocketClient()
        return client
    }
}
