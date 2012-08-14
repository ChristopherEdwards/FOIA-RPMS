TIUSRVLL ; SLC/JER - Server functions for LOCAL lists ;7/16/01
 ;;1.0;TEXT INTEGRATION UTILITIES;**1,100,121,143**;Jun 20, 1997
LIST(TIUY,CLASS,DFN,EARLY,LATE) ; Build List user can select from to browse
 N TIUCNT,TIUDT,TIUI,TIUJ,TIUK,TIUP,TIUQ,TIUREC,TIUPRM0,TIUPRM1
 N TIUPRM3,TIUT,TIUTP,XREF,TIUS,TIUCONT,TIUSTAT,TIUTYPE
 I '$D(TIUPRM0) D SETPARM^TIULE
 S EARLY=9999999-+$G(EARLY),TIUCNT=0
 S (TIUI,LATE)=9999999-$S(+$G(LATE):+$G(LATE),1:3333333)
 F  S TIUI=$O(^TIU(8925,"APTCL",DFN,CLASS,TIUI)) Q:+TIUI'>0!(+TIUI>EARLY)  D GATHER(.TIUY,DFN,CLASS,TIUI)
 Q
GATHER(TIUY,DFN,CLASS,TIUI) ; Find/sort records for the list to browse
 N TIUDA
 S TIUDA=0
 F  S TIUDA=$O(^TIU(8925,"APTCL",DFN,CLASS,TIUI,TIUDA)) Q:+TIUDA'>0  D
 . I ($P(TIUPRM0,U,6)="S"),(+$$CANDO^TIULP(TIUDA,"VIEW")'>0) Q
 . I +$G(^TIU(8925,+TIUDA,0))'>0 K ^TIU(8925,"APTCL",DFN,CLASS,TIUI,TIUDA) Q
 . I +$G(^TIU(8925,+TIUDA,0))=81,(+$P($G(^(0)),U,5)>5) Q
 . S TIUCNT=+$G(TIUCNT)+1
 . S ^TMP("TIUYLIST",$J,TIUCNT)=TIUDA,TIUY=TIUCNT ; TIU*1.0*143
 . ; S TIUY(TIUCNT)=TIUDA,TIUY=TIUCNT ; pre-143 code
 Q
 ;
CONTEXT(TIUY,CLASS,CONTEXT,DFN,EARLY,LATE,PERSON,OCCLIM,SEQUENCE,TIUEXPKD) ; main
 ; --- Call with:  TIUY     - Return array, pass by reference
 ;                 CLASS    - Pointer to TIU DOCUMENT DEFINITION #8925.1
 ;                 CONTEXT  - 1=All Signed (by PT),
 ;                          - 2="Unsigned (by PT&(AUTHOR!TANSCRIBER))
 ;                          - 3="Uncosigned (by PT&EXPECTED COSIGNER
 ;                          - 4="Signed notes (by PT&selected author)
 ;                          - 5="Signed notes (by PT&date range)
 ;                 DFN      - Pointer to Patient (#2)
 ;                [EARLY]   - FM date/time to begin search
 ;                [LATE]    - FM date/time to end search
 ;                [PERSON]  - Pointer to file 200 (DUZ if not passed)
 ;                [OCCLIM]  - Occurrence Limit (optional)
 ;               [SEQUENCE] - "A"=ascending (Regular date/time) (dflt)
 ;                          - "D"=descending (Reverse date/time)
 ;               [TIUEXPKD] - Return array, pass by ref.
 ;                            TIUEXPKD(IFN)="", where we will expand IFN
 ;                            so ID kids/adda that meet criteria are
 ;                            displayed under it.
 K TIUY S TIUY=0
 I $G(CONTEXT)'>0 Q
 I $G(CLASS)'>0 Q
 S:+$G(EARLY)'>0 EARLY=0
 S:+$G(LATE)'>0 LATE=5000000
 S:+$G(PERSON)'>0 PERSON=DUZ
 S:$G(SEQUENCE)']"" SEQUENCE="D"
 S:+$G(OCCLIM)'>0 OCCLIM=9999999
 S DFN=+$G(DFN)
 S EARLY=9999999-EARLY,LATE=9999999-LATE ; CHANGE TO REVERSE DATES
 ; --------------------
 I CONTEXT=1!(CONTEXT=5) D  Q
 . D ACLPT(.TIUY,CLASS,DFN,LATE,EARLY,OCCLIM,SEQUENCE)
 ; --------------------
 I CONTEXT=2 D  Q
 . I DFN>0 D  Q
 . . D ACLAU(.TIUY,CLASS,PERSON,DFN,LATE,EARLY,SEQUENCE,.TIUEXPKD)
 . F DFN=0:0 S DFN=$O(^TIU(8925,"ACLAU",CLASS,PERSON,DFN)) Q:DFN'>0  D ACLAU(.TIUY,CLASS,PERSON,DFN,LATE,EARLY,SEQUENCE,.TIUEXPKD)
 ; --------------------
 I CONTEXT=3 D  Q
 . I DFN>0 D  Q
 . . D ACLEC(.TIUY,CLASS,PERSON,DFN,LATE,EARLY,SEQUENCE,.TIUEXPKD)
 . F DFN=0:0 S DFN=$O(^TIU(8925,"ACLEC",CLASS,PERSON,DFN)) Q:DFN'>0  D ACLEC(.TIUY,CLASS,PERSON,DFN,LATE,EARLY,SEQUENCE,.TIUEXPKD)
 ; --------------------
 I CONTEXT=4 D  Q
 . I DFN>0 D  Q
 . . D ACLSB(.TIUY,CLASS,PERSON,DFN,LATE,EARLY,SEQUENCE,.TIUEXPKD)
 . F DFN=0:0 S DFN=$O(^TIU(8925,"ACLSB",CLASS,PERSON,DFN)) Q:DFN'>0  D ACLSB(.TIUY,CLASS,PERSON,DFN,LATE,EARLY,SEQUENCE,.TIUEXPKD)
 Q
 ;
ACLPT(ARRAY,CLASS,DFN,TIME1,TIME2,OCCLIM,SEQUENCE) ; Signed,
 ;by patient, [& date].
 N DATTIM,DA,ROOT,TIUORDER
 K ^TMP("TIUREPLACE",$J)
 S ROOT=$NA(^TIU(8925,"ACLPT",CLASS,DFN))
 S DATTIM=TIME1-.0000001
 ; Since date/time is inverted, set subscripts forward for descending:
 S TIUORDER=$S(SEQUENCE="D":1,1:-1)
 F  S DATTIM=$O(@ROOT@(DATTIM)) Q:$S(+DATTIM'>0:1,+DATTIM>TIME2:1,+$G(^TMP("TIUREPLACE",$J))'<OCCLIM:1,1:0)  D
 . F DA=0:0 S DA=$O(@ROOT@(DATTIM,DA)) Q:DA'>0  D
 . . I +$G(^TIU(8925,+DA,0))'>0 K @ROOT@(DATTIM,DA) Q
 . . I +^TIU(8925,+DA,0)=81 Q
 . . ; -- Set records into ^TMP("TIUREPLACE",$J),
 . . ;    replacing kids w parents:
 . . D REPLACE(DA,DATTIM)
 ; B 1
 D SETARRY(.ARRAY,TIUORDER)
 K ^TMP("TIUREPLACE",$J)
 Q
 ;
SETARRY(ARRAY,TIUORDER) ; Set ARRAY(SUB)=DA, which is passed
 ;back to CONTEXT.  ARRAY holds the right records, in the right order
 ;for the List Template list.
 ; TIUORDER=1 or -1: Set ARRAY subscripts forward 1,2 etc., or
 ;backward -1,-2, etc.
 ; Requires ^TMP("TIUREPLACE",$J),
 ;with ID kids or adda replaced by parents.
 ; B 1
 N DATTIM,TIUDA,SUB
 S DATTIM=0
 S SUB=0
 F  S DATTIM=$O(^TMP("TIUREPLACE",$J,DATTIM)) Q:'DATTIM  D
 . S TIUDA=0
 . F  S TIUDA=$O(^TMP("TIUREPLACE",$J,DATTIM,TIUDA)) Q:'TIUDA  D
 . . S SUB=SUB+TIUORDER
 . . S ^TMP("TIUYARRAY",$J,SUB)=TIUDA ; TIU*1.0*143
 . . ; S ARRAY(SUB)=TIUDA ; original code
 Q
 ;
REPLACE(TIUDA,DATTIM,EXPAND,FORGETAD) ; Populate ^TMP("TIUREPLACE",$J) with
 ;records that meet criteria, replacing ID kids or addenda with
 ;their parents.
 ; Requires TIUDA, DATTIM;
 ; opt flag FORGETAD - if 1, don't add note to the expand list
 ;merely because of an addendum.  Used in search by title.
 ; Passes back array EXPAND.
 ; Sort by ref date/time
 N IDPRNT,ADDMPRNT,ADDMGPNT,PDATTIM,GPDATTIM
 S IDPRNT=+$G(^TIU(8925,TIUDA,21)) ; ID parent
 I '$D(^TIU(8925,IDPRNT,0)) S IDPRNT=0
 I IDPRNT S PDATTIM=+^TIU(8925,IDPRNT,13),PDATTIM=9999999-PDATTIM
 S ADDMPRNT=+$P(^TIU(8925,TIUDA,0),U,6) ; assume TIUDA is not component
 I '$D(^TIU(8925,ADDMPRNT,0)) S ADDMPRNT=0
 I ADDMPRNT S PDATTIM=+^TIU(8925,ADDMPRNT,13),PDATTIM=9999999-PDATTIM
 ; -- If TIUDA is not an ID kid, not addm, just put it
 ;    in array and quit: --
 S EXPAND=+$G(EXPAND)
 I 'IDPRNT,'ADDMPRNT D  Q
 . Q:$D(^TMP("TIUREPLACE",$J,DATTIM,TIUDA))
 . S ^TMP("TIUREPLACE",$J,DATTIM,TIUDA)=""
 . S ^TMP("TIUREPLACE",$J)=$G(^TMP("TIUREPLACE",$J))+1
 ; -- If TIUDA is an ID kid, put its parent in array:
 I IDPRNT D  Q
 . I '$D(EXPAND(IDPRNT)) S EXPAND(IDPRNT)="",EXPAND=EXPAND+1
 . Q:$D(^TMP("TIUREPLACE",$J,PDATTIM,IDPRNT))
 . S ^TMP("TIUREPLACE",$J,PDATTIM,IDPRNT)=""
 . S ^TMP("TIUREPLACE",$J)=$G(^TMP("TIUREPLACE",$J))+1
 ; -- If TIUDA is an addendum, put its parent/gprnt in array:
 I ADDMPRNT D  Q
 . I '$G(FORGETAD),'$D(EXPAND(ADDMPRNT)) S EXPAND(ADDMPRNT)="",EXPAND=EXPAND+1
 . S ADDMGPNT=+$G(^TIU(8925,ADDMPRNT,21))
 . I '$D(^TIU(8925,ADDMGPNT,0)) S ADDMGPNT=0
 . I ADDMGPNT D  I 1
 . . S GPDATTIM=+^TIU(8925,ADDMGPNT,13),GPDATTIM=9999999-GPDATTIM
 . . I '$D(EXPAND(ADDMGPNT)) S EXPAND(ADDMGPNT)="",EXPAND=EXPAND+1
 . . Q:$D(^TMP("TIUREPLACE",$J,GPDATTIM,ADDMGPNT))
 . . S ^TMP("TIUREPLACE",$J,GPDATTIM,ADDMGPNT)=""
 . . S ^TMP("TIUREPLACE",$J)=$G(^TMP("TIUREPLACE",$J))+1
 . E  D
 . . Q:$D(^TMP("TIUREPLACE",$J,PDATTIM,ADDMPRNT))
 . . S ^TMP("TIUREPLACE",$J,PDATTIM,ADDMPRNT)=""
 . . S ^TMP("TIUREPLACE",$J)=$G(^TMP("TIUREPLACE",$J))+1
 Q
ACLAU(ARRAY,CLASS,AUTHOR,DFN,TIME1,TIME2,SEQUENCE,TIUEXPKD) ; Unsigned
 N DATTIM,DA,ROOT,TIUORDER
 K ^TMP("TIUREPLACE",$J)
 S ROOT=$NA(^TIU(8925,"ACLAU",CLASS,AUTHOR,DFN))
 S DATTIM=TIME1-.0000001
 S TIUORDER=$S(SEQUENCE="D":1,1:-1)
 F  S DATTIM=$O(@ROOT@(DATTIM)) Q:DATTIM'>0!(DATTIM>TIME2)  D
 . S DA=0 F  S DA=$O(@ROOT@(DATTIM,DA)) Q:DA'>0  D
 . . I +$P($G(^TIU(8925,DA,0)),U,5)>6 K @ROOT@(DATTIM,DA) Q
 . . I +$G(^TIU(8925,DA,0))'>0 K @ROOT@(DATTIM,DA) Q
 . . ; Don't include ID kids or parents in top level of list;
 . . ; Do expand kids
 . . D REPLACE(DA,DATTIM,.TIUEXPKD)
 D SETARRY(.ARRAY,TIUORDER)
 K ^TMP("TIUREPLACE",$J)
 Q
ACLEC(ARRAY,CLASS,EXCOSIGN,DFN,TIME1,TIME2,SEQUENCE,TIUEXPKD) ; Uncosigned
 N DATTIM,DA,ROOT,TIUORDER
 K ^TMP("TIUREPLACE",$J)
 S ROOT=$NA(^TIU(8925,"ACLEC",CLASS,EXCOSIGN,DFN))
 S DATTIM=TIME1-.0000001
 S TIUORDER=$S(SEQUENCE="D":1,1:-1)
 F  S DATTIM=$O(@ROOT@(DATTIM)) Q:DATTIM'>0!(DATTIM>TIME2)  D
 . S DA=0 F  S DA=$O(@ROOT@(DATTIM,DA)) Q:DA'>0  D
 . . I +$G(^TIU(8925,DA,0))'>0 K @ROOT@(DATTIM,DA)
 . . D REPLACE(DA,DATTIM,.TIUEXPKD)
 D SETARRY(.ARRAY,TIUORDER)
 K ^TMP("TIUREPLACE",$J)
 Q
ACLSB(ARRAY,CLASS,SIGNEDBY,DFN,TIME1,TIME2,SEQUENCE,TIUEXPKD) ; Signed, by author
 N DATTIM,DA,ROOT,TIUORDER
 K ^TMP("TIUREPLACE",$J)
 S ROOT=$NA(^TIU(8925,"ACLSB",CLASS,SIGNEDBY,DFN))
 S DATTIM=TIME1-.0000001
 S TIUORDER=$S(SEQUENCE="D":1,1:-1)
 F  S DATTIM=$O(@ROOT@(DATTIM)) Q:DATTIM'>0!(DATTIM>TIME2)  D
 . S DA=0 F  S DA=$O(@ROOT@(DATTIM,DA)) Q:DA'>0  D
 . . I +$G(^TIU(8925,DA,0))'>0 K @ROOT@(DATTIM,DA)
 . . D REPLACE(DA,DATTIM,.TIUEXPKD)
 D SETARRY(.ARRAY,TIUORDER)
 K ^TMP("TIUREPLACE",$J)
 Q