SDC3 ;ALB/LDB - CANCELLATION LETTERS; [ 09/13/2001  2:19 PM ]
 ;;5.3;Scheduling;;Aug 13, 1993
 ;IHS/ANMC/LJF  8/18/2000 changed $N to $O
 ;             11/24/2000 moved letter's left margin in 5 spaces
 ;             11/29/2000 added count of rescheduled appts (BSDCNT)
 ;
EN ;F L1=0:0 S L1=$N(^SC(+SC,"S",SD,1,L1)) Q:L1'>0  S A=+^(L1,0) D CHECK,SET:$D(SDOK)  ;IHS/ANMC/LJF 8/18/2000
 F L1=0:0 S L1=$O(^SC(+SC,"S",SD,1,L1)) Q:L1'>0  S A=+^(L1,0) D CHECK,SET:$D(SDOK)  ;IHS/ANMC/LJF 8/18/2000 $N->$O
 Q
CHECK K SDOK I $S('$D(^DPT(+A,.35)):1,$P(^DPT(+A,.35),"^",1)']"":1,1:0),$D(^DPT(+A,"S",SD)),$P(^DPT(+A,"S",SD,0),"^",2)="C"!($P(^(0),"^",2)="CA") S SDOK=1
 Q
SET S ^UTILITY("SDLT",$J,+SDLET,+A,SD,+SC)="" I $P(^DPT(+A,"S",SD,0),"^",2)="CA"&($P(^(0),"^",10)]"") S SD8=$P(^(0),"^",10) I $D(^DPT(+A,"S",SD8,0)),$P(^(0),"^",2)'["C" S ^UTILITY("SDLT",$J,+SDLET,"A",+A,SD8,+SC)=""
 Q
PR F SD1=0:0 S SD1=$O(^UTILITY("SDLT",$J,SD1)) Q:'SD1  S SDLET=SD1 D PR0
 Q
 ;
 ;IHS/ANMC/LJF 8/18/2000 $N -> $O
PR0 ;S SD81=0 F SD8=0:0 D:SD8'=SD81 PR1 S SD81=SD8,SD8=$N(^UTILITY("SDLT",$J,SD1,SD8)) Q:SD8'>0  S A=SD8 D ^SDLT F SD82=0:0 S SD82=$N(^UTILITY("SDLT",$J,SD1,SD8,SD82)) Q:SD82'>0  S SDC=$N(^(SD82,-1)),SDX=SD82,S=^DPT(+A,"S",SD82,0) D WRAPP^SDLT
 S SD81=0 F SD8=0:0 D:SD8'=SD81 PR1 S SD81=SD8,SD8=$O(^UTILITY("SDLT",$J,SD1,SD8)) Q:SD8'>0  S A=SD8 D ^SDLT F SD82=0:0 S SD82=$O(^UTILITY("SDLT",$J,SD1,SD8,SD82)) Q:SD82'>0  S SDC=$O(^(SD82,-1)),SDX=SD82,S=^DPT(+A,"S",SD82,0) D WRAPP^SDLT
 ;
 Q
PR1 ;I $D(^UTILITY("SDLT",$J,SD1,"A",SD8)),A=SD8 W !!,"The cancelled appointments have been rescheduled as follows:",! D PR2  ;IHS/ANMC/LJF 11/24/2000
 I $D(^UTILITY("SDLT",$J,SD1,"A",SD8)),A=SD8 W !!?5,"The cancelled appointments have been rescheduled as follows:",! D PR2  ;IHS/ANMC/LJF 11/24/2000
 D REST^SDLT Q
PR2 ;F SD82=0:0 S SD82=$N(^UTILITY("SDLT",$J,SD1,"A",SD8,SD82)),SDX=SD82 Q:SD82'>0  S SC=$N(^(SD82,-1)),S=^DPT(+A,"S",SD82,0) D WRAPP^SDLT  ;IHS/ANMC/LJF 8/18/2000
 K BSDCNT F SD82=0:0 S SD82=$O(^UTILITY("SDLT",$J,SD1,"A",SD8,SD82)),SDX=SD82 Q:SD82'>0  S SC=$O(^(SD82,-1)),S=^DPT(+A,"S",SD82,0) D WRAPP^SDLT S BSDCNT=$G(BSDCNT)+1 ;IHS/ANMC/LJF 8/18/2000;11/29/2000
 Q
