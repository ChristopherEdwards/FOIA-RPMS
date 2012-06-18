INTSLO ;KAC,DP,FRW ; 7 Apr 96 12:26; Access Logon Server
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
EN ;Mian entry point
 ; Input:
 ;   INBPN  - Background process (ien)
 ; Output:
 ;   INUIF - Acknowledge message returned from LoS (ien)
 ;
 N INCHNL,INDEST,INDSTR,INERRTST,INMSGTST,INIP,INRUNTST,INUSEQ,X,Y,Z
 S X="ERR^INTSLO",@^%ZOSF("TRAP")
 ;
 ;Get Test Transmitter parameters from BACKGROUND PROCESS CONTROL file
 D INIT^INHUVUT(INBPN,.INIP)
 ;
 ; Set array of valid inbound INTERFACE DESTINATION names
 F X=1:1 S Y=$T(DEST+X) Q:Y'[";;"  S Z=$TR($P(Y,";;")," ",""),INDEST(Z)=$P(Y,";;",2)
 ;
 S INUSEQ=0  ;No sequence number protocol
 ;
 N INACKUIF,INERR,INMEM,INMSGTST K INDATA
 S INMSGTST="INDATA" ; reset local array in which to receive data
 ;
 ; Select port of the Logon Server from INBPNSR
 S X=$O(^INTHPC(INBPNSR,5,0)),INPORTSR=$G(^INTHPC(INBPNSR,5,+X,0))
 I 'INPORTSR S MS="No Server port designated for Logon Server" D DEBUG^INTST Q
 ;
 ;Open a TCP/IP Client connection to the Logon Server
 S INERRTST=0,LOOPCNT=0 F LOOPCNT=1:1:10 D  Q:INCHNL  H 5
 . D OPEN^%INET(.INCHNL,.INMEM,INIPADDR,INPORTSR,1)
 ;
 I 'INCHNL D  Q
 .  S MS="Unable to connect to Logon Server at "_INIPADDR_" /  "_INPORTSR
 .  D DEBUG^INTST
 ;
 ;Logon message
 S INUIF=INLOGZ01 Q:'INUIF
 ;
 ;Send logon message to LoS
 S INERRTST=$$SEND^INHUVUT(INLOGZ01,INCHNL,.INIP)
 I 'INERRTST S MS="Unable to send logon message" D DEBUG^INTST Q
 ;
RECIV ;receive ackknowledgement back
 K INMSGTST
 S INERRTST=$$RECEIVE^INHUVUT(.INMSGTST,INCHNL,.INIP,.INERR,.INMEM)
 I INERRTST D  Q
 .  S MS="Acknowledgement not received from Logon server" D DEBUG^INTST
 ;
ACKIN ;Store ack in INTHU
 S INERRTST=$$IN^INHUSEN(INMSGTST,.INDEST,INDSTR,INUSEQ,.INACKUIF,.INERR,"",.INUIF,1)
 I INERRTST D  Q
 .  S MS="Error storing acknowledgement message from Logon Server"
 .  D DEBUG^INTST
 ;
 D CLOSE
 ;
 Q
 ;
CLOSE ;Close socket
 D:$G(INCHNL) CLOSE^%INET(INCHNL)
 Q
 ;
ERR ; Error handler
 W !,$$ERRMSG^INHU1
 D CLOSE
 ;
 ;
DEST ; The following tags identify valid message destinations.
ACKACK ;;TEST INTERACTIVE
 ;
