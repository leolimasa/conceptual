package flixel.perspectives;

import game.interfaces.Positionable;
import conceptual.bases.SimplePerspective;

class FlixelSprite extends SimplePerspective
    implements Positionable {

    var square:FlxSprite;

    public function new() {
    }

    public function increment_y(by:Float) {
        square.y += by;
    }
}