APCLGCDC ; IHS/CMI/LAB - APCL Visits to General and Dental Clinic (Same Day) ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/CMI/LAB - new report per task order
 ;
 ;this routine will print a list of visits that had a general clinic
 ;and dental clinic visit on the same day
 ;
MAIN ;-- this is the main routine driver       
 W:$D(IOF) @IOF
 W !,"This report will produce a list of patients who have had a dental clinic",!,"visit and a general clinic visit on the same day.",!!
 D DTR G XIT:Y<0
 S XBRP="PRT^APCLGCDC",XBRC="SORT^APCLGCDC"
 S XBRX="XIT^APCLGCDC",XBNS="APCL"
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G MAIN
 D ^XBDBQUE
 D XIT
 Q
 ;
DTR ;-- get the date range
 S %DT="AE",%DT("A")="Enter the Beginning Date: "
 D ^%DT
 Q:Y<0
 S APCLBDT=+Y
 S APCLSBDT=APCLBDT-.00001
 K %DT
 S %DT="AE",%DT("A")="Enter the End Date: "
 D ^%DT
 Q:Y<0
 S APCLEDT=+Y
 S APCLSEDT=APCLEDT+.99999
 K %DT
 K DIR
 ;
 S APCLLOC=$$GETLOC^APCLOCCK
 I APCLLOC=-1 S Y=-1
 Q
 ;
SORT ;-- get loop through the visit file
 S APCLH=$H,APCLJ=$J
 S APCLDESC="Visits to General Clinic and Dental Clinic on same day"
 S ^XTMP("APCLGCDC",APCLJ,APCLH,0)=$$DT14_U_DT_U_APCLDESC
 S APCLGEN=$O(^DIC(40.7,"B","GENERAL",0))
 S APCLDEN=$O(^DIC(40.7,"B","DENTAL",0))
 S APCLDA=APCLSBDT F  S APCLDA=$O(^AUPNVSIT("B",APCLDA)) Q:APCLDA>APCLSEDT!(APCLDA="")  D
 . S APCLDFN=0 F  S APCLDFN=$O(^AUPNVSIT("B",APCLDA,APCLDFN)) Q:APCLDFN=""  D
 .. Q:'$D(^AUPNVSIT(APCLDFN,0))
 .. Q:$P(^AUPNVSIT(APCLDFN,0),U,5)=""
 .. Q:$$DEMO^APCLUTL($P(^AUPNVSIT(APCLDFN,0),U,5),$G(APCLDEMO))
 .. Q:$P(^AUPNVSIT(APCLDFN,0),U,8)=""
 .. I $$CHKLOC^APCLOCCK(APCLLOC,$P(^AUPNVSIT(APCLDFN,0),U,6))=0 Q
 .. S APCLVDT=$P(APCLDA,".")
 .. S APCLPAT=$P(^(0),U,5)
 .. S APCLCLN=$P(^(0),U,8)
 .. I APCLCLN=APCLGEN S $P(^TMP("APCLGCDC",$J,APCLPAT,APCLVDT),U)=1
 .. I APCLCLN=APCLDEN S $P(^TMP("APCLGCDC",$J,APCLPAT,APCLVDT),U,2)=1
 S APCLTP=0 F  S APCLTP=$O(^TMP("APCLGCDC",$J,APCLTP)) Q:APCLTP=""  D
 . S APCLTV=0 F  S APCLTV=$O(^TMP("APCLGCDC",$J,APCLTP,APCLTV)) Q:APCLTV=""  D
 .. I $P(^TMP("APCLGCDC",$J,APCLTP,APCLTV),U),$P(^TMP("APCLGCDC",$J,APCLTP,APCLTV),U,2) S ^XTMP("APCLGCDC",APCLJ,APCLH,APCLTV,APCLTP)=""
 Q
 ;
PRT ;-- print out the routine
 D XHDR
 I '$D(^XTMP("APCLGCDC",APCLJ,APCLH)) W !!,"No visits to report." G EOJ
 S APCLXV=0 F  S APCLXV=$O(^XTMP("APCLGCDC",APCLJ,APCLH,APCLXV)) Q:APCLXV=""!$D(DIRUT)  D
 . S APCLXP=0 F  S APCLXP=$O(^XTMP("APCLGCDC",APCLJ,APCLH,APCLXV,APCLXP)) Q:APCLXP=""!$D(DIRUT)  D
 .. D:$Y+2>IOSL HDR Q:$D(DIRUT)
 .. W !,$$FMTE^XLFDT(APCLXV),?20,$$VAL^XBDIQ1(2,APCLXP,.01)
 .. W ?55,$$HRN^AUPNPAT(APCLXP,DUZ(2))
 ;
EOJ ;
 K ^XTMP("APCLGCDC",APCLJ,APCLH)
 K APCLH,APCLJ
 Q
 ;
HDR ;-- report header
 I $E(IOST,1,1)="C" S DIR(0)="E" D ^DIR I Y<1 S DIRUT=1 Q
XHDR W @IOF
 W !,?16,"General Clinic and Dental Clinic Visits (Same Day)"
 S APCLLOCT=$S(APCLLOC=0:"ALL",1:"SELECTED")
 S APCLLENG=21+$L(APCLLOCT)
 W !,?((80-APCLLENG)/2),"Location of Visits:  ",APCLLOCT
 W !!,"Date Range: "_$$FMTE^XLFDT(APCLBDT)_" to "_$$FMTE^XLFDT(APCLEDT)
 W !
 W !,"Visit Date",?20,"Patient Name",?55,"Chart #",!
 F XI=1:1:80 W "-"
 Q
 ;
XIT ;-- kill variables and quit
 K APCLBDT,APCLCLN,APCLDA,APCLDEN,APCLDESC,APCLDFN,APCLEDT,APCLGEN
 K APCLPAT,APCLSEDT,APCDTP,APCLTV,APCLVDT,APCLXP,APCLXV,APCLSBDT
 K X,X1,X2,XBNS,XBRC,XBRP,XBRX,XI,Y,APCLTP
 K ^TMP("APCLGCDC",$J)
 Q
 ;
DT14() ;-- return 14 days in the future
 S X1=DT,X2=+14 D C^%DTC
 Q X
 ;
