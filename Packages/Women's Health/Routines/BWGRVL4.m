BWGRVL4 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 25-JUN-1996 ; [ 08/16/01  3:49 PM ]
 ;;2.0;WOMEN'S HEALTH;**6,8**;MAY 16, 1996
 ;IHS/CMI/LAB - modified file numbers
 ;; ;
EN ; -- main entry point for BWGR GENRET SELECT ITEMS
 K BWGRCSEL
 D EN^VALM("BWGR GENRET SELECT ITEMS")
 D CLEAR^VALM1
 K BWGRDISP,BWGRSEL,BWGRLIST,C,X,I,K,J,BWGRHIGH,BWGRCUT,BWGRCSEL,BWGRCNTL
 K VALMHDR,VALMCNT
 Q
 ;
HDR ; -- header code
 D @("HDR"_BWGRCNTL)
 Q
HDRS ;
 S VALMHDR(1)="                        "_$G(IORVON)_$S(BWGRPTVS="R":"WH PROCEDURE ",1:"PATIENT ")_"Selection Menu"_$G(IORVOFF)
 S VALMHDR(2)=$S(BWGRPTVS="R":"Procedures",1:"Patients")_" can be selected based upon any of the following items.  Select"
 S VALMHDR(3)="as many as you wish, in any order or combination.  An (*) asterisk indicates"
 S VALMHDR(4)="items already selected.  To bypass screens and select all "_$S(BWGRPTVS="R":"visits",1:"patients")_" hit Q."
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
 S VALMHDR(3)="The "_$S(BWGRPTVS="P":"patients",1:"visits")_" displayed can be SORTED by ONLY ONE of the following items."
 S VALMHDR(4)="If you don't select a sort item, the report will be sorted by "_$S(BWGRPTVS="R":"visit date.",1:"patient name.")
 Q
 ;
INIT ; -- init variables and list array
 K BWGRDISP,BWGRSEL,BWGRHIGH,BWGRLIST
 S BWGRHIGH=0,X=0 F  S X=$O(^BWGRI("C",X)) Q:X'=+X  S Y=$O(^BWGRI("C",X,"")) I $P(^BWGRI(Y,0),U,5)[BWGRCNTL,$P(^(0),U,11)[BWGRPTVS S BWGRHIGH=BWGRHIGH+1,BWGRSEL(BWGRHIGH)=Y
 S BWGRCUT=((BWGRHIGH/3)+1)\1
 S (C,I)=0,J=1,K=1 F  S I=$O(BWGRSEL(I)) Q:I'=+I!($D(BWGRDISP(I)))  D
 .S C=C+1,BWGRLIST(C,0)=I_") "_$S($D(BWGRCSEL(I)):"*",1:" ")_$S($P(^BWGRI(BWGRSEL(I),0),U,12)="":$E($P(^(0),U),1,20),1:$P(^(0),U,12)) S BWGRDISP(I)="",BWGRLIST("IDX",C,C)=""
 .S J=I+BWGRCUT I $D(BWGRSEL(J)),'$D(BWGRDISP(J)) S $E(BWGRLIST(C,0),28)=J_") "_$S($D(BWGRCSEL(J)):"*",1:" ")_$S($P(^BWGRI(BWGRSEL(J),0),U,12)="":$E($P(^BWGRI(BWGRSEL(J),0),U),1,20),1:$P(^(0),U,12)) S BWGRDISP(J)=""
 .S K=J+BWGRCUT I $D(BWGRSEL(K)),'$D(BWGRDISP(K)) S $E(BWGRLIST(C,0),55)=K_") "_$S($D(BWGRCSEL(K)):"*",1:" ")_$S($P(^BWGRI(BWGRSEL(K),0),U,12)="":$E($P(^BWGRI(BWGRSEL(K),0),U),1,20),1:$P(^(0),U,12)) S BWGRDISP(K)=""
 K BWGRDISP
 S VALMCNT=C
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 G:BWGRCNTL="R" SELECTR
 W ! S DIR(0)="LO^1:"_BWGRHIGH,DIR("A")="Which "_$S(BWGRPTVS="P":"patient",1:"visit")_" item(s)" D DIRQ^BWGRVLS1,^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 D @("SELECT"_BWGRCNTL)
ADDX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
SELECTS ;select screen items
 S BWGRANS=Y,BWGRC="" F BWGRI=1:1 S BWGRC=$P(BWGRANS,",",BWGRI) Q:BWGRC=""  S BWGRCRIT=BWGRSEL(BWGRC) D
 .S BWGRTEXT=$P(^BWGRI(BWGRCRIT,0),U)
 .S BWGRVAR=$P(^BWGRI(BWGRCRIT,0),U,6) K ^BWGRTRPT(BWGRRPT,11,BWGRCRIT),^BWGRTRPT(BWGRRPT,11,"B",BWGRCRIT)
 .W !!,BWGRC,") ",BWGRTEXT," Selection."
 .I $P(^BWGRI(BWGRCRIT,0),U,2)]"" S BWGRCNT=0,^BWGRTRPT(BWGRRPT,11,0)="^9002086.89101PA^0^0" D @($P(^BWGRI(BWGRCRIT,0),U,2)_"^BWGRVL0")
 .I $D(^BWGRTRPT(BWGRRPT,11,BWGRCRIT,11,1)) S BWGRCSEL(BWGRC)=""
 .I $P(^BWGRI(BWGRCRIT,0),U,13) S BWGRDTR=1
 .Q
 D SHOW^BWGRVLS
 Q
SELECTR ;sort select
 W ! S DIR(0)="NO^1:"_BWGRHIGH_":0",DIR("A")=$S(BWGRCTYP="S":"Sub-total ",1:"Sort ")_$S(BWGRPTVS="P":"Patients",1:"visits")_" by which of the above" D ^DIR K DIR
SELECTR1 ;
 I $D(DUOUT) W !,"exiting" S BWGRQUIT=1 Q
 I Y="",BWGRCTYP="D" W !!,"No sort criteria selected ... will sort by "_$S(BWGRPTVS="P":"Patient Name",1:"Procedure Date")_"." S:BWGRPTVS="R" BWGRSORT=130,BWGRSORV="Procedure Date" S:BWGRPTVS="P" BWGRSORT=1,BWGRSORV="Patient Name" H 3 D  Q
 .S DA=BWGRRPT,DIE="^BWGRTRPT(",DR=".07////"_BWGRSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 I Y="",BWGRCTYP'="D" W !!,"No sub-totalling will be done.",!! D  Q
 .S BWGRCTYP="T"
 .H 3
 .S:BWGRPTVS="R" BWGRSORT=130,BWGRSORV="Procedure Date"
 .S:BWGRPTVS="P" BWGRSORT=1,BWGRSORV="Patient Name"
 S BWGRSORT=BWGRSEL(+Y),BWGRSORV=$P(^BWGRI(BWGRSORT,0),U),DA=BWGRRPT,DIE="^BWGRTRPT(",DR=".07////"_BWGRSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 Q
SELECTP ;print select - get columns
 S BWGRANS=Y,BWGRC="" F BWGRI=1:1 S BWGRC=$P(BWGRANS,",",BWGRI) Q:BWGRC=""  S BWGRCRIT=BWGRSEL(BWGRC),BWGRPCNT=BWGRPCNT+1 D
 .S DIR(0)="N^2:80:0",DIR("A")="Enter Column width for "_$P(^BWGRI(BWGRCRIT,0),U)_" (suggested: "_$P(^BWGRI(BWGRCRIT,0),U,7)_")",DIR("B")=$P(^(0),U,7) D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 .I $D(DIRUT) S Y=$P(^BWGRI(BWGRCRIT,0),U,7)
 .S ^BWGRTRPT(BWGRRPT,12,0)="^9002086.89102PA^1^1"
 .I $D(^BWGRTRPT(BWGRRPT,12,"B",BWGRCRIT)) S X=$O(^BWGRTRPT(BWGRRPT,12,"B",BWGRCRIT,"")),BWGRTCW=BWGRTCW-$P(^BWGRTRPT(BWGRRPT,12,X,0),U,2)-2,^BWGRTRPT(BWGRRPT,12,X,0)=BWGRCRIT_U_Y D  Q
 ..Q
 .S ^BWGRTRPT(BWGRRPT,12,BWGRPCNT,0)=BWGRCRIT_U_Y,^BWGRTRPT(BWGRRPT,12,"B",BWGRCRIT,BWGRPCNT)="",BWGRTCW=BWGRTCW+Y+2,BWGRCSEL(BWGRC)=""
 .W !!?15,"Total Report width (including column margins - 2 spaces):   ",BWGRTCW
 .Q
 Q
REM ;EP - remove a selected item - called from protocol entry
 I '$D(BWGRCSEL) W !!,"No items have been selected.",! H 2 G REMX
 S DIR(0)="LO^:",DIR("A")="Remove which selected item" K DA D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 ;W ! S DIR(0)="LO^1:"_BWGRHIGH,DIR("A")="Remove Which "_$S(BWGRPTVS="P":"patient",1:"visit")_" item(s)" D DIRQ^BWGRVLS1,^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G REMX
 I $D(DIRUT) W !,"No items selected." G REMX
 S BWGRANS=Y,BWGRC="" F BWGRI=1:1 S BWGRC=$P(BWGRANS,",",BWGRI) Q:BWGRC=""  S BWGRCRIT=BWGRSEL(BWGRC) D
 .I '$D(BWGRCSEL(BWGRC)) W !,"Item ",BWGRC," ",$P(^BWGRI(BWGRCRIT,0),U)," has not been selected.",! Q
 .K BWGRCSEL(BWGRC)
 .I BWGRCNTL="S" K ^BWGRTRPT(BWGRRPT,11,BWGRCRIT),^BWGRTRPT(BWGRRPT,11,"B",BWGRCRIT)
 .I BWGRCNTL="P" S X=$O(^BWGRTRPT(BWGRRPT,12,"B",BWGRCRIT,0)) I X K ^BWGRTRPT(BWGRRPT,12,X),^BWGRTRPT(BWGRRPT,12,"B",BWGRCRIT)
 .W !,"Item ",$P(^BWGRI(BWGRCRIT,0),U)," removed from selected list of items."
REMX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
Q ;EP - quit selections
 I BWGRCNTL="R" S Y="" G SELECTR1
 Q
EXITR ;EP - exit report called from protocol entry
 S BWGRQUIT=1
 Q
HELP ; -- help code
 D FULL^VALM1
 W:$D(IOF) @IOF
 W !,"Enter an S to Select an Item, and R to remove a selected item, Q to Quit",!,"the selection process.  To exit the report, enter an E.",!,"Hit a Q to select all ",$S(BWGRPTVS="R":"visits",1:"patients"),", bypassing all screens.",!
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
 K BWGRDISP
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
