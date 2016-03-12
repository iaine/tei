<?php

// extract data takes the short code and converts into a url
function extract_data ($short) {

  $xml_str = open_file($short);  

  $reader = new XMLReader();

  if (!$reader->open($xml_str)) {
    die("Failed to open First Folio");
  }
  $num_items=0;
  $pid = 1;
  $act = $scene = $line = 0;
  $play = '';
  $person = array();
  $id = $name = '';
  $sex = '';
  while($reader->read()) {

    if ($reader->nodeType == XMLReader::ELEMENT && $reader->name == 'person') {  
      $id = $reader->getAttribute('xml:id');
      $sex = $reader->getAttribute('sex');
      $pid++;
    }
    if ($id) {
       $person{$id} = array('id' => $pid, 'sex'=> $sex);
    }

    // parse the play sections
    if ($reader->nodeType == XMLReader::ELEMENT && $reader->name == 'div') {
      $divtype = $reader->getAttribute('type');
      if ($divtype == 'act') {
        $play .= 10 + $reader->getAttribute('n').' ';
      }
      if ($divtype == 'scene') {
        $play .= 50  + $reader->getAttribute('n').' ';
      }
    }

    if ($reader->nodeType == XMLReader::ELEMENT && $reader->name == 'sp') {
      $speaker = substr($reader->getAttribute('who'), 1);
    }
    //get the character
    if ($reader->nodeType == XMLReader::ELEMENT && ($reader->name == 'l' || $reader->name == 'p')) {

       if (!$person[$speaker]['sex']) {
          $play .= 60 + $person[$speaker]['id'].' ';
       } else if ($person[$speaker]['sex'] == 'M') {
          $play .= 127 + $person[$speaker]['id'].' ';
       } else {
          $play .= 210 + $person[$speaker]['id'].' ';
       } 
    }

    // get the types of stage direction
    if ($reader->nodeType == XMLReader::ELEMENT && $reader->name == 'stage') {
       $type = $reader->getAttribute('type');
       if ($type == 'entrance') {
         $play .= "41 ";
       } else if ($type == 'exit') {
         $play .= "42 ";
       } else if ($type == 'setting') {
         $play .= "43 ";
       } else if ($type == 'business') {
         $play .= "44 ";
       } else {
         $play .= "45 ";
       }
    }
  }
  $num_items++;
  $play = $num_items. ' ' . substr($play, 0, -1);
  $reader->close();
  
  return $play;
}

function open_file($code) {
   return "/tmp/F-$code.xml";
}

function write_chuck_file($play_coords) {
   $fh = fopen('p.txt', 'wb');
   if (!$fh) {
     die('Could not open file to write data');
   }
   fwrite($fh, sizeof(explode(" ",$play_coords)) + " ");
   fwrite($fh, $play_coords);
   fclose($fh);
}

if (sizeof($argv) < 1) {
   die('Usage: xml_transform.php <shortcode here>');
   exit();
}

$code = $argv[1];

echo "Extracting the data from $code. \n";

$drama_coords = extract_data($code);

echo "Writing the data to file";

write_chuck_file($drama_coords);

echo "File written";
?>
