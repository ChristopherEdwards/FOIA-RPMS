INHMGD1 ;CAR; 15 May 97 12:22;HL7 MESSAGING - MANAGEMENT OF DATA SOURCES
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME:
 ; HL7 Messaging - Data Source Display and Validation
 ;                 Handle Field (INHMGD1).
 ;
 ; PURPOSE:
 ; Module INHMGD1 is used to extract information describing the
 ; source file and field for HL7 Messaging segment fields.
 ;
IN(INDA,INP) ;Entere here with INDA= ien of message to process one message.
 ; Input:
 ;   INDA = Internal Entry Number (IEN) of message
 ;   INP  = Flag, +INP>0 means create tab-delimited output,
 ;          for exporting to desk-top applications, like MS-Access.
 ;          Also, $E(INP,2,999) contains tab delimited Message and
 ;          Segment information.  Will be copied to INPDATA for printing.
 ;
 Q:'INDA
 N INMSG S INMSG=INDA
 ;Get message zero node, root#, and the root# & global name
 S INMSG(0)=$G(^INTHL7M(INMSG,0)) Q:INMSG(0)=""
 ;Quit on Inactive Message, if called from INALL
 I INALL=1 Q:$P(INMSG(0),U,8)
 ; 
 N FIELD,FILE,FLVL,INHF2,IDENT,INAUDIT
 N INDB,INDTY,INEX,INDATA,INS,INSEQ,INSEG,INSG,INSYS
 N INX,INREPEAT,INREQ
 N INSVAR,TAB
 ;
 ;Initializations: NOTE: many of the following lines were copied
 ;from the input script generator routine, INHSGZ2.
 S (FLVL,IDENT,INREPEAT)=0
 ; FILE     = Root file number from piece 5 of INMSG(0)
 ; FILE(0)  = (Root file number)^^(Global Name)
 S FILE=+$P(INMSG(0),U,5) Q:'FILE
 Q:'$D(^DIC(+FILE,0,"GL"))  S FILE(0)=FILE_U_^("GL")
 ;
 ;initialize abbreviated data listing
 S TAB=$C(9)
 S INP=$G(INP,0) I INP S INP="1"_$P(INMSG(0),U) ;$P 1
 ;
 ;You don't really need INSYS and INAUDIT, but it can't hurt.
 S INSYS=$$SC^INHUTIL1,INAUDIT=0
 S INEXIT=0
 ;
 ;BEGIN OUTPUT:
 ;Display header page(s) for this message
 D HSET ;setup 3 line header
 D PAGE1^INHMGD11(INMSG,INMSG(0),.INHDR)
 ;
 S INTRP=$G(^INTHL7M(INMSG,"S")) ;get script pointers
 S INMODE=$S($P(INTRP,U,2):1,1:0) ;incoming (0) or outgoing (1) message
 S INPARS=$S($P(INMSG(0),U,7)="P":1,1:0) ;is parse only set
 S INAM=$P(INMSG(0),U) ;the name of this message
 ;
 ;Order through the segments for this message using the "AS" x-ref.
 S INSEQ=""
 F  S INSEQ=$O(^INTHL7M(INMSG,1,"AS",INSEQ)) Q:'INSEQ!INEXIT  D
 .S INX=0
 .F  S INX=$O(^INTHL7M(INMSG,1,"AS",INSEQ,INX)) Q:'INX!INEXIT  D
 ..S INSEG(1)=^INTHL7M(INMSG,1,INX,0)
 ..;skip parent segments, they will be called recursively from SEG^
 ..I '$P(INSEG(1),U,11) D SEG^INHMGD2(INX,.FLVL,.FILE,.INP,.INERN)
 Q
 ;
DASH(QTY,CH) ;Extrensic.  Creates QTY copies of CH
 ; Inputs:
 ;   QTY = numeric integer, how many copies of CH do you want in the
 ;         output string.
 ;   CH  = character you want repeated.  defaults to "-", hence the
 ;         name DASH, but " " or anything else is ok.
 ; Output:
 ;
 N DASH S CH=$G(CH,"-"),$P(DASH,CH,QTY+1)=""
 Q DASH
 ;
HSET ;set up header
 ; No Parameters.
 ; Description:  The function HSET is used to set up the header with
 ;               the current page and current date/time.
 ; Return:
 ;   globally creates the INHDR array, containing quoted DATA strings
 ;   for use by WRITE^INHMGD1.
 ;
 ; Code Begins:
 S INHDR(1)="""HL7 Messaging Data Source"",?(IOM-30+ING),INDT,?(IOM-10+ING),""Page: "",INPAGE"
 S INHDR(2)="""Message: "",INAM"
 S INHDR(3)=""""_$$DASH(78+INOFF)_""""
 Q
 ;
HEADER ;output header in local array INHDR(x)
 ; No Parameters.
 ; Description:  The function HEADER is used to display the header
 ;               when reaching the end of the page/screen, and give
 ;               the user the option to continue or to abort.
 ;
 N INA,X
 Q:$L($G(INP))>1
 Q:INEXIT
 ; Check for end of page/screen and give option to continue or quit
 I $E(IOST)="C",'$D(IO("Q")),IO=IO(0),INPAGE D
 .;
 .I $Y+2<IOSL F X=$S(IOSL>24:1,1:$Y):1:$S(IOSL>24:4,1:21) W !
 .Q:$Y+9<IOSL
 .S INEXIT=$$CR^UTSRD
 I INEXIT W @IOF Q
 ;Display new page and header
 S INPAGE=INPAGE+1 W @IOF
 S INA=0 F  S INA=$O(INHDR(INA)) Q:'INA  W !,?ING,@INHDR(INA)
 S INHF2=$G(INHF2)
 S:INHF2=-1 INHF2=0
 D:INHF2 HDR2
 Q
 ;
HDR2 ;Header 2
 ; No Parameters.
 ; Output:
 ;   generates a DATA line for writing by WRITE^INHMGD1, with the
 ;   segment column labels.  Used after the segment header and on each
 ;   page after the page header.
 ; 12,"-" CHCS 11,"-"
 N DATA,X,X1
 ;
 S X=$S(INOFF:INOFF-11,1:0)
 S DATA="?0,""               R R L X"""
 S DATA=DATA_",?INS2-1,""------------ CHCS "",$$DASH((X)+14)"
 D WRITE
 S DATA="?0,""Seq#  Len  DT  q p k f  GIS Field Name"""
 S DATA=DATA_",?INS2-1,""Field#:File  """
 I IOM<96 S DATA=DATA_",""(Field Name)"""
 I IOM'<96 S DATA=DATA_",""    (Field Name)"""
 D WRITE
 S DATA=""""_$$DASH(78+INOFF)_"""" D WRITE
 S INHF2=0 ;means don't rewrite header
 Q
 ;
WRITE ;output a line
 ; Input:
 ;   DATA = passed globally, is a quoted line for use with W @DATA
 ;
 Q:INEXIT
 Q:INP
 I $Y>(IOSL-3) D HEADER
 W !,?ING,@DATA S DATA=""
 Q
 ;
YN(INV,INN) ;Extrensic.  Converts "" and 0 to NO and 1 to YES
 ; Inputs:
 ;   INV = the value ["",0,1] to be converted to YES/NO or Y/N
 ;   INN = control: 1 for "YES"/"NO", 0 for "Y"/"N"
 ;
 Q $E($S(INV="1":"YES",INV="0":"NO",1:INV),1,$S($G(INN):3,1:1))
 ;
LKPRM(INX) ;Extrensic.  Converts lookup parameter F,L,N,O & P to long form
 Q $S(INX="F":"FORCED LAYGO",INX="L":"LAYGO ALLOWED",INX="N":"NO LAYGO",INX="O":"LOOKUP ONLY",INX="P":"PARSE ONLY",1:INX)
 ;
