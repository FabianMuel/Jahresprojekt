package view;

import javax.swing.*;
import java.awt.*;

public class View {

    JFrame frame;

    public View(){
        frame = new JFrame("MistyBackend");
        frame.setContentPane(new MainView().panel1);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);
    }
}
