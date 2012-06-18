INTSTF ;DGH; 11 Jun 97 12:07;Unit Test Formatter functions
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;  !!! If routine INHFTM is modified, this routine !!!
 ;  !!! may need comparable change.                 !!!
 ;Unit Test Utility to test format queue entries through the
 ;format controller.
 Q
 ;
EN(INIP,INEXPAND,INDA) ;Specify an entry from the format queue
 ;INPUT:
 ;  INIP = array of PRE and POST executable code. PRE must set...
 ;  a) INTSK  =  entry to be processed in ^INLHFTSK or
 ;  b) INTSK(entry) = array of entries from ^INLHFTSK
 ;  INEXPAND = expanded display (0) or brief (1)
 ;  INDA = ien in criteria file, 4001.1
 ;INTERNAL VARIABLES:
 ;  INEXPND = reverse logic of INEXPAND
 ;
 N INREQLST,INLST,UIF,INEXPND,INMSG,INTSK,INIDA,INEXTSK,INARY,INDO,INPOP
 K ^UTILITY("INTHU",DUZ)
 S INEXPND='$G(INEXPAND)
 ;Protect INDA and DUZ
 S INIDA=INDA,INDUZ=DUZ
 N INDA,DUZ
 S DUZ=.5,DUZ(0)="@"
 S (INSND,OUT,RCVE,INLASTN,INUPDAT)=0,INPOP=1
 ;Loop until there is nothing left to do or user aborts.
 F  D  Q:OUT!'INPOP
 .K INARY,INEXTSK
 .S (INEXTN,INLASTN)=$O(^UTILITY("INTHU",INDUZ,$J,INLASTN))
 .I INEXTN S INEXTSK=$O(^UTILITY("INTHU",INDUZ,$J,INEXTN,""))
 .;Pre process
 .I $G(INIP("PRE"))'="" D PRE^INTSUT2(INIDA,INIP("PRE"),.INEXTSK,.INARY)
 .;set INARY to task queue--defualt would have been to UIF
 .S INARY="^INLHFTSK"
 .Q:'$$POSTPRE^INTSUT2(INIDA,.INARY,.INEXTSK,.INLASTN,.INPOP,.INPUDAT)
 .;Pre-processor should have created an entry for INEXTSK
 .I '$G(INEXTSK) S OUT=1 Q
 .;Execute format controller logic on next entry
 .D FMT(INEXTSK,.INIP,INEXPND,.INREQLST)
 .S INDO=1
 .;Execute post action. Any Pre and Post defined in criteria
 .;screen wrap around Format process if "Start at Process"=Format
 .I $G(INIP("POST"))'="" D
 ..I INEXPND S INMSG="Executing post processor code" D DISPLAY^INTSUT1(INMSG,0) Q:'INPOP
 ..D POST^INTSUT2(INIDA)
 .;IF FMT tag didn't create an INREQLST array, nothing left to do
 .Q:'$D(INREQLST)
 .;Execute Output Controller logic.
 .S INLST="" F  S INLST=$O(INREQLST(INLST)) Q:'INLST  D
 ..D PROCESS^INTSTO(INLST,INEXPAND,INIDA,.INIP)
 .K INREQLST
 ;Message if nothing was processed
 D:'$G(INDO)
 .D DISPLAY^INTSUT1("No format entries processed!",0)
 .S INMSG="Formatter test requires INTSK to exist as a variable or an array" D DISPLAY^INTSUT1(INMSG,0)
 .S INMSG="set to one or more entries in the Formatter Task File." D DISPLAY^INTSUT1(INMSG,0)
 .S INMSG="The format is either INTSK=entry or INTSK(entry)=""""" D DISPLAY^INTSUT1(INMSG,0)
 .S INMSG="Use Pre-Processor code to create the entries." D DISPLAY^INTSUT1(INMSG,0)
 Q
 ;
FMT(INTSK,INIP,INEXPND,INREQLST) ;Working section of the code
 ;Modified version of BACK^INHFTM, revised to control script processing
 ;INPUT:
 ; INTSK = entry in Formatter Task File
 ; INIP= array of variables set in criteria screen
 ; INEXPND=1 for expanded, 0 for not (reverse of ININEXPND)
 ;OUTPUT:
 ; INREQLST array of entries created in the UIF (PBR)
 ;
 D SCR^INTSUT1(7,17)
 N PRIO,INMSG,DA,DEST,DIK,I,INI1,INTT,INDA,INDIPA,INIDA,X,INJ,INORDUZ,INORDIV
 S INPOP=1
 ;BACK^INHF protects INBPN and INHSRVR here. Not needed for IUTU
 ;--Initial validation of message to be processed
 I '$D(^INLHFTSK(INTSK,0)) S INMSG="Task "_INTSK_" does not exist in INLHFTSK" D DISPLAY^INTSUT1(INMSG,0) Q
 S X=^INLHFTSK(INTSK,0),INTT=+X,INIDA=$P(X,U,2),(DUZ,INORDUZ)=$P(X,U,3),INORDIV=$P(X,U,7)
 I INEXPND S INMSG="------- Processing Format Task Queue Entry "_INTSK_"--------" D DISPLAY^INTSUT1(INMSG,0)
 S INMSG="Parent Transaction Type: "_$P(^INRHT(INTT,0),U) D DISPLAY^INTSUT1(INMSG,0)
 S:$P(X,U,5) DUZ(2)=$P(X,U,5)
 D SETDT^UTDT
 X:$L($G(^INRHSITE(1,1))) $G(^INRHSITE(1,1))
 ;Load and display INDIPA/INA array
 I $D(^INLHFTSK(INTSK,2))>9 D
 .M INDIPA=^INLHFTSK(INTSK,2)
 .Q:'INEXPND
 .D DISPLAY^INTSUT1("INA values:",0)
 .S QX="INDIPA"
 .F  S QX=$Q(@(QX)) Q:'$L(QX)  S INMSG=QX_"="_$G(@(QX)) D DISPLAY^INTSUT1(INMSG,0)
 ;Load and display INDA values
 I $D(^INLHFTSK(INTSK,1)) D
 .M INIDA=^INLHFTSK(INTSK,1)
 .Q:'INEXPND
 .D DISPLAY^INTSUT1("INDA values:",0)
 .S INMSG="INDA = "_INIDA D DISPLAY^INTSUT1(INMSG,0)
 .S QX="INIDA"
 .F  S QX=$Q(@(QX)) Q:'$L(QX)  S INMSG=QX_"="_$G(@(QX)) D DISPLAY^INTSUT1(INMSG,0)
 D:INEXPND DISPLAY^INTSUT1("Parent has the following active children:",0)
 Q:'INPOP
 S I="" F  S I=$O(^INRHT("AC",INTT,I)) Q:'I  D
 .;Display only active children
 .I $P($G(^INRHT(I,0)),U,5) D
 ..S INJ(+$P(^INRHT(I,0),U,7),I)=""
 ..I INEXPND S INMSG="     "_$P(^INRHT(I,0),U) D DISPLAY^INTSUT1(INMSG,0)
 ;If dependencies exist, display dependencies 1 through 9, then 0
 I $D(INJ) D  Q:'INPOP
 .S PRIO=.9 F  S PRIO=$O(INJ(PRIO)) Q:'PRIO  D JL(.INJ,PRIO,.INDIPA,.INIDA,.INORDUZ,INORDIV) Q:'INPOP
 .S PRIO=0 D JL(.INJ,PRIO,.INDIPA,.INIDA,.INORDUZ,INORDIV)
 S INMSG="------- Formatting of Task File entry "_INTSK_" completed ------" D DISPLAY^INTSUT1(INMSG,0)
 ;Kill entry from ^INLHFTSK
 S DIK="^INLHFTSK(",DA=INTSK D ^DIK
 Q
 ;
JL(INJ,PRIO,INDIPA,INIDA,INORDUZ,INORDIV) ;Loop through jobs at priority PRIO
 ;This is a modified version of JL^INHFTM
 ;INPUT:
 ;  INJ(PRIO,TRT) = array of child TTs in priority order
 ;  INDIPA = "INA" array loaded from task file
 ;  INIDA = "INDA" array loaded from task file
 ;  INORDUZ = DUZ loaded from task file
 ;  INORDIV = Division loaded from task file
 N INPOP,TRT,SCR,INTNAME,INHERR,ERR,ER,Z
 S INPOP=1
 S TRT=0 F  S TRT=$O(INJ(PRIO,TRT)) Q:'TRT!'INPOP  D
 .;;Future**If transaction parameter is set, only continue if this is
 .;;the transaction type selected by user.
 .;;;IF $G(INPARM("TT"),$G(INPARM("TT")'=TRT Q
 .;Preserve original values of INIDA (INDA) and INA (INDIPA) through
 .;script processing. They will be needed for subsequent children.
 .N INA,INDA
 .M INA=INDIPA,INDA=INIDA
 .K INV,UIF
 .;Get child TT info, including script and destination
 .S SCR=$P(^INRHT(TRT,0),U,3),DEST=+$P(^INRHT(TRT,0),U,2),INTNAME=$P(^(0),U)
 .S INMSG="------- Formatting child transaction: "_INTNAME_" --------" D DISPLAY^INTSUT1(INMSG,0) Q:'INPOP
 .;Avoid "no program" error if script is missing
 .I 'SCR S INMSG="No script for transaction type "_INTNAME D DISPLAY^INTSUT1(INMSG,0) Q
 .I INEXPND S INMSG="Script name: "_$P(^INRHS(SCR,0),U) D DISPLAY^INTSUT1(INMSG,0)
 .S INMSG="Destination: "_$P($G(^INRHD(DEST,0)),U) D DISPLAY^INTSUT1(INMSG,0) Q:'INPOP
 .K ^UTILITY("INDA",$J) M ^UTILITY("INDA",$J)=INDA
 .;Set "no queue" parameter to 1 so UIF entry will not be queued.
 .S Z="S ER=$$^IS"_$E(SCR#100000+100000,2,6)_"("_TRT_",.INDA,.INA,"_DEST_",1,$G(INORDUZ,DUZ),$G(INORDIV))"
 .D
 ..X Z I $G(UIF)>0 D
 ...S INMSG="Message "_$P(^INTHU(UIF,0),U,5)_" created in the UIF" D DISPLAY^INTSUT1(INMSG,0,UIF) Q:'INPOP
 ...M ^INTHU(UIF,6)=^UTILITY("INDA",$J)
 ...I $D(INA("DMISID")) M ^INTHU(UIF,7,"DMISID")=INA("DMISID")
 ...I $D(INA("MSGTYPE")) M ^INTHU(UIF,7,"MSGTYPE")=INA("MSGTYPE")
 ...;Set array to pass to Output test function
 ...S INREQLST(UIF)=""
 ...;List the message text in expanded mode
 ...I INEXPND D EXPNDIS^INTSUT1(UIF) Q:'INPOP
 ...;IF there are errors, display error messages
 ...D:$D(INHERR)
 ....I $L($G(INHERR)) D DISPLAY^INTSUT1(INHERR,0)
 ....S ERR=0
 ....F  S ERR=$O(INHERR(ERR)) Q:'ERR  D DISPLAY^INTSUT1(INHERR(ERR),0)
 .K ^UTILITY("INDA",$J)
 .I '$G(UIF) S INMSG="Unable to create message" D DISPLAY^INTSUT1(INMSG,0)
 Q
 ;
TEST ;Sample executable pre-processing code to test this routine
 ;OUTPUT: INARY array
 N INTT,INA,INDA,INHF,DIC,DA
 ;Prompt for an entry to test through TEST DAVE -PARENT transaction type
 S DIC="^DPT(",DIC(0)="AEZ" D ^DIC
 Q:Y<0
 ;Create entry in Interface Task File to test.
 S INDA=+Y,INTT="TEST DAVE -PARENT"
 S INA("TEST")="TEST INA",INA("HARRY")="BENCHMARK"
 S INA("DMISID")=9999
 S INDA(2,20)="",INDA(63,1)=""
 ;Pass 7th parameter as 1 to suppress from Format Queue
 D ^INHF(INTT,.INDA,.INA,"","","",1)
 ;INHF will be positive if Format Task Entry is created
 ;Return value in INARY to Pre-processor.
 S INARY("C")=INHF
 Q
 ;
 ;
