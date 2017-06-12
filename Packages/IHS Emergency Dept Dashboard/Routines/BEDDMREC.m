BEDDMREC ;VNGT/HS/BEE-BEDD Patient Medication Reconciliation  ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;;Jun 04, 2014;Build 13
 ;
 ;Adapted from BEDDMEDREC/CNHS/RPF
 ;
 Q
 ;
EN(BEDDDFN,VIEN) ;EP - Patient Medication Reconciliation
 ;
 ; Input:
 ; BEDDDFN (Optional) - Patient DFN
 ; VIEN (Optional) - Visit pointer to 9000010
 ;
 S BEDDDFN=$G(BEDDDFN,""),VIEN=$G(VIEN,"")
 ;
 NEW %,%ZIS,AGE,AGPATDFN,AUPNDAYS,AUPNDOB,AUPNDOD,AUPNPAT,AUPNSEX,DFN,DIC,DOB
 NEW REC,RHIFLAG,SEX,SSN,X,Y,EXIT,DFN,POP
 ;
 ;Select Patient
 S:BEDDDFN]"" DFN=BEDDDFN
 I BEDDDFN="" D PTLK^AG
 Q:'$D(DFN)
 ;
 ;Select Device
 S %ZIS="QA"
 D ^%ZIS
 I POP N IOP S IOP=ION D ^%ZIS Q
 I $G(IO("Q")) D QUE D HOME^%ZIS Q
 U IO
 D START
 D ^%ZISC
 D HOME^%ZIS
 Q
 ;
START ;Display Report
 ;
 NEW PNAME,PSEX,PDOB,PSITE,PCHRT,RPTDTM,LINE,PAGE,APTDT,PLOC
 ;
 S PNAME=$$GET1^DIQ(2,DFN_",",.01,"E")
 S PSEX=$$GET1^DIQ(2,DFN_",",.02,"E")
 S PDOB=$$FMTE^BEDDUTIL($$GET1^DIQ(2,DFN_",",.03,"I"))
 S PSITE=$$GET1^DIQ(4,DUZ(2)_",",.01,"E")
 S PCHRT=$$GET1^DIQ(9000001.41,DUZ(2)_","_DFN_",",.02,"E")
 S APTDT="" I VIEN]"" S APTDT=$$GET1^DIQ(9000010,VIEN_",",.01,"I") S:APTDT]"" APTDT=$$FMTE^BEDDUTIL(APTDT)
 S:APTDT]"" APTDT="PATIENT APPOINTMENT: "_APTDT
 S PLOC="" I VIEN]"" S PLOC=$$GET1^DIQ(9000010,VIEN_",",.08,"E")
 S:PLOC]"" PLOC="LOCATION: "_PLOC
 S $P(LINE,"*",78)="*"
 ;
 S RPTDTM=$TR($$XNOW^BEDDUTIL("5FMZ"),"@"," ")
 ;
 ;PRINT THE REPORT
 ;
 D HDR(.EXIT) G END:$G(EXIT)
 ;
 ;Display Patient Allergies
 W !,LINE
 W !,"ALLERGIES: ",$$PTALG^BEDDUTIL(DFN)
 ;
 ;Print Active Medications
 ;
 NEW X,MCTR
 K ^TMP("TIUMED",$J)
 S X=$$LIST^TIULMED(DFN,"^TMP(""TIUMED"",$J)",1)
 ;
 S MCTR=1
AMED S MCTR=$O(^TMP("TIUMED",$J,MCTR)) G OMED:MCTR=""
 NEW DATA
 S DATA=$G(^TMP("TIUMED",$J,MCTR,0))
 I DATA["ACTIVE OUTPATIENT" G AMED
 W !,DATA
 S DATA=""
 I $Y>IOSL D HDR(.EXIT) G END:$G(EXIT)
 G AMED
 ;
 ;Print blank section for outside medications
 ;
OMED I $Y>(IOSL-5) D HDR(.EXIT) G END:$G(EXIT)
 W !!,LINE
 W !,"____  I am unsure of any outside medications and/or over the counter"
 W !,"      medications and dosages.  I will bring my medications on my next visit.",!
 W !,LINE
 I $Y>(IOSL-13) D HDR(.EXIT) G END:$G(EXIT)
 W !,"OUTSIDE MEDICATIONS"
 W !,"Patient: Please list any outside medications not received at any"
 W !,PSITE," Pharmacy"
 W !!,"_____________________________________________________________________"
 W !!,"_____________________________________________________________________"
 W !!,"_____________________________________________________________________"
 W !!,"_____________________________________________________________________"
 W !!
 ;
 ;Print place for over the counter medications
 ;
 I $Y>(IOSL-14) D HDR(.EXIT) G END:$G(EXIT)
 W !,LINE
 W !,"OVER THE COUNTER MEDICATIONS"
 W !,"Patient: Please list any OVER the Counter Medications"
 W !!,"_____________________________________________________________________"
 W !!,"_____________________________________________________________________"
 W !!,"_____________________________________________________________________"
 W !!,"_____________________________________________________________________"
 W !!!
 ;
 ;Print place for new medications
 ;
 I $Y>IOSL D HDR(.EXIT) G END:$G(EXIT)
 W !,LINE
 W !!,"NEW/CHANGE MEDICATIONS"
 W !!,"_____________________________________________________________________"
 W !!,"_____________________________________________________________________"
 W !!,"_____________________________________________________________________"
 W !!,"_____________________________________________________________________"
 ;
END ;EP - Cleanup
 ; 
 I $E(IOST)="C",'$G(EXIT) K DIR D RTRN
 I $E(IOST)'="C" D CLOSE^%ZISH(IO)
 ;
 K ^TMP("TIUMED",$J)
 Q
 ;
 ;Display Header
 ;
HDR(EXIT) ;EP - Display Report Header
 ;
 NEW ALERT,TITLE,PRINT
 S PAGE=$G(PAGE)+1
 ;
 ;Handle Screen Printing
 I PAGE>1 D RTRN(.EXIT) Q:$G(EXIT)
 ;
 I PAGE'=1 U IO W @IOF
 S ALERT="***ALERT***   PATIENT COPY   ***   PATIENT COPY   *** ALERT ***"
 S TITLE="PATIENT MEDICATION RECONCILIATION"
 S PRINT="PRINTED ON "_RPTDTM
 ;
 W !,PRINT,?70,"PAGE: ",PAGE
 W !,?((80-$L(ALERT))/2),ALERT
 W !!,?((80-$L(PSITE))/2),PSITE
 W !,?((80-$L(TITLE))/2),TITLE
 I $G(APTDT)]"" W !,?((80-$L(APTDT))/2),APTDT
 I $G(PLOC)]"" W !,?((80-$L(PLOC))/2),PLOC
 ;
 W !!,"PATIENT NAME: ",PNAME
 W ?46,"SEX: ",PSEX
 W !,?5,"CHART #: ",PCHRT,?46,"DOB: ",PDOB
 W !
 Q
 ;
RTRN(EXIT) ;EP - Force RETURN entry
 NEW DIR,DIRUT,DUOUT,Y
 S EXIT=""
 ;Only ask if displaying to screen
 I $E(IOST)="C" D
 . S DIR(0)="E"
 . D ^DIR
 . K DIR
 . I $G(DUOUT)!$G(DIRUT) S EXIT=1
 ;
 Q
 ;
QUE ;Queue Task
 NEW ZTRTN,ZTSAVE,ZTDESC
 K IO("Q")
 S ZTRTN="START^BEDDMREC",ZTDESC="Patient Medication Reconciliation"
 S ZTSAVE("*")=""
 K ZTSK D ^%ZTLOAD
 I $D(ZTSK)[0 W !!?5,"Report Cancelled!"
 E  W !!?5,"Task # ",ZTSK," queued.",!
 H 3
 Q
