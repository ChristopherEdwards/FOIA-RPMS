DGVPTIB5 ;alb/mjk - IBOVOP1 for export with PIMS v5.3; 4/21/93
 ;;5.3;Registration;;Aug 13, 1993
 ;
IBOVOP1 ;ALB/RLW - Report of Visits for NSC Outpatients ; 12-JUN-92
 ;;Version 1.5 ; INTEGRATED BILLING ;**14**; 29-JUL-92
MAIN ; perform report for day(s)
 D HDR,APPT,STOPCD,REGS,PRINT
 K DFN,^TMP("IBOVOP",$J),J,IBAPPT,IBJ
 Q
APPT ; scan visits for NSC patients
 ;            field 2="CLINIC APPT"
 ;            field 4=clinic
 ;            field 5=appt type
 ;            field 6=status
 S IBCL="",IBSEQ=0,J=""
 F  S IBCL=$O(^SC("AC","C",IBCL)) Q:IBCL=""  S IBFLD4=$P(^SC(IBCL,0),"^") Q:IBFLD4=""  S J=IBDATE D
 .F  S J=$O(^SC(IBCL,"S",J)) Q:$E(J,1,7)'=IBDATE  S IBIEN=0 D
 ..F  S IBIEN=$O(^SC(IBCL,"S",J,1,IBIEN)) Q:IBIEN=""  S DFN=$P(^(IBIEN,0),"^",1) D
 ...Q:'$$BIL^DGMTUB(DFN,J)
 ...Q:'$D(^DPT(DFN,"S",J,0))  S IBSDATA=^(0)
 ...S ^TMP("IBOVOP",$J,$$FLD1(DFN),"CLINIC APPT",$$FLD3(J),IBSEQ)=$E(IBFLD4,1,16)_"^"_$$FLD5($P(IBSDATA,"^",16))_"^"_$E($P($$STATUS^SDAM1(DFN,J,IBCL,IBSDATA),";",3),1,17)_"^"_DFN
 Q
STOPCD ; scan ADD/EDIT STOP CODES for day
 ;           field 2="STOP CODE"
 ;           field 4=stop code
 ;           field 5=appt type
 N J S J=IBDATE,IBFLD4="",IBSEQ=0
 F  S J=$O(^SDV(J)),DFN="" Q:$E(J,1,7)'=IBDATE  S DFN=$P(^SDV(J,0),"^",2) I $$BIL^DGMTUB(DFN,J)  S IB="" D
 .F  S IB=$O(^SDV(J,"CS","B",IB)) Q:IB=""  S I="",I=$O(^(IB,I)) Q:I=""  D
 ..S IBDATA=^SDV(J,"CS",I,0)
 ..S ^TMP("IBOVOP",$J,$$FLD1(DFN),"STOP CODE",$$FLD3(J),IBSEQ)=$E($P(^DIC(40.7,$P(IBDATA,"^",1),0),"^"),1,16)_"^"_$$FLD5($P(IBDATA,"^",5))_"^^"_DFN S IBSEQ=(IBSEQ+1)
 Q
REGS ; registrations for day
 N J S J=IBDATE,IBFLD4="",IBFLD5=""
 F  S J=$O(^DPT("ADIS",J)) Q:J=""  Q:$E(J,1,7)'=IBDATE  S DFN="" D
 .F  S DFN=$O(^DPT("ADIS",J,DFN)) Q:DFN=""  D
 ..S IBAIEN="",IBAIEN=$O(^DPT("ADIS",J,DFN,IBAIEN)) Q:(IBAIEN="")
 ..S IBDATA=^DPT(DFN,"DIS",IBAIEN,0) Q:($P(IBDATA,"^",2)="2")!('$$BIL^DGMTUB(DFN,$P(IBDATA,"^",6)))
 ..S IBFLD1=$$FLD1(DFN),IBFLD3=$$FLD3(J),Y=$P(IBDATA,"^",3)
 ..I Y'="" S C=$P(^DD(2.101,2,0),"^",2) D Y^DIQ
 ..S IBFLD4=$S($D(Y):Y,1:"")
 ..S Y=$P(IBDATA,"^",7)
 ..I Y'="" S C=$P(^DD(2.101,6,0),"^",2) D Y^DIQ
 ..S IBFLD5=$S($D(Y):Y,1:"")
 ..S ^TMP("IBOVOP",$J,$$FLD1(DFN),"REGISTRATION",$$FLD3(J),IBSEQ)=$E(IBFLD4,1,16)_"^"_$E(IBFLD5,1,30)_"^^"_DFN
 Q
CHRGS ; find OP charges for day, if any.
 ; build string for print
 Q:DFN=""
 I $D(^IB("AFDT",DFN,-IBDATE))=10 S IBPRNT=""  D
 .F  S IBPRNT=$O(^IB("AFDT",DFN,-IBDATE,IBPRNT)) Q:(IBPRNT="")!(IBQUIT)  S IBIEN="" D
 ..F  S IBIEN=$O(^IB("AD",IBPRNT,IBIEN)) Q:(IBIEN="")!(IBQUIT)  S IBDATA=$G(^IB(IBIEN,0)) Q:(IBDATA="")  D
 ...S Y=$P(IBDATA,"^",5),C=$P(^DD(350,.05,0),"^",2) D Y^DIQ S IBSTAT=Y K C,Y
 ...I $Y>(IOSL-5) D PAUSE^IBOUTL Q:IBQUIT  D HDR W !,IBFLD1
 ...S IBACT=$S($P(^IBE(350.1,$P(IBDATA,"^",3),0),"^",8)'="":$P(^(0),"^",8),1:$P(^(0),"^",1)),IBAMT=$P(IBDATA,"^",7),IBAMT=$S(IBACT["CANCEL":"*($"_IBAMT_")",1:"* $"_IBAMT)
 ...W !?5,IBAMT,?13,IBACT,?63,IBSTAT S IBLINE=(IBLINE+1)
 Q
HDR ; print header
 S IBPAGE=IBPAGE+1,IBLINE=5,IBRECNO=1,IBTITLE="Category C Outpatient and Registration Activity for "_$$DAT1^IBOUTL(IBDATE)
 I $E(IOST,1,2)["C-"!(IBPAGE>1) W @IOF
 W ?(80-$L(IBTITLE))\2,IBTITLE
 S IBTITLE="Printed: "_$$DAT1^IBOUTL(DT)
 W !?(80-$L(IBTITLE))\2,IBTITLE,?70,"Page: "_IBPAGE K Y
 W !!,"Patient/Event",?20,"Time",?26,"Clinic/Stop",?44,"Appt.Type",?63,"(Status)",!
 S LINE="",$P(LINE,"-",1,IOM)="" W LINE K LINE
 Q
PRINT ; retrieve data for printing
 S IBFLD1="",DFN="" I '$D(^TMP("IBOVOP",$J)) W !!,"NONE"
 F  S IBFLD1=$O(^TMP("IBOVOP",$J,IBFLD1)) Q:(IBFLD1="")!(IBQUIT)  W ! D:IBLINE>55 HDR W !,IBFLD1 D  D CHRGS Q:IBQUIT
 .S IBFLD2="" F  S IBFLD2=$O(^TMP("IBOVOP",$J,IBFLD1,IBFLD2)) Q:(IBFLD2="")!(IBQUIT)  W !?5,IBFLD2 D
 ..S IBFLD3="" F  S IBFLD3=$O(^TMP("IBOVOP",$J,IBFLD1,IBFLD2,IBFLD3)) Q:(IBFLD3="")!(IBQUIT)  D
 ...S IBSEQ="" F  S IBSEQ=$O(^TMP("IBOVOP",$J,IBFLD1,IBFLD2,IBFLD3,IBSEQ)) Q:(IBSEQ="")!(IBQUIT)  D
 ....S IBDATA=^(IBSEQ),IBFLD4=$P(IBDATA,"^",1),IBFLD5=$P(IBDATA,"^",2),IBFLD6=$P(IBDATA,"^",3),DFN=$P(IBDATA,"^",4)
 ....W ?20,IBFLD3,?26,IBFLD4,?44,IBFLD5,?63,IBFLD6,! S IBFLD4="",IBFLD5="",IBFLD6="",IBLINE=(IBLINE+1)
 ....I IBLINE>55 D HDR W !,IBFLD1 I $D(^TMP("IBOVOP",$J,IBFLD1,IBFLD2,IBFLD3,IBSEQ+1)) W !?5,IBFLD2
 ....I $Y>(IOSL-5) D PAUSE^IBOUTL Q:IBQUIT  D HDR W !,IBFLD1,!?5,IBFLD2
 Q:IBQUIT  D PAUSE^IBOUTL
 Q
FLD1(DFN) ; patient - get patient name and l-4 ssn id
 I '$G(DFN) Q ""
 N X S X=$$PT^IBEFUNC(DFN)
 Q $E($P(X,"^"),1,20)_" "_$E(X)_$P(X,"^",3)
 ;
FLD3(Y) ; time - convert date/time to time only, no seconds
 I '$G(Y) Q ""
 X ^DD("DD") Q $P($P(Y,"@",2),":",1,2)
 ;
FLD5(I) ; get appointment type name
 Q $E($P($G(^SD(409.1,+$G(I),0)),"^",1),1,17)
