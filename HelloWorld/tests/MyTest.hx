class TestFoo extends haxe.unit.TestCase {
    public function testBasic(){
        assertEquals( "A", "A" );
    }
}

class MyTest {
    static function main(){
        var runner = new haxe.unit.TestRunner();

        runner.add(new TestFoo());

        runner.run();
    }
}
