BARMPAS3 ; IHS/SD/LSL - Patient Account Statement Print ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19,20,21,23**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 05/13/03 - V1.7 Patch 2
 ;
 ; ********************************************************************
 ;FEB 2012 PETER OTTIS IHS/SD/OIT LINE PRINT+1 ADDED TO GET REPORT HEADER WHEN PRINTED (QUEUED)
 ;HEAT#80718 21-AUG-2012 P.OTTIS  ADDED SORTING OPTION BY PATNAME
 ;HEAT #91646 DROPPED KILLING COLLECTED DATA (RETAIN DISFUNCT) - WILL BE HANDLED BY THE NEW 'PUR' OPTION
 Q
 ;
GETHDR  ;EP
  ; Find Patient Account Header
 K DIC,DA,DR
 S DIC="^BAR(90052.03,"              ; A/R Letters & Text File
 S DIC(0)="LX"
 S X="ACCOUNT STATEMENT HEADER"
 D ^DIC
 ;
 ; Account Header not found
 I +Y<0 D  Q
 . W !,$$CJ^XLFSTR("ACCOUNT STATEMENT HEADER entry not found in A/R LETTERS & TEXT File",IOM)
 . W !,$$CJ^XLFSTR("Please create the entry before proceeding with this print.",IOM)
 . D EOP^BARUTL(0)
 ;
 ; Retrieve and store header in XTMP
 S BARHDRDA=+Y
 D ENP^XBDIQ1(90052.03,BARHDRDA,100,"BARHDR(")
 K BARHDR("ID")
 K ^XTMP("BARPAS"_BARRUNDT,"HDR")
 M ^XTMP("BARPAS"_BARRUNDT,"HDR")=BARHDR(100)
 K BARHDR
 Q
 ; ********************************************************************
 ;
PGHDR ; EP
 ; Print Patient Account header and demographics
 ; Write Billing Office Address
 K BARPT,BARHRN
 S BARPG=BARPG+1
 ; BARPG>1 W !
 ;W @IOF W #
 W $$EN^BARVDF("IOF"),!  ; 
 ;W @IOF  ;Original code restored
 S $P(BAREQUAL,"=",IOM-2)=""
 S $P(BARDASH,"-",IOM-2)=""
 D HDR
 ;
 ; Gather Patient Demographics
 S BARDFN=$$GET1^DIQ(90050.02,BARACDA,1.001)   ; IEN to Patient file
 S BARPTNM=$$GET1^DIQ(9000001,BARDFN,.01)      ; Patient Name
 S BARPTAGE=$$GET1^DIQ(9000001,BARDFN,1102.99)  ; Patient Age
 S BARADDR=$$GET1^DIQ(9000001,BARDFN,1602.2)   ; Patient street Address
 S BARCITY=$$GET1^DIQ(9000001,BARDFN,1603.2)   ; Patient City
 S BARSTATE=$$GET1^DIQ(2,BARDFN,.115,"I")      ; Patient State IEN
 S:+BARSTATE BARSTATE=$$GET1^DIQ(5,BARSTATE,1)  ; State code
 S BARZIP=$$GET1^DIQ(9000001,BARDFN,1605.2)    ; Patient Zip
 S BARIENS=DUZ(2)_","_BARDFN_","
 S BARHRN=$$GET1^DIQ(9000001.41,BARIENS,.02)   ; Patient Chart number
 ;
 ; Write Patient Name and Address
 I BARPTAGE<18 W !,?5,"TO THE PARENTS OF"
 W !?5,BARPTNM
 W ?55,"STATEMENT PERIOD"
 W !?5,BARADDR
 W ?55,$$SDT^BARDUTL(BARDTB)," - ",$$SDT^BARDUTL(BARDTE)
 W !?5,BARCITY,", ",BARSTATE,", ",BARZIP
 W !!!,BAREQUAL
 W !,HL1
 W !,HL2
 W !,BAREQUAL
 Q
 ; ********************************************************************
 ;
HDR ; EP
 ; Write Billing Office Address
 W !,?2,"Statement Date: ",$$SDT^BARDUTL(DT),?70,"Page: ",BARPG,!
 F I=1:1 Q:'$D(^XTMP("BARPAS"_BARRUNDT,"HDR",I))  W !,^(I)
 W !
 Q
 ; ********************************************************************
 ;
PG(L) ; EP
 I ((IOSL-$Y)<L)&($E(IOST)="P") D PGHDR Q  ; Printer
 Q:IOSL>$Y
  D PAZ^BARRUTL
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BARF1=1 Q
 D PGHDR
 ;end 1.8*20
 Q
 ; ********************************************************************
 ;
EXIT ; EP
 I AZKILL=0 K ^XTMP("AZLKPS",AZJB)
 K AZJB,AZKILL
 Q
 ;
 ;IHS/SD/PKD 1.8*19 Moved here from BARMPAS2 due
 ; to size limitations per SAC
PRTASK ; EP
 ; Called from Print Patient Accounts' Statements AR Menu Option
 D SELECT                            ; Select run to Print
 Q:'$D(BARRUNDT)                     ; No run selected
 S BARSRTBY=$G(^XTMP("BARPAS"_BARRUNDT,0,"SORTBY"),-1) ;P.OTT
 I BARSRTBY<0 D  Q
 . W !!,"THIS BATCH OF STATEMENTS IS NOT COMPATIBLE WITH THE NEW FILE STRUCTURE."
 . W !,"WILL RUN REIDEXING FIRST, THEN TRY AGAIN",!!
 . D REINDEX^BARMPAS5("BARPAS"_BARRUNDT)
 . D EOP^BARUTL(0)
 . Q
 ;;;D RETAIN                         ; Keep run to print again?
 D GETHDR^BARMPAS3                   ; Get Statement Header
 Q:'$D(BARHDRDA)                     ; Not in A/R Letters and Text File
 S BARQ("RC")="COMPUTE^BARMPAS2"     ; Build tmp global with data
 S BARQ("RP")="PRINT^BARMPAS3"       ; Print reports from tmp global
 S BARQ("NS")="BAR"                  ; Namespace for variables
 S BARQ("RX")="EXIT^BARMPAS2"        ; Clean-up routine
 D GETMSG^BARMPAS
 D ^BARDBQUE                         ; Double queuing
 D PAZ^BARRUTL                       ; Press return to continue
 Q
 ; ***
SELECT ;
 K BARRUNDT
 ; Look for data in temp global
 S BAR1=$O(^XTMP("BARPAS"))
 I BAR1'["BARPAS" D  Q
 . W !!!,$$CJ^XLFSTR("NO PATIENT ACCOUNT STATEMENT RUNS TO CHOOSE FROM",IOM)
 . D EOP^BARUTL(0)
 ;
 ; Display tasked runs to choose from
 W !,"Select Account Run time:  ",!
 S BARCNT=0
 S BAR1="BARPAS" F  S BAR1=$O(^XTMP(BAR1)) Q:BAR1'["BARPAS"  D
 . S BARCNT=BARCNT+1                           ; Line counter
 . S BARDT=$P(BAR1,"BARPAS",2,99)              ; Date of Run
 . S BARRUN(BARCNT)=BARDT                      ; Array of runs
 . S Y=BARDT
 . D DD^%DT
 . W !,$J(BARCNT,2),?5,Y                       ; Line count,date run
 . I '$D(^XTMP("BARPAS"_BARDT,0,"SORTBY")) W "  not compatible" Q
 . S BARSRTBY=$G(^XTMP("BARPAS"_BARDT,0,"SORTBY"))+1
 . ;;;I BARSRTBY W "  sorted by ",$P("Billing location, Account Number;Billing location, Patient name",";",BARSRTBY)
 ;
 ; Select run to print
 K DIR
 S DIR(0)="NO^1:"_BARCNT
 D ^DIR
 I '+Y D  Q
 . W !,"NONE SELECTED",!
 . D EOP^BARUTL(0)
 S BARRUNDT=BARRUN(+Y)
 K BARRUN  ; IHS/SD/PKD 10/12/10 KILL ARRAY
 Q
 ; ***
 ;
RETAIN ;
 W !,"DO YOU WISH TO RETAIN THE RUN TO PRINT AGAIN ?"
 K DIR
 S DIR(0)="Y"
 S DIR("B")="N"
 D ^DIR
 S BARKILL=Y
 Q
 ; ***
 ;
PRINT  ;EP
 D GETHDR ;21 FEB 2012 P.OTT IHS/SD/OIT ADDED FOR QUEUED REPORTS 
 S BARTMP=$G(^XTMP("BARPAS"_BARRUNDT,0,"DT"))
 S BARSRTBY=$G(^XTMP("BARPAS"_BARRUNDT,0,"SORTBY"),0) ;P.OTT 
 S BARDTB=$P(BARTMP,U)                         ; Statement begin date
 S BARDTE=$P(BARTMP,U,2)                       ; Statement end date
 S HL1="        BILLED    INSURANCE     PATIENT   ADJUSTED     INSURANCE    PATIENT"
 S HL2="        AMOUNT     PAYMENT      PAYMENT    AMOUNT     OUTSTANDING  AMOUNT DUE"
 D PRINT^BARMPAS2
 Q
 ;
PAZ ; Add extra line feeds to force alignment
 ; IHS/SD/PKD copied from PAZ^BARRUTL but for printers
 ; BARRUTL quits if not terminal
 Q  ; IHS/SD/PKD 1.8*20 removed didn't work for network printers
 I '$D(IO("Q")) D
 .F  W ! Q:$Y>(IOSL+3)
 Q
