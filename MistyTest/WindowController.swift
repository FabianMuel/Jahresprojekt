//
//  WindowController.swift
//  MistyTest
//
<<<<<<< HEAD
//  Created by Jahresprojekt2017/18/19 on 16.01.19.
//  Copyright © 2019 Eiko Eickhoff. All rights reserved.
=======
//  Created by Gleimhaus Halberstadt on 05.12.18.
//  Copyright © 2018 Mona Holtmann. All rights reserved.
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
//

import Cocoa

<<<<<<< HEAD
class WindowController: NSWindowController, NSWindowDelegate {
    
    var dele  = ViewController()
    
    override func windowDidLoad() {
//        self.window!.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
//        self.window!.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
        window?.level = .floating   //immer im Vordergrund
     
    }

    
    func windowWillClose(_ notification: Notification) {
        print("Window will close")
        dele.Light_Audio_Out()
    }
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        print("Window should close")
        return true
    }
    func windowDidChangeScreen(_ notification: Notification) {
        print("Window did change screen")
=======
protocol WindowControllerDelegate{
    func systemStopp()
}

class WindowController: NSWindowController, NSWindowDelegate {
    
    var delegate : WindowControllerDelegate?
    override func windowDidLoad() {
        self.window!.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
        self.window!.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
    }
//    func windowShouldClose(sender: NSWindow){
//        print("Window should close")
//        let alert = NSAlert.init()
//        alert.addButton(withTitle: "No")
//        alert.addButton(withTitle: "Yes")
//        alert.informativeText = "Close the window?"
//        let response = alert.runModal()
//        if response == NSApplication.ModalResponse.alertFirstButtonReturn {
//
//        } else {
//
//        }
//    }
    
    func windowWillClose(_ notification: Notification) {
        print("Window will close")
        
        delegate?.systemStopp()
    }
    
    func windowDidChangeScreen(_ notification: Notification) {
        print("Window did change screen")
        

>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
    }
    
}
