BIPATVW ;IHS/CMI/MWR - VIEW PATIENT IMM DATA; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW PATIENT'S IMMUNIZATION DATA AND ALLOW EDITS
 ;;  THROUGH LISTMANAGER.
 ;
 ;
 ;----------
START ;EP
 ;---> Lookup patients, view and edit their Immunization data.
 ;
 D SETVARS^BIUTL5 N BIDFN,BIFDT,BIPOP,BIRTN
 F  D  Q:$G(BIDFN)<1
 .D TITLE^BIUTL5("VIEW PATIENT IMMUNIZATION DATA")
 .D PATLKUP^BIUTL8(.BIDFN,$S($$MAYEDIT^BIUTL11:"ADD",1:""),DUZ(2),.BIPOP)
 .Q:$G(BIPOP)  Q:$G(BIDFN)<1
 .D DATE(.BIFDT,.BIPOP)
 .Q:BIPOP
 .D EN(BIDFN,$$MAYEDIT^BIUTL11,BIFDT,DUZ(2))
 .D UNLOCK($G(BIDFN))
 D EXIT
 Q
 ;
 ;
 ;----------
ONEPAT ;EP
 ;---> Lookup patients, view and edit their Immunization data.
 ;
 D SETVARS^BIUTL5 N BIDFN,BIFDT,BIPOP,BIRTN
 D
 .D PATLKUP^BIUTL8(.BIDFN,$S($$MAYEDIT^BIUTL11:"ADD",1:""),DUZ(2),.BIPOP)
 .Q:$G(BIPOP)  Q:$G(BIDFN)<1
 .D DATE(.BIFDT,.BIPOP)
 .Q:BIPOP
 .D EN(BIDFN,$$MAYEDIT^BIUTL11,BIFDT,DUZ(2))
 .D UNLOCK($G(BIDFN))
 D EXIT
 Q
 ;
 ;
 ;----------
HAVEPAT(BIDFN,BIFDT,BIPRT,BIPOP) ;EP
 ;---> Entry point when patient is already known.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIFDT  (opt) Forecast Date (date used for forecast).
 ;     3 - BIPRT  (opt) If BIPRT=1 this call is to print.
 ;     4 - BIPOP  (ret) BIPOP=1 If quit, fail, DTOUT, DUOUT.
 ;
 D SETVARS^BIUTL5 S BIPOP=0 N BIN ;(Preserve BIN from calls above.)
 I '$G(BIDFN)  D ERRCD^BIUTL2(201,,1) S BIPOP=1 Q
 I '$D(^AUPNPAT(BIDFN)) D ERRCD^BIUTL2(203,,1) S BIPOP=1 Q
 K ^BITMP($J),^TMP("BILMVW",$J)
 S ^BITMP($J,1,BIDFN)=""
 D:'$G(BIFDT) DATE(.BIFDT,.BIPOP)
 Q:BIPOP
 D EN(BIDFN,$S($G(BIPRT):2,1:$$MAYEDIT^BIUTL11),$G(BIFDT),DUZ(2))
 Q
 ;
 ;
 ;----------
EN(BIDFN,BIEDIT,BIFDT,BIDUZ2) ;EP
 ;---> Main entry point to call Lists: BI PATIENT DATA VIEW/EDIT
 ;---> and BI PATIENT VIEW ONLY.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIEDIT (opt) Null or 0=View only; 1=View/Edit, 2=Print.
 ;     3 - BIFDT  (opt) Forecast Date (date used for forecast).
 ;     4 - BIDUZ2 (req) User's DUZ(2) for BISITE parameters,
 ;                      which affect forecasting rules.
 ;
 I '$G(BIDFN) D ERRCD^BIUTL2(201,,1) Q
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 I '$G(BIDUZ2) D ERRCD^BIUTL2(105,,1) Q
 ;
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> BIHX contains the patient's Immunization History and is
 ;---> used by various protocols and actions in Listmanager.
 N BIHX,DFN S DFN=BIDFN  ;For now with Linda's view reg templates.
 ;
 ;---> Print Patient Data and quit.
 ;---> (Called by Protocol BI PATIENT VIEW PRINT.)
 I $G(BIEDIT)=2 D PRINT Q
 ;
 ;---> Select List Template to View/Edit or View Only.
 S BILIST="BI PATIENT DATA VIEW"_$S($G(BIEDIT)=1:"/EDIT",1:" ONLY")
 I '$D(^SD(409.61,"B",BILIST)) D ERRCD^BIUTL2(628,,1) Q
 D EN^VALM(BILIST)
 Q
 ;
 ;
 ;----------
PRINT ;EP
 ;---> Print Patient Data screen.
 ;---> Called by Protocol BI PATIENT VIEW PRINT, which is the
 ;---> Print List Protocol for Lists: BI PATIENT DATA VIEW/EDIT and
 ;---> BI PATIENT DATA VIEW ONLY.
 ;
 D DEVICE(.BIPOP)
 I $G(BIPOP) D RESET Q
 ;
 D HDR(1),MAIN^BIPATVW1(1)
 D PRTLST^BIUTL8("BILMVW")
 D RESET
 Q
 ;
 ;
 ;----------
HDR(BIPRT) ;EP
 ;---> Header code for both Listman Screen and Print List.
 ;---> Parameters:
 ;     1 - BIPRT  (opt) If BIPRT=1 array is for print: Add Privacy Act
 ;                      line and Site Header line.
 ;
 N BILINE,X,Y S BILINE=0 K VALMHDR
 N BICRT S BICRT=$S(($E($G(IOST))="C")!(IOST["BROWSER"):1,1:0)
 ;
 D WH^BIW(.BILINE)
 ;
 D:$G(BIPRT)
 .S X="WARNING: Confidential Patient Information, Privacy Act applies."
 .D WH^BIW(.BILINE,"   "_X,1)
 .;
 .S X=$$REPHDR^BIUTL6(DUZ(2)),BIDASH=$L(X)+2 D CENTERT^BIUTL5(.X)
 .D WH^BIW(.BILINE,X)
 .S X=$$SP^BIUTL5(BIDASH,"-") D CENTERT^BIUTL5(.X)
 .D WH^BIW(.BILINE,X,1)
 ;
 S Y=$E($$NAME^BIUTL1(BIDFN),1,25)
 S X=" Patient: "
 S:BICRT X=X_IORVON
 S X=X_Y
 S:BICRT X=X_IOINORM
 S X=X_$$SP^BIUTL5(27-$L(Y))_"DOB: "
 S:BICRT X=X_IORVON
 S X=X_$$DOBF^BIUTL1(BIDFN,$G(BIFDT))
 S:BICRT X=X_IOINORM
 D WH^BIW(.BILINE,X)
 S X="  Chart#: "
 S:BICRT X=X_IORVON
 S X=X_$$HRCN^BIUTL1(BIDFN)
 S Y=$E($$INSTTX^BIUTL6($G(DUZ(2))),1,17)
 S X=X_" at "_Y
 S:BICRT X=X_IOINORM
 S X=X_$$SP^BIUTL5(49-$L(X))_$$ACTIVE^BIUTL1(BIDFN)
 S X=X_"   "_$$SEXW^BIUTL1(BIDFN)
 D:$D(^BIP(BIDFN,0))
 .S X=X_"    "_"M HBsAg: "_$E($$MOTHER^BIUTL11(BIDFN,1),1,3)
 D WH^BIW(.BILINE,X,1)
 D:$G(BIPRT)
 .S X="  #  Immunization History                  |   Immunizations DUE"
 .S:$G(BIFDT) X=X_" on "_$$SLDT2^BIUTL5(BIFDT)
 .D WH^BIW(.BILINE,X)
 ;
 ;---> Set Screen Title.
 S VALM("TITLE")="PATIENT VIEW (IMM v"_$$VER^BILOGO_")"
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 D MAIN^BIPATVW1()
 S BIRTN="BIPATVW"
 Q
 ;
 ;
 ;----------
DATE(BIFDT,BIPOP) ;EP
 ;---> Ask Forecast Date.
 ;---> Parameters:
 ;     1 - BIFDT (ret) Forecast Date, Fileman format.
 ;               (opt) Default Date.
 ;     2 - BIPOP (ret) BIPOP=1 If quit, fail, DTOUT, DUOUT.
 ;
 N BIDFLT,DIR
DATE1 ;EP
 S BIPOP=0
 S:$G(BIFDT)="" BIFDT=DT
 S BIDFLT=$$TXDT^BIUTL5(BIFDT)
 D HELP1
 S DIR(0)="DA^::EX"
 S DIR("A")="  Select Forecast Date: ",DIR("B")=BIDFLT
 D ^DIR W !
 I $D(DIRUT) S BIPOP=1 Q
 S BIFDT=$P(Y,".")
 I BIFDT<$$DOB^BIUTL1(BIDFN) D  G DATE1
 .W !?5,"Date must be after patient's date of birth."
 .K BIFDT D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;;The "Forecast" is a list of immunizations that a patient is due
 ;;to receive.
 ;;
 ;;You may view the immunizations that this patient WOULD BE due for
 ;;on a date other than today (past or future).
 D HELPTX("HELP1")
 Q
 ;
 ;
 ;----------
HELPTX(BILINL,BITAB) ;EP
 N I,T,X S T=""  S:'$D(BITAB) BITAB=5  F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR() Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D EN^XBNEW("HELP^BIPATVW3","VALM*;IO*")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> EOJ Cleanup.
 D KILLALL^BIUTL8(1)
 K ^TMP("BILMVW",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
 ;
 ;----------
DEVICE(BIPOP) ;EP
 ;---> Get Device and possibly queue to Taskman.
 ;---> Parameters:
 ;     1 - BIPOP (ret) If error or Queue, BIPOP=1
 ;
 K %ZIS,IOP S BIPOP=0
 S ZTRTN="DEQUEUE^BIPATVW"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Print Patient Data screen.
 D HDR(1),MAIN^BIPATVW1(1)
 D PRTLST^BIUTL8("BILMVW"),EXIT
 Q
 ;
 ;
 ;----------
UNLOCK(BIDFN) ;EP
 ;---> Unlock BI PATIENT global for this patient.
 ;---> Parameters:
 ;     1 - BIDFN (req) Patient DFN to unlock.
 ;
 Q:'$G(BIDFN)
 N I F I=1:1:5  L -^BIP(BIDFN)
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
