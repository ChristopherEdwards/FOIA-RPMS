ABMUPTIN ; IHS/SD/SDR - 3PB/UFMS Pseudo TIN report   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; New routine - v2.5 p12 SDD item 4.9.3.1
 ;
EP ;
 S DIR(0)="S^B:Billing Address;M:Mailing Address"
 S DIR("A")="Which address would you like to see on the report"
 D ^DIR
 G:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT) XIT
 S ABMADD=Y
 S ABM("HD",0)="===== INSURER LISTING WITH PSEUDO TINS ====="
 S ABMY("LOC")=DUZ(2)
 S ABM("LVL")=0
 S ABM("CONJ")=""
 S ABM("TXT")=""
 S ABM("PG")=1
 D LOC^ABMDRHD G XIT:'$D(IO)!$G(POP)!$D(DTOUT)!$D(DUOUT)
 S ABMQ("RX")="XIT^ABMUPTIN"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="COMPUTE^ABMUPTIN"
 D ^ABMDRDBQ
 Q
COMPUTE ;
 K DIC,DIE,X,Y,DA,ABMC,ABMI,ABMCNT
 S ABMI=0
 D WHD^ABMDRHD
 W !,?2,"INSURER",?35,$S(ABMADD="B":"BILLING",1:"MAILING")_" ADDRESS",?70,"TIN"
 W !?5,"Address",?37,"City",?53,"ST",?56,"Zip",?67,"Phone"
 W !
 F ABMI=1:1:80 W "-"
 S ABMI=0
 F  S ABMI=$O(^AUTNINS(ABMI)) Q:+ABMI=0  D
 .K ABMC
 .D GETS^DIQ("9999999.18",ABMI,".01;.02;.03;.04;.05;.06;.11;2;3;4;5","IE","ABMC")
 .S ABMTIN=$G(ABMC("9999999.18",ABMI_",",".11","E"))
 .Q:$A($E(ABMTIN,9))<65!($A($E(ABMTIN,9))>91)
 .W !?2,$E($G(ABMC("9999999.18",ABMI_",",".01","E")),1,30)
 .W ?70,$G(ABMC("9999999.18",ABMI_",",".11","E"))
 .W !
 .I ABMADD="M" D
 ..W ?5,$G(ABMC("9999999.18",ABMI_",",".02","E"))
 ..W ?37,$G(ABMC("9999999.18",ABMI_",",".03","E"))
 ..W ?53,$P($G(^DIC(5,$G(ABMC("9999999.18",ABMI_",",".04","I")),0)),U,2)
 ..W ?56,$G(ABMC("9999999.18",ABMI_",",".05","E"))
 ..W ?67,$G(ABMC("9999999.18",ABMI_",",".06","E"))
 .I ABMADD="B" D
 ..W ?5,$G(ABMC("9999999.18",ABMI_",","2","E"))
 ..W ?37,$G(ABMC("9999999.18",ABMI_",","3","E"))
 ..I $G(ABMC("9999999.18",ABMI_",","4","I"))'="" W ?53,$P($G(^DIC(5,$G(ABMC("9999999.18",ABMI_",","4","I")),0)),U,2)
 ..W ?56,$P($G(ABMC("9999999.18",ABMI_",","5","E")),"-")
 ..W ?67,$G(ABMC("9999999.18",ABMI_",",".06","E"))
 .S ABMCNT=+$G(ABMCNT)+1
 I +$G(ABMCNT)>0 D
 .W !!?40,"TOTAL INSURERS WITH PSEUDO TIN:  ",ABMCNT
 Q
XIT ;
 K ABMC,ABMADD,ABMI,ABMTIN
 Q
