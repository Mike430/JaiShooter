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
	{}

	DrawGame :: (InGame : SGame, InScene : *SScene)
	{
		Height := InGame.GameWindow.SurfaceHeight;
		Width := InGame.GameWindow.SurfaceWidth;
		PixelPtr : *u32 = InGame.GameWindow.WindowSurface.pixels;

		for y : 0 .. Height - 1
        {
            for x : 0 .. Width - 1
            {
                PixelIndex := (y * InGame.GameWindow.SurfaceWidth) + x;
                xComponent : float = ((cast(float)x + 1) / Height);
                yComponent : float = ((cast(float)y + 1) / Width);
                Clamp(*xComponent, 0, 1);
                Clamp(*yComponent, 0, 1);
                number : float = ((xComponent + yComponent) / 2);
                Clamp(*number, 0, 1);
                r : u8 = cast(u8) (number * 255);
                g : u8 = cast(u8) (xComponent * 255);
                b : u8 = cast(u8) (yComponent * 255);
                a : u8 = 255;
                PixelPtr[PixelIndex] = SDL_MapRGBA(InGame.GameWindow.WindowSurface.format, r, g, b, a);
            }
        }
        SDL_UpdateWindowSurface(InGame.GameWindow.WindowPtr);
    }
}