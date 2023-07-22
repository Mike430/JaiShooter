#import "Basic";
#import "SDL";
#import "String";
#import "Math";
#load "Utilities.jai";
#load "Window.jai";

Editor :: struct
{
	EditorWindow : Window;
	MousePosition : Vector2;
	MouseTrailA : Vector2;
	MouseTrailB : Vector2;
	MouseTrailC : Vector2;
	MouseTrailD : Vector2;
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
		InEditor.MouseTrailD = InEditor.MouseTrailC;
		InEditor.MouseTrailC = InEditor.MouseTrailB;
		InEditor.MouseTrailB = InEditor.MouseTrailA;
		InEditor.MouseTrailA = InEditor.MousePosition;
		InEditor.MousePosition.x = cast(float)X;
		InEditor.MousePosition.y = cast(float)Y;
	}

	DrawEditor :: (InEditor : *Editor)
	{
        SDL_SetRenderDrawColor( InEditor.EditorRenderer, 0, 0, 0, 0 );
        SDL_RenderClear(InEditor.EditorRenderer);

        DrawWorld(InEditor);

        SDL_UpdateWindowSurface(InEditor.EditorWindow.WindowPtr);
        SDL_RenderPresent(InEditor.EditorRenderer);
	}

	DrawWorld :: (InEditor : *Editor)
	{
        DrawShape_Cross(InEditor, InEditor.MousePosition, 15.0, 255, 0, 0);
        DrawShape_Circle(InEditor, InEditor.MouseTrailA, 12.0, 0, 234, 255);
        DrawShape_Circle(InEditor, InEditor.MouseTrailB, 9.0, 0, 234, 255);
        DrawShape_Circle(InEditor, InEditor.MouseTrailC, 6.0, 0, 234, 255);
        DrawShape_Circle(InEditor, InEditor.MouseTrailD, 3.0, 0, 234, 255);
	}

	DrawShape_Cross :: (InEditor : *Editor, InLocation : Vector2, InExtent : float, InR : u8, InG : u8, InB : u8)
	{
		DrawShape_Line(InEditor, Vector2.{InLocation.x - InExtent, InLocation.y + InExtent}, Vector2.{InLocation.x + InExtent, InLocation.y - InExtent}, InR, InG, InB);
		DrawShape_Line(InEditor, Vector2.{InLocation.x - InExtent, InLocation.y - InExtent}, Vector2.{InLocation.x + InExtent, InLocation.y + InExtent}, InR, InG, InB);
	}

	DrawShape_Circle :: (InEditor : *Editor, InLocation : Vector2, InRadius : float, InR : u8, InG : u8, InB : u8)
	{
		Resolution := 12;
		Division := 360 / Resolution;
		Counter := 0;

		while Counter < 360
		{
			Step := Counter + Division;
			StartLocation : Vector2 = InLocation + ( make_vector2(sin(Counter * DEGREES_TO_RADIANS), cos(Counter * DEGREES_TO_RADIANS)) * InRadius);
			EndLocation : Vector2 = InLocation + ( make_vector2(sin(Step * DEGREES_TO_RADIANS), cos(Step * DEGREES_TO_RADIANS)) * InRadius);

			DrawShape_Line(InEditor, StartLocation, EndLocation, InR, InG, InB);

			Counter += Division;
		}
	}

	DrawShape_Line :: (InEditor : *Editor, InStartLocation : Vector2, InEndLocation : Vector2, InR : u8, InG : u8, InB : u8)
	{
        SDL_SetRenderDrawColor(InEditor.EditorRenderer, InR, InG, InB, 255);
        SDL_RenderDrawLine(InEditor.EditorRenderer, cast(s32)InStartLocation.x, cast(s32)InStartLocation.y, cast(s32)InEndLocation.x, cast(s32)InEndLocation.y);
	}
}