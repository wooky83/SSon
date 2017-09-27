//
//  Sson.swift
//  NetTest
//
//  Created by baw0803 on 2017. 1. 18..
//  Copyright © 2017년 WookyNim. All rights reserved.
//

/**
 * 지원 타입 = String, String?, Int, Int64, Bool, Array, Array?, Dictionary, Dictionary?, NSArray, NSArray?, NSDictionary, NSDictionary?
 * 사용 금지 타입 = Int?, Int64?, Bool? (Objective-C -> Swift 타입으로 변경시 KVC 에러 발생)
**/

import Foundation

class Sson: NSObject {
    
    private enum SsonConst {
        static let cfBundleExecutable = "CFBundleExecutable"
        static let cMirrorForStr = "Mirror for "
        static let cToken = "<>"
        static let cEmptyStr = ""
        static let kOptional = "Optional"
        static let kString = "String"
        static let kNSNumber = "NSNumber"
        static let kNSArray = "NSArray"
        static let kNSDictionary = "NSDictionary"
        static let kBlank = " "
    }
    
    required override init() {
        super.init()
    }
    
    func fromJson(_ jsonData:Any) -> Sson {
        
        let dicData = jsonData as! NSDictionary
        
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
                    let strArray = valueReflection.description.components(separatedBy: CharacterSet(charactersIn : SsonConst.cToken)).filter { $0.characters.count > 0}.map{ $0.contains(SsonConst.cMirrorForStr) ? $0.replacingOccurrences(of: SsonConst.cMirrorForStr, with: SsonConst.cEmptyStr) : $0 }.filter { self.isContainStrings($0) }
                    
                    if isDictionary(strArray.count) {
                        if let pInstance = getDynamicClass(strArray[0]) {
                            let value = pInstance.fromJson(pValue)
                            self.setValue(value, forKey: memberName)
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
        if !(str.contains(SsonConst.kOptional) || str.contains(SsonConst.kString) || str.contains(SsonConst.kNSNumber) || str.contains(SsonConst.kNSArray) || str.contains(SsonConst.kNSDictionary)) {
            return true
        }
        return false
    }
    
    private func isObjectType(_ type: Any.Type) -> Bool{
        return type == String.self || type == String?.self || type == NSNumber.self || type == NSNumber?.self || type == NSArray.self || type == NSArray?.self || type == NSDictionary.self || type == NSDictionary?.self || type == Int.self || type == Int?.self || type == Int64.self || type == Int64?.self || type == Bool.self || type == Bool?.self
    }
    
    private func classNameParsing(_ fullName: String) -> String {
        let pjName = Bundle.main.object(forInfoDictionaryKey: SsonConst.cfBundleExecutable) as? String ?? ""
        return pjName+"."+fullName
    }
    
}

