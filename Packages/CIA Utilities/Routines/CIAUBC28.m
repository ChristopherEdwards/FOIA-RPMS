CIAUBC28 ;MSC/IND/DKM/PLS - Convert 128 barcode to HPCL-compatible form ;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Inputs:
 ;     TX = Text to encode.
 ; Outputs:
 ;     Returns encoded text.
 ; Purpose:
 ;     Performs bar code 128 encoding on a text string.
 ;=================================================================
EN(TX) Q:TX="" ""
 N CD,TP,TP1,EN,Z1,Z2
 S TP=0,TP=$$TP(TX),CD=TP,EN=$C(TP+8)
 F  Q:TX=""  D
 .S TP1=$$TP(TX)
 .I TP1'=TP D CD(6-TP1) S TP=TP1
 .S Z1=$E(TX,1,TP=2+1),TX=$E(TX,TP=2+2,255),Z2=$A(Z1)
 .I TP=2 D CD($S(Z1>95:Z1-95,Z1:Z1+32,1:31))
 .E  D CD($S(Z2<32:Z2+96,Z2=32:31,1:Z2))
 S CD=CD#103,CD=$S('CD:31,CD>95:CD-95,1:CD+32)
 Q EN_$C(CD,11)
TP(X) Q $S(X?2N.E:2,$A(X)<32:0,$A(X)>95:1,TP=2:0,1:TP)
CD(X) S CD=$S(X=31:0,X<11:X+95,1:X-32)*$L(EN)+$G(CD),EN=EN_$C(X)
 Q
 ;=================================================================
 ; Inputs:
 ;   TXT = Data string to print in bar code
 ;   ORN = Orientation of bar code
 ;         0 = portrait (default)
 ;         1 = landscape
 ;   HGT = Height of bar code in dots (1/300 inch)
 ;   HOR = Horizontal position on page in dots
 ;   VER = Vertical position on page in dots
 ;   WID = Width of bar in dots (3=default)
 ; Purpose:
 ;   Accepts a barcode 128 string and writes an HPCL-compatible
 ;   string that will display the barcode on an HP laser printer.
 ;   A barcode font cartridge is not required.  The print position
 ;   on entry is restored on exit.
 ;=================================================================
BC(TXT,ORN,HGT,HOR,VER,WID) ;
 N Z,Z1,Z2,Z3,Z4,Z5,C,P,X
 S X=0 X ^%ZOSF("RM")
 S TXT=$$EN(TXT),C=$C(27)_"*c",P=$C(27)_"*p+",WID=$G(WID,3.5),HGT=$G(HGT,60),ORN=''$G(ORN)+1
 W $C(27),"&f0S"                                                       ;Push cursor position
 W:$D(HOR) $C(27)_"*p"_+HOR_"X"
 W:$D(VER) $C(27)_"*p"_+VER_"Y"
 W C_HGT_$E("BA",ORN)
 F Z=1:1:$L(TXT) D
 .S Z1=$P($T(@$A(TXT,Z)),";;",2),Z4=11,Z5=0
 .F Z2=1:1:$L(Z1) D
 ..S Z3=+$E(Z1,Z2),Z4=Z4-Z3,Z3=Z3*WID
 ..Q:'Z3
 ..I Z2#2 W C_Z3_$E("ab",ORN)_"0P" S Z5=Z3
 ..E  W P_(Z3+Z5)_$E("XY",ORN) S Z5=0
 .S Z4=Z4*WID+Z5
 .W:Z4>0 P_Z4_$E("XY",ORN)
 W $C(27),"&f1S"                                                       ;Pop cursor position
 Q ""
1 ;;11431
2 ;;41111
3 ;;41131
4 ;;11314
5 ;;11413
6 ;;31114
7 ;;41113
8 ;;21141
9 ;;21121
10 ;;21123
11 ;;2331112
31 ;;21222
33 ;;22212
34 ;;22222
35 ;;12122
36 ;;12132
37 ;;13122
38 ;;12221
39 ;;12231
40 ;;13221
41 ;;22121
42 ;;22131
43 ;;23121
44 ;;11223
45 ;;12213
46 ;;12223
47 ;;11322
48 ;;12312
49 ;;12322
50 ;;22321
51 ;;22113
52 ;;22123
53 ;;21321
54 ;;22311
55 ;;31213
56 ;;31122
57 ;;32112
58 ;;32122
59 ;;31221
60 ;;32211
61 ;;32221
62 ;;21212
63 ;;21232
64 ;;23212
65 ;;11132
66 ;;13112
67 ;;13132
68 ;;11231
69 ;;13211
70 ;;13231
71 ;;21131
72 ;;23111
73 ;;23131
74 ;;11213
75 ;;11233
76 ;;13213
77 ;;11312
78 ;;11332
79 ;;13312
80 ;;31312
81 ;;21133
82 ;;23113
83 ;;21311
84 ;;21331
85 ;;21313
86 ;;31112
87 ;;31132
88 ;;33112
89 ;;31211
90 ;;31231
91 ;;33211
92 ;;31411
93 ;;22141
94 ;;43111
95 ;;11122
96 ;;11142
97 ;;12112
98 ;;12142
99 ;;14112
100 ;;14122
101 ;;11221
102 ;;11241
103 ;;12211
104 ;;12241
105 ;;14211
106 ;;14221
107 ;;24121
108 ;;22111
109 ;;41311
110 ;;24111
111 ;;13411
112 ;;11124
113 ;;12114
114 ;;12124
115 ;;11421
116 ;;12411
117 ;;12421
118 ;;41121
119 ;;42111
120 ;;42121
121 ;;21214
122 ;;21412
123 ;;41212
124 ;;11114
125 ;;11134
126 ;;13114
127 ;;11411
