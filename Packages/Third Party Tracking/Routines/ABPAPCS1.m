ABPAPCS1 ;PVT-INS PAID CLAIM SUMMARY;[ 05/24/91  1:55 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 ;VARIABLE DEFINITION: R   = PAYMENT DFN
 ;                     RR  = LINKED CLAIM DFN
 ;                     RRR = PAYMENT AMOUNT DFN
 ;
START S R=0 F ABPAR=1:1 D  Q:+R=0
 .S R=$O(^ABPVAO(ABPATDFN,"P","CD",ABPACDT,R)) Q:+R=0
 .S RR=0,RRR=0,ABPA("CTOT")=0,ABPA("PTOT")=0
 .W ! F ABPARR=1:1 D  Q:+RR=0
 ..S RR=$O(^ABPVAO(ABPATDFN,"P",R,"D",RR))
 ..I +RR=0 D AMT Q:+RRR=99  D  Q
 ...W !?33,"--------",?64,"--------",!?33
 ...W $J(ABPA("CTOT"),8,2),?64,$J(ABPA("PTOT"),8,2)
 ..S ABPAC=$P(^ABPVAO(ABPATDFN,"P",R,"D",RR,0),"^",2)
 ..D DT3 S ABPAI=ABPAI+1
 ..I ABPARR=1 D
 ...S ABPATDT=+^ABPVAO(DA,"P",R,0)
 ...S ABPAPDT=+$E(ABPATDT,4,5)_"/"_+$E(ABPATDT,6,7)_"/"
 ...S ABPAPDT=ABPAPDT_+$E(ABPATDT,2,3) K ABPATDT
 ...W ?50,$J(ABPAPDT,10)
 ..S RRR=$O(^ABPVAO(ABPATDFN,"P",R,"A",RRR))
 ..I +RRR>0 D
 ...W:$X>62 ! W ?62,$J(+^ABPVAO(DA,"P",R,"A",RRR,0),10,2)
 ...S ABPA("PTOT")=ABPA("PTOT")+(+^ABPVAO(DA,"P",R,"A",RRR,0))
 ...W "  (",$P(^ABPVAO(DA,"P",R,"A",RRR,0),"^",2),")"
 ..I +RRR<1 S RRR=99
 ..I $Y>21&(IO=IO(0)) D  Q
 ...I +RRR<99 D
 ....S ABPA("PTOT")=ABPA("PTOT")-(+^ABPVAO(DA,"P",R,"A",RRR,0))
 ...S ABPA("CTOT")=ABPA("CTOT")-(+$P(^ABPVAO(DA,1,ABPAC,0),"^",7))
 ...S RR=RR-1,RRR=RRR-1,ABPAI=ABPAI-1,ABPARR=ABPARR-1 S:+RR=0 RR=.99
 ...R !,?20,"< Press 'RETURN' to Continue, or '^' to Exit >",X:300
 ...I '$T!(X="^") S R="",RR="" Q
 ...D ^ABPAPCS2
 ..I $Y>55 W @IOF
 I ABPAR=1 D
 .W *7,!!,"No payments on file for claim date "
 .W +$E(ABPACDT,4,5)_"/"_+$E(ABPACDT,6,7)_"/"_+$E(ABPACDT,2,3),"."
QUIT Q
 ;
DT3 S Y=^ABPVAO(DA,1,ABPAC,0),ABPA(ABPAI)=+Y
 S ABPAINS=$E($P(^AUTNINS($P(Y,U,6),0),U),1,15)
 W !,$J(ABPAI,2),?5,$J("",14-$L(ABPAINS)\2)_ABPAINS,?22
 W $J((+$E(Y,4,5)_"/"_+$E(Y,6,7)_"/"_+$E(Y,2,3)),8),?33
 W $J($P(Y,U,7),8,2) S ABPA("CTOT")=ABPA("CTOT")+(+$P(Y,U,7))
 S ABPASTAT=$P(Y,"^",17)
 W ?43,ABPASTAT,$S(ABPASTAT="C":"LOSED",ABPASTAT="D":"ENIED",ABPASTAT="PA":"ID",ABPASTAT="PE":"NDING",ABPASTAT="O":"PEN",1:"??????") Q
 ;
AMT F ABPARRR=0:0 D  Q:+RRR=0!(+RRR=99)
 .S RRR=$O(^ABPVAO(ABPATDFN,"P",R,"A",RRR)) Q:+RRR=0
 .W:$X>62 ! W ?62,$J(+^ABPVAO(DA,"P",R,"A",RRR,0),10,2)
 .S ABPA("PTOT")=ABPA("PTOT")+(+^ABPVAO(DA,"P",R,"A",RRR,0))
 .W "  (",$P(^ABPVAO(DA,"P",R,"A",RRR,0),"^",2),")"
 .I $Y>21&(IO=IO(0)) D  Q
 ..S R=R-1,RR="",RRR=99,ABPAI=ABPAI-1
 ..R !,?20,"< Press 'RETURN' to Continue, or '^' to Exit >",X:300
 ..I '$T!(X="^") S R="" Q
 ..D ^ABPAPCS2
 .I $Y>55 W @IOF
