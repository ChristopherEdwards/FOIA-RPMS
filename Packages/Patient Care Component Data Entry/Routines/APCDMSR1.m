APCDMSR1 ; IHS/CMI/LAB - Cumulative Vital Measurement Report 22-Jun-2007 15:09 PLS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 Q
 ; Generate a cumulative report
CRPT(DFN,SDT,EDT) ; PEP - API FOR PATIENT CUMULATIVE VITALS REPORT
 ; INPUT VARIABLES:    DFN=PATIENT NUMBER
 ;                     SDT=START DATE
 ;                     EDT=FINISH DATE OF REPORT
 N HOSPLOC,VITDATE,PAGE,VITOR,GBED,VIT1ST,PDT,DASH,VTYPE,VTYPEI
 N VA,GWARD,GMRS,GFLAG,VDT,VDA,VBMI,VAL,GPRT
 S VITOR=1
 S (OUT,PAGE)=0 D DEM^VADPT,INP^VADPT S GBED=$S(VAIN(5)'="":VAIN(5),1:"   "),GWARD=$S($P(VAIN(4),"^",2)="":"   ",1:$P(VAIN(4),"^",2))
 S VIT1ST=1,VITDATE(0)=0
 S PDT=$$FMTE^XLFDT($$NOW^XLFDT())
 S PDT=$P(PDT,"@")_" ( "_$P($P(PDT,"@",2),":",1,2)_")"
 S $P(DASH,"-",81)=""
 ;
 K ^TMP($J,"APCD")
 F VTYPE="TMP","PU","RS","BP","HT","WT","AG","WC","PA" D
 .S VTYPEI=$$FIND1^DIC(9999999.07,,,VTYPE)
 .I VTYPEI>0 D SETAR
 ;
 U IO D HDR
 ;
 I $O(^TMP($J,"APCD",0))'>0 D  G Q3
 .W !!,"No cumulative vitals data for "_$S($D(OPSPNM):ORSPNM,1:"this patient"),!
 .S:$D(ORSPNM) OUT=1
 F VITDATE=0:0 S VITDATE=$O(VDT(VITDATE)) Q:VITDATE'>0!OUT  D
 .I $D(^TMP($J,"APCD",VITDATE)) D PRT
Q3 I IOSL'<($Y+10) F X=1:1 W ! Q:IOSL<($Y+10)
 I 'OUT W ! D
 .D FOOTER
 .I '$D(VITOR),$E(IOST)'="P",'OUT D  Q:OUT
 ..W !,"Press return to continue or ""^"" to exit " R X:DTIME S:'$T!(X["^") OUT=1
 D KVAR^VADPT
 K ^TMP($J,"APCD")
 I $D(ORSPNM) S:$D(ZTQUEUED) ZTREQ="@" D ^%ZISC
 Q
 ;
HDR ;
 I 'VIT1ST D FOOTER
 I $E(IOST)'="P",'VIT1ST D  Q:OUT
 .W "Press return to continue ""^"" to escape " R X:DTIME I X="^"!'$T S OUT=1
 W:'($E(IOST)'="C"&'$D(GFLAG)) @IOF
 S PAGE=PAGE+1,GFLAG=1
 W !,PDT,?25,"Cumulative Vitals/Measurements Report",?70,"Page ",PAGE,!!,$E(DASH,1,78)
 I 'VIT1ST,$P(VITDATE,".")=VITDATE(0) D
 .W !,$$FMTE^XLFDT(VITDATE,"5DZ")_" (continued)",!   ;$E(VITDATE(0),4,5)_"/"_$E(VITDATE(0),6,7)_"/"_$E(VITDATE,2,3)_" (continued)",!
 S VIT1ST=0
 Q
FOOTER ;REPORT FOOTER SUBROUTINE
 W !!,"*** (E) - Error entry",!!
 W:VADM(1)'="" ?$X-3,$E(VADM(1),1,15)
 W ?17,$G(VA("PID"))
 W:VADM(3) ?30,$P(VADM(3),U,2)
 W:VADM(4)'="" ?43,$P(VADM(4),U)_" YRS"
 W:VADM(5)'="" ?51,$P(VADM(5),U,2)
 W !,"Unit: "_$S($P(VAIN(4),U,2)'="":$P(VAIN(4),U,2),1:"     "),?32,"Room: "_$S($P(VAIN(5),U)'="":$P(VAIN(5),U),1:"   "),!
 I '$D(HOSPLOC) S HOSPLOC=$P($G(^DIC(42,+$G(VAIN(4)),44)),U)
 W "Division: "_$S(HOSPLOC>0:$$GET1^DIQ(4,+$$GET1^DIQ(44,+HOSPLOC,3,"I"),.01,"I"),1:""),!
 Q
BLNK ;
 F I=1:1:$L(VAL) Q:$E(VAL,I)'=" "
 S VAL=$E(VAL,I,$L(VAL))
 Q
SETAR ;
 S VDT=0 F  S VDT=$O(^AUPNVMSR("AA",DFN,VTYPEI,VDT)) Q:VDT'>0  D
 .S VITDATE=9999999-VDT   ;I '(VITDATE>EDT!(VITDATE<SDT)) D SETND
 .D SETND
 Q
SETND ;
 S VDA=0 F  S VDA=$O(^AUPNVMSR("AA",DFN,VTYPEI,VDT,VDA)) Q:VDA'>0  D SETUT
 Q
SETUT N EVDATE
 S EVDATE=+$P($G(^AUPNVMSR(VDA,12)),U)
 S EVDATE=$S(EVDATE:EVDATE,1:VITDATE)
 S EVDATE=$E(EVDATE,1,12)
 Q:(EVDATE<SDT)!(EVDATE>EDT)
 S ^TMP($J,"APCD",EVDATE,VTYPE,VDA)=0
 S VDT(EVDATE)=""
 Q
 ; Return date/time associated with Vital entry
VITDATE(IEN) ;
 Q RES
PRT ;PRINT V/M BY DATE/TIME
 D:IOSL<($Y+9) HDR Q:OUT
 I $P(VITDATE,".")'=VITDATE(0) D
 .W !,$$FMTE^XLFDT(VITDATE,"5Z")
 .S VITDATE(0)=$P(VITDATE,".")
 D:IOSL<($Y+9) HDR Q:OUT
 W !,$P($P($$FMTE^XLFDT(VITDATE),"@",2),":",1,2)
 I $D(^TMP($J,"APCD",VITDATE)) D
 .K APCDLN,GERROR
 .F VTYPE="TMP","PU","RS","BP","HT","WT","AG","WC","PA" S GPRT(VTYPE)=0 D
 ..I $D(^TMP($J,"APCD",VITDATE,VTYPE)) F VDA=0:0 S VDA=$O(^TMP($J,"APCD",VITDATE,VTYPE,VDA)) Q:VDA'>0!OUT  D SETLN
 Q
SETLN ;
 S VVER=^TMP($J,"APCD",VITDATE,VTYPE,VDA) N VPO
 D:IOSL<($Y+9) HDR Q:OUT  W ! W:VVER "(E)"
 I GPRT(VTYPE)=0 D
 . W ?4,$S(VTYPE="TMP":"TMP: ",VTYPE="PU":"PU: ",VTYPE="RS":"RS: ",VTYPE="BP":"B/P: ",VTYPE="WT":"Wt: ",VTYPE="HT":"Ht: ",VTYPE="AG":"Abdominal Girth: ",VTYPE="WC":"Waist Circumference: ",1:" ")  ;VTYPE="PA":"Pain: ",1:" ")
 . I VTYPE="PA" W ?4,"Pain: "
 S GPRT(VTYPE)=1
 S VDAT=^AUPNVMSR(VDA,0)
 I "PURSBPWCAGPA"[VTYPE S VVX=VTYPE,VVX(0)=$P(VDAT,U,4) D
 .  I "UNAVAILABLEPASSREFUSED"[$$UP^XLFSTR(VVX(0)) W ?9,VVX(0) Q
 . I VTYPE="PA" D
 . . I VVX(0)=0 W ?9,VVX(0)_" - No pain" Q
 . . I VVX(0)=99 W ?9,VVX(0)_" - Unable to respond" Q
 . . I VVX(0)=10 W ?9,VVX(0)_" - Worst imaginable pain" Q
 . . W ?9,VVX(0) Q
 . S VAL=$S(VTYPE="AG"!(VTYPE="WC"):$J($P(VDAT,U,4),0,2),VTYPE'="BP":$J($P(VDAT,U,4),3,0),1:$P(VDAT,U,4)) D:VTYPE'="BP" BLNK W:VTYPE'="PA" ?9,VAL_$S('$D(VVX(1)):" ",'VVX(1):"",1:"*")
 . I VTYPE="AG" W " in ("_$J(VAL/.3937,0,2)_" cm)"
 . I VTYPE="WC" W " in ("_$J(VAL/.3937,0,2)_" cm)"
 I VTYPE="TMP" S X=$P(VDAT,U,4) D
 . I X'>0 W ?9,X Q
 . S VVX=VTYPE,VVX(0)=X
 . S Y=$J(X-32*5/9,0,1)
 . S:'Y Y="" S VAL=$J(X,5,1) D BLNK W ?9,VAL_" F " S VAL=$J(Y,4,1) D BLNK W "("_VAL_" C)"_$S('$D(VVX(1)):" ",'VVX(1):"",1:"*")
 I VTYPE="HT" S X=$P(VDAT,U,4) D
 . I X'>0 W ?9,X Q
 . S Y=$J(2.54*X,0,2)
 . S:'Y Y="" S VAL=$J(X,5,2) D BLNK W ?9,VAL_" in " S VAL=$J(Y,5,2) D BLNK W "("_VAL_" cm)" I 'VVER S GMRVHT=VAL/100
 I VTYPE="WT" S X=$P(VDAT,U,4) D
 . I X'>0 W ?9,X Q
 . S Y=$J(X/2.2,0,2)
 . S:'Y Y="" S VAL=$J(X,7,2) D BLNK W ?9,VAL_" lb " S VAL=$J(Y,6,2) D BLNK W "("_VAL_" kg)"
 I VTYPE="WT",'VVER S VBMI="",VBMI(1)=$P(VDAT,"^"),VBMI(2)=+$P(VDAT,U,4) D
 .S VBMI=+$$TRIM^XLFSTR($$GETBMI(DFN,$P(VDAT,U,4),VITDATE))
 .W:VBMI !,?4,"Body Mass Index: "_VBMI
 Q
GETBMI(DFN,WT,DATE) ;EP
 N X,Y
 Q $$BMI^APCHS2A3(DFN,WT,DATE)
 ;
