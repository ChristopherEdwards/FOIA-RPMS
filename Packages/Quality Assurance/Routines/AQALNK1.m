AQALNK1 ; IHS/ORDC/LJF - EDIT/DELETE AUTO OCCURRENCES ;
 ;;1;QI LINKAGES-RPMS;;AUG 15, 1994
 ;
 ;This rtn is available to RPMS packages that wish to automatically
 ;edit or delete occurrence entries.  The input variables are:
 ;
 ; AQALNK("OCC")=ifn of occurrence to modify or delete
 ; AQALNK("PAT")=patient's DFN (required)
 ; AQALNK("IND")=internal entry # for indicator (required)
 ; AQALNK("DATE")=occurrence date (required)
 ; AQALNK("VSIT")=visit internal number (optional but recommended)
 ; AQALNK("HSV")=hospital service for visit (required but can be null)
 ; AQALNK("WARD")=ward moved into fro admits, out of for others
 ; AQALNK("FAC")=facility internal number (required if no visit #)
 ; AQALNK("DUP OK")=if defined, allows adding duplicate occurrence
 ; AQALNK("BUL")=name of error bulletin
 ; AQALXTR array for data to be stuffed into case summary field
 ;
 ;The output variables will include those listed above AND 
 ; AQALIFN=occurrence internal entry number   OR
 ; AQALNKF("NO GO")=set if occurrence not created PLUS
 ;  AQALNKF("PAT")=if set, describes patient error
 ;  AQALNKF("IND")=if set, describes indicator error
 ;  AQALNKF("DATE")=if set, describes occurrence date error
 ;  AQALNKF("VSIT")=if set, describes visit error
 ;  AQALNKF("FAC")=if set, describes facility error
 ;
 ;The calling routine will be responsible for killing the variables
 ;described above.  This routine will kill all other AQA variables used.
 ;The published entry is EDIT^AQALNK1.
 ;
EDIT ;PEP; PUBLIC ENTRY POINT to create occurrences
 ; >>> check input variables
 K AQALNKF,AQALIFN
 F I="OCC","PAT","IND","DATE","FAC" D
 .I '$D(AQALNK(I)) S AQALNKF(I)="Variable AQALNK("_I_") is missing" Q
 .I AQALNK(I)="" S AQALNKF(I)="Variable set but null"
 I $D(AQALNKF) G EXIT ;quit if error flags set
 ;
 D VARCHECK^AQALNK ;check validity of input variables
 I $D(AQALNKF) G EXIT ;quit if error flags set
 I '$D(AQALNK("VSIT")) S AQALNK("VSIT")=""
 ;
 ;
DIE ; >>> set variables and call file^dicn
 S AQALPAT=AQALNK("PAT"),AQALDATE=AQALNK("DATE"),AQALIND=AQALNK("IND")
 S AQAODATE=AQALDATE,AQAOPAT=AQALPAT,AQAOIND=AQALIND
 S AQALCID=$P($G(^AQAOC(AQALNK("OCC"),0)),U) ; occ id number
 I '$D(AQALCID) S AQALNKF("NO GO")="Occurrence in xref but not in file" G EXIT
 ;
 K DIE S DIE="^AQAOC(",(AQALIFN,DA)=AQALNK("OCC")
 S DR=".02////"_AQALPAT_";.03////"_AQALNK("VSIT")_";.04////"_AQALDATE_";.06////"_AQALNK("WARD")_";.07////"_AQALNK("HSV")_";.08////"_AQALIND_";.09////"_AQALNK("FAC")_";.011////1;.11////0"
 L +(^AQAOC(AQALNK("OCC"))):1 I '$T D  G EXIT
 .S AQALNKF("NO GO")="Occurrence entry locked; could not edit"
 L +(^AQAGU(0)):1 I '$T D  G EXIT
 .S AQALNKF("NO GO")="QI Audit file locked; could not edit"
 D ^DIE L -(^AQAOC(AQALNK("OCC")))
 ;
AUDIT S AQAOUDIT("DA")=AQALNK("OCC"),AQAOUDIT("ACTION")="O"
 S AQAOUDIT("COMMENT")="EDIT A RECORD-AUTO LINK" D ^AQAOAUD
 ;
SUMM ; >>> add xtra data to case summary wp field
 S (AQALSTX,AQALST)=0
 F  S AQALST=$O(AQALXTR(AQALST)) Q:AQALST=""  D
 .S ^AQAOC(AQALIFN,"CASE",AQALST,0)=AQALXTR(AQALST),AQALSTX=AQALST
 I '$D(^AQAOC(AQALIFN,"CASE",0)) S:+AQALSTX ^AQAOC(AQALIFN,"CASE",0)=U_U_AQALSTX_U_AQALSTX_U_DT
 ;
EXIT ; >>> eoj
 K AQAOPAT,AQAODATE,AQAOIND,DIC,X,Y,I
 I $D(AQALNKF),$D(AQALNK("BUL")) D ^AQALNKER Q  ;send error bulletin
 W !!,"QAI Occurrence modified for this transaction: "
 W "(",$P($P(^DD(AQALF,AQALEV,0),U),"LINK"),")",!
 Q
 ;
 ;
DEL(N) ;PEP; PUBLIC ENTRY POINT to delete an occurrence
 ;input variable N=occ ifn
 S AQALIFN=N
 L +^AQAOC(AQALIFN):1 I '$T D  D EXIT Q
 .S AQALNKF("NO GO")="Another user editing occ; cannot delete"
 L +^AQAGU(0):1 I '$T D  D EXIT Q
 .S AQALNKF("NO GO")="Audit file locked; cannot delete occurrence"
 ;
 S AQAOUDIT("DA")=AQALIFN,AQAOUDIT("ACTION")="D"
 S AQAOUDIT("COMMENT")="DELETING RECORD-AUTO LINK" D ^AQAOAUD
 S DIE="^AQAOC(",DA=AQALIFN,DR=".11////2;.112////EVENT EDITED IN RPMS"
 D ^DIE L -^AQAOC(AQALIFN)
 W !!,"QAI Occurrence deleted for this transaction: "
 W "(",$P($G(^AQAO(2,$P(^AQAOC(AQALIFN,0),U,8),0)),U),")",!
 Q
