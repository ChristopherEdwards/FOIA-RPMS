INHMGD3 ;CAR; 16 May 97 16:46;HL7 MESSAGING - MANAGEMENT OF DATA SOURCES
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME:
 ; HL7 Messaging - Data Source Display and Validation
 ;                 Handle Field (INHMGD3).
 ;
 ; PURPOSE:
 ; Module INHMGD3 is used to extract information describing the
 ; source file and field for HL7 Messaging segment fields.
 ;(X,INF,FLVL,.FILE,.INP)
FIELD(INFLD,INF,FLVL,FILE,INP) ;Handle a field in SCRIPT GENERATOR FIELD^4012
 ;
 ; Inputs:
 ;   INFLD = Field index # into ^INTHL7F(INFLD,
 ;   INF   = Sequence Number
 ;   FLVL  = File SP
 ;   FILE  = File Stack
 ;   INP   = Output array (call by reference)
 ; Output:
 ;   INP   = Output array
 ;
 N INSF,IN,INFLDC,INDENT,INUFL,INY,INSUPRES,INREQ,INREP,XFM,INFD
 S INFLD(1)=^INTHL7S(INSEG,1,INFLD,0),INFLD(2)=INFLD,INFLD=+INFLD(1)
 S INY=INFLD(1)
 ;get field specifications that are stored at the segment level:
 S INREQ=$$YN^INHMGD1($P(INY,U,3)) ;required
 S INREP=$$YN^INHMGD1($P(INY,U,4)) ;repeating field
 S INUFL=$$YN^INHMGD1($P(INY,U,5)) ;used for lookup
 S XFM=$$YN^INHMGD1($P(INY,U,6)) ;required to pass transform
 S INFD("SQ")=INF ;sequence number
 S INSVAR=$P(INSEG(0),U,2)_INF
 ;leaving the Flag_MessageName...SegmentName, remove any field data.
 I INP S INP=$P(INP,TAB,1,8)_TAB_INF ;$P9 field sequence#
 S INFLDC=INFLD,(INDENT,INSUPRES)=0
 ;
 ;check for subfields:
 S INSF=$O(^INTHL7F(INFLD,10,0)),(IN(0),IN)=0
 ;
 ;Handle subfields ;INSF>0 subfields present
 I INSF D  Q
 .S INSUPRES=1 D FD1 ;do the header field, first
 .F  S IN(0)=$O(^INTHL7F(INFLD,10,"AS",IN(0))) Q:'IN(0)  D
 ..S IN(10)=$G(^INTHL7F(INFLD,10,+$O(^INTHL7F(INFLD,10,"AS",IN(0),0)),0))
 ..S INFLDC=+IN(10),IN=IN+1
 ..Q:'INFLDC  Q:'$D(^INTHL7F(INFLDC,0))
 ..S INFLDC(0)=^INTHL7F(INFLDC,0),INSVAR=$P(INSEG(0),U,2)_INF_"."_IN
 ..S INREQ=$$YN^INHMGD1($P(IN(10),U,3))
 ..S INUFL=$$YN^INHMGD1($P(IN(10),U,4))
 ..S INDENT=1
 ..D FD1
 ;
FD1 ;one field
 N INERR,INY
 ;
 ;get the field data
 S (INY,INFLDC(0))=^INTHL7F(INFLDC,0)
 ;S INFLDC(4)=$G(^INTHL7F(INFLDC,4)) ;Input Xform
 ;S INFLDC(5)=$G(^INTHL7F(INFLDC,5)) ;Output Xform
 ;S INFLDC(50)=$G(^INTHL7F(INFLDC,50)) ;Map Function
 S INFD("FN")=$P(INY,U) ;field name
 S:$P(INY,U,2)="" $P(INY,U,2)=0
 S INFD("DT")=$P($G(^INTHL7FT($P(INY,U,2),0)),U,2) ;data type abbrev
 S INFD("LEN")=$P(INY,U,3) ;field length
 S INFD("OIT")=$P(INY,U,5) ;override input transforms 1=yes
 ;
 ;process the field, o.k. to output column header if needed
 D:INHF2<0 HDR2^INHMGD1 ;since we have data, now need to write col header
 S INHF2=1 ;if we need a new page, write the col header
 D PROC(.INFLDC,.INP)
 S INHF2=0 ;if we need a new page, don't write the col header
 Q
 ;
PROC(INFLDC,INP) ;Print the data source, utilizing the current Seg. File
 N DICOMPX,INDESC,INDDL,INDL,INS,X,INJ,INX,INOLDX
 ;
 ;Use documented data type, if one exists.
 I $P(INFLDC(0),U,12)]"" S INFD("DT")=$P(INFLDC(0),U,12)
 I INFD("DT")="" D
 .S ^UTILITY("INHMGD",$J,"E",INMSG,INSEG,INFLDC)=+FILE(FLVL)_U_"***NO DATA TYPE***"
 ;
 S J(0)=FILE(FLVL),INDL=""
 ;Use documented data source, if one exists.
 S INDL=$$LBTB^UTIL($P(INFLDC(0),U,11))
 I INDL]"" S INOLDX=INDL,INDL="##"_INDL
 ;else use data location
 I INDL="" S (INDL,INOLDX)=$$LBTB^UTIL($G(^INTHL7F(INFLDC,"C")))
 ;use DICOMP to get data location
 I $L(INDL) D
 .S INDL=$$RESOLVE(J(0),INDL)
 .Q:$L(INDL)
 .S ^UTILITY("INHMGD",$J,"E",INMSG,INSEG,INFLDC)=+FILE(FLVL)_U_INOLDX_"  Unable to resolve or missing from Data Dictionary."
 D PRINT^INHMGD4(INDL,.INP)
 D:0 MAPXFRM^INHMGD4(.INFLDC)
 Q
RESOLVE(INRT,INAD) ;Extrensic ***add DIC lookup
 ; Inputs:
 ;   INRT = file#, or file name
 ;   INAD = field string: e.g.: #.01:#.01:INTERNAL(#3.5)_";40.8"
 ;          delimited by ":"
 ; Output:
 ;   String containing  Field#:File# (Field Name)
 ;                      with no leading spaces, and 1 space before the
 ;                      Field Name. e.g.: .01:8550 (NAME)
 ;
 N DIC,X,Y,I,INAME,INFLD,INFIL,INJ,INS,INPY
 S (INFIL,INFLD)=""
 ;
 ;fixup address from documented data source
 I $E(INAD,1,2)="##" S INAD=$E(INAD,3,999) D
 .S INFIL=$P(INAD,":",2) S:INFIL]"" INRT=INFIL
 .S INAD=$P(INAD,":")
 ;
 ;find file number from file name:
 I +INRT=0,$L(INRT) D  ;make sure it's not like "8550^^CPG("
 .K DIC S DIC="^DIC(",DIC(0)="FZ",X=INRT D ^DIC ;find file
 .I Y>0 S INRT=+Y Q
 .S DIC="^DD(",DIC(0)="FMZ",DIC("S")="I $P(^(0),U,2)" D ^DIC ;sub-file
 .I Y>0 S INRT=+Y Q
 S INRT=+INRT
 I 'INRT D  Q INAD_":"_INRT_" (FILE# MISSING***)"
 .S ^UTILITY("INHMGD",$J,"E",INMSG,INSEG,INFLDC)=+FILE(FLVL)_U_"FILE# MISSING***"
 ;
 ;exit on quoted string or @ (user defined routine)
 S INS=INAD
 Q:INAD["@" INAD
 I INAD'["INTERNAL" S X=$E(INAD) I X="""" Q INAD
 ;
 ;try a ^DD lookup
 S X=$TR(INAD,"#") I X'[":" D  Q:$L(INFIL) INFIL
 .K DIC S DIC="^DD("_INRT_",",DIC(0)="FMZ" D ^DIC
 .I Y>0 S INFIL=+Y_":"_INRT_" ("_Y(0,0)_")"
 ;
 S J(0)=+INRT,I(0)="",DA="DA(",DQI="Y(",DICOMPX="",X=INAD
 D ^DICOMP S INPY=$G(%Y)
 I '$L($G(X)) Q ""
 S INAME=""
 ;if DICOMPX has the results, just reassemble for PRINT
 I $L($G(DICOMPX),U)>1 D  Q INAD_$S($L(INAME):" ("_INAME_")",1:"")
 .;rebuild the address for compatibility with PRINT
 .S INFIL=+DICOMPX,INFLD=+$P(DICOMPX,U,2)
 .S INAD=INFLD_":"_INFIL
 .;
 .;have the address, now look for the field name
 .I $D(^DD(INFIL,INFLD,0)) S INAME=$P(^DD(INFIL,INFLD,0),U) Q
 .;didn't find it, use what DICOMP returned
 .I INPY'["^",+INPY'=INPY S INAME=INPY Q  ;looks like text, use it.
 .;still didn't find it, try using what we started with.
 .I '$TR(INS,"#") S INAME=INS
 ;
 I $L(X) D  Q:$L(INFIL) INFIL
 .S INFIL=""
 .I INAD["NUMBER"!(INAD["#.001") S INFIL=".001:"_+FILE(FLVL)_" (NUMBER)"
 .I INAD["INSITE"  S INFIL="8000:4 (INSITE)"
 Q ""
 ;
