ABMDVST1 ; IHS/ASDST/DMJ - PCC VISIT STUFF - PART 2 (PURPOSE OF VISIT) ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;03/26/96 12:11 PM
 ;
 ; IHS/ASDS/DMJ - 10/31/00 - V2.4 Patch 3 - NOIS NDA-0500-180002
 ;     Modify code to pick up e-codes from PCC if exist
 ;
 ; IHS/SD/SDR - 11/4/02 - V2.5 P2 - NDA-0500-180002
 ;     Modified to pick up all e-codes from PCC
 ; IHS/SD/SDR - v2.5 p9 - IM18472
 ;    Modified to make sure there aren't two of the same priority ICD
 ; IHS/SD/SDR - v2.5 p10 - IM21619
 ;   Added code to populate claim number from Workman's Comp file
 ; IHS/SD/SDR - v2.5 p13 - IM25840
 ;   <UNDEF>DX+39^ABMDEMLC caused when there is a primary code with
 ;   an E-code and a secondary (E-code s/b secondary)
 ; IHS/SD/SDR - v2.5 p13 - POA changes
 ;
 ; IHS/SD/SDR - v2.6
 ;
 Q:ABMIDONE
 I $O(^DIC(40.7,"B","EMERGENCY MEDICINE",""))=ABMP("CLN") S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0) D ASET^ABMDE3B
 ;E3B sets special UB-82 codes
 I $O(^DIC(40.7,"B","EPSDT",""))=ABMP("CLN") S Y=67 D SP^ABMDE3B
 I $O(^DIC(40.7,"B","FAMILY PLANNING",""))=ABMP("CLN") S Y=70 D SP^ABMDE3B
 ;
 N BP,ABMPRI
 S ABM=0
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM)) Q:'ABM  D
 .S Y=^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM,0)
 .S ABMPRI($P(Y,U,2),+Y)=""
 S ABM=0
 ;ABMR("P") is a counter used to keep track of priorities already used
 ;Start with 2 unless there already exist priorities
 S ABMR("P")=$S($D(ABMPRI):$O(ABMPRI(""),-1)+1,1:2)
 ;First check billing pointer for POV
 S BP=$P(^AUPNVSIT(ABMVDFN,0),U,28)
 I BP]"" D
 .F  S ABM=$O(^AUPNVPOV("AD",BP,ABM)) Q:'ABM  K DR,DIC("DR") D POVCHK
 .K DIC
 S ABM=0
POV F  S ABM=$O(^AUPNVPOV("AD",ABMVDFN,ABM)) Q:'ABM  K DR,DIC("DR") D POVCHK
 I $D(ABMPRI),'$O(ABMPRI($O(ABMPRI("")))) S ABMP("CORRSDIAG")=$O(ABMPRI(""))
 K DIC
 Q
 ;
POVCHK ;POV is dinumed.  Each POV is only entered once.
 N ABMPOV0,ABMICD
 I '$D(^AUPNVPOV(ABM,0)) Q
 S ABMPOV0=^AUPNVPOV(ABM,0)
 S ABMICD=$P($$DX^ABMCVAPI(+ABMPOV0,ABMP("VDT")),U,2)  ;CSV-c
 ;Through the use of the ABMPRI array it would be possible to change
 ;the priorities of existing entries if needed.
 ;ABMR("PX") is priority of diagnosis
 ;Piece 12 is primary/secondary
 ;Only a non-V code can be given priority 1
 S ABMR("PX")=$S($D(ABMPRI(1))=10:ABMR("P"),$E(ABMICD,1)="V":ABMR("P"),$P(ABMPOV0,U,12)="P":1,1:ABMR("P"))
 ; Do not do this section for I or D visits
 I ABMP("V0")=ABMCHV0!("ID"'[$P(ABMCHV0,U,7)) D
 .;Employment related POV put Y into employment rel field in claim
 .I $P(ABMPOV0,U,7)=4 D
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN"),DR=".91////Y"
 ..I $P(ABML(ABMP("PRI"),ABMP("INS")),U,2)'="" S DR=DR_";.48////"_$P($G(^AUPNWC(ABMP("PDFN"),11,$P(ABML(ABMP("PRI"),ABMP("INS")),U,2),0)),U,4)
 ..D ^DIE
 ..K DR
 .;Injury date
 .I $P(ABMPOV0,U,13)]"" D
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN")
 ..S DR=".82////"_$P(ABMPOV0,U,13) D ^DIE K DR
 .I $P(ABMPOV0,U,9)]"" D
 ..;Checking to see if 1st 3 chars of ICD code are E81
 ..S ABM("ECODE")=$P(ABMPOV0,"^",9)
 ..S ABM("Y")=$S($E($P($$DX^ABMCVAPI(ABM("ECODE"),ABMP("VDT")),U,2),1,3)="E81":1,1:5)  ;CSV-c
 ..S ABM("X")=$S($P(ABMPOV0,U,13):$P(ABMPOV0,U,13),1:ABMP("VDT"))
 ..D ACCODE^ABMDE3A K DIC
 ..;X is set to Accident type code
 ..S X=$S(ABM("Y")=1:ABM("Y"),$P(ABMPOV0,U,7)=4:4,1:5)
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN")
 ..S DR=".83////"_X D ^DIE
 ..S DR=".857////"_ABM("ECODE") D ^DIE
 ..K ABM("ECODE")
 ;Diagnosis subfile is at node 17
 S X=$P(ABMPOV0,U)
 S DINUM=X,ABMR("NAR")=$P(ABMPOV0,U,4)
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",17,"
 S DIC(0)="LE" K DD,DO
 S DIC("P")=$P(^DD(9002274.3,17,0),U,2)
 S DIC("DR")=".02////"_ABMR("PX")_";.03////"_ABMR("NAR")
 S DIC("DR")=DIC("DR")_";.04////"_$P(ABMPOV0,U,9)  ;E-code
 S DIC("DR")=DIC("DR")_";.05////"_$P(ABMPOV0,U,22)
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,DINUM,0)) D  Q
 .S DIE=DIC
 .S DA=DINUM
 .S DR=$P(DIC("DR"),";",2)
 .K DINUM,DIC
 .D ^DIE
 .K DIE,X,Y
 S ABMPRI(ABMR("PX"),X)=""
 K DD,DO D FILE^DICN
 I ABMR("PX")>1 S ABMR("P")=ABMR("P")+1
 K DIC,X,Y
 K DIC("DR")
 S ABMECD=$P(ABMPOV0,U,9)  ;E-code
 Q:ABMECD=""
 ;entry already exists in array; shift others down one to make room
 I ABMR("P")-1'=1,($O(ABMPRI(1,0))'="") D
 .S ABMOPRI=999
 .F  S ABMOPRI=$O(ABMPRI(ABMOPRI),-1) Q:ABMOPRI=1  D  Q:DA=$P(ABMPOV0,U)
 ..S DA(1)=ABMP("CDFN")
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",17,"
 ..S DA=$O(ABMPRI(ABMOPRI,0))
 ..Q:DA=$P(ABMPOV0,U)
 ..S DR=".02////"_(+ABMOPRI+1)
 ..S DR=DR_";.05////"_$P($G(ABMPOV0),U,5)
 ..D ^DIE
 ..S ABMPRI(ABMOPRI+1,DA)=""
 ..K ABMPRI(ABMOPRI,DA)
 ..S ABMR("P")=ABMR("P")-1
 S (DINUM,X)=ABMECD
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",17,"
 S DIC(0)="LE" K DD,DO
 S DIC("P")=$P(^DD(9002274.3,17,0),U,2)
 S DIC("DR")=".02////"_ABMR("P")_";.03////"_ABMR("NAR")
 S DIC("DR")=DIC("DR")_";.05////"_$P($G(ABMPOV0),U,22)
 S ABMPRI(ABMR("P"),ABMECD)=""
 K DD,DO D FILE^DICN
 I ABMR("PX")>0 S ABMR("P")=ABMR("P")+1
 K DIC,X,Y
 Q
