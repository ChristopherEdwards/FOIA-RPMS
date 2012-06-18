VASITE ;ALB/AAS - TIME SENSETIVE VA STATION NUMBER UTILITY ; [ 04/01/2004  5:17 PM ]
 ;;5.3;Registration;**134,1004,1009,1012,1013**;Aug 13, 1993
 ;IHS/ANMC/LJF  7/31/2001 used IHS location file info
 ;IHS/OIT/LJF  11/09/2005 PATCH 1004 added to patch for sites where good copy was overwritten
 ;cmi/anch/maw 04/07/2008 PATCH 1009 requirement 54 added fix for no DUZ(2) in SITE
 ;
SITE(DATE,DIV) ;
 ;       -Output= Institution file pointer^Institution name^station number with suffix
 ;
 ;       -Input (optional) date for division, if undefined will use DT
 ;       -      (optional) medical center division=pointer in 40.8
 ;
 ;IHS/ANMC/LJF 7/31/2001 use IHS location file for data
 ;I '$G(DIV) S DIV=+$O(^DG(40.8,"C",DUZ(2),0))  ;cmi/maw 04/07/2008 patch 1009 orig line
 ;I '$G(DIV),$G(DUZ(2)) S DIV=+$O(^DG(40.8,"C",DUZ(2),0))  ;cmi/maw 04/07/2008 patch 1009 modified to check for DUZ(2)
 I '$G(DIV),$G(DUZ(2)) S DIV=+$O(^DG(40.8,"AD",DUZ(2),0))  ;cmi/maw 04/07/2008 patch 1012 modified to check for "AD" DUZ(2)
 ;I '$G(DIV) S DIV=+$O(^DG(40.8,"C",$G(^DD("SITE",1)),0))  ;cmi/maw 04/07/2008 patch 1009 modified if neither DUZ(2) or DIV are set
 I '$G(DIV) S DIV=+$O(^DG(40.8,"AD",$G(^DD("SITE",1)),0))  ;cmi/maw 04/07/2008 patch 1012 modified if neither DUZ(2) or DIV are set
 NEW X S X=$$GET1^DIQ(40.8,+$G(DIV),.07,"I") I 'X Q -1
 ;Q X_U_$$GET1^DIQ(9999999.06,X,.01)_U_$$GET1^DIQ(9999999.06,X,.0799)
 Q X_U_$$GET1^DIQ(9999999.06,X,.01)_U_$$GET1^DIQ(4,X,99)   ;IHS/ITSC/LJF 4/1/2004
 ;IHS/ANMC/LJF 7/31/2001 end of IHS code
 ;
 N PRIM,SITE
 S:'$D(DATE) DATE=DT
 S:'$D(DIV) DIV=$$PRIM(DATE)
 I DATE'?7N!DIV<0 Q -1
 S PRIM=$G(^VA(389.9,+$O(^(+$O(^VA(389.9,"AIVDT",DIV,$$IVDATE(DATE))),0)),0))
 S SITE=$S('$P(PRIM,"^",6)&($P(PRIM,"^",4)?3N.AN):$P(PRIM,"^",4),1:-1)  ;IHS/ANMC/LJF 9/21/2000
 S:SITE>0 SITE=$P(^DG(40.8,DIV,0),"^",7)_"^"_$P($G(^DIC(4,$P(^DG(40.8,DIV,0),"^",7),0)),"^")_"^"_SITE
 Q SITE
 ;
ALL(DATE) ; -returns all possible station numbers 
 ;         -input date, if date is undefined, then date will be today
 ;          - output VASITE= 1 or -1 if stations exist
 ;                   VASITE(station number)=station number
 ;
 N PRIM,DIV
 S:'$D(DATE) DATE=DT
 S VASITE=-1
 ;S DIV=0 F  S DIV=$O(^VA(389.9,"C",DIV)) Q:'DIV  S PRIM=$G(^VA(389.9,+$O(^(+$O(^VA(389.9,"AIVDT",DIV,$$IVDATE(DATE))),0)),0)) S:'$P(PRIM,"^",6)&($P(PRIM,"^",4)?3N) VASITE($P(PRIM,"^",4))=$P(PRIM,"^",4),VASITE=1  ;IHS/ANMC/LJF 9/21/2000
 S DIV=0 F  S DIV=$O(^VA(389.9,"C",DIV)) Q:'DIV  S PRIM=$G(^VA(389.9,+$O(^(+$O(^VA(389.9,"AIVDT",DIV,$$IVDATE(DATE))),0)),0)) S:'$P(PRIM,"^",6)&($P(PRIM,"^",4)?6N) VASITE($P(PRIM,"^",4))=$P(PRIM,"^",4),VASITE=1  ;IHS/ANMC/LJF 9/21/2000
 Q VASITE
 ;
IVDATE(DATE) ; -- inverse date reference start
 Q -(DATE+.000001)
 ;
CHK ;  -input transform for IS PRIMARY STATION? field
 ;  -only 1 primary station number allowed per effective date
 ;
 I '$P(^VA(389.9,DA,0),"^",2) W !,"Effective Date must be entered first" K X G CHKQ
 I '$P(^VA(389.9,DA,0),"^",3) W !,"Medical Center Division must be entered first.",! K X G CHKQ
 I $D(^VA(389.9,"AIVDT1",1,-X)) W !,"Another entry Is Primary Division for this date.",! K X G CHKQ
 I 1
CHKQ I 0 Q
 ;
YN ;  -input transform for is primary facility
 I '$P(^VA(389.9,DA,0),"^",2) W !,"Effective date must be entered first!" K X Q
 I '$P(^VA(389.9,DA,0),"^",3) W !,"Medical Center Division must be entered first!" K X Q
 I $D(^VA(389.9,"AIVDT1",1,-$P(^VA(389.9,DA,0),"^",2))) W !,"Only one division can be primary division for an effective date!" K X Q
 S X=$E(X),X=$S(X=1:X,X=0:X,X="Y":1,X="y":1,X="n":0,X="N":0,1:2) I X'=2 W "  (",$S(X:"YES",1:"NO"),")" Q
 W !?4,"NOT A VALID CHOICE!",*7 K X Q
 ;
PRIM(DATE) ;  -returns medical center division of primary medical center division
 ;          - input date, if date is null then date will be today
 ;
 ;Q +$O(^DG(40.8,"C",DUZ(2),0))   ;IHS/ANMC/LJF 7/31/2001
 Q +$O(^DG(40.8,"AD",DUZ(2),0))   ;cmi/maw 3/9/2010 PATCH 1012 for station number
 N PRIM
 S:'$D(DATE) DATE=DT S DATE=DATE+.24
 S PRIM=$G(^VA(389.9,+$O(^(+$O(^VA(389.9,"AIVDT1",1,$$IVDATE(DATE))),0)),0))
 Q $S($P(PRIM,"^",4)?3N:$P(PRIM,"^",3),1:-1)
 ;
NAME(DATE) ;  -returns the new name of medical centers that have integrated
 ;
 ;          -input date, if date is null then date will be today
 S:'$D(DATE) DATE=DT S DATE=DATE+.24
 Q $G(^VA(389.9,+$O(^(+$O(^VA(389.9,"AIVDT1",1,$$IVDATE(DATE))),0)),"INTEG"))
