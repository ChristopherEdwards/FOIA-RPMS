ACRFDAP ;IHS/OIRM/DSD/THL,AEF - SET DISPLAY OF APPROVALS; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;ROUTINE TO CHECK IF EACH TYPE OF APPROBAL HAS BEEN COMPLETED,
 ;;DISPLAYS '#' DURING DOCUMENT EDITING IS APPROVAL COMPLETED
EN ;EP
 N ACRY
 F ACRX=1:1:4,12:1:14,16,26,"AU","FA" D
 .S ACR=$T(@ACRX)
 .S ACR=$P(ACR,";;",2)
 .S ACR(ACRX)=ACR
 I $D(^ACRDOC(D0,"FA")) D
 .S ACRX("FA")=$P(^ACRDOC(D0,"FA"),U)
 .S ACRI="FA"
 .D:ACRX("FA") D1
 I $D(^ACRDOC(D0,"AU")) D
 .S ACRX("AU")=$P(^ACRDOC(D0,"AU"),U)
 .S ACRI="AU"
 .D:ACRX("AU") D1
 I $D(^ACRDOC(D0,"REQ")) F ACRI=12:1:14 D
 .S ACRX(ACRI)=$P(^ACRDOC(D0,"REQ"),U,ACRI)
 .D:ACRX(ACRI) D1
 Q
D1 ;CHECK APPROVALS FOR COMPLETION
 S ACRY=0
 F  S ACRY=$O(^ACRAPVS("AC",D0,ACRX(ACRI),ACRY)) Q:'ACRY  D
 .I $D(^ACRAPVS(ACRY,"DT")),$P(^ACRAPVS(ACRY,0),U,3)=ACR(ACRI),$P(^ACRAPVS(ACRY,"DT"),U)]"" D
 ..S ACRX(ACRI,1)=$P(^ACRAPVS(ACRY,"DT"),U)
 Q
DATA ;;
AU ;;1
FA ;;2
12 ;;3
13 ;;4
14 ;;5
16 ;;8
26 ;;9
1 ;;10
2 ;;11
3 ;;12
4 ;;13
