//#include <Servo.h>

//Servo Variables **************************************************************


int chamber_w[3] = {9, 10, 11}; 
byte x; 
int i =0, count, count2;
//byte ledByte[4000];
byte p1[300]={0};
byte p2[300]={0};
byte p3[300]={0};

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
if ((j%2==0)&&j>1)
{ 
    p1[j]=p1[j];
  p2[j]=p2[j];
  p3[j]=p3[j];
}
else if (j==0)
              { p1[0]=0;
               p2[0]=0;
               p3[0]=0;}
else
{ 
  p1[j]=p1[j-1];
  p2[j]=p2[j-1];
  p3[j]=p3[j-1];
  check=0;
  }
//   


//   Serial.println(p1[j]);
//   Serial.println(p2[j]);
//   Serial.println(p3[j]);

   
  analogWrite(chamber_w[0], p1[j]);
  analogWrite(chamber_w[1], p2[j]);
  analogWrite(chamber_w[2], p3[j]);

   j++;
   i++;

   if (i>199){
    j=0;}
    //check=0;}
  }//end do

}    





void loop(){
//



             
             do{
            if(Serial.available())
            {if (Serial.parseInt()==256)
              {check=1;
              i=0;

              } 
              }
             }
              while(check==0&&i==0);           



              if(Serial.available()&&(j%2==0))
            {                
                p1[j]=Serial.parseInt();
                p2[j] = Serial.parseInt();
                p3[j] = Serial.parseInt();
                check=1;
            }
            // digitalWrite(13, HIGH);



}
              
