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
        let inputData = generateDummyTransferMessage()
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(socketMock.receiveCalled, 2)
    }
    
    func test_subscribeToService_when_not_receive_a_data_should_handle_correct_error() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputString = ""
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.string(inputString)))
        XCTAssertEqual(
            outputSpy.receivedMessages,
            [.errorWhileReceivingMessageFromServer(.unableToDecode)]
        )
    }
    
    func test_subscribeToService_when_not_receive_a_transfer_message_should_throw_error() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputData = Data()
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(
            outputSpy.receivedMessages,
            [.errorWhileReceivingMessageFromServer(.unableToDecode)]
        )
    }
    
    func test_handleMessageFromServer_when_receive_a_player_identifier_should_call_output_correctly() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputPlayer = Player.createAnUndefinedPlayer()
        let inputData = generatePlayerIdentifierMessage(inputPlayer)
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(outputSpy.receivedMessages, [.saveLocalPlayerIdentifier(inputPlayer)])
    }
    
    func test_handleMessageFromServer_when_receive_a_incorrect_player_identifier_should_call_output() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputData = try! JSONEncoder().encode(
            DTOTransferMessage(
                code: CommandCode.ServerMessage.playerIdentifier.rawValue,
                device: .coreOS,
                message: Data()
            )
        )
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(outputSpy.receivedMessages, [.errorWhileReceivingMessageFromServer(.unableToDecode)])
    }
    
    func test_handleMessageFromServer_when_receive_a_choosen_player_should_call_output_correctly() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputPlayer = Player.createAnUndefinedPlayer()
        let inputItem = Item.availableItems.first!
        let inputData = generateChoosePlayer(inputPlayer, inputItem)
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(
            outputSpy.receivedMessages,
            [.saveChosenPlayer(ChosenPlayer(player: inputPlayer, sellingItem: inputItem))]
        )
    }
    
    func test_handleMessageFromServer_when_receive_a_incorrect_choosen_player_should_call_output_correctly() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputData = try! JSONEncoder().encode(
            DTOTransferMessage(
                code: CommandCode.ServerMessage.chosenPlayer.rawValue,
                device: .coreOS,
                message: Data()
            )
        )
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(
            outputSpy.receivedMessages,
            [.errorWhileReceivingMessageFromServer(.unableToDecode)]
        )
    }
    
    func test_handleMessageFromServer_when_receive_a_start_process_should_call_output_with_correct_state() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputStage = 31
        let inputData = generateStartProcessMessage(inputStage)
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(
            outputSpy.receivedMessages,
            [.didUpdateStage(inputStage)]
        )
    }
    
    func test_handleMessageFromServer_when_receive_a_incorrect_start_process_should_call_output_with_correct_state() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputData = try! JSONEncoder().encode(
            DTOTransferMessage(
                code: CommandCode.ServerMessage.startProcess.rawValue,
                device: .coreOS,
                message: Data()
            )
        )
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(
            outputSpy.receivedMessages,
            [.errorWhileReceivingMessageFromServer(.unableToDecode)]
        )
    }

    func test_handleMessageFromServer_when_receive_a_sale_result_should_call_output_correctly() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputResult = SaleResult(
            item: Item.availableItems.first!,
            soldValue: 3,
            seller: .createAnUndefinedPlayer(),
            buyer: .createAnUndefinedPlayer()
        )
        let inputData = generateSaleResultMessage(inputResult)
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(
            outputSpy.receivedMessages,
            [.didFinishInning(result: inputResult)]
        )
    }
    
    func test_handleMessageFromServer_when_receive_a_incorrect_sale_result_should_call_output_correctly() {
        let (sut, (socketMock, _, outputSpy)) = makeSUT()
        let inputData = try! JSONEncoder().encode(
            DTOTransferMessage(
                code: CommandCode.ServerMessage.saleResult.rawValue,
                device: .coreOS,
                message: Data()
            )
        )
        sut.defineServerURL(hostname: "hostname")
        sut.subscribeToService()
        socketMock.receiveCompletionHandler!(.success(.data(inputData)))
        XCTAssertEqual(
            outputSpy.receivedMessages,
            [.errorWhileReceivingMessageFromServer(.unableToDecode)]
        )
    }
}

extension PitchABooClientTest {
    func generateDummyTransferMessage() -> Data {
        return try! JSONEncoder().encode(
            DTOTransferMessage(
                code: 1,
                device: .coreOS,
                message: Data()
            )
        )
    }
    
    func generatePlayerIdentifierMessage(_ inputPlayer: Player) -> Data {
        return try! JSONEncoder().encode(
            DTOTransferMessage(
                code: CommandCode.ServerMessage.playerIdentifier.rawValue,
                device: .coreOS,
                message: try! JSONEncoder().encode(
                    DTOPlayerIdentifier(stage: 10, player: inputPlayer)
                )
            )
        )
    }
    
    func generateChoosePlayer(_ inputPlayer: Player, _ inputItem: Item) -> Data {
        return try! JSONEncoder().encode(
            DTOTransferMessage(
                code: CommandCode.ServerMessage.chosenPlayer.rawValue,
                device: .coreOS,
                message: try! JSONEncoder().encode(
                    DTOChosenPlayer(stage: 31, player: inputPlayer, item: inputItem)
                )
            )
        )
    }
    
    func generateStartProcessMessage(_ inputStage: Int) -> Data {
        return try! JSONEncoder().encode(
            DTOTransferMessage(
                code: CommandCode.ServerMessage.startProcess.rawValue,
                device: .coreOS,
                message: try! JSONEncoder().encode(
                    DTOStartProcess(stage: inputStage, start: true)
                )
            )
        )
    }
    
    func generateSaleResultMessage(_ inputResult: SaleResult) -> Data {
        return try! JSONEncoder().encode(
            DTOTransferMessage(
                code: CommandCode.ServerMessage.saleResult.rawValue,
                device: .coreOS,
                message: try! JSONEncoder().encode(
                    DTOSaleResult(
                        stage: 35,
                        players: [],
                        gameEnded: false,
                        result: inputResult
                    )
                )
            )
        )
    }
}

extension PitchABooClientTest: Testing {
    typealias SutAndDoubles = (
        sut: PitchABooSocketClient,
        doubles: (
            socketMock: URLSessionWebSocketTaskMock,
            sessionMock: URLSessionStub,
            outputSpy: ClientOutputSpy
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let socketMock = URLSessionWebSocketTaskMock()
        let sessionMock = URLSessionStub(socketMock: socketMock)
        let outputSpy = ClientOutputSpy()
        let client = PitchABooSocketClient()
        client.session = sessionMock
        client.output = outputSpy
        return (client, (socketMock, sessionMock, outputSpy))
    }
}
