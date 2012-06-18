APSPLOC ; IHS/DSD/ENM - OUTPATIENT PHARMACY INVENTORY/LOCATION ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
EN ;EP
 K ^TMP("APSPIL",$J)
 W @IOF,!!,"Outpatient Pharmacy Inventory Location!",!!
DIV ;SELECT DIVISION
 ;S DIR(0)="Y",DIR("A")="Would you like all divisions",DIR("B")="YES",DIR("?")="Enter 'Yes' or 'No'" D ^DIR K DIR Q:$D(DTOUT)
 ;I X="YES" S APSPDAN="A" G DRU
 ;S DIR(0)="PO^59:EMZ",DIR("A")="Select Division",DIR("?")="Enter the Division Name or Number "
 ;D ^DIR G:$D(DTOUT)!$D(DUOUT) ZAP K DIR
 S APSPDAN=PSOSITE
DRU S DIR(0)="S^1:All Drugs;2:Controlled Drugs Only;",DIR("A")="Select: (1) or (2)" D ^DIR K DIR
 G:$D(DUOUT)!$D(DIRUT) ZAP S APSPANS=Y,APSPTYPE=Y(0)
 ;--------
DEV K %DT,%ZIS,IOP,ZTSK S PSOION=ION,%ZIS("A")="Select Printer: ",%ZIS="QM" D ^%ZIS
 I POP S IOP=PSOION D ^%ZIS U IO K DVCNT,IOP,PSOION W !,*7,*7,"Report not Queued!" G ZAP
 I $D(IO("Q")),IO=0 W !,"Queueing to your screen is not allow! " K IO("Q") G DEV
 I IO=IO(0)!('$D(IO("Q"))) G AUS
 I $D(IO("Q")) S ZTRTN="AUS^APSPLOC"
 S ZTDESC="Drug Inventory Location"
 F G="ZTDESC","APSPDAN","APSPANS","APSPTYPE" S:$D(@G) ZTSAVE(G)=""
 I  K IO("Q") D ^%ZTLOAD W:$D(ZTSK) !,"Report Queued !" K G,Y,X,%DT G ZAP
 ;----------------------------------------------
AUS U IO
 S APSPA=0,APSPA1=0,APSP("PAGE")=0,APSP("IOF")=0
 F  S APSPA=$O(^PSDRUG(APSPA)) Q:'APSPA  S APSPSH=$P($G(^PSDRUG(APSPA,0)),U,3) D LIST
CON S APSPDN=""
 D SHOW
 D ZAP
 Q
HDR ;
 S APSPDIV=$P($G(^PS(59,APSPDAN,0)),U)
 D NOW^%DTC S Y=X X ^DD("DD") S APSP("PAGE")=APSP("PAGE")+1
 W @IOF
 W "Outpatient Pharmacy Inventory Location",?50,"Page ",APSP("PAGE"),?65,Y,!,"For """,APSPTYPE,"""",!,"Division: ",APSPDIV,! ;S:'APSP("IOF") APSP("IOF")="1"
 W ?40,"Dispensing",?65,"Storage",!,"Drug Name",?40,"Location",?65,"Location",!,"----------",?40,"----------------------",?65,"--------",!
 Q
LIST ;
 Q:$D(^PSDRUG(APSPA,"I"))
 I APSPANS=2&("2345"[+APSPSH) D SAV Q
 I APSPANS=1 D SAV
 Q
SHOW ;
 D HDR,SHOW1
 Q
SHOW1 F  S APSPDN=$O(^TMP("APSPIL",$J,APSPDN)) Q:APSPDN=""  S APSPDL=$P(^(APSPDN),U),APSPBS=$P(^(APSPDN),U,2) D LIST1 Q:$D(DUOUT)!($D(DTOUT))
 Q
LIST1 ;
 I $Y+4>IOSL,IOST["C" D FZZ Q:$D(DUOUT)!($D(DTOUT))
 I $Y+4>IOSL D HDR
 W !,APSPDN,?40,APSPDL,?65,APSPBS
 Q
SAV S APSPDN=$P(^PSDRUG(APSPA,0),U),APSPDL=$P($G(^PSDRUG(APSPA,9999999)),U,5),APSPBS=$P($G(^(9999999)),U,6)
 S ^TMP("APSPIL",$J,APSPDN)=APSPDL_"^"_APSPBS
 Q
FZZ ;IHS/DSD/ENM 10/95
 K DTOUT,DUOUT,DIR S DIR("?")="Enter '^' to Halt or Press Return to Continue",DIR(0)="FO",DIR("A")="Press 'RETURN' to Continue or '^' to 'HALT'" D ^DIR
 Q
ZAP ;
 D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" ;IHS/DSD/ENM 12.95
 K APSPANS,APSPA,APSPCI,APSPDN,APSPDU,APSP("PAGE"),APSPTYPE,^TMP("APSPIL",$J),APSPDL,APSPBS,APSPDAN,APSP("IOF"),APSPDIV,APSPSH
 Q
