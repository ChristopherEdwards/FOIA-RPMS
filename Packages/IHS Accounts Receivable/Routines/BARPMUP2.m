BARPMUP2 ; IHS/SD/LSL - MANUAL UPLOAD PROCESS ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 12/12/02 - V1.7 - NHA-0601-180049
 ;      Modified to find the correct bill in 3P.  Modified routine
 ;      clarity and documentation.
 ;
 ; IHS/SD/LSL - 05/08/03 - V1.7 Patch 1 - IM10668
 ;      Modified to not previous run if DUZ(2) not there.
 ;
 ; IHS/SD/LSL - 06/09/03 - V1.7 Patch 1
 ;      Modified to set BAR("OPT") to menu option to disquinish
 ;      Upload by date range during AR Bill creation
 ;
 ; *********************************************************************
 ;
 ;** Manual upload process by approval dates
 ;
 Q
 ; *********************************************************************
 ;
EN ;EP - entry
 D ^BARVKL0
 S BARESIG=""
 D SIG^XUSESIG                             ; Get electronic sig
 Q:X1=""
 I '$D(BARUSR) D INIT^BARUTL               ; Initialize A/R environment
 S BAROPT="Upload by date"               ; LSL - V1.7 Patch 1
 S (BAR("CONT"),BARERR)=0
 W !
 I ($D(^BARTMP("BARUP"))&($D(^BARTMP("BARUP","DUZ(2)")))) D  Q               ; Previous run detected
 . W $$EN^BARVDF("IOF"),!,"A PREVIOUS RUN HAS BEEN DETECTED",!
 . D STAT^BARPMUP4                         ; Display status of last run
 . I $E(BARUSTAT)="C" D ASKNEW Q           ; Previous run completed
 . D CONT                                  ; Continue last run?
 D NEW                                     ; Begin new run
 D EXIT
 Q
 ; *********************************************************************
 ;
ASKNEW ;
 ; Previous run complete, ask if new one
 W !,"The previous run has completed",!
 K DIR
 S DIR("A")="Do you want to do a new run"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 I Y'=1 Q
 W !!,*7,"You MUST write down the BAD bills found for follow up!"
 W !,"They did not upload into A/R",!
 K DIR
 S DIR("A")="Sure you are ready to restart"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 I Y'=1 Q
 W !
 K ^BARTMP("BARUP")
 D NEW
 D EXIT
 Q
 ; *********************************************************************
 ;
CONT ;
 ; Continue previous run
 K DIR
 S DIR(0)="Y"
 S DIR("A")="CONTINUE WITH RESTART"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 I 'Y D  Q
 . W !,"NO RESTART OF UPLOAD",!
 . D DX
 ; Variables obtained from result of STAT^BARPMUP4
 S BAR("CONT")=1
 S BARQ("RC")="RESUME^BARPMUP2"
 S BARQ("RP")="DX^BARPMUP2"
 S BARQ("NS")="BAR"
 S BARQ("RX")="EXIT^BARPMUP2"
 D ^BARDBQUE
 Q
 ; *********************************************************************
 ;
DX ;
 S ^BARTMP("BARUP","STATUS")="COMPLETE"
 W $$EN^BARVDF("IOF"),!,"This run is complete.  Here's the status",!
 D STAT^BARPMUP4
 W !!,+BARCNT_" 3P Bills updated to A/R"
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
NEW ;
 ; Start new run
 D GETDOS                                  ; Ask date range
 Q:BARSTART<1                              ; Date range not entered
 D SCANMSG                                 ; Ready? message
 I Y'=1 Q                                  ; Not ready
 D SCAN                                    ; Scan for 3p Bills
 Q
 ; *********************************************************************
 ;
GETDOS ;EP
 S BARSTART=$$DATE^BARDUTL(1)
 I BARSTART<1 Q
 ;
G1 ;
 S BAREND=$$DATE^BARDUTL(2)
 I BAREND<1 W ! G GETDOS
 I BAREND<BARSTART D  G GETDOS
 .W *7
 .W !!,"The END date must not be before the START date.",!
 Q
 ; *********************************************************************
 ;
SCANMSG ;
 W !!,"This process will scan the 3P BILL file and extract all bills with approval"
 W !,"dates between ",$$SDT^BARDUTL(BARSTART)," and ",$$SDT^BARDUTL(BAREND)
 W ". The process will check to make"
 W !,"sure that a bill that has already been uploaded will not be duplicated.",!
 K DIR
 S DIR("A")="Are you ready to start"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 Q
 ; *********************************************************************
 ;
SCAN ;
 W !!,"Starting scan process... "
 N BARDA,DIC,BARBAL,BARBLNM
 S BARCNT=0,BARDA=0,BARBLNM=""
 S ^BARTMP("BARUP","PREVIOUS START DATE")=BARSTART
 S ^BARTMP("BARUP","PREVIOUS END DATE")=BAREND
 S BARQ("RC")="RESUME^BARPMUP2"
 S BARQ("RP")="DX^BARPMUP2"
 S BARQ("NS")="BAR"
 S BARQ("RX")="EXIT^BARPMUP2"
 D ^BARDBQUE
 Q
 ; *********************************************************************
 ;
RESUME ;
 ;  Loop DUZ(2)
 I $G(^BARTMP("STOP")) Q
 S X="ERROR^BARPMUP2",@^%ZOSF("TRAP")
 S ^BARTMP("BARUP","STATUS")="IN PROCESS"
 S BARHOLD=DUZ(2)
 ; loop 3P Bill file DUZ(2)
 S DUZ(2)=0
 S:+BAR("CONT") DUZ(2)=$O(^ABMDBILL(^BARTMP("BARUP","DUZ(2)")),-1)
 F  S DUZ(2)=$O(^ABMDBILL(DUZ(2))) Q:'+DUZ(2)  D LOOPDT
 S DUZ(2)=BARHOLD
 Q
 ; *********************************************************************
 ;
LOOPDT ;
 ; Loop Date Approved x-ref on 3P bill for selected date range
 S ^BARTMP("BARUP","DUZ(2)")=DUZ(2)
 S BARAPDT=$O(^ABMDBILL(DUZ(2),"AP",BARSTART),-1)
 S:+BAR("CONT") BARAPDT=$O(^ABMDBILL(DUZ(2),"AP",^BARTMP("BARUP","LAST AP DATE",DUZ(2))),-1)
 F  S BARAPDT=$O(^ABMDBILL(DUZ(2),"AP",BARAPDT)) Q:'+BARAPDT!(BARAPDT>BAREND)  D LOOPBILL
 Q
 ; *********************************************************************
 ;
LOOPBILL ;
 ;
 S ^BARTMP("BARUP","LAST AP DATE",DUZ(2))=BARAPDT
 S BARDA=0
 S:+BAR("CONT") BARDA=^BARTMP("BARUP","LAST BILL IEN",DUZ(2))
 F  S BARDA=$O(^ABMDBILL(DUZ(2),"AP",BARAPDT,BARDA)) Q:'+BARDA  D DATA
 Q
 ; *********************************************************************
 ;
DATA ;
 ; Gather data and upload to A/R
 D NOW^%DTC
 S Y=%
 D DD^%DT
 S (^BARTMP("BARUP","LAST DATE"),BARDTS)=Y
 S ^BARTMP("BARUP","LAST BILL IEN",DUZ(2))=BARDA
 Q:'$D(^ABMDBILL(DUZ(2),BARDA,0))          ; No data on 3P bill, Q
 S (BARBAL,BARBLNM)=""
 S BARSTAT=$$GET1^DIQ(9002274.4,BARDA,.04,"I")
 ; Only want approved, billed, partial payment, or transfered bills
 Q:$S(BARSTAT="A":0,BARSTAT="B":0,BARSTAT="P":0,BARSTAT="T":0,1:1)
 S BARBLNM=$$GET1^DIQ(9002274.4,BARDA,.01)
 S ^BARTMP("BARUP","LAST BILL NAME",DUZ(2))=BARBLNM
 S BAREXIST=$$FINDAR(BARBLNM)              ; Bill already in A/R?
 I +BAREXIST D ERROR2 Q                    ; It is, add  error list, q
 S BARCNT=BARCNT+1
 S ^BARTMP("BARUP","COUNT")=BARCNT
 I BARCNT#25=0,$E(IOST)="C",'$D(ZTQUEUED) W "."
 S DA=BARDA                                ; IEN to 3P bill
 D EXT^ABMAPASS                            ; Upload to A/R
 Q
 ; *********************************************************************
 ;
FINDAR(BARBLNM) ;
 ; Find the 3P bill in A/R
 ; If it exists in any A/R environment, put on ERROR list
 ; Pass in Bill number
 ; Pass out 1 if found, 0 if not found
 N BARDTMP,BARSNM,BARBTMP
 S BARBTMP=-1
 S BARSNM=$P(BARBLNM,"-")
 S BARDTMP=0
 F  S BARDTMP=$O(^BARBL(BARDTMP)) Q:('+BARDTMP!(BARBTMP>0))  D FINDAR2
 I BARBTMP>0 Q 1
 Q 0
 ; *********************************************************************
 ;
FINDAR2 ;
 N BARNNM
 S BARNNM=$O(^BARBL(BARDTMP,"B",BARSNM),-1)
 F  S BARNNM=$O(^BARBL(BARDTMP,"B",BARNNM)) Q:(($P(BARNNM,"-")'=BARSNM)!(BARBTMP>0))  D FINDAR3
 Q
 ; *********************************************************************
 ;
FINDAR3 ;
 S BARDATMP=0
 F  S BARDATMP=$O(^BARBL(BARDTMP,"B",BARNNM,BARDATMP)) Q:('+BARDATMP!(BARBTMP>0))  S BARBTMP=BARDATMP
 Q
 ; *********************************************************************
 ;
ERROR ;PROCESS AN ERROR
 S BARERR=BARERR+1
 S ^BARTMP("BARUP","ERRORS",BARERR)=BARBLNM_U_BARDA_U_$$GET1^DIQ(4,DUZ(2),.01)
 S X="ERROR^BARPMUP2",@^%ZOSF("TRAP")
 G RESUME
 ; *********************************************************************
 ;
ERROR2 ;
 ; Process bill already exists error.
 S BARERR=BARERR+1
 S ^BARTMP("BARUP","ERRORS",BARERR)=BARBLNM_U_BARDA_U_"ALREADY IN A/R"
 S X="ERROR^BARPMUP2",@^%ZOSF("TRAP")
 Q
 ; *********************************************************************
 ;
EXIT ;
 S X=^%ZOSF("ERRTN"),@^%ZOSF("TRAP")
 D ^BARVKL0
 Q
