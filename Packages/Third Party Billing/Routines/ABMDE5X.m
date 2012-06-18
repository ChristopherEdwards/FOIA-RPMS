ABMDE5X ; IHS/ASDST/DMJ - Edit Page 5 - ERROR CHK ;
 ;;2.6;IHS Third Party Billing System;**3,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p13 - POA changes
 ;   Added check for error 231
 ; IHS/SD/SDR - v2.6 CSV
 ;
A ;EP
 S ABME("TITL")="PAGE 5A - DIAGNOSIS"
 S ABMX("PRI")="" F ABMX("I")=0:1 S ABMX("PRI")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMX("PRI"))) Q:ABMX("PRI")=""  S ABMX=$O(^(ABMX("PRI"),"")) D A1
 I 'ABMX("I") S ABME(77)=""
 ;check if Medicare active/pending
 S ABMI=0
 F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMI)) Q:+ABMI=0  D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMI,0)),U)=2&("IP"[$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMI,0)),U,3)) S ABMMCRA=1
 S ABMX("PRI")=""
 F  S ABMX("PRI")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMX("PRI"))) Q:ABMX("PRI")=""  S ABMX=$O(^(ABMX("PRI"),"")) D
 .S ABMX("X0")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABMX,0))
 .I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 ..;Q:(ABMP("EXP")'=28)&(ABMP("EXP")'=21)  ;UB04 and 837I only  ;abm*2.6*8 5010
 ..Q:(ABMP("EXP")'=28)&(ABMP("EXP")'=21)&(ABMP("EXP")'=31)  ;UB04 and 837I only  ;abm*2.6*8 5010
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),U,3)<3071001  ;discharge date prior to 10/1/07; req'd after that
 ..Q:$P(ABMX("X0"),U,5)'=""  ;has POA
 ..;Q:+$G(ABMMCRA)'=1  ;quit if not Medicare  ;abm*2.6*3 HEAT7670
 ..Q:$E($P($G(^ICD9(+ABMX("X0"),0)),U),1)="E"!($E($P($G(^ICD9(+ABMX("X0"),0)),U),1)="V")
 ..I $G(ABME(231))="" S ABME(231)=$P(ABMX("X0"),U,2)
 ..E  S ABME(231)=ABME(231)_","_$P(ABMX("X0"),U,2)
 G XIT
A1 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABMX,0)
 I $P(ABMX("X0"),U,3)="" S ABME(162)=""
 E  I '$D(^AUTNPOV($P(ABMX("X0"),U,3),0)) S ABME(162)=""
 S ABMX(ABMX)=""
 I ABMP("EXP")=31,$P(ABMX("X0"),U,5)=1 S ABME(240)=""  ;abm*2.6*8 5010
 I ABMX("I")'=0 Q
 I $E($P($$DX^ABMCVAPI(+ABMX("X0"),ABMP("VDT")),U,2),1)="V" S ABME(154)=""  ;CSV-c
 I $E($P($$DX^ABMCVAPI(+ABMX("X0"),ABMP("VDT")),U,2),1)="E" S ABME(158)=""  ;CSV-c
 Q
 ;
 ;
B ;EP - Entry Point for checking ICD procedure errors
 I $D(ABMP("PX")),ABMP("PX")'="I" Q
 S ABME("TITL")="PAGE 5B - ICD PROCEDURES"
 S ABMX=0 F  S ABMX=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,ABMX)) Q:'ABMX  D B1
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","O")),'$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,0)) S ABME(3)=""
 G XIT
B1 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),19,ABMX,0)
 I ABMP("INS")]"",$D(^AUTNINS(ABMP("INS"),43,ABMX)) S ABME(157)=""
 I $P(ABMX("X0"),U,3)="" S ABME(125)=""
 I $P(ABMX("X0"),U,4)="" S ABME(124)=""
 E  I '$D(^AUTNPOV($P(ABMX("X0"),U,4),0)) S ABME(124)=""
 I $P(ABMX("X0"),U,3)]"",$P(ABMX("X0"),U,3)<ABMP("VDT") S ABME(127)=""
 I $G(ABMP("DDT")),$P(ABMX("X0"),U,3)]"",$P(ABMX("X0"),U,3)>ABMP("DDT") S ABME(130)=""
 Q
 ;
XIT K ABMX
 Q
