INHMGD2 ;CAR; 27 Jun 97 15:34;HL7 MESSAGING - PROCESS SEGMENT
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME:
 ; HL7 Messaging - Process Segment
 ;
 ; PURPOSE:
 ; Module INHMGD2 is used to order through the fields
 ; pointed to by ^INTHL7M(INDA,1,SEG,0)
 ;
SEG(INSEG,FLVL,FILE,INP,INERN) ;Process segment
 ; Input:
 ;   INSEG= Seg is the index to the ^INTHL7M(INDA,1,SEG,0) node, and
 ;          is used to retrieve INMSG(1).
 ;   FLVL = Current level in FILE.
 ;   FILE = Stacks file# references.
 ;   INP  = The output array used to create a data file for export to 
 ;          a tab delimited text file.
 ;   INERN= An incrementing counter to prevent multiple error msgs
 ; Output:
 ;   INERN,INP and FILE
 ;
 ;get next segment descriptor.
 S INSEG(1)=$G(^INTHL7M(INMSG,1,INSEG,0)),INSEG=+INSEG(1),INSEG(2)=INSEG
 Q:'$D(^INTHL7S(INSEG,0))
 ;
 ;quit if common or MSH segment?
 S INSEG(0)=^INTHL7S(INSEG,0)
 I 'INCSG,"MSH,PID,"[($P(INSEG(0),U,2)_",") Q
 ;
 ;check for MULTIPLE, OTHER.
 N DIC,INWHILE,INCH,X,INX,Y,INUDI,INDHDR
 S INWHILE=$P(INSEG(1),U,3)!$P(INSEG(1),U,4)
 S INUDI=$P(INSEG(1),U,12) ;user defined index
 I INWHILE,(INUDI="") D
 .I $P(INSEG(1),U,3),'$P(INSEG(1),U,4) D  Q  ;MULTIPLE
 ..K DIC S (X,INX)=$P(INSEG(1),U,8)
 ..S DIC="^DD("_+FILE(FLVL)_",",DIC(0)="FMZ"
 ..S DIC("S")="I $P(^(0),U,2)" D ^DIC
 ..I Y<0 D  Q
 ...S INWHILE=0 Q:INPARS  ;bogus segs ok in Parse Only msg.
 ...S INERN=INERN+.001
 ...S ^UTILITY("INHMGD",$J,"E",INMSG,INSEG,INERN)=+FILE(FLVL)_U_"Multiple "_INX_" does not exist"
 ..S FLVL=FLVL+1,FILE(FLVL)=+$P(Y(0),U,2),INWHILE(1)=$P(Y,U,2)
 .S FLVL=FLVL+1,FILE(FLVL)=+$P(INSEG(1),U,5)
 .I 'FILE(FLVL) D  S FLVL=FLVL-1,INWHILE=0 Q
 ..S INX="No OTHER file specified",INERN=INERN+.001
 ..S ^UTILITY("INHMGD",$J,"E",INMSG,INERN)=+FILE(FLVL)_U_INX
 .S INWHILE(1)=$P(^DIC(+FILE(FLVL),0),U)
 ;
 N INF,INY,INREPEAT,INFLD
 S INY=INSEG(0)
 S INSG("NM")=$E($P(INY,U),1,45) ;Segment Name
 S INSG("NM",1)=$E($P(INY,U,2),1,6) ;Segment ID
 ;
 S INY=INSEG(1) ;from ^INTHL7M(INMSG,1,INX,0)
 S INSG("NM",2)=$P(INY,U,2) ;Sequence Number
 S INSG("NM",9)=$$YN^INHMGD1($P(INY,U,9),1) ;Required?
 ;Parent Segment?
 S X=$P(INY,U,11)
 S INSG("PS")=$E($S(X="":X,$D(^INTHL7S(X,0))#2:$P(^(0),U),1:" "_X),1,45)
 S INREPEAT=$P(INY,U,3)
 S INSG("NM",3)=$$YN^INHMGD1(INREPEAT,1) ;Repeatable?
 ;OTHER Flag & File Name
 S INSG("NM",4)=$$YN^INHMGD1($P(INY,U,4),1)
 S X=$P(INY,U,5)
 S INSG("FL")=$E($S(X="":X,$D(^DIC(X,0))#2:$P(^(0),U),1:" "_X),1,45)
 S INSG("MF")=$E($P(INY,U,8),1,30) ;Multiple Field Name
 I +INSG("MF")=INSG("MF") D
 .K DIC S X=INSG("MF"),DIC="^DD("_+FILE(FLVL)_",",DIC(0)="FMZ"
 .S DIC("S")="I $P(^(0),U,2)" D ^DIC Q:Y<0
 .S INSG("MF")=$E(Y(0,0),1,30)
 S INSG("UD")=$P(INY,U,12)
 ;
 ;cleanup INP leaving flag & Message Name
 I INP D
 .S INP=$P(INP,TAB)_TAB_$P(INSEG(0),U,2) ;$P2 seg ID
 .S INP=INP_TAB_$P(INSEG(0),U) ;          $P3 seg name
 .S INP=INP_TAB_INSG("NM",2) ;            $P4 seg seq#
 .S INP=INP_TAB_$S(INSG("NM",3)["Y":"Y",1:"") ;$P5 repeatable
 .S INP=INP_TAB_INSG("MF") ;              $P6 Multiple Field Name
 .S INP=INP_TAB_$S(INSG("NM",9)["Y":"Y",1:"") ;$P7 Seg Reqd (Y/"")
 .S INP=INP_TAB_INSG("PS") ;              $P8 Parent Seg#
 ;
 ;Lookup Params
 S INSG("LP")=$$LKPRM^INHMGD1($P(INY,U,7))
 ;Make Links
 S X=$P(INY,U,10),INSG("ML")=$$YN^INHMGD1(X,1)
 ;Template
 S X=$P(INY,U,6),INSG("TP")=$E($P(INY,U,6),1,30)
 ;name of routine to run after lookup.
 S X=$G(^INTHL7M(INMSG,1,INSEG,3)),INSG("RT")=$E(X,1,100)
 ;
 S INDHDR=0 ;Did we just write the header
 I IO=IO(0)!'INPAGE!($Y>(IOSL-13)) S INDHDR=1 D HEADER^INHMGD1 Q:INEXIT
 ;Output seg header
 S DATA="""=====Segment Name"_$$DASH^INHMGD1(32+INOFF,"=")
 S DATA=DATA_"ID=====Seq No==Req==Rep==OF=="""
 I IO'=IO(0)!($Y<(IOSL-13)),'INDHDR S DATA="!,"_DATA
 D WRITE^INHMGD1
 ;
 S DATA="INSG(""NM""),?(49+INOFF+ING),INSG(""NM"",1)" ;seg Name and ID
 S DATA=DATA_",?(56+INOFF+ING),$J(INSG(""NM"",2),0,1)" ;seg seq. number
 S DATA=DATA_",?(64+INOFF+ING),INSG(""NM"",9)" ;seg is required?
 S DATA=DATA_",?(69+INOFF+ING),INSG(""NM"",3)" ;seg is repeatable?
 S DATA=DATA_",?(74+INOFF+ING),INSG(""NM"",4)" ;OTHER FILE?
 D WRITE^INHMGD1
 ;
 I $G(INSG("PS"))]"" D
 .S DATA="?ING+8,""Parent Segment:"",?ING+24,INSG(""PS"")"
 .D WRITE^INHMGD1
 I $G(INSG("FL"))]"" D
 .S DATA="?ING+18,""File:"",?ING+24,INSG(""FL"")"
 .D WRITE^INHMGD1
 I $G(INSG("MF"))]"" D
 .S DATA="?ING+8,""Multiple Field:"",?ING+24,INSG(""MF"")"
 .D WRITE^INHMGD1
 I $G(INSG("UD"))]"" D
 .S DATA="?ING+4,""User-Defined Index:"",?ING+24,INSG(""UD"")"
 .D WRITE^INHMGD1
 I $G(INSG("LP"))]"" D
 .S DATA="?ING+6,""Lookup Parameter:"",?ING+24,INSG(""LP"")"
 .D WRITE^INHMGD1
 I $G(INSG("ML"))]"" D
 .S DATA="?ING+12,""Make Links:"",?ING+24,INSG(""ML"")"
 .D WRITE^INHMGD1
 I $G(INSG("TP"))]"" D
 .S DATA="?ING+14,""Template:"",?ING+24,INSG(""TP"")"
 .D WRITE^INHMGD1
 I $G(INSG("RT"))]"" D
 .S DATA="?ING+15,""Routine:"",?ING+24,INSG(""RT"")"
 .D WRITE^INHMGD1
 S DATA="$C(32)" D WRITE^INHMGD1
 S INHF2=-1
 ;
 S INF=""
 ; order through the "AS" INF node (this is the sequence number)
 F  S INF=$O(^INTHL7S(INSEG,1,"AS",INF)) Q:'INF!$G(DUOUT)  D
 .S INX=0
 .; now get the index number (INX) that the sequence number points to
 .F  S INX=$O(^INTHL7S(INSEG,1,"AS",INF,INX)) Q:'INX!INEXIT  D
 ..S X=INX,INFLD(1)=^INTHL7S(INSEG,1,X,0)
 ..D:$D(^INTHL7F(+INFLD(1),0)) FIELD^INHMGD3(X,INF,FLVL,.FILE,.INP)
 ;
 ;pick up parent segments
 I $D(^INTHL7M(INMSG,1,"ASP",INSEG)) D
 .S INCH=0
 .F  S INCH=$O(^INTHL7M(INMSG,1,"ASP",INSEG,INCH)) Q:'INCH  D
 ..S INX=0 F  S INX=$O(^INTHL7M(INMSG,1,"ASP",INSEG,INCH,INX)) Q:'INX  D SEG(INX,.FLVL,.FILE,.INP,.INERN)
 ;
 ;adjust file level
 I INWHILE S FLVL=FLVL-1
 Q
