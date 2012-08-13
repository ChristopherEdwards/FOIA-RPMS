INHMGD4 ;CAR; 17 Sep 97 11:45;HL7 MESSAGING - MAIN DATA PRINTING ROUTINE
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME:
 ; HL7 Messaging - Main Data Printing Module (INHMGD4).
 ;
 ; PURPOSE:
 ; Collect previously stored data and display on chosen medium.
 ;
PRINT(INDL,INP) ;Print Routine
 ; Inputs:
 ;   INDL   = Data Loacation in the form "field#:file# (field name)"
 ;   INP    = Flag and Description Array for MS Access output.
 ;
 N INS1,INS3,INW1,INW3,INJ,INK,INEED,INAVL
 N INSV,INFN,INFLD,INFIL,INAME,INTXT,INDSC
 ;
 ;determine column starting positions based of width of page (IOM)
 S INS1=$S(INDENT:25,1:23)+ING ;start of column1
 ; INS2 is defined in INHMGD1
 S INW1=INS2-INS1+1-3 ;width of column1
 S INS3=INS2+$S(IOM<96:12,1:16) ;start of column3
 S INW3=IOM-INS3+1-4 ;width of column3
 ;
 ;BEGIN creating DATA line for output by WRITE^INHMGD1
 ;add segment ID#
 S INSV=$E(INSVAR,4,7),INSV=$P(INSV,".",2) S:$L(INSV) INSV="."_INSV
 S DATA="$J(INFD(""SQ""),3)_INSV" ;sequence# and segment ID#
 ;
 S DATA=DATA_",?ING+6,$J(INFD(""LEN""),3)" ;Field Length
 S DATA=DATA_",?ING+11,INFD(""DT"")" ;Data Type abbreviation
 S DATA=DATA_",?ING+15,INREQ,?ING+17,INREP,?ING+19,INUFL,?ING+21,XFM" ;required, repeating...
 ;
 ;add the HL7 field name to DATA
 S DATA=DATA_",?INS1"
 D WRAPS^INHMGD11(INFD("FN"),.INFN,INW1)
 S DATA=DATA_",INFN(1)"
 ;
 ;check for results from DICOMP lookup, INFIL is File, INFLD is Field
 S (INFLD,INFIL,INAME)=""
 ;for @ & "", stick contents in INAME so it will appear in 3rd CHCS col.
 I $E(INDL)=""""!($E(INDL)="@") S INAME=INDL,INDL=""
 ;line looks like "4:44.8 (FIELD NAME)", so double $P for INFIL
 I $L(INDL) S INFLD=$P(INDL,":"),INFIL=$P($P(INDL," "),":",2)
 ;$L(INDL) means we have field#[:file#], need to split out field name
 I $L(INDL),'$L(INAME) S INAME=$S(INDL["(":"("_$P(INDL,"(",2,9),1:"")
 ;
 ;no need to wrap the HL7 field name if there is no Fileman Field#
 I 'INFLD,INFN>1 S DATA=DATA_",INFN(2)",INFN=1
 ;
 ;add field# to DATA, add ":", add file#
 I $L(INFLD) S DATA=DATA_",?INS2,$J(INFLD,5)"
 I +INFIL S INFIL=INFIL_" ",DATA=DATA_","":"",?(INS2+6),INFIL"
 ;
 ;add field name to DATA
 S INAME=$G(INAME)
 D WRAPS^INHMGD11(INAME,.INTXT,INW3)
 S DATA=DATA_",?INS3,INTXT(1)"
 Q:INEXIT
 ;
 ;before we write out the data line, see if it all will fit on the
 ;existing page, or if we need a new page.
 S INJ=INFN S:INTXT>INJ INJ=INTXT S INEED=1+(INJ-1) ;1 line+wraps
 S INAVL=IOSL-$Y-2
 I INEED>INAVL D HEADER^INHMGD1
 ;WRITE the DATA line
 D WRITE^INHMGD1
 ;
 ;write out the wrapped HL7 Field Name and wrapped Fileman Field Name
 S:'INFLD INFN(2)=""
 I INJ>1 F INK=2:1:INJ D
 .S DATA="?INS1,$G(INFN(INK)),?INS3,$G(INTXT(INK))"
 .D WRITE^INHMGD1
 ;
 ;process data for output file
 I INP,'INDENT D  ;'INDENT because RQMTS doesn't want sub fields
 .;add field length & Data Type
 .S INP=INP_TAB_INFD("LEN") ;         $P10 Field Length
 .S INP=INP_TAB_INFD("DT") ;          $P11 Field Data Type
 .S INP=INP_TAB_$S(INREQ["Y":"Y",1:"") ;$P12 Field Required?
 .S INP=INP_TAB_$S(INREP["Y":"Y",1:"") ;$P13 Field Repeatable?
 .S INP=INP_TAB_INFD("FN") ;          $P14 HL7 Field Name
 .S INP=INP_TAB_INFLD ;               $P15 Fileman Field#
 .S INP=INP_TAB_INFIL ;               $P16 Fileman File#
 .S INP=INP_TAB_INAME ;               $P17 Fileman Field Name
 .;add an incrementing line # to front of DATA line
 .S X=+INP,INP=$E(INP,$L(X)+1,254)
 .S DATA="X+.1_TAB_INP" ;Line type: (data=.1, description=>.2)
 .D WRITE^INHMGD1
 .;restore the numbering to the front of INP
 .S INP=X+1_INP
 Q
 ;
MAPXFRM(INFLDC) ;
 ;Print out any Map functions or Xfrms
 N DATA,INDATA,INTXT,J
 I $L($G(INFLDC(4))) D  S INFLDC(4)=""
 .D WRAPS^INHMGD11(INFLDC(4),.INTXT,IOM-29)
 .S DATA="?10,""Incoming Xform: """,J=0
 .F  S J=$O(INTXT(J)) Q:'J  D
 ..S DATA=DATA_",INTXT(J)" D WRITE^INHMGD1 S DATA="?26"
 ;
 I $L($G(INFLDC(5))) D  S INFLDC(5)=""
 .D WRAPS^INHMGD11(INFLDC(5),.INTXT,IOM-29)
 .S DATA="?10,""Outgoing Xform: """,J=0
 .F  S J=$O(INTXT(J)) Q:'J  D
 ..S DATA=DATA_",INTXT(J)" D WRITE^INHMGD1 S DATA="?26"
 ;
 I $G(INFLDC(50)) D  S INFLDC(50)=""
 .S INDATA=$P($G(^INVD(4090.2,+INFLDC(50),0)),U)
 .I $L(INDATA) S DATA="?10,""Map Function: "",INDATA" D WRITE^INHMGD1
 S DATA="$C(32)"
 Q
 ;
