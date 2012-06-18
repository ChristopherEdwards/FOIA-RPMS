BMCRL4 ; IHS/PHXAO/TMJ - NO DESCRIPTION PROVIDED 26-JUN-1996 ;    
 ;;4.0;REFERRED CARE INFO SYSTEM;**2**;JAN 09, 2006
 ;; ;
 ;BMC*4.0*1 3.3.06 IHS/OIT/FCJ CHNGED PAGE TITLE FR SELECTION TO SEARCH
EN ; -- main entry point for BMC GENRET SELECT ITEMS
 K BMCCSEL
 D EN^VALM("BMC GENRET SELECTION ITEMS")
 D CLEAR^VALM1
 K BMCDISP,BMCSEL,BMCLIST,C,X,I,K,J,BMCHIGH,BMCCUT,BMCCSEL,BMCCNTL
 K VALMHDR,VALMCNT
 Q
 ;
 D EN^VALM("BMC GENRET SELECTION ITEMS")
 Q
 ;
HDR ; -- header code
 D @("HDR"_BMCCNTL)
 Q
HDRS ;
 ;BMC*4.0*1 3.3.06 IHS/OIT/FCJ CHNGED SELECTION TO SEARCH IN NXT LINE
 ;S VALMHDR(1)="                        "_$S(BMCPTVS="R":"REFERRAL ",1:"PATIENT ")_"Selection Menu"
 S VALMHDR(1)="                        "_$S(BMCPTVS="R":"REFERRAL ",1:"PATIENT ")_"Search Menu"
 S VALMHDR(2)=$S(BMCPTVS="R":"Referrals",1:"Patients")_" can be selected based upon any of the following items.  Select"
 S VALMHDR(3)="as many as you wish, in any order or combination.  An (*) asterisk indicates"
 S VALMHDR(4)="items already selected.  To bypass screens and select all "_$S(BMCPTVS="R":"referrals",1:"patients")_" hit Q."
 Q
 ;
HDRP ;print selection header
 S VALMHDR(1)="                        PRINT ITEM SELECTION MENU"
 S VALMHDR(2)="The following data items can be printed.  Choose the items in the order you"
 S VALMHDR(3)="want them to appear on the printout.  Keep in mind that you have an 80"
 S VALMHDR(4)="column screen available, or a printer with either 80 or 132 column width."
 Q
 ;
HDRR ;sort header
 S VALMHDR(1)=""
 S VALMHDR(2)="                        SORT ITEM SELECTION MENU"
 S VALMHDR(3)="The "_$S(BMCPTVS="P":"patients",1:"referrals")_" displayed can be SORTED by ONLY ONE of the following items."
 S VALMHDR(4)="If you don't select a sort item, the report will be sorted by "_$S(BMCPTVS="R":"referral date.",1:"patient name.")
 Q
 ;
INIT ; -- init variables and list array
 K BMCDISP,BMCSEL,BMCHIGH,BMCLIST
 S BMCHIGH=0,X=0 F  S X=$O(^BMCTSORT("C",X)) Q:X'=+X  S Y=$O(^BMCTSORT("C",X,"")) I $P(^BMCTSORT(Y,0),U,5)[BMCCNTL,$P(^(0),U,11)[BMCPTVS S BMCHIGH=BMCHIGH+1,BMCSEL(BMCHIGH)=Y
 S BMCCUT=((BMCHIGH/3)+1)\1
 S (C,I)=0,J=1,K=1 F  S I=$O(BMCSEL(I)) Q:I'=+I!($D(BMCDISP(I)))  D
 .S C=C+1,BMCLIST(C,0)=I_") "_$S($D(BMCCSEL(I)):"*",1:" ")_$S($P(^BMCTSORT(BMCSEL(I),0),U,12)="":$E($P(^(0),U),1,20),1:$P(^(0),U,12)) S BMCDISP(I)="",BMCLIST("IDX",C,C)=""
 .S J=I+BMCCUT I $D(BMCSEL(J)),'$D(BMCDISP(J)) S $E(BMCLIST(C,0),28)=J_") "_$S($D(BMCCSEL(J)):"*",1:" ")_$S($P(^BMCTSORT(BMCSEL(J),0),U,12)="":$E($P(^BMCTSORT(BMCSEL(J),0),U),1,20),1:$P(^(0),U,12)) S BMCDISP(J)=""
 .S K=J+BMCCUT I $D(BMCSEL(K)),'$D(BMCDISP(K)) S $E(BMCLIST(C,0),55)=K_") "_$S($D(BMCCSEL(K)):"*",1:" ")_$S($P(^BMCTSORT(BMCSEL(K),0),U,12)="":$E($P(^BMCTSORT(BMCSEL(K),0),U),1,20),1:$P(^(0),U,12)) S BMCDISP(K)=""
 K BMCDISP
 S VALMCNT=C
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 G:BMCCNTL="R" SELECTR
 W ! S DIR(0)="LO^1:"_BMCHIGH,DIR("A")="Which "_$S(BMCPTVS="P":"patient",1:"referral")_" item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 D @("SELECT"_BMCCNTL)
ADDX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
SELECTS ;select screen items
 S BMCANS=Y,BMCC="" F BMCI=1:1 S BMCC=$P(BMCANS,",",BMCI) Q:BMCC=""  S BMCCRIT=BMCSEL(BMCC) D
 .S BMCTEXT=$P(^BMCTSORT(BMCCRIT,0),U)
 .S BMCVAR=$P(^BMCTSORT(BMCCRIT,0),U,6) K ^BMCRTMP(BMCRPT,11,BMCCRIT),^BMCRTMP(BMCRPT,11,"B",BMCCRIT)
 .W !!,BMCC,") ",BMCTEXT," Selection."
 .I $P(^BMCTSORT(BMCCRIT,0),U,2)]"" S BMCCNT=0,^BMCRTMP(BMCRPT,11,0)="^90001.82101PA^0^0" D @($P(^BMCTSORT(BMCCRIT,0),U,2)_"^BMCRL0")
 .I $D(^BMCRTMP(BMCRPT,11,BMCCRIT,11,1)) S BMCCSEL(BMCC)=""
 .Q
 D SHOW^BMCRLS
 Q
SELECTR ;sort select
 W ! S DIR(0)="NO^1:"_BMCHIGH_":0",DIR("A")=$S(BMCCTYP="S":"Sub-total ",1:"Sort ")_$S(BMCPTVS="P":"Patients",1:"referrals")_" by which of the above" D ^DIR K DIR
SELECTR1 ;
 I $D(DUOUT) W !,"Exiting" S BMCQUIT=1 Q
 I Y="",BMCCTYP="D" W !!,"No sort criteria selected ... will sort by "_$S(BMCPTVS="P":"Patient Name",1:"Referral Date")_"." S:BMCPTVS="R" BMCSORT=6,BMCSORV="Referral Date" S:BMCPTVS="P" BMCSORT=1,BMCSORV="Patient Name" H 4 D  Q
 .S DA=BMCRPT,DIE="^BMCRTMP(",DR=".07////"_BMCSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 I Y="",BMCCTYP'="D" W !!,"No sub-totalling will be done.",!! D  Q
 .S BMCCTYP="T"
 .H 3
 .S:BMCPTVS="R" BMCSORT=6,BMCSORV="Referral Date"
 .S:BMCPTVS="P" BMCSORT=1,BMCSORV="Patient Name"
 S BMCSORT=BMCSEL(+Y),BMCSORV=$P(^BMCTSORT(BMCSORT,0),U),DA=BMCRPT,DIE="^BMCRTMP(",DR=".07////"_BMCSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 Q
SELECTP ;print select - get columns
 S BMCANS=Y,BMCC="" F BMCI=1:1 S BMCC=$P(BMCANS,",",BMCI) Q:BMCC=""  S BMCCRIT=BMCSEL(BMCC),BMCPCNT=BMCPCNT+1 D
 .S DIR(0)="N^2:80:0",DIR("A")="Enter Column width for "_$P(^BMCTSORT(BMCCRIT,0),U)_" (suggested: "_$P(^BMCTSORT(BMCCRIT,0),U,7)_")",DIR("B")=$P(^(0),U,7) D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 .I $D(DIRUT) S Y=$P(^BMCTSORT(BMCCRIT,0),U,7)
 .S ^BMCRTMP(BMCRPT,12,0)="^90001.82102PA^1^1"
 .I $D(^BMCRTMP(BMCRPT,12,"B",BMCCRIT)) S X=$O(^BMCRTMP(BMCRPT,12,"B",BMCCRIT,"")),BMCTCW=BMCTCW-$P(^BMCRTMP(BMCRPT,12,X,0),U,2)-2,^BMCRTMP(BMCRPT,12,X,0)=BMCCRIT_U_Y D  Q
 ..Q
 .S ^BMCRTMP(BMCRPT,12,BMCPCNT,0)=BMCCRIT_U_Y,^BMCRTMP(BMCRPT,12,"B",BMCCRIT,BMCPCNT)="",BMCTCW=BMCTCW+Y+2,BMCCSEL(BMCC)=""
 .W !!?15,"Total Report width (including column margins - 2 spaces):   ",BMCTCW
 .Q
 Q
REM ;EP - remove a selected item - called from protocol entry
 I '$D(BMCCSEL) W !!,"No items have been selected.",! H 2 G REMX
 S DIR(0)="LO^:",DIR("A")="Remove which selected item" K DA D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G REMX
 I $D(DIRUT) W !,"No items selected." G REMX
 S BMCANS=Y,BMCC="" F BMCI=1:1 S BMCC=$P(BMCANS,",",BMCI) Q:BMCC=""  S BMCCRIT=BMCSEL(BMCC) D
 .I '$D(BMCCSEL(BMCC)) W !,"Item ",BMCC," ",$P(^BMCTSORT(BMCCRIT,0),U)," has not been selected.",! Q
 .K BMCCSEL(BMCC)
 .I BMCCNTL="S" K ^BMCRTMP(BMCRPT,11,BMCCRIT),^BMCRTMP(BMCRPT,11,"B",BMCCRIT)
 .I BMCCNTL="P" S X=$O(^BMCRTMP(BMCRPT,12,"B",BMCCRIT,0)) I X K ^BMCRTMP(BMCRPT,12,X),^BMCRTMP(BMCRPT,12,"B",BMCCRIT)
 .W !,"Item ",$P(^BMCTSORT(BMCCRIT,0),U)," removed from selected list of items."
REMX ;
 S DIR(0)="EO",DIR("A")="Hit return to continue..." K DA D ^DIR K DIR
 D BACK
 Q
Q ;EP - quit selections
 I BMCCNTL="R" S Y="" G SELECTR1
 Q
EXITR ;EP - exit report called from protocol entry
 S BMCQUIT=1
 Q
HELP ; -- help code
 D FULL^VALM1
 W:$D(IOF) @IOF
 W !,"Enter an S to Select an Item, and R to remove a selected item, Q to Quit",!,"the selection process.  To exit the report, enter an E.",!,"Hit a Q to select all ",$S(BMCPTVS="R":"referrals",1:"patients"),", bypassing all screens.",!
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
 K BMCDISP
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
