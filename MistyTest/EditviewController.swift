//
//  EditviewController.swift
//  MistyTest
//
//  Created by LocalAdmin on 09.04.18.
//  Copyright © 2018 Mona Holtmann. All rights reserved.
//

import Cocoa

class EditviewController: NSViewController {
    
    //Outlets
    @IBOutlet var SegBn_Portrait_Thema: NSSegmentedControl!
    @IBOutlet var Editview_Portrait: NSTextField!
    @IBOutlet var Spinner_Portrait: NSPopUpButton!
    @IBOutlet var Wav_Name: NSTextField!
    @IBOutlet var Spinner_Submenu: NSPopUpButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        Spinner_Portrait.isHidden = true
        
        Spinner_Portrait.removeAllItems()
        Spinner_Portrait.addItems(withTitles: ["Cooler Typ 0", "Cooler Typ 1", "Cooler Typ 2"])
        
        Spinner_Submenu.removeAllItems()
        Spinner_Submenu.addItems(withTitles: ["Cooles Thema 0", "Cooles Thema 1", "Cooles Thema 2"])
    }
    
    //Button actions
    @IBAction func SegBn_Portrait_Thema_OnClick(_ sender: Any) {
        switch SegBn_Portrait_Thema.selectedSegment{
        case 0:
            Spinner_Portrait.isEnabled = false
            Spinner_Portrait.isHidden = true
            Editview_Portrait.isEditable = true
            Editview_Portrait.isHidden = false
        case 1:
            Editview_Portrait.isEditable = false
            Editview_Portrait.isHidden = true
            Spinner_Portrait.isEnabled = true
            Spinner_Portrait.isHidden = false
        default:
            print("default case, Segmented Button PORTRAIT THEMA")
        }
    }
    
    @IBAction func Bn_SelectWav_OnClick(_ sender: Any) {
        Wav_Name.stringValue = "Wav_Name"
        //audiopicker
    }
    
    @IBAction func Bn_Save_OnClick(_ sender: Any) {
    }
    
}
