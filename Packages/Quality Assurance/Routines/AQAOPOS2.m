AQAOPOS2 ; IHS/ORDC/LJF - POST INIT CONTINUED ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is a continuation of the QAI postinits.  This rtn installs your
 ;primary facility into the QI Parameter file and sets up at least one
 ;user as the package administrator.
 ;
MAIN D 3,4,5,6,7 Q  ;do steps 3, 4, 5, 6, 7 and return to AQAOPOST
 ;
3 ; step 3 - create primary facility entry in parameter file
 W !!,"STEP 3 - SET UP YOUR FACILITY IN PARAMETER FILE",!!
 I $D(DUZ(2)),DUZ(2)>0,$D(^AQAGP(DUZ(2))) D  Q
 .W !,$P(^DIC(4,DUZ(2),0),U)
 .W " is ALREADY set up in the QI Parameter file!!"
 ; ask user for facility name
 W !! K DIC S DIC="^AUTTLOC(",DIC(0)="AEMZQ"
 S DIC("B")=$S('$D(DUZ(2)):"",DUZ(2)<1:"",1:$P($G(^DIC(4,DUZ(2),0)),U))
 S DIC("A")="Select QI FACILITY NAME:  " D ^DIC
 Q:$D(DTOUT)  Q:$D(DUOUT)  Q:X=""  G 3:Y=-1 S AQAOFAC=+Y
31 I $D(^AQAGP(AQAOFAC)) D  Q
 .W !!,"This facility is ALREADY set up in the QI Parameter file!!"
 ;
SURE ; ask user if he is sure he wants to add this facility
 W !! K DIR,DIC S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Okay to ADD this facility to the QI PARAMETER file"
 S DIR("?",1)="Answer YES to create an entry in the QI Parameter file"
 S DIR("?",2)="for the facility you selected.  Answer NO to select "
 S DIR("?")="another facility."
 D ^DIR Q:$D(DIRUT)  G 3:Y=0
 ;
ADD ; set variables and call file^dicn
 W !! K DD,DO,DIC,DIR S DLAYGO=9002166,DIC="^AQAGP(",DIC(0)="L"
 S (DINUM,X)=AQAOFAC,DIC("DR")="[AQAO PARAM ADD]"
 L +(^AQAGP(0)):1 I '$T D  Q
 .W !!,"CANNOT ADD; ANOTHER USER ADDING TO THIS FILE. TRY AGAIN.",!
 D FILE^DICN L -(^AQAGP(0))
 W !!,"CREATING ENTRY . . ."
 I Y=-1 W !!,"**ERROR**  COULD NOT CREATE ENTRY IN FILE!" G 4
 W !!,"ENTRY CREATED!"
 W !!,"To ACTIVATE any of the automatic linkages, please use the option"
 W !,"titled EDIT PARAMETER FILE and select the same facility."
 W !!
 Q
 ;
 ;
4 ; step 4 - set up pkg administrator
 W !!,"STEP 4 - DEFINE QAI PACKAGE ADMINISTRATOR",!!
 W !,"Due to the extra security measures implemented in this package,"
 W !,"no one can access the main QAI menu without having the proper"
 W !,"entry in the QI USER file.  This step will create an entry for"
 W !,"the QI staff person who will be responsible for all the"
 W !,"administrative duties involved in running this package.  This"
 W !,"should be a QI staff member, NOT the site manager.  This person"
 W !,"can add more package administrators, if necessary.",!!
 ;
 I $O(^AQAO(9,"AC","QA",0)) D
 .W !!,"You already have a PKG ADMINISTRATOR defined."
 .S X=0 F  S X=$O(^AQAO(9,"AC","QA",X)) Q:X=""  D
 ..W !,"Name:  ",$P(^VA(200,X,0),U)
 .W !!,"To bypass this step, simple enter a ""^"" at the prompt.",!!
 ;
 K DIC S DIC=200,DIC(0)="AEMQZ"
 S DIC("S")="I $P(^VA(200,Y,0),U,3)]"""",$P(^(0),U,11)="""""
 S DIC("A")="Select PERSON to be PKG ADMINISTRATOR:  " D ^DIC
 Q:$D(DTOUT)  Q:$D(DUOUT)  G 4:Y=-1 S AQAOX=+Y
 ;
 I $D(^AQAO(9,"AC","QA",AQAOX)) D  Q
 .W !!,"This person is already set up as a package administrator."
 .W !,"Bypassing . . ."
 ;
 I $D(^AQAO(9,"B",AQAOX)) D  Q
 .W !!,"This person is already in the QI User file but NOT as a"
 .W !,"package administrator."
 .K DIR S DIR(0)="Y",DIR("B")="NO"
 .S DIR("A")="Do you want to make this user a pkg administrator"
 .D ^DIR I Y=1 D
 ..S DIE="^AQAO(9,",DA=AQAOX,DR=".06////QA" D ^DIE
 ;
 W !! K DIR S DIR(0)="Y"
 S DIR("A")="Ready to add this person as PKG ADMINISTRATOR"
 D ^DIR I Y'=1 G 4
 K DIC,DD,DO S DIC="^AQAO(9,",DIC(0)="L",(DINUM,X)=AQAOX
 S DIC("DR")=".02////"_DT_";.03////"_$G(DUZ)_";.06////QA" D FILE^DICN
 I Y=-1 W !!,"**ERROR**  Could not create entry!"
 W !!,"Make sure the Package Administrator is given ALL security"
 W !,"keys in the AQAO namespace BUT only if QAI training has been"
 W !,"given by the developer OR area trainer",!!
 Q
 ;
 ;
5 ; step 5 - add AQAOVST to PCC Visit Merge Utility
 W !!,"STEP 5 - UPDATE PCC VISIT MERGE UTILITY",!!
 W !,"I will now add an entry for QAI into the MODULE PCC LINK CONTROL"
 W !,"file.  This insures visit merges will be reflected in those"
 W !,"occurrences pointing to the affected visits.",!!
 Q:$D(^APCDLINK("B","QAI MGT SYSTEM"))  ;already exists
 K DD,DO S DIC="^APCDLINK(",DIC(0)="LE",DLAYGO=9001002
 S DIC("DR")="1////S AQAOSAV=$G(X),X=""AQAOVST"" X ^%ZOSF(""TEST"") S X=AQAOSAV K AQAOSAV I $T D MRG^AQAOVST"
 S X="QAI MGT SYSTEM" D FILE^DICN
 Q
 ;
 ;
6 ;step 6 - kill old xrefs no longer used
 W !!,"STEP 6 - KILL OLD CROSS-REFERENCES NO LONGER USED",!!
 W !,"I will now kill any cross-references used during alpha testing"
 W !,"that are no longer needed by the software",!!
 W !,"Kill ^AQAOCC(7,""AC"")" K ^AQAOCC(7,"AC")
 W !,"Kill ^AQAOC(""AFF"")" K ^AQAOC("AFF")
 Q
 ;
7 ; -- convert provider data to variable pointer
 W !!,"CONVERTING provider data to new structure. . ."
 NEW X,Y,DIK K ^AQAOCC(7,"B")
 S X=0 F  S X=$O(^AQAOCC(7,X)) Q:X'=+X  D
 . S Y=$P(^AQAOCC(7,X,0),U) Q:Y'=+Y  ;already converted
 . S $P(^AQAOCC(7,X,0),U)=Y_";VA(200,"
 S DIK="^AQAOCC(7,",DIK(1)=".01^B" D ENALL^DIK
 Q
