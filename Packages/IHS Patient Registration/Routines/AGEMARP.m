AGEMARP ; VNGT/IHS/DLS - Patient Email Listing ; May 14, 2010
 ;;7.1;PATIENT REGISTRATION;**8,9**;AUG 25, 2005
 ;
VAR N TYPE,DL,SDL,AGIO
 K ^TMP("AGEMARP",$J)
 ;
 ; Initialize Variables
 ; 
 S DL="^"
 S SDL=","
    ;
 D GETPARMS
 I $G(TYPE("DATE"))="" G EXIT
 I $G(TYPE("DATE","FROM"))="" G EXIT
 I $G(TYPE("DATE","TO"))="" G EXIT
 I $G(TYPE("FORMAT"))="" G EXIT
DEV ;
 S %ZIS="QA"
 D ^%ZIS
 I POP N IOP S IOP=ION D ^%ZIS Q
 I $G(IO("Q")) D QUE D HOME^%ZIS Q
 U IO
 D GO
 D ^%ZISC
 D HOME^%ZIS
 Q
GO ; Start Processing
 D GETDATA
 D PRINT
 G EXIT
 ;
 Q
 ;
GETPARMS ; Get Report Parameters
 N X,Y,DIR
 S DIR("A")="     Select PARAMETER"
 S DIR("B")="L"
 S DIR(0)="SO^L:LAST UPDATE;A:APPOINTMENT DATE"
 S DIR("L",1)="           Choose from:"
 S DIR("L",2)="          L      LAST UPDATE"
 S DIR("L",3)="          A      APPOINTMENT DATE"
 S DIR("L",4)=""
 D ^DIR
 I X["^" Q
 ; Get Output type
 S TYPE("DATE")=X D GETDTS
 I $G(TYPE("DATE","FROM"))="" Q
 I $G(TYPE("DATE","TO"))="" Q
 N DIR
 S DIR("A")="    Select Output Format"
 S DIR("B")="S"
 S DIR(0)="SO^S:STANDARD;F:FLAT FILE"
 S DIR("L",1)="          S      STANDARD"
 S DIR("L",2)="          F      FLAT (Datafile)"
 S DIR("L",3)=""
 D ^DIR
 I Y["^" Q
 S TYPE("FORMAT")=X
 W !
 Q
 ;
GETDTS ; Get Date Range
 D START I $G(TYPE("DATE","FROM"))="" Q
 D END I $G(TYPE("DATE","TO"))="" Q
 Q
START ; Get Start Date
 N X,Y,DIR
 S DIR("A")="     Select START DATE"
 S DIR("B")="T"
 S DIR(0)="DO"
 W !
 D ^DIR
 I Y["^" Q
 I TYPE("DATE")="L",Y>DT D  G START
 . W !!,?11,"Date cannot be in the future.",!
 S TYPE("DATE","FROM")=Y D DD^%DT S $P(TYPE("DATE","FROM"),U,2)=Y W "     ",Y
 Q
 ;
END ; Get end date
 N X,Y,DIR
 S DIR("A")="     Select END DATE"
 S DIR("B")="T"
 S DIR(0)="DO"
 W !
 D ^DIR
 I Y["^" Q
 I TYPE("DATE","FROM")>Y D  G END
 . W !!,?11,"End date cannot be before start date.",!
 I TYPE("DATE")="L",Y>DT D  G END
 . W !!,?11,"Date cannot be in the future.",!
 S TYPE("DATE","TO")=Y D DD^%DT S $P(TYPE("DATE","TO"),U,2)=Y W "     ",Y
 Q
 ;
GETDATA ; Gather Report data
 N TOTCNT,AIANCNT,PATNT,Y,EXTDT
 S (TOTCNT,AIANCNT)=0
 S Y=DT D DD^%DT S EXTDT=Y
 S ^TMP("AGEMARP",$J,0)=$$GET1^DIQ(4,DUZ(2),.01)_DL_EXTDT_DL_$S($G(TYPE("DATE"))="L":"Last Update",1:"Appointment Date")_DL_$P($G(TYPE("DATE","FROM")),U,2)_DL_$P($G(TYPE("DATE","TO")),U,2)
 S PATNT=""
 F  S PATNT=$O(^AUPNPAT("B",PATNT)) Q:+PATNT=0  D
 . N PTNTNM,PTNTEM,CHRTNO,ACCESS,PERMIT,OK,ACCIEN1,ACCIEN2,ACCESS,ACCCNT
 . S PTNTEM=$$GET1^DIQ(9000001,PATNT,1802)
 . Q:PTNTEM=""
 . S OK=0
 . D DTCHK(PATNT,.OK)
 . I OK D
 . . S CHRTNO=$P($G(^AUPNPAT(PATNT,41,DUZ(2),0)),U,2)
 . . S PTNTNM=$$GET1^DIQ(2,PATNT,.01)
 . . S ACCIEN1=0,ACCESS=""
 . . S ACCCNT=$P($G(^AUPNPAT(PATNT,81,0)),U,3)
 . . I ACCCNT]"" F  S ACCIEN1=$O(^AUPNPAT(PATNT,81,ACCCNT,1,ACCIEN1)) Q:+ACCIEN1=0  D
 . . . S ACCIEN2=ACCIEN1_","_ACCCNT_","_PATNT
 . . . S ACCESS=ACCESS_$$GET1^DIQ(9000001.811,ACCIEN2,.01)_SDL
 . . I $E(ACCESS,$L(ACCESS))=SDL S ACCESS=$E(ACCESS,1,($L(ACCESS)-1))
 . . S PERMIT=$$GET1^DIQ(9000001,PATNT,4001)
 . . I $$GET1^DIQ(9000001,PATNT,1111,"I")=1 S AIANCNT=AIANCNT+1
 . . S TOTCNT=TOTCNT+1
 . . S ^TMP("AGEMARP",$J,PTNTNM,PATNT)=CHRTNO_DL_PTNTEM_DL_ACCESS_DL_PERMIT
 S ^TMP("AGEMARP",$J,0)=^TMP("AGEMARP",$J,0)_DL_TOTCNT_"-Total"_DL_AIANCNT_"-Total AI/AN"
 Q
 ;
DTCHK(PATNT,OK) ; Check Date Parameters
 S OK=0
 N VIEN,STDT,ENDT,VDT
 S STDT=+TYPE("DATE","FROM")-1
 S ENDT=+TYPE("DATE","TO")+1
 I TYPE("DATE")="A" D
 . S VIEN=0
 . F  S VIEN=$O(^AUPNVSIT("AC",PATNT,VIEN)) Q:(VIEN="")!(OK)  D
 . . S VDT=$P($G(^AUPNVSIT(VIEN,0)),U)\1
 . . I VDT>STDT,VDT<ENDT S OK=1
 . . Q:OK
 I TYPE("DATE")="L" D
 . N UDT
 . S UDT=$$GET1^DIQ(9000001,PATNT,.03,"I")
 . I UDT>STDT,UDT<ENDT S OK=1
 . Q
 Q
 ;
PRINT ; Top level print engine
 I $O(^TMP("AGEMARP",$J,0))="" W !!,"     No Records Found!" H 3 Q
 I TYPE("FORMAT")="S" D PRINTS
 I TYPE("FORMAT")="F" D PRINTF
 Q
PRINTS ; Generate Standard Output
 N REC,LINECNT,ESCAPE,RECOUT,HRNOUT,EMAOUT,WHROUT,PRMOUT,PAGE,TYP,POP,ESCAPE,AGTOT,AGT,PATNT
 S PAGE=0,ESCAPE=0
 S TYP=$S(TYPE("DATE")="A":" APPTS ",1:" UPDATES ")
 I $G(AGIO)="" U IO
 N AGLINE
 S $P(AGLINE("EQ"),"=",80)=""
 S $P(AGLINE("DASH"),"-",80)=""
 D HDR
 S REC=0
 F  S REC=$O(^TMP("AGEMARP",$J,REC)) Q:(REC="")!(ESCAPE)  D
 . S PATNT=0
 . F  S PATNT=$O(^TMP("AGEMARP",$J,REC,PATNT)) Q:(PATNT="")!(ESCAPE)  D
 . . N WHERCNT
 . . S RECOUT=^TMP("AGEMARP",$J,REC,PATNT)
 . . S HRNOUT=$P(RECOUT,DL)
 . . S EMAOUT=$P(RECOUT,DL,2)
 . . S WHROUT=$P(RECOUT,DL,3)
 . . S PRMOUT=$P(RECOUT,DL,4)
 . . W !,HRNOUT,?9,$E(REC,1,20),?30,EMAOUT
 . . I $L(EMAOUT)>24 W !
 . . W ?55,$E($P(WHROUT,","),1,19),?74," ",PRMOUT
 . . I WHROUT'="" D
 . . . S AGT=$E($P(WHROUT,","),1,19)
 . . . S AGTOT(AGT)=$G(AGTOT(AGT))+1
 . . . S AGTOT("TOTAL")=$G(AGTOT("TOTAL"))+1
 . . I $L(WHROUT,SDL)>1 D
 . . . S WHERCNT=$L(WHROUT,SDL)
 . . . N I F I=2:1:WHERCNT D
 . . . . W !,?55,$P(WHROUT,SDL,I)
 . . . . S AGT=$P(WHROUT,SDL,I)
 . . . . S AGTOT(AGT)=$G(AGTOT(AGT))+1
 . . . . S AGTOT("TOTAL")=$G(AGTOT("TOTAL"))+1
 . . I $O(^TMP("AGEMARP",$J,REC,PATNT))'="" W !,AGLINE("DASH")
 . . I $E(IOST)="C",$Y>(IOSL-5) K DIR D RTRN^AG S ESCAPE=X=U D:'ESCAPE HDR
 . . I $E(IOST)'="C",$Y>(IOSL-17) W !! D HDR
 I 'ESCAPE D
 . W !,AGLINE("EQ")
 . S AGT=""
 . W !!,"TOTALS",!,"----------------"
 . F  S AGT=$O(AGTOT(AGT)) Q:AGT=""  D
 . . I AGT'="TOTAL" D
 . . . W !,AGT
 . . . I AGT="TRIBE/COMMUNITY CEN" W "TER"
 . . . W ?22
 . . . W $J($G(AGTOT(AGT)),10)
 . W !,"================================="
 . W !,$J($G(AGTOT("TOTAL")),32),!!
 I $E(IOST)="C",REC="" K DIR D RTRN^AG
 I $E(IOST)'="C" D CLOSE^%ZISH(IO)
 Q
 ;XU
HDR ; Print Header
 S PAGE=PAGE+1
 W @IOF
 W !,$$GET1^DIQ(200,DUZ,.01)
 W ?(80-$L($$GET1^DIQ(4,DUZ(2),.01)))/2,$$GET1^DIQ(4,DUZ(2),.01)
 W ?70,"Page ",PAGE
 W !,?33,"EMAIL LISTING"
 I TYPE("DATE")="L" W !,?19,"LAST UPDATE: "
 I TYPE("DATE")="A" W !,?16,"APPOINTMENT DATE: "
 I +TYPE("DATE","FROM")=2010101,+TYPE("DATE","TO")=3991231 W "FOR ALL APPOINTMENTS"
 I +TYPE("DATE","FROM")=2010101,+TYPE("DATE","TO")'=3991231 W "FOR ALL",TYP,"THROUGH ",$P(TYPE("DATE","TO"),U,2)
 I +TYPE("DATE","FROM")'=2010101,+TYPE("DATE","TO")=3991231 W "FOR ALL",TYP,"FROM ",$P(TYPE("DATE","FROM"),U,2)
 I +TYPE("DATE","FROM")'=2010101,+TYPE("DATE","TO")'=3991231 D
 . W $P(TYPE("DATE","FROM"),U,2)
 . W " - "
 . W $P(TYPE("DATE","TO"),U,2)
 W !!,"HRN",?9,"NAME",?30,"EMAIL ADDRESS",?55,"WHERE",?69,"PERMISSION"
 W !,AGLINE("EQ")
 Q
 ;
PRINTF ; Generate "Flat" Datafile Output
 N REC,RECOUT,POP,OUTFNM,PATH,FILENAME,PNLNGTH,LPCNT,ESCAPE,I,PATNT
 I $G(AQGIO)="" U IO
 I $E(IOST)="C" W @IOF
 S REC=0,ESCAPE=0
 W ^TMP("AGEMARP",$J,REC)
 F  S REC=$O(^TMP("AGEMARP",$J,REC)) Q:REC=""!ESCAPE  D
 . S PATNT=0
 . F  S PATNT=$O(^TMP("AGEMARP",$J,REC,PATNT)) Q:PATNT=""  D
 . . S RECOUT=REC_DL_^TMP("AGEMARP",$J,REC,PATNT)
 . . W !,RECOUT
 . . I $E(IOST)="C",$Y>(IOSL-5) K DIR D RTRN^AG S ESCAPE=X=U W @IOF
 I $E(IOST)="C",REC="" K DIR D RTRN^AG
 I $E(IOST)'="C" W ! D CLOSE^%ZISH(IO)
 S IOSL=24
 Q
 ;
QUE ;QUE TO TASKMAN
 K IO("Q")
 S ZTRTN="GO^AGEMARP",ZTDESC="Patient Email Address Listing "
 S ZTSAVE("*")=""
 K ZTSK D ^%ZTLOAD
 I $D(ZTSK)[0 W !!?5,"Report Cancelled!"
 E  W !!?5,"Task # ",ZTSK," queued.",!
 H 3
 Q
 ;
EXIT ; Exit the program
 K ^TMP("AGEMARP",$J)
 Q
 ;
