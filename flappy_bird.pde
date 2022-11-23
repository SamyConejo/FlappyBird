/*Samy Conejo*/
import ddf.minim.*;
import java.util.ArrayList;

Minim minim, minimLose;
AudioPlayer player, playerLose;
PFont mono;
PImage bg, bird, deadBird, tubArriba, tubAbajo, fbLabel, upKey, spaceKey;
int bgx, bgy, bdx, bdy, g, Vby;
int score, highScore, counter;
int[] tubX, tubY; 
int status;
boolean restart = false;
final int FIN_PARTIDA = 2;
final int REINICIAR = 3;
ArrayList<Integer> tempX = new ArrayList<Integer>();
ArrayList<Integer> tempY = new ArrayList<Integer>();

void setup()
{
  size(800, 620);
  mono = createFont("./font/arcade.TTF", 32);
  minim = new Minim(this);
  minimLose = new Minim(this);
  player = minim.loadFile("./Data/audio/init.mp3");
  playerLose = minimLose.loadFile("./Data/audio/lose.mp3");
  bg = loadImage("./Data/img/bg.png");  //imagen background
  bird = loadImage("./Data/img/bird.png");
  tubArriba = loadImage("./Data/img/tubArriba.png");
  tubAbajo = loadImage("./Data/img/tubAbajo.png");
  fbLabel = loadImage("./Data/img/flappybird2.png");
  upKey = loadImage("./Data/img/up.png");
  spaceKey = loadImage("./Data/img/space.png");
  deadBird = loadImage("./Data/img/deadBird.png");

  bdx = 110;
  bdy = 130;
  g = 1;    
  status = 1;
}

void draw()
{
  if (status == 1)
  {
    menuInicio();
  } else if (status == 0)
  {
    setBg();
    setTubos();
    setBird();
    puntaje();
  } else if (status == FIN_PARTIDA) {
    rebuild();
    finPartida();
    puntajeFinal();
  } else if (status == REINICIAR) {
    reiniciar();
  }
  
  cargarSonido(status);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      Vby = -10;  //salto x cada click
    }
  }
}
void puntaje()
{
  if (score>highScore)
  {
    highScore = score;
  }
  fill(160, 160, 160, 190); 
  rect(width-175, 10, 155, 80, 5);
  fill(0);
  textSize(32);
  text("Score " + score, width - 170, 40);  
  text("Best  " + highScore, width - 170, 80);
}
void puntajeFinal() {
  fill(160, 160, 160, 190);
  rectMode(CENTER);
  rect(width/2-15, height/2, 155, 80, 5);
  fill(0);
  textSize(32);
  text("Score " + score, width/2-80, height/2-10);  
  text("Best  " + highScore, width/2-80, height/2+30);
  rectMode(CORNER);
}
void reiniciar() { 
  bdy = 130;
  for (int i = 0; i <tubX.length; i++)
  {
    tubX[i] = width + 210*i;
    tubY[i] = (int)random(-360, 0);
  }   
  score = 0;
  status = 0;
}
void finPartida() {
  bdy = bdy + 3;    // efecto caida 
  deadBird.resize(70, 60);
  image(deadBird, bdx, bdy);
  playerLose.play();
  fill(255, 0, 0);
  text("Perdiste!", 310, 200);
  fill(255);
  text("Presiona", width/2-280, height*0.75);
  spaceKey.resize(90, 40);
  image(spaceKey, width/2-110, height*0.70);
  text("para jugar de nuevo", width/2, height*0.75);

  if (keyPressed && key == 32) {
    bdy = 130;
    Vby = -10;
    playerLose.rewind();
    playerLose.pause();
    status = REINICIAR;
  }
}
void cargarSonido(int status) {
  if (status != 2) {
    player.play(); 
    if ( player.position() == player.length())
    {
      player.rewind();
      player.play();
    }
  } else {
    player.pause();
    player.rewind();
  }
}
void menuInicio() {

  image(bg, 0, 0);
  image(fbLabel, width/2-fbLabel.width/2, height*0.25);
  textFont(mono);
  text("Presiona", width/2-220, height*0.75);
  upKey.resize(40, 40);
  image(upKey, width/2-50, height*0.70);
  text("para iniciar", width/2+10, height*0.75);
  if (keyPressed && key == CODED) {
    if (keyCode == UP)
    {  
      tubX = new int[4];  
      tubY = new int[tubX.length];
      for (int i = 0; i < tubX.length; i++)
      {
        tubX[i] = width + (210*i);
        tubY[i] = (int)random(-360, 0);
      }
      status = 1;
      status = 0;
    }
  }
}

void setTubos() {
  tempX.clear();
  tempY.clear();
  for (int i = 0; i < tubX.length; i++)
  {
    image(tubArriba, tubX[i], tubY[i]);
    image(tubAbajo, tubX[i], tubY[i] + 680);
    tempX.add(tubX[i]);
    tempY.add(tubY[i]);
    tubX[i]-=2;

    if (score > 8)
    {
      tubX[i]--;
    }
    if (score > 18)
    {
      tubX[i]--;
    }
    if (tubX[i] < -210)
    {
      tubX[i] = width;
    }
    if (bdx > (tubX[i]-42) && bdx < tubX[i] + 92)
    {
      if (!(bdy > tubY[i] + 430 && bdy < tubY[i] + (449 + 231-42)))
      {   
        status = FIN_PARTIDA;
      } else if (bdx==tubX[i] || bdx == tubX[i] + 1)
      {
        score++;
      }
    }
  }
}
void rebuild() {
  image(bg, bgx, bgy); //inicio
  image(bg, bgx + bg.width, bgy); //inicio imagen 2   
  for (int j = 0; j < tempX.size(); j++)
  {
    image(tubArriba, tempX.get(j), tempY.get(j));
    image(tubAbajo, tempX.get(j), tempY.get(j) + 680);
  }
}
void setBird()
{

  image(bird, bdx, bdy); //imagen bird
  bdy = bdy + Vby;    
  Vby = Vby + g;    //aceleracion abajo
  if (bdy > height || bdy < 0)
  {
    status=2;
  }
}
void setBg()
{
  image(bg, bgx, bgy); //inicio
  image(bg, bgx + bg.width, bgy); //inicio img2
  bgx=bgx -1; //movimiento en x
  if (bgx < -bg.width)  //cuando termina la img1 e inicia img2
  {
    bgx = 0;
  }
}
