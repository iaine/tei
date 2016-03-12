/*
*  Sonification
*  Use channels to set the notes to side
*/

Flute flute => PoleZero pfl => JCRev r => dac.left;
Flute sr => dac.right;

.95 => r.gain;
.05 => r.mix;
.99 => pfl.blockZero;

.2 => float timeSt;

me.arg(0) => string original;
me.arg(1) => string copy;
10 => int old_first;
10 => int old_second;
//initialise the velocity in the middle
0.5 => float velocity;

//file sizes
int texta[5000];
int textb[5000];
int size;

//create the array and push into a variable
readInts(original) @=> texta;
readInts(copy) @=> textb;

for (0 => int i; i<size;i++) {
      play(flute, sr, texta[i], textb[i], volume(texta[i], textb[i]));



     //set the existing notes to the old notes
    //texta[i] => texta[i-1];
    //textb[i] => textb[i-1];
}

// play the note
fun void play(Flute flute, Flute sr, int noteone, int notetwo, float velocity) {
    // start the first note
    Std.mtof( noteone ) => flute.freq;
    velocity => flute.noteOn;
    velocity => flute.gain;

    // start the second note
    Std.mtof( notetwo ) => sr.freq;
    velocity => sr.noteOn;
    velocity => sr.gain;

    500::ms => now; 
    velocity => flute.noteOff;
    velocity => sr.noteOff;
}

// function to calculate the velocity of the note
// initial thought to go higher, 
// sonification of larger volumes is lower: consider money
fun float volume (int current, int existing) {
    
    if ( existing && current == existing) {
        velocity + 0.1 => velocity;
    } else {
        0.5 => velocity;
    }
    return velocity;
}

// read the ints into an array
// http://wiki.cs.princeton.edu/index.php/ChucK/Dev/IO/FileIO
fun int[] readInts(string path) {
    
    // open the file
    FileIO file;
    if (!file.open(path, FileIO.READ)) {
        <<< "file read failed" >>>;
        <<< path >>>;
        int ret[0]; // error opening the specified file
        return ret;
    }
    
    // read the size of the array
    file => size;
    // now read in the contents
    int ret[size];
    for (0 => int i; i < size; i++) 
        file => ret[i];

    file.close();   
    return ret;    
}
