int ledPin = 13;

uint8_t buf[8] = {
  0 };

void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
  delay(200);
}

void loop() {
  digitalWrite(ledPin, HIGH);
  delay(1000);
  digitalWrite(ledPin, LOW);
  delay(1000);

  int chars[2] = {11, 12};
  buf[2] = chars[0];
  Serial.write(buf, 8);

  buf[0] = 0;
  buf[2] = 0;
  Serial.write(buf, 8);
  delay(100);

  buf[2] = chars[1];
  Serial.write(buf, 8);

  buf[0] = 0;
  buf[2] = 0;
  Serial.write(buf, 8);
}

