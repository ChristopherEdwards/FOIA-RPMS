BIVT100 ;IHS/CMI/MWR - UPDATE CODES FOR VT100; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UPDATE SCREEN HANDLING CODES FOR C-VT100 IN TERMINAL TYPE FILE.
 ;;  NOT CALLED FROM ANY MENU.
 ;
 ;---> Running this routine from START will update the Terminal Type
 ;---> File entry for C-VT100.
 ;---> Following the instructions at BUILD will store the C-VT100
 ;---> Codes from the local ^%ZIS(2,9) entry into this routine.
 ;
 ;----------
START ;EP
 ;
 Q:('$G(DT))
 Q:(DT>3100101)
 ;W !?3,"This step will update your VT100 Codes for Listmanager display"
 N BITT,Y
 ;D DIC^BIFMAN(3.2,"QEMA",.Y,"   Select VT100 Device: ","C-VT100")
 ;Q:'Y
 ;S BITT=+Y
 S BITT=$O(^%ZIS(2,"B","C-VT100",0))
 Q:'BITT  Q:$P($G(^%ZIS(2,BITT,0)),"^")'="C-VT100"
 ;
 ;---> Update C-VT100 Terminal Type entry.
 N BIDONE S BIDONE=0
 N I,X,Y,Z F I=1:1 S X=$T(@"CODES"+I) Q:X'[";;"  D
 .S Y=$P(X,";;",2),Z=$P(X,";;",3)
 .N BIX S BIX="^%"_$C(90)_$C(73)_"S(2,BITT,Y)",@BIX=Z,BIDONE=1
 Q
 ;
 D
 .I $G(BIDONE) W !!?3,"C-VT100 UPDATED!" Q
 .W !!?3,"* NO CHANGES MADE!  (You must uncomment the ^%ZIS line.)"
 D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;
 ;----------
BUILD ;EP
 ;---> Build routine rest of this routine, containing current
 ;---> C-VT100 screen handling codes for updating the Terminal
 ;---> Type File.
 ;---> Used by package programmer only.  Not called by any option
 ;---> or User action.
 ;---> To use: 1) Load this routine and delete all lines after
 ;--->            line label CODES, including the line label.
 ;--->         2) At programmer prompt type:
 ;--->            ZL BIVT100 D BUILD^BIVT100  X BIX0.
 ;
 D SETVARS^BIUTL5
 S BIX0="N I F I=1:1 Q:'$D(@(""BIX""_I))  X @(""BIX""_I)"
 S BIX1="ZI "" ;"","" ;"","" ;----------"",""CODES ;EP"""
 S BIX2="N N S N=-1 F  S N=$O(^%ZIS(2,9,N)) Q:N=""""  "
 S BIX2=BIX2_"ZI "" ;;""_N_"";;""_^(N)"
 S BIX3="ZS BIVT100"
 Q
 ;
 ;
 ;----------
CODES ;EP
 ;;0;;C-VT100^1
 ;;1;;80^$C(27,91,50,74,27,91,72),#^24^$C(8)^W $C(27,91)_((DY+1))_$C(59)_((DX+1))_$C(72)
 ;;5;;^^$C(27,91,72)^$C(27,91,55,109)^$C(27,91,109)^$C(27,91,75)^$C(27,91,74)^$C(27,91,53,109)^$C(27,91,109)
 ;;6;;$C(27,99)^^^$C(27,91,52,109)^$C(27,91,109)^^^$C(27,91,109)
 ;;7;;$C(27,91,49,109)^$C(27,91,109)^$C(27,91,109)
 ;;8;;$C(27)_"[A"^$C(27)_"[B"^$C(27)_"[C"^$C(27)_"[D"^3^^$C(27,91)_"1L"
 ;;8.1;;$C(27)_"[?25h"^$C(27)_"[?25l"
 ;;9;;Digital Equipment Corporation VT-100 video
 ;;10;;W *27,"[5i"
 ;;11;;H 1 W *27,"[4i"
 ;;13;;$C(27,91,49,74)^$C(27,91,50,74)^$C(27,91,49,75)^$C(27,91,50,75)^^$C(27)_"7"_$J("",X)_$C(27)_"8"
 ;;14;;$C(27)_"D"^$C(27)_"M"^$C(27,55)^$C(27,56)^$C(27)_"E"
 ;;15;;$C(27,91,63,55,104)^$C(27,91,63,55,108)^$C(27,91,63,56,104)^$C(27,91,63,56,108)^$C(27,61)^$C(27,62)
 ;;16;;$C(27,72)^$C(27,91,103)^$C(27,91,51,103)^$C(27,91)_(+IOTM)_$C(59)_(+IOBM)_$C(114)
 ;;17;;$C(27,35,51)^$C(27,35,52)^$C(27,35,54)^$C(27,35,53)
 ;;18;;$C(27)_"Op"^$C(27)_"Oq"^$C(27)_"Or"^$C(27)_"Os"^$C(27)_"Ot"^$C(27)_"Ou"^$C(27)_"Ov"^$C(27)_"Ow"^$C(27)_"Ox"^$C(27)_"Oy"
 ;;19;;$C(27)_"OP"^$C(27)_"OQ"^$C(27)_"OR"^$C(27)_"OS"^$C(27)_"Om"^$C(27)_"Ol"^$C(27)_"OM"^$C(27)_"On"
 ;;G;;"l"^"m"^"k"^"j"^"n"^"w"^"v"^"t"^"u"^"x"^"q"
 ;;G0;;$C(27)_"(B"
 ;;G1;;$C(27)_"(0"
 ;;SY;;VT
 ;;XY;;W $C(27,91)_((DY+1))_$C(59)_((DX+1))_$C(72)
