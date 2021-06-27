// the setup function runs once when you press reset or power the board
void setup() {
  //bootM4();
  Serial.begin(115200);
}

// the loop function runs over and over again forever
void loop() {
  Serial.println("hello!");
  delay(2000); // wait for 2 seconds
}
