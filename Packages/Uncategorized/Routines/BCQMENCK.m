BCQMENCK ;IHS/OIT/FBD - MAGIC MAPPER - ENVIRONMENT CHECKER ;   
 ;;1.0;IHS CODE MAPPING;;APR 11, 2016;Build 13
 ;
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch 3"_".",IOM),!
 ;
 S XPDQUIT=0
 I '$$VCHK("XU","8.0",2) S XPDQUIT=2
 ;
 I XPDQUIT D SORRY(XPDQUIT) Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(PRE,VER,QUIT) ; Check versions needed.
 ;  
 N V
 S V=$$VERSION^XPDUTL(PRE)
 W !,$$CJ^XLFSTR("Need at least "_PRE_" v "_VER_"....."_PRE_" v "_V_" Present",IOM)
 I V<VER W *7,!,$$CJ^XLFSTR("^^^^**NEEDS FIXED**^^^^",IOM) Q 0
 Q 1
 ;
