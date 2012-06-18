INHVAX(UIF,ERROR) ;JSH; 21 Jul 92 10:28;Transceiver/Receiver
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;First part is the transceiver
 S SYSTEM="SC" N DIC,DLAYGO
 ;First, get an entry in the DHCP/SAIC-CARE MESSAGE FILE
 S X=$$NOW^UTDT("S"),DIC="^INVA(",DIC(0)="L",DLAYGO=4090 D ^DICN
 I Y<0 S ERROR(1)="Unable to create entry in ^INVA" Q 1
 S INZ=+Y L +^INVA(INZ)
 S $P(^INVA(INZ,0),U,2,3)=SYSTEM_U_0
 S (%,LCT)=0 F  D GETLINE^INHOU(UIF,.LCT,.LINE) Q:'$D(LINE)  D
 . ;copy main line
 . S %=%+1,^INVA(INZ,1,%,0)=LINE
 . ;Copy overflow nodes
 . F I=1:1 Q:'$D(LINE(I))  S ^INVA(INZ,1,%+I,0)=LINE(I)
 . S %=%+I-1,^INVA(INZ,1,%,0)=^INVA(INZ,1,%,0)_$C(13)
 S ^INVA(INZ,1,0)=U_U_%_U_%
 ;Cross-reference the entry
 S DA=INZ,DIK="^INVA(" D IX1^DIK
 ;Unlock and quit
 L -^INVA(INZ) Q 0
 ;
RECEIVE ;Receiver
 S SYSTEM="VA" K CONVERT
LOOP Q:'$D(^INRHB("RUN",INBPN))  S IN=0,^INRHB("RUN",INBPN)=$H
LP1 ;Look for a message using the APS cross reference
 L -^INVA(IN) Q:'$D(^INRHB("RUN",INBPN))  S ^INRHB("RUN",INBPN)=$H
 S IN=$O(^INVA("APS",0,SYSTEM,IN)) I 'IN Q:$D(CONVERT)  G WAIT
 ;Lock the entry
 L +^INVA(IN):0 E  G LP1
 G:$P(^INVA(IN,0),U,3) LP1
 S ING="INDATA" K INDATA
 S (%,%1)=0 F  Q:%=""  S %=$O(^INVA(IN,1,%)) Q:'%  S %1=%1+1,INDATA(%1)=^(%,0) D:INDATA(%1)'[$C(13)  I INDATA(%1)[$C(13) S INDATA(%1)=$TR(INDATA(%1),$C(13))
 . S %2=0 F  S %=$O(^INVA(IN,1,%)) Q:'%  S %2=%2+1,INDATA(%1,%2)=^(%,0) I INDATA(%1,%2)[$C(13) S INDATA(%1,%2)=$TR(INDATA(%1,%2),$C(13)) Q
 I '$D(INDATA(2)) D ENR^INHE(INBPN,"Message format error in DHCP/SAIC message #"_IN) G MP
 I $E(INDATA(2),1,3)="MSA" S DEST="INCOMING ACK",ACK=0 G STORE
 S X=$P(INDATA(2),U,1,2) I $E(X,1,3)'="EVN" D ENR^INHE(INBPN,"DHCP/SAIC message entry #"_IN_" does not have the EVN segment in the correct location.") G MP
 G:'$D(CONVERT) NOCON
 ;If doing conversion ignore those with incorrect event types
 G:$P(X,U,2)'=CONVERT LP1
 I $D(CONVERT(0)),$P($G(INDATA(3)),U)'=CONVERT(0) G LP1
 I $D(CONVERT("C")) S CONVERT("COUNT")=CONVERT("COUNT")+1 Q:CONVERT("COUNT")>CONVERT("C")
 S ACK=0 W "."
NOCON S XX=^INVA(IN,0),A=$P(XX,U,4),A=A+1,$P(^(0),U,4)=A
 I A>5 D ENR^INHE(INBPN,"Too many attempts for entry #"_IN) G MP
 S DEST=$P($T(@$P(X,U,2)),";",3),ACK=1
 I DEST="" D ENR^INHE(INBPN,"No known destination for event type "_$P(X,U,2)_" in DHCP/SAIC message entry #"_IN) G MP
 ;
STORE ;store in UIF
 S MESSID=$P(INDATA(1),U,10) I MESSID="" D ENR^INHE(INBPN,"DHCP/SAIC message entry #"_IN_" does not have a message ID") G MP
 S:$D(CONVERT) MESSID=$P(X,U,2)_MESSID
 ;Call the input driver
 S X=$$NEW^INHD(MESSID,DEST,"DHCP","INDATA",ACK,"I")
 ;If the input driver returns a -1 then the transaction was rejected
 I X<0 D ENR^INHE(INBPN,"DHCP/SAIC message entry #"_IN_" was rejected by GIS") G MP
 ;Update the DATE TRANSFERRED field
 S DIE="^INVA(",DA=IN,DR=".05///NOW" D ^DIE
MP ;Mark as processed, unlock and return to loop
 S DIE="^INVA(",DA=IN,DR=".03///1" D ^DIE L -^INVA(IN) G LP1
 ;
WAIT ;
 H 5 G LOOP
 ;
CONVERT ;Entry to run conversion
 D VAR^DWUTL K CONVERT
 W @IOF D ^UTSRD("Event type to convert: ","Enter the EVENT TYPE of messages to process") Q:X=""!($E(X)="^")  S CONVERT=X
 W ! D ^UTSRD("Value of first segment: ","Enter a value which the first segment must match to be processed.  Use NULL to bypass this check.") Q:$E(X)=U
 S:X]"" CONVERT(0)=X
 W ! D ^UTSRD("Max number of messages to move: ","Enter how many you wish to move.") Q:$E(X)=U  S:X CONVERT("C")=+X
 W ! D ^UTSRD("Starting entry number in INVA: ") Q:$E(X)=U!(+X<0)  S IN=+X S:IN'<1 IN=IN-1
 W ! D ^UTSRD("Number of transfer jobs: ") Q:$E(X)=U  S X=+X S:X<1 X=1 S ITERC=X
 D WAIT^DICD
 S INBPN="CONVERT",^INRHB("RUN",INBPN)="",SYSTEM="VA",CONVERT("COUNT")=0
 F X=1:1:ITERC D
 .S ZTSAVE("*")="",ZTDESC="Transfer messages to GIS",ZTIO="",ZTRTN="LP1^INHVAX" D ^%ZTLOAD
 Q
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
PATALG ;;OUTPATIENT PHARMACY BURST-AL
