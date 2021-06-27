// the setup function runs once when you press reset or power the board
void setup() {
    // initialize digital pin LEDB as an output.
    pinMode(LEDB, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
   digitalWrite(LEDB, LOW); // turn the red LED on (LOW is the voltage level)
   delay(500); // wait for 500 milliseconds
   digitalWrite(LEDB, HIGH); // turn the LED off by making the voltage HIGH
   delay(500); // wait for 500 milliseconds
}
