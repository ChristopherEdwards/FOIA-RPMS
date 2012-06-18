ACHSR1 ; IHS/ITSC/PMF - for export testing   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;
 N A,B,C1,C2,C,D,II,PMF
 ;
 S A="XPRT4"
 ;
 S B=$O(^ACHSF(DUZ(2),A,""))
 ;
 I B="" Q
 ;
 S C="" F II=1:1:2 S PMF="C"_II S C=$O(^ACHSF(DUZ(2),A,B,C)) Q:C=""  S @PMF=C
 ;W !,C1,!,C2,! R PMF
 ;
 I $G(C1)="" Q
 I $G(C2)="" Q
 ;
 S B="" F  S B=$O(^ACHSF(DUZ(2),A,B)) Q:B=""  D C
 ;
 W !
 ;
 F C=C1,C2 S B="" F  S B=$O(^ACHSF(DUZ(2),A,B)) Q:B=""  I $O(^ACHSF(DUZ(2),A,B,C,""))="" W " .." K ^ACHSF(DUZ(2),A,B,C)
 ;
 Q
 S A="ACHS6"
 S B="" F  S B=$O(^ACHSF(DUZ(2),A,B)) Q:B=""  D C2
 Q
C ;
 S D="" F  S D=$O(^ACHSF(DUZ(2),A,B,C1,D)) Q:D=""  I $D(^ACHSF(DUZ(2),A,B,C2,D)) W " ." K ^ACHSF(DUZ(2),A,B,C1,D),^ACHSF(DUZ(2),A,B,C2,D)
 Q
 ;
C2 ;
 S D="" F  S D=$O(^ACHSF(DUZ(2),A,B,D)) Q:D=""  D C3
 Q
C3 ;
 S CC1=C1,CC2=C2 D C4
 S CC1=C2,CC2=C1 D C4
 Q
C4 ;
 S E="" F  S E=$O(^ACHSF(DUZ(2),A,B,D,CC1,E)) Q:E=""  D C5
 Q
C5 ;
 S F="" F  S F=$O(^ACHSF(DUZ(2),A,B,D,CC2,F)) Q:F=""  D
 . I E=F K ^ACHSF(DUZ(2),A,B,D,CC1,E),^ACHSF(DUZ(2),A,B,D,CC2,E) W ". "
 . Q
 Q
