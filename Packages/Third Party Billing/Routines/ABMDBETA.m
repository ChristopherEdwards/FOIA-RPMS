ABMDBETA ; IHS/ASDST/DMJ - Routine to Update Beta Sites ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 I '$D(DUZ(2)) D ^XBKVAR
 W !!!,"Wait, processing..."
 S DA=$O(^AUTNINS("B","BENEFICIARY PATIENT (INDIAN)","")) I DA,$P($G(^AUTNINS(DA,2)),U)'="I" S DR=".21////I",DIE="^AUTNINS(" D ^ABMDDIE Q:$D(ABM("DIE-FAIL"))
 S DA(2)=$O(^AUTNINS("B","MEDICARE","")),DA(1)=831 I DA(2),'$O(^AUTNINS(DA(2),39,DA(1),11,1)) S DA=1,DR=".03///@",DIE="^AUTNINS("_DA(2)_",39,831,11," D ^ABMDDIE Q:$D(ABM("DIE-FAIL"))
 G XIT:$D(^ABMDERR(48,0))
 I $D(^DD(9002274.0111,.01,0)),^(0)'["DINUM" S ^(0)=$P(^(0),"X=+Y")_"(DINUM,X)=+Y"_$P(^(0),"X=+Y",2)
 I $D(^DD(9002274.51111,.01,0)),^(0)'["SURGERY" S ^(0)=$P(^(0),"EMERGENCY ROOM")_"SURGERY"_$P(^(0),"EMERGENCY ROOM",2)
 I $P($G(^DD(9002274.3035,.02,0)),U,5,99)["<37" S ^(0)=$P(^(0),"37")_"36!($E(^(0),1,2)=40)"_$P(^(0),"37",2,99)
 I $G(^DD(9002274.3035,.02,12.1))["<37" S ^(12.1)=$P(^(12.1),"<37")_"<36!($E(^(0),1,2)=40)"_$P(^(12.1),"<37",2)
 I $P($G(^DD(9002274.4035,.02,0)),U,5,99)["<37" S ^(0)=$P(^(0),"37")_"36!($E(^(0),1,2)=40)"_$P(^(0),"37",2,99)
 I $G(^DD(9002274.4035,.02,12.1))["<37" S ^(12.1)=$P(^(12.1),"<37")_"<36!($E(^(0),1,2)=40)"_$P(^(12.1),"<37",2)
 S DIE="^ABMDTXST(",DA=0 F  S DA=$O(^ABMDTXST(DA)) Q:'DA  I "UH"[$P(^(DA,0),U,2) S DR=".02////"_$S($P(^(0),U,2)="H":2,1:1) D ^ABMDDIE Q:$D(ABM("DIE-FAIL"))  W "."
 S DIE="^ABMDBILL(",DA=0 F  S DA=$O(^ABMDBILL(DA)) Q:'DA  D
 .S DR=".16///@"
 .I "TAR"'[$P(^ABMDBILL(DA,0),U,4),'$P($G(^ABMDBILL(DA,1)),U,8) S DR=".16////A"
 .D ^ABMDDIE W "." Q:$D(ABM("DIE-FAIL"))
 ;
 W "." K DD,DO S DIC="^ABMDERR(",DIC(0)="L",DINUM=4,X="CLAIM HAS NO CHARGES (PROCEDURES OR SERVICES) TO BILL"
 S DIC("DR")=".02////Enter in all procedures, services, accomodations, and medications in the Worksheet (CPT) Pages." D FILE^DICN
 W "." K DD,DO S DINUM=40,X="CLINIC IS DESIGNATED AS UNBILLABLE"
 S DIC("DR")=".02////The Insurer is unbillable for this clinic as designated in the Coverage Type File." D FILE^DICN
 W "." K DD,DO S DINUM=46,X="DIAGNOSIS IS DESIGNATED AS UNBILLABLE"
 S DIC("DR")=".02////The Insurer is unbillable for the Diagnosis as designated in the Coverage Type File." D FILE^DICN
 W "." K DD,DO S DINUM=41,X="PROVIDER DISIPLINE IS DESIGNATED AS UNBILLABLE"
 S DIC("DR")=".02////The Insurer is unbillable for the Provider Disipline as designated in the Coverage Type File." D FILE^DICN
 W "." K DD,DO S DINUM=42,X="VISIT TYPE IS DESIGNATED AS UNBILLABLE"
 S DIC("DR")=".02////The Insurer is unbillable for this Visit Type as designated in the Insurer File." D FILE^DICN
 W "." K DD,DO S DINUM=43,X="DENTAL VISITS ARE DESIGNATED AS UNBILLABLE"
 S DIC("DR")=".02////The Insurer is unbillable for Dental Visits as designated in the Insurer File." D FILE^DICN
 W "." K DD,DO S DINUM=44,X="PHARMACY VISITS ARE DESIGNATED AS UNBILLABLE"
 S DIC("DR")=".02////The Insurer is unbillable for Pharmacy Visits as designated in the Insurer File." D FILE^DICN
 W "." K DD,DO S DINUM=45,X="ONLY DENTAL VISITS ARE BILLABLE"
 S DIC("DR")=".02////The Insurer covers Dental visits only as designated in the Insurer File." D FILE^DICN
 W "." K DD,DO S DINUM=47,X="POLICY IS DESIGNATED AS BEING SUPPLEMENTAL TO MEDICARE"
 S DIC("DR")=".02////If the policy is not supplemental to Medicare the linkage to the Coverage Type that is designated as Medicarte Supplemental should be removed." D FILE^DICN
 W "." K DD,DO S DINUM=48,X="MEDICARE IS UNBILLABLE AND POLICY IS SUPPLEMENTAL TO MEDICARE"
 S DIC("DR")=".02////A bill can not be generated for a policy that is supplemental to Medicare when Medicare can not be billed." D FILE^DICN
UPDT S DIE="^ABMDERR(",DR=".03////E;.05////1"
 F DA=4,6,8,40,41,42,43,44,45,46,48,92,110,111,115,121,122,123,124,125,126,127,152,153,162,173 D ^ABMDDIE W "." Q:$D(ABM("DIE-FAIL"))
 S DA=170,DR=".03////W;.05////0" D ^ABMDDIE Q:$D(ABM("DIE-FAIL"))
 S DA=105,DR=".01///POLICY HOLDER'S ADDRESS UNSPECIFIED;.02////Edit the appropriate Private Insurance Policy so that the Address of the Policy Holder is specified." D ^ABMDDIE Q:$D(ABM("DIE-FAIL"))
 W "." K DA,DD,DO,DIC,DINUM
 S DA=$O(^AUTNINS("B","WORKMEN'S COMP","")) I 'DA S DIC="^AUTNINS(",DIC(0)="L",X="WORKMEN'S COMP" D FILE^DICN S DA=$S(+Y:+Y,1:"")
 I DA S DIE="^AUTNINS(",DR=".17////2;.21////W;.41////WORKMEN'S COMPENSATION" D ^ABMDDIE Q:$D(ABM("DIE-FAIL"))
 S DA=0 F  S DA=$O(^AUTNINS(DA)) Q:'DA  D KEYWD^ABMDTINS W "."
 ;
XIT K ABM
 Q
