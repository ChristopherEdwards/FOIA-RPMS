SCAPMC28 ;ALB/REW - Patients with an Appointment ; Apr 3,1996 [ 12/06/2000  9:26 AM ]
 ;;5.3;Scheduling;**41,140**;AUG 13, 1993
 ;IHS/ANMC/LJF 12/06/2000 changed SSN to HRCN as Long Patient ID
 ;
 ;;1.0
PTAP(SCCL,SCDATES,SCMAXCNT,SCLIST,SCERR,MORE) ; -- list of patients with an appointment in a given clinic
 ; 
 ; input:
 ;  SCCL = Pointer to File #44
 ;  SCDATES("BEGIN") = begin date to search (inclusive)
 ;                      [default: TODAY]
 ;        ("END")   = end date to search (inclusive)
 ;                      [default: TODAY]
 ;        ("INCL")  = 1: only use patients who were assigned to
 ;                       team for entire date range
 ;                    0: anytime in date range
 ;                      [default: 1] 
 ;  SCMAXCNT        - Maximum # of patients to return, default=99
 ;  SCLIST -array name to store list
 ;          [ex. ^TMP("SCPT",$J)]
 ;        
 ;  SCERR = array NAME to store error messages.
 ;          [ex. ^TMP("ORXX",$J)]
 ;  MORE - This is a flag that says that this list exists and has been
 ;         aborted because it reached the maxcount.  If this =1 it means
 ;         'kill the old list & start where you finished'
 ;  Note: Don't Return DFNs where $D(^TMP("SCMC",$J,"EXCLUDE PT","SCPTA",+DFN)) is true
 ; Output:
 ;  SCLIST() = array of patients
 ;             Format:
 ;               Subscript: Sequential # from 1 to n
 ;               Piece     Description
 ;                 1       IEN of PATIENT file entry
 ;                 2       Name of patient
 ;                 3       ien to 40.7 - Not Stop Code!! stp=$$intstp
 ;                 4       AMIS reporting stop code
 ;                 5       Patient's Long ID (SSN)
 ;
 ; SCEFFDT - negative of effective date
 ; SCN     - current subscript (counter) 1->n
 ; SCPTA0   is 0 node of Patient Team Assignment file 1st piece is DFN
 ;  SCERR() = Array of DIALOG file messages(errors) .
 ;  @SCERR@(0)=number of errors, undefined if none
 ;             Foramt:
 ;               Subscript: Sequential # from 1 to n
 ;               Piece     Description
 ;                 1       IEN of DIALOG file
 ;
 ;   Returned: 1 if ok, 0 if error^More?
 ;
 ;
ST N SCEND,SCVSDT,SCSTART
 N SCLSEQ,SCN,SCESEQ,SCPARM,SCP,SCBEGIN,SCEND,SCINCL,SCDTS
 G:'$$OKDATA APQ ;check/setup variables
 ; -- loop through visit file
LP S SCDT=SCBEGIN
 S:'$P(SCEND,".",2) SCEND=$$FMADD^XLFDT(SCEND,1) ;ending is end of day
 IF $G(MORE) D
 .S SCSTART=$P($G(@SCLIST@(0)),U,2)
 .S SCBEGIN=$P($G(@SCLIST@(0)),U,3)
 .K @SCLIST
APQ Q $$PTAPX(.SCCL,.SCBEGIN,.SCEND,.SCMAXCNT,.SCLIST,.SCERR,.SCSTART)
 ;
PTAPX(SCCL,SCBEGIN,SCEND,MAXCNT,SCLIST,SCERR,SCSTART) ;return appointments in dt range
 ; Input: (As above plus:)
 ;    SCSTART - Continue with list at this point
 ; output: SCN - COUNT OF PTS
 ; returns:      dfn^ptname^clinic^apptdt^long id
 N SCDT,SCD2,DFN
 S SCDT=SCBEGIN
 F  S SCDT=$O(^SC(SCCL,"S",SCDT)) Q:'SCDT!(SCDT>SCEND)!(SCN'<SCMAXCNT)  D
 .S SCD2=+$G(SCSTART)
 .S SCSTART=0
 .F  S SCD2=$O(^SC(SCCL,"S",SCDT,1,SCD2)) Q:'SCD2!(SCN'<SCMAXCNT)  D
 ..S DFN=+$G(^SC(SCCL,"S",SCDT,1,SCD2,0))
 ..Q:$D(@SCLIST@("SCPTAP",+DFN))
 ..Q:$D(^TMP("SCMC",$J,"EXCLUDE PT","SCPTA",+DFN))
 ..S SCN=$G(@SCLIST@(0))+1
 ..S @SCLIST@(0)=SCN
 ..;S @SCLIST@(SCN)=DFN_U_$P($G(^DPT(+DFN,0)),U,1)_U_SCCL_U_SCDT_U_$P($G(^DPT(+DFN,.36)),U,3)  ;IHS/ANMC/LJF 12/06/2000
 ..S @SCLIST@(SCN)=DFN_U_$P($G(^DPT(+DFN,0)),U,1)_U_SCCL_U_SCDT_U_$$HRCN^BDGF2(DFN,+$G(DUZ(2)))  ;IHS/ANMC/LJF 12/06/2000
 ..S @SCLIST@("SCPTAP",+DFN,+SCN)=""
 S:(SCN'<SCMAXCNT) @SCLIST@(0)=SCN_U_+$G(SCD2)_U_+$G(SCDT)_U_+$G(SCCL)
 Q ($G(@SCERR@(0))<1)_U_(SCN'<SCMAXCNT)
 ;
OKDATA() ;check/setup variables
 N SCOK
 S SCOK=1
 S SCMAXCNT=$G(SCMAXCNT,99)
 D INIT^SCAPMCU1(.SCOK) ; set default dates & error array (if undefined)
 IF '$D(^SC(+$G(SCCL),0)) D  S SCOK=0
 . S SCPARM("CLINIC")=$G(SCCL,"Undefined")
 . D ERR^SCAPMCU1(.SCESEQ,4045101,.SCPARM,"",.SCERR)
 ; -- is it a valid TEAM ien passed (Error # 4045101 in DIALOG file)
 Q SCOK
