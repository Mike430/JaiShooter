#import "Basic";
#import "SDL";
#import "String";
#import "Math";
#load "Utilities.jai";
#load "Window.jai";
#load "Player.jai";
#load "Scene.jai";
#load "Game.jai";
#load "Editor.jai";

main :: ()
{
    SDL_Init(SDL_INIT_VIDEO);
    print("SDL_VERSION =   \t\t%\n", to_string(SDL_GetRevision()));

    Game : SGame;
    SceneEditor : SEditor;
    Scene : SScene;

    Game.InitialiseGame(*Game, "JAI SHOOTER", SCREEN_WIDTH, SCREEN_HEIGHT);
    SceneEditor.InitialiseEditor(*SceneEditor, "EDITOR WINDOW", 800, 800);
    
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
                case SDL_WINDOWEVENT;
                    if event.window.event == SDL_WINDOWEVENT_CLOSE exit = true;
            }
        }

        Game.UpdateGame(*Game, *Scene);
        SceneEditor.UpdateEditor(*SceneEditor, *Scene);

        Game.DrawGame(*Game, *Scene);
        SceneEditor.DrawEditor(*SceneEditor, *Scene);

        // REPLACE WITH PROPER TIMER LOGIC
        SDL_Delay(16);
    }

    Game.GameWindow.DestroyWindow(*Game.GameWindow);
    SceneEditor.EditorWindow.DestroyWindow(*SceneEditor.EditorWindow);
    SDL_Quit();
}