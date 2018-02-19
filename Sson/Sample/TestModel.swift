//
//  TestModel.swift
//  Sson
//
//  Created by baw0803 on 2017. 9. 28..
//  Copyright © 2017년 wooky83. All rights reserved.
//

import Foundation


@objcMembers class SModel: Sson {
    var name: String = ""
    var year: Int = -1
    var hobby: [SSModel]?
}

class SSModel: Sson {
    @objc var kind: String?
    @objc var star: Int = -1
}

struct DModel: Decodable {
    let name: String
    let year: Int
    let hobby: [DSModel]
}

struct DSModel: Decodable {
    let kind: String
    let star: Int
}
