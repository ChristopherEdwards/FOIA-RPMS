DWCNST03 ;NEW PROGRAM [ 07/07/1999  4:37 PM ]
 ; vjm 5/12/99 - this routine re-written by vjm from
 ;                    WALZ's original rtn:  DWCNST03
 ; WALZ's rtn comment:
 ; WRITTEN BY DAN WALZ PIMC TO ALLOW REVIEW OF PENDING CONSULTATIONS
 ;
 ;  Global information:
 ;  ^DWCNST01( = PIMC-CONSULTATION-REQUESTS file
 ;  ^DWCNST03( = PIMC-CONSULTATION-OTHER-SVC file
 ;  ^DIC(49 =    SERVICE/SECTION file
 ;
 I '$D(DUZ) Q
 I '$D(^VA(200,DUZ,0)) Q
 I '$P($G(^VA(200,DUZ,5)),U) W "No SERVICE/SECTION found for this user!!" Q
 S SVCN=$P($G(^VA(200,DUZ,5)),U)
 Q:SVCN=0
 Q:'$D(^DIC(49,SVCN,0))       ;Quit if this SERVICE/SECTION is not found
 S XXIV=$C(27)_"[7m"
 ;S XXIV="""[7m"""
 S XXNO=$C(27)_$C(91)_$C(109)
 Q:'$D(^DWCNST01("C","R"))    ;Quit if there are no "R"equest x-refs
 ;                            ;  in the "C" x-ref (STATUS fld)
 D PROCESS
 K SVCN
 ;switch service if user found in ^DWNCST03 1966195
 I $D(^DWCNST03("B",DUZ)) D OTHER,PROCESS
 W !,"Press <Return> to Acknowledge..." R XXX:15
 K XXIV,XXNO
XIT ;K SVCN,SVC,XXCNT,XXIII,DWDFN,XXIV,XXNO,OSIE,XXX
 K SVCN,SVC,XXCNT,XXIII,DWDFN,OSIE,XXX
 ;K XXIV,XXNO
 Q
 ;
 ;---------------------------------------------------------------------
PROCESS ; process & display # of consults for this SERVICE
 S SVC=$P(^DIC(49,SVCN,0),U,1)
 S XXCNT=0,DWDFN=0
 F XXIII=0:0 S DWDFN=+$O(^DWCNST01("C","R",DWDFN)) Q:DWDFN=0  I $D(^DWCNST01("D",SVCN,DWDFN)) S XXCNT=XXCNT+1
 I XXCNT=0 D XIT Q
 ;W !,XXIV_SVC_" service has "_XXCNT_" new consultation request"_$S(XXCNT>1:"s",1:"")_"."_XXNO,!,"Press <Return> to Acknowledge..." R XXX:15
 W !,XXIV_SVC_" service has "_XXCNT_" new consultation request"_$S(XXCNT>1:"s",1:"")_"."_XXNO
 D XIT
 Q
 ;
 ;
OTHER ;replace usual service with the entry in ^DWCNST03 1966195 
 S OSIE=+$O(^DWCNST03("B",DUZ,0))
 I '$D(^DWCNST03(OSIE,0)) Q
 S SVCN=+$P(^DWCNST03(OSIE,0),U,2)
 I SVCN=0 K SVCN
 Q
