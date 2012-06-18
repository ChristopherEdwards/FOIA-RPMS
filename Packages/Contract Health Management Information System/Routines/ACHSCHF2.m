ACHSCHF2 ; IHS/ITSC/TPF/PMF - C H E F UTILITY ;  
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**15,16,18**;JUN 11, 2001
 ;ACHS*3.1*15 12.15.2008 IHS.OIT.FCJ ADDED FIELD TO ADD COMMENTS
 ;ACHS*3.1*16 11.05.2009 IHS.OIT.FCJ ADDED ADDITIONAL FIELD AND TEST FOR BLANKETS
 ;
 Q
 ;
 ;  --------------------------------------------------------------
 ;
AED ;EP - From option, Add/Edit/Delete CHEF case/P.O.'s.
 N DIC,DIE,DA,DR
 D SEL
 Q:Y<1
 S DA(1)=DUZ(2),DA=+Y
 S DIE="^ACHSCHEF("_DUZ(2)_",1,"
 ;ACHS*3.1*15 12.15.2008 IHS/OIT/FCJ ADDED COMMENTS FIELD TO NXT LINE
 ;S DR=".01:.03;1"
 ;ACHS*3.1*16 11.05.2009 IHS/OIT/FCJ ADDED REIMBURSEMENT %, BLANKETS AND AMENDMENTS TO NXT LINE
 ;S DR=".01:.03;1;2"
 ;ACHS*3.1*18 7.21.2010 IHS/OIT/FCJ REMOVE .03 "TOTAL FUNDS RECIEVED" FR EDIT
 ;S DR=".01:.04;1;3;4;2"
 S DR=".01;.02;.04;1;3;4;2"
 D ^DIE
 ;ACHS*3.1*18 7.21.2010 IHS/OIT/FCJ ADDED NEXT 3 LINES
 I $P(^ACHSCHEF(DUZ(2),1,DA,0),U,3)>0 D
 .W !,"TOTAL FUNDS RECIEVED: ",$P(^ACHSCHEF(DUZ(2),1,DA,0),U,3),"  Note: this is an amount that was entered prior"
 .W !,"to the Amendment options and will be subtracted from total requested."
 Q
 ;
 ;  --------------------------------------------------------------
 ;
SEL ;EP --  Select a CHEF case.
 N DIC,DA
 I '$D(^ACHSCHEF(DUZ(2))) D FILE
 S DIC="^ACHSCHEF("_DUZ(2)_",1,",DIC(0)="AELMQZ",DA(1)=DUZ(2)
 D ^DIC
 Q
 ;
 ;  --------------------------------------------------------------
 ;
FILE ;
 N DIC,DINUM
 S DIC(0)="L",DIC="^ACHSCHEF(",(X,DINUM)=DUZ(2)
 K DD,DO D FILE^DICN
 S ^ACHSCHEF(DUZ(2),1,0)=$$ZEROTH^ACHS(9002064.1,1)
 Q
 ;
 ;  --------------------------------------------------------------
 ;
POIT ;EP - From dd, Input Transform for Purchase Order.
 Q:'$D(X)
 I $L(X)'=11 K X W:'$D(ZTQUEUED) "  Must be 11 chars." Q
 I '(X?1N1"-"1U2N1"-"5N) K X W:'$D(ZTQUEUED) "  Not a P.O. number" Q
 I $P(X,"-",2)'=$$FC^ACHS(DA(2)) K X W:'$D(ZTQUEUED) "  Financial code must be ",$$FC^ACHS(DA(2)) Q
 I '$D(^ACHSF(DA(2),"D","B",1_$E(X)_$P(X,"-",3))) K X W:'$D(ZTQUEUED) "  P.O. does not exist" Q
 N D
 S D=$O(^ACHSF(DA(2),"D","B",1_$E(X)_$P(X,"-",3),0))
 ;ACHS*3.1*16 11/5/2009 IHS.OIT.FCJ ADDED ACHSB TST TO NEXT LINE THEN ADDED NEX LINE TO TEST FOR BLK/SL
 ;I $P($G(^ACHSF(DA(2),"D",D,0)),U,22)'=$P($G(^ACHSCHEF(DA(2),1,DA,0)),U,2) K X W:'$D(ZTQUEUED) "  P.O. is not for Patient in this CHEF case" Q
 I ACHSB=0,$P($G(^ACHSF(DA(2),"D",D,0)),U,22)'=$P($G(^ACHSCHEF(DA(2),1,DA,0)),U,2) K X W:'$D(ZTQUEUED) "  P.O. is not for Patient in this CHEF case" K ACHSB Q
 I ACHSB=1,$P($G(^ACHSF(DA(2),"D",D,0)),U,3)=0 K X W:'$D(ZTQUEUED) "  P.O. is not a Blanket or Special Local type." K ACHSB Q
 Q
 ;
 ;  --------------------------------------------------------------
 ;
PARM ;EP - From option, Enter/Edit CHEF Parameters.
 W !!
 N ACHSFLD,DA,DIC,DIE,DR
 S DA=DUZ(2),DIC=9002080
 F ACHSFLD=14.27,14.31 W $J($P($G(^DD(DIC,ACHSFLD,0)),U),25)," = ",$$VAL^XBDIQ1(DIC,DA,ACHSFLD),!
 S DIE="^ACHSF(",DR="14.27;14.31"
 D ^DIE
 Q
 ;
