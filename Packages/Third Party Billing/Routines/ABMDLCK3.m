ABMDLCK3 ; IHS/ASDST/DMJ - check visit for elig - CONT'D ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;;Y2K/OK - IHS/ADC/JLG 12-18-97
 ;Original;TMD;
 ;
 ; IHS/ASDS/LSL - 06/27/2001 - V2.4 Patch 9 - NOIS HQW-0798-100082 
 ;     Expand No Eligibility Found.  Working this call caused 
 ;     ABMDLCK1 to be too large.  Overflow placed in this routine
 ;
 ; *********************************************************************
 ;
 Q
 ;
PROVSPEC(COVER,PROVDR,BUB)   ;EP;For provider class specific CPT, & ICD ranges
 ;Returns 0 if billable, 1 if not billable
 N INRANGE,OUTOFRNG,ISUB,CODE,VGLOB,ICDGLOB,ABME,UNBILLAB,RNGEFLG
 F ISUB=1:1:3 D  Q:$G(UNBILLAB)=0
 .K ABME
 .I $O(^AUTTPIC(COVER,15,PROVDR,ISUB,0)) D
 ..S RNGEFLG=1
 ..S N=0,ABME=0
 ..F  D  Q:CODE=""!($G(UNBILLAB)=0)
 ...I ISUB=1 D  Q       ;This sect for CPT codes
 ....I '$D(AUPNCPT) S Y=$$CPT^AUPNCPT(ABMVDFN)
 ....S CODE=""
 ....F  S N=$O(AUPNCPT(N)) Q:'N  D  Q:UNBILLAB=0
 .....S CODE=+AUPNCPT(N)
 .....D CODECHK
 ....S CODE="" ;MRS:10/16/98 set variable to quit condit'n when finished
 ...I ISUB=2 D          ;This sect and next for ICD codes
 ....S VGLOB="^AUPNVPRC"
 ....S ICDGLOB="^ICD0"
 ...E  D
 ....S VGLOB="^AUPNVPOV"
 ....S ICDGLOB="^ICD9"
 ...I $D(ABME)<10 D
 ....F  S ABME=$O(@VGLOB@("AD",ABMVDFN,ABME)) Q:'ABME  D
 .....S ABME($P(@ICDGLOB@(+(@VGLOB@(ABME,0)),0),U,1))=""
 ...S CODE=""
 ...F  S CODE=$O(ABME(CODE)) Q:CODE=""  D CODECHK Q:$G(UNBILLAB)=0
 I $D(RNGEFLG)=0 D  Q UNBILLAB      ;Means no ranges defined
 .S UNBILLAB=$S(BUB="U":1,1:0)
 I '$D(INRANGE) D           ;MEANS NO CODES IN VISIT
 .I BUB="B" S UNBILLAB=1 Q
 .I BUB="U" S UNBILLAB=0
 .;If there are no codes found in PCC then we mark the provider class
 .;as unbillable if it is only billable for a specific range.
 .;it is billable if only unbillable for a specific range.
 .;This may not work right if PCC does not contain all of the data.
 Q UNBILLAB
 ;
CODECHK ; Check CPT or ICD code against range
 S INRANGE=0,OUTOFRNG=0
 S D2=0
 F  S D2=$O(^AUTTPIC(COVER,15,PROVDR,ISUB,D2)) Q:'D2  D  Q:$G(UNBILLAB)=0
 .S Y=^AUTTPIC(COVER,15,PROVDR,ISUB,D2,0)
 .I '$D(CODE) S UNBILLAB=0 Q
 .S CODLO=+Y
 .S CODHI=$P(Y,U,2)
 .I ISUB>1 D
 ..S CODLO=$P((@ICDGLOB@(CODLO,0)),U,1)
 ..S CODHI=$P((@ICDGLOB@(CODHI,0)),U,1)
 ..I $E(CODLO,1)'?1(1"V",1"E") D
 ...S CODLO=+CODLO
 ...S CODHI=+CODHI
 .I BUB="B" D  Q
 ..I CODLO']]CODE,CODE']]CODHI S UNBILLAB=0
 ..;Check to see if CODE is between CODLO & CODHI
 ..E  S UNBILLAB=1   ;But continue looking
 .I BUB="U",'INRANGE D
 ..I (CODLO]]CODE)!(CODE]]CODHI) S OUTOFRNG=1
 ..E  S INRANGE=1,OUTOFRNG=0
 Q:BUB="B"
 Q:$G(UNBILLAB)=0
 I OUTOFRNG S UNBILLAB=0 Q
 I INRANGE S UNBILLAB=1 Q
 Q
 ;
 ;
 ;At present this code is only executed if ins has cov type entry
PRVX(PRV)          ; EP
 ;Check for default unbillable provider disciplines
 ;Note that if there is no provider class entry for the provider
 ;the provider will be considered unbillable.
 S ABM("PRV")=$$DOCLASS^ABMDVST2(PRV)
 I ABM("PRV")]"",$D(^ABMDPARM(DUZ(2),1,17,ABM("PRV"))) S ABM("PRV")=""
 Q ABM("PRV")
