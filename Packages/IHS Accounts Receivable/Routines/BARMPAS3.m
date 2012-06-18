BARMPAS3 ; IHS/SD/LSL - Patient Account Statement Print ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19,20,21**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 05/13/03 - V1.7 Patch 2
 ;
 ; ********************************************************************
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
 ; IHS/SD/PKD 1.8*20 Page Length correction
 ;I (IOSL-$Y)<L D
 . ; IHS/SD/PKD 1.8*19 Add extra line feeds to keep page alignment
 . ;I $E(IOST)="P" D PAZ,PGHDR Q  ; 1.8*19 If printer
 . ;D PAZ^BARRUTL
 . ;I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BARF1=1 Q
 .;D PGHDR
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
 D RETAIN                            ; Keep run to print again?
 D GETHDR^BARMPAS3                   ; Get Statement Header
 Q:'$D(BARHDRDA)                     ; Not in A/R Letters and Text File
 S BARQ("RC")="COMPUTE^BARMPAS2"     ; Build tmp global with data
 ; IHS/SD/PKD 1.8*19 move PRINT to BARMPAS3
 ;S BARQ("RP")="PRINT^BARMPAS2"
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
 S BAR1="BARPAS"
 F  S BAR1=$O(^XTMP(BAR1)) Q:BAR1'["BARPAS"  D
 . S BARCNT=BARCNT+1                           ; Line counter
 . S BARDT=$P(BAR1,"BARPAS",2,99)              ; Date of Run
 . S BARRUN(BARCNT)=BARDT                      ; Array of runs
 . S Y=BARDT
 . D DD^%DT
 . W !,$J(BARCNT,2),?5,Y                       ; Line count,date run
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
 S BARTMP=$G(^XTMP("BARPAS"_BARRUNDT,0,"DT"))
 S BARDTB=$P(BARTMP,U)                         ; Statement begin date
 S BARDTE=$P(BARTMP,U,2)                       ; Statement end date
 ; IHS/SD/AR 1.8*19 10/13/10
 ; S HL1="DOS     Trans Bill    Service  Description  Chrg     Credit          Patient"
 ; S HL2="        Date  Num     Type                                           Bal"
 ;S HL1="SERVICE                                INSURANCE  PATIENT  INSURANCE    PAT"
 ;S HL2="DATE         BILL  PROVIDER    BILLED   PAYMENT   PAYMENT  OUTSTAND'G   RESP"
 ;S HL1="SVC DATE    BILL      PROVIDER"
 ;S HL2="BILLED       INS OWES       INS PMT        PT PMT        ADJ AMT        PAT RESP"
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
