# Adding a reset button

I have added a reset button to the breakout board (connecting pin 84 to GND when the button is pressed).
The [button.v](/src/button.v) module 
[debounces](https://en.wikipedia.org/wiki/Switch#Contact_bounce)
the `resetn_pin` input signal and holds the `resetn` wire low for several clock cycles to ensure good reset.
The `resetn_pin` is active low, so the internal pull up resistor is enabled in the configuration file.
To avoid [metastability](https://en.wikipedia.org/wiki/Metastability_in_electronics) problems
we use an extra register indirection on the pins.

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
The Lattice Diamond toolchain will recognize this pattern and implement it with efficient
asynchronous reset logic on the flip-flops, and use the `resetn` signal to drive the global reset network (that is, the GSR module will be instantiated automatically and connected to the `reset_gen` module).

The other option would have been to use the `GSR GSR_INST(.GSR(resetn));` component in the top-level module and use this pattern
```
initial begin
    // initialize registers with default values
end

always @(posedge clock)
begin
    // do regular register updates
end
```
The two solutions produce the exact same configuration for Lattice FPGAs, but the former one
is portable while the later one is more Lattice specific.
