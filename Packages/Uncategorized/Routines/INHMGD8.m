INHMGD8 ;CAR; 25 Apr 97 16:56;HL7 MESSAGING - PRINT SENSITIVITY ANALYSIS
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME:
 ; HL7 Messaging - Print Sensitivity Analysis (INHMGD8).
 ;
 ; PURPOSE:
 ; Module INHMGD8 is used to print a Sensitivity Analysis
 ;
INSPRNT(INSENS,INALL) ;Print the data
 ;Print from an array of requested file,field pairs or print ALL
 ;  e.g.  INSENS(2,.03)="",INSENS(2,.04)="",...INSENS(8550,.01)=""
 ;Inputs:
 ;  INSENS      = 1 for Sensitivity Analysis (SA), 0 for no (SA)
 ;  INSENS(n,m) = array of requested file,field pairs
 ;  INALL       = 1 for SA for ALL, 0 for not ALL
 ;
 N IN7F,IN7M,IN7S,IND,INDATAA,INQ,INFIL,INFILT,INFLD,INFLDT
 N INFSO,INHDR,INIOM2,INIOM3,INJ,INMAX,INWAIT,INH
 ;
 U IO
 S INDATA="$C(32)"
 ;
 ;setup some text constants
 S INH(1)="HL7 Messaging Data Sources"
 S INH(2)=" Sensitivity Analysis"
 S INH(3)="-----Corresponding HL7: Message/Segment/Field Names"
 ;
 D  ;setup Data printing format, based on page width (IOM)
 .;------------------------------------------------------------
 .I IOM<96 D  Q  ;set up for an 80 character line
 ..S IND(1)="$E(""   ""_IN7M,1,60)"
 ..S IND(2)="$E(""      ""_IN7S,1,42),?44,$E(IN7F,1,36)"
 ..;S IND(3)="$C(32)"
 .;------------------------------------------------------------
 .I IOM<132 D  Q  ;set up for a 96 character line
 ..S IND(1)="$E(""   ""_IN7M,1,60)"
 ..S IND(2)="$E(""      ""_IN7S,1,45),?48,$E(IN7F,1,48)"
 .;------------------------------------------------------------
 .;IOM is 132; set up for a 132 character line
 .S IND(1)="$E(""    ""_IN7M,1,44),?46,$E(IN7S,1,42),?90,$E(IN7F,1,42)"
 ;
 ;setup header lines
 S INHDR(1)="INH(1),INH(2),?(IOM-30),INDT,?(IOM-10),""PAGE: "",INPAGE"
 S INHDR(2)="""Field#/Name"",?$S(IOM>96:IOM\3+2,IOM>80:IOM\2-3,1:IOM\2-3),""File Number/Name"""
 S INHDR(3)="INH(3)_$$DASH^INHMGD1(IOM-54)"
 S INHDR(4)="INFLD_""  "",?6,INFLDT,?$S(IOM>96:IOM\3,1:IOM\2-5),""  File: ""_$J(INFIL,7)_""  ""_INFILT"
 ;
 ;begin printing
 ;
 ;check for individual file,field SA
 I $O(INSENS(0)),'INALL D
 .S INFIL=0 F  S INFIL=$O(INSENS(INFIL)) Q:'INFIL!$G(DUOUT)  D
 ..S INFLD=0 F  S INFLD=$O(INSENS(INFIL,INFLD)) Q:'INFLD!$G(DUOUT)  D
 ...S INFILT=$P($G(^DIC(INFIL,0)),U)
 ...S:INFILT="" INFILT=$P($G(^DD(INFIL,0)),U)
 ...S INFLDT=$P($G(^DD(INFIL,INFLD,0)),U)
 ...D PHEADER(4,.INHDR)
 ...S INQ="^UTILITY(""INHMGD"","_$J_",""A"","_INFIL_","_INFLD_")"
 ...F  S INQ=$Q(@INQ) Q:$QS(INQ,4)'=INFIL!($QS(INQ,5)'=INFLD)!$G(DUOUT)  D
 ....S IN7F=$P($G(^INTHL7F(+$QS(INQ,6),0)),U) Q:$$INERS(3)
 ....S IN7S=$P($G(^INTHL7S(+$QS(INQ,7),0)),U) Q:$$INERS(4)
 ....S IN7M=$P($G(^INTHL7M(+$QS(INQ,8),0)),U) Q:$$INERS(5)
 ....S INJ=0 F  S INJ=$O(IND(INJ)) Q:'INJ  D
 .....S INDATA=IND(INJ) D INW(INJ=1)
 ;
 ;check for SA on ALL file,field pairs
 I INALL D
 .S INFSO=0 ;store the old sum (should change with new INFIL or INFLD)
 .S INQ="^UTILITY(""INHMGD"","_$J_",""A"")"
 .F  S INQ=$Q(@INQ) Q:$QS(INQ,3)'["A"!$G(DUOUT)  D
 ..S INFIL=$QS(INQ,4) Q:$$INERS(1)
 ..S INFLD=$QS(INQ,5) Q:$$INERS(2)
 ..I INFIL+INFLD'=INFSO D
 ...S INFILT=$P($G(^DIC(INFIL,0)),U)
 ...S:INFILT="" INFILT=$P($G(^DD(INFIL,0)),U)
 ...S INFLDT=$P($G(^DD(INFIL,INFLD,0)),U)
 ...D PHEADER(4,.INHDR)
 ..S INFSO=INFIL+INFLD
 ..S IN7F=$P($G(^INTHL7F(+$QS(INQ,6),0)),U) Q:$$INERS(3)
 ..S IN7S=$P($G(^INTHL7S(+$QS(INQ,7),0)),U) Q:$$INERS(4)
 ..S IN7M=$P($G(^INTHL7M(+$QS(INQ,8),0)),U) Q:$$INERS(5)
 ..S INJ=0 F  S INJ=$O(IND(INJ)) Q:'INJ  D
 ...S INDATA=IND(INJ) D INW(INJ=1)
 K INSENS
 Q
 ;
INERS(J) ;check for error, and if in error, log it.
 ; Input:
 ;   INN = error to check for
 ; Output:
 ;   Integer: 1=error found, 0=no error found
 ; Purpose: check for specific errors. e.g. J=2:check that INFLD has
 ;   a numeric value, J=4:see if IN7S is nil.
 ;
 N INQ
 S INQ=$S(J=0:0,J=1:'INFIL,J=2:'INFLD,J=3:IN7F="",J=4:IN7S="",J=5:IN7M="",1:1),INERN=INERN+.001
 S:INQ ^UTILITY("INHMGD",$J,"E",+IN7M,+IN7S,+IN7F)=+INFIL_U_+INFLD
 Q INQ
 ;
INW(INTOP) ;Write the Data
 ; Inputs:
 ;   INTOP  = flag, 1 = check if new page needed
 ;   INDATA = input print data
 ; Outputs:
 ;   DUOUT  = returns an exit request when user "^" out
 ;   INDATA = reset to """ """
 ;
 Q:$G(DUOUT)
 S INTOP=$G(INTOP)
 ;
 ;check for room left on this page
 I INTOP,(IOSL-$Y)<4 D PHEADER(1,.INHDR)
 ;
 W !,?ING,@INDATA S INDATA="$C(32)"
 Q
 ;
PHEADER(INLN,INHDR) ;print the header
 ; Inputs:
 ;   INLN    = where to start printing the header array
 ;             skips printing date & page# if you start at 2
 ;   INHDR   = header array
 ;    INFLD  = used in INHDR(4) - Field Number
 ;    INFLDT = used in INHDR(4) - Field Name
 ;    INFIL  = used in INHDR(4) - File Number
 ;    INFILT = used in INHDR(4) - File Name
 ;   INPAGE  = page number of last previous page
 ; Outputs:
 ;   INPAGE  = page number used on this page
 ;
 N INK
 I '$D(INHDR) D
 .F INK=1:1:4 S INHDR(INK)=$G(INHDR(INK))
 .S INHDR(10)="$$DASH^INHMGD1(IOM-3)"
 ;
 ;1st page need line 1 of the header
 I 'INPAGE S INLN=1
 ;
 ;make sure there is room left on this page
 I (IOSL-$Y)<(6-INLN) S INLN=1
 ;
 ;if we are printing line 1 of the header, it means we need a new page
 ;also, if we are interactive, wait at the end of the page
 I INLN=1 S INPAGE=INPAGE+1 I INPAGE>1,$E(IOST)="C",'$D(IO("Q")) D
 .I IO=IO(0) S DUOUT=$$CR^UTSRD
 ;
 ;need new page with new header?
 I INLN=1 W @IOF N INK S INK=0 F  S INK=$O(INHDR(INK)) Q:INK>10!'INK  D
 .W !,?ING,@INHDR(INK)
 ;
 ;just the header
 I INLN'=1 N INK S INK=3 W ! F  S INK=$O(INHDR(INK)) Q:INK>9!'INK  D
 .W !,?ING,@INHDR(INK)
 Q
 ;
