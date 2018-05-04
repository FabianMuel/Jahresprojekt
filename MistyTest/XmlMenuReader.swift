//
//  XmlMenuReader.swift
//  MistyTest
//
//  Created by Jahresprojekt2017/18 on 04.05.18.
//  Copyright © 2018 Ivo Max Muellner. All rights reserved.
//

import Foundation

class XmlMenuReader: NSObject, XMLParserDelegate {
    
    
    override init(){
        super.init()
        if let path = Bundle.main.url(forResource: "GleimMenuStructure", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    parser
}
