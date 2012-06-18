ABMUITIN ; IHS/SD/SDR - 3PB/UFMS TIN report   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
EP ;EP
 K ABMTCNT,ABML,ABMCNT,ABM
 K DIR
 S DIR(0)="S^1:Insurers with TIN;2:Insurers without TIN;3:Both"
 S DIR("A")="Which insurers would you like to see"
 D ^DIR K DIR
 G:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT) XIT
 S ABMWINS=Y
 ;
 S DIR(0)="S^B:Billing Address;M:Mailing Address"
 S DIR("A")="Which address would you like to see on the report"
 D ^DIR K DIR
 G:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT) XIT
 S ABMADD=Y
 ;
 ;this next part will ask for a time frame.  This will be used to go
 ;through claims for that many years and find the active insurers on them
 ;and they will be the only insurers to print on report.
 W !!
 S X1=DT
 S X2=-1825
 D C^%DTC
 S ABMTIME=X
 S X1=DT
 S X2=-365
 D C^%DTC
 S ABMDFLT=X
 K DIR
 S DIR(0)="D^"_ABMTIME_":DT:X"
 S DIR("A",1)="This report prints insurers that have been billed back to a user-selected date."
 S DIR("A")="Please select date for report"
 S DIR("B")=$$SDT^ABMDUTL(ABMDFLT)
 D ^DIR K DIR
 G:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT) XIT
 S ABMTIME=Y
 ;
 W !!!
HD I ABMWINS=1 S ABM("HD",0)="Insurers with TIN"
 I ABMWINS=2 S ABM("HD",0)="Insurers without TIN"
 I ABMWINS=3 S ABM("HD",0)="Insurers with and without TIN"
 S ABM("PG")=1
 S ABMY("LOC")=DUZ(2)
 S ABM("LVL")=0
 S ABM("CONJ")=""
 S ABM("TXT")=""
 S ABMQ("RX")="XIT^ABMUITIN"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="LOOP^ABMUITIN"
 D ^ABMDRDBQ
 Q
LOOP ;create list of insurers to print
 ;
 S ABMDTLP=ABMTIME-.5
 F  S ABMDTLP=$O(^ABMDBILL(DUZ(2),"AP",ABMDTLP)) Q:+ABMDTLP=0  D
 .S ABMBDFN=0
 .F  S ABMBDFN=$O(^ABMDBILL(DUZ(2),"AP",ABMDTLP,ABMBDFN)) Q:+ABMBDFN=0  D
 ..I $P($G(^ABMDBILL(DUZ(2),ABMBDFN,0)),U,8)'="" D
 ...S ABMAINS=$P($G(^ABMDBILL(DUZ(2),ABMBDFN,0)),U,8)
 ...S ABMITYP=$P($G(^AUTNINS(ABMAINS,2)),U)
 ...S ABMINAM=$P($G(^AUTNINS(ABMAINS,0)),U)
 ...Q:ABMITYP="N"!(ABMITYP="I")  ;don't check Ben or Non-Ben
 ...I $G(ABM(ABMAINS))="" S ABMTCNT=+$G(ABMTCNT)+1,ABM(ABMAINS)=1
 ...I ABMWINS=2,($P($G(^AUTNINS(ABMAINS,0)),U,11)'="") Q
 ...I ABMWINS=1,($P($G(^AUTNINS(ABMAINS,0)),U,11)="") Q
 ...S ABMITYP=$P($G(^AUTNINS(ABMAINS,2)),U)
 ...S ABMINAM=$P($G(^AUTNINS(ABMAINS,0)),U)
 ...S ABML(ABMITYP,ABMINAM,ABMAINS)=""
 D PRINT
 Q
PRINT ; print insurers
 D WHD^ABMDRHD G XIT:'$D(IO)!$G(POP)!$D(DTOUT)!$D(DUOUT)
 W !,"INSURER (IEN)",?35,"TIN"
 W !?5,"Address",?37,"City",?53,"ST",?56,"Zip",?67,"Phone"
 W !
 F ABMI=1:1:80 W "-"
 S ABMITYP=0
 F  S ABMITYP=$O(ABML(ABMITYP)) Q:ABMITYP=""  D
 .W !!?3,$P($T(@ABMITYP^ABMUCASH),";;",2)
 .S ABMINAM=""
 .F  S ABMINAM=$O(ABML(ABMITYP,ABMINAM)) Q:ABMINAM=""  D
 ..S ABMI=0
 ..F  S ABMI=$O(ABML(ABMITYP,ABMINAM,ABMI)) Q:+ABMI=0  D
 ...W !,ABMINAM,"(",ABMI,")"
 ...D GETS^DIQ("9999999.18",ABMI,".01;.02;.03;.04;.05;.06;.11;2;3;4;5","IE","ABMC")
 ...S ABMTIN=$G(ABMC("9999999.18",ABMI_",",".11","E"))
 ...W ?35,ABMTIN
 ...W !?5
 ...I ABMADD="M" D
 ....W $G(ABMC("9999999.18",ABMI_",",".02","E"))
 ....W ?37,$G(ABMC("9999999.18",ABMI_",",".03","E"))
 ....W:$G(ABMC("9999999.18",ABMI_",",".04","I"))'="" ?53,$P($G(^DIC(5,$G(ABMC("9999999.18",ABMI_",",".04","I")),0)),U,2)
 ....W ?56,$G(ABMC("9999999.18",ABMI_",",".05","E"))
 ...I ABMADD="B" D
 ....W $G(ABMC("9999999.18",ABMI_",","2","E"))
 ....W ?37,$G(ABMC("9999999.18",ABMI_",","3","E"))
 ....W:$G(ABMC("9999999.18",ABMI_",","4","I"))'="" ?53,$P($G(^DIC(5,$G(ABMC("9999999.18",ABMI_",","4","I")),0)),U,2)
 ....W ?56,$P($G(ABMC("9999999.18",ABMI_",","5","E")),"-")
 ...W ?67,$G(ABMC("9999999.18",ABMI_",",".06","E"))
 ...S ABMCNT=+$G(ABMCNT)+1
 ...I $Y>(IOSL-5) D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)  S ABM("PG")=+$G(ABM("PG"))+1 D WHD^ABMDRHD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " (cont)"
 I +$G(ABMCNT)>0 D
 .W !!?35,"TOTAL INSURERS WITH"_$S(ABMWINS=2:"OUT",ABMWINS=3:" AND WITHOUT",1:"")_" TIN:  ",ABMCNT
 .W !!?35,"TOTAL INSURER COUNT:  ",ABMTCNT
 Q
XIT ;
 K ABMWINS,DIC,DIE,X,Y,DA,ABMC,ABMI,ABMTIME
 K ABML,ABM,ABMCNT,ABMTCNT
 Q
