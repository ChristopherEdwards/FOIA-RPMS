ABMDE9X ; IHS/ASDST/DMJ - Page 9 - ERROR CHECKS ;
 ;;2.6;IHS Third Party Billing;**1,6**;NOV 12, 2009
 ;
 ; 12/19/03 V2.5 Patch 5 - 837 modifications
 ;     Add 192 error code for imprecise accident dates
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6439 - Added page 9G
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added error 237
 ;
A ;EP - for 9A error checks
 S:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,4) ABMX("ACCHR")=0 S ABMX=0 F  S ABMX=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),51,ABMX)) Q:'ABMX  D A1
 S ABME("TITL")="PAGE 9A - OCCURRENCE CODES"
 I $D(ABMX("ACCHR")),ABMX("ACCHR")=0 S ABME(155)=""
 ; Having a date of accident and accident type determine Accident Related
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3)="Y" D
 .I +$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2),$E($P(^(8),U,2),6,7)="00" S ABME(192)=""
 K ABMX("ACCHR")
 G XIT
A1 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),51,ABMX,0)
 I $D(ABMX("ACCHR")),(+ABMX("X0")>0&(+ABMX("X0")<7)) S ABMX("ACCHR")=1
 I $P(ABMX("X0"),U,2)="" S ABME(138)=""
 I $D(ABMP("DDT")),$P(ABMX("X0"),U,2)]"",($P(ABMX("X0"),U,2)\1)>ABMP("DDT") S ABME(130)=""
BTYP ;BILL TYPE CONSISTENCY CHECK
 S ABMX("CODE")=$P(^ABMDCODE(+ABMX("X0"),0),U) D
 .Q:"20,21,22,26,27,28,34,42"'[ABMX("CODE")
 .I ABMX("CODE")=20,"11,41"[$E(ABMP("BTYP"),1,2) Q
 .I ABMX("CODE")=21,"18,21"[$E(ABMP("BTYP"),1,2) Q
 .I ABMX("CODE")=22,"18,21"[$E(ABMP("BTYP"),1,2) Q
 .I ABMX("CODE")=26,"18,21"[$E(ABMP("BTYP"),1,2) Q
 .I ABMX("CODE")=27,"32,33"[$E(ABMP("BTYP"),1,2) Q
 .I ABMX("CODE")=28,"74,75"[$E(ABMP("BTYP"),1,2) Q
 .I ABMX("CODE")=34,$E(ABMP("BTYP"),1,2)=51 Q
 .I ABMX("CODE")=42,"811,814,821,824"[ABMP("BTYP") Q
 .S ABME(177)=""
 Q
 ;
B ;EP - for 9B error checks
 S ABMX=0 F  S ABMX=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),57,ABMX)) Q:'ABMX  D B1
 S ABME("TITL")="PAGE 9B - OCCURRENCE SPAN CODES"
 G XIT
B1 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),57,ABMX,0)
 I $P(ABMX("X0"),U,2)="" S ABME(139)=""
 I $P(ABMX("X0"),U,3)="" S ABME(139)=""
 I $D(ABMP("DDT")),$P(ABMX("X0"),U,2)]"",($P(ABMX("X0"),U,2)\1)>ABMP("DDT") S ABME(130)=""
 I $D(ABMP("DDT")),$P(ABMX("X0"),U,3)]"",($P(ABMX("X0"),U,3)\1)>ABMP("DDT") S ABME(130)=""
 I $P(ABMX("X0"),U,2)>$P(ABMX("X0"),U,3) S ABME(140)=""
 Q
 ;
C ;EP - for 9C error checks
 I ABMP("BTYP")=111,$P($G(^AUTNINS(+ABMP("INS"),2)),U)="R" D
 .K ABMX("OK")
 .S ABMX=0 F  S ABMX=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),53,ABMX)) Q:'ABMX  D
 ..Q:$G(ABMX("OK"))
 ..S ABMX("CODE")=$P($G(^ABMDCODE(+ABMX,0)),U)
 ..Q:$E(ABMX("CODE"),1)'="C"
 ..S ABMX("OK")=1
 .I '$G(ABMX("OK")) S ABME(178)=""
 S ABME("TITL")="PAGE 9C - CONDITION CODES"
 G XIT
 ;
D ;EP - for 9D error checks
 S ABMX=0 F  S ABMX=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),55,ABMX)) Q:'ABMX  D D1
 S ABME("TITL")="PAGE 9D - VALUE CODES"
 G XIT
D1 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),55,ABMX,0)
 I $P(ABMX("X0"),U,2)="" S ABME(141)=""
 Q
 ;
E ;EP - for 9E error checks
 ;start new code abm*2.6*6 5010
 I $G(ABMP("EXP"))=32 D
 .S ABMX=0
 .F  S ABMX=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,ABMX)) Q:'ABMX  D
 ..S ABMCODE=$P($G(^ABMDCODE(ABMX,0)),U)
 ..I "^02^03^05^09^"'[("^"_ABMCODE_"^") S ABME(237)=""
 ;end new code 5010
 Q
 ;
F ;EP - for 9F error checks
 Q
 ;start new code abm*2.6*1 HEAT6439
G ;EP - for 9G error checks
 Q
 ;end new code HEAT6439
 ;
XIT K ABMX
 Q
