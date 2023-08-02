SEditor :: struct
{
	EditorWindow : SWindow;
	MousePosition : Vector2;
	EditorRenderer : *SDL_Renderer = null;

	InitialiseEditor :: (InEditor : *SEditor, InEditorName : string, InWindowWidth : s32, InWindowHeight : s32) -> bool
	{
    	InEditor.EditorWindow.InitialiseWindow(*InEditor.EditorWindow, InEditorName, InWindowWidth, InWindowHeight);
    	InEditor.EditorRenderer = SDL_CreateRenderer(InEditor.EditorWindow.WindowPtr, -1, .ACCELERATED);

    	if InEditor.EditorRenderer == null
        {
            print( "Editor Renderer could not be created! SDL Error: %\n", SDL_GetError() );
            return false;
        }

        return true;
	}

	UpdateEditor :: (InEditor : *SEditor, InScene : *SScene)
	{
		X, Y : s32;
		MouseState : u32 = SDL_GetMouseState(*X, *Y);
		InEditor.MousePosition.x = cast(float)X;
		InEditor.MousePosition.y = cast(float)Y;
	}

	DrawEditor :: (InEditor : *SEditor, InScene : *SScene)
	{
        SDL_SetRenderDrawColor( InEditor.EditorRenderer, 0, 0, 0, 0 );
        SDL_RenderClear(InEditor.EditorRenderer);
        
        DrawWorld(InEditor, InScene);

        SDL_UpdateWindowSurface(InEditor.EditorWindow.WindowPtr);
        SDL_RenderPresent(InEditor.EditorRenderer);
	}

	DrawWorld :: (InEditor : *SEditor, InScene : *SScene)
	{
		for Wall, WIndex : InScene.Walls
		{
			for Corner, CIndex : Wall.Corners
			{
				DrawShape_Circle(InEditor, Corner, 10, 0, 255, 0);

				if CIndex < Wall.Corners.count - 1 { DrawShape_Line(InEditor, Corner, Wall.Corners[CIndex + 1], 0, 255, 0); }
				else if Wall.Loops == true {DrawShape_Line(InEditor, Corner, Wall.Corners[0], 0, 255, 0);}
			}
		}

		DrawShape_Arrow(InEditor, InScene.Player.Transform, 17.5, 0, 255, 255);
        DrawShape_Cross(InEditor, InEditor.MousePosition, 15.0, 255, 0, 0);
        //DrawShape_Cross(InEditor, Vector2.{370.833, 370.833}, 10, 0, 255, 255);

        for RayDir, RayIndex : InScene.RayData.RayDirections
        {
        	DrawShape_Line(InEditor, InScene.Player.Transform.Position, InScene.Player.Transform * (RayDir * InScene.RayData.RayMeasurements[RayIndex]), 255, 255, 255);
        }
	}

	DrawShape_Cross :: (InEditor : *SEditor, InLocation : Vector2, InExtent : float, InR : u8, InG : u8, InB : u8)
	{
		DrawShape_Line(InEditor, Vector2.{InLocation.x - InExtent, InLocation.y + InExtent}, Vector2.{InLocation.x + InExtent, InLocation.y - InExtent}, InR, InG, InB);
		DrawShape_Line(InEditor, Vector2.{InLocation.x - InExtent, InLocation.y - InExtent}, Vector2.{InLocation.x + InExtent, InLocation.y + InExtent}, InR, InG, InB);
	}

	DrawShape_Circle :: (InEditor : *SEditor, InLocation : Vector2, InRadius : float, InR : u8, InG : u8, InB : u8)
	{
		Resolution := 8;
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

	DrawShape_Arrow :: (InEditor : *SEditor, InTransform : STransform2D, InScale : float, InR : u8, InG : u8, InB : u8)
	{
		Position : Vector2 = InTransform.Position;
		Forward : Vector2 = Transform2D_CalcForwards(InTransform);
		Right : Vector2 = Transform2D_CalcRight(InTransform);

		PointA : Vector2 = Position + (InScale * ((Right * 0.0) + (Forward * 1.0)));
		PointB : Vector2 = Position + (InScale * ((Right * 0.75) + (Forward * -1.0)));
		PointC : Vector2 = Position + (InScale * ((Right * 0.0) + (Forward * -0.5)));
		PointD : Vector2 = Position + (InScale * ((Right * -0.75) + (Forward * -1.0)));
		DrawShape_Line(InEditor, PointA, PointB, InR, InG, InB);
		DrawShape_Line(InEditor, PointB, PointC, InR, InG, InB);
		DrawShape_Line(InEditor, PointC, PointD, InR, InG, InB);
		DrawShape_Line(InEditor, PointD, PointA, InR, InG, InB);
	}

	DrawShape_Line :: (InEditor : *SEditor, InStartLocation : Vector2, InEndLocation : Vector2, InR : u8, InG : u8, InB : u8)
	{
        SDL_SetRenderDrawColor(InEditor.EditorRenderer, InR, InG, InB, 255);
        SDL_RenderDrawLine(InEditor.EditorRenderer, cast(s32)InStartLocation.x, cast(s32)InStartLocation.y, cast(s32)InEndLocation.x, cast(s32)InEndLocation.y);
	}
}