BSDCCR2 ; IHS/ANMC/LJF - CLINIC CAPACITY REPORT CONT.;
 ;;5.3;PIMS;**1011**;APR 26, 2002
 ;COPY OF SCRPW72 BEFORE PATCH #223
 ;IHS/ANMC/LJF 10/06/2000 added call to IHS subtitles code
 ;                        made report 80 columns wide for past dates
 ;                        added call to list template
 ;                        made IHS mods to heading code
 ;              8/24/2001 check clinic selection for summary too
 ;             12/13/2001 screen out non-clinic entries in file 44
 ;              4/11/2002 screen out entries without clinic codes
 ;cmi/flag/maw 11/09/2009 put fix in ORD for clinic codes that are not numeric
 ;
START ;Gather data for printed report
 I $E(IOST,1,2)="C-" D EN^BSDCCRL Q      ;IHS/ANMC/LJF 10/6/2000
IHS ;EP; re-entry point from list template  ;IHS/ANMC/LJF 10/6/2000
 N SDCP,SC,SCNA,SDI,SDOUT,SDPAST,SDXM,MAX,X1,X2,X,SDIOM
 S (SDOUT,SDI)=0,SDIOM=$G(IOM,80)
 S SDPAST=SDBDT'>DT ;S:SDPAST SDIOM=130  ;IHS/ANMC/LJF 10/6/2000
 K ^TMP("SD",$J),^TMP("SDS",$J),^TMP("SDTMP",$J),^TMP("SDTOT",$J)
 ;D INIT^BSDCCR1 S SDCOL=$S(SDPAST:0,1:(SDIOM-58\2))  ;IHS/ANMC/LJF 10/6/2000
 D INIT^BSDCCR1 S SDCOL=$S(SDPAST:-7,1:(SDIOM-58\2))  ;IHS/ANMC/LJF 10/6/2000
 S X1=SDEDT,X2=SDBDT D ^%DTC S MAX=X+1
 I SDPAST D OE(SDBDT,SDEDT,MAX,0) Q:SDOUT  ;get outpt. enc. workload
 G:SDOUT EXIT^BSDCCR4
 ;
 ;IHS/ANMC/LJF 8/24/2001 summary has clinic selection too
 ;I SDFMT="D" D @SDSORT
 ;I SDFMT="S" S SC=0 F  S SC=$O(^SC(SC)) Q:'SC!SDOUT  D
 ;.S SDI=SDI+1 I SDI#25=0 D STOP Q:SDOUT
 ;.S SC0=$G(^SC(SC,0)) Q:'$$DIV(+$P(SC0,U,15))
 ;.S SDX=$$CLINIC^BSDCCR1(SC,SDFMT,SDBDT,SDEDT,MAX,SDPAST)
 ;.Q
 D @SDSORT
 ;IHS/ANMC/LJF 8/24/2001 end of mods
 ;
 G:SDOUT EXIT^BSDCCR4
 S SDMD=$O(^TMP("SD",$J,"")),SDMD=$O(^TMP("SD",$J,SDMD)),SDMD=$L(SDMD)
 I SDPAST D NAVA^BSDCCR5(SDBDT,SDEDT,SDEX)  ;get next available wait times
 G:SDOUT EXIT^BSDCCR4
 D ORD,PRT^BSDCCR3(0) G EXIT^BSDCCR4
 ;
ORD ;Build list to order clinic output
 S SDIV="" F  S SDIV=$O(^TMP("SD",$J,SDIV)) Q:SDIV=""!SDOUT  D
 .;S SDCP=0 F  S SDCP=$O(^TMP("SD",$J,SDIV,SDCP)) Q:'SDCP!SDOUT  D  cmi/maw 11/9/2009 PATCH 1011 orig line
 .S SDCP=0 F  S SDCP=$O(^TMP("SD",$J,SDIV,SDCP)) Q:SDCP=""!SDOUT  D  ;cmi/maw 11/9/2009 PATCH 1011
 ..S SC=0 F  S SC=$O(^TMP("SD",$J,SDIV,SDCP,SC)) Q:'SC!SDOUT  D
 ...S SCNA=$P($G(^SC(SC,0)),U) S:'$L(SCNA) SCNA="UNKNOWN"
 ...S ^TMP("SDS",$J,SDCP,SCNA,SC)=""
 ...Q
 ..Q
 .Q
 Q
 ;
OE(SDBDT,SDEDT,MAX,SDEX) ;Count clinic workload
 ;Input: SDBDT=begin date
 ;Input: SDEDT=end date
 ;Input: MAX=number of days in date range
 ;Input: SDEX='0' for user report, '1' for Austin extract
 N SDT,SDOE,SDOE0,SDCT,SDCP,SDQUIT S (SDQUIT,SDCT)=0,SDT=SDBDT
 F  S SDT=$O(^SCE("B",SDT)) Q:'SDT!(SDT>SDEDT)!SDOUT  D
 .S SDOE=0 F  S SDOE=$O(^SCE("B",SDT,SDOE)) Q:'SDOE!SDOUT  D
 ..S SDCT=SDCT+1 I SDCT#1000=0 D STOP Q:SDOUT
 ..S SDOE0=$$GETOE^SDOE(SDOE) Q:$P(SDOE0,U,6)  Q:$P(SDOE0,U,12)=12
 ..S SC=$P(SDOE0,U,4) Q:'SC  Q:'$$DIV(+$P(SDOE0,U,11))
 ..S SC0=$G(^SC(SC,0)) Q:'$L($P(SC0,U))
 ..Q:$P(SC0,U,17)="Y"  Q:'$$CPAIR^BSDCCR1(SC0,.SDCP)
 .. ;
 .. ;IHS/ANMC/LJF 8/24/2001 check clinic for summary report too
 ..;I SDFMT="D",'SDEX S SDQUIT=0 D  Q:SDQUIT
 ..;.I SDSORT="CL",'$D(SDSORT($P(SC0,U))) S SDQUIT=1 Q
 ..;.I SDSORT="CP",'$D(SDSORT(SDCP)) S SDQUIT=1
 ..;.Q
 ..I SDSORT="CL",'$D(SDSORT($P(SC0,U))) S SDQUIT=1 Q
 ..I SDSORT="CP",'$D(SDSORT(SDCP)) S SDQUIT=1
 .. ;IHS/ANMC/LJF 8/24/2001 end of mods
 .. ;
 ..S SDIV=$$DIV^BSDCCR1(SC0)
 ..I '$D(^TMP("SD",$J,SDIV,SDCP,SC)) D ARRINI^BSDCCR1(SDCP,SC,MAX,SDPAST)
 ..S $P(^TMP("SD",$J,SDIV,SDCP),U,3)=$P(^TMP("SD",$J,SDIV,SDCP),U,3)+1
 ..S $P(^TMP("SD",$J,SDIV,SDCP,SC),U,3)=$P(^TMP("SD",$J,SDIV,SDCP,SC),U,3)+1
 ..Q:SDFMT'="D"  S X1=$P(SDT,"."),X2=SDBDT D ^%DTC S SDAY=X+1
 ..D ARRSET(SDCP,SC,SDAY) Q
 .Q
 Q
 ;
ARRSET(SDCP,SC,SDI) ;Set daily counts into array
 ;Input: SDCP=credit pair
 ;Input: SC=clinic ifn
 ;Input: SDI=number of days from report date
 N SDS,SDP,SDX
 S SDS=SDI-1\12,SDP=SDI#12 S:SDP=0 SDP=12
 S SDX=$P(^TMP("SD",$J,SDIV,SDCP,SC,SDS),U,SDP)
 S:'$L(SDX) SDX="0~0~0"
 S $P(SDX,"~",3)=$P(SDX,"~",3)+1
 S $P(^TMP("SD",$J,SDIV,SDCP,SC,SDS),U,SDP)=SDX
 Q
 ;
DIV(SDIV) ;Evaluate division
 Q:'SDDIV 1  Q $D(SDDIV(SDIV))
 ;
CL ;Evaluate list of clinics
 N SDCNAM,SC0,SDIV S SDI=0
 S SDCNAM="" F  S SDCNAM=$O(SDSORT(SDCNAM)) Q:SDCNAM=""!SDOUT  D
 .S SDI=SDI+1 I SDI#10=0 D STOP Q:SDOUT
 .S SC=SDSORT(SDCNAM),SC0=$G(^SC(SC,0)) Q:'$$DIV(+$P(SC0,U,15))
 .S SDX=$$CLINIC^BSDCCR1(SC,SDFMT,SDBDT,SDEDT,MAX,SDPAST)
 .I $P(SDX,U,3)=-1 D
 ..S SDIV=$$DIV^BSDCCR1(SC0)
 ..S:$L(SDIV) $P(^TMP("SD",$J,SDIV,SDCNAM),U,3)=$P(SDX,U,3,4) Q
 .Q
 Q
 ;
CP ;Evaluate list of credit pairs
 N SDCCP,SC,SC0 S SC=0
 F  S SC=$O(^SC(SC)) Q:'SC!SDOUT  D
 .S SC0=$G(^SC(SC,0)) Q:'$$DIV(+$P(SC0,U,15))
 .Q:$P(SC0,U,3)'="C"   ;IHS/ANMC/LJF 12/13/2001 must be a clinic
 .Q:$P(SC0,U,7)=""     ;IHS/ANMC/LJF 04/11/2002 must have clinic code
 .Q:'$$CPAIR^BSDCCR1(SC0,.SDCCP)!'$D(SDSORT(SDCCP))
 .S SDX=$$CLINIC^BSDCCR1(SC,SDFMT,SDBDT,SDEDT,MAX,SDPAST)
 .Q
 Q
 ;
STOP ;Check for stop task request
 S:$D(ZTQUEUED) (SDOUT,ZTSTOP)=$S($$S^%ZTLOAD:1,1:0) Q
 ;
HINI ;Initialize header variables
 N %,%H,%I,X,X1,X2
 ;S SDLINE="",$P(SDLINE,"-",$S(SDPAST:131,1:(SDIOM+1)))="",SDPAGE=1,SDPG=0  ;IHS/ANMC/LJF 10/6/2000
 S SDLINE="",$P(SDLINE,"-",$S(SDPAST:80,1:(SDIOM+1)))="",SDPAGE=1,SDPG=0  ;IHS/ANMC/LJF 10/6/2000
 D NOW^%DTC S Y=% X ^DD("DD") S SDPNOW=$P(Y,":",1,2)
 ;S SDTITL="<*>  Clinic Appointment Availability Report  <*>"  ;IHS/ANMC/LF 10/6/2000
 S SDTITL="<*>  Clinic Appointment Capacity Report  <*>"  ;IHS/ANMC/LJF 10/6/2000
 Q
 ;
HDR(SDTY,SDIV,SDCP,SC) ;Print header
 ;Input: SDTY=type of header where:
 ;            '0'=negative report
 ;            '1'=detailed report
 ;            '2'=division summary
 ;            '3'=facility summary
 ;Input: SDIV=division name^division number
 ;Input: SDCP=credit pair
 ;Input: SC=clinic ifn
 ;
 Q:SDOUT
 I $G(SDXM) D HDRXM^BSDCCR3 Q
 I $E(IOST)="C",SDPAGE>1 N DIR S DIR(0)="E" W ! D ^DIR S SDOUT=Y'=1 Q:SDOUT
 N SDX,SDI D STOP Q:SDOUT
 W:SDPG!($E(IOST)="C") $$XY^SCRPW50(IOF,1,0) W:$X $$XY^SCRPW50("",0,0)
 W SDLINE,!?(SDIOM-$L(SDTITL)\2),SDTITL
 D HDRX(SDTY) Q:SDOUT  S SDI=0
 F  S SDI=$O(SDTIT(SDI)) Q:'SDI  W !?(SDIOM-$L(SDTIT(SDI))\2),SDTIT(SDI)
 W !,SDLINE,!,"For clinic availability dates ",SDPBDT," through ",SDPEDT
 W !,"Date printed: ",SDPNOW,?(SDIOM-6-$L(SDPAGE)),"Page: ",SDPAGE
 W !,SDLINE S SDPAGE=SDPAGE+1,SDPG=1 D:SDTY SUBT(SDTY) Q
 ;
HDRX(SDTY) ;Extra header lines
 K SDTIT
 Q:SDTY=0  S SDIV=$G(SDIV)
 I SDTY=3 S SDTIT(1)="Facility Summary" Q
 N SDDV S SDDV=$P(SDIV,U)_" ("_$P(SDIV,U,2)_")"
 I SDTY=2 S SDTIT(1)="Summary for division: "_SDDV Q
 S SDTIT(1)="Division: "_SDDV
 ;S:SDSORT="CP" SDTIT(2)="For clinics with credit pair: "_$$OTX^BSDCCR3("CP")  ;IHS/ANMC/LJF 10/6/2000
 S:SDSORT="CP" SDTIT(2)="For clinics with clinic code: "_$$OTX^BSDCCR3("CP") S SDTIT(3)="Detail for clinic: "_$$OTX^BSDCCR3("CL")  ;IHS/ANMC/LJF 10/6/2000
 Q
 ;
SUBT(SDTY) ;Print subtitles
 D SUBT^BSDCCRL(SDTY) Q  ;IHS/ANMC/LJF 10/6/2000
 N SDI
 W !?(SDCOL+44),"Avail.",?(SDCOL+54),"Pct."
 I SDPAST F SDI=0:1:3 W ?(SDCOL+68+(16*SDI)),"---Type '",SDI,"'---"
 W ! W:SDTY>1 ?(SDCOL),"Credit Pair"
 W ?(SDCOL+36),"Clinic",?(SDCOL+45),"Appt.",?(SDCOL+53),"Slots"
 W:SDPAST ?(SDCOL+60),"Clinic"
 I SDPAST F SDI=0:1:3 W ?(SDCOL+68+(16*SDI)),"Sched.    Wait"
 W !?(SDCOL+4),$S(SDTY=1:"Availability Date",1:"Clinic Name")
 W ?(SDCOL+34),"Capacity",?(SDCOL+45),"Slots",?(SDCOL+52),"Avail."
 W:SDPAST ?(SDCOL+62),"Enc."
 I SDPAST F SDI=0:1:3 W ?(SDCOL+68+(16*SDI)),"Appts.    Time"
 W !?($S(SDTY>1:SDCOL,1:SDCOL+4)),$E(SDLINE,1,($S(SDPAST:130,1:58)-$S(SDTY=1:4,1:0)))
 Q
 ;
EXTRACT ;Gather data for extract
 N SDBEG,SDEND,SDTIME,SDCP,SDX,SC,SCNA,SDI,SDFMT,SDOUT,SDXM,SDIOM
 N SDEXDT,MAX,X1,X2,X S SDIOM=$G(IOM,80)
 S (SDOUT,SDCOL)=0,SDFMT="D",SDBEG=$H,SDEXDT=DT D INIT^BSDCCR1
 K ^TMP("SD",$J),^TMP("SDS",$J),^TMP("SDTMP",$J),^TMP("SDXM",$J)
 S X1=SDEDT,X2=SDBDT D ^%DTC S MAX=X+1
 ;
 ;Get encounter workload
 I SDPAST D OE(SDBDT,SDEDT_.9999,MAX,1)  ;encounter workload
 ;
 ;Get clinic availability data
 S SC=0 F  S SC=$O(^SC(SC)) Q:'SC  S SC0=$G(^SC(SC,0)) D
 .S SDX=$$CLINIC^BSDCCR1(SC,SDFMT,SDBDT,SDEDT,MAX,SDPAST)
 .Q
 ;
 ;Get next available wait times
 S SDMD=$O(^TMP("SD",$J,"")),SDMD=$O(^TMP("SD",$J,SDMD)),SDMD=$L(SDMD)
 I SDPAST D NAVA^BSDCCR5(SDBDT,SDEDT_.9999,1)  ;next ava. wait times
 ;
 ;Order by clinic, send extract data to Austin
 D ORD,TXXM^BSDCCR0 K ^TMP("SDXM",$J)
 ;
 ;Send summary bulletin to mail group
 S SDFMT="S",SDEND=$H,SDTIME=$$TIME(SDBEG,SDEND)
 S SDBEG=$$HTE^XLFDT(SDBEG),SDEND=$$HTE^XLFDT(SDEND)
 S SDY="*** Clinic Appointment "_$S(SDPAST:"Utilization",1:"Availability")_" Extract ***"
 S SDXM=1,SDX="",$E(SDX,(79-$L(SDY)\2))=SDY D XMTX^BSDCCR3(SDX)
 D XMTX^BSDCCR3(" ")
 D XMTX^BSDCCR3("                   For date range: "_SDPBDT_" to "_SDPEDT)
 D XMTX^BSDCCR3("               Extract start time: "_SDBEG)
 D XMTX^BSDCCR3("                 Extract end time: "_SDEND)
 D XMTX^BSDCCR3("                 Extract run time: "_SDTIME)
 F SDI=1:1:4 D XMTX^BSDCCR3("")
 D PRT^BSDCCR3(SDXM),EXXM^BSDCCR0("G.SC CLINIC WAIT TIME")
 G EXIT^BSDCCR4
 ;
TIME(SDBEG,SDEND) ;Calculate length of run time
 ;Input: SDBEG=start time in $H format
 ;Input: SDEND=end time in $H format
 ;Output: text formatted string with # days, hours, minutes and seconds
 N X,Y
 S SDEND=$P(SDEND,",")-$P(SDBEG,",")*86400+$P(SDEND,",",2)
 S SDBEG=$P(SDBEG,",",2),X=SDEND-SDBEG,Y("D")=X\86400
 S X=X#86400,Y("H")=X\3600,X=X#3600,Y("M")=X\60,Y("S")=X#60
 S Y("D")=$S('Y("D"):"",1:Y("D")_" day"_$S(Y("D")=1:"",1:"s")_", ")
 S Y("H")=Y("H")_" hour"_$S(Y("H")=1:"",1:"s")_", "
 S Y("M")=Y("M")_" minute"_$S(Y("M")=1:"",1:"s")_", "
 S Y("S")=Y("S")_" second"_$S(Y("S")=1:"",1:"s")
 Q Y("D")_Y("H")_Y("M")_Y("S")
