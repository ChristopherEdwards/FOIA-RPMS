BARDRST1 ; IHS/SD/LSL - Statistical Report - Part 3 ; 07/30/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**10,15,19,20**;OCT 26, 2005
 ;
 ; TMM 11/13/09   1.8*15 Resolve HEAT 8548.  Error in BARDRST1.
 ; TMM 07/30/2010 1.8*19 Modify A/R Statistical Report to print
 ;                            in a printer or delimited file format.
 ;                            Allow user to select (Employer) Group Plans
 ;                            when selecting  by BILLING ENTITY/6)SELECT
 ;                            A SPECIFIC A/R ACCOUNT. See requirement
 ;                            4PMS10022.
 ; ********************************************************************
PRINT ;EP for writing data
 S BAR("PG")=0
 ;K BAR(1)  bar*1.8*20 HEAT27283
 ;start new code bar*1.8*20 HEAT27283
 I $D(BAR(1))<11 K BAR(1)
 I $D(BAR(1))>10 D
 .S BAR("L")=0
 .K BARTMP
 .F  S BAR("L")=$O(BAR(1,BAR("L"))) Q:'BAR("L")  M BARTMP(1,BAR("L"))=BAR(1,BAR("L"))
 .M BAR(1,"COVD")=BAR(1,"COVD")
 .K BAR(1)
 .M BAR(1)=BARTMP(1)
 .K BARTMP
 ;end new code HEAT27283
 K BAR(0)
 D HDB
 S BAR("L")=0
 S BAR("NLU")=0                ;MRS:BAR*1.8*10 H2260
 F BAR("NL")=1:1 S BAR("L")=$O(BAR(BAR("L"))) Q:'BAR("L")  D  G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-7) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .W !!,$P(^DIC(4,BAR("L"),0),U)
 .S (BAR("N"),BAR("B"),BAR("P"),BAR("A"),BAR("C"))=0
 .S UNDUP=0                       ;M1*TMM*11/13/2009 HEAT_8548
 .S BAR("V")=""
 .F  S BAR("V")=$O(BAR(BAR("L"),BAR("V"))) Q:'BAR("V")  D  G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ..I $Y>(IOSL-6) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !,$P(^DIC(4,BAR("L"),0),U)," (cont)"
 ..; ---BEGIN DEL(1)--->  ;M819*ADD*TMM*20100801-->replaced with ADD(1) section that follows
 ..; Replace current WRITE's with WRITE/DELIMITER dependent on BARTEXT value
 ..; ;Nest line prints visit type  ;M819*DEL*TMM*20100801
 ..; ..W !?2    ;M819*DEL*TMM*20100731
 ..; ..I BARY("SORT")="V" D   ;M819*DEL*TMM*20100801
 ..; ...I BAR("V")=99999 W "NO VISIT TYP" Q    ;M819*DEL*TMM*20100801
 ..; ...I $P($G(^ABMDVTYP(BAR("V"),0)),U)]"" W $E($P(^ABMDVTYP(BAR("V"),0),U),1,12) Q  ;M819*DEL*TMM*20100801
 ..; ...W "DELETED ",BAR("V")   ;M819*DEL*TMM*20100801
 ..; ..E  D   ;M819*DEL*TMM*20100801
 ..; ...I BAR("V")=99999 W "NO CLINIC" Q   ;M819*DEL*TMM*20100801
 ..; ...W $E($P(^DIC(40.7,BAR("V"),0),U),1,12)                 ;clinic stop name  ;M819*DEL*TMM*20100801
 ..; ..W ?16,$J($FN($P(BAR(BAR("L"),BAR("V")),U),",",0),5)     ;number of visits   ;M819*DEL*TMM*20100801
 ..; ..W ?22,$J($FN($P(BAR(BAR("L"),BAR("V")),U,2),",",0),5)   ;total undup patients   ;M819*DEL*TMM*20100801
 ..; ..S UNDUP=UNDUP+$P(BAR(BAR("L"),BAR("V")),U,2)    ;M1*TMM*11/13/2009 HEAT_8548   ;M819*DEL*TMM*20100801
 ..; ..;Next line writes $ with comma and cents   ;M819*DEL*TMM*20100801
 ..; ..W ?27,$J($FN($P(BAR(BAR("L"),BAR("V")),U,3),",",2),13)  ;total billed amount   ;M819*DEL*TMM*20100801
 ..; ..W ?41,$J($FN($P(BAR(BAR("L"),BAR("V")),U,4),",",2),12)  ;total paid amount   ;M819*DEL*TMM*20100801
 ..; ..W ?55,$J($FN($P(BAR(BAR("L"),BAR("V")),U,5),",",2),12)  ;total adjustment amount   ;M819*DEL*TMM*20100801
 ..; ..W ?66,$J($FN($P(BAR(BAR("L"),BAR("V")),U,6),",",2),13)  ;total unpaid amount   ;M819*DEL*TMM*20100801
 ..; -----END DEL(1)--->  ;M819*ADD*TMM*20100801-->replaced with ADD(1) section that follows
 ..; ---BEGIN ADD(1)--->  ;M819*ADD*TMM*20100801-->replaces DEL(1) section preceding this section
 ..; Next line prints visit type
 ..I $G(BARTEXT)'=1 W !?2
 ..I $G(BARTEXT)=1 W !,"^"
 ..I BARY("SORT")="V" D
 ...I BAR("V")=99999 W "NO VISIT TYP"_$$TEXTCK^BARDRST() Q     ;(B)
 ...I $P($G(^ABMDVTYP(BAR("V"),0)),U)]"" W $E($P(^ABMDVTYP(BAR("V"),0),U),1,12)_$$TEXTCK^BARDRST() Q   ;(B)
 ...W "DELETED ",BAR("V")_$$TEXTCK^BARDRST()                        ;(B)
 ..E  D
 ...I BAR("V")=99999 W "NO CLINIC"_$$TEXTCK^BARDRST() Q                       ;(B)
 ...W $E($P(^DIC(40.7,BAR("V"),0),U),1,12)_$$TEXTCK^BARDRST()    ;clinic stop name (B)
 ..I $E(BARTEXT)'=1 D
 ...W ?16,$J($FN($P(BAR(BAR("L"),BAR("V")),U),",",0),5)     ;number of visits
 ...W ?22,$J($FN($P(BAR(BAR("L"),BAR("V")),U,2),",",0),5)   ;total undup patients
 ..I $E(BARTEXT)=1 D
 ...W $J($FN($P(BAR(BAR("L"),BAR("V")),U),",",0),5)_"^"     ;number of visits (C)
 ...W $J($FN($P(BAR(BAR("L"),BAR("V")),U,2),",",0),5)_"^"   ;total undup patients (D)
 ..S UNDUP=UNDUP+$P(BAR(BAR("L"),BAR("V")),U,2)    ;M1*TMM*11/13/2009 HEAT_8548
 ..; Next line writes $ with comma and cents
 ..I $E(BARTEXT)'=1 D
 ...W ?27,$J($FN($P(BAR(BAR("L"),BAR("V")),U,3),",",2),13)  ;total billed amount
 ...W ?41,$J($FN($P(BAR(BAR("L"),BAR("V")),U,4),",",2),12)  ;total paid amount
 ...W ?55,$J($FN($P(BAR(BAR("L"),BAR("V")),U,5),",",2),12)  ;total adjustment amount
 ...W ?66,$J($FN($P(BAR(BAR("L"),BAR("V")),U,6),",",2),13)  ;total unpaid amount
 ..I $E(BARTEXT)=1 D
 ...W $J($FN($P(BAR(BAR("L"),BAR("V")),U,3),",",2),13)_"^"  ;total billed amount (E)
 ...W $J($FN($P(BAR(BAR("L"),BAR("V")),U,4),",",2),12)_"^"  ;total paid amount (F)
 ...W $J($FN($P(BAR(BAR("L"),BAR("V")),U,5),",",2),12)_"^"  ;total adjustment amount (G)
 ...W $J($FN($P(BAR(BAR("L"),BAR("V")),U,6),",",2),13)_"^"  ;total unpaid amount (H)
 ..; -----END ADD(1)--->  ;M819*ADD*TMM*20100801-->replaces DEL section preceding this section
 ..S BAR("N")=$P(BAR(BAR("L"),BAR("V")),U,1)+BAR("N")
 ..S BAR("NLN")=BAR("NLN")+$P(BAR(BAR("L"),BAR("V")),U,1)
 ..S BAR("B")=$P(BAR(BAR("L"),BAR("V")),U,3)+BAR("B")
 ..S BAR("NLB")=BAR("NLB")+$P(BAR(BAR("L"),BAR("V")),U,3)
 ..S BAR("P")=$P(BAR(BAR("L"),BAR("V")),U,4)+BAR("P")
 ..S BAR("NLP")=BAR("NLP")+$P(BAR(BAR("L"),BAR("V")),U,4)
 ..S BAR("A")=$P(BAR(BAR("L"),BAR("V")),U,5)+BAR("A")
 ..S BAR("NLA")=BAR("NLA")+$P(BAR(BAR("L"),BAR("V")),U,5)
 ..S BAR("C")=$P(BAR(BAR("L"),BAR("V")),U,6)+BAR("C")
 ..;S BAR("NLC")=BAR("NLC")+$P(BAR(BAR("L"),BAR("V")),U,6)  ;MRS:BAR*1.8*10 H2260
 ..S BAR("NLU")=BAR("NLU")+$P(BAR(BAR("L"),BAR("V")),U,6)   ;MRS:BAR*1.8*10 H2260
 .;---BEGIN DEL(2)--->  ;M819*ADD*TMM*20100801-->replaced with ADD(2) section that follows
 .; .W !,?15,"------",?22,"------",?30,"----------",?43,"----------",?57,"----------",?70,"----------"
 .; .W !?16,$J($FN(BAR("N"),",",0),5)
 .; .;W ?22,$J($FN(BAR("LC",BAR("L")),",",0),5)         ;M1*TMM*11/13/2009 HEAT_8548
 .; .W ?22,$J($FN(UNDUP,",",0),5)                       ;M1*TMM*11/13/2009 HEAT_8548
 .; .W ?28,$J($FN(BAR("B"),",",2),12)
 .; .W ?40,$J($FN(BAR("P"),",",2),13)
 .; .W ?55,$J($FN(BAR("A"),",",2),12)
 .; .W ?67,$J($FN(BAR("C"),",",2),13)
 .; .;PRINT INPATIENT DAYS - WILL PRINT 0 DAYS ALSO         
 .; .W !!
 .; .W "TOTAL COVERED INPATIENT DAYS  ",+$GET(BAR(BAR("L"),"COVD"))
 .; .W !
 .; W !,?10,"END OF REPORT",!
 .; -----END DEL(2)--->  ;M819*ADD*TMM*20100801-->replaced with ADD(2) section that follows
 .; ---BEGIN ADD(2)--->  ;M819*ADD*TMM*20100801-->replaces DEL(2) section preceding this section
 .; Printer format
 .I $G(BARTEXT)'=1 D
 ..W !,?15,"------",?22,"------",?30,"----------",?43,"----------",?57,"----------",?70,"----------"
 ..W !?16,$J($FN(BAR("N"),",",0),5)
 ..;W ?22,$J($FN(BAR("LC",BAR("L")),",",0),5)         ;M1*TMM*11/13/2009 HEAT_8548
 ..W ?22,$J($FN(UNDUP,",",0),5)                       ;M1*TMM*11/13/2009 HEAT_8548
 ..W ?28,$J($FN(BAR("B"),",",2),12)
 ..W ?40,$J($FN(BAR("P"),",",2),13)
 ..W ?55,$J($FN(BAR("A"),",",2),12)
 ..W ?67,$J($FN(BAR("C"),",",2),13)
 .; Delimited file format
 .I $G(BARTEXT)=1 D
 ..W !,"^^------^------^----------^----------^----------^----------"
 ..W !,"^^",$J($FN(BAR("N"),",",0),5)             ;(C)
 ..;W "^^",$J($FN(BAR("LC",BAR("L")),",",0),5)         ;M1*TMM*11/13/2009 HEAT_8548
 ..W "^",$J($FN(UNDUP,",",0),5)                   ;(D)  M1*TMM*11/13/2009 HEAT_8548
 ..W "^",$J($FN(BAR("B"),",",2),12)               ;(E)
 ..W "^",$J($FN(BAR("P"),",",2),13)               ;(F)
 ..W "^",$J($FN(BAR("A"),",",2),12)               ;(G)
 ..W "^",$J($FN(BAR("C"),",",2),13)               ;(H)
 ..;PRINT INPATIENT DAYS - WILL PRINT 0 DAYS ALSO         
 .W !!
 .I $G(BARTEXT)'=1 W "TOTAL COVERED INPATIENT DAYS ",+$GET(BAR(BAR("L"),"COVD"))
 .I $G(BARTEXT)=1 W "^TOTAL COVERED INPATIENT DAYS^",+$GET(BAR(BAR("L"),"COVD"))
 .W !
 .W !,"END OF REPORT",!
 .; -----END ADD(2)--->  ;M819*ADD*TMM*20100801-->replaces DEL(2) section preceding this section
 ;
 I $E(IOST)="C",'$D(IO("S")) D
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 .K DIR
 I BAR("NL")<3 G XIT
 ; ---BEGIN DEL(3)--->  ;M819*DEL*TMM*20100801 replaced with ADD(3) section that follows
 W !,?17,"======",?25,"======",?29,"==========",?42,"==========",?67,"=========="
 ;TOOK OUT TOTAL UNDUP CNT 2/98 SL
 W !?10,"Total:",?20,$J($FN(BAR("NLN"),",",0),5)
 W ?29,$J($FN(BAR("NLB"),",",2),13)
 W ?41,$J($FN(BAR("NLP"),",",2),13)
 W ?55,$J($FN(BAR("NLA"),",",2),12)
 ;W ?67,$J($FN(BAR("NLC"),",",2),13) ;MRS:BAR*1.8*10 H2260
 W ?67,$J($FN(BAR("NLU"),",",2),13)  ;MRS:BAR*1.8*10 H2260
 ; -----END DEL(3)--->  ;M819*DEL*TMM*20100801 replaced with ADD(3) section that follows
 ; ---BEGIN DEL(3)--->  ;M819*DEL*TMM*20100801 replaced with ADD(3) section that follows
 ; Printer format
 I $G(BARTEXT)'=1 D
 . W !,?17,"======",?25,"======",?29,"==========",?42,"==========",?67,"=========="
 . ;TOOK OUT TOTAL UNDUP CNT 2/98 SL
 . W !?10,"Total:",?20,$J($FN(BAR("NLN"),",",0),5)
 . W ?29,$J($FN(BAR("NLB"),",",2),13)
 . W ?41,$J($FN(BAR("NLP"),",",2),13)
 . W ?55,$J($FN(BAR("NLA"),",",2),12)
 . ;W ?67,$J($FN(BAR("NLC"),",",2),13) ;MRS:BAR*1.8*10 H2260
 . W ?67,$J($FN(BAR("NLU"),",",2),13)  ;MRS:BAR*1.8*10 H2260
 ; Delimited file format
 I $G(BARTEXT)=1 D
 . W !,"^======^======^==========^==========^=========="
 . ;TOOK OUT TOTAL UNDUP CNT 2/98 SL
 . W !,"^^Total:^",$J($FN(BAR("NLN"),",",0),5)
 . W "^",$J($FN(BAR("NLB"),",",2),13)
 . W "^",$J($FN(BAR("NLP"),",",2),13)
 . W "^",$J($FN(BAR("NLA"),",",2),12)
 . ;W ?67,$J($FN(BAR("NLC"),",",2),13) ;MRS:BAR*1.8*10 H2260
 . W "^",$J($FN(BAR("NLU"),",",2),13)  ;MRS:BAR*1.8*10 H2260
 ; -----END DEL(3)--->  ;M819*DEL*TMM*20100801 replaced with ADD(3) section that follows
 G XIT
 ; *********************************************************************
HD ;
 D PAZ^BARRUTL
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;
HDB ;
 S BAR("PG")=BAR("PG")+1
 S BAR("I")=""
 D WHD^BARRHD
 ; ---BEGIN DEL(1)--->  ;M819*ADD*TMM*20100731--> replaced by ADD(1) section that follows
 ;W !!?2,$S(BARY("SORT")="V":"VISIT",1:"")                                               ;M819*DEL*TMM*20100731
 ;W ?15,"NUMBER",?22,"UNDUP",?35,"BILLED",?48,"PAID",?60,"ADJ",?74,"UNPAID"              ;M819*DEL*TMM*20100731
 ;W !?2,$S(BARY("SORT")="V":"TYPE",1:"CLINIC")                                           ;M819*DEL*TMM*20100731
 ;W ?15,"VISITS",?22,"PATIENTS",?35,"AMOUNT",?48,"AMOUNT",?60,"AMOUNT",?74,"AMOUNT"      ;M819*DEL*TMM*20100731
 ;W !,"-------------------------------------------------------------------------------"  ;M819*DEL*TMM*20100731
 ; -----END DEL(1)--->  ;M819*ADD*TMM*20100731--> replaced by ADD(1) section that follows
 ; ---BEGIN ADD(1)--->  ;M819*ADD*TMM*20100731--> replaces DEL(1) section that preceds this
 I $G(BARTEXT)'=1 D
 .W !!?2,$S(BARY("SORT")="V":"VISIT",1:"")    ;M819*DEL*TMM*20100731
 .W ?15,"NUMBER",?22,"UNDUP",?35,"BILLED",?48,"PAID",?60,"ADJ",?74,"UNPAID"
 .W !?2,$S(BARY("SORT")="V":"TYPE",1:"CLINIC")    ;M819*DEL*TMM*20100731
 .W ?15,"VISITS",?22,"PATIENTS",?35,"AMOUNT",?48,"AMOUNT",?60,"AMOUNT",?74,"AMOUNT"
 .S $P(BARTMPLN,"-",80)=""
 .W !,BARTMPLN
 I $G(BARTEXT)=1 D
 .W !!,U,$S(BARY("SORT")="V":"VISIT",1:"")
 .W U,"NUMBER",U,"UNDUP",U,"BILLED",U,"PAID",U,"ADJ",U,"UNPAID"
 .W !,U,$S(BARY("SORT")="V":"TYPE",1:"CLINIC")
 .W U,"VISITS",U,"PATIENTS",U,"AMOUNT",U,"AMOUNT",U,"AMOUNT",U,"AMOUNT"
 .S $P(BARTMPLN,"-",80)=""
 .W !,"^",BARTMPLN
 ; -----END ADD(1)--->  ;M819*ADD*TMM*20100731--> replaces DEL(1) section that preceds thisQ
 ; *********************************************************************
XIT ;
 K ^TMP($J,"BAR-ST")
 Q
