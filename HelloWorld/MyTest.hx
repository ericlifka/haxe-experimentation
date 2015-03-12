package;

import Arrl;
import Parser;

class TestFoo extends haxe.unit.TestCase {
    public function testBasic() {
        assertEquals("A", "A");
    }
}

class TestParser extends haxe.unit.TestCase {
    public function testInstantiation() {
        var a = new Arrl();
        var p = new Parser();
        assertTrue(a != null);
        assertTrue(p != null);
    }
}

class MyTest {
    static function main() {
        var runner = new haxe.unit.TestRunner();

        runner.add(new TestFoo());
        runner.add(new TestParser());

        runner.run();
    }
}
