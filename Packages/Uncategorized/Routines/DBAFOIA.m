DBAFOIA ; ;10/23/96
 ;;2.0;
 D ZAPFOIA ; Zap non-foia stuff
 Q
 ;
 ;In Platinum account:
 ;
 ;Preparation sequence:
 ;From Platinum account -
 ; use %RO
 ;  select *, %Z*.INT, %DT*.INT, %RCR.INT, %XUCI.INT, 'CJS*.*.*, '%ZC*, '%ZD*, '%ZHALT.*.*, '%ZL*.*.*,'%ZE*.*.*,'%ZF*.*.*,'%ZG*.*.*,'%ZS*.*.*,'%ZW*.*.*
 ;  w Exporer:  *;%Z*.INT;%DT*.INT;%RCR.INT;%XUCI.INT;'CJS*.*.*;'%ZHALT.*.*;'%ZL*.*.*
 ; use %GOF
 ;  select *, 'ERRORS, 'ROUTINE, 'mtemp, 'mtemp1, 'rOBJ, '%Z*, 'Cache*, 'UTILITY, 'TMP, 'XTMP
 ;
 ; Check/Fix DD links
 ; D ^%ZZGCTRL on ^XPD(0) to identify control characters to eliminate
 ;Save all routines (-ZZAPFOIA) & EXCLUDE:
 ;*
 ;'%*
 ;'XUCI*
 ;'ZI*
 ;'ZO*
 ;  'ZT* <-- HAND REMOVE THESE BUT KEEP THESE: ZTMB, ZTMCHK, ZTMCHK1, ZTMKU, ZTMON, ZTMON1
 ;'ZU
 ;'ZZ*
 ;   cut & paste:
 ;   *;'%*;'XUCI*;'ZI*;'ZO*;'ZU;'ZZ*;'CJS* ... then 'ZT's by hand
 ; save to VAH.rtn in MSM format.
 ;
 ;and globals (-ICD0, -ICD9, -LEX*, -PSNDF, -PSPPI, -RGED, -TMP, -XTMP, -XUTL, -UTILITY) to non-FOIA files
 ;(can use ^%GOMSM with paramers: "WNV")
 ;'%Z*
 ;'mtemp*
 ;'ERRORS
 ;'ROUTINE
 ;'rOBJ
 ;   cut & paste:
 ;   *;'%Z*;'mtemp*;'ERRORS;'ROUTINE;'rOBJ;'ICD0;'ICD9;'LEX*;'PSNDF;'PSPPI;'RGED;'TMP;'XTMP;'XUTL;'UTILITY
 ;  save to VAH.gbl in MSM format.
 ;  for non-FOIA Platinum set
 ;
 ;
 ; For Krn8.mgr
 ;  save %DT*.INT, %RCR.INT, %XUCI.INT, %Z*.INT
 ;   (-%ZC* if MSM, '%ZHALT, '%ZD* and '%ZL* if Cache), Z*.INT, 'ZU*.INT, XUCI*.INT
 ;   cut & paste:
 ;     %DT*.INT;%RCR.INT;%XUCI.INT;%Z*.INT;XUCI*.INT;Z*.INT;'%ZHALT.INT;'ZU*.INT;'ZZAPFOIA.INT
 ;  to Krn8.mgr \VistA\Software\Kernel
 ;
 ;For KIDS8.RTN save the following to VistA\Software\Kernel\:
 ; XLFDT
 ; XLFDT1
 ; XLFDT2
 ; XLFDT3
 ; XLFDT4
 ; XPD*
 ; ...
 ; XQDATE
 ; XQH
 ; XQOO
 ; XQOO1
 ; XQOO2
 ; XQOO3
 ;
 ; Test import into D:\MSMPC\Platinum.msm
 ; Copy Platinum.msm to desk PC E:\MSMPC\
 ; In E:\MSMPC\
 ; load FOIA XUSHSH* & D ^ZZAPFOIA
 ; Check/Fix DD links
 ; Save all routines (-ZZAPFOIA) & EXCLUDE:
 ;'XUCI*
 ;'ZI*
 ;'ZO*
 ;  'ZT* <-- HAND REMOVE THESE BUT KEEP THESE: ZTMB, ZTMCHK, ZTMCHK1, ZTMKU, ZTMON, ZTMON1
 ;'ZU
 ;'ZZ*
 ;   cut & paste:
 ;   *;'%*;'XUCI*;'ZI*;'ZO*;'ZU;'ZZ* ... then 'ZT's by hand
 ; save to FOIAVAH.rtn in MSM format to VistA\Software\
 ; and all globals (-ICD0, -ICD9, -LEX*, -PSNDF, -PSPPI, -TMP, -XTMP, -XUTL, -UTILITY) to FOIA files
 ;'%Z*
 ;'mtemp*
 ;'ERRORS
 ;'ROUTINE
 ;'rOBJ
 ; to FOIAVAH.GBL in MSM format to VistA\Software\
 ;
 ; Test import of FOIA into D:\MSM\
 ; recopy D:\MSMPC\Platinum.msm to E:\MSMPC\
 ;
 ; make builds, & test each:
 ; Save DI*, DD*, DM* to FM22.rtn
 ; save builds for Kernel_8_FOIA.kid, Ktk7_3.kid, Mail_7_1.kid,
 ;  also HL_1_6.kid, VALM_1.kid, XWB_1_1.kid
 ; use COMPARE builds for KERNEL, TOOLKIT, & MAILMAN respectively, rollup patches first
 ;  check for straglers at ^XPD(9.6,D0,4,D1,2,0)
 ; D0=1013,1030,4380,1049,1796, D1="" and load FOIA XUSHSH* first
 ;  to VistA\Software\Kernel\
 ;
 ;
 ; Do import test and review of Kernel builds into E:\Cachesys\mgr\vah\cache.dat 288M "VAH"
 ;
 ; Recopy 440M MSM file from notebook to desk PC
 ; Recopy 400M Cache file from notebook to desk PC
 ; edit Readme files
 ; ZIP and exchange new copies
 ;
 ;Protection RWD for %ZUA, %ZIS, %ZTER, %ZISL, %ZTSK, %ZUT, %ZTSCH
 ;edit Taskman Site Parameters
 ; Example for MSM with two volume sets
 ; Select UCI ASSOCIATION FROM UCI:
 ; NUMBER: 1                               FROM UCI: VAH
 ;   FROM VOLUME SET (FREE TEXT): TIS      FROM VOLUME SET: TIS
 ; NUMBER: 2                               FROM UCI: MGR
 ;   FROM VOLUME SET (FREE TEXT): CJS      FROM VOLUME SET: CJS
 ; 
 ; Select VOLUME SET:
 ; VOLUME SET: CJS                         INHIBIT LOGONS?: NO
 ;   LINK ACCESS?: YES                     OUT OF SERVICE?: NO
 ;   REQUIRED VOLUME SET?: YES             TASKMAN FILES UCI: MGR
 ;   DAYS TO KEEP OLD TASKS: 4             TYPE: GENERAL PURPOSE VOLUME SET
 ;   SIGNON/PRODUCTION VOLUME SET: No
 ; VOLUME SET: TIS                         INHIBIT LOGONS?: NO
 ;   LINK ACCESS?: YES                     OUT OF SERVICE?: NO
 ;   REQUIRED VOLUME SET?: YES             TASKMAN FILES UCI: MGR
 ;   TASKMAN FILES VOLUME SET: CJS         DAYS TO KEEP OLD TASKS: 4
 ;   TYPE: GENERAL PURPOSE VOLUME SET      SIGNON/PRODUCTION VOLUME SET: Yes
 ; 
 ; Select TASKMAN SITE PARAMETERS BOX-VOLUME PAIR:
 ; BOX-VOLUME PAIR: CJS                    LOG TASKS?: NO
 ;   DEFAULT TASK PRIORITY: 4              SUBMANAGER RETENTION TIME: 10
 ;   TASKMAN JOB LIMIT: 8                  TASKMAN HANG BETWEEN NEW JOBS: 1
 ;   MODE OF TASKMAN: GENERAL PROCESSOR    OUT OF SERVICE: NO
 ; BOX-VOLUME PAIR: TIS                    LOG TASKS?: NO
 ;   DEFAULT TASK PRIORITY: 4              SUBMANAGER RETENTION TIME: 10
 ;   TASKMAN JOB LIMIT: 8                  TASKMAN HANG BETWEEN NEW JOBS: 1
 ;   MODE OF TASKMAN: GENERAL PROCESSOR    OUT OF SERVICE: NO
 ; 
 ; Check ^%ZOSF("MGR") to match $ZU(0) from MGR account.
 ;
ZAPFOIA S U="^" I $D(DTIME)=0 D ^XUP
INTRO W !,?10,"This program allows you to remove the following elements for non-FOIA"
 w !,?5,"packages:  DDs, options, templates, list manager templates, help frames,"
 w !,?5,"bulletins, protocols, security keys, functions, routines, entries in the"
 w !,?5,"package file, and clean up dangling pointers in the option and help frame"
 w !,?5,"files."
ZAPMGR ;SCRUB % GLOBALS
ERRLOG ;
 K ^%ZTER(1)
 S ^%ZTER(1,0)="ERROR LOG^3.075"
TASKMAN ;
 K ^%ZTSK
 S ^%ZTSK(0)="TASKS^14.4"
 K ^%ZTSCH("ER")
 S ^%ZTSCH("ER")=""
GETNMSP ;
 S I=0 F  S I=I+1,T=$T(NONFOIA+I),ZZNMSP=$P(T,";",3),STARTNO=$P(T,";",4),ENDNO=$P(T,";",5),DIU(0)="DT" Q:ZZNMSP=""  D NMSPLOOP
 ; REMOVE IVM RELATED IB ENTRY
 ; S DIK="^DIC(19,",DA=$O(^DIC(19,"B","IB OUTPUT IVM BILLING ACTIVITY","")) I DA D ^DIK
 ; REMOVE DIETETICS VENDOR ENTRY(S)
 ; S DIK="^FH(113.2,",DA=0 F  S DA=$O(^FH(113.2,DA)) Q:DA'>0  D ^DIK
 ; REMOVE DANGLING OPTION SCHEDULING ENTRIES
 S DIK="^DIC(19.2,",DA=0 F  S DA=$O(^DIC(19.2,DA)) Q:DA'>0  I '$D(^DIC(19,+$P($G(^DIC(19.2,DA,0)),U),0)) D ^DIK
DGLPTRS ;
 S %=1,XQFL="OPTION" D REMOVE^XQ3
 ; REMOVE COPYRIGHTED CPT FILES' DATA
 K ^ICPT S ^ICPT(0)="CPT^81I"
 K ^DIC(81.1) S ^DIC(81.1,0)="CPT CATEGORY^81.1",^(0,"GL")="^DIC(81.1,"
 K ^DIC(81.3) S ^DIC(81.3,0)="CPT MODIFIER^81.3I",^(0,"GL")="^DIC(81.3,"
 S %=$P(^DD(757.02,1,0),U,2) I %'="RF" W !,"757.02,1 has changed" Q
 S $P(^DD(757.02,1,0),U,2)="F"
 S %=$P(^DD(757.02,2,0),U,2) I %'="RP757.03'" W !,"757.02,2 has changed" Q
 S $P(^DD(757.02,2,0),U,2)="P757.03'"
 S DA=0,DIE=757.02,DR="1///@;2///@"
 F  S DA=$O(^LEX(757.02,DA)) Q:DA'>0  D
 . S %=$P($G(^LEX(757.02,DA,0)),U,3)
 . I %=3!(%=4) D ^DIE
 . Q
 S $P(^DD(757.02,1,0),U,2)="RF"
 S $P(^DD(757.02,2,0),U,2)="RP757.03'"
 ; REMOVE COPYRIGHTED MED INSTRUCTIONS
 K ^PS(50.621) S ^PS(50.621,0)="PMI-ENGLISH^50.621"
 K ^PS(50.622) S ^PS(50.622,0)="PMI-SPANISH^50.622"
 K ^PS(50.623) S ^PS(50.623,0)="PMI MAP-ENGLISH^50.623"
 K ^PS(50.624) S ^PS(50.624,0)="PMI MAP-SPANISH^50.624"
 K ^PS(50.625) S ^PS(50.625,0)="WARNING LABEL-ENGLISH^50.625"
 K ^PS(50.626) S ^PS(50.626,0)="WARNING LABEL-SPANISH^50.626"
 K ^PS(50.627) S ^PS(50.627,0)="WARNING LABEL MAP^50.627"
 S %I=0 F  S %I=$O(^PSNDF(50.68,%I)) Q:%I'>0  S $P(^PSNDF(50.68,%I,1),"^",5,7)="^^"
DELRTN ;
 K ^UTILITY($J)
 F %RS="DENTV*","DSI*","VEJD*" D ADDSEL
 W ! S %N=""
 F %I=1:1 S %N=$O(^UTILITY($J,%N)) Q:%N=""  W ?%I-1#8*10,%N W:(%I#8)=0 ! X "ZR  ZS @%N"
 D DELRTN^XPDR ;REBUILD ROUTINE FILE
ANDGBLS ;DOMAIN, MESSAGE STATS, MH non-FOIA
 S DIK="^YTT(601,",YS=0 F  S YS=$O(^YTT(601,YS)) Q:YS'>0  I $L($P($G(^YTT(601,YS,0)),"^",6)) S DA=YS D ^DIK
 ; S DIK="^HL(771,",DA=$O(^HL(771,"B","IVM","")) I DA D ^DIK
 ; S DIK="^HL(770,",DA=$O(^HL(770,"B","IVM CENTER","")) I DA D ^DIK
 ;
USER ;
 W !,"Cleaning up User info",!
 S U="^",IOF="#"
 F I=1,2,3 D
 . S $P(^VA(200,I,0),U,3)="",$P(^(.1),U,1,2)="^"
 . K ^VA(200,I,"VOLD")
 K ^VA(200,"AOLD"),^VA(200,"A")
 K ^DISV
MAIL ;
 S DIK="^%ZTER(1,",YS=0 F  S YS=$O(^%ZTER(1,YS)) Q:YS'>0  S DA=YS D ^DIK
 S DIK="^XUSEC(0,",YS=0 F  S YS=$O(^XUSEC(0,YS)) Q:YS'>0  S DA=YS D ^DIK
 S DIK="^XMB(3.7,.5,2,",YS=1,DA(1)=.5 F  S YS=$O(^XMB(3.7,.5,2,YS)) Q:YS'>0  S DA=YS D ^DIK
 S DIKYB="^XMB(3.7,.5,2,",DA(2)=.5 F YB=.5,.95,1 S DIK=DIKYB_YB_",1,",YS=0,DA(1)=YB F  S YS=$O(^XMB(3.7,.5,2,YB,1,YS)) Q:YS'>0  S DA=YS D ^DIK
 S DIK="^XMBS(4.2999,",YS=0 F  S YS=$O(^XMBS(4.2999,YS)) Q:YS'>0  S DA=YS D ^DIK
 K ^XMB(3.9)
 S ^XMB(3.9,0)="MESSAGE^3.9s"
 D CHKFILES^XMUT4
 W !,"Don't forget to copy in HASH.RTN"
 W !,"And edit GO+1^XMRONT, replace 10001 with 25 which restores the value as exported."
 W !,"DONE"
 K ZI,ZNODE,ZZNMSP,DIU,DIU(0),STARTNO,ENDNO,ZZDATA,DIK,ZX
 Q
NONFOIA ;
 ;;VEJD;19600;19699.9999
 ;;DSI;;-1
 ;;DENTV;228;228.9999
 ;;
NMSPLOOP N I W !,"Deleting: ",ZZNMSP F ZI=STARTNO-.000000001:0 S ZI=$O(^DIC(ZI)) Q:ZI>ENDNO  S DIU=^DIC(ZI,0,"GL") W !,DIU D EN^DIU2
DELBULL ;
 W !!,"Deleting bulletins...",!
 S DIK="^XMB(3.6," F ZI=0:0 S ZI=$O(^XMB(3.6,ZI)) Q:ZI'?.N  S ZNODE=^XMB(3.6,ZI,0) I $E(($P(ZNODE,U,1)),1,$L(ZZNMSP))[ZZNMSP S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"Bulletins deleted."
 W !!,"Deleting mail groups...",!
 S DIK="^XMB(3.8," F ZI=0:0 S ZI=$O(^XMB(3.8,ZI)) Q:ZI'?.N  S ZNODE=^XMB(3.8,ZI,0) I $E(($P(ZNODE,U,1)),1,$L(ZZNMSP))[ZZNMSP S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"Mail Groups deleted."
DELOPTS ;
 W !!,"Deleting options...",!
 S DIK="^DIC(19," F ZI=0:0 S ZI=$O(^DIC(19,ZI)) Q:ZI'?.N!(ZI="")  I $D(^DIC(19,ZI,0)) S ZNODE=^DIC(19,ZI,0) I $E(($P(ZNODE,U,1)),1,$L(ZZNMSP))[ZZNMSP S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"Options deleted."
DELHELP ;
 W !!,"Deleting HELP FRAMES...",!
 S DIK="^DIC(9.2," F ZI=0:0 S ZI=$O(^DIC(9.2,ZI)) Q:ZI'?.N!(ZI="")  I $D(^DIC(9.2,ZI,0)) S ZNODE=^DIC(9.2,ZI,0) I $E(($P(ZNODE,U,1)),1,$L(ZZNMSP))[ZZNMSP S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"HELP FRAMES deleted."
DGLHPTR ;
 S %=0,XQFL="HELP FRAME" D REMOVE^XQ3
DELTEMP ;
 W !!,"Deleting LIST MANAGER TEMPLATES...",!
 S DIK="^SD(409.61," F ZI=0:0 S ZI=$O(^SD(409.61,ZI)) Q:ZI'?.N!(ZI="")  I $D(^SD(409.61,ZI,0)) S ZNODE=^SD(409.61,ZI,0) I $E(($P(ZNODE,U,1)),1,$L(ZZNMSP))[ZZNMSP S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"LIST MANAGER TEMPLATES deleted."
DELPROT ;
 W !!,"Deleting protocols...",!
 S DIK="^ORD(101," F ZI=0:0 S ZI=$O(^ORD(101,ZI)) Q:ZI'?.N!(ZI="")  I $D(^ORD(101,ZI,0)) S ZNODE=^ORD(101,ZI,0) I $E(($P(ZNODE,U,1)),1,$L(ZZNMSP))[ZZNMSP S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"Protocols deleted."
DELFUNC ;
 W !!,"Deleting functions...",!
 S DIK="^DD(""FUNC""," F ZI=0:0 S ZI=$O(^DD("FUNC",ZI)) Q:ZI<0!(ZI'?.N)  S ZNODE=^DD("FUNC",ZI,0) I $E(($P(ZNODE,U,1)),1,$L(ZZNMSP))[ZZNMSP S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"Functions deleted."
DELKEYS ;
 W !!,"Deleting security keys...",!
 S DIK="^DIC(19.1," F ZI=0:0 S ZI=$O(^DIC(19.1,ZI)) Q:ZI'?.N  S ZNODE=^DIC(19.1,ZI,0) I $E(($P(ZNODE,U,1)),1,$L(ZZNMSP))[ZZNMSP S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"Security keys deleted."
DELBUILD ;
 W !!,"Deleting Builds...",!
 S DIK="^XPD(9.6," F ZI=0:0 S ZI=$O(^XPD(9.6,ZI)) Q:ZI'?.N  S ZNODE=^XPD(9.6,ZI,0) I $E(($P(ZNODE,U,1)),1,$L(ZZNMSP))[ZZNMSP!($P($G(^DIC(9.4,+$P(ZNODE,U,2),0)),U,2)=ZZNMSP) S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"Builds deleted."
DELINSTL ;
 W !!,"Deleting Installs...",!
 S DIK="^XPD(9.7," F ZI=0:0 S ZI=$O(^XPD(9.7,ZI)) Q:ZI'?.N  S ZNODE=^XPD(9.7,ZI,0) I $E(($P(ZNODE,U,1)),1,$L(ZZNMSP))[ZZNMSP!($P($G(^DIC(9.4,+$P(ZNODE,U,2),0)),U,2)=ZZNMSP) S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"Installs deleted."
DELPKG ;
 W !!,"Deleting Packages...",!
 S DIK="^DIC(9.4," F ZI=0:0 S ZI=$O(^DIC(9.4,ZI)) Q:ZI'?.N  S ZNODE=^DIC(9.4,ZI,0) I $E(($P(ZNODE,U,2)),1,$L(ZZNMSP))[ZZNMSP S DA=ZI W !,$P(ZNODE,U,1) D ^DIK
 W !!,"Packages deleted."
 Q
 ;
ADDSEL ;
 S A=%RS,%OS=$S($E(^%ZOSF("OS"),1,5)="OpenM":1,1:0)
 S A=$E(A,1,$L(A)-1),B=A D SING,MULT ;wild pattern
 Q
SING I A]"",$$TESTROU(A) S B=A G S ;routine exists
 Q  ;routine does not exist
TESTROU(A) ;
 I %OS=1 Q $D(^ROUTINE(A))
 Q $D(^ (A))
S Q:$D(^UTILITY($J,B))  S ^(B)="" Q  ;adding & not there
 Q  ;shouldn't get to this point
MULT I B="" S B=0 ;A and B are the root pattern for the matches
MULT1 S B=$$ROU(B) Q:B=""  Q:$E(B,1,$L(A))'=A
 D S G MULT1 ;add one routine and continue
ROU(B) ;
 I %OS=1 Q $O(^ROUTINE(B))
 Q $O(^ (B))
