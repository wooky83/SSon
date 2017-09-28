//
//  TestModel.swift
//  Sson
//
//  Created by baw0803 on 2017. 9. 28..
//  Copyright © 2017년 wooky83. All rights reserved.
//

import Foundation

class TestModel: Sson {
    @objc var pa: Int = -1
    @objc var pb: Bool = false
    @objc var pc: String = ""
    @objc var pd: String?
    @objc var pe: SubTestModel?
    @objc var pf: [SubTestModel]?
    @objc var pg: NSArray?
}

class SubTestModel: Sson {
    @objc var sa: Int = -1
    @objc var sb: Bool = false
    @objc var sc: String = ""
    @objc var sd: String?
}
