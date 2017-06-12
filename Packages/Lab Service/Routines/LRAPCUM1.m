LRAPCUM1 ;VA/AVAMC/REG - AP PATIENT CUM ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;LAB SERVICE;**1031,1034**;NOV 1, 1997;Build 88
 ;
 ;;VA LR Patche(s): 315
 ;
EP ; EP
 ;
 D:$Y>LRA(1)!'$Y MORE Q:LRA(2)?1P
 W !,LR("%"),!,"SNOMED/ICD codes:" F C=0:0 S C=$O(^LR(LRDFN,LRSS,LRI,2,C)) Q:'C  S T=+^(C,0),T=^LAB(61,T,0) D:$Y>LRA(1)!'$Y MORE Q:LRA(2)?1P  W !,"T-",$P(T,"^",2),": " S X=$P(T,"^") D:LR(69.2,.05) C^LRUA W X D M
 Q:LRA(2)?1P
 W !
 ; N LRX
 NEW LRX,BLRTAB,BLREDT                                          ; IHS/MSC/MKK - LR*5.2*1034
 F C=0:0 S C=$O(^LR(LRDFN,LRSS,LRI,3,C)) Q:'C  D  Q:LRA(2)?1P
 . D:$Y>LRA(1)!'$T MORE
 . Q:LRA(2)?1P
 . ; S LRX=+^LR(LRDFN,LRSS,LRI,3,C,0),LRX=$$ICDDX^ICDCODE(LRX,,,1)
 . ;
 . S LRX=+$G(^LR(LRDFN,LRSS,LRI,3,C,0)),LRX=$$ICDDX^ICDEX(LRX,,,"I")    ; IHS/MSC/MKK - LR*5.2*1034
 . ;
 . S X=$P(LRX,"^",4)
 . ; W !,"ICD code: ",$P(LRX,"^",2),?20
 . W !,"ICD Code: ",$P(LRX,"^",2),"  " S BLRTAB=$X              ; IHS/MSC/MKK - LR*5.2*1034
 . D:LR(69.2,.05) C^LRUA
 . ; W X
 . D LINEWRAP^BLRGMENU(BLRTAB,X,(IOM-BLRTAB)-1)  W !            ; IHS/MSC/MKK - LR*5.2*1034
 . Q
 Q
 ;
M F B=0:0 S B=$O(^LR(LRDFN,LRSS,LRI,2,C,2,B)) Q:'B  S M=+^(B,0),M=^LAB(61.1,M,0) D:$Y>LRA(1)!'$Y MORE Q:LRA(2)?1P  W !?5,"M-",$P(M,"^",2),": " S X=$P(M,"^") D:LR(69.2,.05) C^LRUA W X D EX
 Q:LRA(2)?1P  F B=1.4,3.3,4.5 F F=0:0 S F=$O(^LR(LRDFN,LRSS,LRI,2,C,$P(B,"."),F)) Q:'F  D A
 Q
 ;
A S M=+^LR(LRDFN,LRSS,LRI,2,C,$P(B,"."),F,0),E="61."_$P(B,".",2),M=^LAB(E,M,0) D:$Y>LRA(1)!'$Y MORE Q:LRA(2)?1P  W !?5,$S(B=1.4:"D-",B=3.3:"F-",B=4.5:"P-",1:""),$P(M,"^",2),?12,": " S X=$P(M,"^") D:LR(69.2,.05) C^LRUA W X
 Q
 ;
EX F G=0:0 S G=$O(^LR(LRDFN,LRSS,LRI,2,C,2,B,1,G)) Q:'G  S E=+^(G,0),E=^LAB(61.2,E,0) D:$Y>LRA(1)!'$Y MORE Q:LRA(2)?1P  W !?10,"E-",$P(E,"^",2),": " S X=$P(E,"^") D:LR(69.2,.05) C^LRUA W X
 Q
 ;
MORE D MORE^LRAPCUM Q
