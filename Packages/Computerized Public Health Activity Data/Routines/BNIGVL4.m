BNIGVL4 ; IHS/CMI/LAB - general retrieval select ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;; ;
EN ; -- main entry point for BNIG GENRET SELECT ITEMS
 K BNIGCSEL
 D EN^VALM("BNIG GENRET SELECT ITEMS")
 D CLEAR^VALM1
 K BNIGDISP,BNIGSEL,BNIGLIST,C,X,I,K,J,BNIGHIGH,BNIGCUT,BNIGCSEL,BNIGCNTL
 K VALMHDR,VALMCNT
 Q
 ;
HDR ; -- header code
 D @("HDR"_BNIGCNTL)
 Q
HDRS ;
 S VALMHDR(1)="                        "_$G(IORVON)_"CPHAD Activity Record Selection Menu"_$G(IORVOFF)
 S VALMHDR(2)="Activity Records can be selected based upon any of the following items.  Select"
 S VALMHDR(3)="as many as you wish, in any order or combination.  An (*) asterisk indicates"
 S VALMHDR(4)="items already selected.  To bypass screens and select all records, type Q."
 Q
 ;
HDRP ;print selection header
 S VALMHDR(1)="                        "_$G(IORVON)_"PRINT ITEM SELECTION MENU"_$G(IORVOFF)
 S VALMHDR(2)="The following data items can be printed.  Choose the items in the order you"
 S VALMHDR(3)="want them to appear on the printout.  Keep in mind that you have an 80"
 S VALMHDR(4)="column screen available, or a printer with either 80 or 132 column width."
 Q
 ;
HDRR ;sort header
 S VALMHDR(1)=""
 S VALMHDR(2)="                        "_$G(IORVON)_"SORT ITEM SELECTION MENU"_$G(IORVOFF)
 S VALMHDR(3)="The Activity records displayed can be SORTED by ONLY ONE of the following items."
 S VALMHDR(4)="If you don't select a sort item, the report will be sorted by activity date."
 Q
 ;
INIT ; -- init variables and list array
 K BNIGDISP,BNIGSEL,BNIGHIGH,BNIGLIST
 S BNIGHIGH=0,X=0 F  S X=$O(^BNIGRI("C",X)) Q:X'=+X  S Y=$O(^BNIGRI("C",X,"")) I $P(^BNIGRI(Y,0),U,5)[BNIGCNTL,$P(^(0),U,11)[BNIGPTVS S BNIGHIGH=BNIGHIGH+1,BNIGSEL(BNIGHIGH)=Y
 S BNIGCUT=((BNIGHIGH/3)+1)\1
 S (C,I)=0,J=1,K=1 F  S I=$O(BNIGSEL(I)) Q:I'=+I  Q:$D(BNIGDISP(I))  D
 .S C=C+1,BNIGLIST(C,0)=I_") "_$S($D(BNIGCSEL(I)):"*",1:" ")_$S($P(^BNIGRI(BNIGSEL(I),0),U,12)="":$E($P(^(0),U),1,20),1:$P(^(0),U,12)) S BNIGDISP(I)="",BNIGLIST("IDX",C,C)=""
 .S J=I+BNIGCUT I $D(BNIGSEL(J)),'$D(BNIGDISP(J)) S $E(BNIGLIST(C,0),28)=J_") "_$S($D(BNIGCSEL(J)):"*",1:" ")_$S($P(^BNIGRI(BNIGSEL(J),0),U,12)="":$E($P(^BNIGRI(BNIGSEL(J),0),U),1,20),1:$P(^(0),U,12)) S BNIGDISP(J)=""
 .S K=J+BNIGCUT I $D(BNIGSEL(K)),'$D(BNIGDISP(K)) S $E(BNIGLIST(C,0),55)=K_") "_$S($D(BNIGCSEL(K)):"*",1:" ")_$S($P(^BNIGRI(BNIGSEL(K),0),U,12)="":$E($P(^BNIGRI(BNIGSEL(K),0),U),1,20),1:$P(^(0),U,12)) S BNIGDISP(K)=""
 K BNIGDISP
 S VALMCNT=C
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 G:BNIGCNTL="R" SELECTR
 W ! S DIR(0)="LO^1:"_BNIGHIGH,DIR("A")="Which activity record item(s)" D DIRQ^BNIGVLS1,^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 D @("SELECT"_BNIGCNTL)
ADDX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
SELECTS ;select screen items
 S BNIGANS=Y,BNIGC="" F BNIGI=1:1 S BNIGC=$P(BNIGANS,",",BNIGI) Q:BNIGC=""  S BNIGCRIT=BNIGSEL(BNIGC) D
 .S BNIGTEXT=$P(^BNIGRI(BNIGCRIT,0),U)
 .S BNIGVAR=$P(^BNIGRI(BNIGCRIT,0),U,6) K ^BNIRTMP(BNIGRPT,11,BNIGCRIT),^BNIRTMP(BNIGRPT,11,"B",BNIGCRIT)
 .W !!,BNIGC,") ",BNIGTEXT," Selection."
 .I $P(^BNIGRI(BNIGCRIT,0),U,2)]"" S BNIGCNT=0,^BNIRTMP(BNIGRPT,11,0)="^90512.81101PA^0^0" D @($P(^BNIGRI(BNIGCRIT,0),U,2)_"^BNIGVL0")
 .I $D(^BNIRTMP(BNIGRPT,11,BNIGCRIT,11,1)) S BNIGCSEL(BNIGC)=""
 .I $P(^BNIGRI(BNIGCRIT,0),U,13) S BNIGDTR=1
 .Q
 D SHOW^BNIGVLS
 Q
SELECTR ;sort select
 W ! S DIR(0)="NO^1:"_BNIGHIGH_":0",DIR("A")=$S(BNIGCTYP="S":"Sub-total ",1:"Sort ")_"records by which of the above" D ^DIR K DIR
SELECTR1 ;
 I $D(DUOUT) W !,"exiting" S BNIGQUIT=1 Q
 I Y="",BNIGCTYP="D"!(BNIGCTYP="L") W !!,"No sort criteria selected ... will sort by Activity Record date." S BNIGSORT=1,BNIGSORV="Activity Date" H 3 D  Q
 .S DA=BNIGRPT,DIE="^BNIRTMP(",DR=".07////"_BNIGSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 I Y="",BNIGCTYP'="D",BNIGCTYP'="L" W !!,"No sub-totalling will be done.",!! D  Q
 .S BNIGCTYP="T"
 .H 2
 .S BNIGSORT=1,BNIGSORV="Activity Date"
 S BNIGSORT=BNIGSEL(+Y),BNIGSORV=$P(^BNIGRI(BNIGSORT,0),U),DA=BNIGRPT,DIE="^BNIRTMP(",DR=".07////"_BNIGSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 Q
SELECTP ;print select - get columns
 S BNIGANS=Y,BNIGC="" F BNIGI=1:1 S BNIGC=$P(BNIGANS,",",BNIGI) Q:BNIGC=""  S BNIGCRIT=BNIGSEL(BNIGC),BNIGPCNT=BNIGPCNT+1 D
 .I BNIGCTYP="D" D
 ..S DIR(0)="N^2:80:0",DIR("A")="Enter Column width for "_$P(^BNIGRI(BNIGCRIT,0),U)_" (suggested: "_$P(^BNIGRI(BNIGCRIT,0),U,7)_")",DIR("B")=$P(^(0),U,7) D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 ..I $D(DIRUT) S Y=$P(^BNIGRI(BNIGCRIT,0),U,7)
 .I BNIGCTYP="L" S Y=""
 .S ^BNIRTMP(BNIGRPT,12,0)="^90512.81102PA^1^1"
 .I $D(^BNIRTMP(BNIGRPT,12,"B",BNIGCRIT)) S X=$O(^BNIRTMP(BNIGRPT,12,"B",BNIGCRIT,"")),BNIGTCW=BNIGTCW-$P(^BNIRTMP(BNIGRPT,12,X,0),U,2)-2,^BNIRTMP(BNIGRPT,12,X,0)=BNIGCRIT_U_Y
 .S ^BNIRTMP(BNIGRPT,12,BNIGPCNT,0)=BNIGCRIT_U_Y,^BNIRTMP(BNIGRPT,12,"B",BNIGCRIT,BNIGPCNT)="",BNIGTCW=BNIGTCW+Y+2,BNIGCSEL(BNIGC)=""
 .I BNIGCTYP="D" W !!?15,"Total Report width (including column margins - 2 spaces):   ",BNIGTCW
 .Q
 Q
REM ;EP - remove a selected item - called from protocol entry
 I '$D(BNIGCSEL) W !!,"No items have been selected.",! H 2 G REMX
 S DIR(0)="LO^:",DIR("A")="Remove which selected item" K DA D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G REMX
 I $D(DIRUT) W !,"No items selected." G REMX
 S BNIGANS=Y,BNIGC="" F BNIGI=1:1 S BNIGC=$P(BNIGANS,",",BNIGI) Q:BNIGC=""  S BNIGCRIT=BNIGSEL(BNIGC) D
 .I '$D(BNIGCSEL(BNIGC)) W !,"Item ",BNIGC," ",$P(^BNIGRI(BNIGCRIT,0),U)," has not been selected.",! Q
 .K BNIGCSEL(BNIGC)
 .I BNIGCNTL="S" K ^BNIRTMP(BNIGRPT,11,BNIGCRIT),^BNIRTMP(BNIGRPT,11,"B",BNIGCRIT)
 .I BNIGCNTL="P" S X=$O(^BNIRTMP(BNIGRPT,12,"B",BNIGCRIT,0)) I X K ^BNIRTMP(BNIGRPT,12,X),^BNIRTMP(BNIGRPT,12,"B",BNIGCRIT)
 .W !,"Item ",$P(^BNIGRI(BNIGCRIT,0),U)," removed from selected list of items."
REMX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
Q ;EP - quit selections
 I BNIGCNTL="R" S Y="" G SELECTR1
 Q
EXITR ;EP - exit report called from protocol entry
 S BNIGQUIT=1
 Q
HELP ; -- help code
 D FULL^VALM1
 W:$D(IOF) @IOF
 W !,"Enter an S to Select an Item, and R to remove a selected item, Q to Quit",!,"the selection process.  To exit the report, enter an E.",!,"Hit a Q to select all ",$S(BNIGPTVS="R":"visits",1:"patients"),", bypassing all screens.",!
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
 K BNIGDISP
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
