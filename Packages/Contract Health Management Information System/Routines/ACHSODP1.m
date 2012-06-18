ACHSODP1 ; IHS/ITSC/PMF - PRINT DCR REPORT (2/3) ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 F I=1:1:9 S X=$P("D,N,R,ACHSPROV,DFN,T,O,A,ACHSDOS",",",I),@X=$P(ACHSACS,U,I)
 S (L(1),L(2))=""
 I DFN,$D(^DPT(DFN,0)) S X=$P(^(0),U),L(1)=$E(X,1,20) G A1
 ;
 S $P(L(1),U)=$S($P(^ACHSF(DUZ(2),"D",ACHSDIEN,0),U,3)=1:"* BLANKET DOCUMENT *",$P(^(0),U,3)=2:"** SPEC LOC DOC **",1:"")
A1 ;
 I $D(^ACHSF(DUZ(2),"D",ACHSDIEN,0)) S X=$P(^(0),U),L(2)=ACHSDPFX_$E(100000+X,2,6)
 ;
 I ACHSPROV,$D(^AUTTVNDR(ACHSPROV,0)) S X=^(0),$P(L(2),U,2)=$P(X,U,3),X=$P(X,U),$P(L(1),U,2)=$E(X,1,25)
 ;
 S $P(L(1),U,3)=$E(100+$E(D,4,5),2,3)_$E(100+$E(D,6,7),2,3)_$E(D,2,3)
 ;
 I ACHSDOS S $P(L(1),U,3)=$P(L(1),U,3)_"/"_$E(100+$E(ACHSDOS,4,5),2,3)_$E(100+$E(ACHSDOS,6,7),2,3)
 S X=$$DOC^ACHS(0,4),$P(L(2),U,3)=$S(X=1:"HOSPITAL",X=2:"DENTAL",X=3:"OUTPAT",1:"")
 S X=$P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,0)),U,17),$P(L(2),U,4)=$S(X="I":"IHS",1:"FI") I T="IP" S $P(L(2),U,4)=$P(L(2),U,4)_"  NOT IN TOTALS"
 S $P(L(2),U,2)=$P(^AUTTVNDR(ACHSPROV,11),U)
 I T="P" S D=$S(O>0:1,O<0:2,1:0) S X="P "_$P(">^<",U,D)_" Obl"
 E  S X=$P($T(@T),";;",2,99),D=$S(T="I":1,T="S":1,T="C":2,T="D":2,1:0)
 S $P(L(1),U,4)=X
 I T="ZA" S D=$S(O<0:2,1:1),$P(L(1),U,5)=$J(O,1,2) G A2
 I T="IP" S $P(L(1),U,5)=$J(O,1,2) ;G A3
 I T'="P" S:D=1 $P(L(1),U,5)=$J(O,1,2) S:D=2 $P(L(1),U,5)=$J(O*-1,1,2) G A2
 I O=0 S $P(L(1),U,4)="P = Obl"
 E  S $P(L(1),U,5)=$J(O,1,2)
A2 ;
 I D S:O<0 O=O*-1 S $P(ACHSSUM(R),U,D)=$P(ACHSSUM(R),U,D)+O
A3 ;
 F J=1,2 W ! F I=1:1:5 W ?$P("0^22^49^62^69",U,I) W:I<5 $P(L(J),U,I) I I=5 S X=$P(L(J),U,5) W ?80-$L(X),X
 W !
 K ACHSPROV
 Q
 ;
I ;;INIT
C ;;C-CANC
D ;;P-CANC
S ;;SUPPL
M ;;P-MEMO
P ;;PAYMENT
IP ;;INT-PMT
ZA ;;ADJUST
