import processing.sound.*;
import processing.serial.*;
//
Serial MiSerial;
 String temporal="";
String valor="";//número de botón.
int tempos; //tempo
 float nuevo=1;
PImage titulo; //titulo
PImage efectos; //efectos
PImage tracks; //tracks
PImage[] pizzatrap;
color fondo =#ffffff; //background
color fuente=#FEF0CF;
color color1=#FEEDAF;
color color2=#87D7F9;
boolean seguro=false;
boolean empezo=false;
boolean isEasy =false;
Button facil, dificil;

SoundFile kickFile, clapFile, snareFile, hatFile, bajoFile, melodyFile;
Instrumento kick, hat, snare, clap, bajo, melody, btReverb, btLowPass, btHighPass, btBandPass;
//efectos
Reverb reverb;
LowPass lowPass;
HighPass highPass;
BandPass bandPass;

void setup() {
  size(1280, 650);

  //arduino
  MiSerial = new Serial(this, "COM3", 9600);


  //effects
  highPass= new HighPass(this);
  reverb= new Reverb(this);
  lowPass= new LowPass(this);
  bandPass= new BandPass(this);

  //título
  titulo = loadImage("easybeat.png");
  tracks = loadImage("tracks.png");
  efectos = loadImage("efectos.png");


  //tracks
  kickFile = new SoundFile(this, "kick.wav");
  clapFile = new SoundFile(this, "clap.wav");
  snareFile = new SoundFile(this, "snare.wav");
  hatFile = new SoundFile(this, "hat.wav");
  bajoFile = new SoundFile(this, "808.wav");
  melodyFile = new SoundFile(this, "melody.wav");

  //instrumentos
  kick=new Instrumento("track1 on.png", "track1 off.png", kickFile, 200, 170, 200, 50);
  clap=new Instrumento("track2 on.png", "track2 off.png", clapFile, 200, 240, 200, 50);
  snare=new Instrumento("track3 on.png", "track3 off.png", snareFile, 200, 310, 200, 50);
  hat=new Instrumento("track4 on.png", "track4 off.png", hatFile, 200, 380, 200, 50);
  bajo=new Instrumento("track5 on.png", "track5 off.png", bajoFile, 200, 450, 200, 50);
  melody=new Instrumento("track1 on.png", "808-off.png", melodyFile, 200, 380, 200, 50);

  //efectos
  btLowPass=new Instrumento("lowPass on.png", "lowPass off.png", melodyFile, 600, 240, 200, 50);
  btHighPass=new Instrumento("highPass on.png", "highPass off.png", melodyFile, 600, 310, 200, 50);
  btBandPass=new Instrumento("bandPass on.png", "bandPass off.png", melodyFile, 600, 380, 200, 50);
  btReverb=new Instrumento("reverb-on.png", "reverb-off.png", melodyFile, 630, 450, 120, 100);

  //reproducir
  melody.play(1);
  kick.play(0);
  clap.play(0);
  snare.play(0);
  bajo.play(0);
  hat.play(0);

  //boton
  facil= new Button(width/2- int(textWidth(" DIFICIL ")+30), height/2-140, 60, 32, "  FACIL  ", color1, color2, textWidth(" FACIL  ")*2+50);
  dificil=new Button(width/2- int(textWidth(" DIFICIL ")+30), height/2-60, 60, 32, " DIFICIL ", color1, color2, textWidth(" DIFICIL ")*2+50);


  pizzatrap=new PImage[10];
  pizzatrap[0] = loadImage( "pizza1.gif" );
  pizzatrap[1] = loadImage( "pizza2.gif" );
  pizzatrap[2] = loadImage( "pizza3.gif" );
  pizzatrap[3] = loadImage( "pizza4.gif" );
  pizzatrap[4] = loadImage( "pizza5.gif" );
  pizzatrap[5] = loadImage( "pizza6.gif" );
  pizzatrap[6] = loadImage( "pizza7.gif" );
  pizzatrap[7] = loadImage( "pizza8.gif" );
  pizzatrap[8] = loadImage( "pizza9.gif" );
  pizzatrap[9] = loadImage( "pizza10.gif" );
}

void draw() {
  background(fondo);
  textAlign(CENTER);
  fill(fuente);
  image(titulo, width/2-titulo.width/2, 50);

  if (empezo)
  {
    textSize(18);
    //texto instrumentos
    image(tracks, 200, 100);

    //texto efectos
    image(efectos, 600, 170);


    //instrumentos
    kick.draw();
    clap.draw();
    snare.draw();
    hat.draw();
    bajo.draw();
    //efectos
    btLowPass.draw();
    btHighPass.draw();
    btBandPass.draw();
    btReverb.draw();

    //arduino
    serial();
    tempos();
    efectosArduino(valor);

    //pizza estrella del flow mc in da house
    frameRate(15);
    image( pizzatrap[frameCount%9], 850, 200, 400, 270 );

    //teclado
    teclas();
  } else {
    dificil.draw();
    facil.draw();

    textSize(20);
    fill(255);
    text("Bienvenido... Usa las teclas Q, W, E, R y T para activar cada pista de la canción, tambien puédes hacer click sobre los ", 100, 400);
    text("botones. Usa las teclas Y, U, I y O para activar efectos en la canción.", 100, 430);
    text("Buena suerte.", 100, 520);
  }

  if (isEasy) {
    arduino(valor);
  } else {
    arduinoDificil(valor);
  }
}


void tempos() {
    
    int temp =int(temporal); 

    if(temp<1044&&temp>=700){
      nuevo=3;
    }
    else if(temp<700&&temp>=520){
      nuevo= 2;
    }
    else if(temp<520&&temp>=250){
      nuevo = 1;
    }
    else if(temp<250&&temp>0){
      nuevo=0.5;
    }
    
    melody.file.rate(nuevo);
    kick.file.rate(nuevo);
    snare.file.rate(nuevo);
    hat.file.rate(nuevo);
    clap.file.rate(nuevo);
    bajo.file.rate(nuevo);
  
}

void serial() {
  int num;
  boolean numero=false;
  if (MiSerial.available() > 0) // si hay algún dato disponible en el puerto
  {

    temporal = MiSerial.readString();
    if (temporal.equalsIgnoreCase("KICK")||temporal.equalsIgnoreCase("SNARE")||
      temporal.equalsIgnoreCase("CLAP")||temporal.equalsIgnoreCase("HAT")||
      temporal.equalsIgnoreCase("BAJO")||temporal.equalsIgnoreCase("LOW")||
      temporal.equalsIgnoreCase("HIGH")||temporal.equalsIgnoreCase("BAND")||
      temporal.equalsIgnoreCase("REVERB")||temporal.equalsIgnoreCase("RESET"))
    {
      valor=temporal;
      println("temp: "+temporal);
    } else
    {     
      //tempos=temporal;
      println("num: "+temporal);
    }
  }
}
void arduinoDificil(String val) {

  if (val!=null)
  {
    switch(val) {

    case "KICK":
      kick.onOff();
      valor="";
      break;
    case "CLAP":
      clap.onOff();
      valor="";
      break;
    case "SNARE":
      snare.onOff();
      valor="";
      break;
    case "HAT":
      hat.onOff();
      valor="";
      break;
    case "BAJO":
      bajo.onOff();
      valor="";
      break;
    }
  }
}

void efectosArduino(String val) {

  if (val!=null) {

    //Lee el dato y lo almacena en la variable "valor"
    //println(valor);
    switch(val) {
    case "LOW":
      btLowPass.changeState();
      lowPassEffect(kickFile);
      lowPassEffect(hatFile);
      lowPassEffect(clapFile);
      lowPassEffect(snareFile);
      lowPassEffect(bajoFile);
      lowPassEffect(melodyFile);
      valor="";
      break;
    case "HIGH":
      btHighPass.changeState();
      highPassEffect(kickFile);
      highPassEffect(hatFile);
      highPassEffect(clapFile);
      highPassEffect(snareFile);
      highPassEffect(bajoFile);
      valor="";
      break;
    case "BAND":
      btBandPass.changeState();
      bandPassEffect(kickFile);
      bandPassEffect(hatFile);
      bandPassEffect(clapFile);
      bandPassEffect(snareFile);
      bandPassEffect(bajoFile);
      bandPassEffect(melodyFile);
      valor="";      
      break;
    case "REVERB":
      btReverb.changeState();
      reverbEffect(kickFile);
      reverbEffect(hatFile);
      reverbEffect(clapFile);
      reverbEffect(snareFile);
      reverbEffect(melodyFile);
      reverbEffect(melodyFile);
      valor="";
      break;
    case "RESET":
      break;
    }
  }
}

void arduino(String val) {

  if (val!=null)
  {

    switch(val) {
    case "KICK":
      kick.changeState();
      valor="";
      break;
    case "CLAP":
      clap.changeState();
      valor="";
      break;
    case "SNARE":
      snare.changeState();
      valor="";
      break;
    case "HAT":
      hat.changeState();
      valor="";
      break;
    case "BAJO":
      bajo.changeState();
      valor="";
      break;
    }
  }
}
void mousePressed() {
  if (dificil.over()) {
    empezo=true;
  } else if (facil.over()) {
    isEasy=true;
    empezo=true;
  } else if (kick.over()) {
    kick.changeState();
  } else if (clap.over()) {
    clap.changeState();
  } else if (snare.over()) {
    snare.changeState();
  } else if (hat.over()) {
    hat.changeState();
  } else if (bajo.over()) {
    bajo.changeState();
  } else if (btReverb.over()) {
    btReverb.changeState();
    reverbEffect(kickFile);
    reverbEffect(hatFile);
    reverbEffect(clapFile);
    reverbEffect(snareFile);
    reverbEffect(melodyFile);
    reverbEffect(melodyFile);
  } else if (btLowPass.over()) {
    btLowPass.changeState();
    reverbEffect(kickFile);
    lowPassEffect(hatFile);
    lowPassEffect(clapFile);
    lowPassEffect(snareFile);
    lowPassEffect(bajoFile);
    lowPassEffect(melodyFile);
  } else if (btHighPass.over()) {
    btHighPass.changeState();
    highPassEffect(kickFile);
    highPassEffect(hatFile);
    highPassEffect(clapFile);
    highPassEffect(snareFile);
    highPassEffect(bajoFile);
    highPassEffect(melodyFile);
  } else if (btBandPass.over()) {
    btBandPass.changeState();
    bandPassEffect(kickFile);
    bandPassEffect(hatFile);
    bandPassEffect(clapFile);
    bandPassEffect(snareFile);
    bandPassEffect(bajoFile);
    bandPassEffect(melodyFile);
  }
}

void teclas()
{
  if (keyPressed==true)
  {
    if (key=='q'||key=='Q')
    {   
      if (!seguro) {
        seguro=true;
        kick.changeState();
      }
    } else if (key=='w'||key=='W') {
      if (!seguro) {
        seguro=true;
        clap.changeState();
      }
    } else if (key=='e'||key=='E') {
      if (!seguro) {
        seguro=true;
        snare.changeState();
      }
    } else if (key=='r'||key=='R') {
      if (!seguro) {
        seguro=true;
        hat.changeState();
      }
    } else if (key=='t'||key=='T') {
      if (!seguro) {
        seguro=true;
        bajo.changeState();
      }
    } else if (key=='y'||key=='Y') {
      if (!seguro) {
        seguro=true;
        btLowPass.changeState();
        lowPassEffect(kickFile);
        lowPassEffect(hatFile);
        lowPassEffect(clapFile);
        lowPassEffect(snareFile);
        lowPassEffect(bajoFile);
        lowPassEffect(melodyFile);
      }
    } else if (key=='u'||key=='U') {
      if (!seguro) {
        seguro=true;
        btHighPass.changeState();
        highPassEffect(kickFile);
        highPassEffect(hatFile);
        highPassEffect(clapFile);
        highPassEffect(snareFile);
        highPassEffect(bajoFile);
        highPassEffect(melodyFile);
      }
    } else if (key=='i'||key=='I') {
      if (!seguro) {
        seguro=true;
        btBandPass.changeState();
        bandPassEffect(kickFile);
        bandPassEffect(hatFile);
        bandPassEffect(clapFile);
        bandPassEffect(snareFile);
        bandPassEffect(bajoFile);
        bandPassEffect(melodyFile);
      }
    } else if (key=='o'||key=='O') {
      if (!seguro) {
        seguro=true;
        btReverb.changeState();
        reverbEffect(kickFile);
        reverbEffect(hatFile);
        reverbEffect(clapFile);
        reverbEffect(snareFile);
        reverbEffect(melodyFile);
        reverbEffect(melodyFile);
      }
    }
  } else if (seguro==true) {
    seguro=false;
  }
}


void reverbEffect(SoundFile in) {
  if (btReverb.temp==btReverb.on) {
    reverb.process(in);
    reverb.set(0.5, 0.5, 0.6);
  } else {
    reverb.stop();
    melody.file.amp(1);
  }
}
void lowPassEffect(SoundFile in) {
  if (btLowPass.temp==btLowPass.on) {
    lowPass.process(in, 800);
  } else {
    lowPass.stop();
    melody.file.amp(1);
  }
}
void highPassEffect(SoundFile in) {
  if (btHighPass.temp==btHighPass.on) {
    highPass.process(in, 5000);
  } else {
    highPass.stop();
    melody.file.amp(1);
  }
}
void bandPassEffect(SoundFile in) {
  if (btBandPass.temp==btBandPass.on) {
    bandPass.process(in, 100, 50);
  } else {
    bandPass.stop();
    melody.file.amp(1);
  }
}

class Instrumento {
  PImage on, off, temp;
  SoundFile file;
  int x, y, px, py;
  HighPass highPass;
  PinkNoise noise;
  Instrumento(String on, String off, SoundFile file, int x, int y, int px, int py) {
    this.on = loadImage(on);
    this.off = loadImage(off);
    this.file = file;
    this.x = x;
    this.y = y;
    this.px = px;
    this.py = py;
    this.temp=this.off;
    this.file.amp(0);
  }

  void draw() {
    image(temp, x, y, px, py );
  }

  void play(int amp) {
    file.loop(1, amp);
  }

  void onOff() {
    if (temp==on) {
      temp=off;
      file.stop();
    } else {
      temp=on;
      file.loop();
      file.amp(1);
    }
  }
  void changeRate(int rate) {
    file.rate(rate);
  }
  void changeState() {
    if (temp==on) {
      file.amp(0);
      temp=off;
    } else {
      file.amp(1);
      temp=on;
    }
  }

  boolean over() {

    if (mouseX >= x && mouseY >= y && mouseX <= x+px && mouseY <= y + py) {
      return true;
    }
    return false;
  }
}

class Button {
  int x, y, alto, texto;
  float w;
  String label ;
  color relleno, resaltado;
  Button(int x, int y, int alto, int texto, String label, color relleno, color resaltado) {
    this.x = x;
    this.y = y;
    this.alto=alto;
    this.texto= texto;
    this.label = label;
    this.relleno = relleno;
    this.resaltado = resaltado;
    this.w= x + textWidth(label) +5;
  }
  Button(int x, int y, int alto, int texto, String label, color relleno, color resaltado, float w) {
    this.x = x;
    this.y = y;
    this.alto=alto;
    this.texto= texto;
    this.label = label;
    this.relleno = relleno;
    this.resaltado = resaltado;
    this.w=w +x +5;
  }
  void draw() {
    textSize(texto);

    fill(relleno);
    if (over()) {
      fill(resaltado);
    }
    rect(x, y, textWidth(label)+5, alto);
    fill(0);
    if (over()) {
      fill(255);
    }
    textAlign(LEFT);
    text(label, x, y +alto -2*alto/7);
  }

  void changeLabel(String label) {
    this.label=label;
  }
  boolean over() {

    if (mouseX >= x && mouseY >= y && mouseX <= w && mouseY <= y + alto) {
      return true;
    }
    return false;
  }
}
