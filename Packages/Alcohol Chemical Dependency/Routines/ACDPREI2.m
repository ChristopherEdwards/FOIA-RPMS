ACDPREI2 ;IHS/ADC/EDE/KML - PRE-INIT CONVERSIONS FOR V4.1;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
START ;
 W !!,"Beginning the pre-init routine ",$T(+0)
 I $D(^TMP("ACD",$J,"VIRGIN INSTALL")) W !!,"Virgin install so pre-init not necessary.",! K ^TMP("ACD",$J) Q
 I '$G(DUZ)!($G(DUZ(0))'["@") W !!,"Either DUZ is not set or you do not have programmer access.  I don't",!,"know how you got here but I cannot run this pre-int routine.",!! Q
 D F5PI
 D IIF
 D TDC
 D EOJ
 Q
 ;
F5PI ; DELETE ALL DATA FROM CDMIS PROGRAM FILE EXCEPT .01 VALUE
 W !!,"Now converting your CDMIS PROGRAM file."
 K ACDPRGM
 S ACDDA=0
 F  S ACDDA=$O(^ACDF5PI(ACDDA)) Q:'ACDDA  S ACDPRGM(ACDDA)="",DIK="^ACDF5PI(",DA=ACDDA D DIK^ACDFMC W "."
 S ACDDA=0
 F  S ACDDA=$O(ACDPRGM(ACDDA)) Q:'ACDDA  S DIC="^ACDF5PI(",DIC("DR")="",DIC(0)="L",DLAYGO=9002173,(DINUM,X)=ACDDA D FILE^ACDFMC
 K ACDDA,ACDPRGM
 Q
 ;
IIF ; DELETE 2ND PIECE OF INIT/INFO/FU FILE
 W !!,"Now converting your CDMIS INIT/INFO/FU file."
 I '$D(^DD(9002170,1,0)) W !,?5,"Already converted.  No action required." Q
 S ACDDA=0
 F  S ACDDA=$O(^ACDIIF(ACDDA)) Q:'ACDDA  I $D(^ACDIIF(ACDDA,0)) S DIE="^ACDIIF(",DA=ACDDA,DR="1///@" D DIE^ACDFMC W:'(ACDDA#100) "."
 Q
 ;
TDC ; DELETE 28TH PIECE OF TRANS/DISC/CLOSE FILE
 W !!,"Now converting your CDMIS TRANS/DISC/CLOSE file."
 I $P($G(^DD(9002171,101,0)),U,2)["F" W !,?5,"Already converted.  No action required." Q
 S ACDDA=0
 F  S ACDDA=$O(^ACDTDC(ACDDA)) Q:'ACDDA  I $D(^ACDTDC(ACDDA,0)) S DIE="^ACDTDC(",DA=ACDDA,DR="101///@" D DIE^ACDFMC W:'(ACDDA#100) "."
 Q
 ;
EOJ ;
 K ACDDA,ACDPRGM
 D PAUSE^ACDDEU
 Q
