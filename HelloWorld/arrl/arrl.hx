package arrl;

class Arrl {
    public function new() {
        trace("arrl.new");
    }
}

class Symbol {
    var name:String;

    static var definedSymbols:Map<String, Symbol>;

    private function new(name:String) {
        this.name = name;
    }

    static public function symbol(name:String) {
        if (definedSymbols.exists(name)) {
            return definedSymbols.get(name);
        }
        else {
            var sym = new Symbol(name);
            definedSymbols.set(name, sym);
            return sym;
        }
    }
}

class Environment {
    var definedSymbols:Map<Symbol, Dynamic>;

    public function new() {

    }
}
