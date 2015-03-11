class TestFoo extends haxe.unit.TestCase {

    public function testBasic(){
        assertEquals( "A", "A" );
    }

}

class MyTest {

    static function main(){
        var r = new haxe.unit.TestRunner();
        r.add(new TestFoo());
        // your can add others TestCase here

        // finally, run the tests
        r.run();
    }
}
