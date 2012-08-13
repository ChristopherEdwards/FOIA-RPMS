VENPCCM3 ; IHS/OIT/GIS - PRINT GROUP SYNCHRONIZATION - ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ;
PG(NAME) ; EP-VALIDATE AND SYNCHRONIZE INDIVIDUAL PRINT GROUPS
 I '$L($G(NAME)) Q
NEW N IP,IPA,SOCK,PSTG,FSTG,X,Y,Z,%,STOP,PG1,PG2,RPMS,DA,DR,DIC,DIE,MR
 N PSN,STOP,PS1,PS2,RPMS,I,X,Y,PCE,PIEN,OK,BAD,WARN,STG
VAR I '$$VAR^VENPCCM1 Q
RPMS ; RPMS PRINT GROUPS
 S PIEN=0,RPMS=""
 F  S PIEN=$O(^VEN(7.4,PIEN)) Q:'PIEN  S X=$P($G(^VEN(7.4,PIEN,0)),U) D  I RPMS'="" S RPMS=RPMS_U
 . S RPMS=RPMS_U
 . S RPMS=RPMS_X
 . Q
 S MR=$$MR ; LOCATE MEDICAL RECORDS PRINT GROUP
PG1 S PG1=$$PGRP^VENPCCM2(IP)
 I PG1="" W !,"There are no Print Groups entered on Print Server #1",!,"You must enter Print Groups on both print servers" Q
PG2 I IP'=IPA S STOP=0 D  I STOP Q
 . S PG2=$$PGRP^VENPCCM2(IPA)
 . I PG1="" W !,"There are no Print Groups entered on Print Server #2",!,"You must enter Print Groups on both print servers" S STOP=1 Q
 . I PG2'=PG1 W !,"Print Groups entered on Print Server #2 don't match those on Print Server #1",!,"You must enter identical sets of Print Groups on both Print Servers" S STOP=1 Q
 . Q
 S PG1=U_PG1_U
OK I PG1[(U_NAME_"|"),RPMS[(U_NAME_U) W !,"'",NAME,"' has been successfully entered on the RPMS Server and Print Server",$S(IP'=IPA:"s",1:"") Q
MISS I PG1'[(U_NAME_"|"),RPMS'[(U_NAME_U) W !,"'",NAME,"' has not been entered on the Print Server yet",!,"You must enter this Print Group before going on" Q
BAD I RPMS[(U_NAME_U) D  Q
 . S DA=$O(^VEN(7.4,"B",NAME,0)) I 'DA W !,"Unable to delete ",NAME
 . S DIK="^VEN(7.4," D ^DIK
 . W !,NAME," has been deleted from the RPMS Server!!"
 . Q
ADD W !,"'",NAME,"' has not been regestered on the RPMS server yet!"
 W !,"Do you want to do this now"
 S %=1 D YN^DICN I %'=1 Q
 S DLAYGO=19707.4,X=NAME,DIC="^VEN(7.4,",DIC(0)="L" D ^DIC S DA=+Y
 I Y=-1 Q
 W !,NAME," entered on the RPMS Server!!"
 I MR Q
 I DA W !,"Is this Print Group located in the Medical Records Department" S %=2 D YN^DICN I %'=1 Q
ADDMR ; DEFINE THE MED REC PRINT GRP
 S DIE="^VEN(7.4,",DR=".02////1" L +^VEN(7.4):0 I $T D ^DIE L -^VEN(7.4) W !,NAME," has been designated as the Medical Records Print Group"
 Q
 ; 
ONE ; EP-CHECK ONE PRINT GROUP
 S DIR(0)="FO^1:30",DIR("A")="Enter the name of the Print Group" KILL DA D ^DIR KILL DIR
 I '$L(Y) Q
 W !,"One moment please..."
 D PG(Y)
 D ^XBFMK
 Q
 ; 
ALL ; EP-CHECK ALL PRINT GROUPS ON PRINT SERVER #1
 N IP,STG,PGN,NAME
 I $D(IP1) S IP=IP1
 E  S IP=$P($G(^VEN(7.5,$$CFG^VENPCCU,11)),U) I '$L(IP) W !,"Unable to find an IP address for Print Server #1" Q
 W !,"Checking all templates on Print Server #1......."
 W !,"One moment please..."
 S STG=$$PGRP^VENPCCM2(IP) I $L(STG)'>1 W "Unable to locate any Print Groups on Print Server #1" Q
 F PGN=1:1:$L(STG,U) S NAME=$P(STG,U,PGN) S NAME=$P(NAME,"|") W !,"Checking ",NAME D PG(NAME)
 D ^XBFMK
 Q
 ; 
MR() ; MED REC PRINT GROUP
 N MR,X,%
 S (MR,X)=0 F  S X=$O(^VEN(7.4,X)) Q:'X  S %=^(X,0) I $P(%,U,2) S MR=X Q
 Q MR
 ; 
 ; --------------------------------------------
 ; 
QCK ; EP-CHECK QUEUE TYPE FILE
 W !!,"Checking the QUEUE TYPE file..."
 N Q,N,DUP,D,DNO,DIK,DIC,X,Y,C,MISS,NAME,QIEN,CIEN
 S (DIK,DIC)="^VEN(7.22,"
DUP S Q="",DUP="" ; DUP QUEUE TYPES
 F  S Q=$O(^VEN(7.22,"B",Q)) Q:Q=""  S N=$O(^VEN(7.22,"B",Q,0)) S D=$O(^(N)) I D S:$L(DUP) DUP=DUP_U S DUP=DUP_D
 I '$L(DUP) G MIS
 W !,"The file VEN EHP QUE TYPE has duplicate records that may cause problems",!,"Want to delete the duplicates"
 S %=1 D YN^DICN I %'=1 G MIS
 F DNO=1:1:$L(DUP) S DA=$P(DUP,U,DNO) D ^DIK
 W !,"Duplicates removed!!" K DUP
MIS ; MISSING QUEUE TYPES
 S C="",MISS=""
 F  S C=$O(^VEN(7.95,"B",C)) Q:C=""  I '$D(^VEN(7.22,"B",C)) S:$L(MISS) MISS=MISS_U S MISS=MISS_C
 I '$L(MISS) G FIN
 W !,"The following clinics are not found in the QUEUE TYPE file =>"
 F %=1:1:$L(MISS,U) W !?5,$P(MISS,U,%)
 S %=1 W !!,"Want to add these to the QUEUE TYPE file"
 D YN^DICN I %'=1 G FIN
 S DIC(0)="L",DLAYGO=19707.22,DIC="^VEN(7.22,"
 F CNO=1:1:$L(MISS,U) S X=$P(MISS,U,CNO) I $L(X) D ^DIC I $P(Y,U,3) W !?5,$P(Y,U,2)," added to the QUEUE TYPE file"
 K MISS
FIN S NAME="" F  S NAME=$O(^VEN(7.22,"B",NAME)) Q:NAME=""  S QIEN=$O(^VEN(7.22,"B",NAME,0)),CIEN=$O(^VEN(7.95,"B",NAME,0)) I QIEN,CIEN S $P(^VEN(7.95,CIEN,1),U)=QIEN
 I '$L($G(DUP)),'$L($G(MISS)) W !,"The QUEUE TYPE file has been validated!!" H 2
 D ^XBFMK
 Q
 ; 
 ; ---------------------------------------------------
 ; 
CADD ; EP-ADD A NEW CLINIC
 N X,Y,%,DIEN,DIC,DIE,DR,DA,DLAYGO,POP,NAME
 W !!?20,"*****  ADD / EDIT A PCC+ CLINIC  *****"
 W !!,"To add a new clinic, answer the following questions"
 W !,"At any time, you may enter '??' to see the choices",!!
 W !,"Enter the name of the new clinic.  It should be in the format:",!!?3,"{SITE} - {CLINIC}  e.g., ANMC - PEDIATRICS or CROW - DENTAL",!
C1 S DIC="^VEN(7.95,",DIC(0)="AEQL",DIC("A")="Clinic name: ",DLAYGO=19707.95
 D ^DIC I Y=-1 G CFIN
 S DIE=DIC,(DA,DIEN)=+Y,NAME=$P(Y,U,2)
 W !!,"Enter the name of the DEPARTMENT (CLINIC STOP) associated with this clinic"
 S DR="2.04////^S X=DUZ(2);.04" L +^VEN(7.95):0 I $T D ^DIE L -^VEN(7.95)
 W !!,"Enter the name of this clinic's DEFAULT ENCOUNTER FORM used during check-in"
 S DR="2.05" L +^VEN(7.95):0 I $T D ^DIE L -^VEN(7.95)
 W !!,"Enter the name of this clinic's DEFAULT HEALTH SUMMARY used during check-in"
 S DR="2.06" L +^VEN(7.95):0 I $T D ^DIE L -^VEN(7.95)
 W !!,"Enter the name of this clinic's DEFAULT PROVIDER used during check-in"
 S DR="2.02" L +^VEN(7.95):0 I $T D ^DIE L -^VEN(7.95)
 W !!,"Enter the name of this clinic's HEALTH SUMMARY PRINT GROUP"
 S DR="2.09" L +^VEN(7.95):0 I $T D ^DIE L -^VEN(7.95)
 W !!,"Enter the name of this clinic's ENCOUNTER FORM PRINT GROUP"
 S DR="2.01" L +^VEN(7.95):0 I $T D ^DIE L -^VEN(7.95)
 W !!,"Does this clinic ever require an outguide request during check-in"
 S %=1 D YN^DICN I %=1 G DQ
 S DR="2.1////1" L +^VEN(7.95):0 I $T D ^DIE L -^VEN(7.95)
DQ ; DESTINATION QUEUE TYPE
 S Y=$O(^VEN(7.22,"B",NAME,0)) I Y G DQ1
 S DIC="^VEN(7.22,",DLAYGO=19707.22,DIC(0)="L",X=""""_NAME_""""
 D ^DIC I Y=-1 G CFIN
DQ1 S DIE="^VEN(7.95,",DA=DIEN,DR="1.01////"_+Y
 L +^VEN(7.95):0 I $T D ^DIE L -^VEN(7.95)
 W !!,"Enter the name of another clinic" G C1
CFIN D ^XBFMK
 Q
 ; 
CDEL ; EP-DELETE A CLINIC
 N X,Y,%,%Y,DIC,DIK,DA
 W !!
 S DIC("A")="Enter the name of the clinic you want to delete: "
 S DIC="^VEN(7.95,",DIC(0)="AEQL",DLAYGO=19707.95
 D ^DIC I Y=-1 G CDFIN
 S DA=+Y,NAME=$P(Y,U,2)
 W !,"Are you sure you want to delete ",$P(Y,U,2)
 S %=1 D YN^DICN I %'=1 G CDFIN
 S DIK=DIC
 D ^DIK W !,"Clinic deleted!!"
 S DA=$O(^VEN(7.22,"B",NAME,0))
 I DA S DIK="^VEN(7.22," D ^DIK W !,"The QUEUE TYPE '",NAME,"' has also been deleted"
CDFIN D ^XBFMK
 Q
 ; 
UNI ; EP-CHK VALIDITY OF UNIQUE CLINIC STATUS
 N UNI,%,CFG
 S CFG=$$CFG^VENPCCU
 S UNI=$P($G(^VEN(7.5,CFG,0)),U,6) I 'UNI Q
 I '$D(^VEN(7.95,UNI)) D  Q
 . S $P(^VEN(7.5,CFG,0),U,6)=""
 . W !,"Invalid unique clinic!  Configuration file has been automatically repaired."
 . Q
 S %=$O(^VEN(7.95,0)) I '$O(^VEN(7.95,%)) Q  ; VALID UNIQUE FILE
 W !,"The there is more than one PCC+ clinic registered!!",!,"Do you want to delete the unique clinic in the configuration file"
 S %=1 D YN^DICN
 I %=1 S $P(^VEN(7.5,CFG,0),U,6)=""
 Q
 ; 
