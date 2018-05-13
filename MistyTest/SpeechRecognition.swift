

import Cocoa
import AVFoundation
import Foundation

class SpeechRecognition: NSObject, NSSpeechRecognizerDelegate, ORSSerialPortDelegate {
    
    
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
    
    var sr = NSSpeechRecognizer()
    var player = AVAudioPlayer()
    var serialPort = ORSSerialPort(path: "/dev/cu.usbmodem14111")
    
    var sleepTimeSek = 0
    
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
    
    override init() {
        super.init()
        sr?.delegate = self
        serialPort?.delegate=self
        sr?.commands = [gleimBegr, gleimLek1, gleimLek2, gleimPort1, gleimPort2, gleimJa, ramlerBegr, ramlerPort1, ramlerPort2, ramlerFrage, ramlerNein, karschBegr, karschLek1, karschLek2,karschFrage, karschNein, stop] //erkennbare Befehle
        sr?.startListening()  //laesst recognizer auf befehle hören
        
        let spm = ORSSerialPortManager()
        let s = spm.availablePorts
        print(s)
        
        serialPort?.baudRate = 9600
        serialPort?.open()
    }

    
    //Methode die aufgerufen wird, wenn sr etwas erkannt hat. "didRecognizeCommand" ist erkannter Befehl
    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command: String) {
        
        print(command)
        if command == gleimBegr {
            let data = "1".data(using: .utf8)
            serialPort?.send(data!)
            
            playSound(file: "Gleim_beg", ext: "wav")
            print("ich bin gleim")
        }
        if command == gleimLek1 || command == gleimLek2 {
            playSound(file: "gleimlek", ext: "wav")
            print("gleim lektüre")
        }
        if command == gleimPort1 || command == gleimPort2 {
            playSound(file: "Gleim_verweis", ext: "wav")
            print("gleim portrait")
        }
        if command == gleimJa {
            playSound(file: "Gleim_end", ext: "wav")
            let data = "2".data(using: .utf8) //Schalte Ramler-lampe an
            serialPort?.send(data!)
            print("gleim ja")
        }
        if command == ramlerBegr {
            //      let data = "2".data(using: .utf8)
            //       serialPort?.send(data!)
            playSound(file: "ramler_beg", ext: "wav")
            print("ramler begr")
        }
        if command == ramlerFrage {
            playSound(file: "ramler_frage", ext: "wav")
            
            print("ramler frage")
        }
        if command == ramlerPort1 || command == ramlerPort2 {
            playSound(file: "ramlerport", ext: "wav")
            print("ramler portrait")
        }
        if command == ramlerNein {
            playSound(file: "Ramler_end", ext: "wav")
            let data = "4".data(using: .utf8) //Schalte Lampen aus
            serialPort?.send(data!)
            print("ramler nein")
        }
        if command == karschBegr {
            let data = "3".data(using: .utf8)
            serialPort?.send(data!)
            playSound(file: "Karsch_beg", ext: "wav")
            print("karsch begr")
        }
        if command == karschLek1 || command == karschLek2 {
            playSound(file: "KarschLek", ext: "wav")
            print("karsch lek")
        }
        if command == karschFrage {
            playSound(file: "Karsch_frage", ext: "wav")
            print("karsch frage")
        }
        if command == karschNein {
            playSound(file: "Karsch_end_1", ext: "wav")
            let data = "4".data(using: .utf8) //Schalte Lampen aus
            serialPort?.send(data!)
            print("karsch nein")
        }
        if command == stop {
            let data = "4".data(using: .utf8)
            serialPort?.send(data!)
            player.stop()
        }
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
