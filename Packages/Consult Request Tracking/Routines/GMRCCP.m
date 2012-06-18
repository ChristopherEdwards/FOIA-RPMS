GMRCCP ;SLC/JFR - utilities for clinical procedures; 11/26/01 10:45
 ;;3.0;CONSULT/REQUEST TRACKING;**17,25**;DEC 27, 1997
 ; 
 ; This routine invokes IA #3378
 ;
 Q
CPLIST(GMRCPT,GMRCPR,GMRCRET) ;return list of patient CP requests
 ; Input:
 ;   GMRCPT = patient DFN              (required)
 ;   GMRCPR = ien from file 702.01     (optional)
 ;            if just one procedure
 ;            desired; defaults to all
 ;   GMRCRET= global array in which to (required)
 ;            return results
 ;
 ; Output:
 ;   ^global(array)=
 ;          date of request^CP DEF nam^urgency^status^cons #^CP DEF ien
 ;
 N GMRCDA,COUNT
 S COUNT=1
 I '$G(GMRCPT)!('$D(GMRCRET)) Q
 I $G(GMRCPR) D
 . S GMRCDA=0
 . F  S GMRCDA=$O(^GMR(123,"ACP",GMRCPR,GMRCPT,GMRCDA)) Q:'GMRCDA  D
 .. I '$$EXTDATA^MDAPI(GMRCPR) Q  ; if no ext. data, don't send
 .. D LOADAR(GMRCDA,GMRCRET,COUNT) S COUNT=COUNT+1
 . Q
 I '$G(GMRCPR) S GMRCPR=0 D
 . F  S GMRCPR=$O(^GMR(123,"ACP",GMRCPR)) Q:'GMRCPR  D
 .. I '$$EXTDATA^MDAPI(GMRCPR) Q  ;don't send if no ext. data
 .. S GMRCDA=0
 .. F  S GMRCDA=$O(^GMR(123,"ACP",GMRCPR,GMRCPT,GMRCDA)) Q:'GMRCDA  D
 ... D LOADAR(GMRCDA,GMRCRET,COUNT) S COUNT=COUNT+1
 .. Q
 . Q
 Q
 ;
LOADAR(IEN,GMRCAR,CNT) ;set up array and return data for given file 123 ien
 N GMRCDT,GMRCCP,GMRCUR,STS,GMRC,GMRCCPI
 Q:'$D(^GMR(123,IEN,0))
 Q:'+$G(^GMR(123,IEN,1))
 S GMRC(0)=^GMR(123,IEN,0)
 S GMRCDT=$P(GMRC(0),U,7)
 S GMRCCPI=+^GMR(123,IEN,1)
 S GMRCCP=$$GET1^DIQ(702.01,GMRCCPI,.01)
 S GMRCUR=$$GET1^DIQ(101,+$P(GMRC(0),U,9),1)
 S STS=$$GET1^DIQ(100.01,+$P(GMRC(0),U,12),.1)
 S @(GMRCAR)@(CNT)=GMRCDT_U_GMRCCP_U_GMRCUR_U_STS_U_IEN_U_GMRCCPI
 Q
 ;
CPROC(PROC) ;is orderable procedure mapped to Clinical Procedures
 Q +$P($G(^GMR(123.3,PROC,0)),U,4)
CPLINK(PROC) ;check "AC" x-ref to see if PROC is linked to entry in 123.3
 ; PROC - ien from 702.01
 Q $E($D(^GMR(123.3,"AC",+PROC)),1)
CPLINKS(NAMES,PROC) ;return list of procedure names linked to a CP
 ; Input
 ;   PROC - ien from PROCEDURE DEFINITION (#702.01)   - (required)
 ; Output:
 ;   NAMES - passed by reference 
 ;           returned as array of GMRC PROCEDUREs linked to PROC 
 ;           in format;
 ;             NAMES(x)=GMRC PROCEDURE name^GMRC PROCEDURE ien
 ;               NAMES(1)="EKG^21"
 ;               NAMES(2)="EKG PORTABLE^32"
 ;           if not currently linked, returned as:
 ;             NAMES(1)="-1^not currently linked"
 N GMRCPR,I
 S I=1,GMRCPR=0
 F  S GMRCPR=$O(^GMR(123.3,"AC",PROC,GMRCPR)) Q:'GMRCPR  D
 . S NAMES(I)=$P($G(^GMR(123.3,GMRCPR,0)),U)_U_GMRCPR
 . S I=I+1
 I '$D(NAMES(1)) S NAMES(1)="-1^not currently linked"
 Q
CPDOC(GMRCDA,TIUDA,ACTION) ;update file 123 entry with CLIN PROC DOC
 ; Input:
 ;   GMRCDA = ien from file 123
 ;   TIUDA  = ien from file 8925
 ;   ACTION = 1   - associate stub record
 ;          = 2   - partial results ready
 ;          = 3   - retract record
 ;
 ; Output: 
 ;   1       = successful
 ;   0^error = unsuccessful^problem 
 ;
 ;
 N QVAL,GMRCADUZ
 I '$D(^GMR(123,+GMRCDA,0)) Q "0^Invalid procedure record"
 I '$G(ACTION) Q "0^Invalid action code"
 I '$G(TIUDA) Q "0^No document to associate"
 S QVAL=""
 I ACTION=1 D  Q QVAL
 . S QVAL="0^Not a current API implementation"
 . Q
 I ACTION=2 D  Q QVAL
 . I $D(^GMR(123,+GMRCDA,50,"B",TIUDA_";TIU(8925")) Q
 . D GET^GMRCTIU(+GMRCDA,TIUDA,"INCOMPLETE") ;update to pr
 . D EN^GMRCT(+$P(^GMR(123,+GMRCDA,0),U,5)) ;get svc notif recips
 . I $D(GMRCADUZ) D
 .. N MSG,GMRCDFN,GMRCREF
 .. S MSG="Procedure ready for interpretation"
 .. S GMRCDFN=$P(^GMR(123,+GMRCDA,0),U,2)
 .. S GMRCREF=+GMRCDA_"|"_+TIUDA_";TIU(8925,"
 .. D MSG^GMRCP(GMRCDFN,MSG,GMRCREF,66,.GMRCADUZ,0) ;send #66 alert
 . S QVAL="1"
 . Q
 I ACTION=3 D  Q QVAL
 . I '$D(^GMR(123,+GMRCDA,50,"B",TIUDA_";TIU(8925")) D  Q
 .. S QVAL="0^Not an associated document"
 . D ROLLBACK^GMRCTIU1(+GMRCDA,+TIUDA)
 . S QVAL=1
 . Q
 Q
CPACTM(GMRCDA) ;return actions available for a CP request
 ;Input:
 ;  GMRCDA = file 123 ien
 ;Output:
 ;  0 = not a CP request or TIU*1*109 not present
 ;  1 = CP request but no instrument report expected
 ;  2 = CP and still waiting on instr. or images
 ;  3 = CP and incomplete CP doc attached
 ;  4 = CP and complete CP doc attached
 ;
 N EXTDTA,CPDOC
 I '$$PATCH^XPDUTL("TIU*1.0*109") Q 0
 I '$G(^GMR(123,GMRCDA,1)) Q 0
 S EXTDTA=$$EXTDATA^MDAPI(+^GMR(123,GMRCDA,1))
 S CPDOC=$G(^GMR(123,GMRCDA,50,+$O(^GMR(123,GMRCDA,50,0)),0))
 I 'EXTDTA,'+CPDOC Q 1 ;no ext & no stub
 I EXTDTA,'+CPDOC Q 2 ;ext data & no data
 I $$GET1^DIQ(8925,+CPDOC,.05)'="COMPLETED" Q 3 ;partial results
 Q 4 ;CP is done, allow additional CP titles
 ;
CPINTERP(GMRCTIU,GMRCUSER) ;is user an interpreter for TIU doc GMRCTIU
 ;
 ; Input:
 ;   GMRCTIU   = ien from file 8925
 ;   GMRCUSER  = DUZ of person to evaluate
 ;
 ; Output:
 ;   1 = GMRCUSER is an interpreter
 ;   0 = GMRCUSER is NOT an interpreter
 ;
 N GMRCSRV,GMRCDA,GMRCINT
 S GMRCDA=$O(^GMR(123,"R",GMRCTIU_";TIU(8925,",0))
 I 'GMRCDA Q 0 ;TIU doc not attached
 S GMRCSRV=$P(^GMR(123,+GMRCDA,0),U,5)
 I 'GMRCSRV Q 0 ;no service, can't tell if interpreter
 S GMRCINT=+$$VALID^GMRCAU(GMRCSRV,,GMRCUSER) ;get upd authority
 Q $S(GMRCINT=2:1,GMRCINT=4:1,1:0) ;2=upd user, 4=adm & upd user
 ;
CPPAT(GMRCDA,GMRCDFN) ;is patient object of given request?
 ; Input:
 ;  GMRCDA   = ien from file 123
 ;  GMRCDFN  = patient DFN
 ;
 ; Output:
 ;  1 = patient is object of request GMRCDA
 ;  0 = patient is NOT object of request in GMRCDA
 I $P($G(^GMR(123,GMRCDA,0)),U,2)'=GMRCDFN Q 0
 Q 1
