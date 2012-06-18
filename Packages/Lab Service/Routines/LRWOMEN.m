LRWOMEN ;DALOI/CYM/FT/CKA - LINK TO WOMEN'S HEALTH PROGRAM ;10/22/04  13:14
 ;;5.2;LAB SERVICE;**1030**;NOV 1, 1997
 ;;5.2;LAB SERVICE;**231,248,311,324,365**;Sep 27, 1994;Build 11
 ;
 ;Reference to CREATE^WVLRLINK supported by IA #2772
 ;Reference to DELETE^WVLRLINK supported by IA #2772
 ;Reference to CREATE^WVLABCHK supported by IA #4525
 ;
ADD ; From DD 63.08,.11 and 63.09,.11
 Q:+$G(LRDPF)'=2
 Q:'$D(LRSS)
 Q:$P(^LR(LRDFN,LRSS,LRI,0),U,11)']""
 Q:$G(SEX)'["F"
 ; Q:$T(CREATE^WVLRLINK)']""                               ; IHS/OIT/MKK - LR*5.2*1030 - RPMS does NOT use VA's LRWOMEN package
 ; D CREATE^WVLRLINK(DFN,LRDFN,LRI,$G(LRA),LRSS)           ; IHS/OIT/MKK - LR*5.2*1030 - RPMS does NOT use VA's LRWOMEN package
 Q
 ;
 ;
DEL ; From LRAPM
 Q:$G(SEX)'["F"
 Q:+$G(LRDPF)'=2
 Q:'$D(LRSS)
 Q:$P(^LR(LRDFN,LRSS,LRI,0),U,11)]""
 ; Q:$T(DELETE^WVLRLINK)']""                               ; IHS/OIT/MKK - LR*5.2*1030 - RPMS does NOT use VA's LRWOMEN package
 ; D DELETE^WVLRLINK(DFN,LRDFN,LRI,X,LRSS)                 ; IHS/OIT/MKK - LR*5.2*1030 - RPMS does NOT use VA's LRWOMEN package
 Q
 ;
 ;
MOVE ; From LRAPMV
 ; no longer used after LR*5.2*259
 Q
 ;
 ;
SNOMED ; From DD 63.08,10 and 63.09,10
 Q:+$G(LRDPF)'=2
 Q:'$D(LRSS)
 Q:$P(^LR(LRDFN,LRSS,LRI,0),U,11)=""
 Q:$G(SEX)'["F"
 ; Q:$T(CREATE^WVLABCHK)']""                               ; IHS/OIT/MKK - LR*5.2*1030 - RPMS does NOT use VA's LRWOMEN package
 ; D CREATE^WVLABCHK(DFN,LRDFN,LRI,$G(LRA),LRSS)           ; IHS/OIT/MKK - LR*5.2*1030 - RPMS does NOT use VA's LRWOMEN package
 Q
