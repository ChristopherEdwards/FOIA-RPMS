APCLVL5 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 25-JUN-1996 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
EN ; -- main entry point for APCL VGEN SELECT ITEMS
 K APCLCSEL
 I APCLCNTL="R" S (APCLSORV,APCLSORT)=""
 D EN^VALM("APCL GEN GROUP SELECTION")
 D CLEAR^VALM1
 K APCLDISP,APCLSEL,APCLLIST,C,X,I,K,J,APCLHIGH,APCLCUT,APCLCSEL,APCLCNTL
 K VALMHDR,VALMCNT
 Q
 ;
HDR ; -- header code
 I $G(APCLCNTL)="" Q
 D @("HDR"_APCLCNTL)
 Q
HDRS ;
 S VALMHDR(1)="                        "_$G(IORVON)_$S(APCLPTVS="V":"VISIT ",1:"PATIENT ")_"Selection Menu"_$G(IORVOFF)
 S VALMHDR(2)=$S(APCLPTVS="V":"Visits",1:"Patients")_" can be selected based upon items in any of the groups listed."
 S VALMHDR(3)="When you select a group a different screen will be displayed with the list of"
 S VALMHDR(4)="items in that group for your selection.  To bypass screens type Q."
 Q
 ;
HDRP ;print selection header
 S VALMHDR(1)="                        "_$G(IORVON)_"PRINT ITEM SELECTION MENU"_$G(IORVOFF)
 S VALMHDR(2)="Items from the following groups can be selected for printing.  Choose the"
 S VALMHDR(3)="the group from which you want an item to print. Keep in mind that you have an 80"
 S VALMHDR(4)="column screen available, or a printer with either 80 or 132 column width."
 Q
 ;
HDRR ;sort header
 S VALMHDR(1)="                        "_$G(IORVON)_"SORT ITEM SELECTION MENU"_$G(IORVOFF)
 S VALMHDR(2)="The "_$S(APCLPTVS="P":"patients",1:"visits")_" displayed can be SORTED by ONLY ONE item."
 S VALMHDR(3)="If you don't select a sort item, the report will be sorted by "_$S(APCLPTVS="V":"visit date.",1:"patient name.")
 S VALMHDR(4)="Choose the group from which the sort item will be selected."
 Q
 ;
INIT ; -- init variables and list array
 K APCLGRP
 S C=0,APCLITEM=0
 I $D(APCLCSEL) D
 .S N=$S(APCLCNTL="S":11,1:12)
 .S C=C+1,$E(APCLGRP(C,0),2)="Selected: "
 .S Z=0 F  S Z=$O(^APCLVRPT(APCLRPT,N,Z)) Q:Z'=+Z  S:$L(APCLGRP(C,0))>60 C=C+1 S:'$D(APCLGRP(C,0)) $E(APCLGRP(C,0),4)=" " S APCLGRP(C,0)=$G(APCLGRP(C,0))_$P(^APCLVSTS($P(^APCLVRPT(APCLRPT,N,Z,0),U),0),U)_"; "
 S X=0 F  S X=$O(^APCLGENG("O",X)) Q:X'=+X  S Y=0 F  S Y=$O(^APCLGENG("O",X,Y)) Q:Y'=+Y  D
 .Q:$P(^APCLGENG(Y,0),U,3)'[APCLPTVS
 .S C=C+1,APCLITEM=APCLITEM+1
 .S APCLGRP(C,0)=APCLITEM_".  "_$P(^APCLGENG(Y,0),U),APCLGRP("IDX",APCLITEM,APCLITEM)=Y
 .;I $D(APCLCSEL),$D(APCLCSEL("GRP",Y)) D
 .;.S C=C+1,$E(APCLGRP(C,0),5)="Selected: " S Z=0 F  S Z=$O(APCLCSEL(Z)) Q:Z'=+Z  S:$L(APCLGRP(C,0))>60 C=C+1 S:'$D(APCLGRP(C,0)) $E(APCLGRP(C,0),4)=" " S APCLGRP(C,0)=$G(APCLGRP(C,0))_$P(^APCLVSTS(Z,0),U)_"; "
 .I APCLCNTL="R",APCLSORT]"",APCLSORG=Y S C=C+1,APCLGRP(C,0)="     Sort item selected: "_$P(^APCLVSTS(APCLSORT,0),U)  ;write out items already selected
 S VALMCNT=C
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 I APCLCNTL="R",APCLSORT]"" D
 .W !!,"You have already selected a sort item and you can only select one.  If you"
 .W !,"want to keep the sort item you selected then just type '^' a the select group"
 .W !,"prompt, otherwise continue on to select a group and select a differnt sort"
 .W !,"item.",!
 S APCLGIEN=0
 W ! S DIR(0)="NO^1:"_APCLITEM_":0",DIR("A")="Which Group" D ^DIR K DIR
 I $D(DIRUT) D BACK Q
 S APCLP=Y I 'APCLP K APCLP,VALMY,XQORNOD,APCLGIEN W !,"No Group selected." Q
 S (X,Y)=0 F  S X=$O(APCLGRP("IDX",X)) Q:X'=+X!(APCLGIEN)  I $O(APCLGRP("IDX",X,0))=APCLP S Y=$O(APCLGRP("IDX",X,0)),APCLGIEN=APCLGRP("IDX",X,Y)
 I '$D(^APCLGENG(APCLGIEN,0)) W !,"Not a valid GROUP." K APCLP S APCLGIEN=0 Q
 ;D FULL^VALM1 ;give me full control of screen
 ;I now have group so go to listman to display all items in that group
 D ^APCLVL6
 D BACK
 Q
SELECTS ;select screen items
 S APCLANS=Y,APCLC="" F APCLI=1:1 S APCLC=$P(APCLANS,",",APCLI) Q:APCLC=""  S APCLCRIT=APCLSEL(APCLC) D
 .S APCLTEXT=$P(^APCLVSTS(APCLCRIT,0),U)
 .S APCLVAR=$P(^APCLVSTS(APCLCRIT,0),U,6) K ^APCLVRPT(APCLRPT,11,APCLCRIT),^APCLVRPT(APCLRPT,11,"B",APCLCRIT)
 .W !!,APCLC,") ",APCLTEXT," Selection."
 .I $O(^APCLVSTS(APCLCRIT,11,0)) D SELECTST
 .I $P(^APCLVSTS(APCLCRIT,0),U,2)]"" S APCLCNT=0,^APCLVRPT(APCLRPT,11,0)="^9001003.81101PA^0^0" D @($P(^APCLVSTS(APCLCRIT,0),U,2)_"^APCLVL0")
 .I $D(^APCLVRPT(APCLRPT,11,APCLCRIT,11,1)) S APCLCSEL(APCLC)=""
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
 I APCLANSW="",(APCLCTYP="D"!(APCLCTYP="L")) W !!,"No sort criteria selected ... will sort by "_$S(APCLPTVS="P":"Patient Name",1:"Visit Date")_"." S:APCLPTVS="V" APCLSORT=19,APCLSORV="Visit Date" D  Q
 .S:APCLPTVS="P" APCLSORT=1,APCLSORV="Patient Name"  H 2 D  Q
 ..S DA=APCLRPT,DIE="^APCLVRPT(",DR=".07////"_APCLSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 I APCLANSW="",APCLCTYP'="D",APCLCTYP'="L" W !!,"No sub-totalling will be done.",!! D  Q
 .S APCLCTYP="T"
 .H 3
 .S:APCLPTVS="V" APCLSORT=19,APCLSORV="Visit Date"
 .S:APCLPTVS="P" APCLSORT=1,APCLSORV="Patient Name"
 S APCLSORT=APCLSEL(+Y),APCLSORV=$P(^APCLVSTS(APCLSORT,0),U),DA=APCLRPT,DIE="^APCLVRPT(",DR=".07////"_APCLSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
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
 .S ^APCLVRPT(APCLRPT,12,APCLPCNT,0)=APCLCRIT_U_Y,^APCLVRPT(APCLRPT,12,"B",APCLCRIT,APCLPCNT)="",APCLTCW=APCLTCW+Y+2,APCLCSEL(APCLC)=""
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
 ..I '$D(APCLCSEL(APCLC)) W !,"Item ",APCLC," ",$P(^APCLVSTS(APCLCRIT,0),U)," has not been selected.",! Q
 ..K APCLCSEL(APCLC)
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
 Q T
Q ;EP - quit selections
 I APCLCNTL="R",APCLSORT="" S Y="" G SELECTR1
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
