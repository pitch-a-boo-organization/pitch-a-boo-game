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
        let (sut, (_, _)) = makeSUT()
        XCTAssertFalse(sut.pause)
    }
    
    func test_init_should_initialize_open_false() {
        let (sut, (_, _)) = makeSUT()
        XCTAssertFalse(sut.opened)
    }
    
    func test_defineServerURL_should_change_baseURL_value() {
        let (sut, (_, _)) = makeSUT()
        let inputHostname = "testHostname"
        sut.defineServerURL(hostname: inputHostname)
        XCTAssertEqual("ws://\(inputHostname):8080", sut.baseURL)
    }
    
    func test_subscribeToService_should_open_websocket() {
        let (sut, (socketMock, _)) = makeSUT()
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        XCTAssertEqual(socketMock.resumeCalled, 1)
    }
}

extension PitchABooClientTest: Testing {
    typealias SutAndDoubles = (
        sut: PitchABooSocketClient,
        doubles: (
            socketMock: URLSessionWebSocketTaskMock,
            sessionMock: URLSessionMock
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let socketMock = URLSessionWebSocketTaskMock()
        let sessionMock = URLSessionMock(socketMock: socketMock)
        let client = PitchABooSocketClient()
        client.session = sessionMock
        return (client, (socketMock, sessionMock))
    }
}
