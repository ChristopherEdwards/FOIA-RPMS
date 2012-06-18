APCDPE ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 25-JUN-1996 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
EN ; -- main entry point for APCD VGEN SELECT ITEMS
 K DIR D ^XBFMK
 D EN^XBVK("APCD")
 D EN^VALM("APCDPE COHORT ENTRY MAIN")
 D CLEAR^VALM1
 D EN^XBVK("AUPN"),^XBFMK
 K APCDLIST,APCDSEL,APCDI,APCDC,APCDCRIT,APCDDISP,APCDHIGH,APCDCUT,APCDANS,VALMHDR,VALMCNT
 I '$D(APCDCSEL) W !!,"No items selected for entry!" Q
 D ^APCDPE1
 D EN^XBVK("APCD"),EN^XBVK("AUPN"),^XBFMK
 K ATXICD
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="                        "_$G(IORVON)_"PCC ITEM SELECTION MENU"_$G(IORVOFF)
 S VALMHDR(2)="The following data items can be selected to be entered on a PCC Visit."
 S VALMHDR(3)="Choose the items you wish to enter on each PCC Visit."
 Q
 ;
 ;
INIT ; -- init variables and list array
 K APCDDISP,APCDSEL,APCDHIGH,APCDLIST
 S APCDHIGH=0,X=0 F  S X=$O(^APCDTKW("FP",X)) Q:X'=+X  S Y=$O(^APCDTKW("FP",X,"")),APCDHIGH=APCDHIGH+1,APCDSEL(APCDHIGH)=Y
 S APCDCUT=((APCDHIGH/3)+1)\1
 S (C,I)=0,J=1,K=1 F  S I=$O(APCDSEL(I)) Q:I'=+I!($D(APCDDISP(I)))  D
 .S C=C+1,APCDLIST(C,0)=I_") "_$S($D(APCDCSEL(I)):"*",1:" ")_$S($P(^APCDTKW(APCDSEL(I),0),U,12)]"":$E($P(^APCDTKW(APCDSEL(I),0),U,12),1,20),1:$E($P(^APCDTKW(APCDSEL(I),0),U,6),1,20)) S APCDDISP(I)="",APCDLIST("IDX",C,C)=""
 .S J=I+APCDCUT
 .I $D(APCDSEL(J)),'$D(APCDDISP(J)) S $E(APCDLIST(C,0),28)=J_") "_$S($D(APCDCSEL(J)):"*",1:" ")_$S($P(^APCDTKW(APCDSEL(J),0),U,12)]"":$E($P(^APCDTKW(APCDSEL(J),0),U,12),1,20),1:$E($P(^APCDTKW(APCDSEL(J),0),U,6),1,20)) S APCDDISP(J)=""
 .S K=J+APCDCUT
 .I $D(APCDSEL(K)),'$D(APCDDISP(K)) S $E(APCDLIST(C,0),55)=K_") "_$S($D(APCDCSEL(K)):"*",1:" ")_$S($P(^APCDTKW(APCDSEL(K),0),U,12)]"":$E($P(^APCDTKW(APCDSEL(K),0),U,12),1,20),1:$E($P(^APCDTKW(APCDSEL(K),0),U,6),1,20)) S APCDDISP(K)=""
 K APCDDISP
 S VALMCNT=C
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 W ! S DIR(0)="LO^1:"_APCDHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 F APCDI=1:1 S APCDC=$P(Y,",",APCDI) Q:APCDC=""  S X=APCDSEL(APCDC),APCDCSEL(APCDC)=X
 D FULL^VALM1 W:$D(IOF) @IOF
ADDX ;
 D BACK
 Q
REM ;EP - remove a selected item - called from protocol entry
 I '$D(APCDCSEL) W !!,"No items have been selected.",! H 2 G REMX
 S DIR(0)="LO^:",DIR("A")="Remove which selected item" K DA D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G REMX
 I $D(DIRUT) W !,"No items selected." G REMX
 S APCDANS=Y,APCDC="" F APCDI=1:1 S APCDC=$P(APCDANS,",",APCDI) Q:APCDC=""  S APCDCRIT=APCDSEL(APCDC) D
 .I '$D(APCDCSEL(APCDC)) W !,"Item ",APCDC," ",$S($P(^APCDTKW(APCDCRIT,0),U,12)]"":$P(^APCDTKW(APCDCRIT,0),U,12),1:$P(^APCDTKW(APCDCRIT,0),U,6))," has not been selected.",! Q
 .K APCDCSEL(APCDC)
 .W !,"Item ",$S($P(^APCDTKW(APCDCRIT,0),U,12)]"":$P(^APCDTKW(APCDCRIT,0),U,12),1:$P(^APCDTKW(APCDCRIT,0),U,6))," removed from selected list of items."
REMX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
EXITR ;EP - exit report called from protocol entry
 S APCDQUIT=1
 Q
HELP ; -- help code
 D FULL^VALM1
 W:$D(IOF) @IOF
 W !,"Enter an S to Select an Item, and R to remove a selected item, Q to Quit",!,"the selection process.  To exit the report, enter an E.",!,"Hit a Q to select all ",$S(APCDPTVS="V":"visits",1:"patients"),", bypassing all screens.",!
 S X="?" D DISP^XQORM1 W !
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
EXIT ; -- exit code
 K APCDDISP
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
