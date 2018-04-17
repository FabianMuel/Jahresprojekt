

import Cocoa
import AVFoundation

class ViewController: NSViewController, NSSpeechRecognizerDelegate, ORSSerialPortDelegate {
    
    
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
    
    var speechRecognizer = NSSpeechRecognizer()
    var player = AVAudioPlayer()
    var serialPort = ORSSerialPort(path: "/dev/cu.usbmodem14111")
    
    var sleepTimeSek = 0
    
    var menuCreator = MenuCreator()
    var topLevelMenu = GleimMenu()
    var currentMenu = GleimMenu()
    
    var timer = Timer()
    let timerInterval = 120.0 //TimeOut und reset auf TopLevelMenu in Sekunden (double)
    
    var stopCommand = "stop"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        topLevelMenu = menuCreator.getMenu()
        currentMenu = topLevelMenu
        updateSpeechCommands()
        speechRecognizer?.startListening()  //laesst recognizer auf befehle hören
       
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        
        
    }
    
    //Bn Actions
    @IBAction func SegBn_On_Off_OnClick(_ sender: Any) {
        
    }
    
    func updateSpeechCommands() {
        var newCommands = currentMenu.getSubMenuCommandList()
        newCommands.append(contentsOf: currentMenu.getReturnCommandList())
        newCommands.append(stopCommand)
        speechRecognizer?.commands=newCommands
    }
    
    @objc func resetMenu() {
        print("reset commands")
        currentMenu = topLevelMenu
        updateSpeechCommands()
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(resetMenu), userInfo: nil, repeats: true)
    }
    
    func resetTimer(){
        timer.invalidate()
        startTimer()
    }
    
    //Methode die aufgerufen wird, wenn sr etwas erkannt hat. "didRecognizeCommand" ist erkannter Befehl
    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command: String) {
        print(command)
        if command == stopCommand {
            serialPort?.send("4".data(using: .utf8)!)
            if(player.isPlaying) {
                player.stop()
            }
         //   currentMenu = topLevelMenu
         //   updateSpeechCommands()
            resetTimer()
            return
        }
        
        for returnCommand in currentMenu.getReturnCommandList(){
            if returnCommand == command {
                currentMenu = topLevelMenu
                updateSpeechCommands()
                resetTimer()
                return
            }
        }
        
        for menuElement in currentMenu.getSubMenu() {
            for elementCommand in menuElement.getOwnCommandList() {
                if elementCommand == command {
                    serialPort?.send(menuElement.getSerialCommand().data(using: .utf8)!)
                    playSound(file: menuElement.getAudioFilePath(), ext: "wav")
                    
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
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
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

