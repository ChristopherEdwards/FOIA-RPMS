BLRNLOIN ;IHS/OIT/MKK - IHS LAB NO LOINC REPORT [ 02/05/2008  1:25 PM ]
 ;;5.2;LR;**1024**;May 2, 2008
 ;;
EEP ; Ersatz EP
 W !!
 W ">>>>>>>>>>>>"
 W " USE LABEL "
 W "<<<<<<<<<<<<"
 W !!
 Q
 ;
EP ; EP -- Main Entry Point
 NEW CNTLOINC,PTRLOINC,CNTLT,CNTZZ,CNTNLOI
 NEW QFLG,SITESPEC,STR
 NEW LABTNME,NOLOINC
 ;
 D NCNTLNC         ; Count Lab Tests without LOINC Codes
 ;
 I CNTNLOI<1 D  Q
 . W !,"All Tests in File 60 Have LOINC Codes.",!
 . W "Program Finished",!!
 . D PRESSIT
 ;
 D REPORT          ; Output Results
 ;
 D PRESSIT         ; Press RETURN key
 ;
 Q
 ;
NCNTLNC ; EP -- Compile listing of tests without LOINC codes
 D NCNTLNCI        ; Initialize variables
 ;
 F  S TEST=$O(^LAB(60,TEST))  Q:TEST=""!(TEST'?.N)  D
 . ; Warm fuzzy to user
 . W "."
 . I $X>78 W !
 . ;
 . ; Skip all COSMIC tests  -- I don't belive you can LOINC panels
 . I +$O(^LAB(60,TEST,2,0))>0 Q
 . ;
 . S CNTLT=CNTLT+1                 ; Count # of ATOMIC Lab Tests in dictionary
 . ;
 . ; Count # of Lab Tests that have a Name that begin with Two Z's
 . I $E($P($G(^LAB(60,TEST,0)),"^",1),1,2)="ZZ" S CNTZZ=CNTZZ+1
 . ;
 . ; LOINC Codes are stored in the SITE/SPECIMEN multiple, so have to
 . ; go through the multiple and determine if there is a LOINC Code
 . S (FLAG,SITESPEC)=0
 . F  S SITESPEC=$O(^LAB(60,TEST,1,SITESPEC))  Q:SITESPEC=""!(SITESPEC'?.N)!(FLAG)  D
 .. I +$G(^LAB(60,TEST,1,SITESPEC,95.3))>0  S FLAG=1     ; LOINC
 . ;
 . ; There is a LOINC, so count it and go to next test
 . I FLAG S CNTLOINC=CNTLOINC+1  Q
 . ;
 . ; There is no LOINC; Build array of such tests -- alpha sort by name
 . S LABTNME=$P($G(^LAB(60,TEST,0)),"^",1)  ; Lab Test Name
 . S NOLOINC(LABTNME)=TEST                  ; Store data
 . S CNTNLOI=CNTNLOI+1                      ; Count them
 ;
 Q
 ;
NCNTLNCI        ; EP -- Initialize variables
 W !
 S (CNTLOINC,FLAG,CNTLT,TEST,CNTZZ,CNTNLOI)=0
 D ^XBCLS
 W $$CJ^XLFSTR("Going through LAB TEST FILE (# 60)",IOM),!!
 Q
 ;
REPORT ; EP - Results
 NEW LN,LRLRPT,TAB,TFLAG
 NEW HEADER,PG,QFLAG,LINES,MAXLINES
 ;
 I $$OKAYGO'="Y" Q      ; Want to go on?
 ;
 D BUILDARY             ; Build the array for output
 ;
 D REPORTIT             ; Output the results
 ;
 Q
OKAYGO() ; EP
 W !!
 W "There are ",CNTNLOI," Lab Tests WITHOUT LOINC codes"
 W !!
 W ?5,"The Detailed report will be approximately ",(CNTNLOI\55)," printed pages long"
 W !!
 D ^XBFMK
 S DIR("A")="Do you want to continue"
 S DIR("B")="NO"
 S DIR(0)="YO"
 D ^DIR
 I $E($$UP^XLFSTR(X),1,1)="N"!(+$G(DUOUT))  D  Q "NO"
 . W !!
 . W ?10,"Program exiting",!
 ;
 Q "Y"
 ;
BUILDARY ; EP -- Build the output array
 S TAB=$J("",5)
 S LN=0
 D ADDLNCJ($$LOC^XBFUNC,.LN)
 D ADDLNCJ("Logical Observation Identifiers",.LN)
 D ADDLNCJ("Names and Codes (LOINC)",.LN)
 D ADDLNCJ("IHS Lab Test File (# 60)",.LN)
 D ADDLNCJ("Tests WITHOUT Codes",.LN)
 D ADDLINE(" ",.LN)
 D ADDLINE(TAB_"File 60",.LN)
 D ADDLINE(TAB_"Number"_"   File 60 Description",.LN)
 D ADDLNCJ($TR($J("",IOM)," ","-"),.LN)
 ;
 S LABTNME=""
 F  S LABTNME=$O(NOLOINC(LABTNME))  Q:LABTNME=""  D
 . S TEST=$G(NOLOINC(LABTNME))
 . D ADDLINE("    "_$J(TEST,8)_"  "_$E(LABTNME,1,55),.LN)
 ;
 D ADDLINE(" ",.LN)
 D ADDLINE("Number of Lab Tests Without LOINC Code = "_CNTNLOI,.LN)
 D ADDLINE(" ",.LN)
 ;
 D ADDLINE(TAB_"Number of Lab Tests in Dictionary = "_CNTLT,.LN)
 D ADDLINE(" ",.LN)
 ;
 D ADDLINE(TAB_"Number of Lab Tests in Dictionary with LOINC codes = "_CNTLOINC,.LN)
 D ADDLINE(" ",.LN)
 ;
 I +$G(CNTZZ)>0 D
 . D ADDLINE(TAB_"Number of ZZ'ed Lab Tests in Dictionary = "_CNTZZ,.LN)
 . D ADDLINE(" ",.LN)
 ;
 Q
 ;
ADDLNCJ(MIDSTR,LN,LEFTSTR,RGHTSTR) ; EP
 S LN=LN+1
 S LRLRPT(LN)=$$CJ^XLFSTR(MIDSTR,IOM)
 ;
 ; Today's Date
 S:$G(LEFTSTR)'="" $E(LRLRPT(LN),1,13)="Date:"_$$HTE^XLFDT($H,"2DZ")
 ;
 ; Current Time
 S:$G(RGHTSTR)'="" $E(LRLRPT(LN),IOM-15)=$J("Time:"_$$UP^XLFSTR($P($$HTE^XLFDT($H,"2MPZ")," ",2,3)),16)
 ;
 ; Trim extra spaces
 S:$G(LEFTSTR)'=""!($G(RGHTSTR)'="") LRLRPT(LN)=$$TRIM^XLFSTR(LRLRPT(LN),"R"," ")
 ;
 Q
 ;
ADDLINE(ADDSTR,LN) ; EP
 S LN=LN+1
 S LRLRPT(LN)=$$LJ^XLFSTR(ADDSTR,IOM)
 Q
 ;
REPORTIT ; EP -- Report the data
 S %ZIS="Q"
 D ^%ZIS
 I POP D
 . W !!,?10,"DEVICE could not be selected.  Output will be to the screen.",!!
 ;
 I $D(IO("Q")) D  Q
 . S ZTRTN="DEVRPT^BLRNLOIN",ZTDESC="IHS Non LOINC Lab Tests Report"
 . S ZTSAVE("LR*")=""
 . S ZTSAVE("CNT*")=""
 . D ^%ZTLOAD,^%ZISC
 . W !,"Request ",$S($G(ZTSK):"Queued - Task #"_ZTSK,1:"NOT Queued"),!!
 . D BLREND
 ;
DEVRPT ; EP
 D DEVRPTIN
 ;
 U IO
 F  Q:$G(LRLRPT(J))=""!(QFLAG="Q")  D
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLAG,"NO")  I QFLAG="Q" Q
 . ;
 . S J=J+1
 . W $G(LRLRPT(J))
 . S LINES=LINES+1
 ;
 D ^%ZISC
 ;
 Q
 ;
DEVRPTIN ; EP -- Initialize variables
 S (PG,CNT)=0
 S MAXLINES=IOSL-3
 S LINES=MAXLINES+10
 S QFLAG="NO"
 K HEADER
 F J=2:1:8 S HEADER(J-1)=LRLRPT(J)
 ;
 S J=10
 Q
 ;
 ; Just Prompt and quit
PRESSIT ; EP
 D ^XBFMK
 S DIR("A")=$J("",10)_"Press RETURN Key"
 S DIR(0)="FO^1:1"
 D ^DIR
 Q
 ;
 ; Called when Queued
BLREND ; EP
 I $E(IOST,1,2)="P-" W @IOF
 I $D(ZTQUEUED) S ZTREQ="@"
 E  D ^%ZISC
 D KVA^VADPT
 Q
