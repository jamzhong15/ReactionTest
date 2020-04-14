int LED1 = 3, LED2 = 4, LED3 = 5, BUZZER = 2;
int BUTTON1 = 8, BUTTON2 = 9, BUTTON3 = 10;
int light;
long start_time, time_now, reaction;

float seconds(long microseconds);

void setup()
{
  // Method of setup and use of built-in functions was 
  // learnt from the arduino references and examples
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(BUZZER, OUTPUT);
  pinMode(BUTTON1, INPUT);
  pinMode(BUTTON2, INPUT);
  pinMode(BUTTON3, INPUT);
  
  //Led pattern signalling the game starting
  for(int i = 3; i<6; i++)
  {
    digitalWrite(i, HIGH);
    tone(2, 130, 500);
    delay(1000);
    digitalWrite(i, LOW);
  }
  delay(2000);
  Serial.begin(9600);
  randomSeed(analogRead(A0));
}

void loop()
{
  //Start the sequence of turning random leds on
  
  light = random(3,6);
  digitalWrite(light, HIGH);
  start_time = micros();
  while(digitalRead(light) == HIGH)
  {
    time_now = micros();
    reaction = time_now - start_time;
    
    // Goes on to the next led if it takes too long
   
    if(reaction >= 1500000)
    {
      digitalWrite(light, LOW);
      tone(2, 70, 200);
      delay(random(1000, 3000));
      loop();
    }
    
    // Check if the player hits the correct button
    else if(digitalRead(light + 5) == HIGH)
    { 
      Serial.println(seconds(reaction));
      tone(2, 150, 200);
      digitalWrite(light, LOW);
      delay(random(1000, 3000));
     } 
    
  }
}


float seconds(long microseconds)
{
  return float(microseconds)/1000000;
}
