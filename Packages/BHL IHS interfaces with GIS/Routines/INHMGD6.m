INHMGD6 ;CAR; 7 May 97 11:43;HL7 MESSAGING - REBUILD SENSITIVITY ANALYSIS GLOBAL
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; PURPOSE:
 ; Module INHMGD6 is used to rebuild the Sensitivity Analysis Global
 ; ^UTILITY("INHMGD",
 ;
INSUPDT ;Create ^UTILITY("INHMGD",$J,...) dBase
 ; Input:
 ;   None:
 ;
 N INAS,INDA,INDC,INDL,INDOT,INF,INFS,INH,INJ
 N INM,INS,INSEG,INSQ
 S INDOT=0 ;show user some activity when rebuilding?
 I $E(IOST)="C",'$D(IO("Q")),IO=IO(0) S INDOT=1
 I INDOT W !,"Rebuilding ^UTILITY(""INHMGD""), this may take a while."
 ;
 ;1. load all Fields (^INTHL7F(X)), containing a "C" node and ] "", but
 ;   watch for 10 nodes and expand subfields.
 S INF=0 F  S INF=$O(^INTHL7F(INF)) Q:'INF  D
 .;try for the DOCUMENTED DATA SOURCE 1st
 .S INDL=$P($G(^INTHL7F(INF,0)),U,11)
 .I INDL]"" S INDL="##"_INDL
 .;else  go for the DATA LOCATION
 .S:INDL="" INDL=$G(^INTHL7F(INF,"C"))
 .;pick up any sub-fields, must check for actual content
 .I $D(^INTHL7F(INF,10,"AS")) D  Q
 ..S (INX,INAS)="" F  S INX=$O(^INTHL7F(INF,10,"AS",INX)) Q:'INX  D
 ...S INDA=$O(^INTHL7F(INF,10,"AS",INX,0))
 ...S INDA=+$G(^INTHL7F(INF,10,+INDA,0)) Q:'INDA
 ...Q:'$D(^INTHL7F(INDA,"C"))  S INDC=^INTHL7F(INDA,"C")
 ...Q:$TR(INDC," ")=""!(INDC["@")
 ...I INDC'["INTERNAL",$E(INDC)="""" Q
 ...S INAS=INAS_$S(INAS]"":"^"_INDA,1:INDA)
 ..I $L(INAS) S ^UTILITY("INHMGD",$J,"F10",INF)=INAS
 .Q:INDL=""
 .;don't save what we can't use
 .Q:INDL["@"
 .I $E(INDL)="""",INDL'["INTERNAL" Q
 .S ^UTILITY("INHMGD",$J,"F",INF)=INDL
 I INDOT W "."
 ;
 ;2. load Segments (^INTHL7S(X)), pointing to an ^INTHL7F(fld,"C")
 ;   containing more than "".
 S INS=0 F  S INS=$O(^INTHL7S(INS)) Q:'INS  D
 .;order through the fields using the "AS" field
 .S INFS=0,INAS="" F  S INFS=$O(^INTHL7S(INS,1,"AS",INFS)) Q:'INFS  D
 ..;get the "in order" index INSQ
 ..S INSQ=$O(^INTHL7S(INS,1,"AS",INFS,0)) Q:'INSQ
 ..;which points to the INSEG field
 ..S INSEG=+$G(^INTHL7S(INS,1,INSQ,0))
 ..;check if there is a DATA LOCATION or DOCUMENTED DATA SOURCE
 ..I INSEG,$D(^UTILITY("INHMGD",$J,"F",INSEG)) D  Q
 ...S INAS=INAS_$S(INAS]"":"^"_INSEG,1:INSEG) ;format is: ien^ien^ien...
 ..;how about a sub-field
 ..I INSEG,$D(^UTILITY("INHMGD",$J,"F10",INSEG)) D
 ...S INSFS=^UTILITY("INHMGD",$J,"F10",INSEG) ;get the subfield string
 ...S INAS=INAS_$S(INAS]"":"^"_INSFS,1:INSFS) ;tack it on to INAS
 .;save any fields that we found.
 .S:INAS]"" ^UTILITY("INHMGD",$J,"S",INS)=INAS
 I INDOT W "."
 ;
 ;3. then order through the messages (^INTHL7M(X)), and for each segment
 ;in ^UTILITY, store the following:
 ; (root,field,HL7field,segment,message) where there is a field
 ;-----------main message loop-------------------
 S INM=0 F  S INM=$O(^INTHL7M(INM)) Q:'INM  D
 .S INM(0)=$G(^INTHL7M(INM,0))
 .Q:$P(INM(0),U,8)  ;inactive - quit
 .S INTRP=$G(^INTHL7M(INM,"S")) ;get script pointers
 .S INMODE=$S($P(INTRP,U,2):1,1:0) ;incoming (0) or outgoing (1) message
 .S INPARS=$S($P(INM(0),U,7)="P":1,1:0) ;is parse only set
 .K FILE,FLVL S FLVL=0
 .;get the root from $P5 of ^(0), exit if there is no root.
 .S FILE=$P(INM(0),U,5) Q:'FILE  S FILE(0)=FILE
 .;order through the segment pointers. "AS" x-ref is in output order
 .S INS=0 F  S INS=$O(^INTHL7M(INM,1,"AS",INS)) Q:'INS  D
 ..;$O to get the index that the "AS" references
 ..S INX=$O(^INTHL7M(INM,1,"AS",INS,0)) Q:'INX
 ..;check for common err:2 INSQs
 ..S INSEG(1)=$O(^INTHL7M(INM,1,"AS",INS,INX)) I INSEG(1) D
 ...S INSEG(1)=$G(^INTHL7M(INM,1,INX,0)),INERN=INERN+.001
 ...S ^UTILITY("INHMGD",$J,"E",INM,+INSEG(1),INERN)=FILE(FLVL)_U_"Msg# "_INM_" has multiple segments defined for Sequence# "_$P(INSEG(1),U,2)
 ..;retrieve segment info, skip processing if seg has parent segment,
 ..;since it will be called recursively from SEG
 ..S INSEG(1)=$G(^INTHL7M(INM,1,INX,0)) D:'$P(INSEG(1),U,11) SEG^INHMGD7(INX,.INERN)
 ;
 ;the UTILITY global is complete, delete the nodes we no longer need.
 K ^UTILITY("INHMGD",$J,"F"),^UTILITY("INHMGD",$J,"S")
 K ^UTILITY("INHMGD",$J,"F10"),^UTILITY("INHMGD",$J,"M")
 Q
 ;
