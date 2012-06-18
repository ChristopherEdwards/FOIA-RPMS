BWCBE ;IHS/ANMC/MWR - UTIL: MOSTLY PATIENT DATA;15-Feb-2003 21:49;PLS
 ;;2.0;WOMEN'S HEALTH;**1,8**;MAR 30, 2001
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CREATE CBE PROCEDURE IN WOMEN'S HEALTH FOR THIS PATIENT.
 ;
 ;
EP(PATDFN,VSIT,VFIEN) ;EP - called from template (APCD CBE (ADD))
 I '$G(PATDFN) Q
 I '$G(VSIT) Q
 S VFIEN=$G(VFIEN)
 ;S VFRES=$G(VFRES)
 S APCDTRES="" ;result to pass back to V EXAM
 D EN^XBNEW("EP1^BWCBE","PATDFN;VSIT;VFIEN;APCDTRES")
 Q
EP1 ;EP - called from xbnew
 NEW RESULT,ERR
 S (ERR,APCDTRES)=""
 ;get result
 S BWPN=27,DIR(0)="9002086.1,.05O",DIR("A")="Enter RESULTS/DIAGNOSIS" KILL DA D ^DIR KILL DIR
 S RESULT=Y
 D ADD(ERR,PATDFN,$P(^AUPNVSIT(VSIT,0),U),VSIT,RESULT,$$PRIMPROV^APCLV(VSIT),VFIEN)
 I ERR]"" W "I got an error"
 Q
 ;----------
ADD(BWERR,BWDFN,BWPCCDT,BWVST,BWDX,BWPROV,BWVFDA) ;EP
 ;---> Add a CBE (Clinical Breast Exam) to this patient.
 ;---> Parameters:
 ;     1 - BWERR   (ret) Text of error, if any.
 ;     2 - BWDFN   (req) DFN of patient.
 ;     3 - BWPCCDT (req) PCC Visit Date/Time.
 ;     4 - BWVST   (opt) Visit IEN (if any) to link this CBE to.
 ;     5 - BWDX    (opt) IEN in BW RESULTS/DIAGNOSIS File #9002086.31.
 ;     6 - BWPROV  (opt) Provider pointer to #200.
 ;
 ;---> If DFN not provided, set Error Code and quit.
 I '$G(BWDFN) D  Q
 .S BWERR="Software error: Patient DFN not provided."
 ;
 ;---> Set required variables.
 D ^XBKVAR S BWERR=""
 ;
 ;
PATIENT ;---> If Patient isn't in Women's Health Database, add her.
 I '$D(^BWP(BWDFN,0)) D
 .D AUTOADD^BWPATE(BWDFN,DUZ(2),.BWERR)
 .S:BWERR<0 BWERR="Software error: Failed to add new patient."
 Q:BWERR]""
 ;
 ;
PROC ;---> Create CBE Procedure in BW PROCEDURE File #9002086.1.
 ;---> 27=IEN of Procedure Type in File #9002086.2.
 ;
 ;---> Optional use of DR string.
 N BWDA,BWDR
 S BWDR=".02////"_BWDFN_";.03////"_$G(BWPCCDT)_";.04////27"
 S BWDR=BWDR_";.05////"_$G(BWDX)_";.07////"_$G(BWPROV)
 S BWDR=BWDR_";.1////"_DUZ(2)_";.11////"_$G(BWLOC)
 S BWDR=BWDR_";.12////"_$P($G(BWPCCDT),".")_";.14////"_$G(BWSTAT)
 S BWDR=BWDR_";.18////"_DUZ_";.19////"_DT
 ;
 D NEW2^BWPROC(BWDFN,27,BWPCCDT,BWDR,"",.BWDA,.BWERR)
 I BWERR<0 D  Q
 .S BWERR="Software error: Failed to create CBE in Women's Health."
 ;
 ;---> BWDA=IEN of just created Procedure in BW PROCEDURE File.
 ;---> Following line will call ^APCDALV and ^APCDALVR.
 ;---> Call to APCDALV will look for same date Visit and prompt
 ;---> if time does not match.  (See +53^BWPCC.)
 ;D CREATE^BWPCC(BWDA,DUZ(2),$G(^BWPCD(BWDA,0)))
 N X S X=$$NORMAL^BWUTL4($P(^BWPCD(BWDA,0),U,5))
 S:X<2 APCDTRES=$S(X:"A",1:"N")
STORE ;---> STORE VISIT AND V FILE IEN'S IN WH PROCEDURE FILE #9002086.1.
 I $G(BWDA) D
 .N DR
 .S DR="5.01////"_BWVST_";5.02////"_BWVFDA
 .D DIE^BWFMAN(9002086.1,DR,BWDA,.BWPOP)
 ;
 ;---> Or, if Visit IEN is known, set required variables and
 ;---> call VFILE^BWPCC.
 Q
