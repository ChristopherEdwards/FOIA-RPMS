BIUTL5 ;IHS/CMI/MWR - UTIL: MENU TITLS, DATE FORMAT; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: SETVARS, MENUT, TITLE, CENTERT, COPYLET,
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
MENUT(TITLE) ;EP
 ;---> Display menu title from BI Menu options.
 ;---> REQUIRED VARIABLES: TITLE=TEXT TO BE CENTERED AND DISPLAYED.
 ;--->                     DUZ(2)=CURRENT LOCATION TO BE DISPLAYED.
 N BITTAB,BIFAC,BIUNL,I
 S:'$D(TITLE) TITLE="* NO TITLE SUPPLIED *"
 S TITLE="*  "_TITLE_"  *"
 S BITTAB=39-($L(TITLE)/2)
 W:$D(IOF) @IOF
 W !?3,"IMMUNIZATION v"_$$VER^BILOGO
 W ?BITTAB,TITLE
 W ?53,"Site: ",$E($$INSTTX^BIUTL6(DUZ(2)),1,20)
 S BIUNL="" F I=1:1:$L(TITLE) S BIUNL=BIUNL_"="
 S BIUNL=$$SP(BITTAB)_BIUNL
 S BIUNL=$$PAD(.BIUNL,53)_"User: "_$E($$PERSON^BIUTL1($G(DUZ)),1,20)
 W !,BIUNL
 Q
 ;
 ;
 ;----------
TITLE(BITL,BIONE) ;EP
 ;---> Clear screen and display BITL (Immunization_version# prepended).
 ;---> Parameters:
 ;     1 - BITL  (req) Text to be centered and displayed.
 ;     2 - BIONE (opt) If BIONE=1 then return only ONE linefeed after title.
 ;
 S:'$D(BITL) BITL="NO BITL SUPPLIED"
 S BITL="*  "_BITL_"  *" D CENTERT(.BITL)
 W:$D(IOF) @IOF
 W " "_$$LMVER^BILOGO,!,BITL,!
 W:'$G(BIONE) !
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
UPPER(X,L) ;EP
 ;---> Translate X to all uppercase.
 ;---> Parameters:
 ;     1 - X  (req) Value to be translated into all uppercase.
 ;     2 - L  (opt) If L=1, translate to all lowercase.
 ;
 I $G(L) S X=$TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz") Q X
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q X
 ;
 ;
 ;----------
UPXREF(X,BIGBL,Z) ;EP
 ;---> Set uppercase xref for X.  Called from M xrefs on mixed case
 ;---> fields where an all uppercase lookup is needed.
 ;---> Parameters:
 ;     1 - X     (req) The value that should be xrefed in uppercase.
 ;     2 - BIGBL (req) The global root of the file.
 ;
 ;---> Variables:
 ;     1 - DA    (req) IEN of the entry being xrefed.
 S:$G(Z)="" Z="U"
 Q:'$D(BIGBL)  Q:$G(X)=""  Q:'$G(DA)
 S @(BIGBL_"""""_Z_"""",$E($$UPPER(X),1,30),DA)")=""
 ;
 Q
 ;
 ;
 ;----------
KUPXREF(X,BIGBL) ;EP
 ;---> Kill uppercase xref for X.  Called from M xrefs on mixed case
 ;---> fields where an all uppercase lookup is needed.
 ;---> Parameters:
 ;     1 - X     (req) The value that should be xrefed in uppercase.
 ;     2 - BIGBL (req) The global root of the file.
 ;
 ;---> Variables:
 ;     1 - DA    (req) IEN of the entry being xrefed.
 ;
 Q:'$D(BIGBL)  Q:$G(X)=""  Q:'$G(DA)
 K @(BIGBL_"""U"",$E($$UPPER(X),1,30),DA)")
 Q
 ;
 ;
 ;----------
SLDT2(DATE,YY) ;EP
 ;---> Convert Fileman Internal Date to "slash" format: MM/DD/YYYY.
 ;---> Parameters:
 ;     1 - DATE (req) The date in Fileman format.
 ;     2 - YY   (opt) If YY=1, return 2-digit year: MM/DD/YY.
 ;
 ;---> DATE=DATE IN FILEMAN FORMAT.
 Q:'$G(DATE) "NO DATE"
 S DATE=$P(DATE,".")
 Q:$L(DATE)'=7 DATE
 Q:'$E(DATE,4,5) $E(DATE,1,3)+1700
 Q:'$E(DATE,6,7) $E(DATE,4,5)_"/"_$E(DATE,2,3)
 Q:($G(YY)=1) $E(DATE,4,5)_"/"_$E(DATE,6,7)_"/"_$E(($E(DATE,1,3)+1700),3,4)
 Q $E(DATE,4,5)_"/"_$E(DATE,6,7)_"/"_($E(DATE,1,3)+1700)
 ;
 ;
 ;----------
SLDT1(DATE) ;EP
 ;---> CONVERT FILEMAN INTERNAL DATE TO "SLASH" FORMAT:
 ;---> MM/DD/YYYY @TIME
 N Y,BITIME S BITIME=""
 Q:'$D(DATE) "NO DATE"
 S Y=DATE,DATE=$P(DATE,".")
 Q:'DATE "NO DATE"
 Q:$L(DATE)'=7 DATE
 Q:'$E(DATE,4,5) $E(DATE,1,3)+1700
 Q:'$E(DATE,6,7) $E(DATE,4,5)_"/"_$E(DATE,2,3)
 D DD^%DT
 S:Y["@" BITIME=" @ "_$P($P(Y,"@",2),":",1,2)
 Q $E(DATE,4,5)_"/"_$E(DATE,6,7)_"/"_($E(DATE,1,3)+1700)_BITIME
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
 ;---> NOTE: This code is copied into routine ^BIPATUP1 for speed.
 ;---> Any changes here should also be made to the call in ^BIPATUP1.
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
 ;---> Return external date in format: MMM DD,YYYY
 ;---> Parameters:
 ;     1 - DATE  (req) Internal Fileman date (DT).
 ;
 N X,Y
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
 ;
 ;
 ;----------
COPYLET ;EP
 ;---> COPY TEXT OF GENERIC SAMPLE LETTER TO ONE OR MORE BI PURPOSES.
 ;---> EDIT NEXT LINE TO INCLUDE IENS OF BI PURPOSES TO BE CHANGED.
 ;F DA=15,16,18,19 D
 S DA=0
 F  S DA=$O(^BINOTP(DA)) Q:'DA  D
 .K ^BINOTP(DA,1)
 .S N=0
 .F  S N=$O(^BILET(1,1,N)) Q:'N  D
 ..S ^BINOTP(DA,1,N,0)=^BILET(1,1,N,0)
 .S ^BINOTP(DA,1,0)=^BILET(1,1,0)
 Q
