SWindow :: struct
{
    WindowPtr : *SDL_Window = null;
    WindowSurface : *SDL_Surface = null;
    SurfaceWidth : s32 = 0;
    SurfaceHeight : s32 = 0;

    InitialiseWindow :: (InWindow : *SWindow, InWindowTitle : string, InWidth : s32, InHeight : s32) -> bool
    {
        InWindow.WindowPtr = SDL_CreateWindow(InWindowTitle.data, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, InWidth, InHeight, SDL_WINDOW_OPENGL|SDL_WINDOW_SHOWN);

        if InWindow.WindowPtr == null
        {
            print("Could not create window: %\n", to_string(SDL_GetError()));
            return false;
        }

        InWindow.WindowSurface = SDL_GetWindowSurface(InWindow.WindowPtr);
        InWindow.SurfaceWidth = InWindow.WindowSurface.w;
        InWindow.SurfaceHeight = InWindow.WindowSurface.h;
        return true;
    }

    DestroyWindow :: (InWindow : *SWindow)
    {
        SDL_DestroyWindow(InWindow.WindowPtr);
    }

    GetPixels :: (InWindow : *SWindow) -> *u32
    {
        return InWindow.WindowSurface.pixels;
    }

    SetWindowPosition :: (InWindow : *SWindow, InX : s32, InY : s32)
    {
        SDL_SetWindowPosition(InWindow.WindowPtr, InX, InY);
    }
}
