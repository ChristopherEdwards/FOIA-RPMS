BGPMUDSI ; IHS/MSC/MMT - DISPLAY MEASURE LISTS ;02-Mar-2011 16:50;MGH
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 K BGPMUMEA,BGPHIGH,BGPANS,BGPC,BGPGANS,BGPGC,BGPGI,BGPI,BGPX,BGPLSEL
 Q
 ;; ;
EN ;EP -- main entry point
 S BGPLSEL="A"
 D EN^VALM("BGPMU 11 MEASURE SELECTION")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
ENH ;EP -- main entry point for Hospital measures
 S BGPLSEL="H"
 D EN^VALM("BGPMU 11 HOSPITAL MEASURE SEL")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
ENM ;EP -- main entry point for Menu Set measure selection
 S BGPLSEL="M"
 D EN^VALM("BGPMU 11 EP MENU MEASURE SEL")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="IHS Meaningful Use Clinical Quality Measures"
 S VALMHDR(2)="* indicates the clinical quality measure has been selected"
 Q
 ;
INIT ; ALL EP Measures -- init variables and list array
 N X,Y,X,C
 K BGPMUMEA S BGPHIGH=""
 S (X,Y,Z,C)=0 F  S X=$O(^BGPMUIND(BGPMUYF,"ADO",X)) Q:X'=+X  S Y=0 F  S Y=$O(^BGPMUIND(BGPMUYF,"ADO",X,Y))  Q:Y'=+Y  I $D(^BGPMUIND(BGPMUYF,Y)),$P($G(^BGPMUIND(BGPMUYF,Y,0)),U,4)'="H" D
 .S BGPMUDAT=^BGPMUIND(BGPMUYF,Y,0),C=C+1,BGPMUMEA(C,0)=C_")",$E(BGPMUMEA(C,0),5)="("_$P(BGPMUDAT,U,4)_") "_$P(BGPMUDAT,U,3),BGPMUMEA(C,C)=Y I $D(BGPIND(Y)) S BGPMUMEA(C,0)="*"_BGPMUMEA(C,0)
 .Q
 S (VALMCNT,BGPHIGH)=C
 Q
INITM ; Only Menu Set Measures -- init variables and list array
 K BGPMUMEA S BGPHIGH=""
 N X,Y,Z,C
 S (X,Y,Z,C)=0 F  S X=$O(^BGPMUIND(BGPMUYF,"ADO",X)) Q:X'=+X  S Y=0 F  S Y=$O(^BGPMUIND(BGPMUYF,"ADO",X,Y))  Q:Y'=+Y  I $D(^BGPMUIND(BGPMUYF,"AMS","M",Y)) D
 .S C=C+1,BGPMUMEA(C,0)=C_")",$E(BGPMUMEA(C,0),5)=$P(^BGPMUIND(BGPMUYF,Y,0),U,3),BGPMUMEA(C,C)=Y I $D(BGPIND(Y)) S BGPMUMEA(C,0)="*"_BGPMUMEA(C,0)
 .Q
 S (VALMCNT,BGPHIGH)=C
 Q
INITH ; ALL Hospital Measures -- init variables and list array
 K BGPMUMEA S BGPHIGH=""
 N X,Y,Z,C
 S (X,Y,Z,C)=0 F  S X=$O(^BGPMUIND(BGPMUYF,"ADO",X)) Q:X'=+X  S Y=0 F  S Y=$O(^BGPMUIND(BGPMUYF,"ADO",X,Y))  Q:Y'=+Y  I $D(^BGPMUIND(BGPMUYF,Y)),$P($G(^BGPMUIND(BGPMUYF,Y,0)),U,4)="H" D
 .S C=C+1,BGPMUMEA(C,0)=C_")",$E(BGPMUMEA(C,0),5)=$P(^BGPMUIND(BGPMUYF,Y,0),U,3),BGPMUMEA(C,C)=Y I $D(BGPIND(Y)) S BGPMUMEA(C,0)="*"_BGPMUMEA(C,0)
 .Q
 S (VALMCNT,BGPHIGH)=C
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 I BGPLSEL="A" D INIT
 I BGPLSEL="M" D INITM
 I BGPLSEL="H" D INITH
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 W !
 S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which item(s)"
ADD1 ;
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  S BGPIND(BGPMUMEA(BGPC,BGPC))=""
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:BGPHIGH S BGPIND(X)=""
 D BACK
 Q
 ;
REM ;
 W ! S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  K BGPIND(BGPMUMEA(BGPC,BGPC))
REMX ;
 D BACK
 Q
