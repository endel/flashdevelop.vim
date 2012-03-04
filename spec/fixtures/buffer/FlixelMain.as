package
{
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import framework.sound.SomManager;
    import org.flixel.*;
    import game.core.ILevel;
    import game.scenes.MainMenu;

    [SWF(width="960", height="640", backgroundColor="#000000")]
    [Frame(factoryClass = "Preloader")]

    public class FlixelMain extends Sprite
    {
        private var game : FlxGame;

        public function FlixelMain()
        {
            SomManager.changeSoundAmbiente(SomManager.SOM_AMBIENTE);
            SomManager.playSoundAmbiente();

            game = new FlxGame(960, 640, MainMenu, 1, 64, 64);
            addChild(game);
        }
    }
}

