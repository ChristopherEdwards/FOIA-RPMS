ABMDE3X ; IHS/ASDST/DMJ - Edit Page 3 - ERROR CHK ;
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8**;NOV 12, 2009
 ;
 ; 03/10/04 V2.5 Patch 5 - 837 Modifications - Added errror code 192 for imprecise accident dates
 ; IHS/SD/SDR - v2.5 p5 - 5/17/2004 - Added code to check for error 193
 ; IHS/SD/SDR - v2.5 p6 - 7/16/04 - Modified code for 193; added code for 201 and 202
 ; IHS/SD/SDR - v2.5 p8 - IM15677 - Modified to only display error 193 when export mode is 837
 ; IHS/SD/SDR - v2.5 p8 - IM12246/IM17548 - Added code for 199 and 200
 ; IHS/SD/SDR - v2.5 p9 - IM19291 - Error 215 added for Supervising Provider UPIN
 ; IHS/SD/SDR - v2.5 p9 - IM16729 - Correction ot taxonomy lookup (<SUBSCRIPT>ABMDE3X+29^ABMDE3X
 ; IHS/SD/SDR - v2.5 p9 - IM18516 - Delayed Reason Code
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR -v2.5 p12 - IM23474 - Added warning if clinic is ER and admitting DX is missing
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added warning 238 if both disability dates aren't populated
 ;
 ; Rel of info, Assign of Benefits
 D QUES^ABMDE3:'$D(ABM("QU"))
 I $D(ABM("QU",1)),$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),$P(^(7),U,4)'="Y" S ABME(58)=""
 I $D(ABM("QU",2)),$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),$P(^(7),U,5)'="Y" S ABME(59)=""
 ; Having a date of accident and accident type determine Accident Related
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3) D
 .I +$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2),$E($P(^(8),U,2),6,7)="00" S ABME(192)=""
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,8)'="" D
 .;I ABMP("EXP")=21!(ABMP("EXP")=22)!(ABMP("EXP")=23) D  ;abm*2.6*8 5010
 .I ABMP("EXP")=21!(ABMP("EXP")=22)!(ABMP("EXP")=23)!(ABMP("EXP")=31)!(ABMP("EXP")=32)!(ABMP("EXP")=33) D  ;abm*2.6*8 5010
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,11)'="",(($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,13)="")&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,14)="")&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,15)="")) S ABME(193)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,13)'="" D  ;Person class
 ...I $G(^ABMPTAX("AUSC",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,13)))="" S ABME(201)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,14)'="" D  ;Provider Class
 ...S ABMPTAX=$P($G(^DIC(7,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,14),9999999)),U)
 ...I $G(ABMPTAX)="" S ABME(202)=""
 ...I $G(ABMPTAX),$G(^ABMPTAX("A7",ABMPTAX))="" S ABME(202)=""
 .;I ABMP("EXP")=21!(ABMP("EXP")=22)!(ABMP("EXP")=23)!(ABMP("EXP")=27)!(ABMP("EXP")=28)!(ABMP("EXP")=29) D  ;abm*2.6*8 5010
 .I ABMP("EXP")=21!(ABMP("EXP")=22)!(ABMP("EXP")=23)!(ABMP("EXP")=27)!(ABMP("EXP")=28)!(ABMP("EXP")=29)!(ABMP("EXP")=31)!(ABMP("EXP")=32)!(ABMP("EXP")=33) D  ;abm*2.6*8 5010
 ..S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..I ABMNPIU="N"!(ABMNPIU="B"),$D(ABM("QU",12)),($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,17)="") S ABME(223)=""  ;Ref prv NPI missing
 ..I ABMNPIU="N"!(ABMNPIU="B"),$D(ABM("QU",25)),($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,12)'=""),($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,25)="") S ABME(224)=""  ;sup prv NPI missing
 S ABMLABT=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,0))  ;check for lab charges
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,8)="",(+ABMLABT>0),(ABMP("EXP")=22!(ABMP("EXP")=23)) S ABME(199)=""
 I ($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,22)="")&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,23)="") D
 .I ABMP("EXP")'=3,(ABMP("EXP")'=14),(ABMP("EXP")'=22),(ABMP("EXP")'=23),(ABMP("EXP")'=25) Q
 .I +ABMLABT>0 S ABME(200)=""
 S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 I ABMNPIU'="N",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,12)'=""),($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,24)=""),("^3^14^15^22"[ABMP("EXP")) S ABME(215)=""
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,16)'="" D
 .I $P($G(^ABMDCODE($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,16),0)),U)=11 S ABME(198)=""
 .I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),61,0)) S ABME(214)=""  ;no remarks to go w/delayed reason code
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U)="EMERGENCY MEDICINE",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,9)="") S ABME(230)=""
 ;start new code abm*2.6*6 5010
 S ABMP("DISSTDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,15)
 S ABMP("DISENDDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,16)
 I $G(ABMP("DISSTDT"))'=""&($G(ABMP("DISENDDT"))="") S ABME(238)=""
 I $G(ABMP("DISSTDT"))=""&($G(ABMP("DISENDDT"))'="") S ABME(238)=""
 ;end new code 5010
 ;
XIT Q
ERR D ABMDE3X
 S ABME("TITL")="PAGE 3 - QUESTIONS"
 G XIT
