package main;
import controller.XmlWriter;
import model.GleimMenu;
import view.*;

public class Main {

    public static void main(String args[]){
       View view = new View();
       GleimMenu topLevelMenu = new GleimMenu("topLevel");

       GleimMenu gleim = new GleimMenu("Gleim");
       gleim.setAudioFilePath("gleim.wav");
       gleim.setSerialCommand("1");
       gleim.addReturnCommand("auf Wiedersehen");
       gleim.addVoiceCommand("Hallo Gleim");
       gleim.addVoiceCommand("Moin Gleim");

       GleimMenu gleimLek = new GleimMenu("GleimLek");
       gleimLek.setAudioFilePath("gleimLek.wav");
       gleimLek.addVoiceCommand("Lektüre");

       gleim.addSubMenu(gleimLek);

       GleimMenu ramler = new GleimMenu("Ramler");
       ramler.setAudioFilePath("ramler.wav");
       ramler.setSerialCommand("2");
       ramler.addReturnCommand("tschüss");
       ramler.addVoiceCommand("Hallo Ramler");
       ramler.addVoiceCommand("Was geht ab");

       topLevelMenu.addSubMenu(gleim);
       topLevelMenu.addSubMenu(ramler);

        XmlWriter xmlWriter = new XmlWriter("test.xml");
        xmlWriter.createXML(topLevelMenu);
    }
}
