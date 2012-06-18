AMHRL4 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 25-JUN-1996 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;; ;
EN ; -- main entry point for AMH GEN SELECT ITEMS
 K AMHCSEL
 D EN^VALM("AMH GENRET SELECTION ITEMS")
 D CLEAR^VALM1
 K AMHDISP,AMHSEL,AMHLIST,C,X,I,K,J,AMHHIGH,AMHCUT,AMHCSEL,AMHCNTL
 K VALMHDR,VALMCNT
 Q
 ;
HDR ; -- header code
 D @("HDR"_AMHCNTL)
 Q
HDRS ;
 S VALMHDR(1)="                        "_$G(IORVON)_AMHPTTX_" Selection Menu"_$G(IORVOFF)
 S VALMHDR(2)=AMHPTTS_" can be selected based upon any of the following items.  Select"
 S VALMHDR(3)="as many as you wish, in any order or combination.  An (*) asterisk indicates"
 S VALMHDR(4)="items already selected.  To bypass screens and select all "_AMHPTTS_" type Q."
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
 S VALMHDR(3)="The "_AMHPTTS_" displayed can be SORTED by ONLY ONE of the following items."
 S VALMHDR(4)="If you don't select a sort item, the report will be sorted by "_$S(AMHPTVS="V":"visit date.",AMHPTVS="P":"patient name.",1:"Date of Suicide Act.")
 Q
 ;
INIT ; -- init variables and list array
 K AMHDISP,AMHSEL,AMHHIGH,AMHLIST
 S AMHHIGH=0,X=0 F  S X=$O(^AMHSORT(AMHXREF,X)) Q:X'=+X  S Y=$O(^AMHSORT(AMHXREF,X,"")) I $P(^AMHSORT(Y,0),U,5)[AMHCNTL,$P(^(0),U,11)[AMHPTVS S AMHHIGH=AMHHIGH+1,AMHSEL(AMHHIGH)=Y
 S AMHCUT=((AMHHIGH/3)+1)\1
 S (C,I)=0,J=1,K=1 F  S I=$O(AMHSEL(I)) Q:I'=+I!($D(AMHDISP(I)))  D
 .S C=C+1,AMHLIST(C,0)=I_") "_$S($D(AMHCSEL(I)):"*",1:" ")_$S($P(^AMHSORT(AMHSEL(I),0),U,14)="":$E($P(^(0),U),1,20),1:$P(^(0),U,14)) S AMHDISP(I)="",AMHLIST("IDX",C,C)=""
 .S J=I+AMHCUT I $D(AMHSEL(J)),'$D(AMHDISP(J)) S $E(AMHLIST(C,0),28)=J_") "_$S($D(AMHCSEL(J)):"*",1:" ")_$S($P(^AMHSORT(AMHSEL(J),0),U,14)="":$E($P(^AMHSORT(AMHSEL(J),0),U),1,20),1:$P(^(0),U,14)) S AMHDISP(J)=""
 .S K=J+AMHCUT I $D(AMHSEL(K)),'$D(AMHDISP(K)) S $E(AMHLIST(C,0),55)=K_") "_$S($D(AMHCSEL(K)):"*",1:" ")_$S($P(^AMHSORT(AMHSEL(K),0),U,14)="":$E($P(^AMHSORT(AMHSEL(K),0),U),1,20),1:$P(^(0),U,14)) S AMHDISP(K)=""
 K AMHDISP
 S VALMCNT=C
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 G:AMHCNTL="R" SELECTR
 W ! S DIR(0)="LO^1:"_AMHHIGH,DIR("A")="Which "_AMHPTTX_" item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 D @("SELECT"_AMHCNTL)
ADDX ;
 S DIR(0)="EO",DIR("A")="Press enter to continue..." K DA D ^DIR K DIR
 D BACK
 Q
SELECTS ;select screen items
 S AMHANS=Y,AMHC="" F AMHI=1:1 S AMHC=$P(AMHANS,",",AMHI) Q:AMHC=""  S AMHCRIT=AMHSEL(AMHC) D
 .S AMHTEXT=$P(^AMHSORT(AMHCRIT,0),U)
 .S AMHVAR=$P(^AMHSORT(AMHCRIT,0),U,6) K ^AMHTRPT(AMHRPT,11,AMHCRIT),^AMHTRPT(AMHRPT,11,"B",AMHCRIT)
 .W !!,AMHC,") ",AMHTEXT," Selection."
 .I $P(^AMHSORT(AMHCRIT,0),U,2)]"" S AMHCNT=0,^AMHTRPT(AMHRPT,11,0)="^9002013.81101PA^0^0" D @($P(^AMHSORT(AMHCRIT,0),U,2)_"^AMHRL0")
 .I $D(^AMHTRPT(AMHRPT,11,AMHCRIT,11,1)) S AMHCSEL(AMHC)=""
 .I $P(^AMHSORT(AMHCRIT,0),U,13) S AMHRDTR=1
 .Q
 D SHOW^AMHRLS
 Q
SELECTR ;sort select
 W ! S DIR(0)="NO^1:"_AMHHIGH_":0",DIR("A")=$S(AMHCTYP="S":"Sub-total ",1:"Sort ")_AMHPTTS_" by which of the above" D ^DIR K DIR
SELECTR1 ;
 I $D(DIRUT)!($D(DUOUT)) W !,"exiting" S AMHQUIT=1 Q
 I Y="",AMHCTYP="D" W !!,"No sort item selected ... will sort by " S:AMHPTVS="V" AMHSORT=19,AMHSORV="Visit Date" S:AMHPTVS="P" AMHSORT=70,AMHSORV="Patient Name" S:AMHPTVS="S" AMHSORT=129,AMHSORV="Date of Suicide Act" W AMHSORV,"." H 4 D  Q
 .S DA=AMHRPT,DIE="^AMHTRPT(",DR=".07////"_AMHSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 I Y="",AMHCTYP'="D" W !!,"No sub-totalling will be done.",!! D  Q
 .S AMHCTYP="T"
 .H 3
 .S:AMHPTVS="V" AMHSORT=19,AMHSORV="Visit Date"
 .S:AMHPTVS="P" AMHSORT=70,AMHSORV="Patient Name"
 .S:AMHPTVS="S" AMHSORT=129,AMHSORV="Date of Suicide Act"
 S AMHSORT=AMHSEL(+Y),AMHSORV=$P(^AMHSORT(AMHSORT,0),U),DA=AMHRPT,DIE="^AMHTRPT(",DR=".07////"_AMHSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 Q
SELECTP ;print select - get columns
 S AMHANS=Y,AMHC="" F AMHI=1:1 S AMHC=$P(AMHANS,",",AMHI) Q:AMHC=""  S AMHCRIT=AMHSEL(AMHC),AMHPCNT=AMHPCNT+1 D
 .S DIR(0)="N^2:80:0",DIR("A")="Enter Column width for "_$P(^AMHSORT(AMHCRIT,0),U)_" (suggested: "_$P(^AMHSORT(AMHCRIT,0),U,7)_")",DIR("B")=$P(^(0),U,7) D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 .I $D(DIRUT) S Y=$P(^AMHSORT(AMHCRIT,0),U,7)
 .S ^AMHTRPT(AMHRPT,12,0)="^9002013.81102PA^1^1"
 .I $D(^AMHTRPT(AMHRPT,12,"B",AMHCRIT)) S X=$O(^AMHTRPT(AMHRPT,12,"B",AMHCRIT,"")),AMHTCW=AMHTCW-$P(^AMHTRPT(AMHRPT,12,X,0),U,2)-2,^AMHTRPT(AMHRPT,12,X,0)=AMHCRIT_U_Y D  Q
 ..Q
 .S ^AMHTRPT(AMHRPT,12,AMHPCNT,0)=AMHCRIT_U_Y,^AMHTRPT(AMHRPT,12,"B",AMHCRIT,AMHPCNT)="",AMHTCW=AMHTCW+Y+2,AMHCSEL(AMHC)=""
 .W !!?15,"Total Report width (including column margins - 2 spaces):   ",AMHTCW
 .Q
 Q
REM ;EP - remove a selected item - called from protocol entry
 I '$D(AMHCSEL) W !!,"No items have been selected.",! H 2 G REMX
 S DIR(0)="LO^:",DIR("A")="Remove which selected item" K DA D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G REMX
 I $D(DIRUT) W !,"No items selected." G REMX
 S AMHANS=Y,AMHC="" F AMHI=1:1 S AMHC=$P(AMHANS,",",AMHI) Q:AMHC=""  S AMHCRIT=AMHSEL(AMHC) D
 .I '$D(AMHCSEL(AMHC)) W !,"Item ",AMHC," ",$P(^AMHSORT(AMHCRIT,0),U)," has not been selected.",! Q
 .K AMHCSEL(AMHC)
 .I AMHCNTL="S" K ^AMHTRPT(AMHRPT,11,AMHCRIT),^AMHTRPT(AMHRPT,11,"B",AMHCRIT)
 .I AMHCNTL="P" S X=$O(^AMHTRPT(AMHRPT,12,"B",AMHCRIT,0)) I X K ^AMHTRPT(AMHRPT,12,X),^AMHTRPT(AMHRPT,12,"B",AMHCRIT)
 .W !,"Item ",$P(^AMHSORT(AMHCRIT,0),U)," removed from selected list of items."
REMX ;
 S DIR(0)="EO",DIR("A")="Press enter to continue..." K DA D ^DIR K DIR
 D BACK
 Q
Q ;EP - quit selections
 I AMHCNTL="R" S Y="" G SELECTR1
 Q
EXITR ;EP - exit report called from protocol entry
 S AMHQUIT=1
 Q
HELP ; -- help code
 D FULL^VALM1
 W:$D(IOF) @IOF
 W !,"Enter an S to Select an Item, and R to remove a selected item, Q to Quit",!,"the selection process.  To exit the report, enter an E.",!,"Type a Q to select all ",AMHPTTS,", bypassing all screens.",!
 S X="?" D DISP^XQORM1 W !
 S DIR(0)="EO",DIR("A")="Press enter to continue..." K DA D ^DIR K DIR
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
 K AMHDISP
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
