#import "Basic";
#import "SDL";
#import "String";
#import "Math";

ScreenData :: struct
{
    WindowPtr : *SDL_Window = null;
    WindowSurface : *SDL_Surface = null;
    SurfaceWidth : s32 = 0;
    SurfaceHeight : s32 = 0;
}

main :: ()
{
    SDL_Init(SDL_INIT_VIDEO);

    ScreenInfo : ScreenData;
    ScreenInfo.WindowPtr = SDL_CreateWindow("Jai Jam Shooter, Fam", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 1280, 800, SDL_WINDOW_OPENGL|SDL_WINDOW_SHOWN);

    if ScreenInfo.WindowPtr == null
    {
        print("Could not create window: %\n", to_string(SDL_GetError()));
        return;
    }

    ScreenInfo.WindowSurface = SDL_GetWindowSurface(ScreenInfo.WindowPtr);
    ScreenInfo.SurfaceWidth = ScreenInfo.WindowSurface.w;
    ScreenInfo.SurfaceHeight = ScreenInfo.WindowSurface.h;
    PixelPtr : *u32 = ScreenInfo.WindowSurface.pixels;
    

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

            SDL_FillRect(ScreenInfo.WindowSurface, null, SDL_MapRGB(ScreenInfo.WindowSurface.format, 0, 0, 0));

            for y : 0 .. ScreenInfo.SurfaceHeight - 1
            {
                for x : 0 .. ScreenInfo.SurfaceWidth - 1
                {
                    PixelIndex := (y * ScreenInfo.SurfaceWidth) + x;
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
                    PixelPtr[PixelIndex] = SDL_MapRGBA(ScreenInfo.WindowSurface.format, r, g, b, a);
                }
            }
            SDL_UpdateWindowSurface(ScreenInfo.WindowPtr);
        }
        SDL_Delay(1);
    }

    // Close and destroy the window
    SDL_DestroyWindow(ScreenInfo.WindowPtr);

    // Clean up
    SDL_Quit();
}