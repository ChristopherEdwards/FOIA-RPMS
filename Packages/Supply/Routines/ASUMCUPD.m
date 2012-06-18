ASUMCUPD ; IHS/ITSC/LMH -CONTROL SHEET UPDATE ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine initializes Control Sheet Master for Fiscal Year Month
 S:$G(ASUMC(ASUMS("E#","STA"),0))']"" ^ASUMC(ASUMS("E#","STA"),0)=ASUMS("E#","STA")
 K ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"))
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),0)=ASUK("DT","FYM#")
 S:$G(ASUMC(ASUMS("E#","STA"),1,0))']"" ^ASUMC(ASUMS("E#","STA"),1,0)="^9002037.01^^"
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),1,0)="^9002037.11PA^^"
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,0)="^9002037.12PA^^"
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,0)="^9002037.13PA^^"
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,0)="^9002037.14PA^^"
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),5,0)="^9002037.15PA^^"
 ;All control sheet data blank for fiscal year month
 S ASURX="W !?3,""Getting Month's Master Beginning Balances""" D ^ASUUPLOG
 S ASUMS("E#","STA")=ASUL(2,"STA","E#")
 D:$G(ASUN("TYP"))']"" RANGE^ASUURANG(2)
 D LOAD^ASUCOHKP(.ASUN)
 N X,Y,Z
 F X=1:1:5,9 D
 .I '$D(^TMP("ASUMC",$J,X)) D  Q
 ..S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),1,X,0)=X
 .S Y=0 F  S Y=$O(^TMP("ASUMC",$J,X,Y)) Q:Y']""  D
 ..S:$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),1,X,0))']"" ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),1,X,0)=X
 ..S Z=$G(Z)+$P(^TMP("ASUMC",$J,X,Y),U)
 .S $P(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),1,X,0),U,2)=Z K Z
 F  S ASUN("KEY")=$O(^ASUH("B",ASUN("KEY"))) Q:ASUN("KEY")']""  Q:ASUN("KEY")>ASUN("EKY")  D
 .S ASUA=$O(^ASUH("B",ASUN("KEY"),""))
 .N Y D READ^ASU0TRRD(.ASUA,"H") Q:Y<0  ;Read history record
 .D RPT1,ACC,VOU,SCAN,DCAN,TRN
CLOSE ;
 F X=1:1:5,9 D
 .S Z=^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),1,X,0)
 .S Y=$P(Z,U,2) ;W !?10,"OPEN : ",?20,Y
 .S Y=Y+$P(Z,U,3) ;W !,"+REC: ",$P(Z,U,3)," = ",?20,Y
 .S Y=Y+$P(Z,U,4) ;W !,"+TFI: ",$P(Z,U,4)," = ",?20,Y
 .S Y=Y+$P(Z,U,5) ;W !,"+PVR: ",$P(Z,U,5)," = ",?20,Y
 .S Y=Y+$P(Z,U,6) ;W !,"-SKI: ",$P(Z,U,6)," = ",?20,Y
 .S Y=Y+$P(Z,U,7) ;W !,"-TFO: ",$P(Z,U,7)," = ",?20,Y
 .S Y=Y+$P(Z,U,8) ;W !,"+PVI: ",$P(Z,U,8)," = ",?20,Y
 .S Y=Y+$P(Z,U,9) ;W !,"+-ADJ: ",$P(Z,U,9)," = ",?20,Y
 .S $P(Z,U,10)=Y
 .S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),1,X,0)=Z
 D RPT1YTD
 S DIK="^ASUMC(" D IXALL^DIK
 Q
RPT1 ;Collect data for report 1
CURMO ;Count transactions for report 1 - current month -subscript (2)
 S X=$G(^XTMP("ASUR","R01",2,ASUL(11,"TRN","E#")))
 I X']"" S X=ASUL(11,"TRN","E#")_"^^"_ASUL(11,"TRN","TYPE")
 S $P(X,U,2)=$P(X,U,2)+1
 S ^XTMP("ASUR","R01",2,ASUL(11,"TRN","E#"))=X
TODAY ;Get active items (transactions posted today) beginning balances
 I $P(ASUN("KEY"),"-",2)=ASUK("DT","RUN") D
 .;Count transactions for report 1 - processed today -subscript (1)
 .S X=$G(^XTMP("ASUR","R01",1,ASUL(11,"TRN","E#")))
 .I X']"" S X=ASUL(11,"TRN","E#")_"^^"_ASUL(11,"TRN","TYPE")
 .S $P(X,U,2)=$P(X,U,2)+1
 .S ^XTMP("ASUR","R01",1,ASUL(11,"TRN","E#"))=X
 Q
RPT1YTD ; Collect year to date item counts for report 1 - subscript (3)
 ;M ^XTMP("ASUR","R01",3)=^XTMP("ASUR","R01",2) ;Start with current month
 N W,X,Y,Z S Z=ASUK("DT","FYM#") F Z=Z:-1:1 D
 .S Y=0 F  S Y=$O(^ASUMC(ASUMS("E#","STA"),1,Z,5,Y)) Q:Y'?1N.N  D
 ..S X=$G(^ASUMC(ASUMS("E#","STA"),1,Z,5,Y,0)),W=$G(^XTMP("ASUR","R01",3,Y)),$P(W,U)=Y,$P(W,U,2)=$P(W,U,2)+$P(X,U,2),^XTMP("ASUR","R01",3,Y)=W
 Q
YEARCLR ;EP ;YEARLY CLEAR SUBSCRIPT 3
 N W,X,Y,Z S Z=ASUK("DT","FYM#") F Z=Z:-1:1 D
 .S Y=0 F  S Y=$O(^ASUMC(ASUMS("E#","STA"),1,Z,5,Y)) Q:Y'?1N.N  D
 ..S ^ASUMC(ASUMS("E#","STA"),1,Z,5,Y,0)=""
 Q
ACC ;Accumulate value from transactions
 S X=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),1,ASUT(ASUT,"ACC"),0)),Z=ASUL(11,"TRN","TYPE")
 S:X']"" X=ASUT(ASUT,"ACC")_U
 S Y=$S(Z=2:3,Z=8:4,Z=3:6,Z=9:7,Z=6:9,Z=0:11,1:Z)
 Q:Z=1
 I Z=2,$E(ASUT("TRCD"),2)="0" S Y=5
 I Z=3,$E(ASUT("TRCD"),2)="0" S Y=8
 S $P(X,U,Y)=$P(X,U,Y)+(ASUT(ASUT,"VAL")*ASUL(11,"TRN","DRCR"))
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),1,ASUT(ASUT,"ACC"),0)=X
 Q
VOU ;Accumulate Values by Vouchers
 Q:$G(ASUT(ASUT,"VOU"))']""  Q:$G(ASUT(ASUT,"ACC"))']""
 N X,Z
 S ASUW("E#","VOU")=($P(ASUT(ASUT,"VOU"),"-"))_($P(ASUT(ASUT,"VOU"),"-",2))_($P(ASUT(ASUT,"VOU"),"-",3))
 S Z=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,ASUW("E#","VOU"),0))
 I Z="" D
 .S Z=ASUT(ASUT,"VOU")_U
 .S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,ASUW("E#","VOU"),0)=Z
 .S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,ASUW("E#","VOU"),1,0)="^9002037.121PA^^"
 .S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,"B",ASUT(ASUT,"VOU"),ASUW("E#","VOU"))=""
 I $P(Z,U)'=ASUT(ASUT,"VOU") D
 .S ASUW("E#","VOU")=$O(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,"B",ASUT(ASUT,"VOU"),""))
 .I ASUW("E#","VOU")']"" D
 ..S ASUW("E#","VOU")=($P(ASUT(ASUT,"VOU"),"-"))_(($P(ASUT(ASUT,"VOU"),"-",2))_($P(ASUT(ASUT,"VOU"),"-",3)))
 ..S Z=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,ASUW("E#","VOU"),0))
 ..I Z="" D
 ...S Z=ASUT(ASUT,"VOU")_U
 ...S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,ASUW("E#","VOU"),0)=Z
 ...S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,ASUW("E#","VOU"),1,0)="^9002037.121PA^^"
 ...S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,"B",ASUT(ASUT,"VOU"),ASUW("E#","VOU"))=""
 ..I $P(Z,U)'=ASUT(ASUT,"VOU") D
 ...S Y=-1 Q
 Q:Y<0
 S X=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,ASUW("E#","VOU"),1,ASUT(ASUT,"ACC"),0))
 I X="" S X=ASUT(ASUT,"ACC")_U_0
 S $P(X,U,2)=$P(X,U,2)+(ASUT(ASUT,"VAL")*ASUL(11,"TRN","DRCR"))
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),2,ASUW("E#","VOU"),1,ASUT(ASUT,"ACC"),0)=X
 Q
SCAN ;Accumulate Values by Stock Issue Cans
 Q:ASUL(11,"TRN","TYPE")'=3  Q:$G(ASUT(ASUT,"CAN"))']""  Q:$G(ASUT(ASUT,"ACC"))']""
 N X,Z
 S ASUW("E#","CAN")=+($P(ASUT(ASUT,"CAN"),ASUL(1,"AR","AP"),2))
 I ASUW("E#","CAN")'?1N.N S ASUW("E#","CAN")=1
 S Z=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,ASUW("E#","CAN"),0))
 I Z="" D
 .S Z=ASUT(ASUT,"CAN")_U
 .S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,ASUW("E#","CAN"),0)=Z
 .S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,ASUW("E#","CAN"),1,0)="^9002037.131PA^^"
 .S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,"B",ASUT(ASUT,"CAN"),ASUW("E#","CAN"))=""
 S Z=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,ASUW("E#","CAN"),0))
 I $P(Z,U)'=ASUT(ASUT,"CAN") D
 .S ASUW("E#","CAN")=$O(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,"B",ASUT(ASUT,"CAN"),""))
 .I ASUW("E#","CAN")']"" D
 ..S ASUW("E#","CAN")=+($P(ASUT(ASUT,"CAN"),"J",2)) I (ASUW("E#","CAN")'?1N.N)!(ASUW("E#","CAN")'>0) S Y=-1 Q
 ..S Z=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,ASUW("E#","CAN"),0))
 ..I Z="" D
 ...S Z=ASUT(ASUT,"CAN")_U
 ...S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,ASUW("E#","CAN"),0)=Z
 ...S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,ASUW("E#","CAN"),1,0)="^9002037.131PA^^"
 ...S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,"B",ASUT(ASUT,"CAN"),ASUW("E#","CAN"))=""
 ..I $P(Z,U)'=ASUT(ASUT,"CAN") D
 ...S Y=-1 Q
 S X=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,ASUW("E#","CAN"),1,ASUT(ASUT,"ACC"),0))
 I X="" S X=ASUT(ASUT,"ACC")_U_0
 Q:Y<0
 S $P(X,U,2)=$P(X,U,2)+($G(ASUT(ASUT,"VAL"))*ASUL(11,"TRN","DRCR"))
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),3,ASUW("E#","CAN"),1,ASUT(ASUT,"ACC"),0)=X
 Q
DCAN ;Accumulate Values by Direct issue Cans
 Q:ASUL(11,"TRN","TYPE")'=9  Q:$G(ASUT(ASUT,"CAN"))']""  Q:$G(ASUT(ASUT,"ACC"))']""
 N X,Z
 S (X,ASUW("E#","CAN"))=$P(ASUT(ASUT,"CAN"),ASUL(1,"AR","AP"),2) S:X'?1N.N ASUW("E#","CAN")=+X
 S Z=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,ASUW("E#","CAN"),0))
 I Z="" D
 .S Z=ASUT(ASUT,"CAN")_U
 .S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,ASUW("E#","CAN"),0)=Z
 .S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,ASUW("E#","CAN"),1,0)="^9002037.141PA^^"
 .S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,"B",ASUT(ASUT,"CAN"),ASUW("E#","CAN"))=""
 S Z=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,ASUW("E#","CAN"),0))
 I $P(Z,U)'=ASUT(ASUT,"CAN") D
 .S ASUW("E#","CAN")=$O(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,"B",ASUT(ASUT,"CAN"),""))
 .I ASUW("E#","CAN")']"" D
 ..S ASUW("E#","CAN")=+($P(ASUT(ASUT,"CAN"),"J",2)) I (ASUW("E#","CAN")'?1N.N)!(ASUW("E#","CAN")'>0) S Y=-1 Q
 ..S Z=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,ASUW("E#","CAN"),0))
 ..I Z="" D
 ...S Z=ASUT(ASUT,"CAN")_U
 ...S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,ASUW("E#","CAN"),0)=Z
 ...S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,ASUW("E#","CAN"),1,0)="^9002037.141PA^^"
 ...S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,"B",ASUT(ASUT,"CAN"),ASUW("E#","CAN"))=""
 ..I $P(Z,U)'=ASUT(ASUT,"CAN") D
 ...S Y=-1 Q
 S X=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,ASUW("E#","CAN"),1,ASUT(ASUT,"ACC"),0))
 I X="" S X=ASUT(ASUT,"ACC")_U_0
 Q:Y<0
 S $P(X,U,2)=$P(X,U,2)+($G(ASUT(ASUT,"VAL"))*ASUL(11,"TRN","DRCR"))
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),4,ASUW("E#","CAN"),1,ASUT(ASUT,"ACC"),0)=X
 Q
TRN ;Accumulate Values by Transaction code
 ;Update Control sheet master for current month Item counts/Balances
 N X S X=$G(^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),5,ASUL(11,"TRN","E#"),0))
 I X']"" D
 .S X=ASUL(11,"TRN","E#")_"^^"_ASUL(11,"TRN","TYPE")
 S $P(X,U,2)=$P(X,U,2)+1
 S ^ASUMC(ASUMS("E#","STA"),1,ASUK("DT","FYM#"),5,ASUL(11,"TRN","E#"),0)=X
 Q
