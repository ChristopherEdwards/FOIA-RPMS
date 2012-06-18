BMXUTL5 ; IHS/OIT/HMW - DATE FORMAT ;
 ;;4.0;BMX;;JUN 28, 2010
 ;;Stolen from:* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  UTILITY: SETVARS, CENTERT, COPYLET,
 ;;           UPPERCASE XREFS, DATE FORMATS, PADS/SPACES.
 ;
 ;
 ;----------
SETVARS ;EP
 ;---> Set standard variables.
 D ^XBKVAR
 S:'$D(IOF) IOF="#"
 Q
 ;
 ;
 ;----------
PHONFIX(X) ;EP
 ;---> Remove parentheses from Phone#.
 ;---> Parameters:
 ;     1 - X (req) Input Phone Number; returned without parentheses.
 ;
 Q:$G(X)=""
 S X=$TR(X,"(","")
 S X=$TR(X,")","-")
 S X=$TR(X,"/","-")
 S:X["- " X=$P(X,"- ")_"-"_$P(X,"- ",2)
 S:$E(X,4)=" " $E(X,4)="-"
 S:X["--" X=$P(X,"--")_"-"_$P(X,"--",2)
 S:X?7N X=$E(X,1,3)_"-"_$E(X,4,7)
 Q
 ;
 ;
 ;----------
CENTERT(TEXT,X) ;EP
 ;---> Pad TEXT with leading spaces to center in 80 columns.
 ;---> Parameters:
 ;     1 - TEXT (req) Text to be centered.
 ;     2 - X    (opt) Columns to adjust to the right.
 ;
 S:$G(TEXT)="" TEXT="* NO TEXT SUPPLIED *"
 S:'$G(X) X=39
 N I
 F I=1:1:(X-($L(TEXT)/2)) S TEXT=" "_TEXT
 Q
 ;
 ;
 ;----------
UPPER(X) ;EP
 ;---> Translate X to all uppercase.
 ;---> Parameters:
 ;     1 - X    (req) Value to be translated into all uppercase.
 ;
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q X
 ;
 ;
 ;----------
UPXREF(X,AGGBL) ;EP
 ;---> Set uppercase xref for X.  Called from M xrefs on mixed case
 ;---> fields where an all uppercase lookup is needed.
 ;---> Parameters:
 ;     1 - X     (req) The value that should be xrefed in uppercase.
 ;     2 - AGGBL (req) The global root of the file.
 ;
 ;---> Variables:
 ;     1 - DA    (req) IEN of the entry being xrefed.
 ;
 Q:'$D(AGGBL)  Q:$G(X)=""  Q:'$G(DA)
 S @(AGGBL_"""U"",$E($$UPPER(X),1,30),DA)")=""
 Q
 ;
 ;
 ;----------
KUPXREF(X,AGGBL) ;EP
 ;---> Kill uppercase xref for X.  Called from M xrefs on mixed case
 ;---> fields where an all uppercase lookup is needed.
 ;---> Parameters:
 ;     1 - X     (req) The value that should be xrefed in uppercase.
 ;     2 - AGGBL (req) The global root of the file.
 ;
 ;---> Variables:
 ;     1 - DA    (req) IEN of the entry being xrefed.
 ;
 Q:'$D(AGGBL)  Q:$G(X)=""  Q:'$G(DA)
 K @(AGGBL_"""U"",$E($$UPPER(X),1,30),DA)")
 Q
 ;
 ;
 ;----------
SLDT2(DATE) ;EP
 ;---> CONVERT FILEMAN INTERNAL DATE TO "SLASH" FORMAT: MM/DD/YYYY.
 ;---> DATE=DATE IN FILEMAN FORMAT.
 Q:'$G(DATE) "NO DATE"
 S DATE=$P(DATE,".")
 Q:$L(DATE)'=7 DATE
 Q:'$E(DATE,4,5) $E(DATE,1,3)+1700
 Q:'$E(DATE,6,7) $E(DATE,4,5)_"/"_$E(DATE,2,3)
 Q $E(DATE,4,5)_"/"_$E(DATE,6,7)_"/"_($E(DATE,1,3)+1700)
 ;
 ;
 ;----------
SLDT1(DATE) ;EP
 ;---> CONVERT FILEMAN INTERNAL DATE TO "SLASH" FORMAT:
 ;---> MM/DD/YYYY @TIME
 N Y
 Q:'$D(DATE) "NO DATE"
 S Y=DATE,DATE=$P(DATE,".")
 Q:'DATE "NO DATE"
 Q:$L(DATE)'=7 DATE
 Q:'$E(DATE,4,5) $E(DATE,1,3)+1700
 Q:'$E(DATE,6,7) $E(DATE,4,5)_"/"_$E(DATE,2,3)
 D DD^%DT S:Y["@" Y=" @ "_$P($P(Y,"@",2),":",1,2)
 Q $E(DATE,4,5)_"/"_$E(DATE,6,7)_"/"_($E(DATE,1,3)+1700)_Y
 ;
 ;
 ;----------
NOSLDT(DATE) ;EP
 ;---> CONVERT FILEMAN INTERNAL DATE TO "NO SLASH" FORMAT: MMDDYYYY.
 ;---> DATE=DATE IN FILEMAN FORMAT.
 Q:'$G(DATE) "NO DATE"
 S DATE=$P(DATE,".")
 Q:$L(DATE)'=7 DATE
 Q $E(DATE,4,5)_$E(DATE,6,7)_($E(DATE,1,3)+1700)
 ;
 ;
 ;----------
IMMSDT(DATE) ;EP
 ;---> Convert Immserve Date (format MMDDYYYY) TO FILEMAN
 ;---> Internal format.
 ;---> NOTE: This code is copied into routine ^AGPATUP1 for speed.
 ;---> Any changes here should also be made to the call in ^AGPATUP1.
 Q:'$G(DATE) "NO DATE"
 Q ($E(DATE,5,9)-1700)_$E(DATE,1,2)_$E(DATE,3,4)
 ;
 ;
 ;----------
TXDT1(DATE,TIME) ;EP
 ;---> Return external date in format: DD-Mmm-YYYY@HH:MM, from Fileman
 ;---> internal YYYMMDD.HHMM
 ;---> Parameters:
 ;     1 - DATE  (req) Internal Fileman date.
 ;     2 - TIME  (opt)
 ;
 Q:'$G(DATE) "NO DATE"
 N X,Y,Z
 S X="Jan^Feb^Mar^Apr^May^Jun^Jul^Aug^Sep^Oct^Nov^Dec"
 S Y=$E(DATE,6,7)_"-"_$P(X,U,$E(DATE,4,5))_"-"_($E(DATE,1,3)+1700)
 S:'$E(DATE,6,7) Y=$E(Y,4,99)
 S:'$E(DATE,4,5) Y=$E(DATE,1,3)+1700
 Q:'$G(TIME) Y
 S Z=$P(DATE,".",2)
 Q:'Z Y
 Q Y_" @"_$E(Z,1,2)_":"_$$PAD($E(Z,3,4),2,"0")
 ;
 ;
 ;----------
TXDT(DATE) ;EP
 ;---> CONVERT FILEMAN INTERNAL DATE TO "TEXT" FORMAT: MMM DD,YYYY.
 N Y
 Q:'$D(DATE) "NO DATE"
 S Y=DATE D DD^%DT
 I Y[", " S Y=$P(Y,", ")_","_$P(Y,", ",2)
 I Y["@" S Y=$P(Y,"@")_"  "_$P($P(Y,"@",2),":",1,2)
 Q Y
 ;
 ;
 ;----------
NOW() ;EP
 ;---> Return Current Date and Time in external format.
 N %H,X,Y,Z
 S %H=$H
 D YX^%DTC
 I Y["@" S Y=$P($P(Y,"@",2),":",1,2)
 S Z=$$TXDT1(X)
 S:Y]"" Z=Z_" @"_Y
 Q Z
 ;
 ;
 ;----------
PAD(D,L,C) ;EP
 ;---> Pad the length of data to a total of L characters
 ;---> by adding spaces to the end of the data.
 ;     Example: S X=$$PAD("MIKE",7)  X="MIKE   " (Added 3 spaces.)
 ;---> Parameters:
 ;     1 - D  (req) Data to be padded.
 ;     2 - L  (req) Total length of resulting data.
 ;     3 - C  (opt) Character to pad with (default=space).
 ;
 Q:'$D(D) ""
 S:'$G(L) L=$L(D)
 S:$G(C)="" C=" "
 Q $E(D_$$REPEAT^XLFSTR(C,L),1,L)
 ;
 ;
 ;----------
SP(N,C) ;EP
 ;---> Return N spaces or other character.
 ;     Example: S X=$$SP(5)_X  Pads the front of X with 5 spaces.
 ;---> Parameters:
 ;     1 - N  (req) Number of spaces to be returned as extrinsic var.
 ;     2 - C  (opt) Character to pad with (default=space).
 ;
 Q:$G(N)<1 ""
 S:$G(C)="" C=" "
 Q $$PAD(C,N,C)
 ;
 ;
 ;----------
STRIP(X) ;EP
 ;---> Strip any punctuation characters from the beginning of X,
 ;---> including spaces.
 ;---> Parameters:
 ;     1 - X  (req) String of characters.
 ;
 Q:$G(X)="" ""
 F  Q:$E(X)'?1P  S X=$E(X,2,99)
 Q X
