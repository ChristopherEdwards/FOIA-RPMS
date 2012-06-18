BLRSHDRP ;IHS/OIT/MKK - NON-MICRO STATE HEALTH DEPT REPORT PRINTER [ 07/22/2005 ]
 ;;5.2;LR;**1020**;Sep 13, 2005
 ;;
 ; Lab PSG gave permission to retrieve program from PIMC and distribute
 ; nationally.  This is called by BLRSHDRC.
 ; 
 ; Note that ^BLRSHDRD is the global name for the new dictionary that
 ; this routine depends upon:  REPORTABLE LAB TESTS (# 90475).
 ; It has been distributed with this patch and number given to it by
 ; the IHS DBA.
 ; 
 ; This the "printer" routine
 ; 
 ; The following is code to prevent routine from being run by D ^BLRLRSEP.
EP ;
 W !,$C(7),$C(7),$C(7),!          ; Bell/Beep
 W "Run from Label ONLY",!!       ; Failsafe code
 Q
 ;
PEP ; EP
 NEW MAXPGLEN                     ; Max Page Length
 NEW BLRQUFLG                     ; Queued Report Flag
 ; 
 I '$D(^TMP($J)) D  Q
 . W @IOF,"NO DATA TO REPORT",!!
 . ;
 . D PRESSRTN                     ; Press RETURN message
 ;
 D ^XBCLS                         ; Clear screen and home cursor
 D EN^DDIOL(.HEADERS)             ; Write the Screen Header Lines
 ;
 S %ZIS="Q"
 D ^%ZIS                          ; "Open"
 ;
 I POP>0 D  Q
 . W !,*7,*7,*7,"Device Open failed with Abnormal Exit."
 . W !,?5,"Printing terminated.",!!
 . D PRESSRTN
 ;
 I IOM<132 D  Q
 . D ^%ZISC                       ; "Close"
 . W !,*7,*7,*7,"Right Margin MUST BE 132."
 . W ?5,"Device's Right Margin = ",IOM,!!
 . W !,?5,"Printing terminated.",!!
 . D PRESSRTN
 ;
 I $D(IO("Q")) D  Q               ; Queue Report
 . S BLRQUFLG="TRUE"
 . S ZTRTN="LP^BLRSHDRP"
 . S ZTSAVE("BLR*")=""
 . S ZTSAVE("^TMP($J,")=""
 . S ZTDESC="Reportable diseases"
 . D ^%ZTLOAD
 . K ZTSAVE,ZTDESC,ZTRTN,IO("Q")
 . W !!,"End of Queued Report",!!
 . D ^%ZISC
 ;
LP ;
 I $G(BLRQUFLG)="TRUE" D          ; If Queued report, need HEADER
 . D SETHDRVS^BLRSHDRC($G(^TMP($J,"DIC4PTR")))
 . D MAKEHDRS^BLRSHDRC            ; Set Header variables
 ;
 S MAXPGLEN=IOSL-10               ; Give white space at bottom of page
 U IO                             ; Use device
 ;
 S PEDT=$E(BLRENDT,4,5)_"/"_$E(BLRENDT,6,7)_"/"_$E(BLRENDT,2,3)
 S PSDT=$E(BLRSDT,4,5)_"/"_$E(BLRSDT,6,7)_"/"_$E(BLRSDT,2,3)
 S FOOTFLG=0,PG=1
 S BLRTP=0
 F  S BLRTP=$O(^TMP($J,BLRTP)) Q:'BLRTP!(BLRTP'?.N)  D
 .S IENS=BLRTP_","
 .S BLRTST=$$GET1^DIQ(90475,IENS,2)       ; Reporting Name
 .I FOOTFLG=1 D FOOTER
 .I PG>1 W @IOF
 .D RHEAD
 .S LRDFN=""
 .F  S LRDFN=$O(^TMP($J,BLRTP,LRDFN)) Q:'LRDFN  D
 ..S LRIDT=""
 ..F  S LRIDT=$O(^TMP($J,BLRTP,LRDFN,LRIDT)) Q:'LRIDT  D PRTIT
 D FOOTER W @IOF
 ;
 I $G(QUEFLAG)'="" Q              ; If Queued report then Quit NOW
 ;
 D ^%ZISC                         ; "Close"
 ;
 Q
 ;
 ; REPORT LOOP
RLOOP1 D:FOOTFLG=1 FOOTER
 W @IOF D RHEAD   ; W !,"Reporting Test: "_DWBUG,!
 S RPNM="" F II=0:0 S RPNM=$O(^UTILITY("CH",$J,DWBUG,RPNM))  Q:RPNM=""  D RLOOP2
 Q
 ;
RLOOP2 S RACC="" F III=0:0 S RACC=$O(^UTILITY("CH",$J,DWBUG,RPNM,RACC))  Q:RACC=""  D PRTIT
 Q
 ;
 ; PRINT LINES OF DATA
PRTIT ;
 S Y=^TMP($J,BLRTP,LRDFN,LRIDT)
 S Y1=^LR(LRDFN,"CH",LRIDT,0)
 ;
 I ($Y+6)>MAXPGLEN D FOOTER W @IOF D RHEAD
 ;
 W !!,$E($P(Y,U,1),1,28)          ; PATIENT NAME
 W ?30,$P(Y,U,2)                  ; HRN
 W ?40,$P(Y,U,3)                  ; DOB
 W ?54,$E($P(Y,U,4),1,1)          ; SEX
 W ?58,$P(Y1,U,6)                 ; ACCN
 ;
 S IENS=LRIDT_","_LRDFN_","
 S SPEC=$$GET1^DIQ(63.04,IENS,.05)
 W ?74,$E(SPEC,1,12)              ; SPECIMEN
 ;
 S COLDT=$P(Y1,U,1)               ; COLLECTION DATE
 W ?88,$E(COLDT,4,5)_"/"_$E(COLDT,6,7)_"/"_$E(COLDT,2,3)
 ;
 S VERDT=$P(Y1,U,3)               ; VERIFY OR COMPLETE DATE
 W ?98,$E(VERDT,4,5)_"/"_$E(VERDT,6,7)_"/"_$E(VERDT,2,3)
 ;
 S PROV=$$GET1^DIQ(63.04,IENS,.1)
 W ?108,$E(PROV,1,23)             ; PROVIDER
 ;
 W !,?5,$P(Y,U,5)                 ; PHONE
 W ?30,$P(Y,U,6)                  ; STREET
 W ?64,$P(Y,U,7)                  ; CITY
 W ?84,$P(Y,U,8)                  ; STATE
 W ?98,$P(Y,U,9)                  ; ZIP
 W ?108,$E($P(Y1,U,11),1,23)      ; LOCATION
 ;
 W !,?5,"Result: ",$P(Y,U,11)
 ;
 ; start - vjm 4/14/2000
 ;W !?5,"Current COMMUNITY:  ",$G(BLRXCOMM)
 W !?5,"Current COMMUNITY:  "
 W $P(Y,U,10)                     ; CURRENT COMMUNITY
 ; end - vjm 4/14/2000
 ;
 I $Y>MAXPGLEN D FOOTER W @IOF D RHEAD
 ;
 Q
 ;
 ; REPORT HEADING
RHEAD      ;
 W !
 W HEADER1
 W !
 W HEADER2
 W !
 W "From "_PSDT_" to "_PEDT
 W ?53,"****** CONFIDENTIAL ******"
 W ?98,"Printed: "_$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)
 W ?120,"Page: "_PG
 W !!
 W "Name"
 W ?30,"ID#"
 W ?40,"DOB"
 W ?54,"Sex"
 W ?58,"Lab #"
 W ?74,"Sample"
 W ?88,"Col Dt"
 W ?98,"Cpl Dt"
 W ?108,"Provider"
 W !
 W ?5,"Phone #"
 W ?30,"Address"
 W ?108,"Location"
 ;
 ; start - vjm 4/14/2000
 W:$G(BLRGR) !?5,"Current Community"
 ; end - vjm 4/14/2000
 ;
 ; S M=$S($G(IOM):IOM,1:132)
 ; W ! F LI=0:1:M-1 W ?LI,"-"
 W !
 W $TR($J("",IOM)," ","-")        ; Dashed line
 ; W !
 S PG=PG+1
 S FOOTFLG=1
 I $G(BLRTST)'="" D  Q
 . W !,"Reporting Test: "_BLRTST
 ;
 I $G(BRLTST)="" D
 . W !,"Reporting Test: "_$G(^TMP($J,BLRTP))
 ;
 Q
 ;
FOOTER ;
 S PLG=MAXPGLEN-$Y F PP=1:1:PLG W !
 W !,"________________________________________            ______________________"
 W !,"  Medical Technologist                                       Date",!
 Q
 ;
 ; PRESS RETURN CODE
PRESSRTN ; EP
 D ^XBFMK          ; Kernel call cleans up FILEMAN vars
 S DIR(0)="E",(X,Y)=""
 S DIR("A")="Press RETURN to continue"      ; Success or failure is irrelevant.
 D ^DIR                                     ; Used only prior to exit
 Q
