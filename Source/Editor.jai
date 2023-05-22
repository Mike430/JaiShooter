#import "Basic";
#import "SDL";
#import "String";
#import "Math";
#load "Window.jai";

Editor :: struct
{
	EditorWindow : Window;
	MousePosition : Vector2;
    EditorRenderer : *SDL_Renderer = null;

	InitialiseEditor :: (InEditor : *Editor) -> bool
	{
    	InEditor.EditorWindow.InitialiseWindow(*InEditor.EditorWindow, "EDITOR WINDOW", 800, 800);
    	InEditor.EditorRenderer = SDL_CreateRenderer(InEditor.EditorWindow.WindowPtr, -1, .ACCELERATED);

    	if InEditor.EditorRenderer == null
        {
            print( "Renderer could not be created! SDL Error: %\n", SDL_GetError() );
            return false;
        }

        return true;
	}

	UpdateEditor :: (InEditor : *Editor)
	{
		X, Y : s32;
		MouseState : u32 = SDL_GetMouseState(*X, *Y);
		InEditor.MousePosition.x = cast(float)X;
		InEditor.MousePosition.y = cast(float)Y;
	}

	DrawEditor :: (InEditor : *Editor)
	{
        SDL_FillRect(InEditor.EditorWindow.WindowSurface, null, SDL_MapRGB(InEditor.EditorWindow.WindowSurface.format, 0, 0, 0));

        SDL_SetRenderDrawColor(InEditor.EditorRenderer, 0xff, 0, 0, 0xff);
        X : s32 = cast(s32)InEditor.MousePosition.x;
        Y : s32 = cast(s32)InEditor.MousePosition.y;
        CursorRadius : s32 = 15;
        SDL_RenderDrawLine(InEditor.EditorRenderer, X - CursorRadius, Y + CursorRadius, X + CursorRadius, Y - CursorRadius);
        SDL_RenderDrawLine(InEditor.EditorRenderer, X - CursorRadius, Y - CursorRadius, X + CursorRadius, Y + CursorRadius);

        SDL_UpdateWindowSurface(InEditor.EditorWindow.WindowPtr);
	}
}