SCREEN_WIDTH :: 1280;
SCREEN_HEIGHT :: 800;

DEGREES_TO_RADIANS :: 0.0174533;
RADIANS_TO_DEGREES :: 57.2958;
NUMBER_OF_RAYS :: SCREEN_WIDTH;

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