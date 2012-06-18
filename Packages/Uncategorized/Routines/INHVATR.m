INHVATR(UIF,ERROR) ;JSH; 7 Aug 92 05:52;Transceiver/Receiver
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;First part is the transceiver
 ;First, get an entry in the SAIC-CARE MESSAGE FILE
 L +^INVAS(0) S Z=^INVAS(0),INZ=$P(Z,U,3)+1 F INZ=INZ:1 Q:'$D(^INVAS(INZ))
 S ^INVAS(INZ,0)="",$P(Z,U,3,4)=INZ_U_($P(Z,U,4)+1),^INVAS(0)=Z
 L -^INVAS(0) L +^INVAS(INZ)
 S $P(^INVAS(INZ,0),U,1,3)=$$NOW^UTDT("S")_U_U_0
 S (%,LCT)=0 F  D GETLINE^INHOU(UIF,.LCT,.LINE) Q:'$D(LINE)  D
 . ;copy main line
 . S %=%+1,^INVAS(INZ,1,%,0)=LINE
 . ;Copy overflow nodes
 . F I=1:1 Q:'$D(LINE(I))  S ^INVAS(INZ,1,%+I,0)=LINE(I)
 . S %=%+I-1,^INVAS(INZ,1,%,0)=^INVAS(INZ,1,%,0)_$C(13)
 S ^INVAS(INZ,1,0)=U_U_%_U_%
 ;Cross-reference the entry
 S DA=INZ,DIK="^INVAS(" D IX1^DIK
 ;Unlock and quit
 L -^INVAS(INZ) Q 0
 ;
VERIFY ;Verify transmission global processing
 I '$D(IOF) S IOP="" D ^%ZIS
 W @IOF
 N I,Y,%
 S (I,%)=0
 F  S I=$O(^INVAS("AP",0,I)) Q:'I  I $D(^INVAS(I,0)) S %=%+1 I %=1 S Y=+^(0) X ^DD("DD")
 W !,"There "_$P("is ^are ",U,%'=1+1)_%_" message"_$E("s",%'=1)_" from SAIC-Care to DHCP not yet received." W:% !?5,"Oldest was transmitted "_Y
 S (I,%)=0 W !
 F  S I=$O(^INVAX("AP",0,I)) Q:'I  I $D(^INVAX(I,0)) S %=%+1 I %=1 S Y=+^(0) X ^DD("DD")
 W !,"There "_$P("is ^are ",U,%'=1+1)_%_" message"_$E("s",%'=1)_" from DHCP to SAIC-Care not yet received." W:% !?5,"Oldest was transmitted "_Y
 Q
 ;
RECEIVE ;Receiver
 ;
LOOP Q:'$D(^INRHB("RUN",INBPN))  S IN=0
LP1 ;Look for a message using the AP cross reference
 L -^INVAX(IN) Q:'$D(^INRHB("RUN",INBPN))  S ^INRHB("RUN",INBPN)=$H
 S IN=$O(^INVAX("AP",0,IN)) G:'IN WAIT
 ;Lock the entry
 L +^INVAX(IN):0 E  G LP1
 I '$D(^INVAX(IN,0)) K ^INVAX("AP",0,IN) G LP1
 I $P(^INVAX(IN,0),U,3) K ^INVAX("AP",0,IN) G LP1
 S ING="INDATA" K INDATA
 S (%,%1)=0 F  Q:%=""  S %=$O(^INVAX(IN,1,%)) Q:'%  S %1=%1+1,INDATA(%1)=^(%,0) D:INDATA(%1)'[$C(13)  I INDATA(%1)[$C(13) S INDATA(%1)=$TR(INDATA(%1),$C(13))
 . S %2=0 F  S %=$O(^INVAX(IN,1,%)) Q:'%  S %2=%2+1,INDATA(%1,%2)=^(%,0) I INDATA(%1,%2)[$C(13) S INDATA(%1,%2)=$TR(INDATA(%1,%2),$C(13)) Q
 I '$D(INDATA(2)) D ENR^INHE(INBPN,"Message format error in DHCP message #"_IN) G MP
 I $E(INDATA(2),1,3)="MSA" S DEST="INCOMING ACK",ACK=0 G STORE
 S X=$P(INDATA(2),U,1,2) I $E(X,1,3)'="EVN" D ENR^INHE(INBPN,"DHCP message entry #"_IN_" does not have the EVN segment in the correct location.") G MP
 S XX=^INVAX(IN,0),A=$P(XX,U,4),A=A+1,$P(^(0),U,4)=A
 I A>5 D ENR^INHE(INBPN,"Too many attempts for entry #"_IN) G MP
 S DEST=$P($T(@$P(X,U,2)),";",3),ACK=1
 I DEST="" D ENR^INHE(INBPN,"No known destination for event type "_$P(X,U,2)_" in DHCP message entry #"_IN) G MP
 ;
STORE ;store in UIF
 S MESSID=$P(INDATA(1),U,10) I MESSID="" D ENR^INHE(INBPN,"DHCP message entry #"_IN_" does not have a message ID") G MP
 ;Call the input driver
 S X=$$NEW^INHD(MESSID,DEST,"DHCP","INDATA",ACK,"I")
 ;If the input driver returns a -1 then the transaction was rejected
 I X<0 D ENR^INHE(INBPN,"DHCP message entry #"_IN_" was rejected by GIS") G MP
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
