package model;

import java.util.ArrayList;

public class GleimMenu {

    private ArrayList<GleimMenu> subMenuList = new ArrayList<>();
    private String name = "";
    private String audioFilePath = "";
    private ArrayList<String> voiceCommandList = new ArrayList<>();
    private String serialCommand = "";
    private ArrayList<String> returnCommandList = new ArrayList<>();

    public GleimMenu(String name){
        this.name=name;
    }

    public ArrayList<String> getSubMenuCommandList(){
        ArrayList<String> array = new ArrayList<>();
        for(GleimMenu menuElement : subMenuList){
            for(String command : menuElement.getVoiceCommandList()){
                array.add(command);
            }
        }
        return  array;
    }

    public void addSubMenu(GleimMenu gleimMenu){
        subMenuList.add(gleimMenu);
    }

    public void addVoiceCommand(String command){
        voiceCommandList.add(command);
    }

    public void addReturnCommand(String command){
        returnCommandList.add(command);
    }

    //-----------Generated Getter Setter------------

    public ArrayList<GleimMenu> getSubMenuList() {
        return subMenuList;
    }

    public void setSubMenuList(ArrayList<GleimMenu> subMenuList) {
        this.subMenuList = subMenuList;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAudioFilePath() {
        return audioFilePath;
    }

    public void setAudioFilePath(String audioFilePath) {
        this.audioFilePath = audioFilePath;
    }

    public ArrayList<String> getVoiceCommandList() {
        return voiceCommandList;
    }

    public void setVoiceCommandList(ArrayList<String> voiceCommandList) {
        this.voiceCommandList = voiceCommandList;
    }

    public String getSerialCommand() {
        return serialCommand;
    }

    public void setSerialCommand(String serialCommand) {
        this.serialCommand = serialCommand;
    }

    public ArrayList<String> getReturnCommandList() {
        return returnCommandList;
    }

    public void setReturnCommandList(ArrayList<String> returnCommandList) {
        this.returnCommandList = returnCommandList;
    }
}
