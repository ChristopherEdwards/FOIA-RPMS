AICD11UT ;IHS/AICD/RNB - Correcting LARGE EINs and BAD 0 Nodes Entries ; 
 ;;3.51;IHS ICD/CPT lookup & grouper;**11**;Nov 08, 1991
 ;
 ; To clean/correct bad entries in ^AUTTCMOD and ^ICPT
 ;    For ^AUTTCMOD:
 ;        LARGE EIN values - need to remove
 ;    
 ;    For ^ICPT:
 ;        Bad/Missing data in invalid ^ICPT(EIN,0) node - missing code or
 ;        (code and short description)
 ;        If bad ^ICPT structure - delete
 ;        If godd structure but missing code or (code and short description) enter
 ;        "unknown" for code and short description
 ;        
 N X,ANS,CODE,ERR,X,Y,DIR
 S X="ERR^AICD12",@^%ZOSF("TRAP")
 S ERR=1
 W !!,$$CJ^XLFSTR("CPT MODIFIER FILE AND CPT FILE CORRECTION UTILITY - BEGIN","")
 ;
 ;Check ^AUTTCMOD for LARGE EIN values
 ;
 W !!,$$CJ^XLFSTR("CPT MODIFIER FILE CHECK - START","")
 W !!,$$CJ^XLFSTR("CPT MODIFIER ENTRIES THAT ARE REMOVED","")
 S AA=9090 F  S AA=$O(^AUTTCMOD(AA)) Q:AA="B"  W !,AA K ^AUTTCMOD(AA)
 W !!,$$CJ^XLFSTR("CPT MODIFIER ENTRIES THAT ARE REMOVED FROM THE 'B' INDEX","")
 S AA="" F  S AA=$O(^AUTTCMOD("B",AA)) Q:AA=""  S BB="" F  S BB=$O(^AUTTCMOD("B",AA,BB)) Q:BB=""  I BB>9090 W !,AA," - ",BB K ^AUTTCMOD("B",AA,BB)
 W !!,$$CJ^XLFSTR("CPT MODIFIER ENTRIES THAT ARE REMOVED FROM THE 'C' INDEX","")
 S AA="" F  S AA=$O(^AUTTCMOD("C",AA)) Q:AA=""  S BB="" F  S BB=$O(^AUTTCMOD("C",AA,BB)) Q:BB=""  I BB>9090 W !,AA," - ",BB K ^AUTTCMOD("C",AA,BB)
 ;
 ; Re-list to see if clean
 W !!,$$CJ^XLFSTR("CPT MODIFIER CHECK 2ND RUN","")
 S AA=9090 F  S AA=$O(^AUTTCMOD(AA)) Q:AA="B"  W !,AA
 ;
 W !!,$$CJ^XLFSTR("CPT MODIFIER FILE CHECK - END","")
 ;
 ; Check ^ICPT for bad zero node entries
 ;
 W !!,$$CJ^XLFSTR("CPT FILE CHECK - START","")
 S AA=0 F  S AA=$O(^ICPT(AA)) Q:(AA="ACT")!(AA="B")  I $P($G(^ICPT(AA,0)),"^",1)="" W !,AA," = ",$G(^ICPT(AA,0)) D PROCS
 W !!,$$CJ^XLFSTR("CPT FILE CHECK - END","")
 W !!,$$CJ^XLFSTR("CPT MODIFIER FILE AND CPT FILE CORRECTION UTILITY - FINISHED","")
 Q
PROCS ;
 ;
 ; Check the indices:
 ;        if none found remove bad entry
 ;        if found entries set code / short description to "unknown"
 ;
 S (GFLG1,GFLG2)=0
 S ZZ="" F  S ZZ=$O(^ICPT("B",ZZ)) Q:ZZ=""  I $D(^ICPT("B",ZZ,AA))=1 S GFLG1=1 Q
 S ZZ="" F  S ZZ=$O(^ICPT("BA",ZZ)) Q:ZZ=""  I $D(^ICPT("BA",ZZ,AA))=1 S GFLG2=1 Q
 I (GFLG1=0)&(GFLG2=0) K ^ICPT(AA) W "  HAS BEEN REMOVED",! Q
 I (GFLG1=1)!(GFLG2=1) S $P(^ICPT(AA,0),"^",1)="unknown",$P(^ICPT(AA,0),"^",2)="unknown" W "  HAS BEEN SET TO - 'unknown'"
 Q
