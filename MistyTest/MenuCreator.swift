//
//  MenuCreator.swift
//  MistyTest
//
//  Created by Jahresprojekt2017/18 on 08.04.18.
//  Copyright © 2018 Mona Holtmann. All rights reserved.
//

import Foundation

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
    
    var topLevelMenu = GleimMenu()
    
    init() {
        topLevelMenu = GleimMenu(name: "TopLevel")
        let gleim = GleimMenu(name: "Gleim")
        let ramler = GleimMenu(name: "Ramler")
        
        gleim.addCommand(command: gleimBegr)
        gleim.setAudioFilePath(path: "Gleim_beg")
        gleim.addReturnCommand(command: karschFrage)
        
        ramler.addCommand(command: ramlerBegr)
        ramler.setAudioFilePath(path: "ramler_beg")
        
        let gleimLek = GleimMenu(name: "GleimLek")
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
    
    public func getIntLevel(i: Int) -> GleimMenu {
        topLevelMenu = GleimMenu(name: "TopLevel")
        let gleim = GleimMenu(name: "Gleim")
        
        gleim.addCommand(command: gleimBegr)
        gleim.setAudioFilePath(path: "Gleim_beg")
     //   gleim.addReturnCommand(command: karschFrage)
        
        for _ in 0...i{
            let gleimLek = GleimMenu(name: "GleimLek")
            gleimLek.addCommand(command: gleimLek1)
            gleimLek.setAudioFilePath(path: "gleimlek")
            gleim.addSubMenuElement(element: gleimLek)
        }
        let gleimKarschFrage = GleimMenu(name: "GleimKarschFrage")
        gleimKarschFrage.addCommand(command: karschFrage)
        gleimKarschFrage.setAudioFilePath(path: "Karsch_end_1")
        gleim.addSubMenuElement(element: gleimKarschFrage)
        
        topLevelMenu.addSubMenuElement(element: gleim)
        
        return topLevelMenu;
    }
}
