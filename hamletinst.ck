/*
*  Sonification
*  Use channels to set the notes to side
*/

Shakers s => Echo a => dac => WvOut wv => blackhole;
SinOsc so => dac;

.2 => float timeSt;

me.arg(0) => string original;

"hamletinst" => wv.wavFilename;
//file sizes
int texta[3200];

int size;

//create the array and push into a variable
readInts(original) @=> texta;

1 => wv.record;

for (0 => int i; i<size;i++) {
    if (texta[i] < 61) {
      playSub(so, texta[i]);
    } else {
      play(s, texta[i]);
    }
}

0 => wv.record;
null @=> wv;

// play the sub
fun void playSub(SinOsc so, int noteone) {
    
    noteone => so.freq;
    100::ms => now;
    0 => so.freq;
}

// play the note
fun void play(Shakers s, int noteone) {
    if (noteone < 200) {
       7 => s.which;
    } else {
       6 => s.which;
    }
    noteone => s.freq;
    0.5 => s.noteOn;
    0.5 => s.gain;

    250::ms => now;
    noteone => s.noteOff; 
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
