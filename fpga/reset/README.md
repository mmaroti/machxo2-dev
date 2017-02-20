# Adding a reset button

I have added a reset button to the breakout board (connecting pin 84 to GND when the button is pressed).
The [reset.v](reset.v) module debounces the `resetn_pin` input signal and holds the
`resetn` wire low for several clock cycles to ensure good reset. The `resetn_pin` is active low,
so the internal pull up resistor is enabled in the configuration file.

The [reset_app.v](reset_app.v) application sets the LEDs to the `8'b10101010` pattern 
when the reset button is pressed, and otherwise it works like the blink application.
In the application I have increased the width of the debouncing counter to 27 for testing purposes:
this way one needs to press the reset button for approximately 1 second before it is registered,
and the reset lasts this long as well.

After reading a lot about reset signals, I have decided to use active low asynchronous resets. 
This means that register updates will be triggered by `clock` and `resetn`, 
and will have the following pattern:
```
always @(posedge clock or negedge resetn)
begin
    if (!resetn)
        // initialize registers with default values
    else
        // do regular register updates
end
```
The Lattice Diamond tool chain will recognize this pattern and implement it with efficient 
asynchronous reset logic on the flip-flops. The `reset_gen` module will simply drive the reset network
(using the GSR module which will be instantiated automatically).
