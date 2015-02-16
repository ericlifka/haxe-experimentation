package;

import openfl.display.Sprite;
import openfl.Assets;

class Main extends Sprite {
	public function new () {
		super ();
        var bitmapData = Assets.getBitmapData("assets/openfl.png");
	}

    static public function main() {
        trace("Hello World!");
    }
}