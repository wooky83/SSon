//
//  Sson.swift
//  NetTest
//
//  Created by baw0803 on 2017. 1. 18..
//  Copyright © 2017년 WookyNim. All rights reserved.
//

import Foundation

class Sson : NSObject {
    
    private let cfBundleName = "CFBundleName"
    private let cMirrorForStr = "Mirror for "
    private let cToken = "<>"
    private let cEmptyStr = ""
    private let kOptional = "Optional"
    private let kString = "String"
    private let kNSNumber = "NSNumber"
    private let kNSArray = "NSArray"
    private let kNSDictionary = "NSDictionary"
    
    func fromJson(_ jsonData:Any, classNm:AnyClass) -> Any {
        
        let dicData = jsonData as! NSDictionary
        
        let classIns = classNm as! NSObject.Type
        let dynamicClass = classIns.init()
        
        let reflection = Mirror(reflecting: dynamicClass)
        
        if let superClassMirror = reflection.superclassMirror {
            superClassMirror.children.forEach {
                if let value = dicData[$0.label!] {
                    dynamicClass.setValue(value, forKey: $0.label!)
                }
            }
        }
    
        reflection.children.filter { $0.label != nil }.forEach {
            let memberName = $0.label!
            
            
            let valueReflection = Mirror(reflecting: $0.value)
            
            
            if let pValue = dicData[memberName] {
                
                if self.isObjectType(valueReflection.subjectType) {
                    dynamicClass.setValue(pValue, forKey: memberName)
                }
                else {
                    let strArray = valueReflection.description.components(separatedBy: CharacterSet(charactersIn : cToken)).filter { $0.characters.count > 0}.map{ $0.contains(cMirrorForStr) ? $0.replacingOccurrences(of: cMirrorForStr, with: cEmptyStr) : $0 }.filter { self.isContainStrings($0) }
                    
                    if strArray.count == 1 {
                        let className = self.classNameParsing(strArray[0])
                        if let pInstance = NSClassFromString(className) as? NSObject.Type {
                            let value = self.fromJson(pValue, classNm: pInstance)
                            dynamicClass.setValue(value, forKey: memberName)
                        }
                    }
                    else if strArray.count > 1{
                        if let pArray = pValue as? NSArray {
                            var newArray = Array<AnyObject>()
                            pArray.forEach {
                                let className = self.classNameParsing(strArray[1])
                                if let pInstance = NSClassFromString(className) as? NSObject.Type {
                                    let value = self.fromJson($0, classNm: pInstance)
                                    newArray.append(value as AnyObject)
                                }
                            }
                            dynamicClass.setValue(newArray, forKey: memberName)
                        }
                        
                    }
                }
                
            }
        }
        
        return dynamicClass
    }
    
    func toJson(_ insClass:AnyObject) -> Any {
        
        let dicData = NSMutableDictionary()
        
        let reflection = Mirror(reflecting: insClass)
        
        reflection.children.forEach {
            let memberName = $0.label!
            
            if let pValue = insClass.value(forKey: memberName){
                let className = self.classNameParsing(memberName)
                if let _ = NSClassFromString(className) as? NSObject.Type {
                    let recursiveIns = self.toJson(pValue as AnyObject)
                    dicData[memberName] = recursiveIns
                }
                else {
                    dicData[memberName] = pValue
                }
            }
        }
        
        return dicData
    }
    
    private func isContainStrings(_ str:String) -> Bool{
        if !(str.contains(kOptional) || str.contains(kString) || str.contains(kNSNumber) || str.contains(kNSArray) || str.contains(kNSDictionary)) {
            return true
        }
        return false
    }
    
    private func isObjectType(_ type: Any.Type) -> Bool{
        let isContain = type == String.self || type == String?.self || type == NSNumber.self || type == NSNumber?.self || type == NSArray.self || type == NSArray?.self || type == NSDictionary.self || type == NSDictionary?.self ? true : false
        return isContain
    }
    
    private func classNameParsing(_ fullName : String) -> String {
        let pjName = Bundle.main.object(forInfoDictionaryKey: cfBundleName) as! String
        return pjName.replacingOccurrences(of: " ", with: "_")+"."+fullName
    }
    
}

