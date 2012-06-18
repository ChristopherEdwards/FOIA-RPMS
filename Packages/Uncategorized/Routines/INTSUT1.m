INTSUT1 ;JPD; 6 May 98 09:20; Utility routine 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
SETSCR(INDA,DIE,INVAL,INREV,DWSFLD) ;initialize fields in second windowman
 ;screen called from post action of field 20 and field 18.03 in windowman
 ; gallery
 ;Input:
 ;  INDA - ien of 4001.1
 ;   DIE - 4001.1
 ; INVAL - field number from 4001.1 of background process
 ; INREV - 1 - Reverse from client to server or server to client
 ;         0 - Don't reverse
 ;Output:
 ; DWSFLD - Windowman values
 ;
 N INBPN,I,IN0,IN1,INIP
 ;clear out values of Test Parameters
 F I=16.01,16.02,16.03,16.05,16.06,16.07,16.08,16.09,16.1,16.11,16.12,17.01,17.02,23.01 S DWSFLD(I)="@"
 ;unsolicited inbound set transaction type or Query response
 I ($$VAL^DWRA(4001.1,6,0,DIE,INDA)="I"&($$VAL^DWRA(4001.1,"13.02",0,DIE,INDA)="U"))!($$VAL^DWRA(4001.1,"13.02",0,DIE,INDA)="Q") S DWSFLD(13.01)="HL GIS ACCEPT ACKNOWLEDGEMENT"
 S INVAL=+$G(INVAL)
 ;set background process
 S INBPN=+$$VAL^DWRA(4001.1,INVAL,0,DIE,INDA)
 ;Default read, hang and transmit retries
 D INIT^INHUVUT(INBPN,.INIP)
 ;
 ;Open Hang Open retries
 S DWSFLD(16.03)=INIP("OHNG"),DWSFLD(16.04)=INIP("OTRY")
 ;Transmitter Hang
 S DWSFLD(16.05)=INIP("THNG")
 ;Send Hang, Send retry, Send Timeout
 S DWSFLD(16.06)=INIP("SHNG"),DWSFLD(16.07)=INIP("STRY"),DWSFLD(16.08)=INIP("STO")
 ;Read hand, Read Retry, Read Tiemout
 S DWSFLD(16.09)=INIP("RHNG"),DWSFLD(16.1)=INIP("RTRY"),DWSFLD(16.11)=INIP("RTO")
 S IN0=$G(^INTHPC(INBPN,0)),IN1=$G(^INTHPC(INBPN,1))
 ;Set Client/Server Flag
 S DWSFLD(13.03)=$P(IN0,U,8)
 I INREV,DWSFLD(13.03)'="" S DWSFLD(13.03)='DWSFLD(13.03)
 ;
 ;if remote is client set to server
 I INREV,DWSFLD(13.03)=1 D
 .;Set server port by getting clients IP port
 .S I=0 F  S I=$O(^INTHPC(INBPN,6,I)) Q:'I  D  Q:DWSFLD(16.02)
 ..S J=0 F  S J=$O(^INTHPC(INBPN,6,I,1,J)) Q:'J  D
 ...S DWSFLD(16.02)=$G(^INTHPC(INBPN,6,I,1,J,0))
 ;
 ;If remote is server and current type not Query response
 I INREV,DWSFLD(13.03)=0,$$VAL^DWRA(4001.1,"13.02",0,DIE,INDA)'="Q" D
 .;set client address
 .S DWSFLD(16.01)="127.0.0.1"
 .;set client port
 .S I=$O(^INTHPC(INBPN,5,0))
 .S DWSFLD(16.02)=$G(^INTHPC(INBPN,5,+I,0))
 ;If query response and current BP is a server set to same port
 I $$VAL^DWRA(4001.1,"13.02",0,DIE,INDA)="Q",DWSFLD(13.03)=1 D
 .S I=$O(^INTHPC(INBPN,5,0))
 .S DWSFLD(16.02)=$G(^INTHPC(INBPN,5,+I,0))
 ;End of Line
 S DWSFLD(16.12)=$P(IN1,U,7)
 ;Client Init String
 S DWSFLD(17.01)=$P(IN1,U,8)
 ;Init Response
 S DWSFLD(17.02)=$P(IN1,U,9)
 S (DWSFLD(17.03,0),DWSFLD(18.01,0),DWSFLD(18.02,0))=2
 Q
SCR2(DWSFLD) ;second screen pre check
 ;Input:
 ; DWSFLD - Windowman array
 ;
 I $$VAL^DWRA("4001.1","13.02",1,DIE,INDA)="U" D
 .S (DWSFLD(18.01,0),DWSFLD(18.02,0),DWSFLD(17.03,0))=2
 I $$VAL^DWRA("4001.1","13.02",1,DIE,INDA)="Q" D
 .S (DWSFLD(18.01,0),DWSFLD(18.02,0),DWSFLD(17.03,0))=0
 Q
SCR2APP(DWSFLD,INDA) ;App server second screen
 ;Input:
 ; DWSFLD - Windowman array
 ; INDA -ien of criteria
 ;
 N INBPNAP
 S INBPNAP=+$$VAL^DWRA(4001.1,18.04,0,DIE,INDA)
 I INBPNAP,$$VAL^DWRA(4001.1,17.03,0,DIE,INDA)="" S DWSFLD(17.03)=$P($G(^INTHPC(INBPNAP,7)),U,4)
 ;set local address
 S DWSFLD(18.01)="127.0.0.1"
 ;set port
 S DWSFLD(18.02)="AUTO GENERATE"
 Q
DEFRHT(DWSFLD,INBPN) ;Set Default hang, retry and transmit values
 ;Input:
 ; DWSFLD - Gallery variable
 N INIP
 D INIT^INHUVUT(INBPN,.INIP)
 ;
 ;Open Hang Open retries
 S DWSFLD(16.03)=INIP("OHNG"),DWSFLD(16.04)=INIP("OTRY")
 ;Transmitter Hang
 S DWSFLD(16.05)=INIP("THNG")
 ;Send Hang, Send retry, Send Timeout
 S DWSFLD(16.06)=INIP("SHNG"),DWSFLD(16.07)=INIP("STRY"),DWSFLD(16.08)=INIP("STO")
 ;Read hand, Read Retry, Read Tiemout
 S DWSFLD(16.09)=INIP("RHNG"),DWSFLD(16.1)=INIP("RTRY"),DWSFLD(16.11)=INIP("RTO")
 Q
DISPLAY(MS,INDIS,INUIF) ;Write interactive messages to the screen
 ;INPUT:
 ;  MS - message to display
 ;  INDIS - 0 display to screen, 1 don't display to screen
 ;  INUIF opt - ien of Universal Interface File
 ;OUTPUT:
 ;  INPOP - exit simulator
 N J
 S MS=$G(MS),INDIS=+$G(INDIS),INPOP=+$G(INPOP),INUIF=+$G(INUIF)
 I 'INDIS D
 .U 0 W !,MS
 .I $S(IO'=IO(0):1,1:0) U IO W !,MS
 .S (J,^UTILITY("DIS",$J))=+$G(^UTILITY("DIS",$J))+1
 .S ^UTILITY("DIS",$J,J)=MS
 .I $D(^INTHU(INUIF,0)) D
 ..S ^UTILITY("DIS",$J,J,0)=""
 ..S ^UTILITY("DIS",$J,J,"IEN")=INUIF
 U 0 R *X:0
 I X'=-1 S INPOP=0
 Q:'$G(INIPPO)!'$G(INBPN)
 I 'INPOP D  Q
 .I $S(IO'=IO(0):1,1:0) U IO W !,"Process signalled to terminate",!
 .S MS="Process signalled to terminate"
 .U 0 W !,MS,!
 .S (J,^UTILITY("DIS",$J))=+$G(^UTILITY("DIS",$J))+1
 .S ^UTILITY("DIS",$J,J)=MS
 S ^INRHB("RUN","SRVR",INBPN,INIPPO)=$H_U_MS
 Q
DISONE(IND,IOM) ;display one message
 ; Input:
 ;   IND - Node to parse
 ;   IOM - Margin of display
 N INMS,J,MS,INMSA
 S INMS="INMSA"
 D ONE^INHUT9(IND,.INMS,IOM,3,"|CR|")
 S J=0 F  S J=$O(@INMS@(J)) Q:'J  S MS=@INMS@(J) D:$L(MS) DISPLAY^INTSUT1(MS,INEXPAND)
 I INMS["^" K @INMS
 Q
SCR(IOYF,IOYT,INFR) ;position screen scrolling region
 ;Input:
 ; IOYF - scrolling region start position
 ; IOYT - scrolling region end position
 ; INFR - display frame 
 N DIJC,INA,I
 S INFR=$G(INFR)
 I $G(DIJTT)'="" S INA="GO^DIJS"_DIJTT D @INA
 X DIJC("SCR")
 I INFR W $$SETXY^%ZTF(0,4),DIJC("BXT")
 F I=6:1:18 W $$SETXY^%ZTF(0,I),@DIJC("EOL")
 I INFR W $$SETXY^%ZTF(0,20),DIJC("BXB")
 W $$SETXY^%ZTF(0,6)
 Q
EXPNDIS(INUIF) ;Display expanded message and store
 ;Input:
 ; INUIF - Universal Interface file ien
 N INMS,MS,J,INMSA
 S INMS="INMSA"
 D ONE^INHUT9("^INTHU("_INUIF_",3,0)",.INMS,78,3,"|CR|",1)
 S J=0 F  S J=$O(@INMS@(J)) Q:'J  S MS=@INMS@(J) D:$L(MS) DISPLAY(MS,0,INUIF)
 I INMS["^" K @INMS
 Q
DISPEXP(DWLMK)  ;display expanded list
 ;Input:
 ; DWLMK - Array of Listman selected values
 N DA,DHD,DIC,DIPA,DR,IO,ION,IOST,IOM,IOSL,INIOP,INUIF,INIO,POP,%ZIS,X,Y
 N INT
 I $D(DWLMK)=1,+$G(^UTILITY("DIS",$J,+$P(@DWLMK,U,4),"IEN"))=0 Q
 ;loop and look for a selected message that has a UIF entry quit if none
 S (INUIF,INT)=""
 I $D(DWLMK)'=1 D  Q:'INUIF
 .F  S INT=$O(DWLMK(INT)) Q:INT=""  D  Q:INUIF
 ..S INUIF=+$G(^UTILITY("DIS",$J,INT,"IEN"))
 D CLEAR^DW
 S %ZIS="N" D ^%ZIS Q:POP  S INIO=IO,IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 S INIOP=IOP
 I $D(DWLMK)=1 D  Q
 .S INUIF=+$G(^UTILITY("DIS",$J,+$P(@DWLMK,U,4),"IEN"))
 .Q:'INUIF
 .S DA(INUIF)=""
 .S IOP=INIOP,DIC=4001,DHD="@",DR="INH MESSAGE DISPLAY"
 .D PRTLIST^DWPR
 .S:INIO=IO X=$$CR^UTSRD
 S INT="" F  S INT=$O(DWLMK(INT)) Q:INT=""  D
 .S INUIF=+$G(^UTILITY("DIS",$J,INT,"IEN"))
 .Q:'INUIF
 .S IOP=INIOP
 .S DIC=4001,DHD="@",DR="INH MESSAGE DISPLAY"
 .S DA(INUIF)=""
 .D PRTLIST^DWPR
 S:INIO=IO X=$$CR^UTSRD
 Q
