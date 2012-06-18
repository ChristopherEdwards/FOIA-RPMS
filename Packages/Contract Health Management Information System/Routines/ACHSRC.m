ACHSRC ; IHS/ITSC/PMF - COUNT DOCUMENTS TO BE PRINTED ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; C = Count
 ; S = System Totals
 ; T = Type
 ;
 N C,T
 ;
 S (ACHS(1),ACHS(2),ACHS(3),ACHS("DUZ2"))=0
A1 ;
 S ACHS("DUZ2")=$O(^ACHSF("PQ",ACHS("DUZ2")))
 G B1:'ACHS("DUZ2")
 I '$D(^AUTTLOC(ACHS("DUZ2"),0)) K ^ACHSF("PQ",ACHS("DUZ2")) G A1
 W !!,$P($G(^DIC(4,ACHS("DUZ2"),0)),U)
 S S=0
 F T=1,3,2 S C=0 D SBC W !
 W ?50,"-----",!?32,"Total",?50,$J(S,4)
 I $$DIR^XBDIR("E","Press RETURN...")
 G A1
 ;
B1 ;
 S S=0
 W !!,"SYSTEM TOTALS"
 F ACHS=1,3,2 W:ACHS>1 ! W ?32,$S(ACHS=1:"Hospital",ACHS=3:"Outpatient",ACHS=2:"Dental",1:"")," Service",?50,$J(ACHS(ACHS),4) S S=S+ACHS(ACHS)
 W !?50,"-----",!?32,"Total",?50,$J(S,4)
END ;
 I $$DIR^XBDIR("E")
 K ACHS,C,S,T
 Q
 ;
SBC ;
 F ACHSDIEN=0:0 S ACHSDIEN=$O(^ACHSF("PQ",ACHS("DUZ2"),T,ACHSDIEN)) Q:'ACHSDIEN  F ACHSTIEN=0:0 S ACHSTIEN=$O(^ACHSF("PQ",ACHS("DUZ2"),T,ACHSDIEN,ACHSTIEN)) Q:'ACHSTIEN  S C=C+1
 W ?32,$S(T=1:"Hospital",T=3:"Outpatient",T=2:"Dental",1:"")," Service",?50,$J(C,4)
 S ACHS(T)=ACHS(T)+C,S=S+C
 Q
 ;
