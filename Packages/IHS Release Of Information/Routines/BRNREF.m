BRNREF ; IHS/PHXAO/TMJ - SET DISCOSURE VARIABLES ; 
 ;;2.0;RELEASE OF INFO SYSTEM;;APR 10, 2003
 ;
 ;   BRNRIEN=Disclosure ien
 ;   BRNRDATE=Disclosure date in internal FileMan form (.01 field)
 ;   BRNRNUMB=Disclosure number (.02 field)
 ;   BRNDFN=patient ien (.03 field)
 ;   BRNRTYPE=type of Disclosure (.04 field)
 ;   BRNREC("PAT NAME")=patient name
 ;   BRNREC("REF DATE")=Disclosure date in external form
 ;
START ;
 Q:'$G(Y)
 Q:$D(BRNOVRPS)  ;override post selection variable
 S (BRNCHSCT,BRNRIEN,BRNRDATE,BRNRNUMB,BRNDFN,BRNRTYPE,BRNRIO,BRNREC("PAT NAME"),BRNREC("REF DATE"))=""
 Q:'$G(Y)
 Q:'$D(^BRNREC(+Y,0))
 NEW X
 S BRNRIEN=+Y
 S X=^BRNREC(BRNRIEN,0)
 S BRNRDATE=$P(X,U)
 S BRNRNUMB=$P(X,U,2)
 S BRNDFN=$P(X,U,3)
 S BRNRSTAT=$P(X,U,8)
 S BRNRTYPE=$P(X,U,4)
 ;S BRNRIO=$P(X,U,14)
 S:$G(BRNDFN) BRNREC("PAT NAME")=$P(^DPT(BRNDFN,0),U)
 ;
 ;S BRNCHSCT=+$P($G(^BRNREF(BRNRIEN,11)),U,15)
 ;
 NEW Y
 S Y=BRNRDATE
 D DD^%DT
 S BRNREC("REF DATE")=Y
 Q
