INHUT8 ;JPD, GD ; 13 Feb 97 11:34; ZIS AND DEVICE HELP FOR GIS  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
ZIS(INRTN,INVARS,INLIM,HDR,INIOM,INIOP) ;Main entry point
 ; Input: 
 ;  INRTN - routine/subroutine that does report output
 ;  INVARS-=Names of variables to pass ZTRTN. Separate names
 ;    with "^". Example: "INTS^INDA(^INTYPE". Or can be array by
 ;    ref. like the ZTSAVE taskman array.
 ;  INLIM - 0 - Allow Queing but not forced 1 - don't allow queing
 ;          2 - Force queing
 ;  INIOM - Width - Default=80
 ;  INIOP - Force Device selection - See Birp for IOP format
 ;NEW statements
 N %ZIS,A,COUNT,DATA,EXIT,HDR,LOOP,PAGE,X,ZTDESC,ZTIO,ZTRTN,ZTSAVE,IOP
 N DIC,Y
 S INLIM=+$G(INLIM),INIOM=+$G(INIOM),ZTRTN=$G(INRTN)
 S:'INIOM INIOM=80
 I $G(INIOP)'="" D
 .S IOP=INIOP,%=$P(IOP,";")
 .S %=$S(%="Q":3,%="SPOOL":3,$E(IOP,1,8)="Q;SPOOL;":4,1:2)
 .S:'$P(IOP,";",%) $P(IOP,";",%)=INIOM
 ;Device handling & Tasking logic
 S %ZIS("B")="",%ZIS="NQ"
 D ^%ZIS I POP S IOP="",%ZIS="" D ^%ZIS K DTOUT D CLOSE Q
 ;Force to specified width even though user specified different
 S IOM=INIOM
 K ZTIO,ZTUCI,ZTDESC,ZTSK S IOP=ION_";"_$G(IOST)_";"_IOM_";"_IOSL
 ;
 I (INLIM'=1&$D(IO("Q")))!(INLIM=2) Q:IO=IO(0)  S ZTDESC="Description of job",ZTIO=IOP D  Q
 .D ZTSAVE
 .D ^%ZTLOAD
 .D CLOSE
 I INLIM=1,$D(IO("Q")) U 0 W !,"Queing not allowed with this option",!,"report will be sent directly to device",!,*7
 D OPENIT I POP D CLOSE Q
 I ZTRTN'="" D @ZTRTN
 D CLOSE
 Q
 ;
HEADER ;output header in local array HDR(x)
 N A
 I ($P(IOST,"-")["C")&('$D(IO("Q")))&(IO=IO(0))&(PAGE>0) R !,"Press <RETURN> to continue ",A:DTIME I A[U S EXIT=1 Q
 S PAGE=PAGE+1 W @IOF
 S A=0 F  S A=$O(HDR(A)) Q:'A  U IO W !,@HDR(A)
 Q
 ;
WRITE ;output a line
 I ($Y>(IOSL-3))&(PAGE>0) D HEADER
 Q:EXIT
 W !,@DATA
 Q
 ;
 ;
CLOSE ;exit module
 D ^%ZISC
 S IOP="",%ZIS="" D ^%ZIS U IO K IO("Q"),IOP,POP
 Q
ZTSAVE N I K ZTSAVE
 I $D(INVARS)<10 S INVARS=$G(INVARS) D  Q
 .F I=1:1 S %=$P(INVARS,U,I) Q:%=""  S ZTSAVE(%)=""
 S I="" F  S I=$O(INVARS(I)) Q:I=""  S ZTSAVE(I)=INVARS(I)
 Q
OPENIT ; Internal routine to open device
 S POP=0 S %ZIS="" D ^%ZIS
 I POP S IOP="" D ^%ZIS W *7,!?5,"Device busy."
 U IO
 Q
ZIS2(INDEV,INOUT,DWPNT) ;Lookup for device
 ;Input:
 ; INDEV - name of device selected by user
 ;Output:
 ; INOUT - Output from lookup
 ; DWPNT - if it exists will repaint screen
 ;
 N INLIST,%ZIS,POP,ION,IOP
 K %ZIS S %ZIS="N"
 S (INDEV,INOUT)=$G(INDEV)
 I INDEV="SPOOL" D  Q
 .D MSG^INTSUT2("Spool files not supported at this time")
 .S (INDEV,INOUT)=""
 Q:INDEV=""
 S IOP=INDEV
 D ^%ZIS S:'POP INOUT=$G(ION)_";"_$G(IOST)_";"_$G(IOM)_";"_$G(IOSL) I POP D
 .S INOUT=$$DISPDEV^%ZIS2(INDEV)
 .I INOUT="SPOOL" D
 ..D MSG^INTSUT2("Spool files not supported at this time")
 ..S INOUT=""
 S DWPNT=1
 ;kill this to prevent transparent print display on slave device
 ;K IO("S")
 D ^%ZISC
 Q
HELP ; This is help for the 'Device: ' prompt field.
 ; Local variables
 ;   INDEVTYP -- Used for determining whether user wants to see a list
 ;               all devices or just printers. Returned from HDASK^
 ;               0 = none, 1 - for printers only, 2 - for all devices 
 ;
 N INDEVTYP
 S INDEVTYP=$$HDASK()      ; Generate device type prompts.
 I INDEVTYP="^" Q  ;Timed out or '^' entered -- QUIT HELP
 Q:'INDEVTYP       ; INDEVTYP - 1 for printers, 2 - Yes answered to HDASK
 ; Display list of output devices if INDEVTYP not equal to 0
 D PRNTLST(INDEVTYP)
 Q
 ;
 ;--------------------------------------------------------------------
PRNTLST(INDTYPE) ;  Output list of printer devices
 ; Input:
 ;     INDTYPE --- Filter var used to determine list type.
 ; Local variables:
 ;  INDONE   -- Flag to test when done looping
 ;  INNOPRT  -- Flag used to ensure non-printer devices are not 
 ;              shown in list of devices.
 ;  INPRDEV  -- Used to get data piece to determine if a printer device.
 ;  INDEVNAM -- Name of device as listed in %ZIS cross-ref, 'B'.
 ;  INDEVNUM -- The number of the device as listed in ^%ZIS(1,DEVNUM.
 ;  INYLINE  -- Keeps track of Y-cordinate.
 ;  INNODE   -- Temp variable to hold node - less disk hits
 ;  INRESULT -- Var to check if user wants to ^ out.
 ;
 N INDONE,INPRDEV,INNOPRT,INDEVNAM,INDEVNUM,INYLINE,INNODE,INRESULT
 S INDEVNAM=0,INYLINE=-1,INDONE=0
 F  Q:INDONE  D
 .S INDEVNAM=$O(^%ZIS(1,"B",INDEVNAM))  ; Loop through cross-ref of
 .I '$L(INDEVNAM) S INDONE=1 Q          ; printer devices till end.
 .S INDEVNUM=$O(^%ZIS(1,"B",INDEVNAM,0))
 .; Piece 2 - is $I, for opening and closing devices
 .; Piece 2 = to 46 and 63 are magnetic devices.
 .I $L(INDEVNUM),$D(^%ZIS(1,INDEVNUM,0)),'($P(^(0),"^",2)=46!($P(^(0),"^",2)=63)) Q:'$T
 .S INNOPRT=0  ; Reset var on whether to skip non-printer data entry
 .I INDTYPE=1 D  Q:INNOPRT   ; INDTYPE=1 -- Printer devices selected
 ..S INPRDEV=+$P(^%ZIS(1,INDEVNUM,0),"^",12)
 ..I '$D(^%ZIS(2,INPRDEV,0)) S INNOPRT=1 Q
 ..I ^%ZIS(2,INPRDEV,0)'?1"P".E S INNOPRT=1 Q
 .; Get the node all at once, only once.
 .S INNODE=^%ZIS(1,INDEVNUM,0)
 .; This piece is the device's name.
 .W ?2,$E($P(INNODE,"^",1),1,20)
 .; This piece is the location of the terminal.
 .W ?26,$E($P($G(^%ZIS(1,INDEVNUM,1)),"^"),1,35)
 .; Notify user that this device exist, but is out of service.
 .I $P(INNODE,"^",13) W "    ** OUT OF SERVICE **"
 .; Check to see if page displayed full yet.
 .W !  S INYLINE=INYLINE+1
 .I INYLINE>$S($D(DIJC("IOSL")):DIJC("IOSL"),1:20) D
 ..S INRESULT=$$MESS1^UTSRD("Press <RETURN> to continue, or '^' to Stop: ")
 ..W !
 ..I INRESULT=1 S INDONE=1 Q
 ..S INYLINE=-1 Q
 Q
 ;----------------------------------------------------------
HDASK() ;-- Writes the Question prompt to ask for Output Device
 ;  INCHOICE -- User choice for device type
 ;  INQUIT   -- Var set if user '^', or timed out
 ;              0 = normal exit
 ;              1,2,3 user responded by '^', or was too slow in choice
 ;
 N INCHOICE,INQUIT
 W !
 D ^UTSRD("Want a list of devices? (Yes/No/Printers) No// ;;;;;;;;;;;;1;INQUIT","","")
 S INCHOICE=X W !
 ; Check that user did not time out or hit '^'
 I INQUIT'=0 Q "^"
 ; Return users choice for device/printer selection
 Q $F("PpYy",$E(INCHOICE))\2
DISPDEV(XPARNAM,XX,XY,XD,XW,INPOS) ;old entry point for device help
 Q $$DISPDEV^%ZIS2(.XPARNAM,.XX,.XY,.XD,.XW,.INPOS)
