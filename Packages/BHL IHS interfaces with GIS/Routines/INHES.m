INHES ;KN; 6 Mar 96 14:10; Interface Error Summary 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: INTERFACE ERROR SUMMARY (INHES)
 ;
 ; PURPOSE: 
 ; The purpose of the Interface Error Summary is to get user/programmer
 ; a summary report of the interface error in a given period of time.
 ; Based on user's select criteria, the report will search the Interfa-
 ; ce Error File, collect all the messages matching the given criteria.
 ; The report will group the error messages according to user's input
 ; text length.  The error count, total and also the first and last
 ; of the error occurs are included in the summary report.
 ;
 ; DESCRIPTION:
 ; The processing of this routine will ask user for start date, optional
 ; end date, and a summary or detail report.  A summary report will also
 ; require text length input ( the default length is set at 30 charactor)
 ; Programmer call is invoke by calling PGUSE^INHES.  (ARNAME) where
 ; ARNAME is the name of array that will contains the error text, the
 ; count, as well as the IEN of the first and last of the error occurs 
 ; are included in the summary report.
 ;
 ; 
 ; Return: None
 ; Parameters: 
 ; 
 ; Code begins: 
ENUSE ; User's entry point for the Interface Error Summary 
 ;
 ; Description:  The ENUSE entry point is used for accepting
 ;   user's input message.  The user is presented with
 ;  a criteria selection screen.  User can select a
 ;  summary report of various error text lenght, or a
 ;  detail listing of all the error messages in a given
 ;  period of time.
 ;
 ; Return: None
 ; Parameters: None   
 ;        
 ; Code begins:
 ;
 N %ZIS,A,EXIT,HDR,INPAGE,X,ZTDESC,ZTIO,ZTRTN,ZTSAVE
 D SEARCH^INHES2
 G QUIT
 ;
PGUSE(INKA) ; Programmer input
 ;
 ; Description:  The PGUSE entry point is used for accepting
 ;  programmer's call to interface error summary report.
 ;
 ; Return: None 
 ;
 ; Parameters: 
 ; INKA: array contains the results, which are the error text,
 ;        count, first and last occurence IEN.
 ;       
 ; Code begins:
 ;
 N INQUIT,PROG
 ; set programmer input flag PROG, and display criteria select sreen
 S PROG=1,INQUIT=$$BGNSRCH^INHERR(.INSRCH,0,"","",1)
 G QUIT
 ;
QUEUE(INSRCH) ;Device handling & Tasking logic
 ; return array INKA for programmer use
 I $D(PROG) D  Q
 . S INKL="INARIEN"
 .; get IEN for array of errors matching selected criteria
 . K @INKL D LIST^INHES1(.INSRCH,.INKL,.INARIEN)
 .; return array INKA which contains error text, count, first and last
 .; occurence IEN
 . D INSUMP^INHES2(.INSRCH,.INKL,.INKA)
 ; display/print summary report for user
 N INSRSZ S INSRSZ=$$SRCHSIZE^INHERR4(.INSRCH,"^INTHER(""B"")")
 Q:INSRSZ<0
 W !,INSRSZ," MESSAGES TO SEARCH.",!
 S INSRCH("TOTAL")=INSRSZ
 ;
 K IOP S %ZIS("A")="DEVICE: ",%ZIS("B")="",%ZIS="NQ" D ^%ZIS G:POP QUIT
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." G QUIT
 I IO'=IO(0) S ZTDESC="Description of job",ZTIO=IOP,ZTRTN="ENQUE^INHES" D  G QUIT
 .F X="U","IO*","D*","HDR(","INPAGE","INSRCH(" S ZTSAVE(X)=""
 .D ^%ZTLOAD
 ;
ENQUE ; Taskman entry point
 ;
 ; Description:  ENQUE is the entry point for Taskman.  It will call
 ;  module INSUM for the interface summary report
 ; 
 ; Return: None
 ; Parameter: None
 ; 
 ; Code begins:  
 ;
 S INPAGE=0,EXIT=0
 N INQUIT,INKL
 S INQUIT=0,INKL="INARIEN"
 ; INKL is the array that contains the IEN of all the error messages
 ; which match the user select criteria.
 K @INKL D LIST^INHES1(.INSRCH,.INKL,.INARIEN)
 ; at this point all found IEN are in INARIEN array
 D INSUM^INHES2(.INSRCH,.INKL) K @INKL,INKL
 G QUIT
 ;
HEADER ; Output header in local array HDR(x)
 ;
 ; Description: The function HEADER is used to display header when
 ;  reaching the end of page/screen, and give user the
 ;  option to continue or to abort.
 ;
 ; Return: None
 ; Parameters: None
 ;
 ; Code begins:
 N INA
 ; Check for end of page/screen and give option to continue or quit
 I ($P(IOST,"-")["C")&('$D(IO("Q")))&(IO=IO(0))&(INPAGE>0) Q:$G(DUOUT)  D
 .W ! D ^UTSRD("Press <RETURN> to continue or ^ to quit;;;;;;;0;;;;DTIME;;X","","",1) S:(X=1)!(X=2) DUOUT=1
 Q:$G(DUOUT)
 ; Display new page and header
 S INPAGE=INPAGE+1 I (INPAGE>1)!($P(IOST,"-")["C") W @IOF
 F INA=1:1:3 W @HDR(INA)
 ; Display criteria header on page 1
 I INPAGE=1 D CRIHDR^INHES1(.INSRCH)
 S INA=3 F  S INA=$O(HDR(INA)) Q:'INA  U IO W !,@HDR(INA)
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
 ;
 ; Initialize site name and today date
 S INSITE=$S($D(^DIC(4,^DD("SITE",1),0)):^(0),1:^DD("SITE")),INSITE=$S($P(INSITE,"^",4)]"":$P(INSITE,"^",4),1:$P(INSITE,"^",1))
 I '$D(INDT) D NOW^%DTC S Y=$J(%,12,4) D DD^%DT S INDT=Y
 ; calculate start and stop date for header
 S Y=$G(INSRCH("INSTART"))+.000001,INTY=Y\1
 I Y-INTY>.0001 S Y=$J(Y,12,4)
 E  S Y=Y\1
 D DD^%DT S INSD=$G(Y)
 S Y=$G(INSRCH("INEND")),INTY=Y\1
 ; delete the seconds resolution
 I Y-INTY>.00009 S Y=Y-.000099
 ; no hhmm for end date
 I Y-INTY>.99 S Y=Y-.9999
 D DD^%DT S INED=$G(Y)
 ; format the header
 S HDR(1)="INSITE,?(IOM-30),INDT,?(IOM-10),""Page: "",INPAGE"
 S HDR(2)="!!?(IOM-36)/2,""INTERFACE ERROR SUMMARY REPORT"""
 S HDR(3)="!?(IOM-48)/2,""From : "",INSD,""     To : "",INED,!"
 S HDR(4)="",$P(HDR(4),"-",IOM-1)="",HDR(4)=""""_HDR(4)_""""
 S HDR(5)="""Count    Error Text"""
 S HDR(6)="?5,"" Occurence"",?45,""Message ID"""
 S HDR(7)="?5,""Tran. Type"",?45,""Error Loc"",!?5,""Destination"",?45,""Backgrnd Proc"""
 S HDR(8)="",$P(HDR(8),"-",IOM-1)="",HDR(8)=""""_HDR(8)_""""
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
