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
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
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
    private GleimMenu gleimMenu;

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

    public void setMenu(GleimMenu gleimMenu){
        this.gleimMenu=gleimMenu;
    }

    public void createXML(GleimMenu gleimMenu){
        document = builder.newDocument();
        Element mainRootElement = document.createElement("MenuStructure");
        document.appendChild(mainRootElement);
        appendMenu(gleimMenu, mainRootElement);

        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        try {
            Transformer transformer = transformerFactory.newTransformer();
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

 /*   public void createXML(){
        document = builder.newDocument();
        Element mainRootElement = document.createElement("MenuStructure");
        document.appendChild(mainRootElement);

        for(GleimMenu menuElement : gleimMenu.getSubMenuList()){
            Element gleimMenu = document.createElement("GleimMenu");
            Element subMenuList = document.createElement("SubMenuList");
            Element audioFilePath = document.createElement("AudioFilePath");
            Element commandList = document.createElement("CommandList");
            Element serialCommand = document.createElement("SerialCommand");
            Element returnCommandList = document.createElement("ReturnCommandList");

            gleimMenu.appendChild(document.createAttribute(menuElement.getName()));
            gleimMenu.appendChild(marke);
            marke.appendChild(document.createTextNode(listMarken.get(t)));

            auto.appendChild(ps);
            ps.appendChild(document.createTextNode(listPS.get(t)));

            auto.appendChild(farbe);
            farbe.appendChild(document.createTextNode(listFarben.get(t)));

            auto.appendChild(verfuegbar);
            verfuegbar.appendChild(document.createTextNode(listVerfuegbar.get(t)));
            mainRootElement.appendChild(auto);
        }
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        try {
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(document);
            StreamResult result = new StreamResult(new File("autovermietung.xml"));
            transformer.transform(source, result);
            System.out.println("File saved!");
            //	XSL_Transformer xsl_transformer = new XSL_Transformer();
            //	xsl_transformer.transform();
        } catch (TransformerConfigurationException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (TransformerException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }


        //mainRootElement.appendChild();
    } */
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
