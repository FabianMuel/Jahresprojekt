//
//  MenuCreator.swift
//  MistyTest
//
//  Created by Jahresprojekt2017/18 on 08.04.18.
//  Copyright © 2018 Ivo Max Muellner. All rights reserved.
//

import Foundation

/*
 Creates the menu containing the commands for the portraits and
 the first audiofile that is played when the name of the person is recognized.
 */
class MenuCreator {
    
    var gleimBegr = "Hallo Liebster Gleim"
    var gleimLek1 = "können sie mir etwas über das Thema Lektüre sagen?"
    var gleimLek2 = "können sie mir etwas über das Thema Lektüre erzählen?"
    var gleimPort1 = "können Sie mir auch etwas über Ihr Portrait erzählen?"
    var gleimPort2 = "können Sie mir auch etwas über Ihr Portrait sagen?"
    var gleimJa = "ja ok"
    
    var ramlerBegr = "Herr Ramler"
    var ramlerPort1 = "ich hab gehört sie können mir etwas über ihr Portrait erzählen?"
    var ramlerPort2 = "ich hab gehört sie können mir etwas über ihr Portrait sagen?"
    var ramlerNein = "Nein danke"
    var ramlerFrage = "wie interessant"
    
    var karschBegr = "Frau Karsch sie sind ja auch hier"
    var karschLek1 = "was können sie zum Thema Lektüre sagen?"
    var karschLek2 = "was können sie zum Thema Lektüre erzählen?"
    var karschNein = "nein auf Wiedersehen"
    var karschFrage = "sehr schön"
    
    var stop = "stop"
    
    public var topLevelMenu = GleimMenu()
    
    /*constructor*/
    init() {
        topLevelMenu = GleimMenu(name: "TopLevel")
        var gleim = GleimMenu(name: "Gleim")
        gleim.setSerialCommand(serialCommand: "1")
        var ramler = GleimMenu(name: "Ramler")
        
        gleim.addCommand(command: gleimBegr)
        gleim.setAudioFilePath(path: "Gleim_beg")
        gleim.addReturnCommand(command: karschFrage)
        
        ramler.addCommand(command: ramlerBegr)
        ramler.setAudioFilePath(path: "ramler_beg")
        
        var gleimLek = GleimMenu(name: "GleimLek")
        gleimLek.addCommand(command: gleimLek1)
        gleimLek.addCommand(command: gleimLek2)
        gleimLek.setAudioFilePath(path: "gleimlek")
        
        gleim.addSubMenuElement(element: gleimLek)
        topLevelMenu.addSubMenuElement(element: gleim)
        topLevelMenu.addSubMenuElement(element: ramler)
    }
    
    public func getMenu() -> GleimMenu {
        return topLevelMenu
    }
}
