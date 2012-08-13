CIAUBCDA ;MSC/IND/PLS - Converts barcode CODABAR to HPCL-compatible format ;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Inputs:
 ;   TXT = Data string to print in bar code
 ;   ORN = Orientation of bar code/Check digit
 ;         0 = portrait/no check digit(default)
 ;         1 = landscape/no check digit
 ;         2 = portrait/check digit
 ;         3 = landscape/check digit
 ;   HGT = Height of bar code in dots (1/300 inch)
 ;   HOR = Horizontal position on page in dots
 ;   VER = Vertical position on page in dots
 ;   WID = Width of bar in dots (3=default)
 ;   SSC = Start/Stop characters (a/a = default)
 ; Purpose:
 ;   Accepts a barcode CODABAR string and writes an HPCL-compatible
 ;   string that will display the barcode on an HP laser printer.
 ;   A barcode font cartridge is not required.  The print position
 ;   on entry is restored upon exit.
 ;=================================================================
BC(TXT,ORN,HGT,HOR,VER,WID,SSC) ;
 N DD,CHK,CH,ZDD,C,P,Z,Z1,Z2,Z3,Z4,Z5,X
 S X=0 X ^%ZOSF("RM")
 S CHK=$S($G(ORN)>1:1,1:0),ORN=$S($G(ORN)#2:1,1:0)
 S CH="0123456789-$:/.+"
 S DD="" F ZDD=1:1:$L(TXT) S DD=DD_$S(CH[$E(TXT,ZDD):$E(TXT,ZDD),1:"") ;STRIP UNPRINTABLE CHARACTERS
 S TXT=DD,TXT="a"_TXT_"a"                                            ;ADD START AND STOP CODES
 I +$G(CHK) S TXT=$$CHK(TXT)
 S C=$C(27)_"*c",P=$C(27)_"*p+",WID=$G(WID,3),HGT=$G(HGT,60),ORN=''$G(ORN)+1
 W $C(27),"&f0S"                                                       ;Push cursor position
 W:$D(HOR) $C(27)_"*p"_+HOR_"X"
 W:$D(VER) $C(27)_"*p"_+VER_"Y"
 W C_HGT_$E("BA",ORN)
 F Z=1:1:$L(TXT) D
 .S Z1=$S("AaTt"[$E(TXT,Z):$P($T(16),";",4),"BbNn"[$E(TXT,Z):$P($T(17),";",4),"Cc*"[$E(TXT,Z):$P($T(18),";",4),"DdEe"[$E(TXT,Z):$P($T(19),";",4),1:$P($T(@($F(CH,$E(TXT,Z))-2)),";",4)),Z4=13,Z5=0
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
 N Z1,Y,CHK,XX
 S CHK=0,Y=X
 S XX=$E(X,1)_$E(X,$L(X))                                             ;STRIP OFF S/S CODES AND CALCULATE CHECKSUM
 F Z1=1:1:$L(XX) S CHK=CHK+$S("AaTt"[$E(XX,Z1):16,"BbNn"[$E(XX,Z1):17,"Cc*"[$E(XX,Z1):18,"DdEe"[$E(XX,Z1):19,1:0)
 ;ADD TO CHECKSUM THE VALUES OF THE DATA
 S X=$E(X,2,$L(X)-1) F  Q:X=""  S CHK=$F(CH,$E(X))-2+CHK,X=$E(X,2,255)
 S CHK=$E(CH,$S('CHK#16:1,1:16-CHK#16+1))
 Q $E(Y,1,$L(Y)-1)_CHK_$E(Y,$L(Y))
0 ;;0;1111133
1 ;;1;1111331
2 ;;2;1113113
3 ;;3;3311111
4 ;;4;1131131
5 ;;5;3111131
6 ;;6;1311113
7 ;;7;1311311
8 ;;8;1331111
9 ;;9;3113111
10 ;;-;1113311
11 ;;$;1133111
12 ;;:;3111313
13 ;;/;3131113
14 ;;.;3131311
15 ;;+;1131313
16 ;;AaTt;1133131
17 ;;BbNn;1313113
18 ;;Cc*;1113133
19 ;;DdEe;1113331
