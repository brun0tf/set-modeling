package bruno;

import org.jgrapht.Graph;
import org.jgrapht.traverse.DepthFirstIterator;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class GraphManipulator {
    private final Graph<String, Transistor> graph;
    private final String strikedNode;
    private final String sourceNode;


    public GraphManipulator(Graph<String, Transistor> graph, String terminal1, String terminal2) {
        this.graph = graph;
        this.strikedNode = terminal1;
        this.sourceNode  = terminal2;
    }

    Graph<String, Transistor> addVoltageSource (){
        String newNode = "nAux";
        String predecessorNode = getPredecessorVertex(strikedNode);
        Transistor voltageSource = setVoltageSource(predecessorNode);
        ArrayList<Transistor> oldEdges = new ArrayList<>();
        if(isN_hit())
            oldEdges.addAll(graph.getAllEdges(predecessorNode, strikedNode));
        else
            oldEdges.addAll(graph.getAllEdges(strikedNode, predecessorNode));

        graph.addVertex(newNode);
        graph.addEdge(strikedNode, newNode, voltageSource);

        graph.removeAllEdges(predecessorNode, strikedNode);

        for (Transistor transistor : oldEdges) {
            transistor = changeTransistorNode(transistor, predecessorNode);
            graph.addEdge(newNode, predecessorNode, transistor);
        }




        //printGraph(graph);
        return graph;
    }

    /*Graph<String, Transistor> addVoltageSource (){
                String newNode = "x";
                String predecessorNode = getPredecessorVertex(strikedNode);
                Transistor voltageSource = setVoltageSource(predecessorNode);
                ArrayList<Transistor> oldEdges = new ArrayList<>(graph.getAllEdges(predecessorNode, strikedNode));

                graph.addVertex(newNode);
                graph.addEdge(strikedNode, newNode, voltageSource);

                graph.removeAllEdges(predecessorNode, strikedNode);

                for (Transistor transistor : oldEdges) {
                    transistor = changeTransistorNode(transistor, predecessorNode);
                    graph.addEdge(newNode, strikedNode, transistor);
                }




        //printGraph(graph);
        return graph;
    }*/

    String getPredecessorVertex (String strikedNode){//todo pega o primeiro nó superior que o iterator vê. talvez tenha que arrumar
        Set<Transistor> x;
        if(isN_hit()) {
            x = graph.incomingEdgesOf(strikedNode);
            return graph.getEdgeSource(x.iterator().next());
        }
        else{
            x = graph.outgoingEdgesOf(strikedNode);
            return graph.getEdgeTarget(x.iterator().next());
        }

    }

    Transistor setVoltageSource(String predecessorNode){
        Transistor voltageSource = new Transistor("v1");

        if(isN_hit()) {
            voltageSource.setNode1(strikedNode);
            voltageSource.setNode2("nAux");
        }
        else{
            voltageSource.setNode1("nAux");
            voltageSource.setNode2(strikedNode);
        }

        voltageSource.setBulk("0");
        voltageSource.setGate("");
        voltageSource.setModel("");
        voltageSource.setL_w("");
        voltageSource.setValue(0);

        return voltageSource;
    }

    void printGraph (Graph<String, Transistor> graph){
        Iterator<String> iter = new DepthFirstIterator<>(graph);
        while (iter.hasNext()) {
            String vertex = iter.next();
            System.out
                    .println(
                            "Vertex " + vertex + " is connected to: "
                                    + graph.edgesOf(vertex).toString());
        }
    }

    Transistor changeTransistorNode (Transistor t, String predecessorNode){
        if(t.getNode1().equals(predecessorNode)){
            if(isN_hit())
                 t.setNode2("nAux");
            else
                 t.setNode2("nAux");
                 t = swapNodesOrder(t);
        }
        else if (t.getNode2().equals(predecessorNode)){
            if(isN_hit())
                t.setNode1("nAux");
            else
                t.setNode1("nAux");
        }
        return t;
    }

    boolean isN_hit(){
        String x = this.sourceNode.toLowerCase();
        return (x.equals("gnd"));
    }

    Transistor swapNodesOrder(Transistor t){

        String temp = t.getNode1();
        t.setNode1(t.getNode2());
        t.setNode2(temp);

        return t;
    }
}
