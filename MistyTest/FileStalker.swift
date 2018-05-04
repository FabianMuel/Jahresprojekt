//
//  FileStalker.swift
//  MistyTest
//
//  Created by Jahresprojekt2017/18 on 19.04.18.
//  Copyright © 2018 Ivo Max Muellner. All rights reserved.
//

import Foundation

protocol FileStalkerDelegate {
    func fileContentChanged(didChangeCommand command: String)
}

class FileStalker  {
    
    var delegate : FileStalkerDelegate?
    var lastReadText = "nil"
    var timer = Timer()
    var timerInterval = 0.1 //sek
    var filename = ""
    
    init(timerInterval: Double, filename: String) {
        self.timerInterval = timerInterval
        self.filename = filename
    }
    
    func startStalking(){
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(readFromFile), userInfo: nil, repeats: true)
    }
    
    func stopStalking(){
        timer.invalidate()
    }
    
    @objc private func readFromFile() {
        let fileURL = URL(fileURLWithPath: filename)
        //reading
        do {
            let currentText = try String(contentsOf: fileURL, encoding: .utf8)
           // print("Loaded text: ", currentText)
            if(lastReadText == "nil") {
                lastReadText = currentText
            }
            if lastReadText != currentText {
                lastReadText = currentText
                delegate?.fileContentChanged(didChangeCommand: currentText)
            }
        }
        catch {
            print("reading failed")
        }
        
    }
}

