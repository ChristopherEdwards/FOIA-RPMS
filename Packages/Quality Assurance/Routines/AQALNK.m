AQALNK ; IHS/ORDC/LJF - CREATES OCC FROM OTHER PKGS ;
 ;;1;QI LINKAGES-RPMS;;AUG 15, 1994
 ;
 ;This rtn is available to RPMS packages that wish to automatically
 ;create occurrence entries.  The input variables are:
 ;
 ; AQALNK("PAT")=patient's DFN (required)
 ; AQALNK("IND")=internal entry # for indicator (required)
 ; AQALNK("DATE")=occurrence date (required)
 ; AQALNK("VSIT")=visit internal number (optional but recommended)
 ; AQALNK("HSV")=hospital service for visit (required but can be null)
 ; AQALNK("WARD")=ward moved into for admits, out of for others
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
 ;The published entry point is CREATE^AQALNK.
 ;
CREATE ;PEP; PUBLIC ENTRY POINT to create occurrences
 ; >>> check input variables
 K AQALNKF,AQALIFN
 F I="PAT","IND","DATE","FAC" D
 .I '$D(AQALNK(I)) S AQALNKF(I)="Variable AQALNK("_I_") is missing" Q
 .I AQALNK(I)="" S AQALNKF(I)="Variable set but null"
 I $D(AQALNKF) G EXIT ;quit if error flags set
 ;
 D VARCHECK ;check validity of input variables
 I $D(AQALNKF) G EXIT ;quit if error flags set
 I '$D(AQALNK("VSIT")) S AQALNK("VSIT")=""
 ;
DUPCHECK ; >>> check if duplicate entry allowed
 I $D(AQALNK("DUP OK")) G ADD ;okay to add duplicate entry
 ;                            ;quit if occurrence already exists
 G EXIT:$D(^AQAOC("AA",AQALNK("IND"),AQALNK("DATE"),AQALNK("PAT")))
 ;
ADD ; >>> set variables and call file^dicn
 S AQALPAT=AQALNK("PAT"),AQALDATE=AQALNK("DATE"),AQALIND=AQALNK("IND")
 S AQAODATE=AQALDATE,AQAOPAT=AQALPAT,AQAOIND=AQALIND
 S AQALCID=$$OCCID^AQAOCID ;create occ id number
 I '$D(AQALCID) S AQALNKF("NO GO")="Couldn't create occ ID #" G EXIT
 ;
 K DD,DO,DIC S DIC="^AQAOC(",DIC(0)="L",X=AQALCID
 S DIC("DR")=".02////"_AQALPAT_";.03////"_AQALNK("VSIT")_";.04////"_AQALDATE_";.06////"_AQALNK("WARD")_";.07////"_AQALNK("HSV")_";.08////"_AQALIND_";.09////"_AQALNK("FAC")_";.011////1;.11////0"
 L +(^AQAOC(0)):1 I '$T D  G EXIT
 .S AQALNKF("NO GO")="Occurrence file locked; could not add"
 L +(^AQAGU(0)):1 I '$T D  G EXIT
 .S AQALNKF("NO GO")="QI Audit file locked; could not add"
 D FILE^DICN L -(^AQAOC(0))
 I Y=-1 S AQALNKF("NO GO")="Add thru FILE^DICN didn't work" G EXIT
 S AQALIFN=+Y
 ;
AUDIT S AQAOUDIT("DA")=AQALIFN,AQAOUDIT("ACTION")="O"
 S AQAOUDIT("COMMENT")="OPEN A RECORD-AUTO LINK" D ^AQAOAUD
 ;
SUMM ; >>> add xtra data to case summary wp field
 G EXIT:$O(^AQAOC(AQALIFN,"CASE",0)) ;already data in case summary field
 S (AQALSTX,AQALST)=0
 F  S AQALST=$O(AQALXTR(AQALST)) Q:AQALST=""  D
 .S ^AQAOC(AQALIFN,"CASE",AQALST,0)=AQALXTR(AQALST),AQALSTX=AQALST
 S:+AQALSTX ^AQAOC(AQALIFN,"CASE",0)=U_U_AQALSTX_U_AQALSTX_DT
 ;
EXIT ; >>> eoj
 K AQAOPAT,AQAODATE,AQAOIND,DIC,X,Y,I
 I $D(AQALNKF),$D(AQALNK("BUL")) D ^AQALNKER Q  ;send error bulletin
 W !!,"QAI Occurrence created for this transaction: "
 W "(",$P($P(^DD(AQALF,AQALEV,0),U),"LINK"),")",!
 Q
 ;
 ;
VARCHECK ;EP >>> SUBRTN to check input variables
 ;called by this rtn and ^AQALNK1
 I '$D(^DPT(AQALNK("PAT"),0)) S AQALNKF("PAT")="Bad patient DFN" Q
 S:$P(^DPT(AQALNK("PAT"),0),U,19)'="" AQALNKF("PAT")="Merged Patient"
 S:'$D(^AQAO(2,AQALNK("IND"),0)) AQALNKF("IND")="Bad indicator ifn" Q
 S:$P(^AQAO(2,AQALNK("IND"),0),U,6)="I" AQALNKF("IND")="Inactive indicator"
 I $G(AQALNK("VSIT"))>0 D
 .S:'$D(^AUPNVSIT(AQALNK("VSIT"),0)) AQALNKF("VSIT")="Bad visit ifn" Q
 .S X=^AUPNVSIT(AQALNK("VSIT"),0) ;set visit node
 .S:$P(X,U,11)=1 AQALNKF("VSIT")="Deleted visit"
 .S:$P(X,U,5)'=AQALNK("PAT") AQALNKF("VSIT")="Visit not for patient"
 S:'$D(^APCDSITE("B",AQALNK("FAC"))) AQALNKF("FAC")="Not PCC site"
 S:'$D(^AUPNPAT(AQALNK("PAT"),41,AQALNK("FAC"),0)) AQALNKF("FAC")="Patient doesn't have chart # for facility"
 S X=AQALNK("DATE") I +X<1000000 S AQALNKF("DATE")="Invalid date"
 I (X<1000000)!(X>DT) S AQALNKF("DATE")="Can't have future dates"
 I X<$P(^DPT(AQALNK("PAT"),0),U,3) S AQALNKF("DATE")="Occ before DOB"
 Q:'$D(^DPT(AQALNK("PAT"),.35))  I $P(^(.35),U)="" Q  ;not dead
 I X>+^DPT(AQALNK("PAT"),.35) S AQALNKF("DATE")="Occ after DOD"
 Q
