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

	UpdateGame :: (InGame : SGame, InScene : *SScene, InDeltaTime : float)
	{
        InScene.Player.Transform.Orientation += -ShooterGlobalControllerInputs.RightJoyStick.x * InScene.Player.TurnSpeed * InDeltaTime;

        Forward := Transform2D_CalcForwards(InScene.Player.Transform);
        Right := Transform2D_CalcRight(InScene.Player.Transform);
        MoveBy := Forward * -ShooterGlobalControllerInputs.LeftJoyStick.y + Right * ShooterGlobalControllerInputs.LeftJoyStick.x;
        MoveBy = unit_vector(MoveBy);
        MoveBy *= InScene.Player.MoveSpeed * InDeltaTime;
        InScene.Player.Transform.Position += MoveBy;
    }

	DrawGame :: (InGame : SGame, InScene : *SScene)
	{
        // Sample the ray lenght per row
        SDL_FillRect(InGame.GameWindow.WindowSurface, null, SDL_MapRGB(InGame.GameWindow.WindowSurface.format, 100, 100, 100));
        PixelPtr : *u32 = InGame.GameWindow.WindowSurface.pixels;
        HalfScreenHeight := SCREEN_HEIGHT / 2;

        for y : 0 .. SCREEN_HEIGHT - 1
        {
        	for x : 0 .. SCREEN_WIDTH - 1
        	{
        		PixelIndex := y * SCREEN_WIDTH + x;
        		PixelRayLength := InScene.RayData.RayMeasurements[x];
        		PixelDepth := (((PixelRayLength / RAY_LENGTH) * -1.0) + 1);
        		WallColumnHeight : s64 = cast(s64)(HalfScreenHeight * PixelDepth);

        		if y < HalfScreenHeight + WallColumnHeight && y > HalfScreenHeight - WallColumnHeight
        		{
        			ColourValue : u8 = cast(u8)(PixelDepth * 255.0);
        			PixelPtr[PixelIndex] = SDL_MapRGBA(InGame.GameWindow.WindowSurface.format, 0, ColourValue, 0, 255);
        		}
        		else if y > HalfScreenHeight
        			PixelPtr[PixelIndex] = SDL_MapRGBA(InGame.GameWindow.WindowSurface.format, 50, 50, 50, 255);
        	}
    	}

        SDL_UpdateWindowSurface(InGame.GameWindow.WindowPtr);
    }
}