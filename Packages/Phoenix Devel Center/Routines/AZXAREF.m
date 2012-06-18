AZXAREF ; IHS/PHXAO/TMJ - SET DISCOSURE VARIABLES ;
 ;;2.0;RELEASE OF INFORMATION;;FEB 21, 2002
 ;
 ;   AZXARIEN=Disclosure ien
 ;   AZXARDATE=Disclosure date in internal FileMan form (.01 field)
 ;   AZXARNUMB=Disclosure number (.02 field)
 ;   AZXADFN=patient ien (.03 field)
 ;   AZXARTYPE=type of Disclosure (.04 field)
 ;   AZXAREC("PAT NAME")=patient name
 ;   AZXAREC("REF DATE")=Disclosure date in external form
 ;
START ;
 Q:'$G(Y)
 Q:$D(AZXAOVRPS)  ;override post selection variable
 S (AZXACHSCT,AZXARIEN,AZXARDATE,AZXARNUMB,AZXADFN,AZXARTYPE,AZXARIO,AZXAREC("PAT NAME"),AZXAREC("REF DATE"))=""
 Q:'$G(Y)
 Q:'$D(^AZXAREC(+Y,0))
 NEW X
 S AZXARIEN=+Y
 S X=^AZXAREC(AZXARIEN,0)
 S AZXARDATE=$P(X,U)
 S AZXARNUMB=$P(X,U,2)
 S AZXADFN=$P(X,U,3)
 S AZXARSTAT=$P(X,U,8)
 S AZXARTYPE=$P(X,U,4)
 ;S AZXARIO=$P(X,U,14)
 S:$G(AZXADFN) AZXAREC("PAT NAME")=$P(^DPT(AZXADFN,0),U)
 ;
 ;S AZXACHSCT=+$P($G(^AZXAREF(AZXARIEN,11)),U,15)
 ;
 NEW Y
 S Y=AZXARDATE
 D DD^%DT
 S AZXAREC("REF DATE")=Y
 Q
