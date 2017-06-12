ICD1857P ;ISL/KER - ICD*18.0*57 Pre/Post-Install ;04/21/2014
 ;;18.0;DRG Grouper;**57**;Oct 20, 2000;Build 7
 ;               
 ;               
 ; Global Variables
 ;    ^%ZOSF("UCI")       ICR  10096
 ;    ^%ZOSF("UCICHECK")  ICR  10096
 ;    ^TMP("LEX*2.0*80"   SACC 2.3.2.5.1
 ;               
 ; External References
 ;    $$VERSION^%ZOSV     ICR  10097
 ;    FIELD^DID           ICR   2052
 ;    EN^DIU2             ICR  10014
 ;    $$UP^XLFSTR         ICR  10104
 ;    $$NETNAME^XMXUTIL   ICR   2734
 ;    BMES^XPDUTL         ICR  10141
 ;    MES^XPDUTL          ICR  10141
 ;               
 ; Local Variables NEWed or KILLed by KIDS
 ;     XPDNOQUE
 ;     
 ; SACC Exemption
 ; 
 ;    $ZU(68,28,n)        May 9, 2013
 ;                        
 ;    Clinical Lexicon requests an exemption to use $ZU in
 ;    the pre and post install routines for future LEX 
 ;    patches. This exemption will expire with the release 
 ;    of LEX 3.0. Calling $ZU(68,28,0) to enable an 
 ;    unsubscripted global kill prior to installing the 
 ;    latest ICD files leaves the possibility that a global
 ;    will be killed by another process during a lengthy 
 ;    installation. Placing the call in the pre (or post) 
 ;    install, instead of making the call manually before 
 ;    and after the install, cuts this window down to a 
 ;    few seconds.
 ;             
 Q
PRE ; ICD*18.0*57 Pre-Install
 S XPDNOQUE=1 I $D(ZTQUEUED) S XPDABORT=1,XPDQUIT=1,XPDQUIT("ICD*18.0*57")=1,XPDQUIT("LEX*2.0*80")=1 Q
 Q:+($$UOK)'>0  D DEL
 Q
POST ; ICD*18.0*57 Post-Install
 S XPDNOQUE=1 I $D(ZTQUEUED) S XPDABORT=1,XPDQUIT=1,XPDQUIT("ICD*18.0*57")=1,XPDQUIT("LEX*2.0*80")=1 Q
 D N0
 Q
 ;
 ; Miscellaneous
N0 ;   Node 0
 D BM(" Updating ICD files")
 N ICD0,ICD9,ICDI,ICDL,ICDM,ICDT
 K ICD9,ICDM D FIELD^DID(80,.01,,"LABEL","ICD9","ICDM")
 K ICD0,ICDM D FIELD^DID(80.1,.01,,"LABEL","ICD0","ICDM")
 D M("    ICD DIAGNOSIS              file #80")
 I $L($G(ICD9("LABEL"))),('$D(^ICD9(0))) D
 . N ICDL,ICDT,ICDI S ICDL="",ICDT=0,ICDI=0
 . F  S ICDI=$O(^ICD9(ICDI)) Q:+ICDI'>0  S ICDL=ICDI,ICDT=ICDT+1
 . S ^ICD9(0)="ICD DIAGNOSIS^80OI^"_ICDL_"^"_ICDT
 D M("    ICD OPERATION/PROCEDURE    file #80.1")
 I $L($G(ICD0("LABEL"))),('$D(^ICD0(0))) D
 . N ICDL,ICDT,ICDI S ICDL="",ICDT=0,ICDI=0
 . F  S ICDI=$O(^ICD0(ICDI)) Q:+ICDI'>0  S ICDL=ICDI,ICDT=ICDT+1
 . S ^ICD0(0)="ICD OPERATION/PROCEDURE^80.1OI^"_ICDL_"^"_ICDT
 Q
UOK(X) ;   UCI Ok for Install
 N X,Y S X=$$NETNAME^XMXUTIL(.5) Q:X["LEXDEV1.FO-BAYPINES" 0
 X ^%ZOSF("UCI") Q:$G(Y)["LEXDEV1" 0  S X="LEXDEV1" X ^%ZOSF("UCICHECK")  Q:$G(X)=$G(Y) 0
 Q 1
DEL ;   Delete ICD Data Dictionaries and Globals
 Q:+($$UOK)'>0  N DIU,ICDMUM S ICDMUM=$$UP^XLFSTR($$VERSION^%ZOSV(1))
 D BM("   Deleting the Data Dictionary and Data for:")
 D M("       ICD DIAGNOSIS file #80") H 1
 S DIU="^ICD9(",DIU(0)=$S($D(^TMP("LEX*2.0*80",$J,"NODATA")):"T",1:"DT")
 S:ICDMUM["CACHE" X=$ZU(68,28,0) D EN^DIU2 S:ICDMUM["CACHE" X=$ZU(68,28,1) W "  done"
 D M("       ICD OPERATION/PROCEDURE file #80.1") H 1
 S DIU="^ICD0(",DIU(0)=$S($D(^TMP("LEX*2.0*80",$J,"NODATA")):"T",1:"DT")
 S:ICDMUM["CACHE" X=$ZU(68,28,0) D EN^DIU2 S:ICDMUM["CACHE" X=$ZU(68,28,1) W "  done"
 Q
M(X) ;   Blank/Text
 D MES^XPDUTL($G(X)) Q
BM(X) ;   Blank/Text
 D BMES^XPDUTL($G(X)) Q
TRIM(X) ;   Trim Spaces
 S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
CLR ;   Clear Variables not NEWed
 N ZTQUEUED,XPDABORT,XPDQUIT,XPDQUIT
 Q
