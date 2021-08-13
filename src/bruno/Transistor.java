package bruno;

public class Transistor {
    private String name, node1, node2, bulk, model, gate;
    private String l_w;


    public Transistor(String str){
        this.name = str;
    }
    public String getGate() {
        return gate;
    }

    public void setGate(String gate) {
        this.gate = gate;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    int value;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNode1() {
        return node1;
    }

    public void setNode1(String node1) {
        this.node1 = node1;
    }

    public String getNode2() {
        return node2;
    }

    public void setNode2(String node2) {
        this.node2 = node2;
    }

    public String getBulk() {
        return bulk;
    }

    public void setBulk(String bulk) {
        this.bulk = bulk;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getL_w() {
        return l_w;
    }

    public void setL_w(String l_w) {
        this.l_w = l_w;
    }

    @Override
    public String toString() {
        return this.name + " " + this.node1 + " " + this.gate+ " " +this.node2 + " "+ this.bulk + " "+ this.model + " "+ this.l_w;
    }
}
