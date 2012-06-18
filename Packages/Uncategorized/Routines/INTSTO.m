INTSTO ;DGH; 1 May 97 14:57;Unit test Output Controller
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;  !!! If INHOTM is modified, this routine !!!
 ;  !!! may need comparable changes.        !!!
 ;Unit Test Utility which processes entries in the UIF through the
 ;output controller.  Primarily intended to test inbound transactions
 ;but will do any existing transaction.
 ;
EN(INIP,INEXPAND,INDA) ;Entry point
 ;Same entry point used for Starting Process=Output &
 ;Starting Process=Replicator. If Replicator, entries are screened
 ;at the PROCESS tag below.
 ;INPUT:
 ;  INDA= ien in criteria file, 4001.1
 ;  INIP = Array of variables
 ;    INIP("PRE")=pre-processor code
 ;    INIP("POST")=post processor code
 ;    INIP("DIR")=direction. I=IN O=OUT (Not currently used)
 ;    INIP("SPROC")=start at process
 ;  INEXPAND = 0 for brief, 1 for expanded display
 ;OUTPUT:
 ;  ^UTILITY("INTHU",DUZ,$J,<processing order>)=UIF entry to process
 ;
 N UIF,INEXPND,X
 K ^UTILITY("INTHU",DUZ,$J)
 ;UIF entries to process are in ^DIZ or designated with Pre-processor.
 ;Following call gets entries from ^DIZ. Same call as is used in
 ;Interactive Test Utility. It retrieves more data than is used for
 ;this function, but maintains compatibility with ITU.
 D UPDTSND^INTSUT3(INDA)
 ;Reverse INEXPAND LOGIC
 S INEXPND='$G(INEXPAND)
 ;Processing flow copied from LOOP^INTSEND. Thus, flow of pre-processing
 ;and "post-pre" will be identical.
 N INSND,OUT,RCVE,INARY,INEXTN,INEXTUIF,INLASTN,INUPDAT,INOPT,INPOP
 S (INSND,OUT,RCVE,INLASTN,INUPDAT)=0
 S INPOP=1
 F  D  Q:OUT!'INPOP
 .K INARY,INEXTUIF
 .S (INEXTN,INLASTN)=$O(^UTILITY("INTHU",DUZ,$J,INLASTN))
 .I INEXTN S INEXTUIF=$O(^UTILITY("INTHU",DUZ,$J,INEXTN,""))
 .;Pre process
 .I $G(INIP("PRE"))'="" D PRE^INTSUT2(INDA,INIP("PRE"),.INEXTUIF,.INARY)
 .Q:'$$POSTPRE^INTSUT2(INDA,.INARY,.INEXTUIF,.INLASTN,.INPOP,.INUPDAT)
 .;last entry in utility and nothing updated in post process so QUIT
 .I 'INLASTN S OUT=1 Q
 .I '$D(^INTHU(+$G(INEXTUIF),0)) D DISPLAY^INTSUT1("Invalid or missing Universal Interface entry "_$G(INEXTUIF)) S INPOP=0 Q
 .;Process through Output Controller
 .D PROCESS(INEXTUIF,INEXPAND,INDA,.INIP)
 .;Execute post action
 .I $G(INIP("POST"))'="" D POST^INTSUT2(INDA)
 ;save criteria tests if they were updated in the pre or post
 I INUPDAT D
 .N INOPT
 .S INOPT("TYPE")="TEST",INOPT("NONINTER")=1
 .S X=$$SAVE^INHUTC1(.INOPT,INDA,"U")
 K ^UTILITY("INTHU",DUZ,$J)
 Q
 ;
PROCESS(UIF,INEXPAND,INDA,INIP) ;Actual processing of each UIF entry
 ;This entry point may be called from INTSTF, the format tester
 ;or from EN above.
 ;INPUT:
 ;  UIF = entry to process
 ;  INEXPAND = 0 for brief, 1 for expanded display
 ;  INDA = entry in 4001.1
 ;  INIP("DIR")=direction. I=IN O=OUT
 ;  INIP("SPROC")=start at process
 N INMSG,J,L1,LOG,TYPE,DEST,INPOP,INEXPND
 S INPOP=1
 ;Reverse INEXPAND LOGIC
 S INEXPND='$G(INEXPAND)
 ;Following is adapted from SVLOOP^INHOTM
 ;Determine how to process transaction and validate needed data.
 I '$D(^INTHU(+$G(UIF),0)) S INMSG="UIF file entry missing: "_+$G(UIF) D DISPLAY^INTSUT1(INMSG,0) Q
 S TYPE=$$TYPE^INHOTM(UIF)
 I 'DEST D DISPLAY^INTSUT1("Transaction has no destination.",0) Q
 I 'TYPE D DISPLAY^INTSUT1("Destination has no method of processing.",0) Q
 S INMSG="------- Processing message "_$P(^INTHU(UIF,0),U,5)_" -------" D DISPLAY^INTSUT1(INMSG,0,UIF)
 I $G(INIP("SPROC"))="R",$P(^INRHD(DEST,0),U)'["HL REPLICATOR" D  Q
 .S INMSG="Destination "_$P(^INRHD(DEST,0),U)_" is not HL REPLICATOR"
 .D DISPLAY^INTSUT1(INMSG,0)
 I INEXPND D
 .D EXPNDIS^INTSUT1(UIF)
 .S INMSG="Destination: "_$P(^INRHD(DEST,0),U) D DISPLAY^INTSUT1(INMSG,0)
 ;Validate message structure (Only in expanded mode)
 I $G(UIF),INEXPND D
 .S INMSG="---- Validating message structure and required fields -----"
 .D DISPLAY^INTSUT1(INMSG,0)
 .D MAIN^INTSTR(UIF,INEXPND)
 .S INMSG="---- Validation complete  ---------------------------------"
 .D DISPLAY^INTSUT1(INMSG,0)
 Q:'INPOP
 D
 .;Start up a job for entry with a Transceiver Routine
 .I TYPE=2 D OUT^INTSTO1(UIF,INEXPND,DEST) Q
 .;Start up a job for entry with a Transaction Type
 .I TYPE=1 D IN(UIF,INEXPND,DEST) Q
 .;Start up a job for entry with a Mail recipient
 .I TYPE=3 D DISPLAY^INTSUT1("Mail messages not supported",0) Q
 Q
 ;
IN(UIF,INEXPND,DEST) ;process incoming message
 ;INPUT:
 ;  UIF = entry in Universal Interface File for processing
 ;  INEXPND = 0 to not expand, 1 to expand
 ;  DEST = pointer to Interface Destination File
 ;;FOLLOWING COPIED FROM ^INHOS(IEN)
 N INHERR,ER,ERR,INTT,SCR,C,Z,L,L1,INPOP
 S INPOP=1
 S INTT=+$P(^INRHD(DEST,0),U,2) I 'INTT S INMSG="Missing transaction type or entry for destination '"_$P(^INRHD(DEST,0),U) D DISPLAY^INTSUT1(INMSG,0) Q
 I INEXPND S INMSG="Executing script for transaction Type "_$P(^INRHT(INTT,0),U) D DISPLAY^INTSUT1(INMSG,0)
 S SCR=$P(^INRHT(INTT,0),U,3) I 'SCR S INMSG="Missing script for transaction type: '"_$P(^INRHT(INTT,0),U)_"'" D DISPLAY^INTSUT1(INMSG,0) Q
 N INOA,INODA,INA
 K INHERR,INEDIT S:$P(^INTHU(UIF,0),U,15) INEDIT=$P(^(0),U,15) S C=",",Z="N INDEV,INTT,DUZ,DTIME S ER=$$^IS"_$E(SCR#100000+100000,2,6)_"("_UIF_",.INOA,.INODA)" X Z K INEDIT
 ;Display results of script run
 I INEXPND D
 .S INMSG="Inbound script "_$S(ER=0:"completed with no errors",ER=1:"encountered non-fatal error",1:"encountered fatal error")
 .D DISPLAY^INTSUT1(INMSG,0)
 .D:$D(INHERR) ERRS(.INHERR)
 Q:'INPOP
 ;Variable INOA, if set within the inbound script, will be passed as
 ;the INA array to the ACK call.
 ;If it exists display it (but it may be an array with nodes)
 D:INEXPND DISPLAY^INTSUT1("---- Inbound script created following variable arrays",0)
 I INEXPND,$D(INOA) D
 .S QX="INOA"
 .F  S QX=$Q(@(QX)) Q:'$L(QX)  S INMSG=QX_"="_$G(@(QX)) D DISPLAY^INTSUT1(INMSG,0)
 ;Variable INODA, if set within the inbound script, will be passed as
 ;the INDA array to the ACK call.
 I INEXPND,$D(INODA) D
 .S QX="INODA"
 .F  S QX=$Q(@(QX)) Q:'$L(QX)  S INMSG=QX_"="_$G(@(QX)) D DISPLAY^INTSUT1(INMSG,0)
 Q:'INPOP
 D DONE^INHOS
 ;--Display activity log multiple entries
 D ACTLOG(UIF) Q:'INPOP
 ;If incoming transaction created an application ack, display it
 I $P(^INTHU(UIF,0),U,6) D
 .D DISPLAY^INTSUT1("Application acknowledgment "_$P(^INTHU($P(^INTHU(UIF,0),U,6),0),U,5)_" created",0)
 .I INEXPND D EXPNDIS^INTSUT1($P(^INTHU(UIF,0),U,6))
 Q
 ;
ACTLOG(UIF) ;Display entries from activity log multiple
 ;INPUT:
 ;  UIF = entry to process
 N I
 Q:'$D(^INTHU(UIF,1))
 D DISPLAY^INTSUT1("Activity log",0)
 S I=0 F  S I=$O(^INTHU(UIF,1,I)) Q:'I  D
 .S INMSG=^INTHU(UIF,1,I,0) D DISPLAY^INTSUT1(INMSG,0)
 Q
 ;
 ;
ERRS(INHERR) ;Display any errors in INHERR array
 ;INPUT:
 ;  INHERR will still exist if there were errors
 Q:'$D(INHERR)
 N ERR
 I $L($G(INHERR)) D DISPLAY^INTSUT1(INHERR,0)
 S ERR=0 F  S ERR=$O(INHERR(ERR)) Q:'ERR  D
 .D DISPLAY^INTSUT1(INHERR(ERR),0)
 Q
 ;
 ;
