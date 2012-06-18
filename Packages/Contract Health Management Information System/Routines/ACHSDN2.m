ACHSDN2 ; IHS/ITSC/PMF - DENIAL SET UP & DISPLAY ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3,4,10,12,18,19**;JUN 11,2001
 ;ACHS*3.1*3  improve denial/patient lookup
 ;            also, handle 'alt resource availabe' as special
 ;ACHS*3.1*4  close device before passing DUMP to taskman
 ;ACHS*3.1*10 4.22.04 IHS/ITSC/FCJ TEST FOR REF TO SET DENIAL REASON
 ;ACHS*3.1*12 12.1.06 IHS/OIT/FCJ ADDED ABILILTY "^" OUT
 ;ACHS*3.1*18 8.29.2010 IHS.OIT.FCJ MULTIPLE CHANGES FOR REWRITE OF DENIAL LETTER
 ;
Q1 ;
 W !!,"If the PROVIDER (vendor) is in the CHS VENDOR FILE,",!,"answer 'Y'.  If not, answer 'N'.",!!
 Q
 ;
PRIORCK ;EP - Enter Priority Category.
 I $L($$DN^ACHS(400,2)) S Y=1 Q
 S Y=0
 W !!,*7,"A PRIORITY CATEGORY is required - try again."
 Q
 ;
REASON ;EP - Enter Denial Reasons.
 N ACHDORNM,ACHDOTR S ACHDOPTR="N"
 D REAS1 Q:$D(DUOUT)  D OTHREAS Q        ;ACHS*3.1*18
REAS1 ;
 ;Primary Denial Reason
 S ACHDROPT=""
 I ACHDOPTR="N",$$DN^ACHS(250,1) W !!,"Primary Denial Reason:  ",$P($G(^ACHSDENS($$DN^ACHS(250,1),0)),U) G OTHREAS
 S Y=$$DICREA("Primary ")
 ;ACHS*3.1*12 12.1.06 IHS/OIT/FCJ ADDED ABILILTY "^" OUT
 I ACHDOPTR="E" G REAS1:$$REASCK()
 I $D(DUOUT) S ACHSERR=1 Q
 I Y<0 D REASERR G REASON
 S ACHDENR=+Y
 ;ACHS*3.1*10 4.22.04 IHS/ITSC/FCJ TEST FOR REF TO SET DENIAL REASON
 I $G(ACHSREF) S ACHSREF(1114)=ACHDENR ;ACHS*3.1*10 4.22.04
 S ACHSDREA=$P($G(^ACHSDENS(ACHDENR,0)),U)  ;ACHS*3.1*18 NEW LINE
 I '$$DIE^ACHSDN("250////"_ACHDENR) Q
 I $D(Y) S DUOUT="" Q
 ;
REAOPT ;EP-ACHSDN4 ;ACHS*3.1*18
 S Y=+$$DICOPT(ACHDENR,"Primary ")
 I ACHDOPTR="E" Q:+Y<0  G REAOPT:$$OPTCK("P")
 I +Y<0,(ACHSDREA["Residency")!(ACHSDREA["Notification")!(ACHSDREA["Alternate")!(ACHSDREA["Medical")!(ACHSDREA["Indian") W !,"Must select an option for this Denial Reason." G REAOPT  ;ACHS*3.1*18
 S ACHDROPT=Y
 I Y>0,'$$DIE^ACHSDN("252///"_Y) Q
 ;
 ;1/10/02  pmf
 ;okay, we got a primary reason.  Now, if that reason is
 ;  'Alternate Resource Available', ask them WHICH resource
 ;I X["Alternate Resource Available" D ^ACHSDN2A I $D(DTOUT)!$D(DUOUT)!$G(ACHSQUIT) Q  ; ACHS*3.1*3
 I ACHSDREA["Alternate Resource Available" D TYPPRI^ACHSDN2A I $D(DTOUT)!$D(DUOUT) Q  ; ACHS*3.1*18
 I '$$DIE^ACHSDN(255,2) Q      ;DENIAL RESAON COMMENTS
 Q                             ;ACHS*3.1*18
 ;
OTHREAS ;EP-ACHSDN4
 I $D(^ACHSDEN(DUZ(2),"D",ACHSA,300)) D REASLST
 S Y=$$DICREA("Other ")
 I X[U S DUOUT="" Q
 Q:Y<0
 ;
 S ACHDOTR=+Y  ; ACHS*3.1*3
 S ACHDOREO=$P($G(^ACHSDENS(ACHDOTR,0)),U)
 G OTHREAS:$$REASCK()
 I '$D(^ACHSDEN(DUZ(2),"D",ACHSA,300,0)) S ^ACHSDEN(DUZ(2),"D",ACHSA,300,0)=$$ZEROTH^ACHS(9002071,1,300)
 S ACHDORNM=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,300,0)),U,3)+1
 S ^ACHSDEN(DUZ(2),"D",ACHSA,300,ACHDORNM,0)=ACHDOTR
 S ^ACHSDEN(DUZ(2),"D",ACHSA,300,"B",ACHDOTR,ACHDORNM)=""
 S $P(^ACHSDEN(DUZ(2),"D",ACHSA,300,0),U,3,4)=ACHDORNM_U_ACHDORNM
 I '$D(^ACHSDEN(DUZ(2),"D",ACHSA,300,ACHDORNM,0)) W !!,"YOUR ENTRY WAS NOT ACCEPTED",!,"PLEASE TRY AGAIN.",!! G OTHREAS
 ;
 ;if this reason has no options, ask for next reason
 ;I '$D(^ACHSDENS(ACHDOTR,20,0)) G OTHREA1
 I $D(^ACHSDENS(ACHDOTR,20,0)) D OTHREAO
OTHREA1 ; --- Other Denial Reason : Comment
 W !
 S DIE="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",300,"
 S DA(2)=DUZ(2)
 S DA(1)=ACHSA
 S DA=ACHDORNM
 S DR=3
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA,300)","+") Q
 D ^DIE
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA,300)","-") Q
 I ACHDOPTR="N",'$D(^ACHSDEN(DUZ(2),"D",ACHSA,300,1,0)) K ^ACHSDEN(DUZ(2),"D",ACHSA,300)
 Q:ACHDOPTR="E"
 G OTHREAS
 ;
OTHREAO ;EP-ACHSDN4 ;ACHS*3.1*18
 ;ask for option
 S Y=$$DICOPT(ACHDOTR,"Other ")
 G OTHREAO:$$OPTCK("O")     ;ACHS*3.1*19 TEST FOR USING SAME OPT
 I $D(DUOUT) Q:ACHDOPTR="E"  D DEL G OTHREAS
 I +Y<0,(ACHDOREO["Residency")!(ACHDOREO["Notification")!(ACHDOREO["Alternate")!(ACHDOREO["Medical")!(ACHDOREO["Indian") W !,"Must select an option for this Denial Reason." G OTHREAO  ;ACHS*3.1*18
 I +Y<0 G OTHREA1
 S DIE="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",300,"
 S DA(2)=DUZ(2)
 S DA(1)=ACHSA
 S DA=ACHDORNM
 S DR="2///"_+Y
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA,300,ACHDORNM)","+") Q
 D ^DIE
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA,300,ACHDORNM)","-") Q
 S ACHDROPT=$P(^ACHSDEN(DUZ(2),"D",ACHSA,300,ACHDORNM,0),U,2)
 ;
 ;1/14/02  pmf
 ;if the reason was alternate resource, ask which one
 ;I ACHDOREO["Alternate Resource Available" D ^ACHSDN2A I $D(DTOUT)!$D(DUOUT)!$G(ACHSQUIT) Q  ; ACHS*3.1*3
 I ACHDOREO["Alternate Resource Available" D TYPOTH^ACHSDN2A I $D(DTOUT)!$D(DUOUT)!$G(ACHSQUIT) Q  ; ACHS*3.1*18
 Q
 ;
REASERR ;
 W !!,*7,*7,*7,"A Primary Denial Reason Must Be Entered",!,"Please Try Again.",!
 Q
 ;
DICREA(R) ; --- Select Denial Reason.
 ;DISPLAY DEN REASONS ;ACHS*3.1*19 RE-WRITTEN FOR PATCH 19
 N X
 S X=0,CT=0
 W !!?3,"Denial Reason List:"
 F  S X=$O(^ACHSDENS(X)) Q:X'?1N.N  D
 .I $D(^ACHSDENS(X,10)),$P(^ACHSDENS(X,10),U)>"" Q:$P(^ACHSDENS(X,10),U)<DT
 .S CT=CT+1 W !?5,CT,". ",$P(^ACHSDENS(X,0),U)
 .S ACHDENS(CT)=X_U_$P(^ACHSDENS(X,0),U)
 I CT=0 W !,"No active Denial Reasons" S Y=-1 Q
 W !
 S DIR(0)="NO^1:"_CT
 S DIR("A")="Enter "_$G(R)_"Denial Reason "
 D ^DIR
 I +Y>0 S Y=ACHDENS(Y)
 E  S Y=-1
 Q +Y
 ;
DICOPT(X,R) ; --- Select Denial reason Option.
 I '$D(^ACHSDENS(X,20,0)) Q -1
 ;DISPLAY REA OPTIONS ;ACHS*3.1*19 REWRITTEN
 W !!?3,"Denial Reason Option list:"
 S X1=0,CT=0
 F  S X1=$O(^ACHSDENS(X,20,X1)) Q:X1'?1N.N  D
 .I $P(^ACHSDENS(X,20,X1,0),U,2)'="",$P(^(0),U,2)<DT Q
 .S CT=CT+1 W !?5,CT,". ",$P(^ACHSDENS(X,20,X1,0),U)
 .S ACHDENO(CT)=X1_U_$P(^ACHSDENS(X,20,X1,0),U)
 I CT=0 W !,"No active Denial Reasons Options" S Y=-1 Q
 W !
 S DIR(0)="NO^1:"_CT
 S DIR("A")="Enter "_$G(R)_"Denial Reason Option "
 D ^DIR
 I +Y>0 S Y=ACHDENO(Y)
 E  S Y=-1
 K ACHSDENO
 Q +Y
 ;
REASLST ; ---  Display the other Denials entered.
 ;ACHS*3.1*19 REWROTE SECTION TO DISPLAY RES AND OPT
 N X,Y,Y1
 W !!?5,"SELECTED Primary Denial Reason:  "
 I $D(^ACHSDEN(DUZ(2),"D",ACHSA,250)) D
 .S Y=$P(^ACHSDEN(DUZ(2),"D",ACHSA,250),U),Y1=$P(^ACHSDEN(DUZ(2),"D",ACHSA,250),U,2)
 .Q:'Y
 .Q:'$D(^ACHSDENS(Y))
 .W !?8,$P($G(^ACHSDENS(Y,0)),U)
 .W:Y1 !,?10,$P($G(^ACHSDENS(Y,20,Y1,0)),U)
 W !?5,"SELECTED Other Denial Reasons: "
 S X=0
 F  S X=$O(^ACHSDEN(DUZ(2),"D",ACHSA,300,X)) Q:X=""!(X'?1.N)  D
 .;W !?10,$P($G(^ACHSDENS($P($G(^ACHSDEN(DUZ(2),"D",ACHSA,300,X,0),"UNDEFINED"),U),0)),U)
 .S Y=$P(^ACHSDEN(DUZ(2),"D",ACHSA,300,X,0),U),Y1=$P(^ACHSDEN(DUZ(2),"D",ACHSA,300,X,0),U,2)
 .Q:'Y
 .Q:'$D(^ACHSDENS(Y))
 .W !?8,$P($G(^ACHSDENS($P(Y,U),0)),U)
 .W:Y1 !,?10,$P($G(^ACHSDENS(Y,20,Y1,0)),U)
 Q
 ;
REASCK() ; ---  Check if the Denial reason has already been entered.
 ;ACHS*3.1*19 MULT CHANGES FOR BECAUSE WILL BE TESTING FOR OPTIONS SELETED
 N X,X1,Y
 S (X,X1,Y)=0
 ;X1=TOTAL OPTIONS AVAILABLE;X=TOTAL REASON OR OPTIONS USED
 F  S X=$O(^ACHSDENS(ACHDOTR,20,X)) Q:X'?1N.N  D
 .I $P(^ACHSDENS(ACHDOTR,20,X,0),U,2)'="",$P(^(0),U,2)<DT Q
 .S X1=X1+1
 ;I X1=0 NO OPTION AVAILABLE JUST USING REASON
 I X1<2,ACHDOTR=$$DN^ACHS(250,1),ACHDOPTR="N" W !!,*7,*7,"DENIAL REASON/OPTIONS ALREADY SELECTED.",!! Q 1
 S X=0 I ACHDOTR=$$DN^ACHS(250,1) S X=X+1
 I $D(^ACHSDEN(DUZ(2),"D",300)) S L=0 F  S L=$O(^ACHSDEN(DUZ(2),"D",ACHSA,300,L)) Q:L'?1N.N  D
 .I $P(^ACHSDEN(DUZ(2),"D",ACHSA,300,L,0),U)=ACHDOTR S X=X+1
 I X<X1 Q Y
 W !!?5,"ALL DENIAL REASON/OPTIONS ALREADY SELECTED. Need to select another.",!!
 Q 1
OPTCK(T) ; CHECK FOR OPTIONS ALREADY SELECTED ;ACHS*3.1*19 NEW SECTION
 S (X,X1)=0
 I T="O",$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,250)),U)=ACHDOTR,$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,250)),U,2)=+Y W !!,*7,*7,"DENIAL REASON OPTION ALREADY SELECTED.",!! S X1=1 H 1 Q X1
 F  S X=$O(^ACHSDEN(DUZ(2),"D",ACHSA,300,X)) Q:+X=0  D  Q:X1
 .I ACHDOPTR="E",X=ACHDORNM Q   ;ACHS*3.1*19
 .Q:$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,300,X,0)),U)'=ACHDOTR
 .I $P($G(^ACHSDEN(DUZ(2),"D",ACHSA,300,X,0)),U,2)=+Y W !!,*7,*7,"DENIAL REASON OPTION ALREADY SELECTED.",!! S X1=1 H 1
 Q X1
 ;
DUMP ;EP - From Option.
 ;S DIC="^ACHSDEN("_DUZ(2)_",""D"","  ; ACHS*3.1*3
 ;S DIC(0)="QAZEMI"  ; ACHS*3.1*3
 ;S DIC("A")="Enter the DENIAL NUMBER or PATIENT NAME : "  ; ACHS*3.1*3
 ;D ^DIC  ; ACHS*3.1*3
 ;G K:+Y<1  ; ACHS*3.1*3
 ;S ACHD("DA")=+Y  ; ACHS*3.1*3
 ;K DIC  ; ACHS*3.1*3
 ;
 S ACHDOCT="denial"  ; ACHS*3.1*3
 D ^ACHSDLK  ; ACHS*3.1*3
 I $D(ACHDLKER) D K Q  ; ACHS*3.1*3
 S ACHD("DA")=ACHSA  ; ACHS*3.1*3
 ;
DEV ; --- Select print device
 S %ZIS="OPQ"
 D ^%ZIS
 I POP D HOME^%ZIS G K
 G:'$D(IO("Q")) START
 K IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 ;
 ;ACHS*3.1*4  pmf  close the device before passing off to taskman
 S ZTIO=ION  ;  ACHS*3.1*4
 D ^%ZISC,HOME^%ZIS  ;  ACHS*3.1*4
 ;
 S ZTRTN="START^ACHSDN2",ZTDESC="DUMP OF DATA FROM DENIAL DOCUMENT "_$P($G(^ACHSDEN(DUZ(2),"D",ACHD("DA"),0)),U)_"."
 F %="AC*","ACHD*" S ZTSAVE(%)=""
 D ^%ZTLOAD
 G DEV:'$D(ZTSK)
 K ZTSK
 G K
 ;
START ;EP - TaskMan.
 S:$D(IO("S")) IOSL=66
 U IO
 S DIC="^ACHSDEN("_DUZ(2)_",""D"",",DA=ACHD("DA")
 D EN^DIQ
 I IO'=ACHDIO W @IOF
K ;
 K ACHD("DA")
 D ^%ZISC,ERPT^ACHS:$D(ZTSK)
 Q
 ;
DOCNTL ;EP - From Option.
 N ACHSA,DA,DIC,DIE
 S DIC="^ACHSDEN("_DUZ(2)_",""D"","
 S DA(1)=DUZ(2)
 S DIC(0)="AQEM"
 D ^DIC
 Q:Y<1
 S ACHSA=+Y
 I $$DIE^ACHSDN("850////Y;851:853",2)
 Q
 ;
APPEAL ;EP - From Option.
 W !!
 S DIC="^ACHSDEN("_DUZ(2)_",""D"","
 S DA(1)=DUZ(2)
 S DIC(0)="AQEM"
 D ^DIC
 Q:Y<1
 S DIC=DIC_+Y_",800,"
 D ^DIC
 ;IHS/ITSC/PMF  1/12/01  add message before quitting   Q:Y<1
 I Y<1 W !!,?5,"No alternate resource info found.",! D RTRN^ACHS Q
 S DIE=DIC,DA=+Y,DR="3;4;8;9;10;",DR(1,9002071)="1;",DR(1,9002071.01)="800;",DR(1,9002071.08)="3;4;8;9;10;",DR(1,9002071.84)=".01"
 D ^DIE
 Q
DEL ; DELETE REASON IF NO ^ OUT OF OPTION
 ;
 S DIE="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",300,"
 S DA(2)=DUZ(2)
 S DA(1)=ACHSA
 S DA=ACHDORNM
 S DR=".01///"_"@"
 D ^DIE
 Q
