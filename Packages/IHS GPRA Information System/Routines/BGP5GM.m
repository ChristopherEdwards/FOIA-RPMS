BGP5GM ; IHS/CMI/LAB - BGPG Visual CRS Reports ;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
MUEP(RETVAL,BGPSTR) ;sel measures by comm
 S X="MERR^BGP5GU",@^%ZOSF("TRAP")
 N BGPI,BGPJ,BGPDATA,BGPDA,P,BGPERR,BGPCT,BGPOT,BGPOPT,BGPRT,P,R,A
 N BGPTP,BGPQTR,BGPRDT,BGPRE,BGPBAS,BGPPATT,BGPLIST,BGPPRV,BGPPROV,BGPIND,BGPINDI,BGPLSTI
 S P="|",R="~",A="*"
 I $G(BGPSTR)="" D CATSTR(.BGPSTR,.BGPSTR)
 S BGPI=0
 S BGPERR=""
 S BGPCT=$P($P(BGPSTR,P),R)  ;THIS WILL BE NULL AS WE DON'T NEED COMMUNITY TAXONOMY
 S BGPTP=$E($P(BGPSTR,P,2))  ;Will be A, C, M, S for indicators selected
 S BGPQTR=$P(BGPSTR,P,3)  ; will be 1 for 90 days, 2 for one year (see BGPMUEP)
 S BGPRDT=$P(BGPSTR,P,4)  ;time to run the report
 S BGPRE=$P(BGPSTR,P,5)  ;beginning date for report user entered e.g. 3110901
 S BGPOPT="CRS 14 EP MU REPORT"
 S BGPBAS=$P(BGPSTR,P,6)  ;BASE LINE YEAR IN 3000000 FORMAT (YEAR ONLY)
 S BGPBEB=$P(BGPSTR,P,7)  ;beneficiary
 S BGPLSTT=$P(BGPSTR,P,8)  ; TYPE OF LIST:  D  Pts. Not in numerator  N  Pts in numerator  A All Patients - THIS IS DIFFERENT THAN OUR REPORTS
 S BGPPRV=$P($P(BGPSTR,P,9),R)  ;provider name they are running the report for
 S BGPPROV=$P($P(BGPSTR,P,9),R,2) ;provider ien they are running the report for
 I $G(BGPPROV)="" S BGPPROV=$P($G(^VA(200,BGPPRV,0)),U)
 S BGPOT=$P(BGPSTR,P,10)  ;output type D, P, B, X  -NOTE:  X IS XML - not sure how you will deal with this
 S BGPFN=$P(BGPSTR,P,14)  ;FILENAME
 S BGPINDI=$P(BGPSTR,P,12) ;string with indicators from BGPMU 11 MEASURES
 S BGPMFITI=$P(BGPSTR,P,13) ;will be null, we don't need MFI stuff
 S BGPLSTI=$P(BGPSTR,P,11)  ;list of measures from BGPMU 11 MEASURES.
 ;NOTE:   BGPINDI IS only necessary if M or S is selected
 N I
 F I=2:1 D  Q:$P(BGPLSTI,A,I)=""
 . Q:$P(BGPLSTI,A,I)=""
 . N BGPL
 . S BGPL=$P($P(BGPLSTI,A,I),R)
 . Q:'$G(BGPL)
 . S BGPLIST(BGPL)=""
 N J
 F J=2:1 D  Q:$P(BGPINDI,A,J)=""
 . Q:$P(BGPINDI,A,J)=""
 . N BGPL
 . S BGPL=$P($P(BGPINDI,A,J),R)
 . S BGPIND(BGPL)=""
 K ^BGPTMP($J)
 S RETVAL="^BGPTMP("_$J_")"
 S ^BGPTMP($J,BGPI)="T00250DATA"_$C(30)
 D EP^BGP5GMUE(.BGPERR,DUZ,DUZ(2),BGPOPT,BGPCT,BGPTP,.BGPIND,BGPQTR,BGPRE,BGPBAS,$G(BGPBEB),BGPLSTT,.BGPLIST,BGPPRV,BGPPROV,$G(BGPOT),BGPRDT,BGPMFITI,BGPFN)
 S BGPI=BGPI+1
 S ^BGPTMP($J,BGPI)=+$G(BGPERR)_$C(30)
 S ^BGPTMP($J,BGPI+1)=$C(31)
 D EN^XBVK("BGP")
 Q
 ;
MUHOS(RETVAL,BGPSTR) ;sel measures by comm
 S X="MERR^BGP5GU",@^%ZOSF("TRAP")
 N BGPI,BGPJ,BGPDATA,BGPDA,P,BGPERR,BGPCT,BGPOT,BGPOPT,BGPRT,P,R,A
 N BGPTP,BGPQTR,BGPRDT,BGPRE,BGPBAS,BGPPATT,BGPLIST,BGPPRV,BGPPROV,BGPIND,BGPINDI,BGPLSTI
 S P="|",R="~",A="*"
 I $G(BGPSTR)="" D CATSTR(.BGPSTR,.BGPSTR)
 S BGPI=0
 S BGPERR=""
 S BGPCT=$P($P(BGPSTR,P),R)  ;THIS WILL BE NULL AS WE DON'T NEED COMMUNITY TAXONOMY
 S BGPTP=$E($P(BGPSTR,P,2))  ;Will be A, C, M, S for indicators selected
 S BGPQTR=$P(BGPSTR,P,3)  ; will be 1 for 90 days, 2 for one year (see BGPMUEP)
 S BGPRDT=$P(BGPSTR,P,4)  ;time to run the report
 S BGPRE=$P(BGPSTR,P,5)  ;beginning date for report user entered e.g. 3110901
 S BGPOPT="CRS 14 HOS MU REPORT"
 S BGPBAS=$P(BGPSTR,P,6)  ;BASE LINE YEAR IN 3000000 FORMAT (YEAR ONLY)
 S BGPBEB=$P(BGPSTR,P,7)  ;beneficiary
 S BGPLSTT=$P(BGPSTR,P,8)  ; TYPE OF LIST:  D  Pts. Not in numerator  N  Pts in numerator  A All Patients - THIS IS DIFFERENT THAN OUR REPORTS
 S BGPPRV=$P($P(BGPSTR,P,9),R)  ;provider name they are running the report for
 S BGPPROV=$P($P(BGPSTR,P,9),R,2) ;provider ien they are running the report for
 S BGPOT=$P(BGPSTR,P,10)  ;output type D, P, B, X  -NOTE:  X IS XML - not sure how you will deal with this
 S BGPFN=$P(BGPSTR,P,14)  ;FILENAME
 S BGPINDI=$P(BGPSTR,P,12) ;string with indicators from BGPMU 11 MEASURES
 S BGPMFITI=$P(BGPSTR,P,13) ;will be null, we don't need MFI stuff
 S BGPLSTI=$P(BGPSTR,P,11)  ;list of measures from BGPMU 11 MEASURES.
 ;NOTE:   BGPINDI IS only necessary if M or S is selected
 N I
 F I=2:1 D  Q:$P(BGPLSTI,A,I)=""
 . Q:$P(BGPLSTI,A,I)=""
 . N BGPL
 . S BGPL=$P($P(BGPLSTI,A,I),R)
 . Q:'$G(BGPL)
 . S BGPLIST(BGPL)=""
 N J
 F J=2:1 D  Q:$P(BGPINDI,A,J)=""
 . Q:$P(BGPINDI,A,J)=""
 . N BGPL
 . S BGPL=$P($P(BGPINDI,A,J),R)
 . S BGPIND(BGPL)=""
 K ^BGPTMP($J)
 S RETVAL="^BGPTMP("_$J_")"
 S ^BGPTMP($J,BGPI)="T00250DATA"_$C(30)
 D EP^BGP5GMUH(.BGPERR,DUZ,DUZ(2),BGPOPT,BGPCT,BGPTP,.BGPIND,BGPQTR,BGPRE,BGPBAS,$G(BGPBEB),BGPLSTT,.BGPLIST,BGPPRV,BGPPROV,$G(BGPOT),BGPRDT,BGPMFITI,BGPFN)
 S BGPI=BGPI+1
 S ^BGPTMP($J,BGPI)=+$G(BGPERR)_$C(30)
 S ^BGPTMP($J,BGPI+1)=$C(31)
 D EN^XBVK("BGP")
 Q
 ;
CATSTR(BGPSRET,STR) ;EP
 N BGPDA
 S BGPSRET=""
 S BGPDA=0 F  S BGPDA=$O(STR(BGPDA)) Q:'BGPDA  D
 . S BGPSRET=BGPSRET_$G(STR(BGPDA))
 Q
 ;
