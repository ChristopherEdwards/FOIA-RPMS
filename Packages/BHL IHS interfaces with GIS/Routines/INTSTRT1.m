INTSTRT1 ;JD; 26 Mar 97 13:44; 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
QUERY(INDA,DIPA,INEXPAND) ;Do Query response messages
 ;Input:
 ; INDA - ien of 4001.1
 ; DIPA - Store needed variables
 ; INEXPAND - 0 Don't expand output, 1 expand output
 N INBPNSR,INBPNAP,INIPADDR,INIPPO
 ;get messages from saved message list
 D UPDTSND^INTSUT3(INDA)
 ;Outbound message and nothing was selected to send
 I '$D(^UTILITY("INTHU",DUZ,$J)) D DISPLAY^INTSUT1("Note - messages have not been selected transmit")
 D ENAUTO^INTS(INDA,.DIPA,INEXPAND)
 Q
UNSOLI(INDIR,DIPA,INEXPAND,INDA,DIE) ;Process unsolicted message
 ;Input:
 ; INDIR - I Inbound, O Outbound
 ; DIPA - Store needed variables
 ; INEXPAND - 0 Don't expand output, 1 expand output
 ; INDA - ien of 4001.1
 ; DIE - 4001.1
 N INRTN
 I INDIR="I" S INRTN="EN^INTSREC(INEXPAND,INDA,DIE)"
 I INDIR="O" S INRTN="EN^INTSEND(INEXPAND,INDA,DIE)"
 D ZIS^INHUT8(INRTN,"INEXPAND^INDA^DIE^",1,"","",INDEV)
 D LISTMSG(INDA)
 ;If came up as server halt to reset TCP/IP socket
 I $$VAL^DWRA(4001.1,13.03,2,"^DIZ(4001.1,",INDA) D HALT
 Q
UNIT(INDA,INDIR,INEXPAND) ;Unit test functions
 ;Input:
 ; INDA - ien of Criteria
 ; INDIR - I Inbound, O Outbound
 ; INEXPAND - 0 Don't expand output, 1 expand output
 N INSPROC,INTSK,INHF,INPRE,INPOST
 S INSPROC=$$VAL^DWRA(4001.1,13.07,2,DIE,INDA)
 S INIP("PRE")=$$VAL^DWRA(4001.1,21.01,2,DIE,INDA)
 S INIP("POST")=$$VAL^DWRA(4001.1,22.01,2,DIE,INDA)
 S INIP("DIR")=INDIR,INIP("SPROC")=INSPROC
 ;Start of process=Format does not have UIF messages, others do
 ;;I INSPROC'="F",'$D(INREQLST) D DISPLAY^INTSUT1("No messages selected") Q
 ;;Move into INTSTO--I INSPROC'="F",'$D(^UTILITY("INTHU",DUZ,$J)) D DISPLAY^INTSUT1("Note - no messages selected") Q
 ;;move into INTSTF---I INPRE'="" X INPRE S:$G(INHF) INTSK=INHF
 ;If start of process=Format, PREprocess code must return INHF>0
 ;;I INSPROC="F",$G(INHF)<1 D DISPLAY^INTSUT1("No formatter entry exists") Q
 ;Identify the routine for the entry process
 S INROU=$S(INSPROC="F":"EN^INTSTF(.INIP,INEXPAND,INDA)",INSPROC="O":"EN^INTSTO(.INIP,INEXPAND,INDA)",INSPROC="R":"EN^INTSTO(.INIP,INEXPAND,INDA)",1:"Q")
 I INROU="Q" D DISPLAY^INTSUT1("No support for this function") Q
 D ZIS^INHUT8(INROU,"INTSK^INREQLST(^INIP(",1,"","",INDEV)
 D LISTMSG(INDA)
 Q
LISTMSG(INDA) ;List Messages using listman
 ;Input:
 ; INDA - ien of 4001.1
 ; ^UTILITY("DIS",$J) - Global with messages in it
 ;
 N DWL,DWLRF,DWLB
 S DWLB="0^4^16^78"
 S DWL("TITLE")="D LSTHDR^INTSTRT("_INDA_")"
 S DWLRF="^UTILITY(""DIS"",$J)",DWL="XWFE'",DWLB="0^4^16^78"
 F  D ^DWL Q:DWLR'="E"  D DISPEXP^INTSUT1(.DWLRF),LSTHDR^INTSTRT(INDA)
 ;D:$D(DWLMK)>1 DISPEXP^INTSUT1(.DWLMK),CLR^DIJF,SCR^INTSUT1(5,17,1),LSTHDR^INTSTRT(INDA)
 K ^UTILITY("DIS",$J)
 Q
CRDUZ ;Stuff current user DUZ into file
 N INOIEN
 S INOIEN=$O(^UTILITY("INHSYS",$J,4001.1,""))
 I INOIEN D
 .;set user field to current user
 .S $P(^UTILITY("INHSYS",$J,4001.1,INOIEN,0),U,2)=$P(^DIC(3,DUZ,0),U)
 Q
CONTINUE(INODE0) ;Continue with restore or stop
 ;Input:
 ; INODE0 - 0 node of flat file or 4001.1 file
 Q:'$$EXISTS^INTSUT3(INODE0,.INAME) 1
 Q $$YN^UTWRD("Overwrite "_INAME_" with new version? ;0")
 ;
HALT ;Halt if process was a server
 ;D CLR^DIJF
 ;W !,"Process was a Server. Halting to close socket"
 ;D HALT^ZU
 Q
UNLOCK(INDA,INOPT) ;unlock all but one lock of INDA
 ;Input:
 ; INDA - ien of lock to keep locked
 ; INOPT - array with lock count
 ;
 N INA,%
 S INA="" F  S INA=$O(INOPT("LOCK",INA)) Q:'INA  D
 .;unlock all non INDA locks
 .I INA'=INDA D
 ..F I=+INOPT("LOCK",INA):-1:1 S %=$$LOCK^INHUTC(INA,0)
 ..K INOPT("LOCK",INA)
 .;if same as INDA unlock all but one lock
 .I INA=INDA D
 ..F I=+INOPT("LOCK",INA):-1:2 S %=$$LOCK^INHUTC(INA,0)
 ..S INOPT("LOCK",INA)=1
 Q
