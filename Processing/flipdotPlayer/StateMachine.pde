static final int INTRO = 0;
static final int VIDEO = 1; // videos von festplatte laden
static final int IMAGES = 2; // bilder von festplatte laden
static final int CALENDAR = 3; // events aus kalender lesen
static final int INPUT = 4; // input via web auslesen
static final int TIME = 5; // uhrzeit, z.B. jede viertel oder halbe stunde
static final int INTERVENTION = 6; // störer oder marquee? z.B. livingthecity.eu
static final int TRANSITION = 7; // plays random transition from the transition folder

int state = INTRO;

static final String[] stateNames = {
  "Intro", "Video", "Images",
  "Hochwandern", "Soundreaktiv", "Perlin",
  "Flocking", "PingPong", "H. Wellen",
  "V. Wellen", "Aufwaerts", "Statische Bilder"
};

String getStateName(int state) {
  return stateNames[state];
}

void stateMachine(int state) {
  
   switch(state) {
    case INTRO:
      setState(IMAGES);
    break;
    
    case VIDEO:
      //if(!isPlaying) return;
      if(myMovie.available()) {
        background(gray);
        myMovie.read();
        
        source = myMovie.get();
        newFrame = myMovie;
        shrink = shrinkToFormat(newFrame);
        
        push();
        source.resize(196, 0);
        if(panelLayout == 0) {
          translate(8, 200);
        } else if(panelLayout == 1) {
          translate(300, 22);
        }
        
        image(source, 0, 0);
        if(dither) {
          d.feed(source);
          image(d.floyd_steinberg(), 200, 0);
        }
        pop();
        
        if(dither) {
          d.feed(shrink);
          shrink = d.floyd_steinberg();
        }
        feedBuffer(shrink);
        flipdots.feed(shrink);
        
        
        push();
        if(panelLayout == 0) {
          image(pg, 8, 95, width-22, 71);
        } else if(panelLayout == 1) {
          image(pg, 150, 8, 140, height-61);
        }
        pop();
        
        flipdots.update();
        flipdots.display();
        send();
        
        push();
        if(panelLayout == 0) {
          translate(8, 170);
        } else if(panelLayout == 1) {
          translate(8, height-20);
        }
        
        noStroke();
        rect(0, 0, map(myMovie.time(), 0, myMovie.duration(), 0, width-22), 6);
        pop();
        
      }
    break;
    
    case IMAGES:
      feedBuffer(staticImage);
      flipdots.feed(staticImage);
      
      push();
      image(pg, 5, height-160, 28*11, 14*11);
      pop();
        
      flipdots.update();
      flipdots.display();
      send();
    break;
   }
}

void setState(int s) {
  state = s;
}
