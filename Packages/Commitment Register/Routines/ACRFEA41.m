ACRFEA41 ;IHS/OIRM/DSD/THL,AEF - EDIT FINANCIAL DATA;  [ 02/02/2005  10:23 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**16**;NOV 05, 2001
 ;;ACRFEA4 CON'T
EDIT ;EP;
 Q:$D(ACROUT)
 F  D E1 Q:$D(ACRQUIT)!$D(ACROUT)
 K ACRQUIT,ACRE1,ACRE2,ACRE
 D EXCEED^ACRFWARN,SYNC^ACRFCIS
 Q
E1 D E1^ACRFEA4D
 D RESP^ACRFEA4
 ;S DIR("A")="     Which one(s)",DIR(0)="LO^1:"_ACREND K ACREND  ;ACR*2.1*16.07 IM10095
 S DIR("A")="     Which one(s)"                                  ;ACR*2.1*16.07 IM10095
 S DIR(0)="LO^1:"_$G(ACREND)                                     ;ACR*2.1*16.07 IM10095
 K ACREND                                                        ;ACR*2.1*16.07 IM10095
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)!(+Y<1)
 S ACRE2=Y
 N ACRE3
 F ACRE3=1:1 S ACRE1=$P(ACRE2,",",ACRE3) Q:ACRE1=""  D  Q:$D(ACROUT)
 .I ACRREFX=130 S ACRE1=$S(ACRE1=1:1,ACRE1=2:3,ACRE1=3:14,ACRE1=4:4,ACRE1=5:25,ACRE1=6:5,ACRE1=7:6,ACRE1=8:11,ACRE1=9:19,ACRE1=10:21,ACRE1=11:15,1:1)
 .I ACRREFX=148 S ACRE1=$S(ACRE1=1:1,ACRE1=2:2,ACRE1=3:3,ACRE1=4:4,ACRE1=5:5,ACRE1=6:6,ACRE1=7:11,ACRE1=8:21,ACRE1=9:26,ACRE1=10:$S($$ACSREQ^ACRFTO(ACRDOCDA)'=1:15,1:28),ACRE1=11:15,1:1)
 .I ACRREFX=600 S ACRE1=$S(ACRE1=1:4,ACRE1=2:25,ACRE1=3:5,ACRE1=4:6,ACRE1=5:11,ACRE1=6:14,ACRE1=7:21,ACRE1=8:24,ACRE1=9:15,1:4)
 .I ACRREFX=103!(ACRREFX=349)!(ACRREFX=326) D
 ..I ACRE1=1 Q
 ..I ACRE1=2 S ACRE1=99 Q
 ..I ACRE1=3 S ACRE1=4 Q
 ..I ACRE1=4 S ACRE1=5 Q
 ..I ACRE1=5 S ACRE1=6 Q
 ..I ACRE1=6 S ACRE1=7 Q
 ..I ACRE1=7 S ACRE1=8 Q
 ..I ACRE1=8 S ACRE1=11 Q
 ..I ACRE1=9 S ACRE1=12 Q
 ..I ACRE1=10 S ACRE1=3 Q
 ..I ACRE1=11 S ACRE1=13 Q
 ..I ACRE1=12 S ACRE1=16 Q
 ..I ACRE1=13 S ACRE1=17 Q
 ..I ACRE1=14 S ACRE1=20 Q
 ..I ACRE1=15 S ACRE1=23 Q
 ..I ACRE1=16 S ACRE1=22 Q
 ..I ACRE1=17 S ACRE1=27 Q
 ..I ACRE1=18 S ACRE1=$S($G(ACRPOT)>2500:18,1:15) Q
 ..I ACRE1=19 S ACRE1=15
 .I ACRREFX=116 D
 ..S:ACRE1=14 ACRE1=15
 ..S:ACRE1=13&($G(ACRPOT)'>2500) ACRE1=15
 ..S:ACRE1=13&($G(ACRPOT)>2500) ACRE1=18
 ..S:ACRE1=12 ACRE1=21
 ..S:ACRE1=11 ACRE1=20
 ..S:ACRE1=10 ACRE1=11
 .S ACRE1=+ACRE1
 .D @ACRE1 K ACRQUIT
 Q
1 I ACRREF=103,$E($P($G(ACRDOC0),U,2),9,10)'="BP" D
 .D CC^ACRFEA43
 .I $P(^ACRDOC(ACRDOCDA,0),U,4)=35 D
 ..S DA=ACRDOCDA
 ..S DIE="^ACRDOC("
 ..S DR=".13///116"
 ..D DIE^ACRFDIC
 ..S DA=ACRDOCDA
 ..S DIE="^ACROBL("
 ..S DR=".1///116"
 ..D DIE^ACRFDIC
 ..S (ACRREF,ACRREFX)=116
 ..D SETDOC^ACRFEA1
 I ACRREF=349!(ACRREF=326) D
 .S DA=ACRDOCDA
 .S DIE="^ACRDOC("
 .S DR=".24T"
 .W !
 .D DIE^ACRFDIC
 F  D ACRDIE^ACRFEA2 Q:$D(ACRQUIT)!$D(ACROUT)!$D(ACRREV)!$D(ACROUT)
 Q:ACRREF'=116&(ACRREF'=103)&(ACRREF'=349)&(ACRREF'=326)&(ACRREF'=210)&(ACRREF'=148)
 D ^ACRFEA43
 Q
2 I $P(^ACRDOC(ACRDOCDA,0),U,19) D  Q
 .W !!,"The VENDOR is determined by the original BPA and cannot be changed."
 .D PAUSE^ACRFWARN
 .K ACRQUIT
 D RV1^ACRFEA42
 Q
3 D NJ^ACRFEA42
 Q
4 D ^ACRFSS
 Q
5 ;WHEN CREDIT CARD PURCHASE BEING SENT FOR APPROVAL BY PURCHASING AGENT
 ;SWITCH DOCUMENT IDENTITY BACK TO PURCHASE ORDER SO PURCHASING OFFICER
 ;APPROVAL SEQUENCE IS SELECTED
 K ACRSWTCH
 I ACRREF=116,$P($G(^ACROBL(ACRDOCDA,"APV")),U)="A",$P(^ACRDOC(ACRDOCDA,0),U,4)=35!($P(^(0),U,12)) D
 .S (ACRREF,ACRREFX)=103
 .S $P(ACRDOC0,U,13)=$O(^AUTTDOCR("B",103,0))
 .S ACRSWTCH=""
 I '$D(ACRPRCS),'$D(ACRREV),$D(^ACRSS("C",ACRDOCDA))!$D(^ACRSS("J",ACRDOCDA)) D APPROVE^ACRFEA21 I 1
 E  I '$D(ACRPRCS),'$D(ACRREV) D
 .W !!,"Financial summary data missing for this request."
 .W !,"Please ensure that the entire process is completed under 'Add/Edit'."
 .D PAUSE^ACRFWARN
 I $D(ACRSWTCH) S (ACRREF,ACRREFX)=116,$P(ACRDOC0,U,13)=$O(^AUTTDOCR("B",116,0)) K ACRSWTCH
 Q
6 W !
 D PR^ACRFEA42
 Q
7 W !
 D QD^ACRFEA42
 Q
8 W !
 D BP^ACRFEA42
 Q
9 W !
 D ATTACH^ACRFEA42
 Q
11 W !
 D RS^ACRFEA42
 Q
12 W !
 D ACCEPT^ACRFPO1
 Q
13 W !
 D ^ACRFVEND
 Q
14 ;EP;
 W !
 D DESTIN^ACRFSS43
 Q
15 W !
 D RESP^ACRFRESP
 Q
16 W !
 D DOCSTAT^ACRFEA42
 Q
17 W !
 D ATTACH^ACRFPRC2
 Q
18 W !
 D ZIS^ACRFPCC
 Q
19 D EN2^ACRFSS3
 Q
20 D EN^ACRFSHIP
 Q
21 D CANYO1^ACRFDEL
 Q
22 Q
23 D ^ACRFPQT
 Q
24 D TREPORT^ACRFTO
 Q
25 D ^ACRFSS5
 Q
26 D YES^ACRFTPAR
 Q
27 D CHKLIST^ACRFPO3
 Q
28 D ACS^ACRFTO
 Q
99 D ^ACRFCIS
 Q