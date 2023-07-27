SWall :: struct
{
	Loops : bool = false;
	Corners : [..]Vector2;
}

SScene :: struct
{
	Walls : [..]SWall;
	Player : SPlayer;
}