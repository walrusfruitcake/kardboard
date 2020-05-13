int ledPin = LED_BUILTIN;
int inPin = 8;

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(inPin, INPUT);
}

void loop() {
  bool observed = digitalRead(inPin);
  digitalWrite(ledPin, observed);
  delay(10);
}
