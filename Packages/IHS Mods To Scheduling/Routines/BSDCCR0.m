BSDCCR0 ; IHS/ANMC/LJF - CLINIC CAPACITY REPORT ; 
 ;;5.3;PIMS;**1011**;APR 26, 2002
 ;IHS modified COPY OF SCRPW70 before VA patch #223
 ;IHS/ANMC/LJF 10/06/2000 removed message about 132 columns
 ;                        changed report title
 ;                        expanded clinic list if princ clinic chosen
 ;                        used IHS call for clinic code question
 ;
 ;cmi/flag/maw 11/9/2009 PATCH 1011 added call to CLINIC^BSDU so taxonomy can be called
 ;
 ;
 N SDEX,SDDIV,DIR,SDFMT,SDMAX,SDSORT,SDOUT,X,Y,DTOUT,DUOUT
 S (SDEX,SDOUT)=0
 ;D TITL^SCRPW50("Clinic Appointment Availability Report")  ;IHS/ANMC/LJF 10/6/2000
 D TITL^SCRPW50("Clinic Appointment Capacity Report")  ;IHS/ANMC/LJF 10/6/2000
 I '$$DIVA^SCRPW17(.SDDIV) S SDOUT=1 G EXIT^BSDCCR4
 D SUBT^SCRPW50("**** Date Range Selection ****")
 W ! S %DT="AEX",%DT("A")="Beginning date: " D ^%DT I Y<1 S SDOUT=1 G EXIT^BSDCCR4
 S SDBDT=Y X ^DD("DD") S SDPBDT=Y
EDT S %DT("A")="   Ending date: " W ! D ^%DT I Y<1 S SDOUT=1 G EXIT^BSDCCR4
 I Y<SDBDT W !!,$C(7),"End date cannot be before begin date!",! G EDT
 S SDEDT=Y_.999999 X ^DD("DD") S SDPEDT=Y
 S SDMAX=Y D SUBT^SCRPW50("**** Report Format Selection ***")
 S DIR(0)="S^S:SUMMARY FOR DATE RANGE;D:DETAIL BY DAY",DIR("A")="Select report format"
 W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S SDOUT=1 G EXIT^BSDCCR4
 ;S SDFMT=Y G:SDFMT="S" QUE S DIR("B")="CLINIC NAME"
 S SDFMT=Y S DIR("B")="CLINIC NAME"
 ;
 ;IHS/ANMC/LJF 10/6/2000 modified lines below
 ;S DIR(0)="S^CL:CLINIC NAME;CP:CREDIT PAIR",DIR("A")="Specify limiting category for detail"
 ;S DIR("?")="Indicate if availability should be limited by clinic name or DSS credit pair."
 S DIR(0)="S^CL:CLINIC NAME;CC:CLINIC CODE",DIR("A")="Specify limiting category for detail"
 S DIR("?")="Indicate if availability should be limited by clinic name or clinic stop code."
 ;IHS/ANMC/LJF 10/6/2000 end of code changes
 ;
 W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S SDOUT=1 G EXIT^BSDCCR4
 S SDSORT=Y I '$$SORT(.SDSORT) S SDOUT=1 G EXIT^BSDCCR4
 G:SDOUT EXIT^BSDCCR4
QUE ;I SDBDT'>DT W !!,"This report requires 132 column output!"  ;IHS/ANMC/LJF 10/6/2000
 N ZTSAVE F X="SDEX","SDBDT","SDPBDT","SDEDT","SDPEDT","SDDIV","SDDIV(","SDFMT","SDSORT","SDSORT(" S ZTSAVE(X)=""
 W ! D EN^XUTMDEVQ("START^BSDCCR2","Clinic Appointment Availability Report",.ZTSAVE) S SDOUT=1 G EXIT^BSDCCR4
 ;
SORT(SDSORT) ;Gather sort values for detailed report
 ;Input: SDSORT=sort category (pass by reference)
 ;Output: '1' if selection(s) made, '0' otherwise
 ;        SDSORT(clinic name)=clinic ifn 
 ;                    (or)
 ;        SDSORT(credit pair)=credit pair
 ;
 I SDSORT="CC" S SDSORT="CP"  ;IHS/ANMC/LJF 10/6/2000
 D @SDSORT Q $D(SDSORT)>1
 ;
CL ;Select clinics for detail
 N SDQUIT S (SDQUIT,SDOUT)=0
 ;N DIC,SDQUIT S (SDQUIT,SDOUT)=0
 ;S DIC="^SC(",DIC(0)="AEMQ",DIC("A")="Select CLINIC: ",DIC("S")="I $P(^(0),U,3)=""C"""
 ;W ! F  Q:SDOUT!SDQUIT  D
 ;.D ^DIC I $D(DTOUT)!$D(DUOUT) S SDOUT=1 Q
 ;.I X="" S SDQUIT=1 Q
 ;.I Y S SDSORT($P(Y,U,2))=+Y
 ;.Q
 D CLINIC^BSDU(1)
 N SDA
 S SDA=0 F  S SDA=$O(VAUTC(SDA)) Q:SDA=""  D
 . S SDSORT(SDA)=$G(VAUTC(SDA))
 D EXPNDPC^BSDU(1,.SDSORT)  ;IHS/ANMC/LJF 10/6/2000
 Q
 ;
CP ;Get credit pairs for detail
 D CP^BSDCCRL Q  ;IHS/ANMC/LJF 10/6/2000
 N DIR,SDQUIT S (SDQUIT,SDOUT)=0
 S DIR(0)="NO:101000:999000:0",DIR("A")="Select clinic DSS credit pair"
 S DIR("?",1)="Specify a six digit number that represents the primary and secondary stop"
 S DIR("?",2)="code of clinics you wish to evaluate.  For clinics that do not have a"
 S DIR("?",3)="secondary stop code, enter ""000"" as the second half of the credit pair"
 S DIR("?")="(eg. ""323000"")."
 W ! F  Q:SDOUT!SDQUIT  D
 .D ^DIR I $D(DTOUT)!$D(DUOUT) S SDOUT=1 Q
 .I X="" S SDQUIT=1 Q
 .I '$$VCP(Y) W "  Invalid credit pair!" Q
 .S SDSORT(Y)=Y
 .Q
 Q
 ;
VCP(Y) ;Validate credit pair
 ;Input: Y=credit pair
 ;Output: '1' if valid, '0' otherwise
 Q:Y'?6N 0
 Q:'$D(^DIC(40.7,"C",$E(Y,1,3))) 0
 Q:$E(Y,4,6)="000" 1
 Q:'$D(^DIC(40.7,"C",$E(Y,4,6))) 0
 Q 1
 ;
RESEND ;Entry point for manually initiating extracts for the current month
 N DIR,SDXTMP,SDMON,SDI,SDT
 W !!,$C(7),"NOTE:  Use of this utility will result in the transmission of extract data to"
 W !,"Austin.  It should only be used if automatically queued extracts failed to run."
 M SDXTMP=^XTMP("SD53P192") D QDIS^BSDCCR4(.SDXTMP)
 F SDI=1,2 I $G(SDXTMP("EXTRACT",SDI,"DATE"))<DT D  Q:$D(DTOUT)!$D(DUOUT)
 .W !!,"Extract ",SDI," doesn't appear to be tasked to run repetitively in the future."
 .S DIR(0)="Y",DIR("A")="Do you wish to schedule it now",DIR("B")="YES"
 .W ! D ^DIR Q:$D(DTOUT)!$D(DUOUT)  D:Y RQUE(SDI)
 .Q
 Q:$D(DTOUT)!$D(DUOUT)
 S DIR(0)="Y",DIR("B")="NO"
 F SDI=1,2 D  Q:$D(DTOUT)!$D(DUOUT)
 .S SDT=DT S:SDI=1 SDT=$S($E(SDT,4,5)="01":$E(SDT,1,3)-1_12_$E(SDT,6,7),1:$E(SDT,1,5)-1_$E(SDT,6,7))
 .S DIR("A")="Do you want transmit Extract "_SDI_" for "_$P($$MON^BSDCCR4(SDI,SDT,.SDMON),U)_" to Austin"
 .W ! D ^DIR Q:$D(DTOUT)!$D(DUOUT)  D:Y QUEUE(.SDMON)
 .Q
 Q
 ;
REQUE ;Entry point for initiating repetitive tasking of extracts
 N DIR,SDXTMP
 M SDXTMP=^XTMP("SD53P192") D QDIS^BSDCCR4(.SDXTMP)
 I '$D(SDXTMP) D  W ! D ^DIR Q:$D(DTOUT)!$D(DUOUT)  I Y D RQUE("B") Q
 .S DIR(0)="Y",DIR("A")="Do you want to schedule both extracts now"
 .S DIR("B")="YES"
 .Q
 Q:$D(DTOUT)!$D(DUOUT)  K DIR
 S DIR(0)="S^1:EXTRACT 1 (PROSPECTIVE);2:EXTRACT 2 (RETROSPECTIVE);B:BOTH EXTRACTS"
 S DIR("?",1)="Extract 1 returns future clinic availability, extract 2 returns previous",DIR("?")="clinic availability and utilization."
 S DIR("A")="Specify which extract you wish to schedule"
 W ! D ^DIR Q:$D(DTOUT)!$D(DUOUT)  D RQUE(Y)
 Q
 ;
RQUE(SDEX) ;Schedule extract for repetitive run
 ;Input: SDEX=extract type, '1', '2' or 'B' for both
 I SDEX="B" D RQUE(1) Q:$D(DTOUT)!$D(DUOUT)  D RQUE(2) Q
 N SDMON,SDNOW,SDOUT,DIR,Y,SDT
 S SDNOW=$$NOW^XLFDT(),SDOUT=0,Y=$G(SDXTMP("EXTRACT",SDEX,"DATE"))
 I Y>SDNOW D  Q:$D(DTOUT)!$D(DUOUT)  Q:SDOUT
 .W !!,"Extract ",SDEX," appears to be queued for the future--"
 .X ^DD("DD") W !!,"Scheduled for: ",Y,", task number: ",$G(SDXTMP("EXTRACT",SDEX,"TASK"))
 .S DIR(0)="Y",DIR("B")="NO"
 .S DIR("A")="Do you want to delete this task and re-schedule extract "_SDEX
 .W ! D ^DIR Q:$D(DTOUT)!$D(DUOUT)  S SDOUT='Y
 .Q:'Y  S ZTSK=$G(SDXTMP("EXTRACT",SDEX,"TASK")) D KILL^%ZTLOAD
 .K ^XTMP("SD53P192","EXTRACT",SDEX) Q
 S SDT=$$WHEN^BSDCCR4(SDEX),SDRPT=$$MON^BSDCCR4(SDEX,SDT,.SDMON)
 D SCHED^BSDCCR4(SDEX,SDT,SDRPT,.SDMON) Q
 ;
QUEUE(SDMON) ;Queue extraction for re-run
 ;Input: SDMON=array of input parameters (as described in MON^BSDCCR4)
 N %DT,SDI,Y,ZTSK,ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTSAVE
 S Y=DT_.22 X ^DD("DD") S %DT("B")=Y,%DT("A")="Queue to run: "
 S %DT="AEFXR" W ! D ^%DT I Y<1 G QQ
 S ZTDTH=Y,ZTSAVE("SDMON(")="",ZTRTN="RUN^BSDCCR4(0)",ZTIO=""
 S ZTDESC="Clinic Appointment Wait Time Extract ("_SDMON("SDEX")_")"
 F SDI=1:1:20 D ^%ZTLOAD Q:$G(ZTSK)
 ;
QQ I '$G(ZTSK) W !!,"Extract not queued!!!",! Q
 W !!,"Task number: ",ZTSK,! Q
 ;
TXXM ;Transmit extract data
 N SDFAC,SDL,SDIV,SDCP,SC,SDI,SDX,SDEX,SDY,SDZ,SDP,SDSIZE,SDMG
 S SDFAC=$P($$SITE^VASITE(),U,3),SDXM=1,SDL=0,SDIV="",SDSIZE=0
 S SDEX=$S(SDPAST:2,1:1),SDMG=$P($G(^SD(404.91,1,"PATCH192")),U,(6+SDEX))
 S:SDMG="" SDMG="G.SC CLINIC WAIT TIME"
 F  S SDIV=$O(^TMP("SD",$J,SDIV)) Q:SDIV=""  S SDCP=0 D
 .F  S SDCP=$O(^TMP("SD",$J,SDIV,SDCP)) Q:'SDCP  S SC=0 D
 ..F  S SC=$O(^TMP("SD",$J,SDIV,SDCP,SC)) Q:'SC  D
 ...I SDSIZE>29000 D EXXM(SDMG)
 ...S SDX="#"_SDFAC_U_SDEXDT_U_SDEX_U_SDBDT_U_$P(SDIV,U,2)_U_SDCP_U_SC_U
 ...S SDI="" F  S SDI=$O(^TMP("SD",$J,SDIV,SDCP,SC,SDI)) Q:SDI=""  D
 ....S SDY=^TMP("SD",$J,SDIV,SDCP,SC,SDI) Q:'$L(SDY)
 ....F SDP=1:1 S SDZ=$P(SDY,U,SDP) Q:SDZ=""  D
 .....I $L(SDX)>220 D XMTX(SDX) S SDX=""
 .....S SDX=SDX_$S($E(SDX,$L(SDX))=U:"",1:"|")_SDZ
 .....Q
 ....Q
 ...I SDEX=1 S SDX=SDX_"$" D XMTX(SDX) Q
 ...S SDY=$G(^TMP("SDNAVA",$J,SDIV,SDCP,SC))  ;get next ava. info.
 ...S SDY=$$NAVA(SDY)
 ...I $L(SDX)+$L(SDY)>240 D XMTX(SDX) S SDX=""
 ...S SDX=SDX_SDY_"$" D XMTX(SDX)
 ...Q
 ..Q
 .Q
 D:$D(^TMP("SDXM",$J)) EXXM(SDMG)
 Q
 ;
EXXM(XMG) ;Send extract mail message
 ;Input: XMG=mail group to receive message
 N XMSUB,XMDUZ,XMDUN,XMTEXT,XMY,XMZ
 S XMSUB="Clinic Appointment Waiting Time Extract ("_SDEX_")"
 S (XMDUZ,XMDUN)="Patch SD*5.3*192",XMTEXT="^TMP(""SDXM"",$J,"
 S XMY(XMG)="" D ^XMD
 K ^TMP("SDXM",$J) S SDXM=1,SDSIZE=0
 Q
 ;
XMTX(SDX) ;Set mail message line
 ;Input: SDX=text value
 S ^TMP("SDXM",$J,SDXM)=SDX,SDXM=SDXM+1,SDSIZE=SDSIZE+$L(SDX)
 Q
 ;
NAVA(SDY) ;format next available appointment information
 ;Input: SDY=next ava. numbers from ^TMP("SDNAVA",$J,SDCP,SC)
 ;
 N SDI,SDX
 S SDX="^" F SDI=0:1:3 D
 .S:SDI SDX=SDX_"|"
 .S SDX=SDX_SDI_"~"_+$P(SDY,U,(SDI+SDI+1))_"~"_+$P(SDY,U,(SDI+SDI+2))
 .Q
 Q SDX
