FHADM2 ; HISC/REL/NCA/AAC - Enter/Edit Served Meals ;5/4/93  09:53
 ;;5.0;Dietetics;**39**;Oct 11, 1995
EN1 ; Enter/Edit Served Meals
 D NOW^%DTC S DT=%\1 K %,%H,%I
 S (ZZOUT,COMM)=0,ZOUT=$P($G(^FH(119.6,0)),"^",4)
 ;
E1 S %DT="AEPX",%DT("A")="SERVED MEALS Date: " W ! D ^%DT G KIL^FHADM21:"^"[X!$D(DTOUT),E1:Y<1
 ;
 S DA=+Y I DA'<DT W *7,!!,"** Input must be for a date before today in order to collect ADT data!",! G E1
 ;
 ;Enter Communications Office 
 K DIC,DIE S DIE="^FH(117," I '$D(^FH(117,DA,0)) S ^FH(117,DA,0)=DA,^FH(117,"B",DA,DA)="",X0=^FH(117,0),$P(^FH(117,0),"^",3,4)=DA_"^"_($P(X0,"^",4)+1)
 S DA=+Y I $G(^FH(117,DA,"I"))="Y" W !," ** INACTIVE COMM OFFICE **" Q
 S ^FH(117,DA,0)=DA
 S DR="[FHADM2]" D ^DIE
 Q
 ;
C1 ;
 K FHN W !!,"Calculating Census Values ...",!
 F W1=0:0 S W1=$O(^DG(41.9,W1)) Q:W1'>0  D C2
 Q
C2 ;
 I '$D(^DG(41.9,W1,"C",DA(1))) Q
 S X0=^DG(41.9,W1,"C",DA(1),0),X1=$G(^(1)) I $D(^DIC(42,W1,0)) S FHWARD=$O(^FH(119.6,"AW",W1,"")) Q:FHWARD=""
 S FHCOM19=$P($G(^FH(119.6,FHWARD,0)),"^",8) Q:FHCOMM'=FHCOM19
 S TYP=$P(^DIC(42,W1,0),"^",3),TYP=$S(TYP="D":"D",TYP="NH":"N",1:"H")
 I '$D(FHN(TYP)) S FHN(TYP,0)=0,FHN(TYP,1)=0
 S Y0=$P(X0,"^",2),Y1=$P(X1,"^",5)
 S:Y0 FHN(TYP,0)=FHN(TYP,0)+Y0 S:Y1 FHN(TYP,1)=FHN(TYP,1)+Y1 Q
 Q
DT ; Get From/To Dates
D1 S %DT="AEPX",%DT("A")="Starting Date: " W ! D ^%DT S:$D(DTOUT) X="^" Q:U[X  G:Y<1 D1 S SDT=+Y
 I SDT'<DT W *7,"  [Must Start before Today!] " G D1
D2 S %DT="AEPX",%DT("A")=" Ending Date: " D ^%DT S:$D(DTOUT) X="^" Q:U[X  G:Y<1 D2 S EDT=+Y
 I EDT'<DT W *7,"  [Must End before Today!] " G D2
 I EDT<SDT W *7,"  [End before Start?] " G D1
 Q
