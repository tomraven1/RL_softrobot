//#include <Servo.h>

//Servo Variables **************************************************************


int chamber_w[3] = {9, 10, 11}; 
float x; 
int i =0, count, count2;
//byte ledByte[4000];
byte p1[100],p2[100],p3[100];
int check=0;
int kk=0;
int j=0;
int hyh=30;
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

   if (i%hyh==0)
   {
    p1[j]=random(10,90);
    p2[j]=random(10,90);
    p3[j]=random(10,90);

   //analogWrite(chamber_w[0], p1[j]);
   
 //  analogWrite(chamber_w[1], p2[j]);
  // analogWrite(chamber_w[2], p3[j]);
   }
   else if (i<10)
   {
    p1[j]=0;
     p2[j]=0;
      p3[j]=0;
    }
   else
  { p1[j]=p1[j-1];
  p2[j]=p2[j-1];
  p3[j]=p3[j-1];}
//
   Serial.println(p1[j]);
   Serial.println(p2[j]);
   Serial.println(p3[j]);
//   
//  analogWrite(chamber_w[0], p1[j]);
//  analogWrite(chamber_w[1], p2[j]);
//  analogWrite(chamber_w[2], p3[j]);

   j++;
   i++;
   if (j==100){j=0;
   hyh=random(10,25);}
   if (i>12000){check=0;kk=1;}
  }//end do

}    





void loop(){
//
//            do{
//              if (Serial.available()){
//                ledByte[j] = Serial.parseInt();
//                 j++;
//                }
//              
//              }
//              while (j<1001);
             // i=2;

//do{Serial.println(ledByte[i]);}
//while(kk==1);

             
             do{
            if(Serial.available())
            {if (Serial.parseInt()==256)
              {check=1;
              i=0;}
              } 
              }
              while(check==0);           
              
            // digitalWrite(13, HIGH);


            



}
              
