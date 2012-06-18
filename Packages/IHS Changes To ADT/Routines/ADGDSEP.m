ADGDSEP ; IHS/ADC/PDW/ENM - EDIT PAST DAY SURGERIES ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> get patient
NAME W !! K DFN S DIC=9009012,DIC(0)="AQEM"
 S DIC("A")="Select Day Surgery Patient: "
 D ^DIC K DIC("A") G END:X="",END:X=U,NAME:Y<0
 ;
 S (DFN,DA)=+Y D EN^ADGPI  ;print patient inquiry info
 I $D(^DPT(DFN,.35)),^(.35)]"" K DIR S DIR(0)="Y",DIR("A")="This patient has died.  Are you sure you want to continue",DIR("B")="NO" D ^DIR I Y=0 G NAME
 ;
 ;***> get day surgery date
DSDATE K DIC S DIC="^ADGDS("_DFN_",""DS"",",DIC(0)="AEQMZ"
 S DA(1)=DFN,DA=0 D ^DIC W !! K DIC,DIC("A") G NAME:Y'>0 S DGDFN1=+Y
 I $D(^ADGDS(DFN,"DS",DGDFN1,2)),$P(^(2),U)'="" G DSEDIT
 W !?5,*7,"Edit active day surgeries in the DAY SURGERY ENTER/EDIT option",! G NAME
 ;
DSEDIT ;***> edit using input template
 S DIDEL=9009012,DR="[ADGDSADD]",DIE="^ADGDS(",DA=DFN
 L +^ADGDS(DFN):3 I '$T D  G NAME
 . W !,*7,"SOMEONE ELSE IS UPDATING THIS DAY SURGERY PATIENT; TRY AGAIN LATER"
 S DIE("NO^")="" D ^DIE L -^ADGDS(DFN) K DIE("NO^")
 ;
 ;***> print day surgery worksheet
CRB K DIR S DIR("A")="Print Clinical Record Brief",DIR(0)="Y"
 S DIR("?")="Enter YES to print a worksheet for this patient"
 S DIR("B")="NO" D ^DIR
 I Y=1 S DGDFNX=DFN D DS1^ADGCRB0  ;go to print
 G NAME
 ;
END D KILL^ADGUTIL Q
