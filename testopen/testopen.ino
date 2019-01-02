//#include <Servo.h>

//Servo Variables **************************************************************


int chamber_w[3] = {9, 10, 11}; 
byte x; 
int i =0, count, count2;
//byte ledByte[4000];
byte p1[1100],p2[1100],p3[1100];

int check=0;
int ini=0;
int j=0;
int hyh=10;
//*******************************************************************************
void setup()
{
  Serial.begin(9600);
  Serial.setTimeout(10000); 
  randomSeed(1);
  
 // TCCR2B = TCCR2B & 0b11111000 | 0x01;
 // TCCR1B = TCCR1B & 0b11111000 | 0x01;
 
  for(int i = 0; i<3; i= i+1)
    {  pinMode(chamber_w[i], OUTPUT);}


  
 i=0;
cli();//stop interrupts


  //set timer1 interrupt at 1kHz
  TCCR3A = 0;// set entire TCCR1A register to 0
  TCCR3B = 0;// same for TCCR1B
  TCNT3  = 0;//initialize counter value to 0;
  // set timer count for 40 hz increments
  OCR3A = 39999;// = (16*10^6) / (1000*8) - 1
  // turn on CTC mode
  TCCR3B |= (1 << WGM12);
  // Set CS11 bit for 8 prescaler
  TCCR3B |= (1 << CS11);   
  // enable timer compare interrupt
  TIMSK3 |= (1 << OCIE1A);
  
  
  sei();//allow interrupts



}



ISR(TIMER3_COMPA_vect){
  if (check>0){


//   
  analogWrite(chamber_w[0], p1[j]);
  analogWrite(chamber_w[1], p2[j]);
  analogWrite(chamber_w[2], p3[j]);

   j++;
   i++;

   if (i>99){ //199
  //    i=0;j=62;}
     check=0;}
  }//end do

}    





void loop(){
//
            do{
              if (Serial.available()){
                 
                 p1[ini]=Serial.parseInt();
                p2[ini] = Serial.parseInt();
                p3[ini] = Serial.parseInt();
              
                Serial.println(p1[ini]);
                   Serial.println(p2[ini]);
               Serial.println(p3[ini]);
                       ini++;
                }
              
              }
              while (ini<101);


             
             do{
            if(Serial.available())
            {if (Serial.parseInt()==256)
              {check=1;
              i=0;
              Serial.println(p1[ini-3]);
              } 
              }
             }
              while(check==0);           
              
            // digitalWrite(13, HIGH);



}
              
