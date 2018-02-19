//
//  Sson.swift
//  Swift JSON
//
//  Created by baw0803 on 2017. 1. 18..
//  Copyright © 2017년 WookyNim. All rights reserved.
//

/**
 * 필수 Variable에 꼭 @objc 붙일것 -> @objc var text: String?  or @objcMembers         (Swift 4.0이상에선 필수)
 * 지원 타입 = String, String?, Int, Int64, Bool, NSArray, NSArray?, NSDictionary, NSDictionary?
 * 사용 금지 타입 = Int?, Int64?, Bool? (Objective-C -> Swift 타입으로 변경시 KVC 에러 발생)
**/

import Foundation

class Sson: NSObject {
    
    private enum SsonConst {
        static let bundleExecutable = "CFBundleExecutable"
        static let mirrorForStr = "Mirror for "
        static let token = "<>"
        static let emptyStr = ""
        static let optional = "Optional"
        static let string = "String"
        static let nSNumber = "NSNumber"
        static let nSArray = "NSArray"
        static let nSDictionary = "NSDictionary"
        static let blank = " "
    }
    
    required override init() {
        super.init()
    }
    
    func fromJson<T>(_ jsonData: T) -> Sson {
        
        guard let dicData = jsonData as? NSDictionary else {return self}
        
        let reflection = Mirror(reflecting: self)
        
        if let superClassMirror = reflection.superclassMirror {
            superClassMirror.children.forEach {
                if let value = dicData[$0.label!] {
                    self.setValue(value, forKey: $0.label!)
                }
            }
        }
        
        reflection.children.filter { $0.label != nil }.forEach {
            let memberName = $0.label!
            
            let valueReflection = Mirror(reflecting: $0.value)
            
            if let pValue = dicData[memberName] {
                
                if self.isObjectType(valueReflection.subjectType){
                    self.setValue(pValue, forKey: memberName)
                }
                else {
                    let strArray = valueReflection.description.components(separatedBy: CharacterSet(charactersIn : SsonConst.token)).filter { !($0.isEmpty)}.map{ $0.contains(SsonConst.mirrorForStr) ? $0.replacingOccurrences(of: SsonConst.mirrorForStr, with: SsonConst.emptyStr) : $0 }.filter { self.isContainStrings($0) }
                    
                    if isDictionary(strArray.count) {
                        if let pInstance = getDynamicClass(strArray[0]) {
                            let value = pInstance.fromJson(pValue)
                            self.setValue(value, forKey: memberName)
                        }
                        else {
                            self.setValue(pValue, forKey: memberName)
                        }
                    }
                    else if isArray(strArray.count){
                        if let pArray = pValue as? NSArray {
                            var newArray = Array<AnyObject>()
                            pArray.forEach {
                                if let pInstance = getDynamicClass(strArray[1]) {
                                    let value = pInstance.fromJson($0)
                                    newArray.append(value as AnyObject)
                                }
                                else {
                                    newArray.append($0 as AnyObject)
                                }
                            }
                            self.setValue(newArray, forKey: memberName)
                        }
                    }
                }
            }
        }
        
        return self
    }
    
    private func isDictionary(_ cnt: Int) -> Bool {
        return cnt == 1
    }
    
    private func isArray(_ cnt: Int) -> Bool {
        return cnt > 1
    }
    
    private func getDynamicClass(_ className : String) -> Sson? {
        let className = classNameParsing(className)
        
        if let dynamicClass = NSClassFromString(className) as? Sson.Type {
            
            let beanClass = dynamicClass.init()
            
            return beanClass
        }
        else {
            return nil
        }
    }
    
    private func isContainStrings(_ str: String) -> Bool{
        if !(str.contains(SsonConst.optional) || str.contains(SsonConst.string) || str.contains(SsonConst.nSNumber) || str.contains(SsonConst.nSArray) || str.contains(SsonConst.nSDictionary)) {
            return true
        }
        return false
    }
    
    private func isObjectType(_ type: Any.Type) -> Bool{
        return type == String.self || type == String?.self || type == NSNumber.self || type == NSNumber?.self || type == NSArray.self || type == NSArray?.self || type == NSDictionary.self || type == NSDictionary?.self || type == Int.self || type == Int64.self || type == Bool.self || type == UInt.self || type == UInt64.self
    }
    
    private func classNameParsing(_ fullName: String) -> String {
        let pjName = Bundle.main.object(forInfoDictionaryKey: SsonConst.bundleExecutable) as? String ?? ""
        return pjName+"."+fullName
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("key(\(key)) is not existence")
    }
    
}

struct DecodingHelper: Decodable {
    private let decoder: Decoder
    
    init(from decoder: Decoder) throws {
        self.decoder = decoder
    }
    
    func decode(to type: Decodable.Type) throws -> Decodable {
        let decodable = try type.init(from: decoder)
        return decodable
    }
}

