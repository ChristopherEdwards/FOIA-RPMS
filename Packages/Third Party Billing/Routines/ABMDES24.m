ABMDES24 ; IHS/ASDST/DMJ - Display Summarized NCPDP charges ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM21581
 ;   Added active insurer print to summary
 ;
HCFA ;EP for displaying charge summary for HCFA-1500
 ;
 D HD
 S ABMP("TOT")=0
 S ABMS=0 F  S ABMS=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMS)) Q:'ABMS  D
 .S ABMRX0=^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMS,0)
 .S ABMDRUG=$P(ABMRX0,U)
 .S ABMDESC=$P(^PSDRUG(ABMDRUG,0),U)
 .S ABMCDATE=$P(ABMRX0,"^",14)
 .S ABMITOT=$P(ABMRX0,"^",3)*$P(ABMRX0,"^",4)
 .S ABMDTOT=$P(ABMRX0,"^",5)
 .S ABMSTOT=ABMITOT+ABMDTOT
 .S ABMSTOT=$J(ABMSTOT,1,2)
 .S ABMP("TOT")=ABMP("TOT")+ABMSTOT
 .I $Y>(IOSL-5) D
 ..S DIR(0)="EO"
 ..D ^DIR
 ..W $$EN^ABMVDF("IOF")
 ..Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 ..D HD
 .W !," ",$$HDT^ABMDUTL(ABMCDATE)
 .W ?15,ABMDESC
 .W ?46,$J(ABMDTOT,5,2)
 .W ?53,$J($P(ABMRX0,"^",3),4)
 .W ?60,$J($P(ABMRX0,"^",4),5,3)
 .W ?66,$J(ABMSTOT,10,2)
 W !?66,"----------"
 S ABMP("EXP",24)=ABMP("TOT")
 W !,?10,"TOTAL CHARGE",?66,$J($FN(ABMP("TOT"),",",2),10)
 F  W ! Q:$Y+4>IOSL
 S DIR(0)="E" D ^DIR K DIR
 Q
 ;
HD ;SCREEN HEADER
 W $$EN^ABMVDF("IOF")
 W !,?20,"***** "
 W $P(^ABMDEXP(ABMP("EXP"),0),U)
 W " CHARGE SUMMARY *****"
 W !!,"Active Insurer: ",$P($G(^AUTNINS(ABMP("INS"),0)),U),!
 W !,?47,"Disp",?60,"Unit"
 W !?1,"Charge Date  ",?19,"Description",?47,"Fee",?54,"Qty",?60,"Price",?71,"Total"
 S $P(ABMS("I"),"-",80)="" W !,ABMS("I")
 Q
