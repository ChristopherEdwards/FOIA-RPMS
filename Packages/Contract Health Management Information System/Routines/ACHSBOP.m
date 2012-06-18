ACHSBOP ; IHS/ITSC/PMF - PRINT/DISPLAY REGISTER BALANCES ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 S ACHSIO=IO,%ZIS="P"
 D ^%ZIS,SLV^ACHSFU:$D(IO("S"))
 I POP D HAT Q
 ;
A1A ;EP - From option to display balances.
 K X2,X3
 U IO(0)
 X:$D(IO("S")) ACHSPPC   ;IF SLAVE OPEN SLAVE
FY ;
 S ACHSACFY=$$FYSEL^ACHS        ;SELECT A DEFINED FISCAL YEAR
 I $D(DUOUT)!$D(DTOUT) D HAT Q
 ;
 I '$D(^ACHS(9,DUZ(2),"FY",+Y))!'$D(ACHSFYWK(DUZ(2),+Y)) W !!,*7,"FY '",+Y,"' does not exist for this facility." G A1A
 S ACHSACWK=+ACHSFYWK(DUZ(2),ACHSACFY)
 ;
 D CKB^ACHSUUP                    ;CHECK BALANCES
 D NOW^ACHS                       ;SET ACHSTIME=CURRENT TIME
 ;
A1 ;
 U IO
 X:$D(IO("S")) ACHSPPO            ;
 W @IOF,!,$$C^XBFUNC($$LOC^ACHS),!,$$C^XBFUNC("CHS REGISTER BALANCES"),!?80-$L(ACHSTIME)/2,ACHSTIME
 S (S,B,W)=""
 S ACHSRGNM=$S($D(^ACHS(9,DUZ(2),"RN")):^ACHS(9,DUZ(2),"RN"),1:"")  ;'R-1 NAME' ?????
 S X3=16
 I '$D(^ACHS(9,DUZ(2),"FY",ACHSACFY,"W",ACHSACWK,1)),+ACHS("ZL")=DT S ACHSACWK=ACHSACWK-1
 ;
 ;GET FISCAL YEAR 0 NODE
 S S=$G(^ACHS(9,DUZ(2),"FY",ACHSACFY,0))
 ;
 ;GET FISCAL YEAR 1 NODE ('INITIAL REG-1')
 S B=$G(^ACHS(9,DUZ(2),"FY",ACHSACFY,1))
 ;
 S W=$G(^ACHS(9,DUZ(2),"FY",ACHSACFY,"W",ACHSACWK,1))
 S F=0
 F I=1:1:7 I $P(B,U,I) S F=1 Q   ;IF ANY 'INITAL REG-I' IS SET
A2 ;
 ;
 D SBH                ;PRINT SUB HEADER
 ;
 F K=1:1:7 D SBD      ;PRINT DETAIL LINE
 I 'F W ?48,"Un-Obligated Balance"
 ;
 ;PRINT BOTTOM SUMMARY
 W !
 I F W ?18,"---------------",?35,"----------------",?57,"----------------"
 E  W ?26,"----------------"
 W !,"TOTAL"
 I F S X2="2$",X=$P(S,U,2) D COMMA^%DTC W ?18,X S X=$P(S,U,3) D COMMA^%DTC W ?35,X S X=$P(S,U,2)-$P(S,U,3) D COMMA^%DTC W ?57,X I 1
 E  S X=$P(S,U,3) D COMMA^%DTC W ?27,X S X=$P(S,U,2)-$P(S,U,3) D COMMA^%DTC W ?50,X
B1 ;
 I $D(ACHSCNC) W !,"**** THE REGISTERS ARE OUT OF BALANCE!"  ;CANCEL FLAG
 D RTRN^ACHS                     ;PRESS RETURN TO CONT.
 I ACHSIO=IO&'$D(IO("S")) D END Q
 W @IOF
B2 ;
 U IO(0)
 X:$D(IO("S")) ACHSPPC  ;IF SLAVE CLOSE SALVE
 I $$DIR^XBDIR("Y","Do You Wish To Print Another Copy ","NO","","","",2) G A1
END ;
 I '$D(ZTQUEUED),ACHSIO=IO,'$D(IO("S")) D INITIALS^ACHSALUP(ACHSACFY)
HAT ;
 D EN^XBVK("ACHS"),^ACHSVAR
 K B,C,D,F,I,J,K,N,S,W,X,X2,X3,Y
 D ^%ZISC
 Q
 ;
SBD ;
 W !?1,$P(ACHSRGNM,U,K)
 I F S X=$P(B,U,K) D COMMA^%DTC W ?18,X S X=$P(W,U,K) D COMMA^%DTC W ?35,X S X=$P(B,U,K)-$P(W,U,K) D COMMA^%DTC W ?57,X I 1
 E  S X=$P(W,U,K) D COMMA^%DTC W ?27,X
 Q
 ;
SBH ;
 W !!!?12,"Fiscal Year  ",ACHSACFY,?44,"Register Number  ",$E(ACHSACFY,4),"-",$E(1000+ACHSACWK,2,4),!
 S ACHSACN=""
 I $D(^ACHS(9,DUZ(2),"FY",ACHSACFY,"C")) D
 .S ACHSACN=+^ACHS(9,DUZ(2),"FY",ACHSACFY,"C")
 .S ACHSACN=$E("00000",1,5-$L(ACHSACN))_ACHSACN
 .S ACHSACN=$E(ACHSACFY,4)_"-"_ACHSFC_"-"_ACHSACN
 W !,"Last document issued: ",ACHSACN,?44,"Advice of Allow: "
 S X=$S($D(^ACHS(9,DUZ(2),"FY",ACHSACFY,0))#2:$P($G(^ACHS(9,DUZ(2),"FY",ACHSACFY,0)),U,2),1:"") D COMMA^%DTC W ?63,X,!
 W !?1,"Register"
 I F W ?18,"Initial Balance",?35,"Obligated Amount",?57,"Current Balance"
 E  W ?26,"Obligated Amount"
 W !?1,"---------" I  W ?18,"---------------",?35,"----------------",?57,"----------------"
 E  W ?26,"----------------"
 Q
 ;
