BMCCHSE ;IHS/OIT/FCJ - CHS EDIT INFORMATION
 ;;4.0;REFERRED CARE INFO SYSTEM;**8**;JAN 09, 2006;Build 51
 ;
 ;IHS.OIT.FCJ; NEW RTN IN PATCH 8 TO ALLOW ADDING CHS DENIAL REASONS
 ;
 ;
DENR ;ENTRY POINT FROM BMCMOD
 ;
TOF ;
 ;S BMCRIEN=113239
 S BMCOPTR="E"
 W @IOF,$$REPEAT^XLFSTR("=",79),!?30,"DENIAL REASONS EDIT",!,$$REPEAT^XLFSTR("=",79),!!,"PRIMARY DENIAL REASON: ",!
PRIREAS ; PRIMARY REASON
 S X=$P($G(^BMCREF(BMCRIEN,11)),U,14),X1=$P($G(^BMCREF(BMCRIEN,61)),U,20)
 S BMCREA(1)=U_X_U_X1
 I X,$D(^ACHSDENS(X,0)) D
 .W !?10,"1. ",$P($G(^ACHSDENS(X,0)),U),!
 .W:X1 ?15,$P($G(^ACHSDENS(X,20,X1,0)),U)
 E  W !!,*7,*7,"No Primary Denial Reason Has Been Entered" S BMCRED="",BMCOPTR="N",%=1,BMCR="Primary " D PRIM G TOF
 ;
OTHREAS ; List other Denial Reasons
 I $D(^BMCREF(BMCRIEN,43)) D
 .S BMCREA=0,BMCCNT=2
 .F  S BMCREA=$O(^BMCREF(BMCRIEN,43,BMCREA)) Q:BMCREA'?1.N  D
 ..I BMCCNT=2 W !!,"OTHER DENIAL REASONS: ",!
 ..S BMCOTR=$P(^BMCREF(BMCRIEN,43,BMCREA,0),U),BMCROPT=$P(^(0),U,2)
 ..W !?10,BMCCNT,". ",$P($G(^ACHSDENS(BMCOTR,0)),U),!
 ..I BMCROPT W ?15,$P($G(^ACHSDENS(BMCOTR,20,BMCROPT,0)),U)
 ..S BMCREA(BMCCNT)=BMCREA_U_BMCOTR_U_BMCROPT
 ..S BMCCNT=BMCCNT+1
 ;
EDIT ; EDIT REASONS
 ;
 S %=$$DIR^ACHS("FO","Enter Number Of Reason To Edit, 'A' To ADD Reason","","","",2)
 I (%="")!$D(DUOUT)!$D(DTOUT) D END Q
 S Y=+%,%=$S(+%=1:"PRIM","Aa"[%:"ADD",1:"OTHER")
 I (Y>BMCCNT)!((%="OTHER")&('$D(BMCREA(Y)))) W !,"Please enter a number from 1 to ",BMCCNT,"." G EDIT
 S BMCRED=+Y,BMCR=$S(%=1:"Primary",1:"Other ")
 D @%
 K BMCREA G TOF
 ;
END ;
 K BMCREA,TMP,BMCCNT,BMCDEN
 K BMCENR,BMCENS,BMCOPTR,BMCOREO,BMCORNM,BMCOTR,BMCR,BMCRED,BMCREDT,CT,L
 Q
 ;
PRIM ;
 D REA Q:$D(DUOUT)
 I X="@" W !!?5,"Must have a Primary Denial Reason." H 1 Q
 ;EDITING REASON THEN CHECK TO SEE IF DUPLICATE
 S (X,BMCOTR,BMCENR)=+Y
 S:BMCRED BMCORNM=$P(BMCREA(BMCRED),U)
 S BMCOREO=$P($G(^ACHSDENS(BMCOTR,0)),U)
 I BMCRED,BMCOTR'=$P(BMCREA(BMCRED),U,2) G PRIM:$$REASCK() S BMCENR=+Y
 Q:$D(DUOUT)
 D REAOPT
 I $D(Y),+Y<0 W !?5,"Denial Option did not change." H 1
 Q
 ;
OTHER ;EDIT OTHER DENIAL REASON
 D REA Q:$D(DUOUT)
 S BMCORNM=$P(BMCREA(BMCRED),U)
 I X="@" D OTHSET Q  ;THEN DELETE ENTRY...
 ;I EDITING REASON THEN CHECK TO SEE IF DUPLICATE
 S (X,BMCOTR)=+Y
 S BMCOREO=$P($G(^ACHSDENS(BMCOTR,0)),U)
 I BMCOTR'=$P(BMCREA(BMCRED),U,2) G OTHER:$$REASCK() D OTHSET
 D OPTSET
 Q
 ;
REA ;  Denial Reason
 S X=0,CT=0,BMCREDT=""
 W !!?3,"Denial Reason List:"
 F  S X=$O(^ACHSDENS(X)) Q:X'?1N.N  D
 .I $D(^ACHSDENS(X,10)),$P(^ACHSDENS(X,10),U)>"" Q:$P(^ACHSDENS(X,10),U)<DT
 .S CT=CT+1 W !?5,CT,". ",$P(^ACHSDENS(X,0),U)
 .S BMCENS(CT)=X_U_$P(^ACHSDENS(X,0),U)
 .I BMCRED,X=$P($G(BMCREA(BMCRED)),U,2) S BMCREDT=CT
 I CT=0 W !,"No active Denial Reasons" S Y=-1 Q
 W !
 S BMCDEN="" I BMCRED>0 S BMCDEN=$P(^ACHSDENS($P(BMCREA(BMCRED),U,2),0),U)
 S DIR(0)="NO^1:"_CT
 S DIR("A")="Enter "_BMCR_" Denial Reason: "_BMCDEN
 S DIR("B")=BMCREDT
 D ^DIR
 Q:$D(DUOUT)
 S TMP=""
 I +Y>0 S TMP=BMCENS(Y)
 I BMCR["Other",+Y>0,Y'=BMCREDT,BMCCNT>1,%="OTHER" S X="@",BMCORNM=$P(BMCREA(BMCRED),U) D
 .D OTHSET
 .I $P(^BMCREF(BMCRIEN,43,0),U,4)<1 S $P(^(0),U,3,4)="1^1"
 S:TMP Y=TMP
 K DIR
 Q
REASCK() ; ---  Check if the Denial reason has already been entered.
 N X,X1,Y
 S (X,X1,Y)=0
 ;X1=TOTAL OPTIONS AVAILABLE;X=TOTAL REASON OR OPTIONS USED
 F  S X=$O(^ACHSDENS(BMCOTR,20,X)) Q:X'?1N.N  D
 .I $P(^ACHSDENS(BMCOTR,20,X,0),U,2)'="",$P(^(0),U,2)<DT Q
 .S X1=X1+1
 ;I X1=0 NO OPTION AVAILABLE JUST USING REASON
 I X1<2,BMCOTR=$P(^BMCREF(BMCRIEN,11),U,14),BMCOPTR="N" W !!,*7,*7,"DENIAL REASON/OPTIONS ALREADY SELECTED.",!! Q 1
 S X=0 I BMCOTR=$P(^BMCREF(BMCRIEN,11),U,14) S X=X+1
 I $D(^BMCREF(BMCRIEN,43)) S L=0 F  S L=$O(^BMCREF(BMCRIEN,43,L)) Q:L'?1N.N  D
 .I $P(^BMCREF(BMCRIEN,43,L,0),U)=BMCOTR S X=X+1
 I X<X1 Q Y
 W !!?5,"DENIAL REASON/OPTIONS ALREADY SELECTED. Need to select another.",!!
 Q 1
 ;
REAOPT ; Primary Reason Option
 S Y=+$$DICOPT(BMCENR,"Primary ")
 I BMCOPTR="E" Q:+Y<0  G REAOPT:$$OPTCK("P")
 I +Y<0,(BMCOREO["Residency")!(BMCOREO["Notification")!(BMCOREO["Alternate")!(BMCOREO["Medical")!(ACHSDREA["Indian") W !,"Must select an option for this Denial Reason." G REAOPT
 S BMCROPT=+Y
 I Y>0 S DA=BMCRIEN,DIE="^BMCREF(" D PRMSET,PRMOSET
 Q
PRMSET ;PRIMARY DENIAL REASON SET
 S DR="1114////"_BMCENR
 D ^DIE
 K DR
 Q
PRMOSET ;
 S DR="6120///"_BMCROPT
 D ^DIE
 K DA,DIE,DR
 Q
OTHSET ;SET OTHER DENIAL REASON - NODE 43
 S (DIC,DIE)="^BMCREF("_BMCRIEN_",43,"
 S DIC(0)="L",DA(1)=BMCRIEN,DA=BMCORNM
 S DR=".01_///"_X
 D ^DIE
 K DIE,DA,DR
 Q
OPTSET ;SET OPTION FOR OTHER DENIAL REASON NODE 43
 ;ask for option
 S Y=$$DICOPT(BMCOTR,"Other ")
 I $D(DUOUT),BMCOPTR'="E" S X="@" D OTHSET Q
 I $D(DUOUT),BMCOPTR="E" D  Q
 .;TEST FOR REASONS REQ AN OPTION, IF NONE SELECTED DELETE
 .I (BMCOREO["Residency")!(BMCOREO["Notification")!(BMCOREO["Alternate")!(BMCOREO["Medical")!(BMCOREO["Indian") D
 ..S BMCROPT=$P(^BMCREF(BMCRIEN,43,BMCORNM,0),U,2)
 ..I BMCROPT="" S X="@" D OTHSET Q
 G OPTSET:$$OPTCK("O")     ;TEST FOR USING SAME OPT
 I +Y<0,(BMCOREO["Residency")!(BMCOREO["Notification")!(BMCOREO["Alternate")!(BMCOREO["Medical")!(BMCOREO["Indian") W !,"Must select an option for this Denial Reason." G OPTSET
 I +Y<0 Q
 S (DIC,DIE)="^BMCREF("_BMCRIEN_",43,"
 S DIC(0)="L",DA(1)=BMCRIEN,DA=BMCORNM
 S DR=".02///"_+Y
 D ^DIE
 S BMCROPT=$P(^BMCREF(BMCRIEN,43,BMCORNM,0),U,2)
 K DA,DIE
 Q
 ;
DICOPT(X,R) ; --- Select Denial reason Option.
 I '$D(^ACHSDENS(X,20,0)) Q -1
 ;DISPLAY REA OPTIONS
 W !!?3,"Denial Reason Option list:"
 S X1=0,CT=0
 F  S X1=$O(^ACHSDENS(X,20,X1)) Q:X1'?1N.N  D
 .I $P(^ACHSDENS(X,20,X1,0),U,2)'="",$P(^(0),U,2)<DT Q
 .S CT=CT+1 W !?5,CT,". ",$P(^ACHSDENS(X,20,X1,0),U)
 .S BMCENO(CT)=X1_U_$P(^ACHSDENS(X,20,X1,0),U)
 I CT=0 W !,"No active Denial Reasons Options" S Y=-1 Q
 W !
 S DIR(0)="NO^1:"_CT
 S DIR("A")="Enter "_$G(R)_"Denial Reason Option "
 D ^DIR
 I +Y>0 S Y=BMCENO(Y)
 E  S Y=-1
 K BMCENO
 Q +Y
 ;
OPTCK(T) ; CHECK FOR OPTIONS ALREADY SELECTED ;ACHS*3.1*19 NEW SECTION
 S (X,X1)=0
 I T="O",$P(^BMCREF(BMCRIEN,11),U,14)=BMCOTR,$P(^BMCREF(BMCRIEN,61),U,20)=+Y W !!,*7,*7,"DENIAL REASON OPTION ALREADY SELECTED.",!! S X1=1 H 1 Q X1
 F  S X=$O(^BMCREF(BMCRIEN,43,X)) Q:+X=0  D  Q:X1
 .I BMCOPTR="E",X=BMCORNM Q
 .Q:$P($G(^BMCREF(BMCRIEN,43,X,0)),U)'=BMCOTR
 .I $P($G(^BMCREF(BMCRIEN,43,X,0)),U,2)=+Y W !!,*7,*7,"DENIAL REASON OPTION ALREADY SELECTED.....",!! S X1=1 H 1
 Q X1
 ;
ADD ;ADD OTHER DENIAL REASON
 S BMCOPTR="N"
 D REA
 Q:+Y<1
 ;I BMCCNT=1 ADD PRIMARY REASON AND DO NOT NEED TO CHECK for duplicates
 I BMCR["Primary" S BMCENR=+Y D REAOPT Q
 ;I BMCCNT>1 ADD OTHER REASON AND NEED TO CHECK FOR DUPLICATES
 S BMCOTR=+Y
 S BMCOREO=$P($G(^ACHSDENS(BMCOTR,0)),U)
 G ADD:$$REASCK()
 ;I '$D(^BMCREF(BMCRIEN,43,0)) D
 S DIC="^BMCREF("_BMCRIEN_",43,"
 S DIC("P")=$P(^DD(90001,4300,0),U,2)
 S DIC(0)="L",DA(1)=BMCRIEN,X=BMCOTR
 S DIC("DR")=".01///"_X
 D FILE^BMCFMC S BMCORNM=+Y
 D:+Y>0 OPTSET
 Q
 ;