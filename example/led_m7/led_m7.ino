// the setup function runs once when you press reset or power the board
void setup() {
  bootM4();
  // initialize digital pin LEDR as an output.
  pinMode(LEDR, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(LEDR, LOW); // turn the red LED on (LOW is the voltage level)
  delay(200); // wait for 200 milliseconds
  digitalWrite(LEDR, HIGH); // turn the LED off by making the voltage HIGH
  delay(200); // wait for 200 milliseconds
}
