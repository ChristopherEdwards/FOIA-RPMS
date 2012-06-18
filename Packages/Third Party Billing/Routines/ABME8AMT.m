ABME8AMT ; IHS/ASDST/DMJ - 837 AMT Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Transaction Set Header
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM13487/IM14092
 ;    Modified to print payments
 ;
EP(X) ;EP HERE
 ; x=entity identifier
 S ABMEIC=X
 K ABMREC("AMT"),ABMR("AMT")
 S ABME("RTYPE")="AMT"
 D LOOP
 K ABME,ABM,ABMEIC
 Q
LOOP ;LOOP HERE
 F I=10:10:40 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("AMT"))'="" S ABMREC("AMT")=ABMREC("AMT")_"*"
 .S ABMREC("AMT")=$G(ABMREC("AMT"))_ABMR("AMT",I)
 Q
10 ;segment
 S ABMR("AMT",10)="AMT"
 Q
20 ;AMT01 - Amount Qualifier Code
 S ABMR("AMT",20)=ABMEIC
 Q
30 ;AMT02 - Monetary Amount
 ; prior payment - actual
 I ABMEIC="C4"!(ABMEIC="D") D
 .D PAYED^ABMERUTL
 .S ABMR("AMT",30)=$G(ABMP("PAYED",+$G(ABMP("INS",ABMPST))))  ;pymt for that insurer
 ;
 ; payer estimated amount
 I ABMEIC="C5" D
 .D PAYED^ABMERUTL
 .S ABMR("AMT",30)=$P(ABMB2,U)
 .S ABMR("AMT",30)=ABMR("AMT",30)-$G(ABMP("PAYED"))
 .S ABMR("AMT",30)=ABMR("AMT",30)-$P(ABMB9,"^",9)
 ;
 ; patient paid amount
 I ABMEIC="F5" D
 .S ABMR("AMT",30)=$P(ABMB9,"^",9)
 ;
 I ABMEIC="F2" D
 .S ABMR("AMT",30)=ABMF2AMT
 ;
 ;start new code abm*2.6*3 HEAT7574
 I ABMEIC="B6" D
 .S ABMR("AMT",30)=ABMB6AMT
 ;end new code HEAT7574
 ;
 S ABMR("AMT",30)=$FN(ABMR("AMT",30),"-")
 S ABMR("AMT",30)=$J(ABMR("AMT",30),0,2)
 ;
 Q
40 ;AMT03 - Credit/Debit Flag Code-not used
 S ABMR("AMT",40)=""
 Q
