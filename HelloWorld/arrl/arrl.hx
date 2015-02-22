package arrl;

class Arrl {
    public function new() {
        trace("arrl.new");
    }
}

class ArrlType {
    public function isAtom() {
        return false;
    }
}

class Symbol {
    var name:String;

    static var definedSymbols:Map<String, Symbol>;

    private function new(name:String) {
        this.name = name;
    }

    static public function symbol(name:String):Symbol {
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
    var definedSymbols:Map<Symbol, ArrlType>;
    var parent:Environment;

    public function new(parent:Environment) {
        this.parent = parent;
        this.definedSymbols = new Map();
    }

    public function putValue(sym:Symbol, value:ArrlType) {
        this.definedSymbols.set(sym, value);
    }

    public function hasValue(sym:Symbol):Bool {
        return this.definedSymbols.exists(sym);
    }

    public function retrieveValue(sym:Symbol):ArrlType {
        if (this.hasValue(sym)) {
            return this.definedSymbols.get(sym);
        }
        else if (this.parent != null) {
            return this.parent.retrieveValue(sym);
        }
        else {
            return null;
        }
    }
}

class Eval {
    static public function eval(expression:ArrlType, scope:Environment):ArrlType {



        return null;
    }
}
