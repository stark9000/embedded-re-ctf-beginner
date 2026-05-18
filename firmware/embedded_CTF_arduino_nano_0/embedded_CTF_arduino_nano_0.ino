#define LED_PIN 13

volatile int blinkDelay = 500;
boolean doneFlag = false;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(9600);
  Serial.println("CHECKING...");
}

void loop() {
  digitalWrite(LED_PIN, HIGH);
  delay(blinkDelay);

  digitalWrite(LED_PIN, LOW);
  delay(blinkDelay);

  if (blinkDelay == 100) {
    if (!doneFlag) {
      Serial.println("FLAG{patched_the_firmware}");
    }
    doneFlag = true;
  } else {
    Serial.println("SYSTEM LOCKED");
  }
}
