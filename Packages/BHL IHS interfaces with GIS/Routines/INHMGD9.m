INHMGD9 ;CAR; 15 May 97 14:57;HL7 MESSAGING - PRINT LOOKUP ERRORS
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME:
 ; HL7 Messaging - Print Lookup Errors (INHMGD9).
 ;
 ; PURPOSE:
 ;  Module INHMGD9 is used to print a listing of the lookup errors
 ;  encountered while building the ^UTILITY("INHMGD",$J,"A") table
 ;  for Sensitivity Analysis
 ;
INPERR ;Print the Lookup Errors
 ;Print list of lookup errors from ^UTILITY("INHMGD",$J,"E")
 ;Inputs:
 ;   INPERR takes no inputs.  When started, it goes to
 ;   ^UTILITY("INHMGD",$J,"E") and lists all of the errors found.
 ;
 S INPAGE="" K INHDR
 ;quit if no errors
 I '$D(^UTILITY("INHMGD",$J,"E")) Q
 ;
 N IN7F,IN7FT,IN7FET,IN7M,IN7MT,IN7S,IN7ST,IN7SET
 N INAM,IND,INF,INFIL,INFLD,INHP,INT,INT0,INTEXT,INX
 ;
 ;begin printing Lookup Error Report
 ;All of the errors which are logged, are handled in roughly the same
 ;way.  An entry is made under ^UTILITY("INHMGD",$J,"E",I1,I2,I3)=data
 ;where I1=Message IEN, I2=Segment IEN and I3 (if available)=Field IEN.
 ;Where I3 is not available, an incrementing counter is used.
 ;"data" is composed of File#_^_Field#_error_message.
 ;
 S INHP=0 ;flag: page header not setup
 S INT=$S(IOM>80:48,1:40)
 S INQ="^UTILITY(""INHMGD"","_$J_",""E"")"
 F  S INQ=$Q(@INQ) Q:$QS(INQ,3)'["E"!$G(DUOUT)  D
 .I 'INHP D
 ..D SETHDR(.INHDR) S INHP=1 ;setup header
 ..D PHEADER^INHMGD8(4,.INHDR) ;print a header (full header if page="")
 .;now, handle errors
 .;extract Message, Segment and Field numbers.
 .S IN7M=$QS(INQ,4),IN7S=$QS(INQ,5),IN7F=$QS(INQ,6)
 .;get data: Root File# | Field "C" data.
 .S IN7FET=@INQ,INAM=+IN7FET,INFC=$P(IN7FET,U,2)
 .;message name
 .S IN7MT=""
 .I IN7M,$D(^INTHL7M(IN7M,0)) D  Q:$E(IN7MT,1,2)'="HL"
 ..S IN7MT=$P($G(^INTHL7M(IN7M,0)),U)
 .;segment name
 .S IN7ST=""
 .I IN7S,$D(^INTHL7S(IN7S,0)) S IN7ST=$P($G(^INTHL7S(IN7S,0)),U)
 .;field name
 .S IN7FT="",INT0=INT
 .I IN7F<1 S IN7F="Field N/A",INT0=15
 .I IN7F,$D(^INTHL7F(IN7F,0)) S IN7FT=$P($G(^INTHL7F(IN7F,0)),U)
 .;
 .S INDATA="IN7M_""  ""_IN7MT,?INT,IN7S_"" "",?INT,IN7ST"
 .D INW^INHMGD8(1)
 .S INDATA="?3,IN7F_""  "",IN7FT,?INT0,INAM_""  ""_INFC,!"
 .D INW^INHMGD8(0)
 ;
 ;print *****End of Report*****, and pause to read.
 S INHDR(4)="$C(32)" F INJ=1:1:3 D INW^INHMGD8(INJ=2)
 S INDATA="$$DASH^INHMGD1(IOM-$L(INEOR)\2,"" "")_INEOR" D INW^INHMGD8(0)
 I $E(IOST)="C",'$D(IO("Q")),IO=IO(0) S DUOUT=$$CR^UTSRD
 Q
 ;
SETHDR(INHDR) ;Setup header lines
 ; Input & Output:
 ;   INHDR   =header text array
 ;
 S INHDR(99)="HL7 Messaging Data Sources - Lookup Errors"
 S INHDR(1)="INHDR(99),?(IOM-30),INDT,?(IOM-10),""PAGE: "",INPAGE"
 S INHDR(4)="""IEN/Message Name"",?INT,""IEN/Segment Name"""
 S INHDR(5)="""   IEN/Field Name"",?INT,""Root/DATA LOCATION or Error"""
 S INHDR(10)="$$DASH^INHMGD1(IOM-3)"
 Q
 ;
