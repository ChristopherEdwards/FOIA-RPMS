ACHSCR16 ; COMPILED XREF FOR FILE #9002080.02 ; 11/08/10
 ; 
 S DA(2)=DA(1) S DA(1)=0 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=2 DIKLM=1 S:DIKM1'=2&'$G(DIKPUSH(2)) DIKPUSH(2)=1,DA(2)=DA(1),DA(1)=DA,DA=0 G @DIKM1
A S DA(1)=$O(^ACHSF(DA(2),"D",DA(1))) I DA(1)'>0 S DA(1)=0 G END
1 ;
B S DA=$O(^ACHSF(DA(2),"D",DA(1),"T",DA)) I DA'>0 S DA=0 Q:DIKM1=1  G A
2 ;
 S DIKZ(0)=$G(^ACHSF(DA(2),"D",DA(1),"T",DA,0))
 S X=$P(DIKZ(0),U,2)
 I X'="" S ^ACHSF(DA(2),"TB",+$P(^ACHSF(DA(2),"D",DA(1),"T",DA,0),"^",1),$E(X,1,30),DA(1),DA)=""
 S X=$P(DIKZ(0),U,2)
 I X'="" S:((X="I")!(X="C"&($P(^ACHSF(DA(2),2),U,6)="Y"))!(X="S"&($P(^ACHSF(DA(2),2),U,7)="Y")))&('$D(^ACHS(7,"P",DA(2),DA(1),DA))) ^ACHSF("PQ",DA(2),$P(^ACHSF(DA(2),"D",DA(1),0),U,4),DA(1),DA)=""
 S X=$P(DIKZ(0),U,3)
 I X'="" S ^ACHSF("AC",$E(X,1,30),DA(2),DA(1),DA)=""
 S X=$P(DIKZ(0),U,10)
 I X'="" S ^ACHSF(DA(2),"PDOS",X,DA(1),DA)=""
 S X=$P(DIKZ(0),U,13)
 I X'="" S ^ACHSF(DA(2),"EOBD",9999999-X,DA(1),DA)=""
 S X=$P(DIKZ(0),U,14)
 I X'="" S ^ACHSF(DA(2),"D",DA(1),"EB1",$P(^ACHSF(DA(2),"D",DA(1),"T",DA,0),"^",13),X,DA)=""
 G:'$D(DIKLM) B Q:$D(DISET)
END G ^ACHSCR17