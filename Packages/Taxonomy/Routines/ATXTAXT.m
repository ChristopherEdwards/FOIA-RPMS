ATXTAXT ; IHS/CMI/LAB - DISPLAY TAX ;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("ATX TAXONOMY GENERIC LIST")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 K ATXLIST,J,C
 D ^XBFMK
 Q
 ;
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
HDR ; -- header code
 S VALMHDR(1)="ADD OR EDIT "_$P(^ATXTYPE(ATXTAXT,0),U)_" TAXONOMIES"
 S VALMHDR(2)="TAXONOMY NAME",$E(VALMHDR(2),38)="DESCRIPTION",$E(VALMHDR(2),70)="FILE"
 Q
 ;
INIT ; -- init variables and list array
 I ATXFILE=60 D LABINIT Q
 K ATXLIST S ATXHIGH="",C=0
 S J=0 F  S J=$O(^ATXAX(J)) Q:J'=+J  D
 .I $P(^ATXAX(J,0),U,15)'=ATXFILE Q
 .S C=C+1
 .S D=$P(^ATXAX(J,0),U,2)
 .S ATXLIST(C,0)=C_")  "_$P(^ATXAX(J,0),U),$E(ATXLIST(C,0),38)=D,$E(ATXLIST(C,0),70)=ATXFILE
 .S ATXLIST("IDX",C,C)=J
 .Q
 S (VALMCNT,ATXHIGH)=C
 Q
LABINIT ;
 K ATXLIST S ATXHIGH="",C=0
 S J=0 F  S J=$O(^ATXLAB(J)) Q:J'=+J  D
 .S C=C+1
 .S D=$P(^ATXLAB(J,0),U,2)
 .S ATXLIST(C,0)=C_")  "_$P(^ATXLAB(J,0),U),$E(ATXLIST(C,0),38)=D,$E(ATXLIST(C,0),70)=ATXFILE
 .S ATXLIST("IDX",C,C)=J
 .Q
 S (VALMCNT,ATXHIGH)=C
 Q
 ;
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
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
SEL ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 W !
 S DIR(0)="NO^1:"_ATXHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy selected." G ADDX
 S ATXTAXI=$P(ATXLIST("IDX",Y,Y),U,1),ATXTAXN=$S(ATXFILE=60:$P(^ATXLAB(ATXTAXI,0),U),1:$P(^ATXAX(ATXTAXI,0),U))
 D FULL^VALM1 W:$D(IOF) @IOF
 D EP^ATXTAXE
ADDX ;
 D BACK
 Q
ADDNEW ;EP  add new taxonomy of this type
 D FULL^VALM1
 I ATXFILE=60 D LABADD G ADDNEWX
 NEW ATXN,ATXF,ATXADD,ATXFLG,ATXTAXI,ATXL,ATXQ
 W !
 S DIR(0)="F^3:30",DIR("A")="Enter Taxonomy Name" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G ADDNEWX
 I Y="" G ADDNEWX
 S ATXN=Y
 S ATXF=$P(^ATXTYPE(ATXTAXT,0),U,2)
 S X="",Y=0
 F  S X=$O(^ATXAX("B",ATXN,X)) Q:X=""  I $P(^ATXAX(X,0),U,15)=ATXF S Y=Y+1,ATXL(X)=$P(^ATXAX(X,0),U,1)_"  created by: "_$$VAL^XBDIQ1(9002226,X,.05)
 I $O(ATXL(0)) S ATXQ=0 D  I ATXQ G ADDNEW
 .W !!,"There ",$S(Y>1:"are ",1:"is a "),$P(^DIC(ATXF,0),U,1),$S(Y>1:" taxonmies ",1:" taxonomy ")," with that name."
 .S X=0 F  S X=$O(ATXL(X)) Q:X'=+X  W !?5,ATXL(X)
 .S DIR(0)="Y",DIR("A")="Are you sure you want to create another one",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S ATXQ=1 Q
 .I 'Y S ATXQ=1 Q
 S ATXADD=1,ATXFLG=1
 K DIC
 S X=ATXN,DIC="^ATXAX("
 ;,DIC("DR")=".02;5101",
 S DIC(0)="L",DIADD=1,DLAYGO=902226 D ^DIC K DIC,DIADD,DLAYGO
 I Y=-1 G ADDNEWX
 S ATXTAXI=+Y
 NEW ATXT,ATXNC
 S ATXT=$O(^ATXTYPE("C",ATXFILE,0)),ATXNC=$P(^ATXTYPE(ATXT,0),U,4)
 S DA=ATXTAXI,DIE="^ATXAX("
 S DR=".05////"_DUZ_";.09////"_DT_";.12////"_$P(^ATXTYPE(ATXTAXT,0),U,3)_";.13////"_ATXNC_";.15////"_$P(^ATXTYPE(ATXTAXT,0),U,2)
 D ^DIE K DIE,DA,DR
 I $D(Y) W !!,"error creating taxonomy........" S DA=ATXTAXI,DIK="^ATXAX(" D ^DIK K DIK,DA D PAUSE G ADDNEWX
 S ATXTAXN=$P(^ATXAX(ATXTAXI,0),U)
 D EP^ATXTAXE
ADDNEWX ;
 D BACK
 Q
LABADD ;
 NEW ATXN,ATXF,ATXADD,ATXFLG,ATXTAXI,ATXL,ATXQ
 W !
 S DIR(0)="F^3:30",DIR("A")="Enter Taxonomy Name" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G ADDNEWX
 I Y="" G ADDNEWX
 S ATXN=Y
 S ATXF=$P(^ATXTYPE(ATXTAXT,0),U,2)
 S X="",Y=0
 F  S X=$O(^ATXAX("B",ATXN,X)) Q:X=""  I $P(^ATXAX(X,0),U,15)=ATXF S Y=Y+1,ATXL(X)=$P(^ATXAX(X,0),U,1)_"  created by: "_$$VAL^XBDIQ1(9002226,X,.05)
 I $O(ATXL(0)) S ATXQ=0 D  I ATXQ G ADDNEW
 .W !!,"There ",$S(Y>1:"are ",1:"is a "),$P(^DIC(ATXF,0),U,1),$S(Y>1:" taxonmies ",1:" taxonomy ")," with that name."
 .S X=0 F  S X=$O(ATXL(X)) Q:X'=+X  W !?5,ATXL(X)
 .S DIR(0)="Y",DIR("A")="Are you sure you want to create another one",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S ATXQ=1 Q
 .I 'Y S ATXQ=1 Q
 K DIC
 S X=ATXN,DIADD=1,DLAYGO=9002228,DIC="^ATXLAB(",DIC("DR")=".02;.15////60",DIC(0)="L" D ^DIC K DIC,DIADD,DLAYGO
 I Y=-1 G ADDNEWX
 S ATXTAXI=+Y
 S DA=ATXTAXI,DIE="^ATXLAB("
 S DR=".09////"_DT_";.11Should this taxonomy include Panels?"
 D ^DIE K DIE,DA,DR
 I $D(Y) W !!,"error creating taxonomy........" S DA=ATXTAXI,DIK="^ATXAX(" D ^DIK K DIK,DA D PAUSE G ADDNEWX
 S ATXTAXN=$P(^ATXLAB(ATXTAXI,0),U)
 D EP^ATXTAXE
 G ADDNEWX
