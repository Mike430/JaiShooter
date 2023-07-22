#import "Basic";
#import "SDL";
#import "String";
#import "Math";
#load "Editor.jai";
#load "Level.jai";

main :: ()
{
    SDL_Init(SDL_INIT_VIDEO);
    print("SDL_VERSION =   \t\t%\n", to_string(SDL_GetRevision()));

    GameWindow : Window;
    GameWindow.InitialiseWindow(*GameWindow, "JAI SHOOTER", 1280, 800);

    LevelEditor : Editor;
    LevelEditor.InitialiseEditor(*LevelEditor);
    
    PixelPtr : *u32 = GameWindow.WindowSurface.pixels;
    
    exit := false;
    while !exit
    {
        event : SDL_Event;
        while SDL_PollEvent(*event)
        {
            if event.type ==
            {
                case SDL_QUIT;
                    exit = true;
                case SDL_KEYUP;
                    if event.key.keysym.sym == SDLK_ESCAPE exit = true;
            }
        }

        LevelEditor.UpdateEditor(*LevelEditor);

        for y : 0 .. GameWindow.SurfaceHeight - 1
        {
            for x : 0 .. GameWindow.SurfaceWidth - 1
            {
                PixelIndex := (y * GameWindow.SurfaceWidth) + x;
                xComponent : float = ((cast(float)x + 1) / 1280);
                yComponent : float = ((cast(float)y + 1) / 800);
                Clamp(*xComponent, 0, 1);
                Clamp(*yComponent, 0, 1);
                number : float = ((xComponent + yComponent) / 2);
                Clamp(*number, 0, 1);

                r : u8 = cast(u8) (number * 255);
                g : u8 = cast(u8) (xComponent * 255);
                b : u8 = cast(u8) (yComponent * 255);
                a : u8 = 255;
                PixelPtr[PixelIndex] = SDL_MapRGBA(GameWindow.WindowSurface.format, r, g, b, a);
            }
        }

        SDL_UpdateWindowSurface(GameWindow.WindowPtr);
        LevelEditor.DrawEditor(*LevelEditor);

        // REPLACE WITH PROPER TIMER LOGIC
        SDL_Delay(16);
    }

    GameWindow.DestroyWindow(*GameWindow);
    LevelEditor.EditorWindow.DestroyWindow(*LevelEditor.EditorWindow);
    SDL_Quit();
}