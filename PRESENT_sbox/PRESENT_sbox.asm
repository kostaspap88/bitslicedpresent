/*
 * PRESENT_sbox.asm
 *
 *  Created: 11-Jul-13 9:45:00 PM
 *   Author: airwizard
 */ 

  
 .org 0x0800
 //Byte address:  2 * 0x0800

 sbox256:
.db 0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xCA, 0xCB, 0xCC, 0xCD, 0xCE, 0xCF
.db 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F
.db 0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F
.db 0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7, 0xB8, 0xB9, 0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF
.db 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9A, 0x9B, 0x9C, 0x9D, 0x9E, 0x9F
.db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
.db 0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9, 0xAA, 0xAB, 0xAC, 0xAD, 0xAE, 0xAF
.db 0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA, 0xDB, 0xDC, 0xDD, 0xDE, 0xDF
.db 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F
.db 0xE0, 0xE1, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xEC, 0xED, 0xEE, 0xEF
.db 0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF
.db 0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8A, 0x8B, 0x8C, 0x8D, 0x8E, 0x8F
.db 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F
.db 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x7F
.db 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F
.db 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F



/* Start of program. */
 /*
 Here is what we found online: PRESENT sbox with 15gates
 Remember to update reference
  T1 = X2 ^ X1;
  T2 = X1 & T1;
  T3 = X0 ^ T2;
  *Y3 = X3 ^ T3;
  T2 = T1 & T3;
  T1 ^= (*Y3);
  T2 ^= X1;
  T4 = X3 | T2;
  *Y2 = T1 ^ T4;
  T2 ^= (~X3);
  *Y0 = (*Y2) ^ T2;
  T2 |= T1;
  *Y1 = T3 ^ T2;

  */


 .include "tn85def.inc"
 
 .def x0=r16
 .def x1=r17
 .def x2=r18
 .def x3=r19

 .def t1=r18
 .def t2=r21
 .def t3=r16
 .def t4=r20

 .def y0=r22
 .def y1=r16
 .def y2=r20
 .def y3=r23

 //counter
 .def counter=r24
 
 

 //Initial key is 0
 
 // [Add key initilization here if needed]

 .def k0=r0
 .def k1=r1
 .def k2=r2
 .def k3=r3
 .def k4=r4
 .def k5=r5
 .def k6=r6
 .def k7=r7
 .def k8=r8
 .def k9=r9

 //shifted key
 .def k10=r10
 .def k11=r11

 //Memory offset
 .def flag=r25
 
 //constant
 .def vff=r26
 
 .macro doit
 lds x0, $60
lds x1, $61
lds x2, $62
lds x3, $63

sbrc k0, 7
eor x0, vff
sbrc k0, 6
eor x1, vff
sbrc k0, 5
eor x2, vff
sbrc k0, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $a0, y0
sts $b0, y1
sts $c0, y2
sts $d0, y3

lds x0, $64
lds x1, $65
lds x2, $66
lds x3, $67

sbrc k0, 3
eor x0, vff
sbrc k0, 2
eor x1, vff
sbrc k0, 1
eor x2, vff
sbrc k0, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $a1, y0
sts $b1, y1
sts $c1, y2
sts $d1, y3

lds x0, $68
lds x1, $69
lds x2, $6a
lds x3, $6b

sbrc k1, 7
eor x0, vff
sbrc k1, 6
eor x1, vff
sbrc k1, 5
eor x2, vff
sbrc k1, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $a2, y0
sts $b2, y1
sts $c2, y2
sts $d2, y3

lds x0, $6c
lds x1, $6d
lds x2, $6e
lds x3, $6f

sbrc k1, 3
eor x0, vff
sbrc k1, 2
eor x1, vff
sbrc k1, 1
eor x2, vff
sbrc k1, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $a3, y0
sts $b3, y1
sts $c3, y2
sts $d3, y3

lds x0, $70
lds x1, $71
lds x2, $72
lds x3, $73

sbrc k2, 7
eor x0, vff
sbrc k2, 6
eor x1, vff
sbrc k2, 5
eor x2, vff
sbrc k2, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $a4, y0
sts $b4, y1
sts $c4, y2
sts $d4, y3

lds x0, $74
lds x1, $75
lds x2, $76
lds x3, $77

sbrc k2, 3
eor x0, vff
sbrc k2, 2
eor x1, vff
sbrc k2, 1
eor x2, vff
sbrc k2, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $a5, y0
sts $b5, y1
sts $c5, y2
sts $d5, y3

lds x0, $78
lds x1, $79
lds x2, $7a
lds x3, $7b

sbrc k3, 7
eor x0, vff
sbrc k3, 6
eor x1, vff
sbrc k3, 5
eor x2, vff
sbrc k3, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $a6, y0
sts $b6, y1
sts $c6, y2
sts $d6, y3

lds x0, $7c
lds x1, $7d
lds x2, $7e
lds x3, $7f

sbrc k3, 3
eor x0, vff
sbrc k3, 2
eor x1, vff
sbrc k3, 1
eor x2, vff
sbrc k3, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $a7, y0
sts $b7, y1
sts $c7, y2
sts $d7, y3

lds x0, $80
lds x1, $81
lds x2, $82
lds x3, $83

sbrc k4, 7
eor x0, vff
sbrc k4, 6
eor x1, vff
sbrc k4, 5
eor x2, vff
sbrc k4, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $a8, y0
sts $b8, y1
sts $c8, y2
sts $d8, y3

lds x0, $84
lds x1, $85
lds x2, $86
lds x3, $87

sbrc k4, 3
eor x0, vff
sbrc k4, 2
eor x1, vff
sbrc k4, 1
eor x2, vff
sbrc k4, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $a9, y0
sts $b9, y1
sts $c9, y2
sts $d9, y3

lds x0, $88
lds x1, $89
lds x2, $8a
lds x3, $8b

sbrc k5, 7
eor x0, vff
sbrc k5, 6
eor x1, vff
sbrc k5, 5
eor x2, vff
sbrc k5, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $aa, y0
sts $ba, y1
sts $ca, y2
sts $da, y3

lds x0, $8c
lds x1, $8d
lds x2, $8e
lds x3, $8f

sbrc k5, 3
eor x0, vff
sbrc k5, 2
eor x1, vff
sbrc k5, 1
eor x2, vff
sbrc k5, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $ab, y0
sts $bb, y1
sts $cb, y2
sts $db, y3

lds x0, $90
lds x1, $91
lds x2, $92
lds x3, $93

sbrc k6, 7
eor x0, vff
sbrc k6, 6
eor x1, vff
sbrc k6, 5
eor x2, vff
sbrc k6, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $ac, y0
sts $bc, y1
sts $cc, y2
sts $dc, y3

lds x0, $94
lds x1, $95
lds x2, $96
lds x3, $97

sbrc k6, 3
eor x0, vff
sbrc k6, 2
eor x1, vff
sbrc k6, 1
eor x2, vff
sbrc k6, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $ad, y0
sts $bd, y1
sts $cd, y2
sts $dd, y3

lds x0, $98
lds x1, $99
lds x2, $9a
lds x3, $9b

sbrc k7, 7
eor x0, vff
sbrc k7, 6
eor x1, vff
sbrc k7, 5
eor x2, vff
sbrc k7, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $ae, y0
sts $be, y1
sts $ce, y2
sts $de, y3

lds x0, $9c
lds x1, $9d
lds x2, $9e
lds x3, $9f

sbrc k7, 3
eor x0, vff
sbrc k7, 2
eor x1, vff
sbrc k7, 1
eor x2, vff
sbrc k7, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $af, y0
sts $bf, y1
sts $cf, y2
sts $df, y3



 .endmacro

 .macro doitagain
 lds x0, $a0
lds x1, $a1
lds x2, $a2
lds x3, $a3

sbrc k0, 7
eor x0, vff
sbrc k0, 6
eor x1, vff
sbrc k0, 5
eor x2, vff
sbrc k0, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $60, y0
sts $70, y1
sts $80, y2
sts $90, y3

lds x0, $a4
lds x1, $a5
lds x2, $a6
lds x3, $a7

sbrc k0, 3
eor x0, vff
sbrc k0, 2
eor x1, vff
sbrc k0, 1
eor x2, vff
sbrc k0, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $61, y0
sts $71, y1
sts $81, y2
sts $91, y3

lds x0, $a8
lds x1, $a9
lds x2, $aa
lds x3, $ab

sbrc k1, 7
eor x0, vff
sbrc k1, 6
eor x1, vff
sbrc k1, 5
eor x2, vff
sbrc k1, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $62, y0
sts $72, y1
sts $82, y2
sts $92, y3

lds x0, $ac
lds x1, $ad
lds x2, $ae
lds x3, $af

sbrc k1, 3
eor x0, vff
sbrc k1, 2
eor x1, vff
sbrc k1, 1
eor x2, vff
sbrc k1, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $63, y0
sts $73, y1
sts $83, y2
sts $93, y3

lds x0, $b0
lds x1, $b1
lds x2, $b2
lds x3, $b3

sbrc k2, 7
eor x0, vff
sbrc k2, 6
eor x1, vff
sbrc k2, 5
eor x2, vff
sbrc k2, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $64, y0
sts $74, y1
sts $84, y2
sts $94, y3

lds x0, $b4
lds x1, $b5
lds x2, $b6
lds x3, $b7

sbrc k2, 3
eor x0, vff
sbrc k2, 2
eor x1, vff
sbrc k2, 1
eor x2, vff
sbrc k2, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $65, y0
sts $75, y1
sts $85, y2
sts $95, y3

lds x0, $b8
lds x1, $b9
lds x2, $ba
lds x3, $bb

sbrc k3, 7
eor x0, vff
sbrc k3, 6
eor x1, vff
sbrc k3, 5
eor x2, vff
sbrc k3, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $66, y0
sts $76, y1
sts $86, y2
sts $96, y3

lds x0, $bc
lds x1, $bd
lds x2, $be
lds x3, $bf

sbrc k3, 3
eor x0, vff
sbrc k3, 2
eor x1, vff
sbrc k3, 1
eor x2, vff
sbrc k3, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $67, y0
sts $77, y1
sts $87, y2
sts $97, y3

lds x0, $c0
lds x1, $c1
lds x2, $c2
lds x3, $c3

sbrc k4, 7
eor x0, vff
sbrc k4, 6
eor x1, vff
sbrc k4, 5
eor x2, vff
sbrc k4, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $68, y0
sts $78, y1
sts $88, y2
sts $98, y3

lds x0, $c4
lds x1, $c5
lds x2, $c6
lds x3, $c7

sbrc k4, 3
eor x0, vff
sbrc k4, 2
eor x1, vff
sbrc k4, 1
eor x2, vff
sbrc k4, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $69, y0
sts $79, y1
sts $89, y2
sts $99, y3

lds x0, $c8
lds x1, $c9
lds x2, $ca
lds x3, $cb

sbrc k5, 7
eor x0, vff
sbrc k5, 6
eor x1, vff
sbrc k5, 5
eor x2, vff
sbrc k5, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $6a, y0
sts $7a, y1
sts $8a, y2
sts $9a, y3

lds x0, $cc
lds x1, $cd
lds x2, $ce
lds x3, $cf

sbrc k5, 3
eor x0, vff
sbrc k5, 2
eor x1, vff
sbrc k5, 1
eor x2, vff
sbrc k5, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $6b, y0
sts $7b, y1
sts $8b, y2
sts $9b, y3

lds x0, $d0
lds x1, $d1
lds x2, $d2
lds x3, $d3

sbrc k6, 7
eor x0, vff
sbrc k6, 6
eor x1, vff
sbrc k6, 5
eor x2, vff
sbrc k6, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $6c, y0
sts $7c, y1
sts $8c, y2
sts $9c, y3

lds x0, $d4
lds x1, $d5
lds x2, $d6
lds x3, $d7

sbrc k6, 3
eor x0, vff
sbrc k6, 2
eor x1, vff
sbrc k6, 1
eor x2, vff
sbrc k6, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $6d, y0
sts $7d, y1
sts $8d, y2
sts $9d, y3

lds x0, $d8
lds x1, $d9
lds x2, $da
lds x3, $db

sbrc k7, 7
eor x0, vff
sbrc k7, 6
eor x1, vff
sbrc k7, 5
eor x2, vff
sbrc k7, 4
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $6e, y0
sts $7e, y1
sts $8e, y2
sts $9e, y3

lds x0, $dc
lds x1, $dd
lds x2, $de
lds x3, $df

sbrc k7, 3
eor x0, vff
sbrc k7, 2
eor x1, vff
sbrc k7, 1
eor x2, vff
sbrc k7, 0
eor x3, vff

eor t1,x1
mov t2,x1
and t2,t1
eor t3,t2
mov y3,x3
eor y3,t3
mov t2,t1
and t2,t3
eor t1,y3
eor t2,x1
mov t4,x3
or t4,t2
eor y2,t1
com x3
eor t2,x3
mov y0,y2
eor y0,t2
or t2,t1
eor t3,t2

sts $6f, y0
sts $7f, y1
sts $8f, y2
sts $9f, y3
 .endmacro

 .macro update

 inc counter /* Increase counter */

 /* Key XOR counter */
 lsl counter
 lsl counter
 eor k5,counter
 lsr counter
 lsr counter

 /* 61 rotations to left = 19 rotations to the right = 2*(8bit moves) +
    3 bit rotation right */


/* 2*8 bit rotation is done easily with mov */
mov k11,k9
mov k10,k8
/* key is stored in k2, k3, ... ,k11 */

/* Perform 3 rotations to the right */

/* 1st rotation */
/* clear k1 which will work as a temp */
eor k8,k8

lsr k10
ror k11
ror k0
ror k1
ror k2
ror k3
ror k4
ror k5
ror k6
ror k7

ror k8
or k10,k8

/*2nd rot*/
eor k8,k8

lsr k10
ror k11
ror k0
ror k1
ror k2
ror k3
ror k4
ror k5
ror k6
ror k7

ror k8
or k10,k8

/*3rd rot*/
eor k8,k8

lsr k10
ror k11
ror k0
ror k1
ror k2
ror k3
ror k4
ror k5
ror k6
ror k7

ror k8
or k10,k8



/* key is stored in k2, k3, ... ,k11. I should probably move it back to k0,k1,k2,....,k9 */
mov k9,k7
mov k8,k6
mov k7,k5
mov k6,k4
mov k5,k3
mov k4,k2
mov k3,k1
mov k2,k0
mov k1,k11
mov k0,k10

/* SBox on key bits 76,77,78,79 i.e. high part of register r11 (k11) */

ldi ZH, high(2*sbox256)
mov ZL,k0
lpm k0,Z

.endmacro

 .org 0x00
//[initialize counter to zero]
eor counter,counter
ldi vff,0xff


//testing values for key


ldi r16,0
mov k0,r16
ldi r16,0
mov k1,r16
ldi r16,0
mov k2,r16
ldi r16,0
mov k3,r16
ldi r16,0
mov k4,r16
ldi r16,0
mov k5,r16
ldi r16,0
mov k6,r16
ldi r16,0
mov k7,r16
ldi r16,0
mov k8,r16
ldi r16,0
mov k9,r16 

ldi r16,0



  
LOOP_BEGINNING:
 //++++++++++++++++++++ SP NETWORK 1++++++++++++++++++++++++++++
doit
//+++++++++++++++++++++ END OF SP NETWORK 1+++++++++++++++++++++



//+++++++++++++++++++++++++ KEY UPDATE 1 +++++++++++++++++++++++++++++
update
//+++++++++++++++++++++++++ END OF KEY UPDATE 1 ++++++++++++++++++++++

cpi counter, 0x1F
brne NOTYET
rjmp END
NOTYET:


 //++++++++++++++++++++ SP NETWORK 2++++++++++++++++++++++++++++
doitagain
//+++++++++++++++++++++ END OF SP NETWORK 2+++++++++++++++++++++



//+++++++++++++++++++++++++ KEY UPDATE 2+++++++++++++++++++++++++++++
update
//+++++++++++++++++++++++++ END OF KEY UPDATE 2++++++++++++++++++++++


 /*back to beginning */
 //cpi counter,0x20
 //brne ONE_MORE_ROUND
  
 //rjmp END
 //ONE_MORE_ROUND:
 rjmp LOOP_BEGINNING


 
 END:

 /* Final xor */

 lds x0, $a0
lds x1, $a1
lds x2, $a2
lds x3, $a3
sbrc k0, 7
eor x0, vff
sbrc k0, 6
eor x1, vff
sbrc k0, 5
eor x2, vff
sbrc k0, 4
eor x3, vff

sts $a0, x0 
sts $a1, x1
sts $a2, x2
sts $a3, x3 

lds x0, $a4
lds x1, $a5
lds x2, $a6
lds x3, $a7
sbrc k0, 3
eor x0, vff
sbrc k0, 2
eor x1, vff
sbrc k0, 1
eor x2, vff
sbrc k0, 0
eor x3, vff

sts $a4, x0 
sts $a5, x1
sts $a6, x2
sts $a7, x3 

lds x0, $a8
lds x1, $a9
lds x2, $aa
lds x3, $ab
sbrc k1, 7
eor x0, vff
sbrc k1, 6
eor x1, vff
sbrc k1, 5
eor x2, vff
sbrc k1, 4
eor x3, vff

sts $a8, x0 
sts $a9, x1
sts $aa, x2
sts $ab, x3 

lds x0, $ac
lds x1, $ad
lds x2, $ae
lds x3, $af
sbrc k1, 3
eor x0, vff
sbrc k1, 2
eor x1, vff
sbrc k1, 1
eor x2, vff
sbrc k1, 0
eor x3, vff

sts $ac, x0 
sts $ad, x1
sts $ae, x2
sts $af, x3 

lds x0, $b0
lds x1, $b1
lds x2, $b2
lds x3, $b3
sbrc k2, 7
eor x0, vff
sbrc k2, 6
eor x1, vff
sbrc k2, 5
eor x2, vff
sbrc k2, 4
eor x3, vff

sts $b0, x0 
sts $b1, x1
sts $b2, x2
sts $b3, x3 

lds x0, $b4
lds x1, $b5
lds x2, $b6
lds x3, $b7
sbrc k2, 3
eor x0, vff
sbrc k2, 2
eor x1, vff
sbrc k2, 1
eor x2, vff
sbrc k2, 0
eor x3, vff

sts $b4, x0 
sts $b5, x1
sts $b6, x2
sts $b7, x3 

lds x0, $b8
lds x1, $b9
lds x2, $ba
lds x3, $bb
sbrc k3, 7
eor x0, vff
sbrc k3, 6
eor x1, vff
sbrc k3, 5
eor x2, vff
sbrc k3, 4
eor x3, vff

sts $b8, x0 
sts $b9, x1
sts $ba, x2
sts $bb, x3 

lds x0, $bc
lds x1, $bd
lds x2, $be
lds x3, $bf
sbrc k3, 3
eor x0, vff
sbrc k3, 2
eor x1, vff
sbrc k3, 1
eor x2, vff
sbrc k3, 0
eor x3, vff

sts $bc, x0 
sts $bd, x1
sts $be, x2
sts $bf, x3 

lds x0, $c0
lds x1, $c1
lds x2, $c2
lds x3, $c3
sbrc k4, 7
eor x0, vff
sbrc k4, 6
eor x1, vff
sbrc k4, 5
eor x2, vff
sbrc k4, 4
eor x3, vff

sts $c0, x0 
sts $c1, x1
sts $c2, x2
sts $c3, x3 

lds x0, $c4
lds x1, $c5
lds x2, $c6
lds x3, $c7
sbrc k4, 3
eor x0, vff
sbrc k4, 2
eor x1, vff
sbrc k4, 1
eor x2, vff
sbrc k4, 0
eor x3, vff

sts $c4, x0 
sts $c5, x1
sts $c6, x2
sts $c7, x3 

lds x0, $c8
lds x1, $c9
lds x2, $ca
lds x3, $cb
sbrc k5, 7
eor x0, vff
sbrc k5, 6
eor x1, vff
sbrc k5, 5
eor x2, vff
sbrc k5, 4
eor x3, vff

sts $c8, x0 
sts $c9, x1
sts $ca, x2
sts $cb, x3 

lds x0, $cc
lds x1, $cd
lds x2, $ce
lds x3, $cf
sbrc k5, 3
eor x0, vff
sbrc k5, 2
eor x1, vff
sbrc k5, 1
eor x2, vff
sbrc k5, 0
eor x3, vff

sts $cc, x0 
sts $cd, x1
sts $ce, x2
sts $cf, x3 

lds x0, $d0
lds x1, $d1
lds x2, $d2
lds x3, $d3
sbrc k6, 7
eor x0, vff
sbrc k6, 6
eor x1, vff
sbrc k6, 5
eor x2, vff
sbrc k6, 4
eor x3, vff

sts $d0, x0 
sts $d1, x1
sts $d2, x2
sts $d3, x3 

lds x0, $d4
lds x1, $d5
lds x2, $d6
lds x3, $d7
sbrc k6, 3
eor x0, vff
sbrc k6, 2
eor x1, vff
sbrc k6, 1
eor x2, vff
sbrc k6, 0
eor x3, vff

sts $d4, x0 
sts $d5, x1
sts $d6, x2
sts $d7, x3 

lds x0, $d8
lds x1, $d9
lds x2, $da
lds x3, $db
sbrc k7, 7
eor x0, vff
sbrc k7, 6
eor x1, vff
sbrc k7, 5
eor x2, vff
sbrc k7, 4
eor x3, vff

sts $d8, x0 
sts $d9, x1
sts $da, x2
sts $db, x3 

lds x0, $dc
lds x1, $dd
lds x2, $de
lds x3, $df
sbrc k7, 3
eor x0, vff
sbrc k7, 2
eor x1, vff
sbrc k7, 1
eor x2, vff
sbrc k7, 0
eor x3, vff

sts $dc, x0 
sts $dd, x1
sts $de, x2
sts $df, x3 


 







/* that's all folks */

//2967 clock cycles per block
eor r30,r30