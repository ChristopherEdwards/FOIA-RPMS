ACHSPAA ; IHS/ITSC/PMF - DOCUMENT PAYMENT - ENTER/EDIT AMOUNT ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
A1 ;
 W !!,"IHS Cost: "
 I ACHSVAMT S X=ACHSVAMT,X2=2 D FMT^ACHS W "//"
 ;
 D READ^ACHSFU
 I $D(DUOUT)!$D(DTOUT) D END Q
 I Y?1"?".E W !,"  Enter The Dollar Amount Requested for Payment (e.g. 27.50)" G A1
 I Y="" D END:ACHSVAMT W *7,"  Must Have Amount" G A1
 S:$E(Y,1)="$" Y=$E(Y,2,999)
 F I=1:1 S F=$F(Y,",") Q:'F  S Y=$E(Y,1,F-2)_$E(Y,F,99)
 I '(Y?1N.N1"."2N!(Y?1N.N))!($L(Y)>10) W *7,"  ??" G A1
 S X=Y,X2=2
 W "  ("
 D FMT^ACHS
 W ")"
 S H=$J(Y,1,2),T=ACHSPAMT-ACHSVAMT+H
 I T'>ACHSTAO G A9
 W !!,"Obligated Amount"
 S X=ACHSTAO,X2=2,X3=20
 D FMT^ACHS
 W !,"Current Charge Total"
 S X=T,X2=2,X3=16
 D FMT^ACHS
 W !?26,"---------",!,"Exceeded Amount         "
 S X=T-ACHSTAO,X2=2,X3=12
 D FMT^ACHS
 I ACHSOPAY W !!,"Max Overpmt Allowed" S X=$P(ACHSOPAY,U,2),X2=2,X3=9 D FMT^ACHS
 I 'ACHSOPAY W !!,*7,"  The Charge Total May NOT Exceed The Obligated Amount.",!! G A1
 S D=T-ACHSTAO
 I D>$P(ACHSOPAY,U,2) W *7,!!,"  You May NOT Exceed This Amount" G A1
A2 ;
 G A1:'$$DIR^XBDIR("Y","Ok ","NO","","  Do You Wish To Overpay On This Document.","",2)
 I $D(DTOUT) D END Q
 G A1:$D(DUOUT)
A9 ;
 S ACHSIPA=ACHSIPA-ACHSVAMT+H,ACHSPAMT=T,ACHSVAMT=H
END ;
 Q
 ;
