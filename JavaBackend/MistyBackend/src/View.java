import javax.swing.*;
import java.awt.*;

public class View {

    public static void main(String args[]){
        JFrame frame = new JFrame("MistyBackend");
        frame.setContentPane(new MainView().panel1);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);

    }

}
