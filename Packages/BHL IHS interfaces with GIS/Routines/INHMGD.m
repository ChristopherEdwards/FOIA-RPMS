INHMGD ;CAR; 1 Aug 97 10:23;HL7 MESSAGING - MANAGEMENT OF DATA SOURCES
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: HL7 Message Data Sources utility (INHMGD)
 ;
 ; PURPOSE:
 ; Module INHMGD is used to extract information describing the
 ; source file and field for HL7 Messages, or to list all Messages
 ; that reference a specific field.
 ;
 ;DESCRIPTION:
 ;This routine prompts the user for a HL7 Message Name, then displays
 ;the associated Segments and for each segment, display the Fields
 ;and the data address for each Field.  Alternatively, the user can
 ;request that a listing for all messages be sent to a file.  Or, the
 ;user can request a sensitivity analysis where the user supplies a
 ;data address, and the routine lists all of the messages that
 ;reference that address.
 ;
 ;ENTRY POINTS:
 ;  EN  = Extract source data addresses for specific messages.
 ;  EN1 = List messages referencing a specific data address.
 ;
 ; Return: None
 ; Parameters: None
 ;
EN ; Entry point for the HL7 Message Data Sources utility
 K INSENS N INSENS S INSENS=0
 ;
EN1 ; Entry point for the HL7/CHCS Field Sensitivity Analysis
 I '$D(INSENS) N INSENS S INSENS=1
 N DIC,INALL,INAM,INCSG,INDA,POP,INQUIT
 K DUOUT,POP,DIC
 ;
 ;new leftover variables
 N %,%Y,%DT,DA,DICOMPX,DIJC,DIRCP,DIRI,DIRMAX,DOY,DQI,DUOUT,INEXIT,INFIN,INFLD,J,X,Y,INPERR,INEOR
 S (INEXIT,INQUIT)=0,INCSG=1 ;INCSG=flag for Print common segments?
 ;
 ;All fields/messages?
 S INALL=$$INALL($S(INSENS:"mapped fields",1:"messages")) Q:INEXIT
 ;
 ;Else  Ask for field/message names
 I 'INALL D  Q:$G(DUOUT)!INQUIT
 .;query user for fields to lookup in sensitivity analysis
 .I INSENS D SENSINP^INHMGD5(.INSENS) Q
 .;OR, for message name, then DIC lookup for the IEN
 .S DIWF="",DIC="^INTHL7M(",DIC(0)="AEQ"
 .S DIC("A")="SELECT SCRIPT GENERATOR MESSAGE: "
 .D ^DIC I Y>0 S INAM=$P(Y,U,2),INDA=+Y Q
 .S INQUIT=1
 ;
 ;If not sensitivity analysis, ask: include the common segments?
 I 'INSENS S INCSG=$$COMMON Q:INEXIT
 ;
 ;Print lookup errors?
 S INPERR=$$INPERR Q:$G(DUOUT)
 I 'INALL,'INPERR,INSENS,'$O(INSENS(0)) Q  ;nothing to do
 ;
 ;set up Device handling:
 N %ZIS,INHDR,INP,ZTDESC,ZTIO,ZTRTN,ZTDTH,ZTSAVE
 K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ"
 D ^%ZIS I POP S IOP="",%ZIS="" D ^%ZIS U IO K IO("Q"),IOP,POP Q
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 ;
 ;Ask user, "Write an abbreviated copy of the output to a file?"
 S INP=0 I 'INSENS,'INPERR,ION[".DAT" S INP=$$TABOUT Q:INEXIT
 ;
 ;queue job up for a printer or send to a file:
 I IO'=IO(0) D  S IOP="",%ZIS="" D ^%ZIS U IO K IO("Q"),IOP,POP Q
 .S ZTDESC="HL7 Data Source Management"
 .S ZTRTN="ENQUE^INHMGD"
 .S ZTIO=IOP
 .;S ZTDTH=$H,$P(ZTDTH,",",2)=$P(ZTDTH,",",2)+5
 .F X="INALL","INAM","INDA","INCSG","INP","INSENS","INSENS(","INPERR" S ZTSAVE(X)=""
 .D ^%ZTLOAD
 ;
 ;else, fall through to Taskman entry point and send output to user
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP D  S IOP="" D ^%ZIS U IO K POP Q
 .W *7,!,"Sorry, unable to find device..."
 ;
ENQUE ;Taskman entry point
 ;where INAM [ Message Name and INDA [ IEN of that message.
 K ^UTILITY("INHMGD",$J) ;just in case we did ^C out last time.
 N INDATA,INDT,INOFF,INEXIT,INDHT,INERN,INJ,INHDR
 N INMODE,INPAGE,INPARS,INTRP,DATA,INX,J,K,INQ,FILE,FLVL,INS2,ING
 ;
 S (ING,INERN)=0
 I IOM=132 S ING=IOM-12 N IOM S IOM=ING,ING=8
 ;setup for field column (see INHMGD4 for remainder of columns)
 S INS2=$S(IOM>90:58,1:47)+ING ;start of column2
 ;
 S INDA=$G(INDA,0),INAM=$G(INAM),INALL=$G(INALL,0)
 S INP=$G(INP),IOP=$G(IOP),INSENS=$G(INSENS),INPAGE=""
 ;
 S INEXIT=0
 S INDT=$$CDATASC^UTDT($H,1,1)
 S INOFF=$S(IOM>80:IOM-80,1:0) ;printing offsets based on width IOM
 ;
 ;if we are printing all (INALL>0) messages, then:
 I 'INSENS,INALL N INDA S INAM="" D  Q:INEXIT
 .F  S INAM=$O(^INTHL7M("B",INAM))   Q:INAM=""!INEXIT  D
 ..S INDA=0 F  S INDA=$O(^INTHL7M("B",INAM,INDA)) Q:'INDA  D
 ...I "TESTPROTO"[$P(^INTHL7M(INDA,0)," ") Q
 ...D IN^INHMGD1(INDA,.INP)
 ;
 ;we are not printing all messages, just one.
 I 'INSENS,'INALL D IN^INHMGD1(INDA,.INP) Q:INEXIT
 ;
 ;is this a SENSITIVITY ANALYSIS?
 I INSENS D
 .D INSUPDT^INHMGD6
 .D INSPRNT^INHMGD8(.INSENS,INALL)
 ;
 ;Print *****End of Report***** and pause to let user read last page
 S INEOR="*****End of Report*****"
 I INPAGE,'INP,'INEXIT D
 .S (INHDR(4),INDATA)="$C(32)" F INJ=1:1:3 D INW^INHMGD8(INJ=1)
 .S INDATA="$$DASH^INHMGD1(IOM-$L(INEOR)\2,"" "")_INEOR" D INW^INHMGD8(0)
 .;pause to let user read last page
 .I $E(IOST)="C",'$D(IO("Q")),IO=IO(0) S DUOUT=$$CR^UTSRD
 ;
 ;Print Errors?
 I INPERR,'INEXIT D INPERR^INHMGD9
 K ^UTILITY("INHMGD",$J)
 ;
 D ^%ZISC
 Q
 ;
INALL(UNITS) ;do you want all (fields/messages)?
 N INHLP,X
 S INHLP="Answer ""Y"" to display all "_UNITS
 S INHLP=INHLP_", ""N"" to select individual "_UNITS_"."
 S X=$$YN^UTSRD("Do you wish to print ALL "_UNITS_"? ;0",INHLP)
 I $P(X,U,2)]"" S INEXIT=1
 Q X
 ;
COMMON() ;do you want the common segments?
 N INHLP,X
 S INHLP="Do you want to include the Message Header segment (MSH) "
 S INHLP=INHLP_"and the Patient ID segment (PID)?"
 S X=$$YN^UTSRD("Include the COMMON SEGMENTS (MSH and PID)? ;0",INHLP)
 I $P(X,U,2)]"" S INEXIT=1
 Q X
 ;
INPERR() ;do you want to print any lookup errors?
 N INHLP
 S INHLP="Lists non-existant CHCS fields and multiply defined HL7 Message Segments"
 S X=$$YN^UTSRD("Print ""Lookup Errors"" listing? ;0",INHLP)
 I $P(X,U,2)]"" S INEXIT=1
 Q X
 ;
TABOUT() ;set up the output for exporting as a tab-delimited file?
 N INHLP,X
 S INHLP="A tab-delimited VMS file can be easily imported into desk-top applications."
 S X=$$YN^UTSRD("Do you want this file to be tab-delimited? ;0",INHLP)
 I $P(X,U,2)]"" S INEXIT=1
 Q X
 ;
