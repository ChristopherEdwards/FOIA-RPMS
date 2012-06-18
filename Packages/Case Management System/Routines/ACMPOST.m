ACMPOST ;cmi/anch/maw - CONTROLLER FOR CMS ;  [ 02/10/2009  9:51 AM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**6,7,8**;JAN 10, 1996
 ;;NO POST INIT ACTION FOR THIS VERSION (1.61)
 ;Q
 ;
ENV ;EP;IHS/CMI/TMJ PATCH 8 
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPM1","XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $$INSTALLD("ACM*2.00*7") Q
 I $$INSTALLD("ACM*2.0*7") Q
 D SORRY(2)
 Q
 ;
EN D ^ACMTMPI
 W !!,"All CMS SORT File Associated Print Templates Repointed",!
 D EN1
 W !!,"All Re-Index of All Cross Reference Completed",!
 D CONVRES
 W !!,"Restrict Field Conversion Complete",!!
 D CONV200
 W !,"File 200 Conversion Complete",!
 D CONVRCL
 W !!,"Recall Letter Conversion Complete",!!
 ;
 D EXIT
 ;
 D PRTUSER
 Q
 ;
CONVRES ;
 ;Convert Restricted field to HEALTH SUMMARY field , flip flop data
 ;CHANGE 0 TO 1 AND 1 TO 0
 S X=0 F  S X=$O(^ACM(41.1,X)) Q:X'=+X  D
 .I $P(^ACM(41.1,X,0),U,7)=1 S $P(^ACM(41.1,X,0),U,7)=0 Q
 .I '$P(^ACM(41.1,X,0),U,7) S $P(^ACM(41.1,X,0),U,7)=1
 .Q
 Q
EN1 W !,"THE 'NAME OF REGISTER' CROSS REFERENCE WILL NOW BE SET.",!,"THIS MAY TAKE SEVERAL MINUTES.  DO NOT INTERRUPT."
 F ACM=41:1:49,51,53,54,57 S DIK="^ACM("_ACM_",",DIK(1)=$S(ACM'=41:".04^1",1:".01^2") D ENALL^DIK
 K DIK,DR,DA
 Q
 ;
 ;
CONV200 ;Convert File 200 Entry Point
 I '$D(^ACM(40,DUZ(2))) D V200FACD,V200FAC I '$D(^ACM(40,DUZ(2))) W !!,"Unable to create Facility Entry in CMS Parameters File",! Q
 I $P(^ACM(40,DUZ(2),0),U,2) W !,"CONVERSION DONE PREVIOUSLY",! Q
 W !!!,*7
 W "It appears you have not upgraded the Case Management System to recognize",!
 W "File 200 - the",!,"***NEW PERSON FILE ***",!!
 W "Let's do the upgrade now!",!
 D V200CONV,V200DIE
 ;
 Q
 ;
 ;
 ;
V200FACD ;Delete Existing Non-DINUM entries CMS Parameters
 ;
 ;K ^UTILITY("XBDSET",$J)
 ;S ^UTILITY("XBDSET",$J,"9002240")="" D EN2^XBFRESET
 ;W !!,"The Non-DINUM entries have been deleted from the CMS Paramaters File",!!
 Q
 ;
V200FAC ;Adds Facility to CMS PARAMETERS File if non-existent
 S X="`"_DUZ(2),DLAYGO=9002240,DIADD=1,DIC(0)="L",DIC="^ACM(40," D ^DIC
 I Y=-1 W !!,"Error has ocurred..Cannot Add a Facility to the CMS Parameters File - Call Developer On This Error!!!"
 Q
V200DIE ;SET FLAG IN CMS PARAMETERS FILE TO INDICATE FILE 200 CONVERSION
 W !!,"I will now set CMS Parameters Flag to Indicate File 200 Conversion has been completed",!!
 S DIE="^ACM(40,",DA=DUZ(2),DR="3///1" D ^DIE K DIE,DR,DA,DIC
 Q
 ;
V200CONV ;File 200 Conversion
 W "I will now begin the Conversion Process",!
 S ACMDFN=0 F  S ACMDFN=$O(^ACM(41,ACMDFN)) Q:ACMDFN'=+ACMDFN  I $D(^ACM(41,ACMDFN,"DT")) D
 .D CASEMGR
 .D PHN
 .D PROV
 .Q
 Q
CASEMGR ;CASE MANAGER FIX
 ;Convert 6th piece - Case Manager
 S ACMOLDN=$P(^ACM(41,ACMDFN,"DT"),U,6)
 Q:'ACMOLDN
 S ACMNEWN=$G(^DIC(16,ACMOLDN,"A3"))
 I 'ACMNEWN W !!,"ERROR - ERROR in Case Manager Record "_ACMDFN,! Q
 S DA=ACMDFN,DIE="^ACM(41,",DR="6////"_ACMNEWN D ^DIE K DIE
 Q
PHN ;PHN FIX
 ;Convert 7th piece - PHN
 S ACMOLDN=$P(^ACM(41,ACMDFN,"DT"),U,7)
 Q:'ACMOLDN
 S ACMNEWN=$G(^DIC(16,ACMOLDN,"A3"))
 I 'ACMNEWN W !!,"ERROR - ERROR in PHN Record "_ACMDFN,! Q
 S DA=ACMDFN,DIE="^ACM(41,",DR="7////"_ACMNEWN D ^DIE K DIE
 Q
PROV ;PRIMARY PROVIDER FIX
 ;Convert 15th piece - PRIMARY PROVIDER
 S ACMOLDN=$P(^ACM(41,ACMDFN,"DT"),U,15)
 Q:'ACMOLDN
 S ACMNEWN=$G(^DIC(16,ACMOLDN,"A3"))
 I 'ACMNEWN W !!,"ERROR - ERROR in Provider Record "_ACMDFN,! Q
 S DA=ACMDFN,DIE="^ACM(41,",DR="15////"_ACMNEWN D ^DIE K DIE
 Q
 ;
 ;
 ;
CONVRCL ;Convert Call Letters
 D ^ACMPOST1
 Q
 ;
DELCMSL ;-- this subroutine will delete entries in the CMS LISTER ITEMS file before installing new ones
 N ACMDA
 S ACMDA=0 F  S ACMDA=$O(^ACM(58.1,ACMDA)) Q:'ACMDA  D
 . S DIK="^ACM(58.1,",DA=ACMDA
 . D ^DIK
 Q
 ;
PRTUSER ;Print Register Developer and Users
 ;
 W !!!,?5,"**********************************************************************",!
 W !,?10,"YOU MAY NOW PRINT THE EXISTING REGISTER DEVELOPER",! W ?10,"AND ASSOCIATED AUTHORIZED USERS...",!
 W !!,?5,"Improved Register Security has been addressed by adding a new field",!
 W ?5,"to the CMS Register Type file name REGISTER CREATOR.  ONLY the CREATOR",!
 W ?5,"of the Register may modify the existing Register Structure, or",!
 W ?5,"assign Authorized Users to that Register, or Delete that Register.",!
 W ?5,"Utilizing FileMan, one CREATOR for each existing Register must be entered.",!
 W ?5,"Once you have printed the following list of existing Register Developers",!
 W ?5,"and Authorized Users, refer to the Install Notes on how to add the",!
 W ?5,"REGISTER CREATOR to the CMS Register Type file.",!!
 W ?5,"**********************************************************************",!!
 S DIC="^ACM(41.1,",FLDS="[ACM REGISTER DEVELOPER]",BY="@REGISTER TYPE",FR="A",TO="ZZ" D DIP
 ;
 Q
DIP ;
 D EN1^DIP Q
EXIT ;
 W !!!,?10,"ALL POST INIT CONVERSIONS HAVE BEEN SUCCESSFULLY COMPLETED!!",!
 W ?32,"INSTALL NOW DONE!!",!
 K ACMDFN,ACMOLDN,ACMNEWN
 Q
44 ;EP;TO ADD THE 'AC' CROSS REFERENCE AND REINDEX ALL CMS PATIENT FILES
 ;IHS/CIM/THL PATCH 2
 W:'$D(ZTQUEUED) !!,"This could take several minutes.  Please stand by.",!!
 N XX1,XX2,X
 F XX1=42:1:49,51:1:54,57 D
 .S XX2=9002200+XX1
 .Q:'$D(^DD(XX2,.01,1))
 .F X="AC","B","C","D","E","F" K ^ACM(XX1,X)
 .S DIK="^ACM("_XX1_","
 .D IXALL^DIK
 .W:'$D(ZTQUEUED) !,XX1 ;"."
 Q
 ;
POST6 ;EP;FOR PATCH 6
 F ACMX="ACM INSTALL PRE DM" D
 .S ACMY="PDM"
 .S X=$$ADD^XPDMENU("ACMMENU",ACMX,ACMY)
 ;
 D ^ACMBUL6
 Q
 ;
PRE6 ;EP;FOR PATCH 6 PRE-INIT
 ;Kill of Lister Items
 F DA=1:1:900 S DIK="^ACM(58.1," D ^DIK
 ;now delete dd fields that have trigger with $N
 S DIK="^DD(9002241,",DA=.01,DA(1)=9002241 D ^DIK
 S DIK="^DD(9002242,",DA=.04,DA(1)=9002242 D ^DIK
 S DIK="^DD(9002243,",DA=.04,DA(1)=9002243 D ^DIK
 S DIK="^DD(9002244,",DA=.04,DA(1)=9002244 D ^DIK
 S DIK="^DD(9002245,",DA=.04,DA(1)=9002245 D ^DIK
 S DIK="^DD(9002246,",DA=.04,DA(1)=9002246 D ^DIK
 S DIK="^DD(9002247,",DA=.04,DA(1)=9002247 D ^DIK
 S DIK="^DD(9002248,",DA=.04,DA(1)=9002248 D ^DIK
 S DIK="^DD(9002249,",DA=.04,DA(1)=9002249 D ^DIK
 S DIK="^DD(9002251,",DA=.04,DA(1)=9002251 D ^DIK
 S DIK="^DD(9002253,",DA=.04,DA(1)=9002253 D ^DIK
 S DIK="^DD(9002254,",DA=.04,DA(1)=9002254 D ^DIK
 S DIK="^DD(9002257,",DA=.04,DA(1)=9002257 D ^DIK
 S DIK="^DD(9002258.8,",DA=.07,DA(1)=9002258.8 D ^DIK
 Q
 ;
P7 ;-- patch 7 post init
 D OPT7
 D ^ACMBUL7
 Q
 ;
OPT7 ;-- add patch 7 options
 N ACMX,ACMY
 F ACMX="ACM E DISP/EDIT REG CREATOR" D
 .S ACMY="ECR"
 .S X=$$ADD^XPDMENU("ACMMENU",ACMX,ACMY)
 F ACMX="APCLLT CUSTOM LETTER MGT" D
 .S ACMY="CLM"
 .S X=$$ADD^XPDMENU("ACMMENU",ACMX,ACMY)
 Q
 ;
P8 ;EP - post init patch 8
 D ADD^XPDMENU("ACMMENU","APCLLT CUSTOM LETTER MGT","CLM",50)
 D ADD^XPDMENU("ACMMENU","AMQQMENU","QMAN",30)
 Q
INSTALLD(ACMSTAL) ;EP - Determine if patch ACMSTAL was installed, where
 ; ACMSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 NEW ACMY,DIC,X,Y
 S X=$P(ACMSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(ACMSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(ACMSTAL,"*",3)
 D ^DIC
 S ACMY=Y
 D IMES
 Q $S(ACMY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_ACMSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
