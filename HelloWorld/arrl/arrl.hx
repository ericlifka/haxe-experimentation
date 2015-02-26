package arrl;

class Arrl {
    public function new() {
        trace("arrl.new");
    }
}

class ArrlType {
    private var type:String;
    private var symbol:Symbol;
    private var car:ArrlType;
    private var cdr:ArrlType;

    private function new() {}

    public function isAtom():Bool {
        if (type == "nil") {
            return true;
        }

        return false;
    }

    public function isSymbol():Bool {
        return type == "symbol";
    }

    public function getSymbol():Symbol {
        if (type == "symbol") {
            return symbol;
        }
        else {
            throw "TypeError - called getSymbol() on a non symbol ArrlType";
        }
    }

    public function isList():Bool {
        return type == "cons";
    }

// builders
    private static var nil:ArrlType;

    public static function Nil():ArrlType {
        if (nil != null) {
            return nil;
        }
        else {
            nil = new ArrlType();
            nil.type = "nil";
            return nil;
        }
    }

    public static function Symbol(symbol:Symbol):ArrlType {
        var sym = new ArrlType();
        sym.type = "symbol";
        sym.symbol = symbol;
        return sym;
    }

    public static function Cons(car:ArrlType, cdr:ArrlType):ArrlType {
        var cons = new ArrlType();
        cons.type = "cons";
        cons.car = car;
        cons.cdr = cdr;
        return cons;
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
            return ArrlType.Nil();
        }
    }
}

class Eval {
    static public function eval(expression:ArrlType, scope:Environment):ArrlType {
        if (expression.isAtom()) {
            return expression;
        }

        if (expression.isSymbol()) {
            return scope.retrieveValue(expression.getSymbol());
        }

        if (expression.isList()) {
            return evalList(expression, scope);
        }

        return ArrlType.Nil();
    }

    static public function evalList(expression:ArrlType, scope:Environment):ArrlType {
        return ArrlType.Nil();
    }
}
