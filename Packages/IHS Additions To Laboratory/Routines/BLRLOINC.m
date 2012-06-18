BLRLOINC ;IHS/OIT/MKK - IHS LAB LOINC REPORT [ 12/19/2002  7:25 AM ]
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
 NEW CNTLOINC,PTRLOINC,CNTLT,CNTZZ
 NEW QFLG,SITESPEC,STR
 ;
 D COMLOINC         ; Count Lab Tests with LOINC Codes
 ;
 D REPORT           ; Output Results
 ;
 Q
COMLOINC ; EP - Compile Listing of Tests with LOINC Codes
 S (CNTLOINC,FLAG,CNTLT,TEST,CNTZZ)=0
 F  S TEST=$O(^LAB(60,TEST))  Q:TEST=""!(TEST'?.N)  D
 . S CNTLT=CNTLT+1                 ; Count # of Lab Tests in dictionary
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
 . I FLAG S CNTLOINC=CNTLOINC+1
 ;
 Q
 ;
REPORT ; EP - Results
 NEW LN,LRLRPT,TAB,TFLAG
 ;
 D BUILDARY        ; Build the Array
 ;
 D REPORTIT        ; Output the results
 ;
 Q
 ;
BUILDARY ; EP
 NEW NOLOINC
 ;
 S NOLOINC=CNTLT-CNTLOINC
 ;
 S TAB=$J("",5)
 S LN=0
 D ADDLNCJ($$LOC^XBFUNC,.LN)
 D ADDLNCJ("Logical Observation Identifiers",.LN,"YES","YES")
 D ADDLNCJ("Names and Codes (LOINC)",.LN)
 D ADDLNCJ("IHS Percentages Report",.LN)
 D ADDLNCJ($TR($J("",IOM)," ","-"),.LN)
 ;
 D ADDLINE(" ",.LN)
 D ADDLINE("Number of Lab Tests in Dictionary = "_CNTLT,.LN)
 D ADDLINE(" ",.LN)
 ;
 I CNTLOINC<1 D
 . D ADDLINE(TAB_"Not a single Lab Test has a LOINC Code",.LN)
 . D ADDLINE(" ",.LN)
 ;
 I +$G(CNTZZ)>0 D
 . D ADDLINE(TAB_"Number of ZZ'ed Lab Tests in Dictionary = "_CNTZZ,.LN)
 . D ADDLINE(" ",.LN)
 ;
 D ADDLINE(TAB_"Number of Lab Tests in Dictionary with LOINC codes = "_CNTLOINC,.LN)
 D ADDLINE(" ",.LN)
 ;
 D ADDLINE(TAB_"Number of Lab Tests in Dictionary without LOINC codes = "_NOLOINC,.LN)
 D ADDLINE(" ",.LN)
 ;
 D ADDLINE(TAB_"Percentage of Lab Tests in File 60 with LOINC codes = "_($FN((CNTLOINC/CNTLT),"",3)*100)_"%",.LN)
 D ADDLINE(" ",.LN)
 ;
 I (CNTLT-CNTZZ)>0 D
 . D ADDLINE(TAB_"Percentage of Non ZZ'ed Lab Tests in File 60 with LOINC codes = "_($FN((CNTLOINC/(CNTLT-CNTZZ)),"",3)*100)_"%",.LN)
 . D ADDLINE(" ",.LN)
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
REPORTIT ; EP
 S %ZIS="Q"
 D ^%ZIS
 I POP D
 . W !!,?10,"DEVICE could not be selected.  Output will be to the screen.",!!
 ;
 I $D(IO("Q")) D  Q
 . S ZTRTN="DQ^BLRLOINC",ZTDESC="IHS LOINC Percentage Report"
 . S ZTSAVE("LR*")=""
 . S ZTSAVE("CNT*")=""
 . D ^%ZTLOAD,^%ZISC
 . W !,"Request ",$S($G(ZTSK):"Queued - Task #"_ZTSK,1:"NOT Queued"),!!
 . D BLREND
 . D PRESSIT
 ;
DQ ; EP
 ;
 U IO
 I $E(IOST,1,2)="C-" D ^XBCLS            ; If terminal, clear sceen & home cursor
 ; I IOST'["C-VT" W @IOF                 ; Form Feed if not terminal
 ;
 D EN^DDIOL(.LRLRPT)                     ; Display the array
 ;
 I $D(ZTQUEUED) Q                        ; If Queued, QUIT
 ;
 D ^%ZISC                                ; Close all the devices
 D PRESSIT
 ;
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
