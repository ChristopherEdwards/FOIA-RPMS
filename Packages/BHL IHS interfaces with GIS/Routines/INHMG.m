INHMG ;KN; 24 May 99 13:41; Script Generator Message 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: Script Generator Message (INHMG)
 ;
 ; PURPOSE: 
 ; The purpose of the Script Generator Message Module (INHMG)
 ; is to accept user input of script generator message,get
 ; user's option of displaying common segments, set up the
 ; the output device, and call module INHMG1 for processing
 ; and display/print the Script Generator Message.
 ; 
 ; DESCRIPTION:
 ; The processing of this routine will ask user for a script
 ; generator message.  The Module INHMG will prompt the user 
 ; for option to display the common segments ( MSH and PID ).  
 ; After accepting the user input, this module will set up 
 ; the output device, set up the tasking logic, build DXS array,
 ; then call module INMHMG1 to process a listing for the Script 
 ; Generator Message selected.
 ; 
 ; Return: None
 ; Parameters:
 ; None
 ; 
 ; Code begins:
EN ; Main entry point for the Script Generator Message 
 ; 
 N %ZIS,A,EXIT,HDR,INPAGE,X,ZTDESC,ZTIO,ZTRTN,ZTSAVE,DXS
 ;
ENUSE ; User input
 ;
 ; Description:  The ENUSE entry point is used for accepting
 ;   user's input message.  Also the user will be 
 ;  prompted for the option to print the common 
 ;  segments.
 ;
 ; Return: None
 ; Parameters: None   
 ;        
 ; Code begins:
 ; Prompt for message and look up the internal entry number  
 S DIWF="",DIC="^INTHL7M(",DIC(0)="AEQ",DIC("A")="PLEASE SELECT SCRIPT GENERATOR MESSAGE : "
 D ^DIC
 I ($G(Y)<0)!($G(DUOUT)) Q
 ;Save message name and parameters for look up
 S INAM=$P($G(Y),U,2),D0=+Y,D1=0
 ;Prompt for display of common segments option and validate input
 S INCOMSEG=$$YN^UTSRD("Do you wish to print the COMMON SEGMENTS (MSH and PID) <Y/N> ")
 ;Device handling & Tasking logic
 K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ" D ^%ZIS G:POP QUIT
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." G QUIT
 I IO'=IO(0) S ZTDESC="Description of job",ZTIO=IOP,ZTRTN="ENQUE^INHMG" D  G QUIT
 .F X="U","IO*","D*","HDR(","INAM","INDT","INPAGE","INCOMSEG" S ZTSAVE(X)=""
 .D ^%ZTLOAD
ENQUE ; Taskman entry point
 ;
 ; Description:  ENQUE is the entry point for Taskman.  It will call
 ;  module INHMG1 for the script generator message 
 ;  processing.
 ; 
 ; Return: None
 ; Parameter: None
 ; 
 ; Code begins:  
 S INPAGE=0,EXIT=0
 W @IOF D HSET,HEADER
 D INBUILD^INHMG1(INCOMSEG)
 G QUIT
 ;
HEADER ; Output header in local array HDR(x)
 ;
 ; Description: The function HEADER is used to display header when
 ;  reaching the end of page/screen, and give user the
 ;  option to continue or to abort.
 ;
 ;
 ; Input:
 ;  INPAGE - page number
 ;  HDR    - array containing header lines of the report
 ;  INNOOUT- if 1 means do not allow the user to abort
 ; Output:
 ;  DUOUT  - if 1 means user wants to abort
 ;
 ; Code begins:
 N INA,I,X,Y
 ; Check for end of page/screen and give option to continue or quit
 I ($P(IOST,"-")["C")&('$D(IO("Q")))&(IO=IO(0))&(INPAGE>0) Q:$G(DUOUT)  D
 .I $Y<(IOSL-3) D
 ..F X=$Y:1:(IOSL-4) W !
 .I $G(INNOOUT) W ! D ^UTSRD("Press <RETURN> to continue;;;;;;;0;;;;DTIME;;X","","",1)
 .E  W ! D ^UTSRD("Press <RETURN> to continue or ^ to quit;;;;;;;0;;;;DTIME;;X","","",1) S:(X=1)!(X=2) DUOUT=1
 Q:$G(DUOUT)
 ; Display new page and header
 S INPAGE=INPAGE+1 W @IOF
 S INA=0 F  S INA=$O(HDR(INA)) Q:'INA  U IO W !,@HDR(INA)
 Q
 ;
HSET ; set up header
 ;
 ; Description: The function HSET is used to set up the header with
 ;  the current page and current date/time.
 ;
 ; Return: None
 ; Parameters: None
 ;
 ; Code Begins:
 D NOW^%DTC S Y=$J(%,12,4) D DD^%DT S INDT=Y
 S HDR(1)="""SCRIPT GENERATOR MESSAGE LISTING"",?(IOM-30),INDT,?(IOM-10),""PAGE: "",INPAGE"
 S HDR(2)="""Message: "",INAM"
 S HDR(3)="",$P(HDR(3),"-",IOM-1)="",HDR(3)=""""_HDR(3)_""",!"
 Q
 ;
INDXS ; Build array DXS
 ; Description: The function INDXS is used to build the DXS array of 
 ;  the MUMPS code to support for the INHMG, INHMG1 and
 ;  INHMG2 modules.  The MUMPS code will be used to search
 ;  the following globals ^INTHL7M, ^INTHL7S, ^INTHL7F 
 ;  for the segments, and fields of the selected Script 
 ;  Generator Message.
 ;
 ; Return: None
 ; Parameter:
 ;
 ; Code begins:
 K DXS
 ; Get the segment name
 S DXS(2,9.2)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S DIP(101)=$G(^INTHL7S(D0,0)) S X=$P(DIP(101),U,2) S D0=I(0,0)"
 ; Used as look up table for display purpose ( int val - ext val )
 ; Yes or No
 S DXS(18,0)="NO"
 S DXS(18,1)="YES"
 ; Processing ID
 S DXS(19,"D")="DEBUG"
 S DXS(19,"P")="PRODUCTION"
 S DXS(19,"T")="TRAINING"
 ; Look Up Parameter
 S DXS(20,"F")="FORCED LAYGO"
 S DXS(20,"L")="LAYGO ALLOWED"
 S DXS(20,"N")="NO LAYGO"
 S DXS(20,"O")="LOOKUP ONLY"
 S DXS(20,"P")="PARSE ONLY"
 ; Accept Acknowledge
 S DXS(21,"AL")="ALWAYS"
 S DXS(21,"ER")="ERROR/REJECT"
 S DXS(21,"NE")="NEVER"
 S DXS(21,"SU")="SUCCESS ONLY"
 ; Application Ack
 S DXS(22,"AL")="ALWAYS"
 S DXS(22,"ER")="ERROR/REJECT"
 S DXS(22,"NE")="NEVER"
 S DXS(22,"SU")="SUCCESS ONLY"
 Q
 ;
QUIT ;exit module
 ;
 ; Description: The function QUIT is used to close the ouput
 ;  device, reset IO variables back to the home
 ;  device and exit the module.
 ; 
 ; Return: None
 ; Parameters: None
 ;
 ; Code Begins: 
 ;
 D ^%ZISC K IO("Q"),IOP,POP
 Q
