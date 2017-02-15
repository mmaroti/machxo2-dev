# Adding a reset button

We add a reset button to our breakout board (connecting pin 84 to GND when the button is pressed).
The [reset.v](reset.v) module debounces the `resetn_pin` input signal and holds the
`resetn` wire low for several clock cycles to ensure good reset. The `resetn_pin` is active low,
so the internal pull up resistor is enabled in the configuration file.
The [reset_app.v](reset_app.v) application sets the LEDs to the `8'b10101010` pattern 
when the reset button is pressed, and otherwise it works like the blink application.
In the application we increase the width of the debouncing counter to 27 for testing purposes:
this way one needs to press the reset button for approximately 1 second before it is registered,
and the reset lasts this long as well.
