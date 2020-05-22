const int PIN_LEFT=7;
const int PIN_DOWN=6;
const int PIN_UP=5;
const int PIN_RIGHT=4;

bool pressedState[4] = { false };

void setup() {
  Serial.begin(9600);
  pinMode(PIN_LEFT, INPUT_PULLUP);
  pinMode(PIN_DOWN, INPUT_PULLUP);
  pinMode(PIN_UP, INPUT_PULLUP);
  pinMode(PIN_RIGHT, INPUT_PULLUP);

  Serial.write("running\r\n\r\n");
  delay(1000);
}

void loop() {
  if (!digitalRead(PIN_LEFT)) {
    Serial.write("left\r\n");
  }
  if (!digitalRead(PIN_DOWN)) {
    Serial.write("down\r\n");
  }
  if (!digitalRead(PIN_UP)) {
    Serial.write("up\r\n");
  }
  if (!digitalRead(PIN_RIGHT)) {
    Serial.write("right\r\n");
  }
  delay(1000); 
}

