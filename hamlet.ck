/*
*  Sonification
*  Use channels to set the notes to side
*/

SinOsc s => dac => WvOut wv => blackhole;

.2 => float timeSt;

me.arg(0) => string original;

//file sizes
int texta[3400];

int size;

//create the array and push into a variable
readInts(original) @=> texta;

"hamtone" => wv.wavFilename;

1 => wv.record;

for (0 => int i; i<size;i++) {
      play(s, texta[i]);
}

0 => wv.record;

null @=> wv;

// play the note
fun void play(SinOsc s, int noteone) {
    // start the first note
    noteone => s.freq;
    100::ms => now; 
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
