INHUTC52 ;DGH Search using VA list manager 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;
 ;
EN(INSRCH) ; -- option entry point
 K XQORS,VALMEVL
 ;If the array exists, call the protocol that allows selection
 I INSRCH("TYPE")="TRANSACTION",$G(INOPT("ARRAY"))["INREQLST" D EN^VALM("INH TRANSACTION SELECT") Q
 I INSRCH("TYPE")="TRANSACTION" D EN^VALM("INH TRANSACTION SEARCH") Q
 I INSRCH("TYPE")="ERROR" D EN^VALM("INH ERROR SEARCH")
 Q
 ;
 ;
FIND ;Entry point called from within VA List Manager
 ;Stack VALM variables, then call existing GIS search point.
 N VALMX,VALMCNTI
 S (VALMCNT,VALMCNTI)=0
 D CLEAN^VALM10
 D FIND^INHUTC5(.INQUIT,.INOPT,"",.INSRCH)
 Q
 ;
SETTMP(INIEN,INSRCH) ;Set ^TMP global for records that match selection crit.
 ;called from FIND^INHUTC5
 ;VALM function seems to require that VALMCNT be the counter
 ;It is incremented in the calling routine
 N INDEST,INDSTNUM,INTR,INTRN,INX,INSTAT,INLOC,INWID
 S VALMCNT=INSRCH("INFNDCT")
 I INSRCH("TYPE")="TRANSACTION" D
 .S VALMX=^INTHU(INIEN,0)
 .S VALMCNTI=VALMCNTI+1
 .S X=$$SETFLD^VALM1(VALMCNTI,"","NUMBER")
 .S X=$$SETFLD^VALM1($TR($$CDATASC^%ZTFDT($P(VALMX,U),1,2),":"),X,"DATE/TIME")
 .S X=$$SETFLD^VALM1($P(VALMX,U,5),X,"MESSAGE ID")
 .S INDSTNUM=+$P(VALMX,U,2),INDEST=$S(INDSTNUM:$P($G(^INRHD(INDSTNUM,0)),U),1:""),X=$$SETFLD^VALM1(INDEST,X,"DESTINATION")
 .Q  ;Don't do expanded display now
 .;patient
 .S INTMP=$$INMSPAT^INHMS1(INIEN,"",.INPATNAM)
 .S X=$$SETFLD^VALM1(INPATNAM,X,"PATIENT")
 .;Transaction
 .S INTRN=+$P(VALMX,U,11),INTR=$S(INTRN:$P($G(^INRHT(INTRN,0)),U),1:""),X=$$SETFLD^VALM1(INTR,X,"TRANSACTION")
 I INSRCH("TYPE")="ERROR" D
 .S VALMX=^INTHER(INIEN,0)
 .S VALMCNTI=VALMCNTI+1
 .S X=$$SETFLD^VALM1(VALMCNTI,"","NUMBER")
 .S X=$$SETFLD^VALM1($TR($$CDATASC^%ZTFDT($P(VALMX,U),1,2),":"),X,"DATE/TIME")
 .S INSTAT=$P(VALMX,U,10)
 .S INSTAT=$S($L(INSTAT):INSRCH("INETBL",+INSTAT),1:"none")
 .S X=$$SETFLD^VALM1(INSTAT,X,"STATUS")
 .S INLOC=$S(+$P(VALMX,U,5):+$P(VALMX,U,5),1:"none")
 .S:+INLOC INLOC=$P($G(^INTHERL(INLOC,0)),U)
 .S X=$$SETFLD^VALM1(INLOC,X,"LOCATION")
 ;Width needs to be variable if called from different screens with
 ;differing total widths. Set at 79 for now
 S INWID=77
 K Z S $P(Z,$E(VALMCNTI),INWID)=""
 D SET^VALM10(VALMCNT,$E(X_Z,1,INWID),VALMCNTI) ; set text
 S ^TMP("INSRCH",$J,VALMCNTI)=VALMCNT_U_INIEN
 D:'(VALMCNT#9) FLDCTRL^VALM10(VALMCNT)     ; defaults for all fields
 D FLDCTRL^VALM10(VALMCNT,"NUMBER")       ; default for 1 field
 ;D:'(VALMCNT#5) FLDCTRL^VALM10(VALMCNT,"NAME",IOUON,IOUOFF) ; adhoc
 D:'(VALMCNT#5) FLDCTRL^VALM10(VALMCNT,"DATE/TIME",IOUON,IOUOFF) ;adhoc
 D NUL:'VALMCNT
 Q
 ;
HDR ; -- header
 ;N VALMX
 ;S VALMX=$G(^DIC(9.4,VALMPKG,0)),X="    Package: "_$P(VALMX,U)
 ;S VALMHDR(1)=$$SETSTR^VALM1("Prefix: "_$P(VALMX,U,2),X,63,15)
 ;S VALMHDR(2)="Description: "_$E($P(VALMX,U,3),1,65)
 N MSG S MSG="Interface "_$S(INSRCH("TYPE")="ERROR":"Error",1:"Transaction")_" Search"
 S X="",VALMHDR(1)=$$SETSTR^VALM1(MSG,X,26,29) Q
 ;
NUL ; -- set nul message
 I 'VALMCNT D
 .F X=" ","    No matching records." S VALMCNT=VALMCNT+1 D SET^VALM10(VALMCNT,X)
 .S ^TMP("INSRCH",$J,1)=1,^(2)=2
 Q
 ;
FNL ; -- clean up
 K DIE,DIC,DR,DA,DE,DQ,VALMY,VALMPKG,^TMP("INSRCH",$J)
 D CLEAN^VALM10
 Q
 ;
EXP ; -- expand action
 D FULL^VALM1
 N VALMI,VALMAT,VALMY
 D EN^VALM2(XQORNOD(0),"O") S VALMI=0
 F  S VALMI=$O(VALMY(VALMI)) Q:'VALMI  D
 .S VALMAT=$G(^TMP("INSRCH",$J,VALMI))
 .W !!,@VALMAR@(+VALMAT,0),!
 .I INSRCH("TYPE")="TRANSACTION" S DIC="^INTHU(",DR="0;1;3"
 .I INSRCH("TYPE")="ERROR" S DIC="^INTHER(",DR="0;1;2"
 .S DA=+$P(VALMAT,U,2) D EN^DIQ,PAUSE^VALM1
 S VALMBCK="R",VALMSG="'Expand' was last action picked."
 Q
 ;
SEL ; Set selected item into array
 ;I $G(INOPT("ARRAY"))'["INREQLST" D EXP S VALMSG="'Select' was last action picked." Q
 N VALMI,VALMAT,VALMY,INNUM
 D EN^VALM2(XQORNOD(0),"O") S VALMI=0
 F  S VALMI=$O(VALMY(VALMI)) Q:'VALMI  D
 .S VALMAT=$G(^TMP("INSRCH",$J,VALMI))
 .W !!,@VALMAR@(+VALMAT,0),!
 .S INNUM=+VALMAT,DA=+$P(VALMAT,U,2)
 .;ARRAY will be set for MTC and REQUEUE functions
 .I $G(INOPT("ARRAY"))["INREQLST" D  Q
 ..;CHCS listman returns array in DWLMK. GIS expects this
 ..S DWLMK(INNUM)=""
 ..;CHCS listman has @DWLRF array that must be populated.
 ..;It is usually INL 
 ..S:'$D(DWLRF) DWLRF="INL"
 ..S @DWLRF@(INNUM)="",@DWLRF@(INNUM,0)=DA
 ..S VALMSG=$P($G(^INTHU(DA,0)),U,5)_" selected for processing."
 ;
 S VALMBCK="R"
 Q
 ;
UPD(TEXT,FLD,VALMAT) ; -- update data for screen
 D:VALMCC FLDCTRL^VALM10(+VALMAT,.FLD,.IOINHI,.IOINORM,1)
 D FLDTEXT^VALM10(+VALMAT,.FLD,.TEXT)
 Q
 ;
 ;
