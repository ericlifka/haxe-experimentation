package;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Assets;

class Main extends Sprite {
	public function new() {
		super();

        var bitmapData = Assets.getBitmapData("assets/openfl.png");
        var bitmap = new Bitmap(bitmapData);
        addChild(bitmap);

        bitmap.x = 100;
        bitmap.y = 200;
	}

    static public function main() {
        trace("Hello World!");
    }
}