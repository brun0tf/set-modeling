package bruno;

import org.jgrapht.Graph;
import org.jgrapht.graph.DirectedMultigraph;
import org.jgrapht.traverse.DepthFirstIterator;

import java.io.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.StringTokenizer;

public class Main {

    public static void main(String[] args) throws IOException {
        FileOutputStream buffer = new FileOutputStream("src\\Bruno\\Auto\\auto.txt");
        PrintWriter autoArch = new PrintWriter(buffer);





        for(int i = 0, j = 0; i < args.length/5; i++, j = j + 5){
            String logicGate = ReadFile.LoadFileToString(args[j]);
            String x = addVoltageSourceinNetlist(logicGate, args[j+2], args[j+3]);

            String[] inputVector = args[j+1].split("");

            Passo1 p1 = new Passo1(inputVector, args[j+2], args[j+3], logicGate, Integer.parseInt(args[j+4]));
            String caseName = p1.makeNetlist();

            runSPICE("D:\\pesquisa\\Projeto SEE\\Algoritmos\\MeuModelo\\src\\bruno\\Output\\" + p1.getLogicGateName(logicGate) + "\\" + p1.arrayToString(inputVector) + "\\Passo1_" + caseName + ".sp");

            Passo2 p2 = new Passo2(inputVector, args[j+2], args[j+3], x, Integer.parseInt(args[j+4]), caseName, "15f");
            Variables var = p2.makeNetlist();

            runSPICE("D:\\pesquisa\\Projeto SEE\\Algoritmos\\MeuModelo\\src\\bruno\\Output\\" + p1.getLogicGateName(logicGate) + "\\" + p1.arrayToString(inputVector) + "\\Passo2_" + caseName + ".sp");

            p2.getVariablesFromPasso2();



        }


        autoArch.close();
    }

    public static void runSPICE (String pathNETLIST) throws IOException { //https://docs.oracle.com/javase/7/docs/api/java/lang/ProcessBuilder.html
        String runSPICE_command = "tspcmd64.exe";

        ProcessBuilder test = new ProcessBuilder(runSPICE_command, pathNETLIST);
        test.redirectErrorStream(true);
        Process p = test.start();

        BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream()));
        String line;
        while (true) {
            line = r.readLine();
            if (line == null) { break; }
            System.out.println(line);
        }
    }

    public static String addVoltageSourceinNetlist(String logicGate, String terminal1, String terminal2){
        Graph<String, Transistor> graphWithVoltageSource;
        Graph<String, Transistor> g;
        ArrayList<Transistor> transistorNetlist;
        String source = null, target = null;

        GraphGenerator graph = new GraphGenerator();
        assert logicGate != null;
        transistorNetlist = graph.netlistMappingAsString(logicGate);

        g = graph.graphGenerator(transistorNetlist);


        if(terminal1.toLowerCase().equals("vdd")){
             source = terminal1;
             target = terminal2;
        }
        else {//(terminal1.toLowerCase().equals("gnd"))
            source = terminal2;
            target = terminal1;
        }

        GraphManipulator man = new GraphManipulator(g, target, source);
        graphWithVoltageSource = man.addVoltageSource();

       return translateGraphToNetlist (graphWithVoltageSource, logicGate);
    }
    public static String translateGraphToNetlist(Graph<String, Transistor> g, String logicGate){
        ArrayList<String> netlist = new ArrayList<>();
        ArrayList<String> vertex = new ArrayList<>();

        Iterator<String> iter = new DepthFirstIterator<>(g);

        while (iter.hasNext()){
            vertex.add(iter.next());
        }

        for(int i = 0; i < vertex.size(); i++){
            for(int j = i; j < vertex.size(); j++){
                ArrayList<Transistor> edge = new ArrayList<>();

                edge.addAll(g.getAllEdges(vertex.get(i), vertex.get(j)));//grafo é direto. então se adiciona todas edges entre VDD-OUT e OUT-VDD pra garantir
                edge.addAll(g.getAllEdges(vertex.get(j), vertex.get(i)));

                for(Transistor transistor : edge){
                    netlist.add(transistor.toString());
                }
            }
        }

        netlist =  addSubckt(netlist, logicGate);

        StringBuilder sB = new StringBuilder();

        for(String str : netlist){
            sB.append(str).append("\n");
        }

        return sB.toString();

    }
    public static ArrayList<String> addSubckt(ArrayList<String> netlist, String logicGate){
        ArrayList<String> temp = new ArrayList<>();
        ArrayList<String> temp2 = new ArrayList<>();
        StringTokenizer sT = new StringTokenizer(logicGate, "\n");
        String subckt = null;
        String ends = null;

        while (sT.hasMoreTokens())
            temp.add(sT.nextToken());

        for (String str : temp){
            if(str.toLowerCase().contains("subckt")) subckt = str;
            else if(str.toLowerCase().contains("ends")) ends = str;
        }

        temp2.add(subckt);
        temp2.addAll(netlist);
        temp2.add(ends);

        return temp2;
    }


}
