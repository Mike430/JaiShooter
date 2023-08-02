SSceneRayData :: struct
{
    FOV : float = 90.0;
    RayLength : float = 1000.0;
    RayDirections : [NUMBER_OF_RAYS]Vector2;
    RayMeasurements : [NUMBER_OF_RAYS]float;
}

//----------------------------------------------------------

SWall :: struct
{
	Loops : bool = false;
	Corners : [..]Vector2;
}

//----------------------------------------------------------

SScene :: struct
{
	Walls : [..]SWall;
	Player : SPlayer;
	RayData : SSceneRayData;
}

//----------------------------------------------------------

SScene_InitialiseRayData :: (InScene : *SScene)
{
	RayAngleSpan := InScene.RayData.FOV;
	MaxRayAngle := (InScene.RayData.FOV * 0.5);
	MinRayAngle := MaxRayAngle * -1;
	RayAngleStepSize := RayAngleSpan / NUMBER_OF_RAYS;

	for RIndex : 0..InScene.RayData.RayDirections.count-1
	{
		RayAngleRadians := (MinRayAngle + (RayAngleStepSize * RIndex)) * DEGREES_TO_RADIANS;
		InScene.RayData.RayDirections[RIndex] = Vector2.{sin(RayAngleRadians), cos(RayAngleRadians)};
	}
}

//----------------------------------------------------------

SSCene_ComputeRayMeasurements :: (InScene : * SScene)
{
	for RayDir, RIndex : InScene.RayData.RayDirections
    {
    	InScene.RayData.RayMeasurements[RIndex] = InScene.RayData.RayLength;
        RayStart := InScene.Player.Transform.Position;
        RayEnd := InScene.Player.Transform * (RayDir * InScene.RayData.RayLength);
        for Wall, WIndex : InScene.Walls
        {
            for Corner, CIndex : Wall.Corners
            {
                if CIndex < Wall.Corners.count - 1
                {
                	Hit, RayDistance := CastRay(RayStart, RayEnd, Corner, Wall.Corners[CIndex + 1]);
                    if Hit == true && RayDistance < InScene.RayData.RayMeasurements[RIndex]
                    {
                    	InScene.RayData.RayMeasurements[RIndex] = RayDistance;
                    }
                }
                else if Wall.Loops == true
                {
                	Hit, RayDistance := CastRay(RayStart, RayEnd, Corner, Wall.Corners[0]);
                    if Hit == true && RayDistance < InScene.RayData.RayMeasurements[RIndex]
                    {
                    	InScene.RayData.RayMeasurements[RIndex] = RayDistance;
                    }
                }
            }
        }
    }
}

//----------------------------------------------------------

CastRay :: (InRayStart : Vector2, InRayEnd : Vector2, InWallStart : Vector2, InWallEnd : Vector2) -> (bool, float)
{
	Intersection : Vector2;
	x1 := InWallStart.x;
	y1 := InWallStart.y;
	x2 := InWallEnd.x;
	y2 := InWallEnd.y;
	x3 := InRayStart.x;
	y3 := InRayStart.y;
	x4 := InRayEnd.x;
	y4 := InRayEnd.y;

	den : float = ((x1 - x2) * (y3 - y4)) - ((y1 - y2) * (x3 - x4));

	if den == 0.0
	{
		return false, -1.0;
	}

	t := ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
	u := -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den;

	if t > 0 && t < 1 && u > 0
	{
		Intersection.x = x1 + t * (x2 - x1);
		Intersection.y = y1 + t * (y2 - y1);
		V : Vector2 = Intersection - InRayStart;
		OutDistance : float = sqrt(V.x*V.x + V.y*V.y);
		return true, OutDistance;
	}
	else
	{
		return false, -1.0;
	}
}

//----------------------------------------------------------
