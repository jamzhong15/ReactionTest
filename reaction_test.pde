import processing.serial.*;
Serial mySerial;

String data = null;
float reaction, sum = 0;
int new_line = 10, x = 100, y = 150;
// These arrays are used to store all previous the values and their positions
float[] times = {}, average= {};  
int[] xpos = {100}, ypos = {150};

void setup()
{
  // Technique of connecting the arduino serial and the processor were learnt from:
  // https://learn.sparkfun.com/tutorials/connecting-arduino-to-processing/all
  // https://processing.org/reference/
  
  String portName = Serial.list()[5]; 
  mySerial = new Serial(this, portName, 9600);
  size(1100,700);
}

void draw()
{
  strokeWeight(1);
  stroke(220,220,220);
  fill(220,220,220,100);
 
  // Only proceed if data is found in a line
  
  while ( mySerial.available() > 0) 
  {
    data = mySerial.readStringUntil(new_line);
    
    if (data != null)
    {
      background(52);
      reaction = float(data);
      // Stop and freeze the program if the maximum amount of data has been obtained
      if(times.length == 17)
      {
       stop();
      }
      
      // Make sure invalid times are not counted
      
      else if(reaction != 0)
      {
        times = append(times, reaction);
        sum += reaction;
        average = append(average, sum/times.length);
      }
        
        // Draw axis and graph layout
   
        line(50,height-50,width -30,height-50);
        line(width - 1050,30,width - 1050,height - 50);
        
        triangle(40, 30, 50, 5, 60, 30);
        triangle(1070, 660, 1070, 640, 1095, 650);
        
        fill(255,165,0);
        rect(800, 200, 7.5, 7.5);
        fill(0,128,128);
        rect(800, 180, 7.5, 7.5);
        fill(220,220,220,100);
        
        clock(170, 50);
        clock(505, 50);
        
        
        for(int i = height-100; i>= 130; i-=50)
        {
             dashed_line(40,i);
         }
       
        
        textSize(30);
        text("[ REACTION DATA ]", 200, 30, 500, 100);
        textSize(50);
        text(data, 500, 100, 500, 100);
        textSize(14);
        text("TIME", 815, 175, 200, 100);
        text("AVERAGE", 815, 195, 200, 100);
        textSize(18);
        text("TIME", 5, 50, 500, 100);
        text("FASTEST:", 800, 50, 500, 100);
        text(str(min(times)), 900, 50, 500, 100);
        text("AVERAGE:", 800, 70, 500, 100);
        text(str(sum/times.length), 900, 70, 500, 100);
        rect(775, 45, 300, 55, 7);
        
        // Display the previous times on the right side
        
        for(int i = 0; i < times.length; i ++)
        {
          text(str(times[i]),1000, ypos[i], 500, 100);
          y += 20;
          ypos = append(ypos, y);
        }
        
        // Plot line graphs of the data 
        
        for(int i = 0; i < times.length; i++)
        {
          // Join current plot with previous ones
          graph_font();
          point(xpos[i], height - (times[i]*height)/2);
          stroke(255,165,0);
          point(xpos[i], height - (average[i]*height)/2);
          if (i > 0)
          {
            plot_font();
            line(xpos[i-1], height - (times[i-1]*height)/2, xpos[i], height - (times[i]*height)/2);
            stroke(255,140,0);
            line(xpos[i-1], height - (average[i-1]*height)/2, xpos[i], height - (average[i]*height)/2 );
          }
        }
        x += 50;
        xpos = append(xpos, x);
        

    }
  
  } 
}

void dashed_line(int x, int y)
{
  fill(220,220,220,50);
  line(x, y, x + 10, y);
}

void clock(int x, int y)
{
  strokeCap(ROUND);
  strokeWeight(2.5);
  ellipse(x, y, 30, 30);
  point(x,y);
  line(x, y, x, y-10);
}

void graph_font()
{
  strokeWeight(6);
  stroke(0,128,128);
  fill(0,128,128,255);
}

void plot_font()
{
  strokeWeight(3);
  stroke(0,206,209);
  fill(0,206,209);
}
