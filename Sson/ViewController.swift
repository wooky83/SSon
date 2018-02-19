//
//  ViewController.swift
//  Sson
//
//  Created by wooy83 on 2017. 2. 8..
//  Copyright © 2017년 wooky83. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let data = makeTestJosn()
        
        print(String(describing: testJson(data, model: DModel.self)))
        print(String(describing: testJson(data, model: SModel.self)))
    }
    
    private func testJson<T>(_ data: Data, model: T.Type) -> T?  {
        do {
            if let md = model as? Decodable.Type {
                let decodingHelper = try JSONDecoder().decode(DecodingHelper.self, from: data)
                let decodable = try decodingHelper.decode(to: md)
                return decodable as? T
            }
            else if let md = model as? Sson.Type{
                let jsonDic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                let test = md.init()
                _ = test.fromJson(jsonDic)
                return test as? T
            }
        }
        catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    private func makeTestJosn() -> Data{
        let jsonString = """
        {
            "name": "kwon",
            "year": 1983,
            "hobby": [{
                "kind": "baseball",
                "star": 9
                }, {
                "kind": "snowboard",
                "star": 7
            }]
        }
        """
        return jsonString.data(using: .utf8) ?? Data()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

