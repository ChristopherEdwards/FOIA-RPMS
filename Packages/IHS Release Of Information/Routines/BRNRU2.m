BRNRU2 ; IHS/OIT/LJF - REPORTING UTILITY - SCREEN SELECTION
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 10/25/2007 PATCH 1 Added this routine
 ;; ;
EN ;EP; -- main entry point for BRN VGEN SELECT ITEMS
 ; BRNCNTL is set to determine which selection screen
 K BRNCSEL NEW VALMCNT,VALMHDR,BRNLIST,BRNHIGH
 D EN^VALM("BRN RGEN SELECT ITEMS")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 I $G(BRNCNTL)="" Q
 D @("HDR"_BRNCNTL)
 Q
 ;
HDRS ;screen selection header
 S VALMHDR(1)=$$SP(24)_$G(IORVON)_"Disclosure Request Selection Menu"_$G(IORVOFF)
 S VALMHDR(2)="Disclosure requests can be selected based upon any of the following items."
 S VALMHDR(3)="Select as many as you wish, in any order or combination.  An (*) asterisk"
 S VALMHDR(4)="indicates items already selected.  To select all disclosures press Q."
 Q
 ;
HDRP ;print selection header
 S VALMHDR(1)=$$SP(24)_$G(IORVON)_"Print Items Selection Menu"_$G(IORVOFF)
 S VALMHDR(2)="The following data items can be printed.  Choose the items in the order you"
 S VALMHDR(3)="want them to appear on the printout.  Keep in mind that you have an 80"
 S VALMHDR(4)="column screen available, or a printer with either 80 or 132 column width."
 Q
 ;
HDRR ;sort header
 S VALMHDR(1)=""
 S VALMHDR(2)=$$SP(24)_$G(IORVON)_"Sorting Criteria Selection Menu"_$G(IORVOFF)
 S VALMHDR(3)="The disclosure requests can be SORTED by ONLY ONE of the following items."
 S VALMHDR(4)="If you don't select a sort item, the report will be sorted by Date Request Initiated"
 Q
 ;
INIT ;EP; -- build list array in BRNLIST
 K BRNLIST,BRNHIGH,BRNSEL
 NEW BRNDISP,X,Y,BRNCUT,C,J,K,I,BRNZZ
 S BRNHIGH=0,X=0 F  S X=$O(^BRNSORT("C",X)) Q:X'=+X  D
 . S Y=$O(^BRNSORT("C",X,""))
 . I $P(^BRNSORT(Y,0),U,5)[BRNCNTL S BRNHIGH=BRNHIGH+1,BRNSEL(BRNHIGH)=Y
 S BRNCUT=((BRNHIGH/3)+1)\1
 ;
 S (C,I)=0,J=1,K=1 F  S I=$O(BRNSEL(I)) Q:I'=+I  Q:($D(BRNDISP(I)))  D
 .S C=C+1,BRNZZ=$$T(I,BRNCNTL),BRNLIST(C,0)=I_")"_$S($D(BRNCSEL(I)):"*",1:" ")_BRNZZ S BRNDISP(I)="",BRNLIST("IDX",C,C)=""
 .S J=I+BRNCUT
 .I $D(BRNSEL(J)),'$D(BRNDISP(J)) S BRNZZ=$$T(J,BRNCNTL),$E(BRNLIST(C,0),28)=J_")"_$S($D(BRNCSEL(J)):"*",1:" ")_BRNZZ S BRNDISP(J)=""
 .S K=J+BRNCUT
 .I $D(BRNSEL(K)),'$D(BRNDISP(K)) S BRNZZ=$$T(K,BRNCNTL),$E(BRNLIST(C,0),55)=K_")"_$S($D(BRNCSEL(K)):"*",1:" ")_BRNZZ S BRNDISP(K)=""
 S VALMCNT=C
 Q
 ;
ADD ;EP - add an item to the selected list - called from BRN RGEN ADD ITEM protocol
 I BRNCNTL="R" D SELECTR Q   ;only one sort so drop to selection code
 ;
 NEW DIR,DUOUT,DIRUT,X,Y
 W ! S DIR(0)="LO^1:"_BRNHIGH,DIR("A")="Which disclosure item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." D PAUSE^BRNU,BACK Q
 I $D(DIRUT) W !,"No items selected." D PAUSE^BRNU,BACK Q
 D FULL^VALM1 W:$D(IOF) @IOF
 D @("SELECT"_BRNCNTL)
 D PAUSE^BRNU
 D BACK
 Q
 ;
SELECTS ;select screen items
 ; RETURNS BRNCSEL variable
 NEW BRNC,BRNI,BRNANS
 S BRNANS=Y  ;answer from ADD subroutine
 S BRNC="" F BRNI=1:1 S BRNC=$P(BRNANS,",",BRNI) Q:BRNC=""  S BRNCRIT=BRNSEL(BRNC) D
 . S BRNTEXT=$P(^BRNSORT(BRNCRIT,0),U)     ;item name
 . S BRNVAR=$P(^BRNSORT(BRNCRIT,0),U,6)    ;column header
 . K ^BRNRPT(BRNRPT,11,BRNCRIT),^BRNRPT(BRNRPT,11,"B",BRNCRIT)  ;clean out report temp file
 . W !!,BRNC,") ",BRNTEXT," Selection."
 . I $P(^BRNSORT(BRNCRIT,0),U,2)]"" S BRNCNT=0,^BRNRPT(BRNRPT,11,0)="^90264.81101PA^0^0" D @($P(^BRNSORT(BRNCRIT,0),U,2)_"^BRNRU21")
 . I $D(^BRNRPT(BRNRPT,11,BRNCRIT,11,1)) S BRNCSEL(BRNC)=""  ;add to selection list
 D SHOW^BRNRUS
 Q
 ;
SELECTR ;sort select
 ; returns BRNSORT & BRNSORV variables
 NEW DIR,BRNANS,DIE,DA,DR
 W ! S DIR(0)="NO^1:"_BRNHIGH_":0"
 S DIR("A")=$S(BRNCTYP="S":"Sub-total ",1:"Sort ")_"Disclosure requests by which of the above"
 D ^DIR K DIR
 ;
SELCTR1 ; called by Q subrouitne in case user decided not to select a sort
 ;
 I $D(DUOUT) W !,"exiting" S BRNQUIT=1 Q
 S BRNANS=Y
 ;
 I BRNANS="",(BRNCTYP="D"!(BRNCTYP="L")) D  Q
 . W !!,"No sort criteria selected ... will sort by Patient Name."
 . S BRNSORT=1,BRNSORV="Patient Name"  H 2 D  Q
 . . S DA=BRNRPT,DIE="^BRNRPT(",DR=".07////"_BRNSORT
 . . D ^DIE K DIU,DIV,DIY,DIW
 ;
 I BRNANS="",BRNCTYP'="D",BRNCTYP'="L" W !!,"No sub-totalling will be done.",!! D  Q
 . S BRNCTYP="T"
 . H 3
 . S BRNSORT=1,BRNSORV="Patient Name"
 ;
 S BRNSORT=BRNSEL(+BRNANS),BRNSORV=$P(^BRNSORT(BRNSORT,0),U)
 S DA=BRNRPT,DIE="^BRNRPT(",DR=".07////"_BRNSORT
 D ^DIE K DIU,DIV,DIY,DIW
 Q
 ;
SELECTP ;print select - get columns
 NEW BRNANS,BRNC,BRNI,DIR
 S BRNANS=Y,BRNC=""
 F BRNI=1:1 S BRNC=$P(BRNANS,",",BRNI) Q:BRNC=""  S BRNCRIT=BRNSEL(BRNC),BRNPCNT=BRNPCNT+1 D
 . I BRNCTYP="D" D
 . . S DIR(0)="N^2:80:0"
 . . S DIR("A")="Enter Column width for "_$P(^BRNSORT(BRNCRIT,0),U)_" (suggested: "_$P(^BRNSORT(BRNCRIT,0),U,7)_")"
 . . S DIR("B")=$P(^(0),U,7)
 . . D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 . . I $D(DIRUT) S Y=$P(^BRNSORT(BRNCRIT,0),U,7)
 . ;
 . I BRNCTYP="L" S Y=""
 . S ^BRNRPT(BRNRPT,12,0)="^9001003.81102PA^1^1"
 . ;
 . I $D(^BRNRPT(BRNRPT,12,"B",BRNCRIT)) D
 . . S X=$O(^BRNRPT(BRNRPT,12,"B",BRNCRIT,""))
 . . S BRNTCW=BRNTCW-$P(^BRNRPT(BRNRPT,12,X,0),U,2)-2
 . . S ^BRNRPT(BRNRPT,12,X,0)=BRNCRIT_U_Y
 . ;
 . S ^BRNRPT(BRNRPT,12,BRNPCNT,0)=BRNCRIT_U_Y
 . S ^BRNRPT(BRNRPT,12,"B",BRNCRIT,BRNPCNT)=""
 . S BRNTCW=BRNTCW+Y+2,BRNCSEL(BRNC)=""
 . I BRNCTYP="D" W !!?15,"Total Report width (including column margins - 2 spaces):   ",BRNTCW
 . ;
 . ;new functionality to print 1 or all
 . Q:'$D(^BRNRPT(BRNRPT,11,"B",BRNCRIT))  ;didn't select this item
 . Q:'$P(^BRNSORT(BRNCRIT,0),U,13)        ;not one of these items
 . ;
 . ;one or all
 . W !!,"***  This item, ",$P(^BRNSORT(BRNCRIT,0),U)," was a selection item.  Do you want to print"
 . W !,"ALL ",$P(^BRNSORT(BRNCRIT,0),U),"'s or just those you selected.",!
 . S DIR(0)="S^A:ALL items;O:Only the ones selected"
 . S DIR("A")="For this item",DIR("B")="A" KILL DA
 . D ^DIR KILL DIR
 . I $D(DIRUT) S Y="A"
 . I Y="O" S $P(^BRNRPT(BRNRPT,12,BRNPCNT,0),U,3)=1
 Q
 ;
REM ;EP - remove a selected item - called from protocol entry
 NEW BRNC,DIR,BRNI
 I '$D(BRNCSEL) W !!,"No items have been selected.",! H 2 G REMX
 S DIR(0)="LO^:",DIR("A")="Remove which selected item" K DA
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G REMX
 I $D(DIRUT) W !,"No items selected." G REMX
 S BRNANS=Y,BRNC="" F BRNI=1:1 S BRNC=$P(BRNANS,",",BRNI) Q:BRNC=""  S BRNCRIT=BRNSEL(BRNC) D
 . I '$D(BRNCSEL(BRNC)) W !,"Item ",BRNC," ",$P(^BRNSORT(BRNCRIT,0),U)," has not been selected.",! Q
 . K BRNCSEL(BRNC)
 . I BRNCNTL="S" K ^BRNRPT(BRNRPT,11,BRNCRIT),^BRNRPT(BRNRPT,11,"B",BRNCRIT)
 . I BRNCNTL="P" S X=$O(^BRNRPT(BRNRPT,12,"B",BRNCRIT,0)) I X K ^BRNRPT(BRNRPT,12,X),^BRNRPT(BRNRPT,12,"B",BRNCRIT)
 . W !,"Item ",$P(^BRNSORT(BRNCRIT,0),U)," removed from selected list of items."
REMX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
 ;
T(Z,Y) ; resets print menu header if defined for this item
 NEW T
 S T=$P(^BRNSORT(BRNSEL(Z),0),U)
 I $P(^BRNSORT(BRNSEL(Z),0),U,12)]"",Y="P" S T=$P(^BRNSORT(BRNSEL(Z),0),U,12)
 Q T
 ;
Q ;EP - quit selections
 I BRNCNTL="R" S Y="" G SELCTR1
 Q
 ;
EXITR ;EP - exit report called from protocol entry
 S BRNQUIT=1
 Q
 ;
HELP ; -- help code
 D FULL^VALM1
 W:$D(IOF) @IOF
 W !,"Enter an S to Select an Item, and R to remove a selected item, Q to Quit"
 W !,"the selection process.  To exit the report, enter an E."
 W !,"Hit a Q to select all disclosure requests, bypassing all screens.",!
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
 ;
EXIT ; -- exit code
 K BRNDISP
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ;EP -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
