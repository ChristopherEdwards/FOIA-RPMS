AUPNLK2 ; IHS/CMI/LAB - IHS PATIENT LOOKUP ADD NEW PATIENT ; [ 11/02/2006  9:48 AM ]
 ;;99.1;IHS DICTIONARIES (PATIENT);**14,15,17**;MAR 09, 1999
 ;'Modified' MAS Patient Look-up Add New Patient, June 1987
 ;
 ; Upon exiting this routine AUPDFN will be set as follows:
 ;
 ;          AUPDFN >0 means patient added and AUPDFN is the DFN
 ;          AUPDFN <0 means patient not added
 ;
 ; AUPQF2 values have the following meaning:
 ;
 ;       0 = Initial state
 ;       1 = Primary error
 ;       2 = Name edit error
 ;       3 = Operator said no
 ;       4 = Identifier failure
 ;       5 = No add from dupe checker
 ;       6 = Add failed
 ;
START ;
 D INIT ;                      Initialization
 I AUPQF2 D EOJ Q
 D EDIT ;                      Edit the name
 I AUPQF2 D EOJ Q
 K AUPLID
 I DIC(0)["E" D TALK ;         Ask if add, get identifiers, check dupes
 I AUPQF2 D EOJ Q
 D ADDPAT ;                    Add patient
 I AUPQF2 D EOJ Q
 D EOJ
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
EDIT ; EXTERNAL ENTRY POINT - EDIT NAME
 S X=AUPX
 X $P(^DD(2,.01,0),U,5,99)
 I '$D(X) S AUPQF2=2 W:DIC(0)["Q" *7," ??" Q
 ;IHS/ITSC/WAR 6/25/2004 Set AUPX = X if changed 
 I X'=AUPX S AUPX=X
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
TALK ; EXTERNAL ENTERY POINT - TALK TO OPERATOR
 D ^AUPNLK2B
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
ADDPAT ; ADD PATIENT
 I $D(AUPLID),DIC(0)["E" W !!?3,"Please enter the following additional information:",!?3
 K DD,DO S X=AUPX S:$D(AUP("DR")) DIC("DR")=AUP("DR") D FILE^DICN S DIC("W")=AUPDICW K:$D(AUP("DR")) DIC("DR") S AUPDFN=Y
 I +AUPDFN>0 L +^DPT(+AUPDFN):10 D IHSPAT L
 Q
 ;
IHSPAT ; ADD PATIENT TO 9000001
 K DD,DO
 F AUPV="DINUM","DIC","DIC(""DR"")","DIC(0)","DLAYGO" S:$D(@AUPV) AUPRCR(AUPV)=@AUPV
 S X=+AUPDFN,DINUM=X,DIC="^AUPNPAT(",DIC(0)="L",DLAYGO=9000001,DIC("DR")=".02////"_DT_";.11////"_DUZ D FILE^DICN L +^DPT(+AUPDFN):10 S DIC("W")=AUPDICW I Y<0 D IHSPATE
 K DINUM,DIC("DR"),DIC(0),DLAYGO S AUPV="" F AUPL=0:0 S AUPV=$O(AUPRCR(AUPV)) Q:AUPV=""  S @AUPV=AUPRCR(AUPV)
 K AUPRCR,AUPV
 Q
 ;
IHSPATE ; ERROR ADDING TO 9000001
 W:AUPRCR("DIC(0)")["Q" !!?3,"Adding patient to ^AUPNPAT failed.  Patient being removed from ^DPT also.",!
 S DA=+AUPDFN,DIK="^DPT(" D ^DIK K DA,DIK
 S AUPQF2=6
 Q
 ;
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
INIT ; EXTERNAL ENTERY POINT - INITIALIZATION
 S AUPQF2=0
 I '$D(DUZ(0)) W:DIC(0)["Q" !?3,*7,"Unable to Add Patient. Your Fileman Access Code is undefined." S AUPQF2=1 Q
 D ACCESS K I,X
 Q:AUPQF2
 S:'($D(DUZ)#2) DUZ=0 S:DUZ="" DUZ=0
 ;AUPN*99.1*15, line below used to reference ^DIC(3
 I '$D(^VA(200,DUZ)) W:DIC(0)["Q" !?3,*7,"Unable to Add Patient.  DUZ is not a valid user." S AUPQF2=1 Q
 Q
 ;
ACCESS ; CHECK FILEMAN ACCESS
 S X=$S(AUPDIC="^DPT(":2,1:9000001)
 I $S($D(DLAYGO):X-DLAYGO,1:1),DUZ(0)'["@",$D(^DIC(X,0,"LAYGO")) S X=^("LAYGO") X "F I=1:1 I DUZ(0)[$E(X,I) Q" I I>$L(DUZ(0)) W:DIC(0)["Q" !?3,*7,"Unable to Add Patient.  You do not have Add authority." S AUPQF2=1 Q
 Q
 ;
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
EOJ ; EXTERNAL ENTRY POINT
 S:AUPQF2 AUPDFN=-1
 K AUPGID,AUPID,AUPID0,AUPIDS,AUPLID,AUP("DR"),AUPQF2,AUPRCR,AUPSET,AUPV
 Q
