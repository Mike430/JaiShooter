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
#load "Input.jai";

main :: ()
{
    SDL_Init(SDL_INIT_VIDEO | SDL_INIT_GAMECONTROLLER);
    print("SDL_VERSION =   \t\t%\n", to_string(SDL_GetRevision()));

    Game : SGame;
    SceneEditor : SEditor;
    Scene : SScene;

    Game.InitialiseGame(*Game, "JAI SHOOTER", GAME_WINDOW_WIDTH, GAME_WINDOW_HEIGHT);
    SceneEditor.InitialiseEditor(*SceneEditor, "EDITOR WINDOW", 800, 800);
    SScene_InitialiseRayData(*Scene);

    WallA : SWall;
    WallB : SWall;
    array_add(*Scene.Walls, WallA);
    array_add(*Scene.Walls, WallB);

    Scene.Walls[0].Loops = false;
    array_add(*Scene.Walls[0].Corners, Vector2.{500.0, 0.0});
    array_add(*Scene.Walls[0].Corners, Vector2.{600.0, 250.0});
    array_add(*Scene.Walls[0].Corners, Vector2.{350.0, 270.0});
    array_add(*Scene.Walls[0].Corners, Vector2.{400.0, 512.0});

    Scene.Walls[1].Loops = true;
    array_add(*Scene.Walls[1].Corners, Vector2.{50.0, 50.0});
    array_add(*Scene.Walls[1].Corners, Vector2.{50.0, -50.0});
    array_add(*Scene.Walls[1].Corners, Vector2.{-50.0, -50.0});
    array_add(*Scene.Walls[1].Corners, Vector2.{-50.0, 50.0});

    Scene.Player.Transform.Position = Vector2.{200.0, 200.0};
    Scene.Player.Transform.Orientation = 0.0;
    
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
                case SDL_CONTROLLERDEVICEADDED;
                    if ShooterGlobalController == null
                    {
                        ShooterGlobalController = SDL_GameControllerOpen(event.cdevice.which);
                        print("New controller found to use :)\n");
                    }
                case SDL_CONTROLLERDEVICEREMOVED;
                    if ShooterGlobalController != null && event.cdevice.which == SDL_JoystickInstanceID(SDL_GameControllerGetJoystick(ShooterGlobalController))
                    {
                        SDL_GameControllerClose(ShooterGlobalController);
                        ShooterGlobalController = FindGameControllers();

                        if ShooterGlobalController == null print("We lost our controller and found no replacements :(\n");
                        else print("We lost our controller but we're moving on :)\n");
                    }
            }

            ProcessControllerEvents();
        }

        Game.UpdateGame(*Game, *Scene, UPDATE_DELTA);
        SceneEditor.UpdateEditor(*SceneEditor, *Scene, UPDATE_DELTA);

        SSCene_ComputeRayMeasurements(*Scene);
        
        Game.DrawGame(*Game, *Scene);
        SceneEditor.DrawEditor(*SceneEditor, *Scene);

        // REPLACE WITH PROPER TIMER LOGIC
        SDL_Delay(UPDATE_DELAY);
    }

    Game.GameWindow.DestroyWindow(*Game.GameWindow);
    SceneEditor.EditorWindow.DestroyWindow(*SceneEditor.EditorWindow);
    SDL_Quit();
}