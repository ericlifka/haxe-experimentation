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
    var parent:Environment;

    public function new(parent:Environment) {
        this.parent = parent;
        this.definedSymbols = new Map();
    }

    public function putValue(sym:Symbol, value:Dynamic) {
        definedSymbols.set(sym, value);
    }

    public function hasValue(sym:Symbol) {
        return definedSymbols.exists(sym);
    }

    public function retrieveValue(sym:Symbol) {
        if (this.hasValue(sym)) {
            return definedSymbols.get(sym);
        }
        else if (this.parent != null) {
            return this.parent.retrieveValue(sym);
        }
        else {
            return null;
        }
    }
}
