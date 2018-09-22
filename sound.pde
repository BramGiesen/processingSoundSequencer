import processing.sound.*;

Env env;

float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.3;
float releaseTime = 0.4;

float detune = 0;
float startTime;
float triggerTime;
float triggerLenght;

float count = 0;

int index = 0;


SinOsc[] sineWaves; // Array of sines
float[] sineFreq; // Array of frequencies
int numSines = 5; // Number of oscillators to use


//rythm
int[][] sineEnvs = { {0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0},
{1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
{0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0},
{1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0},
{1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}};

//melody
int[][] sineNotes = { {60, 60, 60, 60, 60, 60, 60, 60},
{63, 63, 63, 63, 63, 63, 63, 63},
{67, 67, 67, 67, 67, 67, 67, 67},
{70, 70, 70, 70, 70, 70, 70, 70},
{84, 84, 84, 84, 84, 84, 84, 84}};



void setup() {
  size(640, 360);
  background(255);

  sineWaves = new SinOsc[numSines]; // Initialize the oscillators
  sineFreq = new float[numSines]; // Initialize array for Frequencies

  // Create the envelope
  env  = new Env(this);

  for (int i = 0; i < numSines; i++) {
    // Calculate the amplitude for each oscillator
    float sineVolume = (1.0 / numSines) / (i + 1);
    // Create the oscillators
    sineWaves[i] = new SinOsc(this);
    // Set panning
    sineWaves[i].pan(random(-1.0,1.0));
    // Start Oscillators
    sineWaves[i].play();
    // Set the amplitudes for all oscillators
    sineWaves[i].amp(sineVolume);
  }
  sequence();
}

void draw() {
  //Map mouseY from 0 to 1
  float yoffset = 0;
  //Use mouseX mapped from -0.5 to 0.5 as a detune argument
  detune = random(5);

}

float mtof(int midiPitch) {
  return pow(2.0,(midiPitch-69.0)/12.0) * 440.0;
}

void sequence() {

    startTime = millis();
    triggerLenght = 200;
    count = 0;

    while (true) {
        triggerTime = startTime + (triggerLenght * count);

        if(millis() > triggerTime){
          for (int i = 0; i < numSines; i++) {
            sineFreq[i] = mtof(sineNotes[i][index % 8]);
            // Set the frequencies for all oscillators
            sineWaves[i].freq(sineFreq[i]);
            // Apply envelope
            if(sineEnvs[i][index] == 1)
              env.play(sineWaves[i], attackTime, sustainTime, sustainLevel, releaseTime);
          }
          index = (index + 1) % 16;
          count = count + 1;
        }
    }
}
