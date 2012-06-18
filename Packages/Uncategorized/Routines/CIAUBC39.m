CIAUBC39 ;MSC/IND/PLS - Converts barcode 39 to HPCL-compatible format ;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Inputs:
 ;   TXT = Data string to print in bar code
 ;   ORN = Orientation of bar code/Check Digit
 ;         0 = portrait/no check digit(default)
 ;         1 = landscape/no check digit
 ;         2 = portrait/check digit
 ;         3 = landscape/check digit
 ;   HGT = Height of bar code in dots (1/300 inch)
 ;   HOR = Horizontal position on page in dots
 ;   VER = Vertical position on page in dots
 ;   WID = Width of bar in dots (3=default)
 ; Purpose:
 ;   Accepts a barcode 39 string and writes an HPCL-compatible
 ;   string that will display the barcode on an HP laser printer.
 ;   A barcode font cartridge is not required.  The print position
 ;   on entry is restored upon exit.
 ;=================================================================
BC(TXT,ORN,HGT,HOR,VER,WID) ;
 N DD,CHK,CH,ZDD,C,P,Z1,Z2,Z3,Z4,Z5,X
 S X=0 X ^%ZOSF("RM")
 S CHK=$S($G(ORN)>1:1,1:0),ORN=$S($G(ORN)#2:1,1:0)
 S TXT=$TR(TXT,"*",""),CH="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+Z"
 S DD="" F ZDD=1:1:$L(TXT) S DD=DD_$S(CH[$E(TXT,ZDD):$E(TXT,ZDD),1:"") ;STRIP UNPRINTABLE CHARACTERS
 S TXT=DD I +$G(CHK) S TXT=$$CHK(TXT)                             ;ADD CHECKSUM CHARACTER
 S TXT="*"_TXT_"*"                                                     ;ADD START AND STOP CODES
 S C=$C(27)_"*c",P=$C(27)_"*p+",WID=$G(WID,3),HGT=$G(HGT,60),ORN=''$G(ORN)+1
 W $C(27),"&f0S"                                                       ;Push cursor position
 W:$D(HOR) $C(27)_"*p"_+HOR_"X"
 W:$D(VER) $C(27)_"*p"_+VER_"Y"
 W C_HGT_$E("BA",ORN)
 F Z=1:1:$L(TXT) D
 .S Z1=$S($E(TXT,Z)="*":$P($T(99),";",4),1:$P($T(@($F(CH,$E(TXT,Z))-2)),";",4)),Z4=15,Z5=0
 .F Z2=1:1:$L(Z1) D
 ..S Z3=+$E(Z1,Z2),Z4=Z4-Z3,Z3=Z3*WID
 ..Q:'Z3
 ..I Z2#2 W C_Z3_$E("ab",ORN)_"0P" S Z5=Z3
 ..E  W P_(Z3+Z5)_$E("XY",ORN) S Z5=0
 .S Z4=Z4*WID+Z5
 .W P_(Z5+WID)_$E("XY",ORN)
 W $C(27),"&f1S"                                                       ;Pop cursor position
 Q ""
CHK(X) ;CALCULATE CHECK DIGIT AND RETURN STRING TO PRINT
 Q:X="" ""
 N CHK,Y
 S CHK=0,Y=X
 F  Q:X=""  S CHK=$F(CH,$E(X))-2+CHK,X=$E(X,2,255)
 S CHK=$E(CH,CHK#43+1)
 Q Y_CHK
0 ;;0;111331311
1 ;;1;311311113
2 ;;2;113311113
3 ;;3;313311111
4 ;;4;111331113
5 ;;5;311331111
6 ;;6;113331111
7 ;;7;111311313
8 ;;8;311311311
9 ;;9;113311311
10 ;;A;311113113
11 ;;B;113113113
12 ;;C;313113111
13 ;;D;111133113
14 ;;E;311133111
15 ;;F;113133111
16 ;;G;111113313
17 ;;H;311113311
18 ;;I;113113311
19 ;;J;111133311
20 ;;K;311111133
21 ;;L;113111133
22 ;;M;313111131
23 ;;N;111131133
24 ;;O;311131131
25 ;;P;113131131
26 ;;Q;111111333
27 ;;R;311111331
28 ;;S;113111331
29 ;;T;111131331
30 ;;U;331111113
31 ;;V;133111113
32 ;;W;333111111
33 ;;X;131131113
34 ;;Y;331131111
35 ;;Z;133131111
36 ;;-;131111313
37 ;;.;331111311
38 ;; ;133111311
39 ;;$;131313111
40 ;;/;131311131
41 ;;+;131113131
42 ;;%;111313131
99 ;;*;131131311
