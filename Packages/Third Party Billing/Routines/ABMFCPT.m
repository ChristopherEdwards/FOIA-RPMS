ABMFCPT ; IHS/ASDST/DMJ - FILE CPT CODE ;   
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;
 ; IHS/ASDS/JLG - 01/23/01 - V2.4 Patch 3 - NOIS NEA-0600-18022
 ;    Modified routine to fix problem with provider narrative not 
 ;    showing up.
 ; IHS/ASDS/SDH - 04/26/01 - V2.4 Patch 9 - NOIS DXX-0400-140004
 ;     Allow quantity to pass from PCC to 3PB when the CPT 
 ;     mnuemonic is used.
 ; IHS/ASDS/LSL - 07/03/01 - V2.4 Patch 9 - NOIS NEA-0600-180021
 ;     Modified to allow Pathology, Cytology, and Blood Bank CPT's
 ;     entered through CPT mnuemonic in PCC to pass to 3PB. Thanks
 ;     to Jim Gray for the code.
 ;
 ; IHS/SD/SDR - 11/4/02 - V2.5 P2 - ZZZ-0301-210046
 ;     Modified to capture modifiers from PCC
 ; IHS/SD/SDR - v2.5 p8
 ;    Added code so A0000-A0999 would go to page 8K if ambulance
 ; IHS/SD/SDR - v2.5 p10 - IM21095
 ;   Removed VRAD check for unit; it should always be 1
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 ; *********************************************************************
 ;
START ;FILE ONE CPT CODE
 ;NEEDS ABMCPT (CPT CODE), ABMSDT (SERVICE DATE/TIME),
 ;ABMSRC (DATA SOURCE), AND DA(1) OR ABMP("CDFN")) DEFINED
 ;This is written to work for Anesthesiology, surgery, radiology, lab
 ;Two lines of code were added to the surgery subrtn to add the priority
 ;field.  JLG 4/9/98
 N ABMCTG,DXPTR,ABMCPTIE,ABMUNIT
 S:'$G(ABMP("FEE")) ABMP("FEE")=1
 S:'$G(DA(1)) DA(1)=ABMP("CDFN")
 D
 .;I '+ABMCPT D HCPCS Q
 .I (ABMCPT<100)!(ABMCPT?.5N1.6A.5N)!($L(ABMCPT)=6) D HCPCS Q
 .I +ABMCPT<10000 D ANES Q
 .I +ABMCPT<70000 D SURG Q
 .I +ABMCPT<80000 D RAD Q
 . I +ABMCPT<90000 D LAB Q
 .D MED
 K ABMCPT,ABMSRC,ABMRVN,DIC,DIE,DR,X,Y,ABMUNIT
 Q
ANES ;ANESTHESIA CODE
 N QUIT,VFILE,VIEN
 I ABMCPT>9999 D  Q:QUIT
 .S QUIT=1
 .S VFILE=$P(AUPNCPT(N),U,4)
 .I VFILE'=9000010.08 Q
 .S VIEN=$P(AUPNCPT(N),U,5)
 .S A=$P(^AUPNVPRC(VIEN,0),U,14)
 .I A S QUIT=0 Q   ;Don't quit if anesth admin
 .E  S QUIT=1 Q
 S ABMCTG=39 D EDIT Q:+Y<0
 S:'ABMRVN ABMRVN=370
 S DR=DR_";.02////"_ABMRVN
 ;S DR=DR_";.04////"_$P($G(^ABMDFEE(ABMP("FEE"),23,+ABMCPT,0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S DR=DR_";.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),23,+ABMCPT,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S DR=DR_";.05////"_ABMSDT
 S DR=DR_";.06////"_ABMMOD1
 ;Next line set correspond diagnosis if only 1 POV
 I $D(ABMP("CORRSDIAG")) S DR=DR_";.1////1"
 S DR=DR_";.17////"_ABMSRC
 D ^DIE
 Q
SURG ;SURGICAL CODE
 S ABMCTG=21 D EDIT Q:+Y<0
 S ABMSRGPR=$G(ABMSRGPR)+1
 S:'ABMRVN ABMRVN=960
 N ABMPNARR,ABMINDXP
 S ABMPNARR=$$GET1^DIQ($P(AUPNCPT(N),U,4),ABMDA_",",.04,"I")
 I 'ABMPNARR S ABMPNARR=$P(AUPNCPT(N),U,2)
 S ABMPNARR=$TR(ABMPNARR,";",",")
 S DR=DR_";.02////"_ABMSRGPR
 S DR=DR_";.03////"_ABMRVN
 S DR=DR_";.05////"_ABMSDT
 I ABMPNARR S DR=DR_";.06////"_ABMPNARR
 E  I ABMPNARR]"" S DR=DR_";.06///"_ABMPNARR
 ;S DR=DR_";.07////"_+$P($G(^ABMDFEE(ABMP("FEE"),11,ABMCPT,0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S DR=DR_";.07////"_+$P($$ONE^ABMFEAPI(ABMP("FEE"),11,ABMCPT,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S ABMUNIT=$P($G(^AUPNVCPT(ABMDA,0)),U,16)
 I +ABMUNIT=0 S ABMUNIT=1
 S DR=DR_";.09////"_ABMMOD1
 S DR=DR_";.11////"_ABMMOD2
 S DR=DR_";.13////"_ABMUNIT
 S DR=DR_";.17////"_ABMSRC
 I $D(ABMCORDI(ABMCPT)) D
 .Q:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABMCORDI(ABMCPT),0))
 .S DXPTR=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABMCORDI(ABMCPT),0),U,2)
 .S ABMINDXP=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",""))
 .S DR=DR_";.04////"_(DXPTR-ABMINDXP+1)
 ;Next line set correspond diagnosis if only 1 POV
 E  I $D(ABMP("CORRSDIAG")) S DR=DR_";.04////1"
 D ^DIE
 D ANES
 Q
 ;
RAD ;RADIOLOGY
 S ABMCTG=35 D EDIT Q:+Y<0
 S:'ABMRVN ABMRVN=320
 S DR=DR_";.02////"_ABMRVN
 S ABMUNIT=1
 S DR=DR_";.03////"_ABMUNIT
 ;S DR=DR_";.04////"_$P($G(^ABMDFEE(ABMP("FEE"),15,ABMCPT,0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S DR=DR_";.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),15,ABMCPT,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S DR=DR_";.05////"_ABMMOD1
 S DR=DR_";.06////"_ABMMOD2
 ;Next line set correspond diagnosis if only 1 POV
 I $D(ABMP("CORRSDIAG")) S DR=DR_";.08////1"
 S DR=DR_";.09////"_ABMSDT
 S DR=DR_";.17////"_ABMSRC
 D ^DIE
 Q
 ;
MED ;MEDICAL CODE
 S ABMCTG=27 D EDIT Q:+Y<0
 S:'ABMRVN ABMRVN=510
 S DR=DR_";.02////"_ABMRVN
 S ABMUNIT=$P($G(^AUPNVCPT(ABMDA,0)),U,16)
 I +ABMUNIT=0 S ABMUNIT=1
 S DR=DR_";.03////"_ABMUNIT
 ;S DR=DR_";.04////"_$P($G(^ABMDFEE(ABMP("FEE"),19,ABMCPT,0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S DR=DR_";.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),19,ABMCPT,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S DR=DR_";.05////"_ABMMOD1
 S DR=DR_";.08////"_ABMMOD2
 ;Next line set correspond diagnosis if only 1 POV
 I $D(ABMP("CORRSDIAG")) S DR=DR_";.06////1"
 S DR=DR_";.07////"_ABMSDT
 S DR=DR_";.17////"_ABMSRC
 D ^DIE
 Q
 ;
HCPCS ;HCPCS CODE
 S XTLKUT=""
 S ABMCTG=$S(ABMCPT]]"A0000"&(ABMCPT']]"A0999"):47,1:43) D EDIT Q:+Y<0
 I ABMRVN="" D
 .I $E(ABMCPT,1,2)="A0" S ABMRVN=540 Q
 .I $E(ABMCPT)="E" S ABMRVN=290 Q
 .I $E(ABMCPT)="J" S ABMRVN=250 Q
 .I $E(ABMCPT)="K" S ABMRVN=290 Q
 .I $E(ABMCPT,1,3)="L86" S ABMRVN=274 Q
 .I $E(ABMCPT,1,2)="P9" S ABMRVN=300 Q
 .S ABMRVN=270
 S DR=DR_";.02////"_ABMRVN
 S ABMUNIT=$P($G(^AUPNVCPT(ABMDA,0)),U,16)
 I +ABMUNIT=0 S ABMUNIT=1
 S DR=DR_";.03////"_ABMUNIT
 ;S DR=DR_";.04////"_$P($G(^ABMDFEE(ABMP("FEE"),13,ABMCPTIE,0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S DR=DR_";.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),13,ABMCPTIE,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S DR=DR_";.05////"_ABMMOD1
 ;Next line set correspond diagnosis if only 1 POV
 I $D(ABMP("CORRSDIAG")) S DR=DR_";.06////1"
 S DR=DR_";.07////"_ABMSDT
 S DR=DR_";.08////"_ABMMOD2
 S DR=DR_";.17////"_ABMSRC
 D ^DIE
 K XTLKUT
 Q
 ;
LAB ;     
 I '$D(ABMCPTTB("LAB")) D
 .S ABMIEN=0
 .F I=1:1 S ABMIEN=$O(^ABMDCPT("C","LAB",ABMIEN)) Q:'ABMIEN  D
 ..S ABMCPTTB("LAB",I)=$P(^ABMDCPT(ABMIEN,0),U,4,5)
 S ABMOK=0
 S I=0
 F  S I=$O(ABMCPTTB("LAB",I)) Q:'I  D  Q:ABMOK
 .I ABMCPT'<$P(ABMCPTTB("LAB",I),U)&(ABMCPT'>$P(ABMCPTTB("LAB",I),U,2)) S ABMOK=1
 Q:'ABMOK
 S ABMFILE=$P(AUPNCPT(N),U,4)
 S ABMIENS=ABMDA_","
 I ABMFILE=9000010.18 D
 .S ABMFLD1=.08
 .S ABMFLD2=.09
 E  I ABMFILE=9000010.08 D
 .S ABMFLD1=.17
 .S ABMFLD2=.18
 E  I ABMFILE=9000010.22 D
 .S ABMFLD1=.07
 .S ABMFLD2=.08
 E  K ABMFLD1,ABMFLD2
 S ABMMOD(1)=$$GET1^DIQ(ABMFILE,ABMIENS,ABMFLD1)
 I ABMMOD(1)]"" S ABMMOD(2)=$$GET1^DIQ(ABMFILE,ABMIENS,ABMFLD2)
 E  K ABMMOD(1)
 I ABMFILE=9000010.18 S ABMUNITS=$$GET1^DIQ(ABMFILE,ABMIENS,.16)
 E  S ABMUNITS=1
 S:ABMUNITS<1 ABMUNITS=1
 S ABMCOLDT=$$GET1^DIQ(ABMFILE,ABMIENS,1201,"I")
 S:ABMCOLDT<2000101 ABMCOLDT=ABMCHVDT
 S ABMREVCD=$P($$IHSCPT^ABMCVAPI(ABMCPT,ABMP("VDT")),U,3)  ;CSV-c
 I 'ABMREVCD D
 .N ABMCPTCT
 .S ABMCPTCT=$P($$CPT^ABMCVAPI(ABMCPT,ABMP("VDT")),U,4)  ;CSV-c
 .Q:'ABMCPTCT
 .S ABMREVCD=$P($$IHSCAT^ABMCVAPI(ABMCPTCT,ABMP("VDT")),U)  ;CSV-c
 S:'ABMREVCD ABMREVCD=300
 ;S FEE=$P($G(^ABMDFEE(+ABMP("FEE"),17,ABMCPT,0)),U,2)  ;abm*2.6*2 3PMS10003A
 S FEE=$P($$ONE^ABMFEAPI(+ABMP("FEE"),17,ABMCPT,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 K DIC,DD,DO
 S X=ABMCPT
 S DIC="^ABMDCLM("_DUZ(2)_","_ABMP("CDFN")_",37,"
 S DIC("DR")=".02////"_ABMREVCD
 S DIC("DR")=DIC("DR")_";.03////"_ABMUNITS
 S DIC("DR")=DIC("DR")_";.04////"_FEE
 S DIC("DR")=DIC("DR")_";.05////"_ABMCOLDT
 S DIC("DR")=DIC("DR")_";.06////"_ABMMOD1
 S DIC("DR")=DIC("DR")_";.07////"_ABMMOD2
 S DIC("DR")=DIC("DR")_";.17////"_ABMSRC
 I $D(ABMP("CORRSDIAG")) S DIC("DR")=DIC("DR")_";.09////1"
 I $D(ABMMOD) F J=1:1:2 Q:'$D(ABMMOD(J))  D
 .S DIC("DR")=DIC("DR")_";"_((5+J)/100)_"////"_ABMMOD(J)
 S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),"ASRC",ABMSRC,0))
 I DA,'$D(@(DIC_DA_",0)")) S DA=""    ;For duplicates problem
 S DA(1)=ABMP("CDFN")
 I DA>0 D
 .K DR
 .S DIE=DIC
 .S DR=".01///"_X_";"_DIC("DR")
 .D ^DIE
 E  D
 .S DIC(0)="LE"
 .S DIC("P")=$P(^DD(9002274.3,37,0),U,2)
 .K DD,DO
 .K DD,DO D FILE^DICN
 Q
EDIT ;EDIT EXISTING ENTRY
 N ABM1,ABMY,P
 K DIC,DIE
 S (DIC,DIE)="^ABMDCLM(DUZ(2),DA(1),ABMCTG,"
 S ABMCPTIE=$O(^ICPT("B",ABMCPT,0))
 S ABMRVN=$P($$IHSCPT^ABMCVAPI(+ABMCPTIE,ABMP("VDT")),U,3)  ;CSV-c
 S DA=$O(^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC,0))
 I DA,'$D(@(DIC_DA_",0)")) S DA=""          ;For duplicates problem 
 N XREF
 I DA,(ABMCTG=21)!(ABMCTG=39) D
 .S XREF="ASRC"_$S(ABMCTG=21:"S",1:"A")
 .I $D(^ABMDCLM(DUZ(2),DA(1),ABMCTG,XREF,ABMSRC,DA)) Q
 .S DA=""
 I DA="" D
 .S ABM1=0
 .F  S ABM1=$O(^ABMDCLM(DUZ(2),DA(1),ABMCTG,ABM1)) Q:'ABM1  D  Q:DA]""
 ..;If this finds an old entry with no source field
 ..;   and it matches DA is set and new record not created.
 ..;   and no match a new entry is created and DA defined
 ..;If no old entry a new record is created and DA defined
 ..;If all old entries have source field new record created & DA defined
 ..S ABMY=$G(^ABMDCLM(DUZ(2),DA(1),ABMCTG,ABM1,0))
 ..Q:$P(ABMY,U,17)]""
 ..S P=$S(ABMCTG=21!(ABMCTG=39):5,ABMCTG=35:9,1:7)
 ..I ABMCPTIE=+ABMY,ABMSDT=$P(ABMY,U,P) S DA=ABM1 Q
 .Q:DA]""
 .I (ABMCTG=21)!(ABMCTG=39) D  Q:DA]""
 ..S XREF="ASRC"_$S(ABMCTG=21:"S",1:"A")
 ..S DA=$O(^ABMDCLM(DUZ(2),DA(1),ABMCTG,XREF,ABMSRC,DA))
 .D ADD
 S Y=$G(Y)
 S DR=".01////"_ABMCPTIE
 Q
 ;
ADD ;SET ZERO NODE AND DIC
 S:'$D(^ABMDCLM(DUZ(2),DA(1),ABMCTG,0)) ^(0)="^9002274.30"_ABMCTG_"P^^"
 S X=ABMCPTIE
 S DIC(0)="LXE"
 K DD,DO,DINUM D FILE^DICN
 S DA=+Y
 Q
