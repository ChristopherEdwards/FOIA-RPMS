ABMDE8DA ; IHS/ASDST/DMJ - PAGE 8D - MED VIEW OPTION ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S ABMZ("PG")="8D"
 S ABMZ("TITL")="MEDICATION VIEW OPTION" D SUM^ABMDE1
 S ABMA("C")=0,ABMA("D")="",$P(ABMA("D"),"-",80)=""
 D HD
 S ABMA("OUT")=0,ABMA=ABMP("VDT")-1 F  S ABMA=$O(^PSRX("AD",ABMA)) Q:'ABMA  D  Q:ABMA("OUT")
 .Q:ABMA<ABMP("VDT")
 .I $D(ABMP("DDT")),ABMA>ABMP("DDT") S ABMA("OUT")=1 Q
 .I '$D(ABMP("DDT")),ABMA>ABMP("VDT") S ABMA("OUT")=1 Q
 .S ABMA("R")=0 F  S ABMA("R")=$O(^PSRX("AD",ABMA,ABMA("R"))) Q:'ABMA("R")  Q:'$D(^PSRX(ABMA("R"),0))  I $P(^(0),U,2)=ABMP("PDFN") S ABMA(0)=^(0),ABMA(2)=^(2) D V1 Q:$D(DTOUT)!$D(DUOUT)
 I ABMA("C")=0 W *7,!,"There have been no Drugs issued through the Pharmacy System to this Patient",!,"for the visit date(s) in concern."
 D ^ABMDERR
 G XIT
 ;
V1 S ABMA("C")=ABMA("C")+1
 I $Y+5>IOSL K DIR S DIR(0)="E" D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)  W $$EN^ABMVDF("IOF") D HD
 W !,$P(ABMA(0),U),?8,$S($D(^PSDRUG(+$P(ABMA(0),U,6),0)):$P(^(0),U),1:"NOT ON FILE"),?43,$J($P(ABMA(0),U,7),6)
 S ABMA("DT")=$P(ABMA(2),U,2) S:'+ABMA("DT") ABMA("DT")=$P(ABMA(0),U,13)
 S ABMA("F")=$P(ABMA(0),U,9),ABMA("I")=0
 F  S ABMA("I")=$O(^PSRX(ABMA("R"),1,ABMA("I"))) Q:'ABMA("I")  S:^(ABMA("I"),0)>ABMA("DT") ABMA("DT")=+^(0) S ABMA("F")=ABMA("F")-1
 W ?53,$$HDT^ABMDUTL($P(ABMA(0),U,13))
 W:ABMA("DT") ?63,$$HDT^ABMDUTL(ABMA("DT")) W ?74,"(",ABMA("F"),")"
 W !?10,"NDC#: ",$P($G(^PSDRUG($P(ABMA(0),U,6),2)),U,4)
 S DIC="^PSRX(",DR=12,DIQ="ABMA(",DIQ(0)="E" D
 .N DA S DA=ABMA("R")
 .D EN^DIQ1 K DIQ Q:ABMA(52,DA,12,"E")=""
 .W !,?10,"Comments: ",ABMA(52,DA,12,"E")
 Q
 ;
HD W !?10,"***** MEDICATIONS ENTERED THROUGH THE PHARMACY SYSTEM *****"
 W !!,"Rx#     Drug",?46,"Qty",?53,"Issued ",?63,"Last Fill  Rem"
 W !,ABMA("D")
 Q
 ;
XIT K ABMA,DUOUT,DTOUT
 Q
