//
//  WindowController.swift
//  MistyTest
//
//  Created by Gleimhaus Halberstadt on 05.12.18.
//  Copyright © 2018 Mona Holtmann. All rights reserved.
//

import Cocoa

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
        

    }
    
}
