INTSTRT ;JD; 24 Mar 97 07:31; Routine entry for Actions on Action Bar 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;This is the interactive test utility of the GIS. It is a programmer
 ;utility which is run from the command prompt. There is no menu.
 ;To port this to the IHS would require a screen man screen (not
 ;a problem) and an interactive list manager (not available in
 ;IHS). For the time being, calls to CHCS functions are commented
 ;out. This will require a major revision to work for the IHS.
 Q
EN ;main entry point to test utility
 N DWN,DIE,DWN,DIPA,DA,XGABPOP,INDA
 D ENV^UTIL
 ;D CLR^DIJF ;not a call for IHS
 K ^UTILITY("TEST UTIL",$J,DUZ)
 S DWA1="INH TEST UTILITY"
 S DWLRF="^UTILITY(""TEST UTIL"",$J,DUZ)"
 ;
 ;D ^DWA ;Not a call for IHS
 Q
START(INDA) ;Start ITU from Action screen
 ;Input:
 ; INDA - ien of 4001.1
 N INNAME,INBPNSR,INBPNAP,INTYP,DIE,INDEV,INEXPAND,INPOP,INDIR
 D ^%ZIST
 I '+$G(INDA) W !,"No Criteria Selected yet. Please select a Criteria",*7 Q
 S DIE="^DIZ(4001.1,"
 S INTYP=$$VAL^DWRA(4001.1,13.02,2,DIE,INDA)
 S INEXPAND='$$VAL^DWRA(4001.1,12,2,DIE,INDA)
 S INDEV=$$VAL^DWRA(4001.1,28,2,DIE,INDA) S:INDEV="" INDEV=$I
 S INDIR=$$VAL^DWRA(4001.1,6,2,DIE,INDA)
 ;Get message list
 W $$SETXY^%ZTF(0,21),"Stop -- Press any key to stop",@DIJC("EOL")
 W $$SETXY^%ZTF(0,22),@DIJC("EOL")
 D SCR^INTSUT1(5,17)
 ;If Query response message
 I INTYP="Q" D
 .D ZIS^INHUT8("QUERY^INTSTRT1(INDA,.DIPA,INEXPAND)","INDA^DIPA(^INEXPAND^",1,"","",INDEV)
 .D LISTMSG^INTSTRT1(DIPA("DA"))
 ;If unsolicited message
 I INTYP="U" D UNSOLI^INTSTRT1(INDIR,.DIPA,INEXPAND,INDA,DIE)
 ;If unit test
 I INTYP="T" D UNIT^INTSTRT1(INDA,INDIR,INEXPAND)
 Q
LSTHDR(INDA) ;Header for Command screen processor
 ;Input:
 ; INDA - ien of 4001.1
 N INX,INDIR,DIE,INTCNAM,INST
 S INX="Interface Testing Utilities Monitor"
 W $$SETXY^%ZTF(0,0),INX_$$PAD^INHUT2($$CDATASC^%ZTFDT($H,1,3),80-$L(INX)," ")
 I '+$G(INDA) W !!,"No Criteria Selected" Q
 E  D
 .S DIE="^DIZ(4001.1,"
 .S INTCNAM=$$VAL^DWRA(4001.1,".04",2,DIE,INDA)
 .S:INTCNAM="" INTCNAM="  (No Test Case Name defined)"
 .S INDIR=$$VAL^DWRA(4001.1,6,2,DIE,INDA),INDIR=$S(INDIR="O":"Outbound",INDIR="I":"Inbound",1:"")
 .S:INDIR="" INDIR=" (None)"
 .W !!,?10,"Test Case: ",INTCNAM,?57,"Direction: ",INDIR
 .S INST=$$VAL^DWRA(4001.1,13.07,2,DIE,INDA)
 .S INST=$S(INST="F":"Format Controller",INST="O":"Output Controller",1:"")
 .W !,?2,"Starting Process: ",INST
 Q
CRIT(DIPA,INDA) ;go to criteria gallery from action screen
 ;Input/Output
 ; DIPA - Array with DIPA("DA")
 ; INDA - ien of criteria
 N DWN,DWLRF,DWA1,DWLM,INX,X,Y,INNAME,INOPT,INDEV,INODA
 S INODA=$G(DIPA("DA"))
 S:INODA INOPT("NAME")=INODA
 S INOPT("GALLERY")="INH TEST UTILITY CRITERIA",INOPT("LOCK")=1,INOPT("TYPE")="TEST",INOPT("NEW")=1
 W @IOF
 S Y=$$GETCRIT^INHUTC(.INOPT,.INPARMS)
 I +Y>0 S (INDA,DIPA("DA"))=+Y I $G(INODA),$$LOCK^INHUTC(INODA,0)
 I '+Y D
 .K INDA,DIPA("DA")
 .S:INODA (INDA,DIPA("DA"))=INODA
 ;;D CLR^DIJF ;;Not an IHS call
 Q
SAVE(INDA) ;Save an element to flat file from the action screen
 ; Input:
 ;   INDA - ien of 4001.1 entry to save
 N DIE,DIC,X,Y,INNTRIES,I,INTMP,%FILE,%OIEN,INRTN,INPOP,INAME,INROU,INCR
 N INOMIT
 I '+$G(INDA) W *7 Q
 ;validate all pointers to ^INTHU exist
 D UPDTSND^INTSUT3(INDA) K ^DIZ(4001.1,INDA,19) D UPDTFRUT^INTSUT3(INDA)
 S (INCR,INPOP)=0
 S INAME=$$VAL^DWRA("4001.1",18.05,2,"^DIZ(4001.1,",+$G(INDA))
 S INAME=$$FLATNAM^INTSUT3(INAME,"S")
 Q:INAME=""
 K ^UTILITY($J)
 S INNTRIES("4001.1",INDA)=""
 ;Omit pointed to UIF fields in Universal Interface file
 F I=".06",".07",".18" S INOMIT(4001,I)=""
 S I=0 F  S I=$O(^DIZ(4001.1,INDA,19,I)) Q:'I  D
 .S INTMP=$G(^DIZ(4001.1,INDA,19,I,0))
 .I INTMP S INNTRIES(4001,+INTMP)=""
 S %FILE="" F  S %FILE=$O(INNTRIES(%FILE)) Q:%FILE=""  D
 .S %OIEN="" F  S %OIEN=$O(INNTRIES(%FILE,%OIEN)) Q:%OIEN=""  D
 ..D COPY^INHSYS09(%FILE,%OIEN,0,.INOMIT)
 Q:'$D(^UTILITY($J))
 W !
 D SV2FLT^INHSYSE(INAME,.INDONE)
 I 'INDONE W !,"Save did not complete. Check validity of file name.",*7,$$CR^UTSRD(0,21)
 Q
RESTORE(INDA,DIPA) ;Restore data from flat file from the action Screen
 ;Input:
 ; INDA - ien of 4001.1 entry to restore 
 ; DIPA - array of saved variables
 N DIE,DIC,DR,X,INAME,INRTN,INREPRT,%DRVR,Y,IN01,INCRNAM,%
 N %PASS,%LFILES,AA,%SAV,DFN,INMSG,DONE,INEX,INODA,INOPT,INEWDA
 S INREPRT=0
 S INAME=$$VAL^DWRA("4001.1",18.05,2,"^DIZ(4001.1,",+$G(INDA))
 S INAME=$$FLATNAM^INTSUT3(INAME)
 Q:INAME=""
 W !
 K ^UTILITY("INHSYS",$J)
 D RSFRFLT^INHSYSE(INAME)
 I '$D(^UTILITY("INHSYS",$J)) D MSG^INTSUT2("Nothing updated. Check validity of VMS file") S X=$$CR^UTSRD Q
 I $D(^UTILITY("INHSYS",$J)),$$CONTINUE^INTSTRT1($G(^UTILITY("INHSYS",$J,4001.1,+$O(^UTILITY("INHSYS",$J,4001.1,"")),0))) D
 .D CRDUZ^INTSTRT1
 .S INODA=+$G(INDA)
 .W !,"." D INST^INHSYSE(.%DRVR,2,INREPRT,.INFLD,.INMSG)
 .S INOPT("TYPE")="TEST",INOPT("LOCK")=0,INOPT("NONINTER")=1
 .W "." S INEWDA=$$SAVE^INHUTC1(.INOPT,DIPA("DA"),"U")
 .S INOPT("LOCK",INODA)=$G(INOPT("LOCK",INODA))+1
 .D UNLOCK^INTSTRT1(INEWDA,.INOPT)
 .I 'INEWDA,$L(INEWDA)>1 W !,INEWDA S X=$$CR^UTSRD Q
 .S (DIPA("DA"),INDA)=+INEWDA
 ;Clean up ^UTILITY
 K ^UTILITY($J),^UTILITY("INHSYS",$J),^UTILITY("INHSYSUT",$J)
 Q
HELP ;Action Screen Help
 W !,"Start/Stop - Start or Stop transmission or reception of messages."
 W !,"Criteria   - Select a criteria and edit it."
 W !,"Listmsg    - List the selected messages to be transmitted."
 W !,"selMsg     - Select messages from the Universal Interface file to "
 W !,"             transmit to the interface."
 W !,"saVe       - Save the test criteria to a flat file."
 W !,"Restore    - Restore test criteria from a flat file."
 W !,"eXit       - Exit the Test Utility Monitor"
 W !!!,"***   See GIS manual for additional Interactive Test Utility Help"
 Q
SEL(INDA) ;Select messages from selMsg on the Action Screen
 ; DESCRIPTION: Prompts the user for a message to select. The user may
 ;              enter any valid indexed message for a single
 ;              message or '/' to search and select multiple messages.
 ;Input: 
 ; INDA - ien of Criteria
 ;Output:
 ;  ^UTILITY("INTHU",DUZ,$J,INL,IND) - Messages to send
 ;
 N X,Y,INNDA,INPARM2,DIC,I,POP,INLOOP,INDA1,INOPT,INREQLST,DIE
 I '+$G(INDA) W *7 Q
 ; construct the structure defining the selection operations
 I '$O(^INTHU(0)) W !!,"There are no entries to select." Q
 ;
 ;Determine how to search
 F  D  Q:X[U!(X="")!(X="C")!(X="c")!(X="I")!(X="i")  W *7
 .D HDR^INTS
 .W ! S X=$$READ^%ZTF(1,2,"(C)andidate Search or (I)ndividual Messages: ","C",13)
 Q:X[U!(X="")
 ;
 ;Message search
 I X="/"!(X="C")!(X="c") D  Q
 .S INDA1=INDA
 .S INOPT("ARRAY")="INREQLST"
 .D ENTRY^INHUTC("TRANSACTION","INTERFACE","","",.INOPT)
 .S (INDA,DIPA("DA"))=INDA1
 .S INL="" F  S INL=$O(INREQLST(INL)) Q:INL=""  D
 ..S INT=INREQLST(INL)
 ..;update 4001.1 
 ..D UPSINGMS^INTSUT3(INDA1,"LS",INT)
 .;if we added something update utility
 .I $O(INREQLST("")) D UPDTSND^INTSUT3(INDA1)
 .S INOPT("TYPE")="TEST",INOPT("NONINTER")=1,X=$$SAVE^INHUTC1(.INOPT,INDA1,"U")
 .I 'X,$L(X)>1 W !,X S X=$$CR^UTSRD
 .S (INDA,DIPA("DA"))=INDA1
 .;D CLR^DIJF ;not an IHS call
 ;
 ;Allow multiple DIC selections
 K INREQLST
 ;I '$D(^DIZ(4001.1,INDA,19,0)) S ^DIZ(4001.1,INDA,19,0)="^4001.19PA"
 K DIC S DIC("P")=$P(^DD(4001.1,19,0),U,2),DIC="^DIZ(4001.1,"_INDA_",19,",DIC(0)="ANMEQL",DA(1)=INDA,DIE=DIC
 F  D ^DIC Q:Y<0  D
 .N DIC,X,DA,DR
 .S DA=+Y,DA(1)=INDA,DR=".01//^S X=""`"""_$P(Y,U,2)
 .;call DIE to give ability to delete
 .D ^DIE
 S DIPA("DA")=INDA
 S INOPT("TYPE")="TEST",INOPT("NONINTER")=1
 S X=$$SAVE^INHUTC1(.INOPT,DIPA("DA"),"U")
 I 'X,$L(X)>1 W !,X S X=$$CR^UTSRD
 Q
DIS(INDA) ;Display current messages from Listmsg on the action screen
 ;Input:
 ; INDA - ien of Criteria
 N INL,INTN,DWL,DWLRF,DWLB,INCNT,INODE0,Y,DWLMK,INTMP
 K ^UTILITY("DIS",$J)
 I '+$G(INDA) W *7 Q
 D UPDATE^INTSUT3(INDA)
 S INCNT=0
 S INL=0 F  S INL=$O(^UTILITY("DIS",$J,INL)) Q:'INL  D
 .S IND=0 F  S IND=$O(^UTILITY("DIS",$J,INL,IND)) Q:'IND  D
 ..S INCNT=INCNT+1
 ..S INODE0=$G(^UTILITY("DIS",$J,INL,IND,0))
 ..S Y=$$PAR^%DT($P(INODE0,U))
 ..S INTMP=Y_"             "
 ..S INTMP=$E(INTMP,1,22)_$P(INODE0,U,5)_"                        "
 ..S ^UTILITY("DIS",$J,INCNT)=$E(INTMP,1,44)_$P($G(^INRHD(+$P(INODE0,U,2),0)),U)
 ..S ^UTILITY("DIS",$J,INCNT,0)=""
 ..S ^UTILITY("DIS",$J,INCNT,"IEN")=IND
 I '$D(^UTILITY("DIS",$J)) D
 .S ^UTILITY("DIS",$J,1)="No messages selected for this criteria yet"
 .S ^UTILITY("DIS",$J,1,0)=""
 S DWL="XWFE",DWLRF="^UTILITY(""DIS"","_$J_")",DWLB="0^3^17^78"
 S INTIT="Test Utility Messages to be Transmitted List"
 S DWL("TITLE")="W $$CENTER^INHUTIL(INTIT,IOM),!!,?2,""Date/Time"",?24,""Message ID"",?46,""Destination"""
 F  D ^DWL Q:DWLR'="E"  D DISPEXP^INTSUT1(.DWLRF)
 D:$D(DWLMK)>1 DISPEXP^INTSUT1(.DWLMK)
 K ^UTILITY("DIS",$J)
 Q
EXIT(INDA) ;Exit from action screen
 ;Input:
 ; INDA - IEN of Criteria
 N INIPPO,X,INBPN
 S X=$$LOCK^INHUTC(.INDA,"-")
 Q
