INHVATRP(UIF,ERROR) ;JSH; 11 Feb 93 12:34;Transceiver / Receiver
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;First part is the transceiver
 S SYSTEM="SC" N DIC,DLAYGO
 ;First, get an entry in the DHCP/SAIC-CARE MESSAGE FILE
 S X=$$NOW^UTDT("S")
 L +^INVAX(0) S Z=^INVAX(0),INZ=$P(Z,U,3)+1 F INZ=INZ:1 Q:'$D(^INVAX(INZ))
 S ^INVAX(INZ,0)="",$P(Z,U,3,4)=INZ_U_($P(Z,U,4)+1)
 L -^INVAX(0)
 L +^INVAX(INZ)
 S $P(^INVAX(INZ,0),U,2,3)=SYSTEM_U_0
 S (%,LCT)=0 F  D GETLINE^INHOU(UIF,.LCT,.LINE) Q:'$D(LINE)  D
 . ;copy main line
 . S %=%+1,^INVAX(INZ,1,%,0)=LINE
 . ;Copy overflow nodes
 . F I=1:1 Q:'$D(LINE(I))  S ^INVAX(INZ,1,%+I,0)=LINE(I)
 . S %=%+I-1,^INVAX(INZ,1,%,0)=^INVAX(INZ,1,%,0)_$C(13)
 S ^INVAX(INZ,1,0)=U_U_%_U_%
 ;Cross-reference the entry
 S DA=INZ,DIK="^INVAX(" D IX1^DIK
 ;Unlock and quit
 L -^INVAX(INZ) Q 0
 ;
RECEIVE ;Receiver
 S SYSTEM="VA" K CONVERT
LOOP Q:'$D(^INRHB("RUN",INBPN))  S IN=0,^INRHB("RUN",INBPN)=$H
LP1 ;Look for a message using the APS cross reference
 L -^INVAX(IN) Q:'$D(^INRHB("RUN",INBPN))
 S IN=$O(^INVAX("APS",0,SYSTEM,IN)) I 'IN Q:$D(CONVERT)  G WAIT
 ;Lock the entry
 L +^INVAX(IN):0 E  G LP1
 I '$D(^INVAX(IN,0)) K ^INVAX("APS",0,SYSTEM,IN) G LP1
 G:$P(^INVAX(IN,0),U,3) LP1
 S ING="INDATA" K INDATA
 S (%,%1)=0 F  Q:%=""  S %=$O(^INVAX(IN,1,%)) Q:'%  S %1=%1+1,INDATA(%1)=^(%,0) D:INDATA(%1)'[$C(13)  I INDATA(%1)[$C(13) S INDATA(%1)=$TR(INDATA(%1),$C(13))
 . S %2=0 F  S %=$O(^INVAX(IN,1,%)) Q:'%  S %2=%2+1,INDATA(%1,%2)=^(%,0) I INDATA(%1,%2)[$C(13) S INDATA(%1,%2)=$TR(INDATA(%1,%2),$C(13)) Q
 I '$D(INDATA(2)) D ENR^INHE(INBPN,"Message format error in DHCP/SAIC message #"_IN) G MP
 I $E(INDATA(2),1,3)="MSA" S DEST="INCOMING ACK",ACK=0 G STORE
 S X=$P(INDATA(2),U,1,2) I $E(X,1,3)'="EVN" D ENR^INHE(INBPN,"DHCP/SAIC message entry #"_IN_" does not have the EVN segment in the correct location.") G MP
 S XX=^INVAX(IN,0),A=$P(XX,U,4),A=A+1,$P(^(0),U,4)=A
 I A>5 D ENR^INHE(INBPN,"Too many attempts for entry #"_IN) G MP
 S DEST=$P($T(@$P(X,U,2)),";",3),ACK=1
 I DEST="" D ENR^INHE(INBPN,"No known destination for event type "_$P(X,U,2)_" in DHCP/SAIC message entry #"_IN) G MP
 ;
STORE ;store in UIF
 S MESSID=$P(INDATA(1),U,10) I MESSID="" D ENR^INHE(INBPN,"DHCP/SAIC message entry #"_IN_" does not have a message ID") G MP
 ;Call the input driver
 S X=$$NEW^INHD(MESSID,DEST,"DHCP","INDATA",ACK,"I")
 ;If the input driver returns a -1 then the transaction was rejected
 I X<0 D ENR^INHE(INBPN,"DHCP/SAIC message entry #"_IN_" was rejected by GIS") G MP
 ;Update the DATE TRANSFERRED field
 S DIE="^INVAX(",DA=IN,DR=".05///NOW" D ^DIE
MP ;Mark as processed, unlock and return to loop
 S DIE="^INVAX(",DA=IN,DR=".03///1" D ^DIE L -^INVAX(IN) G LP1
 ;
WAIT ;
 H 5 G LOOP
 ;
 ;
DEST ;The following tags are used to determine destination
PATADM ;;PATIENT ID-IN
REGTAX ;;DISABILITY CONDITION CONVERSION
SYSUSR ;;USER/PERSON/PROVIDER CONVERSION
REGTAB ;;INSURANCE CONVERSION
PATREG ;;ADD/UPDATE PATIENT REGISTRATION
PATADT ;;ADT/PTF CONVERSION
OUTPHR ;;OUTPATIENT PHARMACY CONVERSION
PATPHARM ;;PHARMACY PATIENT UPDATE
PATBILL ;;BILLING PATIENT
PATLRG ;;GENERAL LAB RESULTS
PATLRM ;;MICROBIOLOGY RESULTS
PATLRA ;;AP RESULTS
INPHR ;;INPATIENT PHARMACY CONVERSION
