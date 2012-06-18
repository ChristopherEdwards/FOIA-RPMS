BLRSHDRC ; IHS/OIT/MKK - NON MICRO STATE HEALTH DEPT REPORT MAIN [ 07/22/2005 ]
 ;;5.2;LR;**1020,1022**;September 20, 2007
 ;;
 ; Lab PSG gave permission to retrieve programs from PIMC and distribute
 ; nationally.  The original routines at PIMC are BZXLRSER and BZXLRSEP.
 ; 
 ; Note that ^BLRSHDRD is the new global name for the new dictionary that
 ; this routine depends upon:  REPORTABLE LAB TESTS (# 90475)
 ; It has been distributed with this patch and number given to it by
 ; the IHS DBA.
 ; 
 ; This is the driver and compiler of data.
 ; It calls BLRSHDRP as the routine to do the actual printing
 ;
 ; The following is code to prevent routine from being run by D ^BLRLRSER.
EP ;
 W !,$C(7),$C(7),$C(7),!          ; Bell/Beep
 W "Run from Label ONLY",!!       ; Failsafe code
 Q
 ;
PEP      ; EP -- Private
 NEW HEADER1,HEADER2,HEADERS
 NEW STR,SITENAME,SITEADDR,SITECITY,SITESTPT,SITESTAB,SITESTNM,SITEZIP
 ;
 I $G(IOM)="" D HOME^%ZIS         ; If no IOM, then setup Interactive IO vars
 ;
 K ^TMP($J)                       ; Clean up
 ;
 D GETSITE                        ; Get site information
 ;
 D ^XBCLS                         ; Clear screen and home cursor
 D EN^DDIOL(.HEADERS)             ; Write the Screen Header Lines
 ;
 D ^XBFMK                         ; Clear FileMan variables
 S DIR("A")="Enter start date"
 S DIR(0)="D^::EPX"
 D ^DIR
 I $D(DIRUT) D  Q                 ; If ^, or RETURN, or timed out, Quit
 . K DIR,DIRUT,DTOUT,DUOUT
 ;
 S BLRSDT=Y                       ; Start Date
 S BLRVDT=Y-.5                    ; Trick for $Order function -- see LP label
 ;
GETEND ;
 S DIR("A")="Enter end date"
 S DIR(0)="D^::EPX"
 D ^DIR
 I $D(DIRUT) D  Q
 . K DIR,DIRUT,DTOUT,DUOUT,BLRSDT,BLRVDT
 S BLRENDT=Y
 I BLRENDT<BLRVDT D  G GETEND
 . W !,"End date cannot be before start date.  Try again."
 ;
 D ^XBCLS
 D EN^DDIOL(.HEADERS)
 D WAIT^DICD                      ; Wait Message
 ;
LP ;Start looping through tests
 ; BLRVDT is both the verification date and the order date
 ; In effect we only look at the verification date
 NEW TMPIT              ; Temp variable -- Discar
 ; 
 F  S BLRVDT=$O(^LRO(69,BLRVDT)) Q:'BLRVDT!(BLRVDT>BLRENDT)  D
 .S LOC=""
 .F  S LOC=$O(^LRO(69,BLRVDT,1,"AN",LOC)) Q:LOC=""  D
 ..S LRDFN=""
 ..F  S LRDFN=$O(^LRO(69,BLRVDT,1,"AN",LOC,LRDFN)) Q:'LRDFN  D
 ...S LRIDT=9999999-BLRVDT-.5              ; Create Inverse Date
 ...;
 ...S X=$$FMADD^XLFDT(BLRVDT,-545)         ; Subtracts 545 days from BLRVDT
 ...S LRIDTLM=9999999-X                    ; Sets Minimum "Inverse Date"
 ...F  S LRIDT=$O(^LRO(69,BLRVDT,1,"AN",LOC,LRDFN,LRIDT)) Q:'LRIDT!(LRIDT>LRIDTLM)  D
 ....Q:'$D(^LR(LRDFN,"CH",LRIDT,0))        ; Quit if no CH data
 ....;
 ....; S X=$P(^LR(LRDFN,"CH",LRIDT,0),U,3)\1  ; Date Report Completed
 ....; ----- BEGIN IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 ....S X=$P($G(^LR(LRDFN,"CH",LRIDT,0)),U,3)\1  ; Date Report Completed
 ....; ----- END IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 ....Q:X'=BLRVDT                            ; Quit if no Report Comp Date
 ....;
 ....S D0=0
 ....F  S D0=$O(^BLRSHDRD(D0)) Q:'D0  D
 .....S BLRTPTR=$P($G(^BLRSHDRD(D0,0)),U,1)
 .....S BLRTYPE=""
 .....I $P($G(^LAB(60,BLRTPTR,0)),U,12)'="" D
 ......S TMPIT=U_$P($G(^LAB(60,BLRTPTR,0)),U,12)_"0)"
 ......I $D(@TMPIT)<1 Q
 ......S BLRTYPE=$P(@(U_$P($G(^LAB(60,BLRTPTR,0)),U,12)_"0)"),U,2)
 .....I $G(BLRTYPE)="" Q                    ; Quit if no data type for test
 .....;
 .....S BLRDLOC=$P($G(^LAB(60,BLRTPTR,0)),U,5)
 .....I $G(BLRDLOC)="" Q                    ; Quit f no Location
 .....;
 .....; S ^BLRDEBUG(LRDFN,LRIDT,D0,"BLRTYPE")=BLRTYPE
 .....; S ^BLRDEBUG(LRDFN,LRIDT,D0,"BLRDLOC")=BLRDLOC
 .....;
 .....Q:'$D(^LR(LRDFN,"CH",LRIDT,$P(BLRDLOC,";",2)))  ; Quit if not CH
 .....; 
 .....; S BLRRES=$P(^LR(LRDFN,"CH",LRIDT,$P(BLRDLOC,";",2)),U,1)
 .....; S BLRFLD=$P(^LAB(60,BLRTPTR,0),U,12)
 .....; ----- BEGIN IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 ..... S BLRRES=$P($G(^LR(LRDFN,"CH",LRIDT,$P(BLRDLOC,";",2))),U,1)
 ..... S BLRFLD=$P($G(^LAB(60,BLRTPTR,0)),U,12)
 .....; ----- END IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 .....S BLRRAWRS=BLRRES
 .....;
 .....S TRANS=$G(^BLRSHDRD(D0,2))
 .....I $L(TRANS) D                         ; If Transform code, execute it
 ......S Y=BLRRES
 ......K X
 ......X TRANS
 ......Q:'$D(X)
 ......S BLRRES=X
 .....;
 .....I $E(BLRTYPE,1)="N" D  Q              ; Numeric Data Type
 ......S COND=$P($G(^BLRSHDRD(D0,0)),U,4)
 ......S COND=$S(COND=2:"[",COND=4:"<",COND=5:"=",COND=6:">",1:"")
 ......I $G(COND)="" Q
 ......S VALUE=$P($G(^BLRSHDRD(D0,0)),U,3)
 ......I $E(BLRRES,1)=">" S BLRRES=$P(BLRRES,">",2)+1
 ......S BLRRES=+BLRRES
 ......I @(BLRRES_COND_VALUE) D STORE
 .....;
 .....I $E(BLRTYPE,1)="S" D  Q              ; Set Data Type
 ......;What the values stand for in the set
 ......S BLRSTNFR=$P(@(U_BLRFLD_"0)"),U,3)
 ......F I=1:1 S Y=$P(BLRSTNFR,";",I) Q:Y=""  D
 .......I $P(Y,":",1)=BLRRAWRS D
 ........ I $L($P(Y,":",1))>$L(BLRRAWRS) S BLRRAWRS=$P(Y,":",1) Q
 ........ I $L($P(Y,":",2))>$L(BLRRAWRS) S BLRRAWRS=$P(Y,":",2)
 .......I $P(Y,":",2)=BLRRAWRS D
 ........ I $L($P(Y,":",1))>$L(BLRRAWRS) S BLRRAWRS=$P(Y,":",1) Q
 ........ I $L($P(Y,":",2))>$L(BLRRAWRS) S BLRRAWRS=$P(Y,":",2)
 ......S D1=0
 ......F  S D1=$O(^BLRSHDRD(D0,1,D1)) Q:'D1  D
 .......S VALUE=$P($G(^BLRSHDRD(D0,1,D1,0)),U,1)
 .......I BLRRES=VALUE D STORE
 .....;
 .....I $E(BLRTYPE,1)="F" D                 ; Free Text Data Type
 ......I BLRRES'=+BLRRES S BLRRES=""""_BLRRES_""""
 ......S D1=0
 ......F  S D1=$O(^BLRSHDRD(D0,4,D1)) Q:'D1  D
 .......S COND=$P($G(^BLRSHDRD(D0,4,D1,0)),U,2)
 .......S COND=$S(COND=2:"[",COND=4:"<",COND=5:"=",COND=6:">",1:"")
 .......I $G(COND)="" Q
 .......; S COND=$S(COND="C":"[",1:"=")
 .......S VALUE=$P($G(^BLRSHDRD(D0,4,D1,0)),U,1)
 .......I VALUE'=+VALUE S VALUE=""""_VALUE_""""
 .......I @(BLRRES_COND_VALUE) D STORE
 ;
 D PEP^BLRSHDRP    ; Print data collected
 ;
 ; D ^XBCLS
 D EN^DDIOL(.HEADERS)
 I +$G(PG)>0 W !!!,"Number of pages printed = ",PG-1,!
 I '$D(IO("Q")) D PRESSRTN^BLRSHDRP    ; Press RETURN
 ;
 K ^TMP($J)                       ; Clean up
 ;
 D ^XBCLS
 ;
 Q
 ;
STORE ;Store data for printing
 K BLRCOMM,BLRCMIN
 ; S BLRFILE=$P(^LR(LRDFN,0),U,2)
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 S BLRFILE=$P($G(^LR(LRDFN,0)),U,2)
 ; ----- END IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 S DFN=$P(^LR(LRDFN,0),U,3)
 ; S PATNAM=$S(BLRFILE=2:$P($G(^DPT(DFN,0)),U,1),BLRFILE=67:"*"_$P(^LRT(67,DFN,0),U,1),1:"UNK")
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 S PATNAM=$S(BLRFILE=2:$P($G(^DPT(DFN,0)),U,1),BLRFILE=67:"*"_$P($G(^LRT(67,DFN,0)),U,1),1:"UNK")
 ; ----- END IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 S IENS=DFN_","
 S SEX=$$GET1^DIQ(BLRFILE,IENS,.02)
 S DOB=$$GET1^DIQ(BLRFILE,IENS,.03)
 Q:BLRFILE=67.3
 I BLRFILE=67 D
 . ;S ID=$P(^LRT(67,DFN,0),U,9)
 . ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 . S ID=$P($G(^LRT(67,DFN,0)),U,9)
 . ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 .S (STREET,CITY,STATE,ZIP,PHONE,BLRCOMM,BLRCMIN)=""
 E  I BLRFILE=2 D
 .S ID=$$HRN^AUPNPAT(DFN,DUZ(2))
 . ; S Y=^DPT(DFN,.11)
 . ;----- BEGIN IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 . S Y=$G(^DPT(DFN,.11))
 . ;----- END IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 .S STREET=$P(Y,U,1)
 .S CITY=$P(Y,U,4)
 .S ZIP=$P(Y,U,6)
 .S IENS=DFN_","
 .S STATE=$$GET1^DIQ(2,IENS,.115)
 .S PHONE=$$GET1^DIQ(2,IENS,.131)
 .S BLRCOMM=$$COMMRES^AUPNPAT(DFN,"E")
 .S BLRCMIN=$$COMMRES^AUPNPAT(DFN,"I")
 .I 'BLRCMIN D
 ..; S BLRXCOMM=$P(^AUPNPAT(DFN,11),U,18)
 ..; ----- BEGIN IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 .. S BLRXCOMM=$P($G(^AUPNPAT(DFN,11)),U,18)
 ..; ----- BEGIN IHS/OIT/MKK - LR*5.2*1022 - Naked reference correction
 ..Q:BLRCOMM=""
 ..S BLRCMIN=$O(^AUTTCOM("B",BLRCOMM,""))
 I BLRCMIN,$D(BLRGR),'$D(^BLRGRHR("B",BLRCMIN)) Q
 I $D(BLRGR),'BLRCMIN Q
 S ^TMP($J,D0)=$P($G(^BLRSHDRD(D0,0)),U,2)      ; Reporting Test
 I $G(^TMP($J,D0))="" S ^TMP($J,D0)=$P($G(^LAB(60,BLRTPTR,0)),U,1)
 S ^TMP($J,D0,LRDFN,LRIDT)=PATNAM_U_ID_U_DOB_U_SEX_U_PHONE_U_STREET_U_CITY_U_STATE_U_ZIP_U_BLRCOMM_U_BLRRAWRS
 Q
 ;
 ; NOTE: The variables HEADER1 & HEADER2 hold the "header" information for the
 ;       report, which must be 132 columns wide.  That is why the Right Margin
 ;       is hard-coded to 132 for those 2 variables.
GETSITE      ;
 ;
 D MAKESITE                       ; Get Site parameters
 ;
 D MAKEHDRS                       ; Create Header Strings
 ;
 Q
MAKEHDRS ; EP
 ;
 S STR=$$CJ^XLFSTR(SITENAME,132)
 S $E(STR,1,28)=SITESTAB_" HEALTH DEPARTMENT REPORT"
 S HEADER1=STR                    ; HEADER LINE 1
 ;
 S HEADER2=$$CJ^XLFSTR(SITEADDR_", "_SITECITY_", "_SITESTAB_" "_SITEZIP,132)
 I $TR($TR(HEADER2,",")," ")="" S HEADER2=""     ; If nothing, set to null
 ;
 ; Screen Header
 NEW TMPLN                        ; Temporary Line
 ;
 S TMPLN=$$CJ^XLFSTR(SITENAME,IOM)
 S $E(TMPLN,1,13)="Date:"_$$NUMDATE^BLRUTIL($$DT^XLFDT())             ; Today's Date
 S $E(TMPLN,IOM-16)=$J("Time:"_$$NUMTIME^BLRUTIL($$NOW^XLFDT()),16)   ; Current Time
 S TMPLN=$$TRIM^XLFSTR(TMPLN,"R"," ")                 ; Trim extra spaces
 S HEADERS(1)=TMPLN
 ;
 S BLRVERN="1.01.02"              ; Version number
 S TMPLN=$$CJ^XLFSTR(SITESTAB_" Health Department Report",IOM)    ; Center Header Line 2
 S $E(TMPLN,IOM-11)=$J(BLRVERN,11)     ; Version Number
 S TMPLN=$$TRIM^XLFSTR(TMPLN,"R"," ")  ; Trim extra spaces
 S HEADERS(2)=TMPLN
 ;
 S HEADERS(3)=$TR($J("",IOM-1)," ","-")     ; Dashed line
 S HEADERS(4)=" "                           ; Blank line
 ;
 Q
 ;
MAKESITE ;
 W !!!
 D ^XBFMK
 D GETDUZS
 ;
 S DIR("A")="Use Site "_SITENAME_" as Report Header"
 S DIR("B")="YES"
 S DIR(0)="Y"
 D ^DIR
 I X["Y" Q                        ; Accepted Default
 ;
 ; Did NOT accept default.  Get Institution
 D ^XBFMK
 S DIC=4
 S DIC(0)="ACEIKNQTZ"
 S DIC("B")=SITENAME
 D ^DIC
 I $D(DIRUT) D  Q                 ; If ^, or RETURN, or timed out, Quit
 . K DIR,DIRUT,DTOUT,DUOUT
 . D SETHDRVS($G(DUZ(2)))         ; Something has to be there
 ;
 D SETHDRVS(+Y)
 ;
 Q
 ;
 ; Get Site Name/Address using DUZ(2)
GETDUZS ;
 D SETHDRVS($G(DUZ(2)))           ; Set HeaDeR VariableS
 ;
 S DIR("A",1)="Default Site/Address for Report:"
 S DIR("A",2)=" "
 S DIR("A",3)="     "_SITENAME
 S DIR("A",4)="     "_SITEADDR
 S DIR("A",5)="     "_SITECITY_", "_SITESTAB_" "_SITEZIP
 S DIR("A",6)=" "
 ;
 Q
 ;
 ; SET HeaDeR VariableS -- use ONLY values in dictionaries.
 ; NO FREE TEXT.
SETHDRVS(DIC4PTR)      ; EP
 S SITENAME=$$GET1^DIQ(4,DIC4PTR_",","NAME")
 ;
 S SITESTAB=$$GET1^DIQ(4,DIC4PTR_",","STATE:ABBREVIATION")
 S SITESTNM=$$GET1^DIQ(4,DIC4PTR_",","STATE:NAME")
 ;
 S SITEADDR=$$GET1^DIQ(4,DIC4PTR_",","STREET ADDR. 1")
 S STR=$$GET1^DIQ(4,DIC4PTR_",","STREET ADDR. 2")
 I $G(STR)'="" S SITEADDR=SITEADDR_" "_STR
 ;
 S SITECITY=$$GET1^DIQ(4,DIC4PTR_",","CITY")
 S SITEZIP=$$GET1^DIQ(4,DIC4PTR_",","ZIP")
 ;
 S ^TMP($J,"DIC4PTR")=DIC4PTR
 Q
