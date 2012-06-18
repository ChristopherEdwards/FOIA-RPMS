BKMSUPP5 ;PRXM/HC/WOM - Continuation of BKMSUPP1, HIV SUPPLEMENT; [ 1/19/2005 7:16 PM ] ; 10 Jun 2005  12:31 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
FLOW(DFN) ;EP - Generate Flow Sheet
 I $Y>(MAXCT-4) S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 W !?1,"HIV FLOW SHEET",!
 N FLTST,FLDT,FLIEN,FLTYP,CNT,LAST,STOP,MAX,MEDNM,MEDDT,DISDT
 K BKMT("FLOW"),BKMT("PRT")
 F FLTST="VL","CD4ABS" S CNT=0 D
 .S FLDT="" F  S FLDT=$O(BKMT(FLTST,FLDT),-1) Q:FLDT=""  D  Q:CNT=6
 ..S FLIEN="" F  S FLIEN=$O(BKMT(FLTST,FLDT,FLIEN)) Q:FLIEN=""  D  Q:CNT=6
 ...S FLTYP="" F  S FLTYP=$O(BKMT(FLTST,FLDT,FLIEN,FLTYP)) Q:FLTYP=""  D  Q:CNT=6
 ....I $P(BKMT(FLTST,FLDT,FLIEN,FLTYP),U)]"" D  ;Only include if results are present
 .....S BKMT("FLOW",FLDT,FLTST,FLIEN,FLTYP)=BKMT(FLTST,FLDT,FLIEN,FLTYP),CNT=CNT+1
 K BKMT("VL"),BKMT("CD4ABS")
 Q:'$D(BKMT("FLOW"))
 ;
 S STOP="" K BKMT("FLOWD")
 ; Only print 6 dates; combine if dates are w/in 7 days
 S LAST=$O(BKMT("FLOW",""),-1),FLDT=LAST,CNT=1,FLDT(LAST)="",BKMT("FLOWD",LAST,LAST)=""
 F  S FLDT=$O(BKMT("FLOW",FLDT),-1) Q:FLDT=""  D  Q:STOP
 . I $$FMDIFF^XLFDT(LAST,FLDT,1)<8 D  Q
 .. M BKMT("FLOW",LAST)=BKMT("FLOW",FLDT) K BKMT("FLOW",FLDT) S BKMT("FLOWD",LAST,FLDT)=""
 . I CNT=6 S STOP=1 Q
 . S LAST=FLDT,FLDT(LAST)="",CNT=CNT+1,BKMT("FLOWD",LAST,LAST)=""
 ;
 ;Reorder array for printing
 S FLDT="",MAX("VL")="",MAX("CD4ABS")=""
 F  S FLDT=$O(BKMT("FLOW",FLDT)) Q:FLDT=""  D
 . S FLTST="" F  S FLTST=$O(BKMT("FLOW",FLDT,FLTST)) Q:FLTST=""  D
 .. S FLIEN=""  F  S FLIEN=$O(BKMT("FLOW",FLDT,FLTST,FLIEN)) Q:FLIEN=""  D
 ... S FLTYP="" F  S FLTYP=$O(BKMT("FLOW",FLDT,FLTST,FLIEN,FLTYP)) Q:FLTYP=""  D
 .... S CNT=$G(BKMT("PRT",FLTST,FLDT))+1,BKMT("PRT",FLTST,FLDT)=CNT
 .... I CNT>MAX(FLTST) S MAX(FLTST)=CNT
 .... S BKMT("PRT",FLTST,FLDT,CNT)=BKMT("FLOW",FLDT,FLTST,FLIEN,FLTYP)
 ;
 ;Print results
 N MEDDYS,FIRST,MEDDSPDT,MEDISSDT
 K BKMT("FLOW")
 S FLDT=""
 F CNT=0:1:5 S FLDT=$O(FLDT(FLDT)) Q:FLDT=""  S FLDT(FLDT)=18+(CNT*10)
 D PRTDT ;Print dates
 W ?1,"Viral Load"
 D PRTFL("VL",MAX("VL")) Q:QUIT
 W !?1,"CD4 Count"
 D PRTFL("CD4ABS",MAX("CD4ABS")) Q:QUIT
 ;Get HAART Medication
 ;Loop through currently active medications
 K BKMT("MED")
 S MEDDT=""
 F  S MEDDT=$O(^TMP("BKMSUPP",$J,"HAART",MEDDT)) Q:MEDDT=""  D
 . S MEDIEN=""
 . F  S MEDIEN=$O(^TMP("BKMSUPP",$J,"HAART",MEDDT,MEDIEN)) Q:MEDIEN=""  D
 .. S MEDDYS=$$GET1^DIQ(9000010.14,MEDIEN,.07,"I") ; Get days prescribed
 .. I MEDDYS="" S MEDDYS=30 ; Using Health Summary logic
 .. Q:'MEDDYS
 .. S MEDDSPDT=$$RX(MEDIEN,MEDDT,101) ; Get last dispensed date
 .. S MEDISSDT=$$RX(MEDIEN,MEDDT,1) ; Get issue date
 .. S MEDNM=$$GET1^DIQ(9000010.14,MEDIEN,.01,"E") ; Get med name
 .. I MEDNM="" S MEDNM="Unknown"
 .. S FLDT=""
 .. F  S FLDT=$O(FLDT(FLDT)) Q:FLDT=""  D
 ... ; If Last Dispensed Date (or Visit Date if no PCC LINK) + DAYS is earlier than the lab date, skip this med
 ... I $$FMADD^XLFDT(MEDDSPDT,MEDDYS)<(FLDT\1) Q
 ... ; Medication must be active prior to the first date of the test
 ... S FIRST=$O(BKMT("FLOWD",FLDT,"")) Q:'FIRST
 ... I MEDISSDT'<(FIRST\1) Q
 ... S BKMT("MED",MEDNM,FLDT)=""
 ;
 ;Loop through inactive medications
 S DISDT=""
 F  S DISDT=$O(BKMT("HAARTD",DISDT)) Q:DISDT=""  D
 . S MEDDT=""
 . F  S MEDDT=$O(BKMT("HAARTD",DISDT,MEDDT)) Q:MEDDT=""  D
 .. S MEDIEN=""
 .. F  S MEDIEN=$O(BKMT("HAARTD",DISDT,MEDDT,MEDIEN)) Q:MEDIEN=""  D
 ... S MEDDYS=$$GET1^DIQ(9000010.14,MEDIEN,.07,"I") ; Get days prescribed
 ... I MEDDYS="" S MEDDYS=30 ; Using Health Summary logic
 ... Q:'MEDDYS
 ... S MEDDSPDT=$$RX(MEDIEN,MEDDT,101) ; Get last dispensed date
 ... S MEDISSDT=$$RX(MEDIEN,MEDDT,1) ; Get issue date
 ... S MEDNM=$$GET1^DIQ(9000010.14,MEDIEN,.01,"E") ; Get med name
 ... I MEDNM="" S MEDNM="Unknown"
 ... S FLDT=""
 ... F  S FLDT=$O(FLDT(FLDT)) Q:FLDT=""  D  ;I DISDT\1>(FLDT\1) D; IHS removed discontinued date check 04/27/06
 .... ; If Last Dispensed Date (or Visit Date if no PCC LINK) + DAYS is earlier than the lab date, skip this med
 .... S FIRST=$O(BKMT("FLOWD",FLDT,"")) Q:'FIRST
 .... I $$FMADD^XLFDT(MEDDSPDT,MEDDYS)<(FIRST\1) Q
 .... ;Medication must be active prior to the first date of the test
 .... I MEDISSDT\1'<(FIRST\1) Q
 .... S BKMT("MED",MEDNM,FLDT)=""
 W !
 ;
 ;Print medications for listed dates
 S MEDNM=""
 F  S MEDNM=$O(BKMT("MED",MEDNM)) Q:MEDNM=""  D  Q:QUIT
 .W !?1,$E(MEDNM,1,16)
 .S MEDDT="" F  S MEDDT=$O(BKMT("MED",MEDNM,MEDDT)) Q:MEDDT=""  D  Q:QUIT
 ..W ?FLDT(MEDDT),"   x"
 .I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW),PRTDT
 Q
RX(MEDIEN,DFLTDT,FLD) ;Get date from prescription file if PCC LINK exists
 ;FLD = field for desired date
 I '$D(^PSRX("APCC",MEDIEN)) Q DFLTDT\1
 N PSRXIEN,PSRXDT
 S PSRXIEN=$O(^PSRX("APCC",MEDIEN,""))
 I PSRXIEN S PSRXDT=$$GET1^DIQ(52,PSRXIEN,FLD,"I") I PSRXDT S DFLTDT=PSRXDT
 Q DFLTDT\1
PRTDT ;Print dates for subheader
 N FIRST
 S FLDT="" F  S FLDT=$O(FLDT(FLDT)) Q:FLDT=""  D
 . S FIRST=$O(BKMT("FLOWD",FLDT,"")) I 'FIRST S FIRST=FLDT
 . W ?FLDT(FLDT),$P($$FMTE^XLFDT(FIRST,"2Z"),"@")
 W !!
 Q
PRTFL(TYPE,MAX) ;
 N LCNT,RESULT
 F LCNT=1:1:MAX D  Q:QUIT  W !
 .S FLDT=""
 .F  S FLDT=$O(FLDT(FLDT)) Q:FLDT=""  D  Q:QUIT
 .. S RESULT=$E($G(BKMT("PRT",TYPE,FLDT,LCNT)),1,8)
 .. W ?FLDT(FLDT),$E("       ",1,8-$L(RESULT)\2),RESULT
 .. I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW),PRTDT
 Q
REM(DFN) ;EP - List Reminders
 I IOST["C-" W !!?1,"Calculating HIV-RELATED REMINDERS - Please wait."
 W !!?1,"HIV-RELATED REMINDERS: ",!
 N PRT,A1,B1,DUE,OVERDUE,REMTXT
 K LIST D REMIND^BKMVF3(DFN,NOW,.LIST)
 I $Y>(MAXCT-1) S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 I $O(LIST("")) D  Q:QUIT
 .W !?1,"Reminder",?26,"Last",?41,"Due",!
 . S A1="" F  S A1=$O(LIST(A1)) Q:A1=""  D  Q:QUIT
 .. S B1="" F  S B1=$O(LIST(A1,B1)) Q:B1=""  D  Q:QUIT
 ... S DUE=$G(LIST(A1,B1,"DUE")) ;S:DUE="" DUE="Unknown" this is not on the Clinical Rem, they must be the same
 ... I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 ... I 'DUE,'$G(LIST(A1,B1,"LAST")) Q
 ... S REMTXT=$G(LIST(A1,B1,0))
 ... S OVERDUE=0
 ... I DUE'="" S:DUE<DT OVERDUE=1 S DUE=$P($$FMTE^XLFDT(+DUE,"5Z"),"@",1)
 ... I OVERDUE=0,$G(LIST(A1,B1,"LAST"))="" S DUE="("_DUE_")"
 ... I OVERDUE=1 S DUE="May Be Due Now (Was due "_DUE_")"
 ... W ?1,$E(REMTXT,1,25)
 ... W ?26,$P($$FMTE^XLFDT($G(LIST(A1,B1,"LAST")),"5Z"),"@")
 ... I $G(LIST(A1,B1,"LASTTXT"))]"" W LIST(A1,B1,"LASTTXT")
 ... W ?42,DUE,!
 ... I REMTXT["Viral Load"!(REMTXT["Trichomoniasis Test")!(REMTXT["Tetanus IZ")!(REMTXT["Dental Exam") W !
 ... I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 K LIST Q:QUIT
 I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW) Q
 W !!
 Q
XIT ;QUIT POINT
 Q
