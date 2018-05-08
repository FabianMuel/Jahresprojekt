//
//  GleimMenuList.swift
//  MistyTest
//
//  Created by Jahresprojekt2017/18 on 08.04.18.
//  Copyright © 2018 Ivo Max Muellner. All rights reserved.
//

import Foundation

class GleimMenu{
    
    private var subMenuList = [GleimMenu]()
    private var name = ""
    private var audioFilePath = ""
    private var commandList = [String]()
    private var serialCommand = ""
    private var returnCommandList = [String]()
    
    init(name: String, subMenu: Array<GleimMenu>, audioFilePath: String, commandList: Array<String>, serialCommand: String, returnCommandList: Array<String>){
        self.name=name
        self.subMenuList=subMenu
        self.audioFilePath=audioFilePath
        self.commandList=commandList
        self.serialCommand=serialCommand
        self.returnCommandList=returnCommandList
    }
    
    init(name: String){
        self.name=name
    }
    
    init(){
        
    }
    
    public func getSubMenuList() -> Array<GleimMenu> {
        return subMenuList
    }
    
    public func getName() -> String {
        return name
    }
    
    public func getAudioFilePath() -> String {
        return audioFilePath
    }
    
    public func getOwnCommandList() -> Array<String> {
        return commandList
    }
    
    public func getSubMenuCommandList() -> Array<String> {
        var array = [String]()
        for menuElement in subMenuList {
            for command in menuElement.getOwnCommandList() {
                array.append(command)
            }
        }
        return array
    }
    
    public func getSerialCommand() -> String {
        return serialCommand
    }
    
    public func getReturnCommandList() -> Array<String> {
        return returnCommandList
    }
    
    public func setName(name: String) {
        self.name=name
    }
    
    public func setAudioFilePath(path: String){
        audioFilePath=path
    }
    
    public func setCommandList(list: Array<String>){
        commandList=list
    }
    
    public func addCommand(command: String){
        commandList.append(command)
    }
    
    public func addSubMenuElement(element: GleimMenu){
        subMenuList.append(element)
    }
    
    public func setSerialCommand(serialCommand: String) {
        self.serialCommand=serialCommand
    }
    
    public func setReturnCommandList(returnCommandList: Array<String>) {
        self.returnCommandList=returnCommandList
    }
    
    public func addReturnCommand(command: String){
        returnCommandList.append(command)
    }
    
}
