package view;

import javax.swing.*;

public class MainView extends JFrame {
    private JButton button1;
    public JPanel panel1;
    private JList list1;
    private JTree tree1;
    private JScrollBar scrollBar1;

    public MainView(){
        this.setContentPane(panel1);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.pack();
        this.setVisible(true);
    }
}
