//
//  XmlMenuReader.swift
//  MistyTest
//
//  Created by Jahresprojekt2017/18 on 04.05.18.
//  Copyright © 2018 Ivo Max Muellner. All rights reserved.
//

import Foundation

class XmlMenuReader: NSObject, XMLParserDelegate {
    
    private var gleimMenu = GleimMenu()
    private var currentElement = ""
    
    override init(){
        super.init()
        if let path = Bundle.main.url(forResource: "GleimMenuStructure", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "GleimMenu" {
            gleimMenu.setName(name: attributeDict["Name"]!)
        }
    }
    
}
