ASURO760 ; IHS/ITSC/LMH -REPORT DATA FOR 76-78 REPORTS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine sorts report 76 extracts into proper sequence so that the
 ;report can be formatted and printed.
 I '$D(ASUL(1,"AR","AP")) D ^ASULARST ;CHECK AND SET AREA VARIABLES
 F ASU2=1:1:22 S ASU1(ASU2)=0
 K ^XTMP("ASUR","R76")
 S ^XTMP("ASUR","R76",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 F ASUMY("E#","REQ")=0:0 S ASUMY("E#","REQ")=$O(^ASUMY(ASUMY("E#","REQ"))) Q:ASUMY("E#","REQ")'?1N.N  D
 .F ASUMY("E#","SSA")=0:0 S ASUMY("E#","SSA")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"))) Q:ASUMY("E#","SSA")'?1N.N  D
 ..F ASUMY("E#","ACC")=0:0 S ASUMY("E#","ACC")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"))) Q:ASUMY("E#","ACC")'?1N.N  D
 ...D READ^ASUMYDIO
 ...K ASUF("OK")
 ...F ASU2=1:1:23 I $P(ASUMY(0),U,ASU2) S ASUF("OK")=1 Q
 ...Q:'$D(ASUF("OK"))
 ...S ASU1=$G(^XTMP("ASUR","R76",ASUMY("E#","REQ"),ASUMY("ACC"))) D
 ....F ASU2=1:1:23 S $P(ASU1,U,ASU2)=$P(ASU1,U,ASU2)+$P(ASUMY(0),U,ASU2)
 ...S ^XTMP("ASUR","R76",$E(ASUMY("E#","REQ"),1,5),ASUL(1,"AR","AP")_$E(ASUMY("E#","REQ"),6,9),ASUMY("ACC"))=U_ASU1
 K ASU1,ASU2,ASUMY
 Q
