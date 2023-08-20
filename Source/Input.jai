// Credit and basic resources for getting input working go to this tutorial: https://blog.rubenwardy.com/2023/01/24/using_sdl_gamecontroller/
JOYSTICK_DEAD_ZONE :: 8000; // https://lazyfoo.net/tutorials/SDL/19_gamepads_and_joysticks/index.php - "The way SDL handles analog sticks on a game controller is that it converts its position into a number between -32768 and 32767"

SControllerInput :: struct
{
	RightJoyStick : Vector2;
	LeftJoyStick : Vector2;
}

ShooterGlobalController : *SDL_GameController;
ShooterGlobalControllerInputs : SControllerInput;

FindGameControllers :: () -> *SDL_GameController
{
	NumberOfJoysticks := SDL_NumJoysticks();

	for i: 0 .. NumberOfJoysticks
	{
		if SDL_IsGameController(i)
		{
			return SDL_GameControllerOpen(i);
		}
	}

	return null;
}

ProcessControllerEvents :: ()
{
	if ShooterGlobalController != null
    {
    	LX : float = cast(float) SDL_GameControllerGetAxis(ShooterGlobalController, SDL_GameControllerAxis.SDL_CONTROLLER_AXIS_LEFTX);
    	LY : float = cast(float) SDL_GameControllerGetAxis(ShooterGlobalController, SDL_GameControllerAxis.SDL_CONTROLLER_AXIS_LEFTY) * -1;
    	RX : float = cast(float) SDL_GameControllerGetAxis(ShooterGlobalController, SDL_GameControllerAxis.SDL_CONTROLLER_AXIS_RIGHTX);
    	RY : float = cast(float) SDL_GameControllerGetAxis(ShooterGlobalController, SDL_GameControllerAxis.SDL_CONTROLLER_AXIS_RIGHTY) * -1;
    	ShooterGlobalControllerInputs.RightJoyStick.x = ifx RX > JOYSTICK_DEAD_ZONE || RX < -JOYSTICK_DEAD_ZONE then RX / cast(float) S16_MAX else 0.0;
    	ShooterGlobalControllerInputs.RightJoyStick.y = ifx RY > JOYSTICK_DEAD_ZONE || RY < -JOYSTICK_DEAD_ZONE  then RY / cast(float) S16_MAX else 0.0;
    	ShooterGlobalControllerInputs.LeftJoyStick.x = ifx LX > JOYSTICK_DEAD_ZONE || LX < -JOYSTICK_DEAD_ZONE  then LX / cast(float) S16_MAX else 0.0;
    	ShooterGlobalControllerInputs.LeftJoyStick.y = ifx LY > JOYSTICK_DEAD_ZONE || LY < -JOYSTICK_DEAD_ZONE  then LY / cast(float) S16_MAX else 0.0;
    }
    else
    {
    	ShooterGlobalControllerInputs.RightJoyStick = Vector2.{0.0, 0.0};
    	ShooterGlobalControllerInputs.LeftJoyStick = Vector2.{0.0, 0.0};
    }
}