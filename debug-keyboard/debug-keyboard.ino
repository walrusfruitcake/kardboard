const int PIN_LEFT=7;
const int PIN_DOWN=6;
const int PIN_UP=5;
const int PIN_RIGHT=4;

bool pressedState[4] = { false };

const unsigned long SLURRY = 100;
unsigned long uptime = 0;
unsigned long lastSpoon = 0;

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
  uptime = millis();
  if (!digitalRead(PIN_LEFT)) {
    pressedState[0] = true;
  }
  if (!digitalRead(PIN_DOWN)) {
    pressedState[1] = true;
  }
  if (!digitalRead(PIN_UP)) {
    pressedState[2] = true;
  }
  if (!digitalRead(PIN_RIGHT)) {
    pressedState[3] = true;
  }

  if (lastSpoon + SLURRY < uptime) {
    sendCereal();
  }
}

void sendCereal() {
  lastSpoon = uptime;
  if (pressedState[0]) {
    Serial.write("left\r\n");
    pressedState[0] = false;
  }
  if (pressedState[1]) {
    Serial.write("down\r\n");
    pressedState[1] = false;
  }
  if (pressedState[2]) {
    Serial.write("up\r\n");
    pressedState[2] = false;
  }
  if (pressedState[3]) {
    Serial.write("right\r\n");
    pressedState[3] = false;
  }
}

