SGame :: struct
{
	GameWindow : SWindow;
	GameRenderer : *SDL_Renderer = null;

	InitialiseGame :: (InGame : *SGame, InGameName : string, InWindowWidth : s32, InWindowHeight : s32) -> bool
	{
		InGame.GameWindow.InitialiseWindow(*InGame.GameWindow, InGameName, InWindowWidth, InWindowHeight);
		InGame.GameRenderer = SDL_CreateRenderer(InGame.GameWindow.WindowPtr, -1, .ACCELERATED);

		if InGame.GameRenderer == null
        {
            print( "Game Renderer could not be created! SDL Error: %\n", SDL_GetError() );
            return false;
        }

        return true;
	}

	UpdateGame :: (InGame : SGame, InScene : *SScene)
	{
        InScene.Player.Transform.Orientation += 1.0;
        //InScene.Player.Transform.Orientation = 150.0;
    }

	DrawGame :: (InGame : SGame, InScene : *SScene)
	{
        // Sample the ray lenght per row

        SDL_UpdateWindowSurface(InGame.GameWindow.WindowPtr);
    }
}