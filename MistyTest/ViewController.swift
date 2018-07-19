import Cocoa
import AVFoundation
/*
 Main - connects Code and Storybord
 Sets the menus, commandlists and audiosamples.
 Plays sound on command.
 Updates programm, if a command is recoginized or the timer is up.
 */
class ViewController: NSViewController, NSSpeechRecognizerDelegate, ORSSerialPortDelegate, FileStalkerDelegate {

    var speechRecognizer = NSSpeechRecognizer()
    var player = AVAudioPlayer()
    var serialPort = ORSSerialPort(path: "/dev/cu.usbmodem14111")
    
    var sleepTimeSek = 0
    
    var menuCreator = MenuCreator()
    var topLevelMenu = GleimMenu()
    var currentMenu = GleimMenu()
    
    var timer = Timer()
    let timerInterval = 120.0 //TimeOut und reset auf TopLevelMenu in Sekunden (double)
    
    let stopCommand = "stop"
    let stopCommandSerial = "4"
    
    let fileStalker = FileStalker(timerInterval: 0.1, filename: "/Applications/MAMP/htdocs/Gleimhaus/personen/file.txt")
    
    /*
     Gets serialport for the arduino and creates the menu.
     This includes the menu itself, as well as the commandlists.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xml = XmlMenuReader(menuCreator: menuCreator)
        
        let spm = ORSSerialPortManager()
        let s = spm.availablePorts
        for port in s {
            print("Name: ", port.name)
            if port.name.contains("usbmodem") {
                serialPort = ORSSerialPort(path: port.path)
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
    }
    
    /*
     Sets the commands of the currently active menu (or submenu).
     */
    func updateSpeechCommands() {
        var newCommands = currentMenu.getSubMenuCommandList()
        newCommands.append(contentsOf: currentMenu.getReturnCommandList())
        newCommands.append(stopCommand)
        speechRecognizer?.commands=newCommands
    }
    
    /*
     Sends the data to the serialport and calls the function to reset the timer.
     */
    func sendDataToSP(commandData: String) {
        serialPort?.send(commandData.data(using: .utf8)!)
    //    resetTimer()
    }
    
    /*
     Updates the menu and commands if the menu is reset to main menu.
     */
    @objc func resetMenu() {
        print("reset commands")
        currentMenu = topLevelMenu
        updateSpeechCommands()
    }
    
    /*
     Starts a timer, that is needed for going back if the user didn't say anything after a certain time.
     */
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(resetMenu), userInfo: nil, repeats: true)
    }
    
    /*
     Resets the timer needed for going back automaticly.
     */
    func resetTimer(){
        timer.invalidate()
        startTimer()
    }
    
    /*
     Calls the function sending the data, if said data was changed.
     */
    func fileContentChanged(fileSerialCommand serialCommand: String, fileAudio audiofile: String) {
        sendDataToSP(commandData: serialCommand)
        if audiofile != stopCommand {
            playSound(file: audiofile, ext: "")
        } else if player.isPlaying {
            player.stop()
        }
		resetTimer()
    }
    
    
    /*
     Is called when the speechRecognizer hears a known command.
     Resets timer, changes the menu if needed and calls the functions to play the audio.
     */
    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command: String) {
        print(command)
        if command == stopCommand {
            sendDataToSP(commandData: stopCommandSerial)
            if(player.isPlaying) {
                player.stop()
            }
            resetTimer()
            return
        }
        
        for returnCommand in currentMenu.getReturnCommandList(){
            if returnCommand == command {
                sendDataToSP(commandData: stopCommandSerial)
                currentMenu = topLevelMenu
                updateSpeechCommands()
                resetTimer()
                return
            }
        }
        
        for menuElement in currentMenu.getSubMenuList() {
            for elementCommand in menuElement.getOwnCommandList() {
                if elementCommand == command {
                    sendDataToSP(commandData: menuElement.getSerialCommand())
                    
                    let audioFilePath = menuElement.getAudioFilePath()
                    if audioFilePath != "" {
                        playSound(file: menuElement.getAudioFilePath(), ext: "")
                    }
            
                    if menuElement.getSubMenuCommandList().count != 0{
                        currentMenu = menuElement
                        updateSpeechCommands()
                        print("changed")
                    }
                    resetTimer()
                    return
                }
            }
        }
    }
    
    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
        
    }
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        print("Port opened")
    }
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        print(data)
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
    override func keyDown(with event: NSEvent) { //Backup Plan
        if event.keyCode == 18 {
            let data = "1".data(using: .utf8)
            serialPort?.send(data!)
            
            playSound(file: "Gleim_beg", ext: "wav")
            print("ich bin gleim")
        }
        if event.keyCode == 19 {
            playSound(file: "gleimlek", ext: "wav")
            print("gleim lektüre")
        }
        if event.keyCode == 20 {
            playSound(file: "Gleim_verweis", ext: "wav")
            print("gleim portrait")
        }
        if event.keyCode == 21 {
            playSound(file: "Gleim_end", ext: "wav")
            let data = "2".data(using: .utf8) //Schalte Ramler-lampe an
            serialPort?.send(data!)
            print("gleim ja")
        }
        if event.keyCode == 23 {
            //      let data = "2".data(using: .utf8)
            //       serialPort?.send(data!)
            playSound(file: "ramler_beg", ext: "wav")
            print("ramler begr")
        }
        if event.keyCode == 26 {
            playSound(file: "ramler_frage", ext: "wav")
            
            print("ramler frage")
        }
        if event.keyCode == 22 {
            playSound(file: "ramlerport", ext: "wav")
            print("ramler portrait")
        }
        if event.keyCode == 28 {
            playSound(file: "Ramler_end", ext: "wav")
            let data = "4".data(using: .utf8) //Schalte Lampen aus
            serialPort?.send(data!)
            print("ramler nein")
        }
        if event.keyCode == 25 {
            let data = "3".data(using: .utf8)
            serialPort?.send(data!)
            playSound(file: "Karsch_beg", ext: "wav")
            print("karsch begr")
        }
        if event.keyCode == 29 {
            playSound(file: "KarschLek", ext: "wav")
            print("karsch lek")
        }
        if event.keyCode == 27 {
            playSound(file: "Karsch_frage", ext: "wav")
            print("karsch frage")
        }
        if event.keyCode == 24 {
            playSound(file: "Karsch_end_1", ext: "wav")
            let data = "4".data(using: .utf8) //Schalte Lampen aus
            serialPort?.send(data!)
            print("karsch nein")
        }
        if event.keyCode == 0 {
            let data = "4".data(using: .utf8)
            serialPort?.send(data!)
            player.stop()
        }
        resetTimer()
    }
    
    /*
     Plays the audio.
     */
    func playSound(file:String, ext:String) -> Void {
        let url = Bundle.main.url(forResource: file, withExtension: ext)!
        do {
            player = try AVAudioPlayer(contentsOf: url)
     //       guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
       //     print(error.localizedDescription)
        }
    }
}

