GAME_WINDOW_WIDTH :: 1280;
GAME_WINDOW_HEIGHT :: 800;

EDITOR_WINDOW_WIDTH :: 800;
EDITOR_WINDOW_HEIGHT :: 800;

DEGREES_TO_RADIANS :: 0.0174533;
RADIANS_TO_DEGREES :: 57.2958;

NUMBER_OF_RAYS :: GAME_WINDOW_WIDTH;
RAY_LENGTH :: 1500.0;

UPDATE_PACE :: (60.0);
UPDATE_DELTA :: (1.0 / UPDATE_PACE);
UPDATE_DELAY :: (cast(u32) ((1.0 / UPDATE_PACE) * 1000));


STransform2D :: struct
{
	Position : Vector2;
	Orientation : float;
}

Transform2D_CalcForwards :: inline(InT : STransform2D) -> Vector2
{
	OrientationRadians : float = InT.Orientation * DEGREES_TO_RADIANS;
	return Vector2.{sin(OrientationRadians), cos(OrientationRadians)};
}

Transform2D_CalcRight :: inline(InT : STransform2D) -> Vector2
{
	OrientationRadians : float = InT.Orientation * DEGREES_TO_RADIANS;
	return Vector2.{-cos(OrientationRadians), sin(OrientationRadians)};
}

operator * :: inline(InT : STransform2D, InV : Vector2) -> Vector2
{
	Forward : Vector2 = Transform2D_CalcForwards(InT);
	Right : Vector2 = Transform2D_CalcRight(InT);
	return InT.Position + ((Right * InV.x) + (Forward * InV.y));
}

//		operator * :: (a : STransform2D, b : STransform2D) -> STransform2D
//		{
//		}