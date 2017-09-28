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
        
        let jsonString = """
        {
            "pa": 1,
            "pb": true,
            "pc": "hi",
            "pd": "nike",
            "pe": {
            "sa": 3,
            "sb": true,
            "sc": "sub",
            "sd": "type"
            },
            "pf": [{
            "sa": 5,
            "sb": true,
            "sc": "s",
            "sd": "type"
            }, {
            "sa": 6,
            "sb": true,
            "sc": "b",
            "sd": "type"
            }],
             "pg": ["1", "2", "3", "4", "5"]
        }
        """
        let data = jsonString.data(using: .utf8)
        do {
            let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            print(jsonDic)
            let test = TestModel()
            _ = test.fromJson(jsonDic)
        }
        catch let error as NSError {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

