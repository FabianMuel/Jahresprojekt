package view;

import controller.XmlWriter;
import model.GleimMenu;

import javax.swing.*;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultTreeModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class MainView extends JFrame{
    public JPanel panel1;
    private JTree tree1;
    private JScrollBar sbTree;
    private JTextField tfName;
    private JTextArea taVoiceCommand;
    private JTextField tfSerialCommand;
    private JTextField tfAudio;
    private JButton button1;
    private JTextArea taReturnCommand;
    private JScrollBar sbVoiceCommands;
    private JScrollBar sbReturnCommands;
    private JButton addSubmenuButton;
    private JButton removeSubmenuButton;
    private JButton saveButton;
    private JLabel nameLabel;
    private JLabel voiceCommandLabel;
    private JLabel serialCommandLabel;
    private JLabel audioLabel;
    private JLabel returnCommandLabel;
    private JButton openFileButton;
    private JButton saveValuesButton;

    private GleimMenu selectedMenu;
    private XmlWriter xmlWriter;
    private GleimMenu topLevelMenu;
    private String xmlFilePath = "test.xml";

    public MainView() {
        this.setContentPane(panel1);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.pack();
        this.setVisible(true);
        this.setLocationRelativeTo(null);
        this.setTitle("Misty Backend");

        xmlWriter = new XmlWriter(xmlFilePath);

        button1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JFileChooser fileChooser = new JFileChooser();
                int result = fileChooser.showOpenDialog(null);
                if (result == JFileChooser.APPROVE_OPTION) {
                    String path = fileChooser.getSelectedFile().getPath();
                    selectedMenu.setAudioFilePath(path);
                    tfAudio.setText(path);
                }
            }
        });
        removeSubmenuButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if(selectedMenu == null) return;
                GleimMenu parentMenu = (GleimMenu) selectedMenu.getParent();
                if(parentMenu == null) return;
                System.out.println(parentMenu.getName());
                new removeMenuDialog(parentMenu, selectedMenu, (DefaultTreeModel) tree1.getModel());
            }
        });
        addSubmenuButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if(selectedMenu == null) return;
                new addMenuDialog(selectedMenu, (DefaultTreeModel) tree1.getModel());
            }
        });
        saveButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if(selectedMenu == null) return;
                saveValues();
                File file = xmlWriter.createXML(topLevelMenu);

                //open file after writing
                if(!Desktop.isDesktopSupported()){
                    System.out.println("Desktop is not supported");
                    return;
                }
                Desktop desktop = Desktop.getDesktop();
                if( file.exists()) {
                    try {
                        desktop.open(file);
                    } catch (IOException e1) {
                        e1.printStackTrace();
                    }
                }
            }
        });
        saveValuesButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if(selectedMenu == null) return;
                saveValues();
            }
        });
    }

    private void saveValues() {
        selectedMenu.setName(tfName.getText());
        selectedMenu.setAudioFilePath(tfName.getText());
        selectedMenu.setSerialCommand(tfSerialCommand.getText());

        String[] voiceCommands = taVoiceCommand.getText().split("\n");
        ArrayList<String> voiceCommandList = new ArrayList<>();
        for (String command : voiceCommands){
            System.out.println("Voice Command: "+command);
            voiceCommandList.add(command);
        }
        selectedMenu.setVoiceCommandList(voiceCommandList);

        String[] returnCommands = taReturnCommand.getText().split("\n");
        ArrayList<String> returnCommandList = new ArrayList<>();
        for (String command : returnCommands){
            returnCommandList.add(command);
        }
        selectedMenu.setReturnCommandList(returnCommandList);

    }

    private void createUIComponents() {
        topLevelMenu = new GleimMenu("topLevel");

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
        tree1 = new JTree(topLevelMenu);

        tree1.addTreeSelectionListener(new TreeSelectionListener() {
            @Override
            public void valueChanged(TreeSelectionEvent e) {
                selectedMenu = (GleimMenu) e.getPath().getLastPathComponent();
                tfName.setText(selectedMenu.getName());
                tfAudio.setText(selectedMenu.getAudioFilePath());
                tfSerialCommand.setText(selectedMenu.getSerialCommand());

                taVoiceCommand.setText("");
                for(String vcommand : selectedMenu.getVoiceCommandList()) {
                    taVoiceCommand.append(vcommand + "\n");
                }

                taReturnCommand.setText("");
                for (String rcommand : selectedMenu.getReturnCommandList()){
                    taReturnCommand.append(rcommand + "\n");
                }
            }
        });
    }

    public void setTree1(GleimMenu gleimMenu){

    }
}
