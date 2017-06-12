ABMDVST1 ; IHS/ASDST/DMJ - PCC VISIT STUFF - PART 2 (PURPOSE OF VISIT) ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**10,14,16,18**;NOV 12, 2009;Build 289
 ;Original;TMD;03/26/96 12:11 PM
 ;
 ;IHS/ASDS/DMJ - 10/31/00 - V2.4 Patch 3 - NOIS NDA-0500-180002
 ;     Modify code to pick up e-codes from PCC if exist
 ;
 ;IHS/SD/SDR - 11/4/02 - V2.5 P2 - NDA-0500-180002
 ;    Modified to pick up all e-codes from PCC
 ;IHS/SD/SDR - v2.5 p9 - IM18472
 ;   Modified to make sure there aren't two of the same priority ICD
 ;IHS/SD/SDR - v2.5 p10 - IM21619
 ;  Added code to populate claim number from Workman's Comp file
 ;IHS/SD/SDR - v2.5 p13 - IM25840
 ;  <UNDEF>DX+39^ABMDEMLC caused when there is a primary code with
 ;  an E-code and a secondary (E-code s/b secondary)
 ;IHS/SD/SDR - v2.5 p13 - POA changes
 ;
 ;IHS/SD/SDR - v2.6
 ;IHS/SD/SDR - 2.6*14 - Populated .06 field of 17 multiple if ICD10 code.  002F
 ;IHS/SD/SDR - 2.6*14 - ICD10 SNOMED - populate SNOMED and dual coding fields from V POV file.
 ;IHS/SD/SDR - 2.6*14 - ICD10 ICD Indicator - Added code to check for 3P Claim .021 field to see if it has been set for claim;
 ;  acts as override for ICD-10 Effective Date
 ;IHS/SD/SDR - 2.6*14 - Updated DX^ABMCVAPI to be numeric
 ;IHS/SD/SDR - 2.6*14 - Made change for E-codes if there are any for ICD-10 and to keep ICD9 and ICD10 separate.
 ;IHS/SD/SDR - 2.6*14 - CR3445 - Made change for sequencing; with ICD10 changes, if there were E-codes present the sequencing was getting
 ;  messed up.
 ;IHS/SD/SDR - 2.6*16 - HEAT200359 - Made changes so CASE NUMBER will populated with the claim number from Reg if it is
 ;  a workman's comp claim.  Wasn't doing lookup correctly (data needed wasn't defined).
 ;IHS/SD/SDR - 2.6*16 - HEAT217211 - Added code to populated External Cause 2, External Cause 3, Place of Occurrence, and Place of Occurrence (E849)
 ;IHS/SD/SDR - 2.6*18 - HEAT239392 - Correction for E-code not crossing over from PCC Visit.
 ;
 ;
 Q:ABMIDONE
 I $O(^DIC(40.7,"B","EMERGENCY MEDICINE",""))=ABMP("CLN") S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0) D ASET^ABMDE3B
 ;E3B sets special UB-82 codes
 I $O(^DIC(40.7,"B","EPSDT",""))=ABMP("CLN") S Y=67 D SP^ABMDE3B
 I $O(^DIC(40.7,"B","FAMILY PLANNING",""))=ABMP("CLN") S Y=70 D SP^ABMDE3B
 ;
 I +$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,21)=9 S ABMP("ICD10")=(ABMP("VDT")+1)  ;abm*2.6*14 ICD10 ICD Indicator
 I +$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,21)=10 S ABMP("ICD10")=(ABMP("VDT")-1)  ;abm*2.6*14 ICD10 ICD Indicator
 I (+$G(ABMP("INS"))'=0)&(+$G(ABMP("ICD10"))=0) S ABMP("ICD10")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),0)),U,12)  ;abm*2.6*14 ICD10 002F
 N BP,ABMPRI
 S ABM=0
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM)) Q:'ABM  D
 .S Y=^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM,0)
 .I +$P(Y,U,2)=0 Q  ;skip if not sequenced  ;abm*2.6*14 ICD10 002F
 .S ABMPRI($P(Y,U,2),+Y)=""
 .S ABMTYP=$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM,0)),U,6)=1:"ICD10",1:"ICD9")
 S ABM=0
 ;ABMR("P") is a counter used to keep track of priorities already used
 ;Start with 2 unless there already exist priorities
 ;S ABMR("P")=$S($D(ABMPRI):$O(ABMPRI(""),-1)+1,1:2)  ;abm*2.6*10 NOHEAT
 ;changed so default would be 1, not 2 for priority; if only 1 DX user would have to resequence
 ;S ABMR("P")=$S($D(ABMPRI):$O(ABMPRI(""),-1)+1,1:1)  ;abm*2.6*10 NOHEAT  ;abm*2.6*14 CR3445
 S ABMR("P")=$S($D(ABMPRI):$O(ABMPRI(""),-1)+1,1:0)  ;abm*2.6*10 NOHEAT  ;abm*2.6*14 CR3445
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
 S ABMPOV11=$G(^AUPNVPOV(ABM,11))  ;abm*2.6*14 ICD10 SNOMED
 S ABMICD=$P($$DX^ABMCVAPI(+ABMPOV0,ABMP("VDT")),U,2)  ;CSV-c
 S ABMTYP=$S($P($$DX^ABMCVAPI(+ABMPOV0,ABMP("VDT")),U,20)=30:"ICD10",1:"ICD9")  ;abm*2.6*14 ICD10 002F
 ;start old abm*2.6*18 IHS/SD/SDR HEAT239392
 ;start new code abm*2.6*14 E-codes
 ;S ABM("ECODE")=0
 ;I ABMP("VDT")<3150930 S ABM("ECODE")=+$P(ABMPOV0,U,9)
 ;I ABMP("VDT")>3151001&((ABMP("VDT")>ABMP("ICD10"))!(ABMP("VDT")=ABMP("ICD10"))) S ABM("ECODE")=+$P(ABMPOV0,U,9)
 ;I ABMP("VDT")>3151001&(ABMP("VDT")<ABMP("ICD10")) S ABM("ECODE")=+$P(ABMPOV0,U,25)
 ;I ABM("ECODE")'=0 D
 ;end new code abm*2.6*14 E-codes
 ;end old start new abm*2.6*18 IHS/SD/SDR HEAT239392
 S ABM("ECODE")=0
 ;I ABMP("VDT")<ABMP("ICD10") S ABM("ECODE")=+$P(ABMPOV0,U,25)
 ;I (ABMP("VDT")>ABMP("ICD10"))!(ABMP("VDT")=ABMP("ICD10")) S ABM("ECODE")=+$P(ABMPOV0,U,9)
 I ((ABMP("VDT")'<ABMP("ICD10"))&($P($$DX^ABMCVAPI(+$P(ABMPOV0,U,9),ABMP("VDT")),U,20)=30)) S ABM("ECODE")=+$P(ABMPOV0,U,9)
 I ((ABMP("VDT")<ABMP("ICD10"))&($P($$DX^ABMCVAPI(+$P(ABMPOV0,U,9),ABMP("VDT")),U,20)'=30)) S ABM("ECODE")=+$P(ABMPOV0,U,9)
 I ((ABMP("VDT")<ABMP("ICD10"))&(+$P(ABMPOV0,U,25)'=0)) S ABM("ECODE")=+$P(ABMPOV0,U,25)
 ;end new abm*2.6*18 IHS/SD/SDR HEAT239392
 ;Through the use of the ABMPRI array it would be possible to change
 ;the priorities of existing entries if needed.
 ;ABMR("PX") is priority of diagnosis
 ;Piece 12 is primary/secondary
 ;Only a non-V code can be given priority 1
 ;S ABMR("PX")=$S($D(ABMPRI(1))=10:ABMR("P"),$E(ABMICD,1)="V":ABMR("P"),$P(ABMPOV0,U,12)="P":1,1:ABMR("P"))  ;abm*2.6*14 CR3445
 S ABMR("PX")=ABMR("P")  ;abm*2.6*14 CR3445
 S ABMR("P")=ABMR("P")+1  ;abm*2.6*10 NOHEAT
 ; Do not do this section for I or D visits
 I ABMP("V0")=ABMCHV0!("ID"'[$P(ABMCHV0,U,7)) D
 .;Employment related POV put Y into employment rel field in claim
 .I $P(ABMPOV0,U,7)=4 D
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN"),DR=".91////Y"
 ..;I $P(ABML(ABMP("PRI"),ABMP("INS")),U,2)'="" S DR=DR_+";.48////"_$P($G(^AUPNWC(ABMP("PDFN"),11,$P(ABML(ABMP("PRI"),ABMP("INS")),U,2),0)),U,4)  ;abm*2.6*16 IHS/SD/SDR HEAT200359
 ..;start new abm*2.6*16 IHS/SD/SDR HEAT200359
 ..N ABML S ABML=""
 ..D ELG^ABMDLCK(ABMVDFN,.ABML,ABMP("PDFN"),ABMP("VDT"))
 ..S ABMT("PRI")=0,ABMWFLG=0
 ..F  S ABMT("PRI")=$O(ABML(ABMT("PRI"))) Q:'ABMT("PRI")  D  Q:ABMWFLG=1
 ...S ABMT("INS")=$O(ABML(ABMT("PRI"),0))
 ...Q:ABMT("INS")'=ABMP("INS")  ;not correct insurer
 ...I $P(ABML(ABMT("PRI"),ABMP("INS")),U,3)'="W" Q  ;workman's comp only past this
 ...I +$P(ABML(ABMT("PRI"),ABMP("INS")),U,2)'=0 S DR=DR_";.48////"_$P($G(^AUPNWC(ABMP("PDFN"),11,$P(ABML(ABMT("PRI"),ABMP("INS")),U,2),0)),U,4)
 ..;end new abm*2.6*16 IHS/SD/SDR HEAT200359
 ..D ^DIE
 ..K DR
 .;Injury date
 .I $P(ABMPOV0,U,13)]"" D
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN")
 ..S DR=".82////"_$P(ABMPOV0,U,13) D ^DIE K DR
 .;I $P(ABMPOV0,U,9)]"" D  ;abm*2.6*14 E-codes
 .I ABM("ECODE")'=0 D  ;abm*2.6*14 E-codes
 ..;Checking to see if 1st 3 chars of ICD code are E81
 ..;S ABM("ECODE")=$P(ABMPOV0,"^",9)  ;abm*2.6*14 E-codes
 ..;S ABM("Y")=$S($E($P($$DX^ABMCVAPI(ABM("ECODE"),ABMP("VDT")),U,2),1,3)="E81":1,1:5)  ;CSV-c  ;abm*2.6*14 updated API call
 ..S ABM("Y")=$S($E($P($$DX^ABMCVAPI(+ABM("ECODE"),ABMP("VDT")),U,2),1,3)="E81":1,1:5)  ;CSV-c  ;abm*2.6*14 updated API call
 ..S ABM("X")=$S($P(ABMPOV0,U,13):$P(ABMPOV0,U,13),1:ABMP("VDT"))
 ..D ACCODE^ABMDE3A K DIC
 ..;X is set to Accident type code
 ..S X=$S(ABM("Y")=1:ABM("Y"),$P(ABMPOV0,U,7)=4:4,1:5)
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN")
 ..S DR=".83////"_X D ^DIE
 ..S DR=".857////"_ABM("ECODE") D ^DIE
 ..;K ABM("ECODE")  ;abm*2.6*14 E-codes
 ;Diagnosis subfile is at node 17
 S X=$P(ABMPOV0,U)  ;DX code
 I +$P(ABMPOV0,U,24)'=0&(ABMP("ICD10")>ABMP("VDT")) S X=$P(ABMPOV0,U,24),ABMTYP="ICD9"  ;abm*2.6*14 dual coding - ICD9 dual coding field
 S DINUM=X,ABMR("NAR")=$P(ABMPOV0,U,4)  ;DINUM and provider narrative
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",17,"
 S DIC(0)="LE" K DD,DO
 S DIC("P")=$P(^DD(9002274.3,17,0),U,2)
 ;S DIC("DR")=".02////"_ABMR("PX")_";.03////"_ABMR("NAR")  ;abm*2.6*14 ICD10 002F
 I (ABMP("ICD10")<ABMP("VDT")!(ABMP("ICD10")=ABMP("VDT")))&(ABMTYP="ICD10") S DIC("DR")=".02////"_ABMR("P")  ;abm*2.6*14 ICD10 002F
 I (ABMP("ICD10")>ABMP("VDT")&(ABMTYP="ICD9")) S DIC("DR")=".02////"_ABMR("P")  ;abm*2.6*14 ICD10 002F
 S DIC("DR")=$S($G(DIC("DR"))'="":DIC("DR")_";",1:"")_".03////"_ABMR("NAR")  ;abm*2.6*14 ICD10 002F
 ;S DIC("DR")=DIC("DR")_";.04////"_$P(ABMPOV0,U,9)  ;E-code  ;abm*2.6*14 E-codes
 S:(+ABM("ECODE")'=0) DIC("DR")=DIC("DR")_";.04////"_ABM("ECODE")  ;E-code  ;abm*2.6*14 E-codes
 S DIC("DR")=DIC("DR")_";.05////"_$P(ABMPOV0,U,22)
 I $P($$DX^ABMCVAPI(+X,ABMP("VDT")),U,20)=30 S DIC("DR")=DIC("DR")_";.06////1"  ;abm*2.6*14 ICD10 002F and updated API call
 ;start new code abm*2.6*14 ICD10 SNOMED/dual coding
 S:$P(ABMPOV0,U,18)'="" DIC("DR")=DIC("DR")_";.07////"_$P(ABMPOV0,U,18)  ;abm*2.6*16 IHS/SD/SDR HEAT217211
 S:$P(ABMPOV0,U,19)'="" DIC("DR")=DIC("DR")_";.08////"_$P(ABMPOV0,U,19)  ;abm*2.6*16 IHS/SD/SDR HEAT217211
 S:$P(ABMPOV0,U,21)'="" DIC("DR")=DIC("DR")_";.09////"_$P(ABMPOV0,U,21)  ;abm*2.6*16 IHS/SD/SDR HEAT217211
 S:$P(ABMPOV0,U,24)'="" DIC("DR")=DIC("DR")_";21////"_$P(ABMPOV0,U,24)
 S:$P(ABMPOV0,U,25)'="" DIC("DR")=DIC("DR")_";23////"_$P(ABMPOV0,U,25)
 S:$P(ABMPOV0,U,26)'="" DIC("DR")=DIC("DR")_";24////"_$P(ABMPOV0,U,26)
 S:$P(ABMPOV0,U,27)'="" DIC("DR")=DIC("DR")_";25////"_$P(ABMPOV0,U,27)
 S:$P(ABMPOV0,U,28)'="" DIC("DR")=DIC("DR")_";26////"_$P(ABMPOV0,U,28)  ;abm*2.6*16 IHS/SD/SDR HEAT217211
 S:$P(ABMPOV11,U)'="" DIC("DR")=DIC("DR")_";11////"_$P(ABMPOV11,U)
 S:$P(ABMPOV11,U,2)'="" DIC("DR")=DIC("DR")_";13////"_$P(ABMPOV11,U,2)
 S:$P(ABMPOV11,U,3)'="" DIC("DR")=DIC("DR")_";15////"_$P(ABMPOV11,U,3)
 ;end new code ICD10 SNOMED/dual coding
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,DINUM,0)) D  Q
 .S DIE=DIC
 .S DA=DINUM
 .S DR=$P(DIC("DR"),";",2)
 .K DINUM,DIC
 .D ^DIE
 .K DIE,X,Y
 S ABMPRI(ABMR("PX"),X)=""
 K DD,DO D FILE^DICN
 ;I ABMR("PX")>1 S ABMR("P")=ABMR("P")+1  ;abm*2.6*14 ICD10 002F
 I ABMP("ICD10")<ABMP("VDT")!(ABMP("ICD10")=ABMP("VDT")),ABMR("PX")>1 S ABMR("P")=ABMR("P")+1  ;abm*2.6*14 ICD10 002F
 K DIC,X,Y
 K DIC("DR")
 ;S ABMECD=$P(ABMPOV0,U,9)  ;E-code  ;abm*2.6*14 E-codes
 S ABMECD=ABM("ECODE")  ;E-code  ;abm*2.6*14 E-codes
 ;Q:ABMECD=""  ;abm*2.6*14 E-codes
 Q:ABMECD=0  ;abm*2.6*14 E-codes
 ;entry already exists in array; shift others down one to make room
 ;abm*2.6*14 start old CR3445
 ;I ABMR("P")-1'=1,($O(ABMPRI(1,0))'="") D
 ;.S ABMOPRI=999
 ;.F  S ABMOPRI=$O(ABMPRI(ABMOPRI),-1) Q:ABMOPRI=1  D  Q:DA=$P(ABMPOV0,U)
 ;..S DA(1)=ABMP("CDFN")
 ;..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",17,"
 ;..S DA=$O(ABMPRI(ABMOPRI,0))
 ;..Q:DA=$P(ABMPOV0,U)
 ;..S DR=".02////"_(+ABMOPRI+1)
 ;..;S DR=DR_";.05////"_+$P($G(ABMPOV0),U,21)  ;abm*2.6*14
 ;..S:($P($G(ABMPOV0),U,22)'="") DR=DR_";.05////"_$P($G(ABMPOV0),U,22)  ;abm*2.6*14
 ;..I ABMTYP="ICD10" S DR=DR_";.06////1"  ;abm*2.6*14 E-codes ICD Indicator
 ;..D ^DIE
 ;..S ABMPRI(ABMOPRI+1,DA)=""
 ;..K ABMPRI(ABMOPRI,DA)
 ;..S ABMR("P")=ABMR("P")-1
 ;end old CR3445
 S ABMR("P")=ABMR("P")+1  ;abm*2.6*14 CR3445
 S (DINUM,X)=ABMECD
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",17,"
 S DIC(0)="LE" K DD,DO
 S DIC("P")=$P(^DD(9002274.3,17,0),U,2)
 ;S DIC("DR")=".02////"_ABMR("P")_";.03////"_ABMR("NAR")  ;abm*2.6*14 ICD10 002F
 I ABMP("ICD10")<ABMP("VDT")!(ABMP("ICD10")=ABMP("VDT"))&(ABMTYP="ICD10") S DIC("DR")=".02////"_ABMR("P")  ;abm*2.6*14 ICD10 002F
 I (ABMP("ICD10")>ABMP("VDT")&(ABMTYP="ICD9")) S DIC("DR")=".02////"_ABMR("P")  ;abm*2.6*14 ICD10 002F
 S DIC("DR")=$S($G(DIC("DR"))'="":DIC("DR")_";",1:"")_".03////"_ABMR("NAR")  ;abm*2.6*14 ICD10 002F
 S DIC("DR")=DIC("DR")_";.05////"_$P($G(ABMPOV0),U,22)
 I ABMTYP="ICD10" S DIC("DR")=DIC("DR")_";.06////1"  ;abm*2.6*14 E-codes ICD Indicator
 S ABMPRI(ABMR("P"),ABMECD)=""
 K DD,DO D FILE^DICN
 ;I ABMR("PX")>0 S ABMR("P")=ABMR("P")+1  ;abm*2.6*14 CR3445
 K DIC,X,Y
 Q
