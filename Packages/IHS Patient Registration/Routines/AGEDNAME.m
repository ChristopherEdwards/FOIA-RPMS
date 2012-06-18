AGEDNAME ;IHS/ASDST/GTH - NAME STANDARDIZATION REPORT ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
TXT ;
 ;;This report is intended to help in Patient identification by searching
 ;;through all the various ways that PtReg collects "NAME"s of patients,
 ;;and checking them for conformance to standard formats for names used
 ;;by the I/T/Us:
 ;;     1...Use from 3 to 30 letters
 ;;     2...a COMMA MUST FOLLOW THE LAST NAME
 ;;     3...If "JR" or "II", etc, is included, follow the form
 ;;         SMITH,JOHN MARK,JR.
 ;;     4...NO SPACES after commas.
 ;;The following name fields are checked:
 ;; PATIENT NAME, EMERGENCY CONTACT, FATHER'S NAME, MOTHER'S MAIDEN
 ;; NAME, OTHER NAME (ALIASES), NAME OF INSURED (MCD), NAME OF POLICY
 ;; HOLDER, NAME OF INSURED (PVT), and NEXT OF KIN.
 ;;  
 ;;Deleted or Merge'd patients are not checked.
 ;;###
TXT1 ;
 ;;In the following report, the value of FIELD indicates where to go in
 ;;the PtReg application to correct the VALUE.  Here's the fields that
 ;;are checked, and corresponding locations in RPMS PtReg, by page number
 ;;and field number that are used on the "Patient Registration" option
 ;;or the pages on the "EDIT a patient's file" option:
 ;;
 ;; Field                 Option                Page#  Field#
 ;; --------------------  ---------------------   ---    ---
 ;; PATIENT NAME          Patient Registration (NAM)
 ;; EMERGENCY CONTACT     EDIT a patient's file     3     1
 ;; FATHER'S NAME         EDIT a patient's file     3     8
 ;; MOTHER'S MAIDEN NAME  EDIT a patient's file     3    11
 ;; OTHER NAME (ALIASES)  EDIT a patient's file     8     4
 ;; NAME OF INSURED (MCD) EDIT a patient's file     5   "E"
 ;; NAME OF POLICY HOLDER EDIT a patient's file    7a   "E"
 ;; NAME OF INSURED (PVT) EDIT a patient's file    7a   "E"
 ;; NEXT OF KIN           EDIT a patient's file    10     1
 ;;  
 ;; -- Here is the report:
 ;;ASUFAC     HRN                     FIELD    VALUE
 ;;======  ======     =====================    =============================
 ;;###
 ; --------------------------------------------------------
QUE ;EP - From Option
 D HELP^XBHELP("TXT","AGEDNAME")
 Q:'$$DIR^XBDIR("YO","Proceed","N","","Do you want to proceed with the report to check format of names (Y/N)")
 S XBRP="START^AGEDNAME",ZTIO=""
 D ^XBDBQUE,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",!
 Q
START ;EP - From Taskman
 N AG,AGFAC,AGHRN,DFN,AGDONE,AGP3,AGSITE
 K ^TMP("AGEDNAME",$J)
 F %=1:1 D OUT($P($T(TXT+%),";",3)) Q:$P($T(TXT+%+1),";",3)="###"
 F %=1:1 D OUT($P($T(TXT1+%),";",3)) Q:$P($T(TXT1+%+1),";",3)="###"
 S DFN=0,AGP3=$P($G(^AUPNPAT(0)),U,3)
 F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D  I '(DFN#1000),'$D(ZTQUEUED) W !,"On IEN ",DFN," of ",AGP3," in ^AUPNPAT(..."
 . Q:'$D(^DPT(DFN))  Q:$P(^(DFN,0),U,19)  ;merged pt
 . S (AGDONE,AGSITE)=0
 . F  S AGSITE=$O(^AUPNPAT(DFN,41,AGSITE)) Q:'AGSITE  D  Q:AGDONE
 .. I $L($P($G(^AUPNPAT(DFN,41,AGSITE,0)),U,5)) Q:"DM"[$P(^(0),U,5)  ;deleted or merged patient
 .. S AGFAC=$P($G(^AUTTLOC(DUZ(2),0)),U,10),AGHRN="??????"
 .. I $L($P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)) S AGHRN=$P(^(0),U,2)
 .. E  I $L($P($G(^AUPNPAT(DFN,41,AGSITE,0)),U,2)) S AGHRN=$P(^(0),U,2),AGFAC=$P($G(^AUTTLOC(AGSITE,0)),U,10)
 .. D CHK("PATIENT NAME :  ",$P($G(^DPT(DFN,0)),U))
 .. D CHK("EMERGENCY CONTACT :  ",$P($G(^DPT(DFN,.33)),U))
 .. D CHK("FATHER'S NAME :  ",$P($G(^DPT(DFN,.24)),U))
 .. D CHK("MOTHER'S MAIDEN NAME :  ",$P($G(^DPT(DFN,.24)),U,3))
 .. D CHK("NEXT OF KIN :  ",$P($G(^DPT(DFN,.21)),U))
 .. D MCD
 .. S AG=0
 .. F  S AG=$O(^DPT(DFN,.01,AG)) Q:'AG  D CHK("OTHER NAME (ALIASES) :  ",$P($G(^DPT(DFN,.01,AG,0)),U))
 .. S AG=0
 .. F  S AG=$O(^AUPNPRVT(DFN,11,AG)) Q:'AG  D
 ... D CHK("NAME OF INSURED (PVT) :  ",$P($G(^AUPNPRVT(DFN,11,AG,0)),U,4))
 ... D NPH($P($G(^AUPNPRVT(DFN,11,AG,0)),U,8))
 ...Q
 .. S AGDONE=1 ;pt is done, one and only one time
 ..Q
 .Q
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AGEDNAME"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUPROGMODE","AGZMENU","AGZMGR","ABMDZ TABLE MAINTENANCE","ABMDZ ELIGIBILITY EDIT","APCCZMGR" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AGEDNAME",$J)
 D EN^XBVK("AG")
 I $D(ZTQUEUED) S ZTREQ="@" Q
 W !!,"The results are in your MailMan 'IN' basket.",!
 Q
MCD ;
 NEW D,N,S
 S S=0
 F  S S=$O(^AUPNMCD("AB",DFN,S)) Q:'S  S N=0 D
 . F  S N=$O(^AUPNMCD("AB",DFN,S,N)) Q:'N  S D=0 D
 .. F  S D=$O(^AUPNMCD("AB",DFN,S,N,D)) Q:'D  D
 ... D CHK("NAME OF INSURED (MCD) :  ",$P($G(^AUPNMCD(D,0)),U,5))
 ... D NPH($P($G(^AUPNMCD(D,0)),U,9))
 ...Q
 ..Q
 .Q
 Q
NPH(I) ;
 Q:'I
 D CHK("NAME OF POLICY HOLDER :  ",$P($G(^AUPN3PPH(I,0)),U))
 Q
CHK(F,X) ;
 Q:((X="")!(X="SAME"))
 NEW AG
 S AG=X
 D NAME^AUPNPED
 Q:$D(X)
 D RSLT(F_U_AG)
 Q
RSLT(%) S %=$J(AGFAC,6)_$J(AGHRN,8)_$J($P(%,U,1),30)_"'"_$P(%,U,2)_"'"
RSLT1 S ^(0)=$G(^TMP("AGEDNAME",$J,0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,%
 Q
OUT(%) D RSLT1 Q
SINGLE(K) ;Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
