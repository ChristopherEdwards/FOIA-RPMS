ASDPC ; IHS/ADC/PDW/ENM - principal clinic make appt. ;  [ 01/29/2003  1:20 PM ]
 ;;5.0;IHS SCHEDULING;**8**;MAR 25, 1999
 ;1/28/03 WAR - Patch 8
 ;
 I '$D(DUZ(2)) Q
 NEW SDPC D DT^DICRW
 ;
 S DIC="^SC(",DIC(0)="AEMZQ",DIC("A")="Select PRINCIPAL CLINIC NAME: "
 S DIC("S")="I $P(^(0),""^"",3)=""C"",'$D(^(9,""B"",$I)),$D(^SC(""AIHSPC"",+Y))"
 D ^DIC K DIC I Y<0 Q
 S SDPC=+Y
 ;
EN ;EP; called by SDM with SDPC set
 NEW SDAY,SDX,SDN,SDD,Y,Z,SDSLOT
 S %DT="AE",%DT("A")="Enter EARLIEST POSSIBLE APPT DATE: "
 S %DT("B")="TODAY",X="" D ^%DT S SDAY=Y
 ;
 S %DT="AE",%DT("A")="Enter LATEST POSSIBLE APPT DATE: "
 S %DT("B")="T+15",X="" D ^%DT S SDEND=Y+.2400 W !!
 ;
SC S (SDN,SDCNT)=0 F  S SDN=$O(^SC("AIHSPC",SDPC,SDN)) Q:'SDN  D DAY
 W ! Q
 ;
DAY S SDD=SDAY-.001,Z="",SDSLOT=0
 F  S SDD=$O(^SC(SDN,"ST",SDD)) Q:'SDD  Q:SDD>SDEND  Q:SDSLOT  D
 . S SDX=0
 . F  S SDX=$O(^SC(SDN,"ST",SDD,SDX)) Q:'SDX  Q:+SDSLOT  D
 ..;1/28/03 WAR changed next line from '6' to '5'
 ..; S Z=$E(^SC(SDN,"ST",SDD,SDX),6,$L(^SC(SDN,"ST",SDD,SDX)))
 .. S Z=$E(^SC(SDN,"ST",SDD,SDX),5,$L(^SC(SDN,"ST",SDD,SDX)))
 .. Q:Z["CANCELLED"
 .. I (Z'["|"),(Z'["[") Q
 ..;1/28/03 WAR REM'd the next 5 lines and added the $TR
 ..; I Z["|" S SDSLOT=$P(Z,"|",2,999)  ;1/28/03 WAR REM'd
 ..; I Z'["|" S SDSLOT=$E(Z,6,999)  ;1/28/03 WAR REM'd
 ..; F I="|","[","]","*"," ","0" S SDSLOT=$$STRIP^XLFSTR(SDSLOT,I)
 ..; F I="A","B","C","D","E","F" S SDSLOT=$$STRIP^XLFSTR(SDSLOT,I)
 ..; F I="j","k","l","m","n","o" S SDSLOT=$$STRIP^XLFSTR(SDSLOT,I)
 .. S SDSLOT=$TR(Z,"|[@#]!$* ABCDEFXjklmno",0)  ;1/28/03 WAR added
 .. Q:+SDSLOT<1
 .. S Y=SDD X ^DD("DD")
 .. W !,$P(^SC(SDN,0),U,1),?25,Y,!,^SC(SDN,"ST",SDD,SDX)
 .. S SDCNT=SDCNT+2 I SDCNT>18 D
 ... K DIR S DIR(0)="E",DIR("A")="Press RETURN for more choices"
 ... D ^DIR K DIR S SDCNT=0
 Q
