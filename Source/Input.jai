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
    	LY : float = cast(float) SDL_GameControllerGetAxis(ShooterGlobalController, SDL_GameControllerAxis.SDL_CONTROLLER_AXIS_LEFTY);
    	RX : float = cast(float) SDL_GameControllerGetAxis(ShooterGlobalController, SDL_GameControllerAxis.SDL_CONTROLLER_AXIS_RIGHTX);
    	RY : float = cast(float) SDL_GameControllerGetAxis(ShooterGlobalController, SDL_GameControllerAxis.SDL_CONTROLLER_AXIS_RIGHTY);
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