SCREEN_WIDTH :: 1280;
SCREEN_HEIGHT :: 800;

DEGREES_TO_RADIANS :: 0.0174533;
RADIANS_TO_DEGREES :: 57.2958;

STransform2D :: struct
{
	Position : Vector2;
	Orientation : float;
}

Transform2D_CalcForwards :: (InT : STransform2D) -> Vector2
{
	OrientationRadians : float = InT.Orientation * DEGREES_TO_RADIANS;
	return Vector2.{sin(OrientationRadians), cos(OrientationRadians)};
}

Transform2D_CalcRight :: (InT : STransform2D) -> Vector2
{
	OrientationRadians : float = InT.Orientation * DEGREES_TO_RADIANS;
	return Vector2.{-cos(OrientationRadians), sin(OrientationRadians)};
}

//		operator * :: (a : STransform2D, b : STransform2D) -> STransform2D
//		{
//		}