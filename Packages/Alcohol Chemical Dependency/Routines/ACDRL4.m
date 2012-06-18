ACDRL4 ;IHS/ADC/EDE/KML - GENERAL RETRIEVAL;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;; ;
EN ; -- main entry point for ACD GENRET SELECTION ITEMS
 K ACDCSEL
 D EN^VALM("ACD GENERAL RETRIEVAL TEMPLATE")
 D CLEAR^VALM1
 K ACDDISP,ACDSEL,ACDLIST,C,X,I,K,J,ACDHIGH,ACDCUT,ACDCSEL,ACDCNTL
 K VALMHDR,VALMCNT
 Q
 ;
 ;
HDR ; -- header code
 D @("HDR"_ACDCNTL)
 Q
HDRS ;
 S VALMHDR(1)="                        "_$G(IORVON)_$S(ACDPTVS="V":"CDMIS RECORD ",1:"PATIENT ")_"Selection Menu"_$G(IORVOFF)
 S VALMHDR(2)=$S(ACDPTVS="V":"CDMIS Records",1:"Patients")_" can be selected based upon any of the following items.  Select"
 S VALMHDR(3)="as many as you wish, in any order or combination.  An (*) asterisk indicates"
 S VALMHDR(4)="items already selected.  To bypass screens and select all "_$S(ACDPTVS="V":"visits",1:"patients")_" hit Q."
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
 S VALMHDR(3)="The "_$S(ACDPTVS="P":"patients",1:"visits")_" displayed can be SORTED by ONLY ONE of the following items."
 S VALMHDR(4)="If you don't select a sort item, the report will be sorted by "_$S(ACDPTVS="V":"record date.",1:"patient name.")
 Q
 ;
INIT ; -- init variables and list array
 K ACDDISP,ACDSEL,ACDHIGH,ACDLIST
 S ACDHIGH=0,X=0 F  S X=$O(^ACDTITEM("C",X)) Q:X'=+X  S Y=$O(^ACDTITEM("C",X,"")) I $P(^ACDTITEM(Y,0),U,5)[ACDCNTL,$P(^(0),U,11)[ACDPTVS S ACDHIGH=ACDHIGH+1,ACDSEL(ACDHIGH)=Y
 S ACDIONL=$L($G(IORVON)),ACDIOFL=$L($G(IORVOFF))
 S ACDCUT=((ACDHIGH/3)+1)\1
 S (C,I)=0,J=1,K=1
 S E=0
 F  S I=$O(ACDSEL(I)) Q:I'=+I!($D(ACDDISP(I)))  D
 .  S C=C+1,O=0,F=0,X=" "
 .  S:$D(ACDCSEL(I)) F=1
 .  S:F X=$G(IORVON)_"*"
 .  S X=X_$S($P(^ACDTITEM(ACDSEL(I),0),U,12)="":$E($P(^(0),U),1,20),1:$P(^(0),U,12))
 .  S:F X=X_$G(IORVOFF)
 .  S ACDLIST(C,0)=$S(E:$G(IORVOFF),1:"")_I_") "_X
 .  S:E O=O+ACDIOFL,E=0
 .  S ACDDISP(I)="",ACDLIST("IDX",C,C)=""
 .  S:F O=O+ACDIONL+ACDIOFL
 .  ;----------
 .  S J=I+ACDCUT
 .  I $D(ACDSEL(J)),'$D(ACDDISP(J)) D
 ..  S F=0,X=" "
 ..  S:$D(ACDCSEL(J)) F=1
 ..  S:F X=$G(IORVON)_"*"
 ..  S X=X_$S($P(^ACDTITEM(ACDSEL(J),0),U,12)="":$E($P(^ACDTITEM(ACDSEL(J),0),U),1,20),1:$P(^(0),U,12))
 ..  S:F X=X_$G(IORVOFF)
 ..  S $E(ACDLIST(C,0),28+O)=J_") "_X
 ..  S ACDDISP(J)=""
 ..  S:F O=O+ACDIONL+ACDIOFL
 ..  Q
 .  ;----------
 .  S K=J+ACDCUT
 .  I $D(ACDSEL(K)),'$D(ACDDISP(K)) D
 ..  S F=0,X=" "
 ..  S:$D(ACDCSEL(K)) F=1
 ..  S:F X=$G(IORVON)_"*"
 ..  S X=X_$S($P(^ACDTITEM(ACDSEL(K),0),U,12)="":$E($P(^ACDTITEM(ACDSEL(K),0),U),1,20),1:$P(^(0),U,12))
 ..  S:F X=X_$G(IORVOFF)
 ..  S $E(ACDLIST(C,0),55+O)=K_") "_X
 ..  S ACDDISP(K)=""
 ..  S:F E=1
 ..  Q
 .  Q
 K ACDDISP
 S VALMCNT=C
 Q
 ;
 ;----------
 ;S (C,I)=0,J=1,K=1 F  S I=$O(ACDSEL(I)) Q:I'=+I!($D(ACDDISP(I)))  D
 ;.S C=C+1,ACDLIST(C,0)=I_") "_$S($D(ACDCSEL(I)):"*",1:" ")_$S($P(^ACDTITEM(ACDSEL(I),0),U,12)="":$E($P(^(0),U),1,20),1:$P(^(0),U,12)) S ACDDISP(I)="",ACDLIST("IDX",C,C)=""
 ;.S J=I+ACDCUT I $D(ACDSEL(J)),'$D(ACDDISP(J)) S $E(ACDLIST(C,0),28)=J_") "_$S($D(ACDCSEL(J)):"*",1:" ")_$S($P(^ACDTITEM(ACDSEL(J),0),U,12)="":$E($P(^ACDTITEM(ACDSEL(J),0),U),1,20),1:$P(^(0),U,12)) S ACDDISP(J)=""
 ;.S K=J+ACDCUT I $D(ACDSEL(K)),'$D(ACDDISP(K)) S $E(ACDLIST(C,0),55)=K_") "_$S($D(ACDCSEL(K)):"*",1:" ")_$S($P(^ACDTITEM(ACDSEL(K),0),U,12)="":$E($P(^ACDTITEM(ACDSEL(K),0),U),1,20),1:$P(^(0),U,12)) S ACDDISP(K)=""
 ;----------
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 G:ACDCNTL="R" SELECTR
 W ! S DIR(0)="LO^1:"_ACDHIGH,DIR("A")="Which "_$S(ACDPTVS="P":"patient",1:"record")_" item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 D @("SELECT"_ACDCNTL)
ADDX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
SELECTS ;select screen items
 S ACDANS=Y,ACDC="" F ACDI=1:1 S ACDC=$P(ACDANS,",",ACDI) Q:ACDC=""  S ACDCRIT=ACDSEL(ACDC) D
 .S ACDTEXT=$P(^ACDTITEM(ACDCRIT,0),U)
 .S ACDVAR=$P(^ACDTITEM(ACDCRIT,0),U,6) K ^ACDRPTD(ACDRPT,11,ACDCRIT),^ACDRPTD(ACDRPT,11,"B",ACDCRIT)
 .W !!,ACDC,") ",ACDTEXT," Selection."
 .I $P(^ACDTITEM(ACDCRIT,0),U,2)]"" S ACDCNT=0,^ACDRPTD(ACDRPT,11,0)="^9002171.81101PA^0^0" D @($P(^ACDTITEM(ACDCRIT,0),U,2)_"^ACDRL0")
 .I $D(^ACDRPTD(ACDRPT,11,ACDCRIT,11,1)) S ACDCSEL(ACDC)=""
 .Q
 D SHOW^ACDRLS
 Q
SELECTR ;sort select
 W ! S DIR(0)="NO^1:"_ACDHIGH_":0",DIR("A")=$S(ACDCTYP="S":"Sub-total ",1:"Sort ")_$S(ACDPTVS="P":"Patients",1:"visits")_" by which of the above" D ^DIR K DIR
SELECTR1 ;
 I Y="",ACDCTYP="D" W !!,"No sort criteria selected ... will sort by "_$S(ACDPTVS="P":"Patient Name",1:"Referral Date")_"." S:ACDPTVS="V" ACDSORT=19,ACDSORV="Referral Date" S:ACDPTVS="P" ACDSORT=119,ACDSORV="Patient Name" H 4 D  Q
 .S DA=ACDRPT,DIE="^ACDRPTD(",DR=".07////"_ACDSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 I Y="",ACDCTYP'="D" W !!,"No sub-totalling will be done.",!! D  Q
 .S ACDCTYP="T"
 .H 3
 .S:ACDPTVS="V" ACDSORT=19,ACDSORV="Referral Date"
 .S:ACDPTVS="P" ACDSORT=119,ACDSORV="Patient Name"
 S ACDSORT=ACDSEL(+Y),ACDSORV=$P(^ACDTITEM(ACDSORT,0),U),DA=ACDRPT,DIE="^ACDRPTD(",DR=".07////"_ACDSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 Q
SELECTP ;print select - get columns
 S ACDANS=Y,ACDC="" F ACDI=1:1 S ACDC=$P(ACDANS,",",ACDI) Q:ACDC=""  S ACDCRIT=ACDSEL(ACDC),ACDPCNT=ACDPCNT+1 D
 .S DIR(0)="N^2:80:0",DIR("A")="Enter Column width for "_$P(^ACDTITEM(ACDCRIT,0),U)_" (suggested: "_$P(^ACDTITEM(ACDCRIT,0),U,7)_")",DIR("B")=$P(^(0),U,7) D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 .I $D(DIRUT) S Y=$P(^ACDTITEM(ACDCRIT,0),U,7)
 .S ^ACDRPTD(ACDRPT,12,0)="^9002171.81102PA^1^1"
 .I $D(^ACDRPTD(ACDRPT,12,"B",ACDCRIT)) S X=$O(^ACDRPTD(ACDRPT,12,"B",ACDCRIT,"")),ACDTCW=ACDTCW-$P(^ACDRPTD(ACDRPT,12,X,0),U,2)-2,^ACDRPTD(ACDRPT,12,X,0)=ACDCRIT_U_Y D  Q
 ..Q
 .S ^ACDRPTD(ACDRPT,12,ACDPCNT,0)=ACDCRIT_U_Y,^ACDRPTD(ACDRPT,12,"B",ACDCRIT,ACDPCNT)="",ACDTCW=ACDTCW+Y+2,ACDCSEL(ACDC)=""
 .W !!?15,"Total Report width (including column margins - 2 spaces):   ",ACDTCW
 .Q
 Q
REM ;EP - remove a selected item - called from protocol entry
 I '$D(ACDCSEL) W !!,"No items have been selected.",! H 2 G REMX
 S DIR(0)="LO^:",DIR("A")="Remove which selected item" K DA D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G REMX
 I $D(DIRUT) W !,"No items selected." G REMX
 S ACDANS=Y,ACDC="" F ACDI=1:1 S ACDC=$P(ACDANS,",",ACDI) Q:ACDC=""  S ACDCRIT=ACDSEL(ACDC) D
 .I '$D(ACDCSEL(ACDC)) W !,"Item ",ACDC," ",$P(^ACDTITEM(ACDCRIT,0),U)," has not been selected.",! Q
 .K ACDCSEL(ACDC)
 .I ACDCNTL="S" K ^ACDRPTD(ACDRPT,11,ACDCRIT),^ACDRPTD(ACDRPT,11,"B",ACDCRIT)
 .I ACDCNTL="P" S X=$O(^ACDVPRT(ACDRPT,12,"B",ACDCRIT,0)) I X K ^ACDRPTD(ACDRPT,12,X),^ACDRPTD(ACDRPT,12,"B",ACDCRIT)
 .W !,"Item ",$P(^ACDTITEM(ACDCRIT,0),U)," removed from selected list of items."
REMX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
Q ;EP - quit selections
 I ACDCNTL="R" S Y="" G SELECTR1
 Q
EXITR ;EP - exit report called from protocol entry
 S ACDQUIT=1
 Q
HELP ; -- help code
 D FULL^VALM1
 W:$D(IOF) @IOF
 W !,"Enter an S to Select an Item, and R to remove a selected item, Q to Quit",!,"the selection process.  To exit the report, enter an E.",!,"Hit a Q to select all ",$S(ACDPTVS="V":"visits",1:"patients"),", bypassing all screens.",!
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
 K ACDDISP
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
