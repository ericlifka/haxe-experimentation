package;

import arrl.Arrl;

class TestFoo extends haxe.unit.TestCase {
    public function testBasic() {
        assertEquals("A", "A");
    }
}

class TestParser extends haxe.unit.TestCase {
    public function testInstantiation() {
        var a = new Arrl();
        assertTrue(a != null);
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
