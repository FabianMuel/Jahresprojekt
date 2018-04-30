package controller;

import model.GleimMenu;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class XmlWriter {

    private DocumentBuilderFactory factory;
    private DocumentBuilder builder;
    private Document document;
    private String documentPath;

    /**
     * http://www.mkyong.com/java/how-to-create-xml-file-in-java-dom/
     * @param documentPath String
     */
    public XmlWriter(String documentPath){
        factory = DocumentBuilderFactory.newInstance();
        this.documentPath=documentPath;
        try {
            builder = factory.newDocumentBuilder();
        } catch (ParserConfigurationException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void createXML(GleimMenu gleimMenu){
        document = builder.newDocument();
        Element mainRootElement = document.createElement("MenuStructure");
        document.appendChild(mainRootElement);
        appendMenu(gleimMenu, mainRootElement);

        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        try {
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT, "yes"); //make it pretty
            DOMSource source = new DOMSource(document);
            StreamResult result = new StreamResult(new File(documentPath));
            transformer.transform(source, result);
            System.out.println("File saved!");
        } catch (TransformerConfigurationException e) {
            e.printStackTrace();
        } catch (TransformerException e) {
            e.printStackTrace();
        }
    }

    private void appendMenu(GleimMenu gleimMenu, Element parentElement){
        Element menuElement = document.createElement("GleimMenu");
        //name
        menuElement.setAttribute("Name", gleimMenu.getName());

        //voice commands
        Element commandListElement = document.createElement("VoiceCommandList");
        for (String command : gleimMenu.getVoiceCommandList()){
            Element commandElement = document.createElement("VoiceCommand");
            commandElement.appendChild(document.createTextNode(command));
            commandListElement.appendChild(commandElement);
        }
        menuElement.appendChild(commandListElement);

        //serial command
        Element serialCommandElement = document.createElement("SerialCommand");
        serialCommandElement.appendChild(document.createTextNode(gleimMenu.getSerialCommand()));
        menuElement.appendChild(serialCommandElement);

        //audio file Path
        Element audioPathElement = document.createElement("AudioPath");
        audioPathElement.appendChild(document.createTextNode(gleimMenu.getAudioFilePath()));
        menuElement.appendChild(audioPathElement);

        //return commands
        Element returnCommandListElement = document.createElement("ReturnCommandList");
        for (String command : gleimMenu.getReturnCommandList()){
            Element commandElement = document.createElement("ReturnCommand");
            commandElement.appendChild(document.createTextNode(command));
            returnCommandListElement.appendChild(commandElement);
        }
        menuElement.appendChild(returnCommandListElement);

        //SubMenuElements
        Element subMenuListElement = document.createElement("SubMenuList");
        for(GleimMenu subMenuElement : gleimMenu.getSubMenuList()){
            appendMenu(subMenuElement, subMenuListElement); //recursive
        }
        menuElement.appendChild(subMenuListElement);

        //append to parent Element
        parentElement.appendChild(menuElement);
    }

    /**
     * liest xml mit X-Path ein.
     * @return String nachricht
     */
    public ArrayList<String> readXML(){
        ArrayList<String> tmpList = new ArrayList<String>();
        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
        docFactory.setNamespaceAware(false); // important!
        DocumentBuilder docBuilder;
        try {
            docBuilder = docFactory.newDocumentBuilder();
            Document doc = docBuilder.parse("chat.xml");
            XPath xpath = XPathFactory.newInstance().newXPath();
            NodeList nodeList = (NodeList)xpath.compile("/chat/nachricht").evaluate(doc, XPathConstants.NODESET);
            for (int i = 0; i < nodeList.getLength(); ++i) {
                Node node = nodeList.item(i);
                tmpList.add(node.getFirstChild().getFirstChild().getNodeValue());
                //tmpList.add(nodeList.item(i).getFirstChild().getNodeValue());
            }

            return tmpList;
        } catch (ParserConfigurationException e) {
            // TODO Auto-generated catch block
        } catch (SAXException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (XPathExpressionException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return null;

    }

}
