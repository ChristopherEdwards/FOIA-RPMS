ASURO46P ; IHS/ITSC/LMH - REPORT 46 ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine creates report 46 Analysis of Stock Issues by Vendor
 ;^XTMP("ASUR","R46",AREA,STATION,ACCOUNT,VENDOR,DESCRIPTION)
 K %ZIS,IOP,IO("Q") S %ZIS="QM" D ^%ZIS I POP W !,"No device selected or report queued." G KIL
 I $D(IO("Q")) K IO("Q") S ZTIO=ION K ZTSAVE,ZTDTH,ZTSK S ZTRTN="QUE^ASURP",ZTSAVE("DUZ*")="",ZTDTH=$H D ^%ZTLOAD W !,"Queued" G KIL
QUE ;EP; for task man
 D ASUR0
 D KIL U IO
 ;Set header values
 D SETHEADR
 D  S ASUREND=1 D VSCS(.ASURVSCT) D PAZ^ASUURHDR W @IOF D ^%ZISC,KIL
 .F  S ASURD1=$O(^XTMP("ASUR","R46",$G(ASURD1))) Q:ASURD1=""  D  Q:$D(DUOUT)
 ..F  S ASURD2=$O(^XTMP("ASUR","R46",ASURD1,$G(ASURD2))) Q:ASURD2=""  D  Q:$D(DUOUT)
 ...F  S ASURD3=$O(^XTMP("ASUR","R46",ASURD1,ASURD2,$G(ASURD3))) Q:ASURD3=""  D  Q:$D(DUOUT)
 ....K ASURVSCA
 ....F  S ASURD4=$O(^XTMP("ASUR","R46",ASURD1,ASURD2,ASURD3,$G(ASURD4))) Q:ASURD4=""  D  D HEADER Q:$D(DUOUT)
 .....K ASURVSCS
 .....F  D NEWPAGE W ! S ASURD5=$O(^XTMP("ASUR","R46",ASURD1,ASURD2,ASURD3,ASURD4,$G(ASURD5))) Q:ASURD5=""  S ASUR("DTA")=^(ASURD5) D SETDATA
 .....D VSCS(.ASURVSCS)
 ....D VSCS(.ASURVSCA)
 Q
VSCS(X) ;Print out Vendor Source Code Summary
 ;Formal Param is X(SOURCE CODE)=PROJECT ANNUAL ISS VAL^NUM LINE ITEMS
 ;Actual parameters are as follows:
 ;ASURVSCS -Totals for each separate vendor
 ;ASURVSCT -Totals for all vendors on report
 ;ASURVSCA -Totals for all vendors for each account 1,3 other
 I $D(ASUREND) W @IOF,"REPORT # 46 ANALYSIS OF STOCK ITEM BY VENDOR",?65,ASUR("DT"),?112,"PAGE ",ASUR("PG")+1,!,"SUMMARY PAGE"
 K ASUR("T1"),ASUR("T2")
 D NEWPAGE W !!!?6,"VENDOR SOURCE CODE SUMMARY:",?36,"SOU CDE",?60,"NO. LI",?79,"PROJ ANN ISS VAL"
 F  D NEWPAGE S Y=$O(X($G(Y))) Q:Y=""  W !?35,$J(Y,8),?60,$J($FN($P(X(Y),U,2),","),6),?80,$J($FN($P(X(Y),U),","),15) D
 .S ASUR("T1")=$G(ASUR("T1"))+$P(X(Y),U) ;Total for PAIV
 .S ASUR("T2")=$G(ASUR("T2"))+$P(X(Y),U,2) ;Total for NO. LI
 K Y
 D NEWPAGE W !?38,"TOTAL",?60,$J($FN($G(ASUR("T2")),","),6),?80,$J($FN($G(ASUR("T1")),","),15)
 Q
 ;
NEWPAGE ;Form Feed
 I $Y+4>IOSL D HEADER Q:$D(DUOUT)
 Q
KIL ;Kill
 K ASURD1,ASURD2,ASURD3,ASURD4,ASURD5,ASURDL,ASUR1
 K ASURVSCS,ASURVSCT,ASUREND
ASUR0 ;
 D KILL K ^XTMP("ASUR","R46")
 S ^XTMP("ASUR","R46",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 F ASUMS("E#","STA")=0:0 S ASUMS("E#","STA")=$O(^ASUMS(ASUMS("E#","STA"))) Q:'ASUMS("E#","STA")  D
 .F ASUMS("E#","IDX")=0:0 S ASUMS("E#","IDX")=$O(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"))) Q:'ASUMS("E#","IDX")  D
 ..D ^ASUMSTRD S ASUMX("E#","IDX")=ASUMS("E#","IDX") D READ^ASUMXDIO
 ..D ARE^ASULARST(ASUMS("AR")),STA^ASULARST(ASUMS("E#","STA"))
 ..S ASUR("ACC")=ASUMX("ACC") I ASUMX("ACC")'=1,ASUMX("ACC")'=3 S ASUR("ACC")=4
 ..S ASUR("IDX")=$E(ASUMX("IDX"),1,5)_"."_$E(ASUMX("IDX"),6)
 ..S ASUR("DESC")=ASUMX("DESC",1)_" "_ASUMX("DESC",2)
 ..S ASUR("PMIV")=ASUMS("PMIV")*12,ASUR("PMIV")=$FN(ASUR("PMIV"),"+",0)
 ..D
 ...S X=ASUMS("SLC")_U_ASUR("IDX")_U_ASUMX("DESC",1)_U_ASUMX("DESC",2)_U_ASUMX("AR U/I")_U_ASUMS("ORD#")_U_ASUMX("NSN")
 ...S X=X_U_ASUMS("SRC")_U_ASUMS("LTM")_U_ASUMS("EOQ","TP")_U_ASUMS("LPP")_U_ASUMS("PMIQ")_U_ASUMS("DMD","QTY")_U_ASUR("PMIV")
 ...S ASUR("VEN")=$S(ASUMS("VENAM")]"":ASUMS("VENAM"),1:"*")
 ...S ASUR("AR/NM")=ASUMS("AR")_"-"_ASUL(1,"AR","NM"),ASUR("STA/NM")=ASUL(2,"STA","CD")_"-"_ASUL(2,"STA","NM")
 ...S ^XTMP("ASUR","R46",ASUR("AR/NM"),ASUR("STA/NM"),ASUR("ACC"),ASUR("VEN"),ASUR("DESC"))=X
KILL ;Kill
 K ASUR,ASU1,ASU2,ASU3,ASUMS,ASUMX
 Q
SETHEADR ;EP; -Set hdr
 ;Hdr 1
 S ASU1(1)="S",ASU1(2)="LAST",ASU1(3)="PREV",ASU1(4)="PROJ ANN"
 ;
 ;Hdr 2
 S ASU2(1)="L",ASU2(2)="INDEX",ASU2(3)="ORDER",ASU2(4)="SOU",ASU2(5)="LT",ASU2(6)="T",ASU2(7)="PURCHASE",ASU2(8)="12 MOS",ASU2(9)="ISSUE"
 ;
 ;Hdr 3
 S ASU3(1)="C",ASU3(2)="NUMBER",ASU3(3)="DESCRIPTION",ASU3(4)="U/I",ASU3(5)="NUMBER",ASU3(6)="CDE",ASU3(7)="MOS",ASU3(8)="C",ASU3(9)="PRICE"
 S ASU3(10)="PAMIQ",ASU3(11)="USAGE",ASU3(12)="VALUE"
 Q
 ;
HEADER ;EP; -Print hdr
 S:'$D(ASUR("LN")) $P(ASUR("LN"),"=",123)="="
 I '$D(ASUR("DT")) D NOW^%DTC S Y=% X ^DD("DD") S ASUR("DT")=$P(Y,"@")
 S ASUR("PG")=$G(ASUR("PG"))+1 D:ASUR("PG")>1 PAZ^ASUURHDR Q:$D(DUOUT)  W @IOF
 W "REPORT # 46 ANALYSIS OF STOCK ITEM BY VENDOR",?65,ASUR("DT"),?112,"PAGE ",ASUR("PG"),!,"AREA : ",ASURD1
 W !,"STATION: ",ASURD2,?50,"CATEGORY: ",$S(ASURD3=1:"PHARMACY",ASURD3=3:"SUBSISTENCE",1:"GENERAL SUPPLIES"),?86,"VENDOR NAME: ",ASURD4
 ;
 ;Hdr1
 W !!!,ASU1(1),?86,ASU1(2),?105,ASU1(3),?115,ASU1(4)
 ;
 ;Hdr2
 W !,ASU2(1),?5,ASU2(2),?48,ASU2(3),?69,ASU2(4),?74,ASU2(5),?79,ASU2(6),?82,ASU2(7),?103,ASU2(8),?118,ASU2(9)
 ;
 ;Hdr 3
 W !,ASU3(1),?4,ASU3(2),?12,ASU3(3),?44,ASU3(4),?48,ASU3(5),?69,ASU3(6),?74,ASU3(7),?79,ASU3(8),?85,ASU3(9),?94,ASU3(10),?104,ASU3(11),?118,ASU3(12)
 ;
 W !,ASUR("LN")
 W !
 Q
SETDATA ;Set DATA line
 S ASURDL(1)=$P(ASUR("DTA"),U) ;SLC-Storage location code
 S ASURDL(2)=$P(ASUR("DTA"),U,2) ;IDX-index number grouped as 5-1
 S ASURDL(3)=$P(ASUR("DTA"),U,3) ;DSC1-Description 1
 S ASURDL(4)=$P(ASUR("DTA"),U,5) ;AUI-Area Unit of issue
 S ASUR=$P(ASUR("DTA"),U,6) S ASURDL(5)=$$ON(ASUR) ;VON-Vendor order number
 S ASURDL(6)=$P(ASUR("DTA"),U,8) ;SRC-Source code
 S ASURDL(7)=$P(ASUR("DTA"),U,9) ;LTM-Lead Time Months
 S ASURDL(8)=$P(ASUR("DTA"),U,10) ;TC-Type Code
 S ASURDL(9)=$P(ASUR("DTA"),U,11) ;LPP-Last Purchase Price
 S ASURDL(10)=$P(ASUR("DTA"),U,12) ;PAMIQ-Projected Average Mon Iss Qnt
 S ASURDL(11)=$P(ASUR("DTA"),U,13) ;P12MU-Prev 12 Months Issue Qnt
 S ASURDL(12)=$P(ASUR("DTA"),U,14) ;PAIV-Projected Annual Issue Value
 S ASURDL(13)=$P(ASUR("DTA"),U,4) ;DSC2-Description 2
 S ASURDL(14)=$P(ASUR("DTA"),U,7) ;NSN-National Stock Number
 ;
 S:'$D(ASURVSCS(ASURDL(6))) ASURVSCS(ASURDL(6))=""
 S $P(ASURVSCS(ASURDL(6)),U)=$P(ASURVSCS(ASURDL(6)),U)+ASURDL(12),$P(ASURVSCS(ASURDL(6)),U,2)=$P(ASURVSCS(ASURDL(6)),U,2)+1
 S:'$D(ASURVSCT(ASURDL(6))) ASURVSCT(ASURDL(6))=""
 S $P(ASURVSCT(ASURDL(6)),U)=$P(ASURVSCT(ASURDL(6)),U)+ASURDL(12),$P(ASURVSCT(ASURDL(6)),U,2)=$P(ASURVSCT(ASURDL(6)),U,2)+1
 S:'$D(ASURVSCA(ASURDL(6))) ASURVSCA(ASURDL(6))=""
 S $P(ASURVSCA(ASURDL(6)),U)=$P(ASURVSCA(ASURDL(6)),U)+ASURDL(12),$P(ASURVSCA(ASURDL(6)),U,2)=$P(ASURVSCA(ASURDL(6)),U,2)+1
 ;Print data line
 W ! D NEWPAGE D OUT(.ASURDL)
 Q
 ;
OUT(X) ;Print Data line
 ;Formal Parameter is X(1-14)
 ;Actual Parameter is ASURDL(1-14)
 W X(1)
 W ?3,X(2)
 W ?12,X(3)
 W ?44,X(4)
 W ?48,X(5)
 W ?69,X(6)
 W ?74,X(7)
 W ?79,X(8)
 W ?83,$J(X(9),7,2)
 W ?94,$J(X(10),5)
 W ?103,$J(X(11),6)
 W ?114,$J($FN(X(12),","),9)
 W ! D NEWPAGE
 W ?12,X(13)
 Q
 ;
ON(X) ;EP; -Set VENDOR ORDER NUMBER -EXTRINSIC
 ;Set X into requested print format
 ;Actual parameter is ASUR
 ;Formal parameter is X
 ;If X]"" print as follows:
 ;                $E(X)="M" ....Print as stored
 ;                      "M" ....4-2-3-5 grouping
 ;If X="" print as follows:
 ;              ASURDL(14)  ....4-2-3-5 grouping
 I X]"",$E(X)="M" Q X
 I X]"" S X=$E(X,1,4)_"-"_$E(X,5,6)_"-"_$E(X,7,9)_"-"_$E(X,10,9999) Q X
 S X=ASURDL(14),X=$E(X,1,4)_"-"_$E(X,5,6)_"-"_$E(X,7,9)_"-"_$E(X,10,999) Q X
 Q
