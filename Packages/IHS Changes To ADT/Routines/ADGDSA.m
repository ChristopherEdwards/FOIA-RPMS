ADGDSA ; IHS/ADC/PDW/ENM - DAY SURGERY ENTER/EDIT ; [ 09/17/2002  3:55 PM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> get patient
NAME W !! K DFN S DIC=9009012,DLAYGO=9009012,DIC(0)="AQEML"
 S DIC("A")="Select Day Surgery Patient: "
 ;set DIC("S") to check for unregistered patients
 S DIC("S")="I $D(^AUPNPAT(+Y,41,DUZ(2),0)),$P(^(0),U,2)'="""""
 D ^DIC K DIC("A") G END:X="",END:X=U,NAME:Y<0
 ;
 S (DFN,DA)=+Y D EN^ADGPI  ;print patient inquiry info
 I $D(^DPT(DFN,.35)),$P(^(.35),U)]"" D  G NAME:Y=0
 . K DIR S DIR(0)="Y"
 . S DIR("A")="This patient has died.  Sure you want to continue"
 . S DIR("B")="NO" D ^DIR
 ;
 ;***> get day surgery date
DSDATE K DIC S:'$D(^ADGDS(DFN,"DS",0)) ^(0)="^9009012.01D^^"
 S DIC="^ADGDS("_DFN_",""DS"",",DLAYGO=9009012,DIC(0)="AEQMZL"
 S DA(1)=DFN,DA=0,DGA=$P(^ADGDS(DFN,"DS",0),U,3)
 G DSASK:DGA="",DSASK:'$O(^ADGDS(DFN,"DS",0))
 S DIC("B")=$S('$D(^ADGDS(DFN,"DS",DGA,2)):DGA,$P(^(2),U)="":DGA,1:"")
 ;
DSASK L +^ADGDS(DFN,"DS"):3 I '$T D  G NAME
 . W !,*7,"SOMEONE ELSE IS UPDATING THIS DAY SURGERY PATIENT; TRY AGAIN LATER"
 D ^DIC L -^ADGDS(DFN,"DS") W !! K DIC,DIC("A") G NAME:Y'>0 S DGDFN1=+Y
 I $D(^ADGDS(DFN,"DS",DGDFN1,2)),$P(^(2),U)'="" W !?5,*7,"Past day surgeries must be edited in the Edit Past Day Surgery option",! G DSDATE
 ;
 ;***> enter/edit using input template
 L +^ADGDS(DFN):3 I '$T D  G DSDATE
 . W !,*7,"SOMEONE IS UPDATING THIS ENTRY; TRY AGAIN LATER"
 S DIDEL=9009012,DR="[ADGDSADD]",DIE="^ADGDS(",DA=DFN
 S DIE("NO^")="" D ^DIE L -^ADGDS(DFN) K DIE("NO^")
 ;
 ;***> print day surgery worksheet
CRB K DIR S DIR("A")="Print Day Surgery Worksheet",DIR(0)="Y"
 S DIR("?")="Enter YES to print a worksheet for this patient"
 S DIR("B")="NO" D ^DIR
 I Y=1 S ADGDFN=DFN,ADGDFN1=DGDFN1 D DS1^ADGCRB0 S DFN=ADGDFN,DGDFN1=ADGDFN1  ;go to print
 ;
 ;***> go back & ask for another patient if no release date/time entered
 G NAME:'$D(^ADGDS(DFN,"DS",DGDFN1,2)),NAME:$P(^(2),U)=""
 ;
DSIC ;***> create incomplete chart entry
 W !!,"Creating entry in DS Incomplete Chart file....",! K DIC
INC I '$D(^ADGDSI(DFN,0))#2 S X="`"_DFN,DIC="^ADGDSI(",DLAYGO=9009012,DIC(0)="L" D ^DIC
 I '$D(^ADGDSI(DFN,0))#2 G VST
 S:'$D(^ADGDSI(DFN,"DT",0)) ^ADGDSI(DFN,"DT",0)="^9009012.51D^^"
 S X=+^ADGDS(DFN,"DS",DGDFN1,0),DGSRV=$P(^(0),U,5),DA(1)=DFN
 S DA=$P(^ADGDSI(DFN,"DT",0),U,3)+1
 S DIC="^ADGDSI("_DFN_",""DT"",",DLAYGO=9009012,DIC(0)="L"
 L +^ADGDSI(DFN):3 I '$T D  G VST
 . W !,*7,"CANNOT ADD TO DS INCOMPLETE CHART FILE; BEING UPDATED BY SOMEONE ELSE"
 D ^DIC L -^ADGDSI(DFN)
 S DIE=DIC,DA=$P(^ADGDSI(DFN,"DT",0),U,3),DR="5///^S X=""`""_DGSRV" D ^DIE K DIC,DIE
 ;
VST ;***> create visit in PCC for day surgery
 I '$D(^DG(43,1,9999999))!($P(^DG(43,1,9999999),U,2)'="Y") G END
 S APCDALVR("APCDDATE")=+^ADGDS(DFN,"DS",DGDFN1,0)  ;visit date
 ;check if visit already exists
 S DGX=APCDALVR("APCDDATE"),DGX1=9999999-$P(DGX,".")_"."_$P(DGX,".",2)
 G NAME:$D(^AUPNVSIT("AA",DFN,DGX1))
 ;
 S APCDALVR("APCDADD")=1 D APCDEIN^ADGCALLS  ;initialize PCC variables
 W !!,"Day Surgery visit being created..."
 S APCDALVR("APCDPAT")=DFN,APCDALVR("APCDLOC")=APCDDUZ2
 S APCDALVR("APCDTYPE")="I",APCDALVR("APCDCAT")="S"
 S APCDALVR("APCDCLN")="DAY SURGERY" D DSCV^ADGCALLS K AUPNSEX
 I $D(APCDALVR("APCDAFLG")) W !!,*7,"VISIT ERROR, Please notify your supervisor!" G END
V9 K APCDALVR G NAME
 ;
END D KILL^ADGUTIL K ADGDFN,ADGDFN1 Q
