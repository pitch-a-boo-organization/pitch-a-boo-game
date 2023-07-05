//
//  Testing.swift
//  pitch-a-boo-gameTests
//
//  Created by Thiago Henrique on 03/07/23.
//

import Foundation

protocol Testing {
    associatedtype SutAndDoubles
    func makeSUT() -> SutAndDoubles
}
