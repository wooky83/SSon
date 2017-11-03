//
//  TestModel.swift
//  Sson
//
//  Created by baw0803 on 2017. 9. 28..
//  Copyright © 2017년 wooky83. All rights reserved.
//

import Foundation

@objcMembers class superModel: Sson {
    var pc: String = ""
}


@objcMembers class TestModel: superModel {
    var pa: Int = -1
    var pb: Bool = false
    //var pc: String = ""
    var pd: String?
    var pe: SubTestModel?
    var pf: [SubTestModel]?
    var pg: NSArray?
}

class SubTestModel: Sson {
    @objc var sa: Int = -1
    @objc var sb: Bool = false
    @objc var sc: String = ""
    @objc var sd: String?
}
