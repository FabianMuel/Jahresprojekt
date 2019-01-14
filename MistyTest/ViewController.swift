//  MistyTest
//
//  Created by Jahresprojekt2017/18 on 08.04.18.
//  Copyright © 2018 Ivo Max Muellner, Gina Schlott, Eiko Eickhoff
// All rights reserved

import Cocoa
import AVFoundation



/*
 Main - connects Code and Storybord
 Sets the menus, commandlists and audiosamples.
 Plays sound on command.
 Updates programm, if a command is recoginized or the timer is up.
 */
class ViewController: NSViewController, NSWindowDelegate, NSSpeechRecognizerDelegate, ORSSerialPortDelegate, FileStalkerDelegate, WindowControllerDelegate {
    
    let window = WindowController()
    
    var speechRecognizer = NSSpeechRecognizer()
    var player = AVAudioPlayer()
    var serialPort = ORSSerialPort(path: "/dev/cu.usbmodem1461")
    var audioIsPlaying = false
    var programIsListening = true

    @IBOutlet var textField: NSTextField!
    
    var sleepTimeSek = 0
    
    var menuCreator = MenuCreator()
    var topLevelMenu = GleimMenu()
    var currentMenu = GleimMenu()
    
    var timer = Timer()
    let timerInterval = 1.0 //TimeOut und reset auf TopLevelMenu in Sekunden (double)
    let soundDelay = 0.4
    
    //let stopCommand = "stop"
    let stopCommandSerial = "0"
    
    let fileStalker = FileStalker(timerInterval: 0.05, filename: "/Applications/MAMP/htdocs/Gleimhaus/personen/file.txt")
    
    
    /*
     Gets serialport for the arduino and creates the menu.
     This includes the menu itself, as well as the commandlists.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.delegate = self
        
        window.delegate = self
        
        
        _ = XmlMenuReader(menuCreator: menuCreator)
        
        let spm = ORSSerialPortManager()
        let s = spm.availablePorts
        for port in s {
            if port.name.contains("usbmodem") {
                serialPort = ORSSerialPort(path: port.path)
                writeToTextWindow("Port-Name: " + port.name)
            }
        }
        serialPort?.delegate=self
        serialPort?.baudRate = 9600
        serialPort?.open()
        
        speechRecognizer?.delegate = self
        /*    while !xml.complete {
         //wait
         } */
        topLevelMenu = menuCreator.getMenu()
        currentMenu = topLevelMenu
        updateSpeechCommands()
        speechRecognizer?.blocksOtherRecognizers = false
        speechRecognizer?.startListening()  //laesst recognizer auf befehle hören
        
        fileStalker.delegate = self
        fileStalker.startStalking() //start listening to file and notify when content changed
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        writeToTextWindow("Fertig geladen!!!")
        playSound(file: "SystemFertigGeladen", ext: "wav")
    }
    
    
    func systemStopp() {
        print("systemStopp")
        Light_Audio_Out()
        exit(0)
    }
    
    
    /*
     Sets the commands of the currently active menu (or submenu).
     */
    func updateSpeechCommands() {
        var newCommands = currentMenu.getSubMenuCommandList()
        newCommands.append(contentsOf: currentMenu.getReturnCommandList())
        //newCommands.append(stopCommand)
        //muss noch entfernd werden, wenn das Projekt abgegeben wird
        speechRecognizer?.commands=newCommands
    }
    
    /*
     Sends the data to the serialport and calls the function to reset the timer.
     */
    func sendDataToSP(commandData: String) {
       
        serialPort?.send(commandData.data(using: .utf8)!)
        
    }
    
    /*
     Put out the light and stop audio
     */
    @objc func Light_Audio_Out(){
        print("Licht aus")
        sendDataToSP(commandData: stopCommandSerial)
        //        if(player.isPlaying) {
        player.stop()
        //        }
        audioIsPlaying = false
    }
    
    /*
     Resets and starts the timer to put out the light and stop audio.
     */
    func resetTimer(_ duration: Double){
        timer.invalidate()
        startTimer(duration)
    }
    
    /*
     Starts a timer, that is needed for going back if the user didn't say anything after a certain time.
     */
    func startTimer(_ duration: Double){
        print("Timer gestartet " + String(duration))
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(Light_Audio_Out), userInfo: nil, repeats: false)
    }
    
    /*
     Calls the function sending the data, if said data was changed.
     Aufruf in FileStalker
     */
    func fileContentChanged(fileSerialCommand serialCommand: String, fileAudio audiofile: String) {
        sendDataToSP(commandData: serialCommand)
        playSound(file: audiofile, ext: "")
    }
    
    
    /*
     Is called when the speechRecognizer hears a known command.
     Resets timer, changes the menu if needed and calls the functions to play the audio.
     */
    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command: String) {
        if audioIsPlaying==false{
            print(command)
            
            for menuElement in currentMenu.getSubMenuList() {
                for elementCommand in menuElement.getOwnCommandList() {
                    if elementCommand == command {
                        if  programIsListening == true && menuElement.getName() == "Bilder schweigt"{
                            programIsListening = false
                            writeToTextWindow("Programm gestoppt")
                            
                            prepareSound(menuElement: menuElement)
                            
                        }else if programIsListening == false && menuElement.getName() == "Bilder sprecht" {
                            programIsListening = true
                            writeToTextWindow("Programm fortgesetzt")
                            
                            prepareSound(menuElement: menuElement)

                        }else if programIsListening == true{
                            
                            self.sendDataToSP(commandData: menuElement.getSerialCommand())
                            
                            prepareSound(menuElement: menuElement)
                            
//                            if menuElement.getSubMenuCommandList().count != 0{
//                                currentMenu = menuElement
//                                updateSpeechCommands()
//                                print("changed")
//                            }
                            
                            writeToTextWindow(command + " --> " + menuElement.getName())
                        }

                        return
                    }
                }
                // ?
                //        for returnCommand in currentMenu.getReturnCommandList(){
                //            if returnCommand == command {
                //                sendDataToSP(commandData: stopCommandSerial)
                //                currentMenu = topLevelMenu
                //                updateSpeechCommands()
                //                resetTimer(1)
                //                return
                //            }
                //        }
                
            }
        }
        else if programIsListening == false{
            programIsListening = true
            writeToTextWindow("Programm wird fortgesetzt")
        }
    }
    
    func prepareSound(menuElement: GleimMenu) {
        let audioFilePath = menuElement.getAudioFilePath()
        if audioFilePath != "" {
            Timer.scheduledTimer(withTimeInterval: soundDelay, repeats: false) { (soundDelay) in
                self.playSound(file: menuElement.getAudioFilePath(), ext: "")
            }
        }
    }
    
    /*
     Plays the audio.
     */
    func playSound(file:String, ext:String) -> Void {
        
        let url = Bundle.main.url(forResource: file, withExtension: ext)!
        
        //print(url)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            //       guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            audioIsPlaying = true
            resetTimer(player.duration-soundDelay);
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
        writeToTextWindow("Arduino getrennt (Port geschlossen)")
    }
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        writeToTextWindow("Arduino verbunden (Port geöffnet)")
    }
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
//        print("Port: \(data)")
    }
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print(error)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    /*
     Backup plan in case the audiolistener doesn't work anymore.
     Plays the sound via keyinput.
     This method is only needed for debugging and testing new things.
     */
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 { //esc Taste
            sendDataToSP(commandData: stopCommandSerial)
            print("esc")
            player.stop()
            resetTimer(1)
        }
    }
    
    /*
     Closes the app, put out light and audio
     */
    @IBAction func closeApp(_ sender: NSButton) {
        Light_Audio_Out()
        exit(0)
    }
    
    func writeToTextWindow(_ str:String){
        var tempText = textField.stringValue
        tempText.append("\n")
        tempText.append(str)
        textField.stringValue = tempText
    }
    
    
    //    func windowShouldClose(_ sender: NSWindow) -> Bool{
    //        print("sollte beenden")
    //        Light_Audio_Out()
    //        exit(0)
    //    }
    
    //    func windowWillClose(notification: NSNotification) {
    //        Light_Audio_Out()
    //        exit(0)
    //    }
    
    //    override func windowDidLoad() {
    //        self.view.window?.delegate = self
    //    }
    
    //    override func viewDidAppear() {
    //        self.view.window?.delegate = self
    //        self.window.delegate = self
    //    }
    
    //    private func windowShouldClose(_ sender: Any) {
    //        print("sollte beenden")
    //        Light_Audio_Out()
    //        exit(0)
    //    }
    
    //    func lichterAlleAus() {
    //        sendDataToSP(commandData: stopCommandSerial)
    //    }
    
    /*
     GERADE NICHT GENUTZT?
     Updates the menu and commands if the menu is reset to main menu.
     */
    //    @objc func resetMenu() {
    //        print("reset commands")
    //        sendDataToSP(commandData: stopCommandSerial)
    //        if(player.isPlaying) {
    //            player.stop()
    //        }
    //        resetTimer(1)
    //        currentMenu = topLevelMenu
    //        updateSpeechCommands()
    //    }
    
    
}

