ABMDE7C ; IHS/ASDST/DMJ - Page 7 - Inpatient Triggers ;   
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 11/01/01 - V2.4 P9  - Resolve undef error when splitting claims.
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 ; *********************************************************************
 ;
 ; If it gets this far w/o active insurer, ABMP("FEE") is undefined
 S:'$D(ABMP("FEE")) ABMP("FEE")=$P($G(^ABMDPARM(DUZ(2),1,0)),U,9)
TRIG S ABM("C6")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),ABM("C5")=$G(^(5)),ABM("C7")=$G(^(7))
 G RB:+ABM("C5")'=85
FLAT2 I $D(ABMP("FLAT")),$P(ABM("C5"),U,10)>0 S ABMP("FLAT",170)=$P(ABM("C5"),U,10)
 G COMP:ABMP("PAGE")'[8
 ;
RB I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),25,0)),$P(ABM("C7"),U,3)>0 D
 .Q:ABMP("VTYP")=831
 .Q:ABMP("VTYP")=999
 .S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",25,",DIC(0)="LXE"
 .S ^ABMDCLM(DUZ(2),ABMP("CDFN"),25,0)="^9002274.3025P"
 .;S (DINUM,X)=120,DIC("DR")=".02////"_$P(ABM("C7"),U,3)_";.03////"_$P($G(^ABMDFEE(ABMP("FEE"),31,X,0)),U,2) K DD,DO D FILE^DICN  ;abm*2.6*2 3PMS10003A
 .S (DINUM,X)=120,DIC("DR")=".02////"_$P(ABM("C7"),U,3)_";.03////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),31,X,ABMP("VDT")),U) K DD,DO D FILE^DICN  ;abm*2.6*2 3PMS10003A
 ;
NURS G NONUR:+ABM("C5")'=85
 I '$D(ABMP("FLAT")),ABMP("VTYP")'=831 D
 .Q:$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),25,0))
 .S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",25,",DIC(0)="LE"
 .;I $P(ABM("C5"),U,10)>0 S (DINUM,X)=170,DIC("DR")=".02////"_$P(ABM("C5"),U,10)_";.03////"_$P($G(^ABMDFEE(ABMP("FEE"),31,X,0)),U,2) K DD,DO D FILE^DICN  ;abm*2.6*2 3PMS10003A
 .I $P(ABM("C5"),U,10)>0 S (DINUM,X)=170,DIC("DR")=".02////"_$P(ABM("C5"),U,10)_";.03////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),31,X,ABMP("VDT")),U) K DD,DO D FILE^DICN  ;abm*2.6*2 3PMS10003A
 G COMP
 ;
NONUR I $P(ABM("C5"),U,10)]"" S DA=ABMP("CDFN"),DR=".525///@",DIE="^ABMDCLM(DUZ(2)," D ^DIE
 I $D(ABMP("FLAT")) K ABMP("FLAT",2)
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),25,170))=10 S DA(1)=ABMP("CDFN"),DIK="^ABMDCLM(DUZ(2),"_DA(1)_",25,",DA=170 D ^DIK
 ;
COMP ;COMP LINE TAG
 ;
PSRO S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 ;
MED Q:$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,0))
 S ^ABMDCLM(DUZ(2),ABMP("CDFN"),27,0)="^9002274.3027P"
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",27,",DIC(0)="LE"
 S (DINUM,X)=$S($D(^ICPT(99221)):99221,1:90200)
 ;S DIC("DR")=".03////1;.04////"_$P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2)  ;abm*2.6*2 3PMS10003A
 S DIC("DR")=".03////1;.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 K DD,DO D FILE^DICN
 ;I $P(ABM("C7"),U,3)>1 S (X,DINUM)=$S($D(^ICPT(99231)):99231,1:90240),DIC("DR")=".03////"_($P(ABM("C7"),U,3)-1)_";.04////"_$P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2) K DD,DO D FILE^DICN  ;abm*2.6*2 3PMS10003A
 I $P(ABM("C7"),U,3)>1 S (X,DINUM)=$S($D(^ICPT(99231)):99231,1:90240),DIC("DR")=".03////"_($P(ABM("C7"),U,3)-1)_";.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U) K DD,DO D FILE^DICN  ;abm*2.6*2 3PMS10003A
 ;I $P(ABM("C7"),U,2)>$P(ABM("C7"),U) S (X,DINUM)=$S($D(^ICPT(99238)):99238,1:90292),DIC("DR")=".03////1;.04////"_$P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2) K DD,DO D FILE^DICN  ;abm*2.6*2 3PMS10003A
 I $P(ABM("C7"),U,2)>$P(ABM("C7"),U) S (X,DINUM)=$S($D(^ICPT(99238)):99238,1:90292),DIC("DR")=".03////1;.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U) K DD,DO D FILE^DICN  ;abm*2.6*2 3PMS10003A
 Q
