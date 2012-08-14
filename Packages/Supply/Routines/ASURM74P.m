ASURM74P ; IHS/ITSC/LMH -ISS ANAL BY LOC ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;prints report 74, Stock Issues/Budget ;Analysis by Location Report.
EN ;EP;PRIME
 Q  ;WAR 5/21/99
 D:'$D(IO) HOME^%ZIS I '$D(DUZ(2)) W !,"Run from Kernel only" Q
 I '$D(ASUL(1,"AR","AP")) D SETAREA^ASULARST
 S ASUK("PTRSEL")=$G(ASUK("PTRSEL")) I ASUK("PTRSEL")]"" G PSER
 S ZTRTN="PSER^ASURM74P",ZTDESC="SAMS RPT 74" D O^ASUUZIS
 I POP S IOP=$I D ^%ZIS Q
 I ASUK(ASUK("PTR"),"Q") Q
PSER ;EP;TMQ
 S ASUF("HDR")=1,X=$O(^XTMP("ASUR","R74","")),ASUF("RPT75")=+$G(ASUF("RPT75"))
 I ASUF("RPT75") K ^XTMP("ASUR","R75") S ^XTMP("ASUR","R75",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 D U^ASUUZIS S ASUV("TOT")="""TOT""" D P1 G:'$D(^XTMP("ASUR","R74")) END
 S (ASUV("DT","FM"),Y)=$P(^XTMP("ASUR","R74",0),U,2) X ^DD("DD") S ASUV("DT")=Y,ASUC("PG")=0,ASUC("LN")=0
 S ASUX("SST")=0 F  S ASUX("SST")=$O(^XTMP("ASUR","R74",ASUX("SST"))) Q:ASUX("SST")=""  D  Q:$D(DUOUT)
 .S ASUA("SST")=$P(^XTMP("ASUR","R74",ASUX("SST")),U,3)
 .S ASUX("SSA")="" F  S ASUX("SSA")=$O(^XTMP("ASUR","R74",ASUX("SST"),ASUX("SSA"))) Q:ASUX("SSA")=""  Q:$D(DTOUT)  Q:$D(DUOUT)  D  Q:$D(DUOUT)
 ..S ASUA("SSA")=$P(^XTMP("ASUR","R74",ASUX("SST"),ASUX("SSA")),U,3)
 ..S ASUX("ACC")="",ASUF("SSA")=1
 ..F  S ASUX("ACC")=$O(^XTMP("ASUR","R74",ASUX("SST"),ASUX("SSA"),ASUX("ACC"))) Q:ASUX("ACC")=""  Q:$D(DTOUT)  Q:$D(DUOUT)  D  Q:$D(DUOUT)
 ...S ASUA=^XTMP("ASUR","R74",ASUX("SST"),ASUX("SSA"),ASUX("ACC"))
 ...D ACC^ASULDIRF(ASUX("ACC"))
 ...I ASUF("HDR")>0 D HEADER Q:$D(DUOUT)
 ...S ASUA("B")=$P(ASUA,U,2),ASUA("J")=$P(ASUA,U,3),ASUA("G")=ASUA("B")+ASUA("J"),ASUA("L")=$P(ASUA,U,4)
 ...S ASUA("M")=$P(ASUA,U,5),ASUA("Y")=$P(ASUA,U,6),ASUA("N")=$P(ASUA,U,7),ASUA("BAL")=ASUA("L")-(ASUA("Y")+ASUA("N"))
 ...S ASUA("V")=$E(ASUV("DT","FM"),4,5)+3 S:ASUA("V")>12 ASUA("V")=ASUA("V")-12
 ...S ASUA("P")=$FN(ASUA("G")-(((ASUA("Y")/ASUA("V"))*12)+ASUA("N")),"",2)
 ...S ASUA2=ASUA,$P(ASUA2,U)=ASUA("SST")
 ...I 'ASUF("RPT75") S:ASUF("SSA") ASUF("SSA")=0
 ...E  D
 ....I ASUF("SSA") S ^XTMP("ASUR","R75",ASUX("SSA"))=ASUA("SSA"),ASUF("SSA")=0
 ....S ^XTMP("ASUR","R75",ASUX("SSA"),ASUX("ACC"))=ASUL(9,"ACC","NM")
 ....S ^XTMP("ASUR","R75",ASUX("SSA"),ASUX("ACC"),ASUX("SST"))=ASUA2
 ...S ASUC("LN")=ASUC("LN")+3 W !!," ACC ",ASUX("ACC") S ASUF("TOT")=0 D PRLINE
 ...W !," ",ASUL(9,"ACC","NM")
 ..Q:$D(DTOUT)  Q:$D(DUOUT)  S ASUF("HDR")=1,ASUF("TOT")=1 D PRTOTLL
 .Q:$D(DTOUT)  Q:$D(DUOUT)  S ASUF("HDR")=1,ASUF("TOT")=2 D PRTOTL S ASUF("HDR")=1
 .I ASUA("SST")="" S ASUV("SST")=ASUX("SST") D HEADER Q:$D(DUOUT)
 I $D(DUOUT)!($D(DTOUT)) G END
 S ASUF("TOT")=3 D PRTOTL
END ;
 D PAZ^ASUURHDR I ASUK("PTRSEL")']"" D
 .D C^ASUUZIS K ASUW
 K ASUV,ASUF,ASUX,ASUF,ASUC,ASUA2,ASUT,ASURZ,ASURZA,ASURZW,ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTUCI,DFOUT,DLOUT,DTOUT,DUOUT,X,X2,X3,Y
 Q
P1 ;
 F ASUU(11)=1:1:9 S ASUT=$P($T(CN+ASUU(11)),";",3) D
 .F ASUU(12)=1:1:4 S ASURZ="ASUA("_ASUV("TOT")_","_ASUU(12)_","_ASUT_")",@ASURZ=0
 Q
PRTOTLL ;EP;TOT
 S ASUC("LN")=ASUC("LN")+1 W ! F ASUU(14)=1:1:9 S X=(ASUU(14)*12)+7 W ?X," -----------"
PRTOTL ;EP;TOT2
 S ASUC("LN")=ASUC("LN")+2 W !,$P($T(TN+ASUF("TOT")),";",3) S:ASUF("TOT")=2 ASUF("HDR")=0 D PRLINE F ASUU(14)=1:1:9 S X=(ASUU(14)*12)+7 W ?X," ==========="
 Q
PRLINE ;EP;DETAIL
 F ASUU(11)=1:1:9 S ASUT=$P($T(CN+ASUU(11)),";",3) D
 .S X=(ASUU(11)*12)+7,ASUU(13)=ASUF("TOT")+1,ASURZ="ASUA("_ASUT_")"
 .S:ASUF("TOT")>0 ASURZ="ASUA("_ASUV("TOT")_","_ASUF("TOT")_","_ASUT_")"
 .S ASURZA="ASUA("_ASUV("TOT")_","_ASUU(13)_","_ASUT_")"
 .S ASURZW="W ?X,$J($FN("_ASURZ_","",+T"",0),12)"
 .X ASURZW ;U IO(0) X ASURZW U ASUK("SRPT","IO")
 .S @ASURZA=@ASURZA+@ASURZ,@ASURZ=0
 F ASUU(14)=1:1:ASUF("TOT") W ! S ASUC("LN")=ASUC("LN")+1
 Q
HEADER ;EP;HEADING
 S ASUC("PG")=ASUC("PG")+1 D:ASUC("PG")>1 PAZ^ASUURHDR Q:$D(DUOUT)  W @IOF
 W !,"REPORT #74 STORES STOCK ISSUES/BUDGET ANALYSIS BY LOCATION",?70,"AS OF: ",ASUV("DT"),?90,"PAGE:",$J(ASUC("PG"),3)
 W !!,"SUB STATION: ",$G(ASUA("SST")),!!,"SUB-SUB ACTIVITY: ",$G(ASUA("SSA"))
 W !!!?22,"ANNUAL",?34,"BUDGET",?46,"ADJUSTED",?58,"ALLOTMENT",?94,"NON-REC",?106,"CURRENT",?118,"PROJECTED"
 W !?22,"  BASE",?34,"ADJUST",?46,"ANNUAL",?58,"TO",?70,"RECURRING",?82,"ISSUES",?94,"ISSUES",?106,"FUND",?118,"YEAR END"
 W !,"ACCOUNT",?22,"BUDGET",?34,"+ OR -",?46,"BUDGET",?58,"DATE",?70,"CUR MO",?82,"Y-T-D",?94,"Y-T-D",?106,"BALANCE",?118,"BALANCE",!!
 S ASUC("LN")=12,ASUF("HDR")=0
 Q
CN ;
 ;;"B"
 ;;"J"
 ;;"G"
 ;;"L"
 ;;"M"
 ;;"Y"
 ;;"N"
 ;;"BAL"
 ;;"P"
TN ;;
 ;;SUB-SUB ACT TOTAL
 ;;SUB STATION TOTAL
 ;;AREA TOTAL
CMPT ;EP;SORT
 K ^XTMP("ASUR","R74") S ^XTMP("ASUR","R74",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM"),ASUL(18,"SST","E#")=ASUL(1,"AR","AP")_"000"
 F  S ASUL(18,"SST","E#")=$O(^ASUL(18,ASUL(18,"SST","E#"))) D  Q:ASUL(18,"SST","E#")']""
 .I $E(ASUL(18,"SST","E#"),1,2)'=ASUL(1,"AR","AP") S ASUL(18,"SST","E#")="" Q
 .D SST^ASULDIRR(ASUL(18,"SST","E#"))
 .S ^XTMP("ASUR","R74","ZB",+ASUL(18,"SST","E#"))=ASUL(18,"SST","E#")
 .S $P(^XTMP("ASUR","R74","ZB",+ASUL(18,"SST","E#")),U,3)=ASUL(18,"SST")_" -"_ASUL(18,"SST","NM")
 S ASUL(18,"SST","E#")=""
 F ASUC=0:1 S ASUL(18,"SST","E#")=$O(^XTMP("ASUR","R74","ZB",ASUL(18,"SST","E#"))) Q:ASUL(18,"SST","E#")']""  D
 .S ASUL(21,"SSA","E#")=0
 .F ASUC(0)=0:1 S ASUL(21,"SSA","E#")=$O(^ASUL(21,ASUL(18,"SST","E#"),1,ASUL(21,"SSA","E#"))) Q:ASUL(21,"SSA","E#")'?1N.N  D
 ..S ^XTMP("ASUR","R74","ZB",+ASUL(18,"SST","E#"),+ASUL(21,"SSA","E#"))=ASUL(21,"SSA","E#")
 ..S X=$P(^ASUL(17,ASUL(21,"SSA","E#"),0),U) S:X="" X="N/F"
 ..S Y=$P(^ASUL(17,ASUL(21,"SSA","E#"),1),U) S:Y="" Y="N/F"
 ..S $P(^XTMP("ASUR","R74","ZB",+ASUL(18,"SST","E#"),+ASUL(21,"SSA","E#")),U,3)=Y_" -"_X
 ..S ASUL(21,"ACC","E#")=0
 ..F ASUC(1)=0:1 S ASUL(21,"ACC","E#")=$O(^ASUL(21,ASUL(18,"SST","E#"),1,ASUL(21,"SSA","E#"),1,ASUL(21,"ACC","E#"))) Q:ASUL(21,"ACC","E#")'?1N.N  D
 ...S X=^ASUL(21,ASUL(18,"SST","E#"),1,ASUL(21,"SSA","E#"),1,ASUL(21,"ACC","E#"),0)
 ...S ASUC(3)=0 F ASUC(2)=2:1:6 S ASUC(3)=ASUC(3)+$P(X,U,ASUC(2))
 ...I ASUC(3)>0 S ^XTMP("ASUR","R74",+ASUL(18,"SST","E#"),+ASUL(21,"SSA","E#"),+ASUL(21,"ACC","E#"))=X
 ...E  S ^XTMP("ASUR","R74","ZA",+ASUL(18,"SST","E#"),+ASUL(21,"SSA","E#"),+ASUL(21,"ACC","E#"))=X,ASUC(1)=ASUC(1)=1
 ..I ASUC(1)>0 S ^XTMP("ASUR","R74",+ASUL(18,"SST","E#"),+ASUL(21,"SSA","E#"))=^XTMP("ASUR","R74","ZB",+ASUL(18,"SST","E#"),+ASUL(21,"SSA","E#"))
 ..E  S ^XTMP("ASUR","R74","ZA",+ASUL(18,"SST","E#"),+ASUL(21,"SSA","E#"))=^XTMP("ASUR","R74","ZB",+ASUL(18,"SST","E#"),+ASUL(21,"SSA","E#")),ASUC(0)=ASUC(0)-1
 .I ASUC(0)>0 S ^XTMP("ASUR","R74",+ASUL(18,"SST","E#"))=^XTMP("ASUR","R74","ZB",+ASUL(18,"SST","E#"))
 .E  S ^XTMP("ASUR","R74","ZA",+ASUL(18,"SST","E#"))=^XTMP("ASUR","R74","ZB",+ASUL(18,"SST","E#")),ASUC=ASUC-1
 S ASUMY("E#","REQ")=0
 F  S ASUMY("E#","REQ")=$O(^ASUMY(ASUMY("E#","REQ"))) Q:ASUMY("E#","REQ")'?1N.N  D
 .S ASUMY("E#","SSA")=0
 .F  S ASUMY("E#","SSA")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"))) Q:ASUMY("E#","SSA")'?1N.N  D
 ..S ASUMY("E#","ACC")=0
 ..F  S ASUMY("E#","ACC")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"))) Q:ASUMY("E#","ACC")'?1N.N  D
 ...D READ^ASUMYDIO
 ...I '$D(^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA"),+ASUMY("ACC"))) D
 ....S X=$G(^XTMP("ASUR","R74","ZB",ASUMY("SST"),+ASUMY("SSA"),+ASUMY("ACC")))
 ....S:X="" X="^^^^^^^NO BUDG"
 ....S ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA"),+ASUMY("ACC"))=X
 ...I $D(^XTMP("ASUR","R74",ASUMY("E#","SST"),+ASUMY("SSA"),+ASUMY("ACC"))) D
 ....S ASUX(0)=^XTMP("ASUR","R74",ASUMY("E#","SST"),+ASUMY("SSA"),+ASUMY("ACC"))
 ...E  D
 ....S ASUX(0)=^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA"),+ASUMY("ACC"))
 ...S (ASUC("SUM"),ASUF("BLD"))=0
 ...F ASUU(12)="5;RCR;CMO","6;RCR;YTD","7;NRC;YTD" D
 ....S ASUMY($P(ASUU(12),";",3),$P(ASUU(12),";",2),"VAL")=$FN(ASUMY($P(ASUU(12),";",3),$P(ASUU(12),";",2),"VAL"),"",0)
 ....S ASUC("SUM")=$P(ASUX(0),U,$P(ASUU(12),";"))+ASUMY($P(ASUU(12),";",3),$P(ASUU(12),";",2),"VAL")
 ....Q:ASUC("SUM")'>0
 ....I ASUF("BLD")=0 D BUILD2
 ....S $P(ASUX(0),U,$P(ASUU(12),";"))=ASUC("SUM"),ASUC("SUM")=0
 ...I 'ASUF("BLD") D
 ....F ASUU(12)=2:1:4 D  Q:ASUF("BLD")
 .....I $P(ASUX(0),U,ASUU(12))]"" D BUILD2
 ...I ASUF("BLD") S ^XTMP("ASUR","R74",ASUMY("E#","SST"),+ASUMY("SSA"),+ASUMY("ACC"))=ASUX(0)
 ...K X
 K ASUX,ASUV,ASUMU,^XTMP("ASUR","R74","ZA"),^XTMP("ASUR","R74","ZB") F X=3:1:22 K ASUL(X)
 Q
BUILD2 ;
 S ASUF("BLD")=1
 I '$D(^XTMP("ASUR","R74",ASUMY("E#","SST"))) D
 .S ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"))=$G(^XTMP("ASUR","R74","ZA",ASUMY("E#","SST")))
 .I ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"))="" S ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"))=$G(^XTMP("ASUR","R74","ZB",ASUMY("E#","SST")))
 .I ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"))="" S ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"))="^^^"_ASUMY("SST")_" -N/F"
 .S ^XTMP("ASUR","R74",ASUMY("E#","SST"))=^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"))
 I '$D(^XTMP("ASUR","R74",ASUMY("E#","SST"),+ASUMY("SSA"))) D
 .S ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA"))=$G(^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA")))
 .I ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA"))="" S ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA"))=$G(^XTMP("ASUR","R74","ZB",ASUMY("E#","SST"),+ASUMY("SSA")))
 .I ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA"))="" D
 ..D SSA^ASULDIRR(ASUMY("SSA"))
 ..I Y>0 D
 ...S ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA"))="^^"_ASUL(17,"SSA")_" - "_ASUL(17,"SSA","NM")
 ..E  D
 ...S ^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA"))="^^"_ASUMY("SSA")_"- N/F"
 .S ^XTMP("ASUR","R74",ASUMY("E#","SST"),+ASUMY("SSA"))=^XTMP("ASUR","R74","ZA",ASUMY("E#","SST"),+ASUMY("SSA"))
 Q