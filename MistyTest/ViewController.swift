//  MistyTest
//
<<<<<<< HEAD
//  Created by Jahresprojekt2017/18/19 on 13.02.2019
//  Copyright © 2019 Ivo Max Muellner, Eiko Eickhoff, Gina Schlott
//  All rights reserved
=======
//  Created by Jahresprojekt2017/18 on 08.04.18.
//  Copyright © 2018 Ivo Max Muellner, Gina Schlott, Eiko Eickhoff
// All rights reserved
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a

import Cocoa
import AVFoundation


<<<<<<< HEAD
=======

>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
/*
 Main - connects Code and Storybord
 Sets the menus, commandlists and audiosamples.
 Plays sound on command.
 Updates programm, if a command is recoginized or the timer is up.
 */
<<<<<<< HEAD
class ViewController: NSViewController, NSWindowDelegate, NSSpeechRecognizerDelegate, ORSSerialPortDelegate, FileStalkerDelegate{
    
    @IBOutlet var textField: NSTextField!
    @IBOutlet var textFieldExtra: NSTextField!
    
    @IBOutlet var statusBild: NSImageCell!
    @IBOutlet var statusTextCell: NSTextFieldCell!
    
    var speechRecognizer = NSSpeechRecognizer()
    var player = AVAudioPlayer()
=======
class ViewController: NSViewController, NSWindowDelegate, NSSpeechRecognizerDelegate, ORSSerialPortDelegate, FileStalkerDelegate, WindowControllerDelegate {
    
    let window = WindowController()
    
    var speechRecognizer = NSSpeechRecognizer()
    var player = AVAudioPlayer()
    var serialPort = ORSSerialPort(path: "/dev/cu.usbmodem1461")
    var audioIsPlaying = false
    var programIsListening = true

    @IBOutlet var textField: NSTextField!
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
    
    var serialPort = ORSSerialPort(path: "/dev/cu.usbmodem1471")
    
    var arduinoConnected = false
    var audioIsPlaying = false
    var isListening = true
    var detectTopics = false
    
    var audioPathPart1 = ""
    var audioPathPart2 = ""
    var audioPathPart3 = ""
    
    var portraits = [[String]]()
    
    var menuCreator = MenuCreator()
    var topLevelMenu = GleimMenu()
    var currentMenu = GleimMenu()
    
    var timer = Timer()
<<<<<<< HEAD
    var timerPause = Timer()
    var timerTopicReset = Timer()
    var tX = Timer()
    let timerInterval = 1.0 //TimeOut und reset auf TopLevelMenu in Sekunden (double)
    let soundDelay = 0.8
    let timerPauseInterval = 900.0 //when nobody said something since 15 min
    let timerTopicInterval = 30.0 //when nobody said a Topic since 30 sec
    
=======
    let timerInterval = 1.0 //TimeOut und reset auf TopLevelMenu in Sekunden (double)
    let soundDelay = 0.4
    
    //let stopCommand = "stop"
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
    let stopCommandSerial = "0"
    
    let fileStalker = FileStalker(timerInterval: 0.05, filename: "/Applications/MAMP/htdocs/Gleimhaus/personen/file.txt")
   
    
    
    /*
     Gets serialport for the arduino and creates the menu.
     This includes the menu itself, as well as the commandlists.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.delegate = self
<<<<<<< HEAD
        view.layer?.zPosition = .greatestFiniteMagnitude
        view.window?.level = .floating
=======
        
        window.delegate = self
        
        
        _ = XmlMenuReader(menuCreator: menuCreator)
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
        
        let spm = ORSSerialPortManager()
        let s = spm.availablePorts
        
        statusAendern(1)
        _ = XmlMenuReader(menuCreator: menuCreator)
        topLevelMenu = menuCreator.getMenu()
        currentMenu = topLevelMenu
        updateSpeechCommands()
        
        for port in s {
            if port.name.contains("usbmodem") {
                serialPort = ORSSerialPort(path: port.path)
<<<<<<< HEAD
                writeToTextExtraWindow("Port-Name: " + port.name)
=======
                writeToTextWindow("Port-Name: " + port.name)
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
            }
        }
        serialPort?.delegate=self
        serialPort?.baudRate = 9600
        serialPort?.open()
        
        speechRecognizer?.delegate = self
<<<<<<< HEAD
=======
        /*    while !xml.complete {
         //wait
         } */
        topLevelMenu = menuCreator.getMenu()
        currentMenu = topLevelMenu
        updateSpeechCommands()
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
        speechRecognizer?.blocksOtherRecognizers = false
        speechRecognizer?.listensInForegroundOnly = false
        speechRecognizer?.startListening()  //laesst recognizer auf befehle hoeren
        
        fileStalker.delegate = self
        fileStalker.startStalking() //start listening to file and notify when content changed
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
<<<<<<< HEAD
        NSEvent.addLocalMonitorForEvents(matching: .keyDown){
            if self.keyDownO(with: $0){
                return nil
            } else {
                return $0
            }
        }
        
        loadPortraits()
        
        //nach 2 sec prüfen ob ardoino angeschlossen ist
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkArduino), userInfo: nil, repeats: false)
        
        startTimerForPause()
        playSound(file: "aktiv", ext: "wav")
        
        
    }


=======
        writeToTextWindow("Fertig geladen!!!")
        playSound(file: "SystemFertigGeladen", ext: "wav")
    }
    
    
    func systemStopp() {
        print("systemStopp")
        Light_Audio_Out()
        exit(0)
    }
    
    
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
    /*
     -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
                                S P R A C H E R K E N N U N G    H A N D L I N G
     -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
     */
<<<<<<< HEAD
   
=======
    func updateSpeechCommands() {
        var newCommands = currentMenu.getSubMenuCommandList()
        newCommands.append(contentsOf: currentMenu.getReturnCommandList())
        //newCommands.append(stopCommand)
        //muss noch entfernd werden, wenn das Projekt abgegeben wird
        speechRecognizer?.commands=newCommands
    }
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
    
    /*
     Is called when the speechRecognizer hears a known command.
     Resets timer, changes the menu if needed and calls the functions to play the audio.
     */
<<<<<<< HEAD
    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command: String) {
        if audioIsPlaying==false{
            for menuElement in currentMenu.getSubMenuList() {
                for elementCommand in menuElement.getOwnCommandList() {
                    if elementCommand == command {
                        
                        // programm pausieren
                        if  isListening == true && menuElement.getName() == "Danke"{
                            isListening = false
                            statusAendern(3)    //Programm pausiert
                            
                            playSound(file:"pause", ext:"wav")  //Pausieren Sound abspielen
//                            prepareSound(menuElement: menuElement)  //Pausieren Sound abspielen
                            timerPause.invalidate() //Timer stoppen
                            detectTopics = false
                            
                        //programm aktivieren
                        }else if isListening == false && menuElement.getName() == "sprecht Bilder" {
                            isListening = true
                            if arduinoConnected{
                                statusAendern(2)
                            }else{
                                statusAendern(4)    // Fehlermeldung anzeigen
                                statusTextCell.stringValue = "Fehler, Arduino getrennt"
                            }
                            playSound(file:"aktiv", ext:"wav")  //Pausieren Sound abspielen
//                            prepareSound(menuElement: menuElement)
                            
                            // neuen timer starten
                            timerPause.invalidate()
                            startTimerForPause()
                        
                        // wenn ein name gesagt wird
                        }else if isListening == true && detectTopics == false && !menuElement.isTopic() || isListening == true && detectTopics == true && !menuElement.isTopic(){
                            
                            // das ist nur für debugging/entwicklung
                            writeToTextWindow(command + " --> " + menuElement.getName())
                            
                            // der audiopfad wird vorbereitet mit den teilen vom Namen des Portraits
                            audioPathPart1 = menuElement.getAudioFilePath()
                            audioPathPart3 = menuElement.getName()
                            
                            // das licht hinter dem Bild an machen
                            self.sendDataToSP(commandData: menuElement.getSerialCommand())
                            
                            // der timer für die programmpausierung wird gestartet
                            timerPause.invalidate()
                            startTimerForPause()
                            
                            detectTopics = true
                            startTopicTimer() // nach gewisser zeit geht dadurch das licht wieder aus
                            
                        // wenn ein portrait an ist und ein thema gesagt wird
                        }else if isListening == true && detectTopics == true && menuElement.isTopic(){
                            
                            // das kommando wird im fenster ausgegeben
                            writeToTextWindow("^ " + command + " --> " + menuElement.getName())
                            
                            stopTopicTimer()
                            
                            // der audiopfad wird zusammengesetzt und abgespielt
                            
                            Timer.scheduledTimer(withTimeInterval: soundDelay, repeats: false) { (soundDelay) in
                                self.playSound(file: self.audioPathPart1 + menuElement.getAudioFilePath() + self.audioPathPart3 , ext: "")
                            }
      
                            
                            // der timer wird neu gestartet
                            timerPause.invalidate()
                            startTimerForPause()
                            
                        // wenn thema gesagt wird, ohne dass ein portrait aktiv ist
                        }else if isListening == true && detectTopics == false && menuElement.isTopic(){
                            
//                            // nur bei bedarf aktivierbar
//
//                            // zufällig wird ein portrait ausgewählt, daten ausgelesen und gespeichert
//                            let randName = portraits[Int(arc4random_uniform(UInt32(portraits.count)))]
//                            audioPathPart1 = randName[0]
//                            audioPathPart2 = menuElement.getAudioFilePath()
//                            audioPathPart3 = randName[1]
//
//                            // gibt den befehl in das ausgabe fenster
//                            writeToTextWindow(command + " --> " + menuElement.getName() + " - " + audioPathPart3)
//
//                            // licht wird an gemacht
//                            self.sendDataToSP(commandData: randName[2])
//
//                            // timer werden neu gestartet
//                            timerPause.invalidate()
//                            startTimerForPause()
//                            startTopicTimer()
//
//                            // audio pfad wird zusammengesetzt und abgespielt
//                            Timer.scheduledTimer(withTimeInterval: soundDelay, repeats: false) { (soundDelay) in
//                                self.playSound(file: self.audioPathPart1 + self.audioPathPart2 + self.audioPathPart3 + ".wav", ext: "")
//
//                            }
//                            timerPause.invalidate()
//                            startTimerForPause()
//
                        }
                        
                        if menuElement.getSubMenuCommandList().count != 0{
                            currentMenu = menuElement
                            updateSpeechCommands()
                            print("changed")
                        }
                        return
                    }
                }
            }
        }
=======
    func sendDataToSP(commandData: String) {
       
        serialPort?.send(commandData.data(using: .utf8)!)
        
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
    }
    
    
    
    
    /*
<<<<<<< HEAD
     Turn off the light and stop audio
     */
    @objc func Light_Audio_Out(){
        sendDataToSP(commandData: stopCommandSerial)
        if audioIsPlaying {
            player.stop()
        }
        writeToTextExtraWindow("lightsOut")
        audioIsPlaying = false
        detectTopics = false
=======
     Put out the light and stop audio
     */
    @objc func Light_Audio_Out(){
        print("Licht aus")
        sendDataToSP(commandData: stopCommandSerial)
        //        if(player.isPlaying) {
        player.stop()
        //        }
        audioIsPlaying = false
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
    }

    
    /*
<<<<<<< HEAD
     -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
                                                A U D I O    S T U F F
     -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
     */
    
    /*
     stop audio
     */
    @objc func Audio_Out(){
        if audioIsPlaying {
            player.stop()
        }
        audioIsPlaying = false
        startTopicTimer()
    }
    
    /*
     Plays the audio.
     */
    func playSound(file:String, ext:String) -> Void {
        //writeToTextExtraWindow("play file: \""+file+"\"")
        if file == "stop"{
            player.stop()
            resetTimer(1)
        }
        
        let url = URL(fileURLWithPath: NSHomeDirectory()+"/Desktop/Gleim300Assets/"+file+".wav")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
            audioIsPlaying = true
//            resetTimer(player.duration);  licht soll nach thema nicht aus gehen!
            resetTimerAudio(player.duration)
        } catch let error {
            print(error.localizedDescription)
        }
=======
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
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
    }
    

    /*
     -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
                            A R D U I N O    &     L I G H T   H A N D L I N G
     -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
     */
    
    /*
     Turn off the light
     */
<<<<<<< HEAD
    @objc func Light_Out(){
        sendDataToSP(commandData: stopCommandSerial)
        writeToTextExtraWindow("lightsOut")
        startTopicTimer()
    }
    
    
    @objc func checkArduino(){
        if arduinoConnected {
            statusAendern(2)
        } else {
            writeToTextExtraWindow("Arduino getrennt (Port geschlossen)")
            statusAendern(4)
=======
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
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
        }
    }
    
    /*
     Sends the data to the serialport and calls the function to reset the timer.
     */
    func sendDataToSP(commandData: String) {
        serialPort?.send(commandData.data(using: .utf8)!)
    }
    
    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
<<<<<<< HEAD
        writeToTextExtraWindow("Arduino getrennt (Port geschlossen)")
        arduinoConnected = false
        statusAendern(4)
        statusTextCell.stringValue = "Fehler, Arduino getrennt"
    }
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        writeToTextExtraWindow("Arduino verbunden (Port geöffnet)")
        arduinoConnected = true
        statusAendern(2)
    }
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
//        writeToTextWindow("Port: \(data)")
=======
        writeToTextWindow("Arduino getrennt (Port geschlossen)")
    }
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        writeToTextWindow("Arduino verbunden (Port geöffnet)")
    }
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
//        print("Port: \(data)")
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
    }
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print(error)
    }
    
<<<<<<< HEAD
    
    /*
     -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
                                        T I M E R    G E S C H I C H T E N
     -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
     */
    
    
    /*
     Starts a timer, that is needed for going back if the user didn't say anything after a certain time.
     */
    func startTimerForPause(){
        timerPause = Timer.scheduledTimer(timeInterval: timerPauseInterval, target: self, selector: #selector(programPause), userInfo: nil, repeats: false)
    }
    
    @objc func programPause(){
        isListening = false
        writeToTextExtraWindow("Pause")
        statusAendern(3)
        playSound(file: "programmHoertNicht", ext: "wav")
    }
    
    
    /*
     Resets and starts the timer to turn off the light and stop audio.
     */
    func resetTimer(_ duration: Double){
        timer.invalidate()
        startTimer(duration)
    }
    func resetTimerAudio(_ duration: Double){
        timer.invalidate()
        startTimerAudio(duration)
    }
    /*
     Starts a timer, that is needed for pause if the user didn't say anything after a certain time.
     */
    func startTimer(_ duration: Double){
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(Light_Audio_Out), userInfo: nil, repeats: false)
    }
    /*
     Starts a timer, that is needed for pause if the user didn't say anything after a certain time.
     */
    func startTimerAudio(_ duration: Double){
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(Audio_Out), userInfo: nil, repeats: false)
    }
    /*
     Starts a timer, that is needed for going back in the menu structure if the user didn't say anything after a certain time.
     
     */
    func startTopicTimer(){
        stopTopicTimer()
        timerTopicReset = Timer.scheduledTimer(timeInterval: timerTopicInterval, target: self, selector: #selector(Light_Audio_Out), userInfo: nil, repeats: false)
    }
    func stopTopicTimer(){
        timerTopicReset.invalidate()
    }
//    //debugging timer
//    func intervalShowTimer(){
//        tX = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(showTimer), userInfo: nil, repeats: true)
//    }
//    @objc func showTimer(){
//        writeToTextExtraWindow(String(Int(timerPause.fireDate.timeIntervalSince(Date()))))
//    }
    
    
    
    
    /*
     -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
                                Ausgabe Fenster - key input - sonstiges
     -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
    */
    
    var temp = ""
=======
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
    /*
     Backup plan in case the audiolistener doesn't work anymore.
     Plays the sound via keyinput.
     This method is only needed for debugging and testing new things.
     */
<<<<<<< HEAD
    func keyDownO(with event: NSEvent) -> Bool{
        if event.keyCode == 53 || event.keyCode == 116 || event.keyCode == 121 || (event.keyCode != 49 && event.keyCode != 36){ //esc Taste
            Audio_Out()
        }

        //leertaste
        if event.keyCode == 49{
            if isListening {
                isListening = false
                statusAendern(3)    //Programm pausiert
                playSound(file:"pause", ext:"wav")  //Pausieren Sound abspielen
                timerPause.invalidate() //Timer stoppen
                detectTopics = false
            } else {
                isListening = true
                if arduinoConnected{
                    statusAendern(2)
                }else{
                    statusAendern(4)    // Fehlermeldung anzeigen
                    statusTextCell.stringValue = "Fehler, Arduino getrennt"
                }
                playSound(file:"aktiv", ext:"wav")
                timerPause.invalidate()
                startTimerForPause()
            }
        }
        
        if event.keyCode == 18 { temp.append("1") }
        if event.keyCode == 19 { temp.append("2") }
        if event.keyCode == 20 { temp.append("3") }
        if event.keyCode == 21 { temp.append("4") }
        if event.keyCode == 23 { temp.append("5") }
        if event.keyCode == 22 { temp.append("6") }
        if event.keyCode == 26 { temp.append("7") }
        if event.keyCode == 28 { temp.append("8") }
        if event.keyCode == 25 { temp.append("9") }
        if event.keyCode == 29 { temp.append("0") }
        if event.keyCode == 36 {
            sendDataToSP(commandData: temp)
            writeToTextExtraWindow("to ardoino: " + temp)
            temp = ""
        }
        

        if event.keyCode == 12 { // q taste zum testen
//            sendDataToSP(commandData: "34")
            
                restartProgram()
           
        }
        
        return true
    }
    
    /*
     writes Text to Window (oben)
     */
    func writeToTextWindow(_ str:String){
        var tempText = textField.stringValue
        tempText.append("\n")
        tempText.append(str)
        textField.stringValue = tempText
    }
    
    /*
     writes Text to extra output Window (unten)
     */
    func writeToTextExtraWindow(_ str:String){
        var tempText = textFieldExtra.stringValue
        tempText.append("\n")
        tempText.append(str)
        textFieldExtra.stringValue = tempText
    }
    
    
    /*
        wenn fehler sind werden sie oben im fenster angezeigt und der punkt ändert die farbe
     */
    func statusAendern(_ int:NSInteger){
        if int==1{
            statusTextCell.stringValue = "Programm wird gestartet"
            statusBild.image = NSImage(named: NSImage.Name(rawValue: "NSStatusPartiallyAvailable"))
        } else if int==2{
            statusTextCell.stringValue = "Programm läuft"
            statusBild.image = NSImage(named: NSImage.Name(rawValue: "NSStatusAvailable"))
        } else if int==3{
            statusTextCell.stringValue = "Programm pausiert"
            statusBild.image = NSImage(named: NSImage.Name(rawValue: "NSStatusPartiallyAvailable"))
        } else {
            statusTextCell.stringValue = "Fehler"
            statusBild.image = NSImage(named: NSImage.Name(rawValue: "NSStatusUnavailable"))
        }
    }

    /*
     läd alle portraits in ein array, wichtig für zufallswiedergabe
     */
    func loadPortraits(){
        // es wird auf das top level verwiesen
        topLevelMenu = menuCreator.getMenu()
        currentMenu = topLevelMenu
        
        // in einem array werden alle namen mit infos gespeichert
        for menuElement in currentMenu.getSubMenuList() {
            if !menuElement.isTopic() && !menuElement.isPause() {
                portraits.append([menuElement.getAudioFilePath(),menuElement.getName(),String(menuElement.getSerialCommand())])
            }
=======
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 { //esc Taste
            sendDataToSP(commandData: stopCommandSerial)
            print("esc")
            player.stop()
            resetTimer(1)
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a
        }
    }
    
    /*
<<<<<<< HEAD
     Calls the function sending the data, if said data was changed.
     Aufruf in FileStalker
     */
    func fileContentChanged(fileSerialCommand serialCommand: String, fileAudio audiofile: String) {
        sendDataToSP(commandData: serialCommand)
        playSound(file: audiofile, ext: "")
    }
    
    /*
     Sets the commands of the currently active menu (or submenu).
     */
    func updateSpeechCommands() {
        var newCommands = currentMenu.getSubMenuCommandList()
        newCommands.append(contentsOf: currentMenu.getReturnCommandList())
        speechRecognizer?.commands=newCommands
    }
    
    func restartProgram(){
        // does nothing
    }
    
    
    
    /*
     Closes the app, put out light and audio
     */
    @IBAction func closeApp(_ sender: NSButton) {
        sendDataToSP(commandData: stopCommandSerial)
        exit(0)
    }
    
    func systemStopp() {
        Light_Audio_Out()
        exit(0)
    }
=======
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
>>>>>>> 1dc483a5da9928c4bc560be69a26411895c6ef8a

    
}
