INHUT ; FRW ; 7 May 99 11:24; HL7 utilities  
 ;;3.01;BHL IHS Interfaces with GIS;**16**;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;All linetags in this program are supported and may be called
 ;by aapplication software
 ;
COMP() ;EP - Return HL7 component separator
 Q:$L($G(INSUBDEL)) INSUBDEL
 Q:$L($G(SUBDELIM)) SUBDELIM
 ;Q "\" orig
 Q $S($G(BHLMIEN):$E($G(^INTHL7M(BHLMIEN,"EC")),1,1),1:"^")  ;cmi/maw md
 ;
FIELD() ;EP - Return HL7 field separator
 Q:$L($G(INDELIM)) INDELIM
 Q:$L($G(DELIM)) DELIM
 ;Q "^" orig
 Q $S($G(BHLMIEN):$G(^INTHL7M(BHLMIEN,"FS")),1:"|")  ;cmi/maw mod
 ;
SUBCOMP() ;EP - Subcomponent separator
 Q:$L($G(INSUBCOM)) INSUBCOM
 ;Q "&" orig
 Q $S($G(BHLMIEN):$E($G(^INTHL7M(BHLMIEN,"EC")),3,3),1:"\")  ;cmi/maw md
 ;
REP() ;EP - Repetition separator
 ;Q "|" orig
 Q $S($G(BHLMIEN):$E($G(^INTHL7M(BHLMIEN,"EC")),2,2),1:"~")  ;cmi/maw md
 ;
ESC() ;EP - Escape Character
 ;Q "~" orig
 Q $S($G(BHLMIEN):$E($G(^INTHL7M(BHLMIEN,"EC")),4,4),1:"&")  ;cmi/maw md
 Q
 ;
CE(INTCE,FILE,CODE,INDELIMS,INENC,INDIR) ;Entry point to transform to coded entry data type
 ;INPUT:
 ; INTCE - ien of coded entry in format ien or ien ; file ; coding system
 ; FILE  - File number in format NN or global ref in format ^GL(
 ; CODE  - Coding system
 ; INDELIMS - Delimeter values
 ; INENC - 0 Don't encode, 1 encode
 ; INDIR - O Outbound, I Inbound
 ;OUTPUT:
 ;  ien\value\coding system
 ;  note: the actual delimiter may not be "\"
 ;
 Q $$CE^INHUT1(.INTCE,.FILE,.CODE,.INDELIMS,.INENC,.INDIR)
 ;
CM(INTCE,FILE,CODE,INDELIMS,INENC,INDIR) ;Entry point to transform to composite data type
 ;INPUT:   same as CE module
 ;OUTPUT:
 ;  internal value (i.e. .001 field) \ external value (i.e. .01 field)
 ;
 Q $$CM^INHUT1($G(INTCE),$G(FILE),$G(CODE),.INDELIMS,.INENC,.INDIR)
 ;
CN(INTCE,FILE,CODE,INDELIMS,INENC,INDIR) ;Entry point to transform to composite person name data type
 ;INPUT:   same as CE module
 ;OUTPUT:
 ;  internal value (i.e. .001 field) \ formatted person name
 ;
 Q $$CN^INHUT1($G(INTCE),$G(FILE),$G(CODE),.INDELIMS,.INENC,.INDIR)
 ;
PN(NAME,INDELIMS,INENC,INDIR) ;Transform person name to HL7 formatted person name
 ;INPUT:
 ; NAME - name in format LAST,FIRST MI
 ; INDELIMS - Delimeter values
 ; INENC - 0 Don't encode, 1 encode
 ; INDIR - O Outbound, I Inbound
 ;OUTPUT:
 ; function - name in format LAST\FIRST\MI
 ;
 Q $$PN^INHUT1(NAME,.INDELIMS,.INENC,.INDIR)
 ;
HLPN(NAME,COMP,INDELIMS,INENC,INDIR) ;EP - Transform HL7 formatted person name to person name
 ;INPUT:
 ; NAME - name in format LAST\FIRST\MI\SUFFIX
 ; COMP - HL7 component seperator
 ; INDELIMS - Delimeter values
 ; INENC - 0 Don't encode, 1 encode
 ; INDIR - I Inbound
 ;OUTPUT:
 ;  function - name in format LAST,FIRST MI SU
 ;
 Q $$HLPN^INHUT1(NAME,$G(COMP),.INDELIMS,.INENC,.INDIR)
 ;
DATE(X,TS) ;Transform fileman date/time to HL7 date/time stamp
 ;INPUT:
 ;   X  - date in any fileman or external format
 ;   TS - include time [ 1 - yes ; 0 - no (default) ]
 ;OUPUT:
 ;   function - date/time in HL7 format
 ;
 Q:$G(TS) $$TS^INHUT1(X)
 Q $$DT^INHUT1(X)
 ;
HDATE(X,TS,VA) ;EP - Transform HL7 date/time format to internal fileman format
 ;INPUT:
 ;   X  - date/time in HL7 format
 ;   TS - control variable - similiar to %DT
 ;        used as %DT when validating data
 ;           TS [ "T" allow time
 ;           TS [ "S" allow seconds
 ;   VA - validate data ( 1 - yes ; 0 - no )
 ;OUPUT:
 ;   function - date/time in fileman format
 ;   X  - same as function (pass by ref)
 ;   VA - is data valid (pbr) ( 1 - valid ; 0 - invalid )
 ;
 Q $$HDT^INHUT1(.X,.TS,.VA)
 ;
CL(X,INDELIMS,INENC,INDIR) ;Transform hospital location to coded location data type
 ;INPUT:
 ; X - hospital location ien _ ";" _ division ien (opt.)
 ; INDELIMS - Delimeter values
 ; INENC - 0 Don't encode, 1 encode
 ; INDIR - O Outbound, I Inbound
 ;OUTPUT:
 ;  function - location and division in CE format
 ;
 Q $$CL^INHUT1(X,.INDELIMS,.INENC,.INDIR)
 ;
CC(X,INDELIMS,INENC,INDIR) ;Transform MEPRS to charge code data type
 ;INPUT:
 ; X - MEPRS iend _ ";" _ charge amount (opt.)
 ; INDELIMS - Delimeter values
 ; INENC - 0 Don't encode, 1 encode
 ; INDIR - O Outbound, I Inbound
 ;OUTPUT:
 ;  function - charge code \ MEPRS ien \ MEPRS code \ 99MEP
 ;
 Q $$CC^INHUT1(X,.INDELIMS,.INENC,.INDIR)
 ;
CRB(X,INDELIMS,INENC,INDIR) ;Transform room-bed & location code room-bed data type
 ;INPUT:
 ; X -> room-bed (opt.) _ ";" _ hos loc ien (opt.)
 ; INDELIMS - Delimeter values
 ; INENC - 0 Don't encode, 1 encode
 ; INDIR - O Outbound, I Inbound
 ;
 ;OUTPUT:
 ;  function - ward location (CE) \ Room-Bed \  \  MTF Code
 ;
 Q $$CRB^INHUT1($G(X),.INDELIMS,.INENC,.INDIR)
 ;
RCVSCRN(INSRCTL,INSRDATA,INA,INDA) ; Default Inbound Receiver screen.
 ; Called by: Receiver SRMC code for inbound BPC, Dest or TT entries.
 ;            D RCVSCRN^INHUT(.INSRCTL,.INSRDATA,.INA,.INDA)
 ; See called routine for comments.
 D RCVSCRN^INHUT5(.INSRCTL,.INSRDATA,.INA,.INDA)
 Q
 ;
LOG(INFN,INIEN,INSRMC,INUIF,INLOG) ; Log error message in UIF or IEF
 D LOG^INHUT6(.INFN,.INIEN,.INSRMC,.INUIF,.INLOG)
 Q
 ;
GETDEST(INACKTT,INA,INACKDST,INACKUIF) ; $$function
 ; Called by:  SCRIPT GENERATOR MESSAGE file, Outgoing Initial MUMPS 
 ;             Code field, S INDEST=$$GETDEST^INHUT(INTT,.INA,INDEST)
 ; See called routine for comments.
 Q $$GETDEST^INHUT7(INACKTT,.INA,$G(INACKDST),$G(INACKUIF))
 ;
GETSEG(INUIF,INSEGNM,INSTANCE) ; Get an HL7 Segment
 Q $$GETSEG^INHUT2(.INUIF,.INSEGNM,.INSTANCE)
 ;
PARSEG(INSRCTL,INSEGNM) ; Parse an HL7 segment (from GETSEG.)
 D PARSEG^INHUT2(.INSRCTL,.INSEGNM)
 Q
 ;
SUBESC(INREC,INDEL,INB) ;Substitute escape delimeters to and from HL7
 ;                        spec
 ;Input:
 ; INREC - Portion of HL7 MSG to check
 ; INDEL(opt) = FSRET values - each position is critical
 ;              ie S INDEL="^\|~&"
 ;                       or
 ;              array of delimiters
 ;              S INDEL("F")="^"
 ;              S INDEL("S")="\"
 ;              S INDEL("R")="|"
 ;              S INDEL("E")="~"
 ;              S INDEL("T")="&"
 ; INB - I inbound, O outbound
 ;Returns - Record with replace values
 Q $$SUBESC^INHUT7(INREC,.INDEL,.INB)
CNVDLM(INREC) ;Convert delimeters to HL7 specifications if in record
 ; Input: INREC - Portion of HL7 MSG to check
 ; Returns - Record with replace values
 ;
 Q $$CNVDLM^INHUT7(INREC)
 ;
BPSTAT(INBKGNM,INSRVR) ;-determine status of GIS background process, given name
 ;Input:  INBKGNM - name of background process to determine status
 ;        INSRVR  - server number (not currently supported)
 ;Output:  Status message string of given background process name
 ;
 Q $$BPSTAT^INHUT2($G(INBKGNM),$G(INSRVR))
 ;
TIMEIO(X,INP,INCV,IN24,INOUT) ;Convert time to input or output
 ;Input:
 ; X  - date/time
 ; INP(opt) - Precision Y=year, L=month, D=day, H=hour, M=minute,S=second
 ;                      1=Auto precision
 ; INCV(opt) - 1 convert, 0 don't convert, 2 convert no 2nd component
 ;             3 convert 2.3
 ;          outbound - INOUT flag set to 0
 ; IN24(opt) - 0 do nothing, 1 - add 1 day set time to 0000
 ;             2 - subtract one second, 3 - subtract one minute
 ;          inbound - INOUT flag set to 1
 ;             0 - do nothing, 1 - subtract 1 day set time to 2400
 ;             2 - add one second, 3 - add one minute
 ; INOUT - 0 or null outbound - converts from fileman to HL7
 ;         1 inbound - converts from HL7 to fileman
 ;Output:
 ; INP - Precision
 ;
 ;External Input:
 ; (opt) INSUBDEL - Sub delimeter
 ;Returns:
 ; function date/time in converted format
 ;
 ;Output
 ; INP (val) - Precision
 Q $$TIMEIO^INHUT10(X,.INP,INCV,IN24,INOUT)
MRGINA(INOA,INA) ;Merge INOA array into INA array
 ; Used by Query Response capability
 ; Input: INA  = Application team INA array
 ;        INOA = Values used by GIS for processing responses
 ; Output: Consolidated INA array used for processing responses
 M INA=INOA
 Q
APPACK(INUIF,INAKMES,INASTAT,INERMSG) ;User API to ACKLOG^INHU
 ;This routine is documented in APPACK^INHUT7
 D APPACK^INHUT7(INUIF,$G(INAKMES),$G(INASTAT),$G(INERMSG))
 Q
 ;
TASKNUM(INSEQ) ; return task number for a given seq. #
 ;
 Q $$TASKNUM^INTQRY($G(INSEQ))
