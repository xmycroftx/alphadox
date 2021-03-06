// Inspired by @technomancy's Atreus project:
//
// https://github.com/technomancy/atreus/blob/master/case/openscad/atreus_case.scad

// Settings that most likely don't need adjusting.
$fn          = 50;                  // Increase the resolution for the small screw holes.
key_size     = 19;                  // Distance between keys.
bezel        = 9;                   // Bezel size.
screw_offset = bezel / (2*sqrt(2)); // Screw offset into the bezel.

// User settings.
n_cols   = 10;  // Number of columns.
n_rows   = 4;  // Number of rows.
screw_d  = 3;  // Screw size.
kerf     = 0;  // Adjusts friction fit of switch holes.

// Handy variables.
max_x = n_cols * key_size;
max_y = n_rows * key_size;

// USB/Teensy settings.
usb_size      = [20.7, 10.2];
teensy_size   = [30.5, 18.0];
usb_offset    = [bezel/2, max_y+teensy_size[1]+bezel/2+screw_offset-usb_size[1]];
teensy_offset = [max_x/2-teensy_size[0]/2, max_y+bezel/2];

translate([-15,-15]) reference_square();

                      bottom_plate();
translate([0, 120])   spacer_plate();
translate([220, 0])   hole_plate();
translate([220, 120]) switch_plate();

translate([0, -120]) everything();

module everything() {
  difference() {
    hull() screws() bezel();
    keys() square(18, center=true);
    screws() screw();
    translate(usb_offset) usb();
    translate(teensy_offset) teensy();
  }
  translate(usb_offset) usb_screws();
}

module switch_plate() {
  difference() {
    bottom_plate();
    keys() switch_hole();
    translate(usb_offset) usb_screws();
    translate([max_x-25,max_y+7.5]) signature();
  }
}

module hole_plate() {
  difference() {
    bottom_plate();
    keys() square(14, center=true);
    translate([0,max_y]) square([max_x,teensy_size[1]]);
    translate(usb_offset) usb();
  }
}

module spacer_plate() {
  difference() {
    bottom_plate();
    hull() {
      keys() square(key_size, center=true);
      translate([0,max_y]) square([max_x,teensy_size[1]]);
    }
    translate(usb_offset) usb();
  }
}

module bottom_plate() {
  difference() {
    hull() screws() bezel();
    screws() screw();
  }
}

module screws() {
  for(x=[-screw_offset,max_x+screw_offset])
    for(y=[-screw_offset,max_y+teensy_size[1]+screw_offset])
      translate([x,y]) children();
  translate([max_x/2,-screw_offset]) children();
  translate([usb_offset[0]+usb_size[0]+bezel/2+screw_offset,max_y+teensy_size[1]+screw_offset]) children();
}

module keys()
  translate([0.5*key_size,0.5*key_size])
    for(x=[0:n_cols-1]) for(y=[0:n_rows-1])
      translate([x*key_size,y*key_size])
        children();

module switch_hole() {
  hole_size    = 13.97;
  notch_width  = 3.5001;
  notch_offset = 4.2545;
  notch_depth  = 0.8128;

  union() {
    square(hole_size-kerf, center=true);
      translate([0, notch_offset]) {
        square([hole_size+2*notch_depth, notch_width], center=true);
      }
      translate([0, -notch_offset]) {
        square([hole_size+2*notch_depth, notch_width], center=true);
      }
  }
}

module usb_screws() {
  translate([0,usb_size[1]])
    translate([0,-2.5]) {
      translate([usb_size[0]-2.75,0]) circle(d=2, center=true);
      translate([2.75,0]) circle(d=2, center=true);
    }
}

module usb() square(usb_size);
module teensy() square(teensy_size);

module bezel() circle(d=bezel, center=true);
module screw() circle(d=screw_d, center=true);

module signature(str="αXL") text(str, font="Athelas:style=Bold");

module reference_square() square(10, center=true);
