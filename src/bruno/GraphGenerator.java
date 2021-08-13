package bruno;

import bruno.ReadFile;
import org.jgrapht.Graph;
import org.jgrapht.graph.*;
import org.jgrapht.traverse.DepthFirstIterator;

import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.StringTokenizer;

public class GraphGenerator {

    public Graph<String, Transistor> graphGenerator (ArrayList<Transistor> transistor){
        ArrayList<String> nodeList = new ArrayList<>();


        Graph<String, Transistor> graph = new DirectedMultigraph<>(Transistor.class);

        for(Transistor i : transistor){
            if(!nodeAlreadyExists(nodeList, i.getNode1())){
                nodeList.add(i.getNode1());
            }
            if(!nodeAlreadyExists(nodeList, i.getNode2())){
                nodeList.add(i.getNode2());
            }
        }
        nodeList = sortNodelist(nodeList);

        for (String i: nodeList)
            graph.addVertex(i);

        for(Transistor i : transistor){
            for(String str : nodeList){
                if(str.equals(i.getNode1().toLowerCase())){ //tratamento para garantir que cada edge aponte para o lado certo. (começa em VDD e vai até GND)
                    graph.addEdge(i.getNode1(), i.getNode2(), i);
                }
                else if(str.equals(i.getNode2().toLowerCase())){
                    graph.addEdge(i.getNode2(), i.getNode1(), i);
                }
            }
        }


        /*Iterator<String> iter = new DepthFirstIterator<>(graph);
        while (iter.hasNext()) {
            String vertex = iter.next();
            System.out
                    .println(
                            "Vertex " + vertex + " is connected to: "
                                    + graph.edgesOf(vertex).toString());
        }*/


        /*for(Transistor i : transistor){
            System.out.println(i.getBulk());
        }*/
        return graph;
    }

    public ArrayList<String> sortNodelist(ArrayList<String> nodeList){
        ArrayList<String> newNodeList = new ArrayList<>();

        newNodeList.add("vdd");

        for(String str : nodeList){
            if(str.toLowerCase().contains("pu"))
                newNodeList.add(str);
        }

        newNodeList.add("out");

        for(String str : nodeList){
            if(str.toLowerCase().contains("pd"))
                newNodeList.add(str);
        }

        newNodeList.add("gnd");

        return newNodeList;
    }
    public boolean nodeAlreadyExists (ArrayList<String> X, String node){
        for (String i : X){
            if(i.equals(node)){
                return true;
            }
        }
        return false;
    }

    public ArrayList<Transistor> netlistMapping (String file){ //todo: dar uma atualizada. Não recebe netlist com .subckt, .ends, comentários....
        ArrayList<Transistor> transistor = new ArrayList<>();
        ArrayList<String> netlist = ReadFile.loadFileToArray(file);

        int k = 0;
        assert netlist != null;
        for (String line : netlist){
            StringTokenizer lineT = new StringTokenizer(line, " ");
            while(lineT.hasMoreTokens()){
                String transistorName = lineT.nextToken();

                if (transistorName.contains("inv")){
                    int i = 5;
                    while (i > 0){
                        lineT.nextToken();
                        i--;
                    }
                    break;
                }
                transistor.add(new Transistor(transistorName));
                transistor.get(k).setNode1(lineT.nextToken());
                transistor.get(k).setGate(lineT.nextToken());
                transistor.get(k).setNode2(lineT.nextToken());
                transistor.get(k).setBulk(lineT.nextToken());
                transistor.get(k).setModel(lineT.nextToken());
                k++;
            }
        }
        /*for(Transistor i : transistor){
            System.out.println(i.getGate());
        }*/
        return transistor;
    }

    public ArrayList<Transistor> netlistMappingAsString (String logicGate){
        //ArrayList<String> netlist = ReadFile.loadFileToArray(file);
        ArrayList<Transistor> transistor = new ArrayList<>();
        ArrayList<String> netlist = new ArrayList<>(Arrays.asList(logicGate.split("\n")));

        int k = 0;

        netlist = arrangeNetlist(netlist);




        for (String line : netlist){//todo arrumar esse string tokenizer
            String line_= line.replace("\t", " ");
            StringTokenizer lineT = new StringTokenizer(line_, " ");

            while(lineT.hasMoreElements()){
                String transistorName = lineT.nextToken();
                if (transistorName.contains("inv")){
                    int i = 5;
                    while (i > 0){
                        lineT.nextToken();
                        i--;
                    }
                    break;
                }

                transistor.add(new Transistor(transistorName));
                transistor.get(k).setNode1(lineT.nextToken());
                transistor.get(k).setGate(lineT.nextToken());
                transistor.get(k).setNode2(lineT.nextToken());
                transistor.get(k).setBulk(lineT.nextToken());
                transistor.get(k).setModel(lineT.nextToken());

                StringBuilder sb = new StringBuilder();
                while (lineT.hasMoreTokens()){
                    assert false;
                    sb.append(" ").append(lineT.nextToken());
                }
                assert false;
                transistor.get(k).setL_w(sb.toString());
                k++;
            }
        }

        /*for (Transistor t : transistor){
            System.out.println(t.toString());
        }*/

        return transistor;
    }

    ArrayList<String> arrangeNetlist(ArrayList<String> netlist){
        ArrayList<String> temp = new ArrayList<>();

        for (String s : netlist)
            temp.add(s.toLowerCase());

        temp.removeIf(x -> x.contains(".subckt"));
        temp.removeIf(x -> x.contains(".ends"));
        temp.removeIf(x -> x.startsWith("*"));

        return temp;
    }

}
