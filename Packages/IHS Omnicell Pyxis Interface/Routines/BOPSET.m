BOPSET ;IHS/ILC/ALG/CIA/PLS - Build Item Index in 90355.1;06-Apr-2005 13:41;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;;Jul 26, 2005
 ; Index ^BOP(90355.1,"ITM",patient DFN,orderIEN,drugIEN, 4 20 or 21 from node) =
 ;      drug or iv ^ BOP(90355.1 transaction # ^ what file the drug
 ;      is from ^ order status ^ subnode for 20.1 or 21.1 ex: 20-1
 ;
IN1 ; Entry from 4.01 field
 N A,B,C,D
 S A=$P($G(^BOP(90355.1,DA,1)),U,1),B=$G(^BOP(90355.1,DA,2))
 S C=$P($G(^BOP(90355.1,DA,4)),U,1),D=$P($G(^BOP(90355.1,DA,5)),U,11)
 I A=""!($P(B,U,2)="")!(C="") Q  ; do not set nill nodes
 S ^BOP(90355.1,"ITM",A,$P(B,U,2),C,4)=$S(D["PS(":"IV",1:"DRUG")_U_DA_U_D_U_$P(B,U,1)_U
 I D["PS(" S ^BOP(90355.1,"AIV",A,DA)=""
 K A,B,C,D
 Q
 ;
IN1K(DA1) ;  remove
 N A,B,C,D,E
 S A=$P($G(^BOP(90355.1,DA1,1)),U,1),B=$G(^BOP(90355.1,DA1,2))
 S C=$P($G(^BOP(90355.1,DA1,4)),U,1),D=$P($G(^BOP(90355.1,DA1,5)),U,11)
 I A=""!($P(B,U,2)="")!(C="") Q  ; do not kill nill nodes
 K ^BOP(90355.1,"ITM",A,$P(B,U,2),C,4)
 I D["PS(" K ^BOP(90355.1,"AIV",A,DA1)
 K A,B,C,D
 Q
 ;
IN20 ; EP -  Entry from solutions node 20
 N A,B,C,D,E
 S A=$P($G(^BOP(90355.1,DA(1),1)),U,1),B=$G(^BOP(90355.1,DA(1),2))
 S E=$G(^BOP(90355.1,DA(1),20,DA,0)),C=$P(E,U,1),D=$P(E,U,11)
 I A=""!($P(B,U,2)="")!(C="") Q  ; do not set nill nodes
 S ^BOP(90355.1,"ITM",A,$P(B,U,2),C,20)="IV^"_DA(1)_U_D_U_$P(B,U,1)_U_"20-"_DA
 S ^BOP(90355.1,"AIV",A,DA(1))=""
 K A,B,C,D,E
 Q
 ;
IN20K(DA1) ; remove soultions indexs
 N A,B,C,D,E,F,G
 S G=0 F  S G=$O(^BOP(90355.1,DA1,20,G)) Q:'G  D
 . S A=$P($G(^BOP(90355.1,DA1,1)),U,1),B=$G(^BOP(90355.1,DA1,2))
 . S E=$G(^BOP(90355.1,DA1,G,0)),C=$P(E,U,1),D=$P(E,U,11)
 . I A=""!($P(B,U,2)="")!(C="") Q  ; do not kill nill nodes
 . K ^BOP(90355.1,"ITM",A,$P(B,U,2),C,20)
 . K ^BOP(90355.1,"AIV",A,DA1)
 . Q
 K A,B,C,D,E,F,G
 Q
 ;
IN21 ; EP -  Entry from additives node 21
 N A,B,C,D,E
 S A=$P($G(^BOP(90355.1,DA(1),1)),U,1),B=$G(^BOP(90355.1,DA(1),2))
 S E=$G(^BOP(90355.1,DA(1),21,DA,0)),C=$P(E,U,1),D=$P(E,U,11)
 I A=""!($P(B,U,2)="")!(C="") Q  ; do not set nill nodes
 S ^BOP(90355.1,"ITM",A,$P(B,U,2),C,21)="IV^"_DA(1)_U_D_U_$P(B,U,1)_U_"21-"_DA
 S ^BOP(90355.1,"AIV",A,DA(1))=""
 K A,B,C,D,E
 Q
 ;
IN21K(DA1) ; remove additives index items
 N A,B,C,D,E,F,G
 S G=0 F  S G=$O(^BOP(90355.1,DA1,21,G)) Q:'G  D
 . S A=$P($G(^BOP(90355.1,DA1,1)),U,1),B=$G(^BOP(90355.1,DA1,2))
 . S E=$G(^BOP(90355.1,DA1,G,0)),C=$P(E,U,1),D=$P(E,U,11)
 . I A=""!($P(B,U,2)="")!(C="") Q  ; do not kill nill nodes
 . K ^BOP(90355.1,"ITM",A,$P(B,U,2),C,21)
 . K ^BOP(90355.1,"AIV",A,DA1)
 . Q
 K A,B,C,D,E,F,G
 Q
