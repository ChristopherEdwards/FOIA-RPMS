ATXAX ; IHS/OHPRD/TMJ -  TAXONOMY FOR ICD9 CODES INTO ICD DIAG FILE ; 23 Aug 2012  6:40 AM
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
 ;
 ; -- ADD A NEW TAXONOMY OR ADD CODES TO A TAXONOMY
DESC ;
 ;;This option should ONLY be used if you want to set up a bulletin
 ;;that will be sent to a Mail Group you define.  
 ;;A bulletin for a taxonomy is an email message sent to a specified
 ;;group of recipients when a patient's purpose of visit matches one
 ;;of the entries within the taxonomy. The selection of a taxonomy
 ;;within the 'Enter Bulletin for a Taxonomy' option will automatically
 ;;create a bulletin to be sent to the recipients within the designated mail group.
 ;;
 ;;$$END
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 ;GET TAXONOMY
 W !!,"Please select the ICD Diagnosis Taxonomy that you wish to have"
 W !,"a bulletin set up for.  You must first create the taxonomy using"
 W !,"the taxonomy set up option. Please Note:  You can only set up"
 W !,"a bulletin for a taxonomy that you created.",!
 S ATXFLG="",ATXSTP=0
 S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("DR")="",DIC("S")="I $P(^(0),U,5)=DUZ,$P(^(0),U,15)=80" D ^DIC K DIC,DLAYGO
 I Y=-1 W !,"Taxonomy not selected." D XIT Q
 S ATXX=+Y
 ;set created by taxonomy system
 S DIE="^ATXAX(",DR=".08///1",DA=ATXX D ^DIE
ZTM ;
 D DFNS
 ;now do what atxbull did
 D ENTER^ATXBULL2  ;create the bulletin
 D XIT
 Q
 ;
DFNS ;EP - GET LO AND HIGH DFNS FOR THIS TAXONOMY
 K ATXARR
 D BLDTAX^ATXAPI($P(^ATXAX(ATXX,0),U,1),"ATXARR",ATXX,"T")
 S ATX1="",ATXQ=0 F  S ATX1=$O(ATXARR(ATX1)) Q:ATX1=""  D
 .;set icd9 41 multiple
 .S DIE="^ICD9(",DR="9999999.41///"_"`"_ATXX,DA=ATX1 I DA]"",'$D(^ICD9(DA,9999999.41,"B",ATXX)) D ^DIE,^XBFMK
 Q
 ;
XIT ;
 D EN^XBVK("ATX")
 Q
