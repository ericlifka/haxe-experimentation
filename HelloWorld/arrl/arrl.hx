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
    private var errorMessage:String;
    private var funcCallable:ArrlType -> ArrlType;
    private var macroCallable:ArrlType -> ArrlType;
    private var specialCallable:ArrlType -> Environment -> ArrlType;

    private function new(type:String) {
        this.type = type;
    }

    public function isAtom():Bool {
        return isNil() || isError();
    }

    public function isNil():Bool {
        return type == "nil";
    }

    public function isSymbol():Bool {
        return type == "symbol";
    }

    public function getSymbol():Symbol {
        if (isSymbol()) {
            return symbol;
        }
        else {
            throw "TypeError - called getSymbol() on a non symbol ArrlType";
        }
    }

    public function isList():Bool {
        return type == "cons";
    }

    public function getCar():ArrlType {
        if (isList()) {
            return car;
        }
        else {
            throw "TypeError - called getCar() on a non list ArrlType";
        }
    }

    public function getCdr():ArrlType {
        if (isList()) {
            return cdr;
        }
        else {
            throw "TypeError - called getCdr() on a non list ArrlType";
        }
    }

    public function isError():Bool {
        return type == "error";
    }

    public function getError():String {
        if (isError()) {
            return errorMessage;
        }
        else {
            throw "TypeError - called getError() on a non error ArrlType";
        }
    }

    public function isFunction():Bool {
        return type == "function";
    }

    public function getFunction():ArrlType -> ArrlType {
        return funcCallable;
    }

    public function isMacro():Bool {
        return type == "macro";
    }

    public function getMacro():ArrlType -> ArrlType {
        return macroCallable;
    }

    public function isSpecialForm():Bool {
        return type == "special-form";
    }

    public function getSpecialForm():ArrlType -> Environment -> ArrlType {
        return specialCallable;
    }

// builders
    private static var nil:ArrlType;

    public static function Nil():ArrlType {
        if (nil != null) {
            return nil;
        }
        else {
            nil = new ArrlType("nil");
            return nil;
        }
    }

    public static function Symbol(symbol:Symbol):ArrlType {
        var sym = new ArrlType("symbol");
        sym.symbol = symbol;
        return sym;
    }

    public static function Cons(car:ArrlType, cdr:ArrlType):ArrlType {
        if (car == null) {
            return Nil();
        }

        var cons = new ArrlType("cons");
        cons.car = car;

        if (cdr == null) {
            cons.cdr = Nil();
        }
        else {
            cons.cdr = cdr;
        }
        return cons;
    }

    public static function Error(message:String):ArrlType {
        var error = new ArrlType("error");
        error.errorMessage = message;
        return error;
    }

    public static function Func(callable:ArrlType -> ArrlType):ArrlType {
        var func = new ArrlType("function");
        func.funcCallable = callable;
        return func;
    }

    public static function Macro(callable:ArrlType -> ArrlType):ArrlType {
        var macroCell = new ArrlType("macro");
        macroCell.macroCallable = callable;
        return macroCell;
    }

    public static function SpecialForm(callable:ArrlType -> Environment -> ArrlType):ArrlType {
        var special = new ArrlType("special-form");
        special.specialCallable = callable;
        return special;
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

    public function putValue(sym:Symbol, value:ArrlType):Void {
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

        return ArrlType.Error("Unrecognized type passed to eval '" + expression + "'");
    }

    static public function evalList(expression:ArrlType, scope:Environment):ArrlType {
        var first:ArrlType = expression.getCar();
        var rest:ArrlType = expression.getCdr();

        var callable:ArrlType = eval(first, scope);

        if (callable.isError()) {
            return callable;
        }

        if (callable.isSpecialForm()) {
            var fn = callable.getSpecialForm();
            return fn(rest, scope);
        }

        if (callable.isMacro()) {
            var fn = callable.getMacro();
            var expanded = fn(rest);
            return eval(expanded, scope);
        }

        if (callable.isFunction()) {
            var fn = callable.getFunction();
            var parameters = eval_parameters(rest, scope);

            if (parameters.isError()) {
                return parameters;
            }
            else {
                return fn(parameters);
            }
        }

        return ArrlType.Error("Found non callable value '" + callable + "'' in virst value of list '" + expression + "'");
    }
}
