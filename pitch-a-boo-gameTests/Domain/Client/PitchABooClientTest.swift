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
        let (sut, (_, _, _)) = makeSUT()
        XCTAssertFalse(sut.pause)
    }
    
    func test_init_should_initialize_open_false() {
        let (sut, (_, _, _)) = makeSUT()
        XCTAssertFalse(sut.opened)
    }

    func test_defineServerURL_should_change_baseURL_value() {
        let (sut, (_, _, _)) = makeSUT()
        let inputHostname = "testHostname"
        sut.defineServerURL(hostname: inputHostname)
        XCTAssertEqual("ws://\(inputHostname):8080", sut.baseURL)
    }

    func test_subscribeToService_when_open_false_should_open_websocket() {
        let (sut, (socketMock, _, _)) = makeSUT()
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        XCTAssertEqual(socketMock.resumeCalled, 1)
    }

    func test_subscribeToService_when_open_false_should_toggle_the_value() {
        let (sut, (_, _, _)) = makeSUT()
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        XCTAssertTrue(sut.opened)
    }

    func test_subscribeToService_when_opened_shoudnt_open_websocket() {
        let (sut, (socketMock, _, _)) = makeSUT()
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        sut.subscribeToService()
        XCTAssertEqual(socketMock.resumeCalled, 1)
    }

    func test_subscribeToService_when_invalid_url_websocket_should_be_nil() {
        let (sut, (_, _, _)) = makeSUT()
        sut.subscribeToService()
        XCTAssertNil(sut.webSocket)
    }

    func test_subscribeToService_when_websocket_nil_shoudnt_call_receive() {
        let (sut, (socketMock, _, _)) = makeSUT()
        sut.subscribeToService()
        XCTAssertEqual(socketMock.receiveCalled, 0)
    }

    func test_subscribeToService_when_receive_failure_should_call_output() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputError = NSError(domain: "error", code: 1)
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        
        socketMock.receiveCompletionHandler!(.failure(inputError))
        
        XCTAssertEqual(
            outputSpy.receivedMessages,
            [.errorWhileReceivingMessageFromServer(.failWhenReceiveMessage)]
        )
    }

    func test_subscribeToService_when_receive_failure_should_close_websocket() {
        let (sut, (socketMock, _, _)) = makeSUT()
        let inputError = NSError(domain: "error", code: 1)
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.failure(inputError))
        XCTAssertFalse(sut.opened)
    }

    func test_subscribeToService_when_success_should_be_able_to_receive_another_awnser() {
        let (sut, (socketMock, _, _)) = makeSUT()
        let inputData = try! JSONEncoder().encode(
            DTOTransferMessage(
                code: 1,
                device: .coreOS,
                message: Data()
            )
        )
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(socketMock.receiveCalled, 2)
    }
}

extension PitchABooClientTest: Testing {
    typealias SutAndDoubles = (
        sut: PitchABooSocketClient,
        doubles: (
            socketMock: URLSessionWebSocketTaskMock,
            sessionMock: URLSessionMock,
            outputSpy: ClientOutputSpy
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let socketMock = URLSessionWebSocketTaskMock()
        let sessionMock = URLSessionMock(socketMock: socketMock)
        let outputSpy = ClientOutputSpy()
        let client = PitchABooSocketClient()
        client.session = sessionMock
        client.output = outputSpy
        return (client, (socketMock, sessionMock, outputSpy))
    }
}
