APCLVL6 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 25-JUN-1996 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
EN ; -- main entry point for APCL VGEN SELECT ITEMS
 ;
 D EN^VALM("APCL VGENG SELECT ITEMS")
 D CLEAR^VALM1
 ;
 K VALMHDR,VALMCNT
 Q
 ;
HDR ; -- header code
 I $G(APCLCNTL)="" Q
 D @("HDR"_APCLCNTL)
 Q
HDRS ;
 S VALMHDR(1)="                        "_$G(IORVON)_$S(APCLPTVS="V":"VISIT ",1:"PATIENT ")_"Selection Menu"_$G(IORVOFF)
 S VALMHDR(2)=$S(APCLPTVS="V":"Visits",1:"Patients")_" can be selected based upon any of the following items.  Select"
 S VALMHDR(3)="as many as you wish, in any order or combination.  An (*) asterisk indicates"
 S VALMHDR(4)="items already selected.  To bypass screens and select all "_$S(APCLPTVS="V":"visits",1:"patients")_" hit Q."
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
 S VALMHDR(3)="The "_$S(APCLPTVS="P":"patients",1:"visits")_" displayed can be SORTED by ONLY ONE of the following items."
 S VALMHDR(4)="If you don't select a sort item, the report will be sorted by "_$S(APCLPTVS="V":"visit date.",1:"patient name.")
 Q
 ;
INIT ; -- init variables and list array
 K APCLDISP,APCLSEL,APCLHIGH,APCLLIST
 S APCLXREF="C"
 S APCLHIGH=0,X=0 F  S X=$O(^APCLVSTS(APCLXREF,X)) Q:X=""  S Y=$O(^APCLVSTS(APCLXREF,X,"")) I $P(^APCLVSTS(Y,0),U,5)[APCLCNTL,$P(^(0),U,11)[APCLPTVS,$P(^APCLVSTS(Y,0),U,15)=APCLGIEN S APCLHIGH=APCLHIGH+1,APCLSEL(APCLHIGH)=Y
 S APCLCUT=((APCLHIGH/3)+1)\1
 S (C,I)=0,J=1,K=1 F  S I=$O(APCLSEL(I)) Q:I=""  Q:($D(APCLDISP(I)))  D
 .S C=C+1,APCLZZ=$$T(I,APCLCNTL),APCLLIST(C,0)=I_")"_$S($D(APCLCSEL(APCLSEL(I))):"*",1:" ")_APCLZZ S APCLDISP(I)="",APCLLIST("IDX",C,C)=""
 .S J=I+APCLCUT I $D(APCLSEL(J)),'$D(APCLDISP(J)) S APCLZZ=$$T(J,APCLCNTL),$E(APCLLIST(C,0),28)=J_")"_$S($D(APCLCSEL(APCLSEL(J))):"*",1:" ")_APCLZZ S APCLDISP(J)=""
 .S K=J+APCLCUT I $D(APCLSEL(K)),'$D(APCLDISP(K)) S APCLZZ=$$T(K,APCLCNTL),$E(APCLLIST(C,0),55)=K_")"_$S($D(APCLCSEL(APCLSEL(K))):"*",1:" ")_APCLZZ S APCLDISP(K)=""
 K APCLDISP
 S VALMCNT=C
 Q
 ;
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 G:APCLCNTL="R" SELECTR
 W ! S DIR(0)="LO^1:"_APCLHIGH,DIR("A")="Which "_$S(APCLPTVS="P":"patient",1:"visit")_" item(s)" D DIRQ^APCLVLS1,^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 D @("SELECT"_APCLCNTL)
ADDX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
SELECTS ;select screen items
 S APCLANS=Y,APCLC="" F APCLI=1:1 S APCLC=$P(APCLANS,",",APCLI) Q:APCLC=""  S APCLCRIT=APCLSEL(APCLC) D
 .S APCLTEXT=$P(^APCLVSTS(APCLCRIT,0),U)
 .S APCLVAR=$P(^APCLVSTS(APCLCRIT,0),U,6) K ^APCLVRPT(APCLRPT,11,APCLCRIT),^APCLVRPT(APCLRPT,11,"B",APCLCRIT)
 .W !!,APCLC,") ",APCLTEXT," Selection."
 .I $O(^APCLVSTS(APCLCRIT,11,0)) D SELECTST
 .I $P(^APCLVSTS(APCLCRIT,0),U,2)]"" S APCLCNT=0,^APCLVRPT(APCLRPT,11,0)="^9001003.81101PA^0^0" D @($P(^APCLVSTS(APCLCRIT,0),U,2)_"^APCLVL0")
 .I $D(^APCLVRPT(APCLRPT,11,APCLCRIT,11,1)) S APCLCSEL(APCLCRIT)="",APCLCSEL("GRP",APCLGIEN,APCLCRIT)=""
 .Q
 D SHOW^APCLVLS
 Q
SELECTST ;print help text for this item
 W ! NEW X S X=0 F  S X=$O(^APCLVSTS(APCLCRIT,11,X)) Q:X'=+X  W !,^APCLVSTS(APCLCRIT,11,X,0)
 W !
 Q
SELECTR ;sort select
 W ! S DIR(0)="NO^1:"_APCLHIGH_":0",DIR("A")=$S(APCLCTYP="S":"Sub-total ",1:"Sort ")_$S(APCLPTVS="P":"Patients",1:"visits")_" by which of the above" D ^DIR K DIR
SELECTR1 ;
 I $D(DUOUT) W !,"exiting" S APCLQUIT=1 Q
 S APCLANSW=Y
 I APCLANSW="" Q  ;,(APCLCTYP="D"!(APCLCTYP="L")) W !!,"No sort criteria selected ... will sort by "_$S(APCLPTVS="P":"Patient Name",1:"Visit Date")_"." S:APCLPTVS="V" APCLSORT=19,APCLSORV="Visit Date" D  Q
 ;.S:APCLPTVS="P" APCLSORT=1,APCLSORV="Patient Name"  H 2 D  Q
 ;..S DA=APCLRPT,DIE="^APCLVRPT(",DR=".07////"_APCLSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 ;I APCLANSW="",APCLCTYP'="D",APCLCTYP'="L" W !!,"No sub-totalling will be done.",!! D  Q
 ;.S APCLCTYP="T"
 ;.H 3
 ;.S:APCLPTVS="V" APCLSORT=19,APCLSORV="Visit Date"
 ;.S:APCLPTVS="P" APCLSORT=1,APCLSORV="Patient Name"
 S APCLSORT=APCLSEL(+Y),APCLSORV=$P(^APCLVSTS(APCLSORT,0),U),APCLSORG=$P(^APCLVSTS(APCLSORT,0),U,15),DA=APCLRPT,DIE="^APCLVRPT(",DR=".07////"_APCLSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 Q
SELECTP ;print select - get columns
 S APCLANS=Y,APCLC="" F APCLI=1:1 S APCLC=$P(APCLANS,",",APCLI) Q:APCLC=""  S APCLCRIT=APCLSEL(APCLC),APCLPCNT=APCLPCNT+1 D
 .I APCLCTYP="D" D
 ..S DIR(0)="N^2:80:0",DIR("A")="Enter Column width for "_$P(^APCLVSTS(APCLCRIT,0),U)_" (suggested: "_$P(^APCLVSTS(APCLCRIT,0),U,7)_")",DIR("B")=$P(^(0),U,7) D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 ..I $D(DIRUT) S Y=$P(^APCLVSTS(APCLCRIT,0),U,7)
 .I APCLCTYP="L" S Y=""
 .S ^APCLVRPT(APCLRPT,12,0)="^9001003.81102PA^1^1"
 .I $D(^APCLVRPT(APCLRPT,12,"B",APCLCRIT)) S X=$O(^APCLVRPT(APCLRPT,12,"B",APCLCRIT,"")),APCLTCW=APCLTCW-$P(^APCLVRPT(APCLRPT,12,X,0),U,2)-2,^APCLVRPT(APCLRPT,12,X,0)=APCLCRIT_U_Y D  Q
 ..Q
 .S ^APCLVRPT(APCLRPT,12,APCLPCNT,0)=APCLCRIT_U_Y,^APCLVRPT(APCLRPT,12,"B",APCLCRIT,APCLPCNT)="",APCLTCW=APCLTCW+Y+2,APCLCSEL(APCLCRIT)="",APCLCSEL("GRP",APCLGIEN,APCLCRIT)=""
 .I APCLCTYP="D" W !!?15,"Total Report width (including column margins - 2 spaces):   ",APCLTCW
 .;new functionality to print 1 or all
 .Q:'$D(^APCLVRPT(APCLRPT,11,"B",APCLCRIT))  ;didn't select this item
 .Q:'$P(^APCLVSTS(APCLCRIT,0),U,13)  ;not one of these items
 .;one or all
 .W !!,"***  This item, ",$P(^APCLVSTS(APCLCRIT,0),U)," was a selection item.  Do you want to print",!,"ALL ",$P(^APCLVSTS(APCLCRIT,0),U),"'s or just those you selected.",!
 .S DIR(0)="S^A:ALL items;O:Only the ones selected",DIR("A")="For this item",DIR("B")="A" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S Y="A"
 .I Y="O" S $P(^APCLVRPT(APCLRPT,12,APCLPCNT,0),U,3)=1
 Q
REM ;EP - remove a selected item - called from protocol entry
 I '$D(APCLCSEL) W !!,"No items have been selected.",! H 2 G REMX
 S DIR(0)="LO^:",DIR("A")="Remove which selected item" K DA D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 ;W ! S DIR(0)="LO^1:"_APCLHIGH,DIR("A")="Remove Which "_$S(APCLPTVS="P":"patient",1:"visit")_" item(s)" D DIRQ^APCLVLS1,^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G REMX
 I $D(DIRUT) W !,"No items selected." G REMX
 S APCLANS=Y,APCLC="" F APCLI=1:1 S APCLC=$P(APCLANS,",",APCLI) Q:APCLC=""  D
 .I '$D(APCLSEL(APCLC)) W !,APCLC," is not a valid choice" Q
 .S APCLCRIT=APCLSEL(APCLC) D
 ..I '$D(APCLCSEL(APCLCRIT)) W !,"Item ",APCLC," ",$P(^APCLVSTS(APCLCRIT,0),U)," has not been selected.",! Q
 ..K APCLCSEL(APCLCRIT),APCLCSEL("GRP",APCLGIEN,APCLCRIT)
 ..I APCLCNTL="S" K ^APCLVRPT(APCLRPT,11,APCLCRIT),^APCLVRPT(APCLRPT,11,"B",APCLCRIT)
 ..I APCLCNTL="P" S X=$O(^APCLVRPT(APCLRPT,12,"B",APCLCRIT,0)) I X K ^APCLVRPT(APCLRPT,12,X),^APCLVRPT(APCLRPT,12,"B",APCLCRIT)
 ..W !,"Item ",$P(^APCLVSTS(APCLCRIT,0),U)," removed from selected list of items."
REMX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
T(Z,Y) ;
 NEW T
 S T=$P(^APCLVSTS(APCLSEL(Z),0),U)
 I $P(^APCLVSTS(APCLSEL(Z),0),U,12)]"",Y="P" S T=$P(^APCLVSTS(APCLSEL(Z),0),U,12)
 Q $E(T,1,22)
Q ;EP - quit selections
 ;I APCLCNTL="R" S Y="" G SELECTR1
 Q
EXITR ;EP - exit report called from protocol entry
 S APCLQUIT=1
 Q
HELP ; -- help code
 D FULL^VALM1
 W:$D(IOF) @IOF
 W !,"Enter an S to Select an Item, and R to remove a selected item, Q to Quit",!,"the selection process.  To exit the report, enter an E.",!,"Hit a Q to select all ",$S(APCLPTVS="V":"visits",1:"patients"),", bypassing all screens.",!
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
 K APCLDISP
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
