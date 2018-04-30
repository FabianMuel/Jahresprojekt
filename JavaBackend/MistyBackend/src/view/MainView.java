package view;

import model.GleimMenu;

import javax.swing.*;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

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
    private JButton saveValuesButton;
    private JLabel nameLabel;
    private JLabel voiceCommandLabel;
    private JLabel serialCommandLabel;
    private JLabel audioLabel;
    private JLabel returnCommandLabel;

    public MainView() {
        this.setContentPane(panel1);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.pack();
        this.setVisible(true);


        button1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

            }
        });
        removeSubmenuButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

            }
        });
        addSubmenuButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

            }
        });
    }

    private void createUIComponents() {
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
        //add the child nodes to the root node
    //    root.add(vegetableNode);
   //     root.add(fruitNode);
        tree1 = new JTree(topLevelMenu);

        tree1.addTreeSelectionListener(new TreeSelectionListener() {
            @Override
            public void valueChanged(TreeSelectionEvent e) {

                GleimMenu selectedMenu = (GleimMenu) e.getPath().getLastPathComponent();
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
