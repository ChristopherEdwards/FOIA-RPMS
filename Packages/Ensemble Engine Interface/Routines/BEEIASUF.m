BEEIASUF ; IHS/OIT/FJE - UTILITIES  DISPLAY EDR ASUFAC ;
 ;;1.0;BEE;;Oct 19, 2009
 ;;
 Q
CLEAN  ;EP for diagnostic use only by programmer
 ;K ^HLB
 ;K ^HLA
 S ^HLB(0)="HLO MESSAGES^778O^^"
 S ^HLA(0)="HLO MESSAGE BODY^777D^^"
 S ^HLC("QUEUECOUNT","OUT","DENTRIX:5012","DENT ADT")=0
 S ^HLC("QUEUECOUNT","IN","DENTRIX:5012","DENT ADT")=0
 S ^HLC("QUEUECOUNT","OUT","DENTRIX:5012","DENT MFE")=0
 S ^HLC("QUEUECOUNT","IN","DENTRIX:5012","DENT MFE")=0
 S ^HLC("FILE777","OUT")=0
 S ^HLC("FILE778","OUT","TCP")=0
 Q
RSEND  ;EP
 N X
 W !,"Reset a message in HLO for EIE transport"
 W !!,"Are you sure you want to reset an HLO message.." S %=2 D YN^DICN I %'=1 S Y=-1 Q
 R !,"ENTER IEN TO REMOVE 16,17,20 DATA:  ",X:DTIME
 Q:(X="")!(+X'=X)
 I '$D(^HLB(X,0)) W !,"Message IEN not identified..",! Q
 S $P(^HLB(X,0),"^",16)=""
 S $P(^HLB(X,0),"^",17)=""
 S $P(^HLB(X,0),"^",20)=""
 S $P(^HLB(X,0),"^",21)=""
 S ^HLB(X,4)=""
 W !,"Message IEN "_X_" reset.."
 R !!,"Press RETURN to continue..",!,X:DTIME
 Q
TOON ;EP TURN TRACE ON
 W !,"Turn on the EIE Outbound Message Trace"
 W !,"Only run this for a few minutes - THEN TURN OFF"
 W !!,"Are you sure you want to turn on this message.." S %=2 D YN^DICN I %'=1 S Y=-1 Q
 S ^BEEICTRL("TRACE","Dental")=1
 W !,"Outbound Message Trace turned on.."
 R !!,"Press RETURN to continue..",!,X:DTIME
 Q
 ;
TOOFF ;EP TURN TRACE OFF
 W !,"Turn off the EIE Outbound Message Trace"
  W !!,"Are you sure you want to turn on this message.." S %=1 D YN^DICN I %'=1 S Y=-1 Q
 S ^BEEICTRL("TRACE","Dental")=0
 W !,"Outbound Message Trace turned off.."
 R !!,"Press RETURN to continue..",!,X:DTIME
 Q
 ;  
TION ;EP TURN TRACE ON
 W !,"Turn on the EIE Inbound Message Trace"
 W !,"Only run this for a few minutes - THEN TURN OFF"
 W !!,"Are you sure you want to turn on this message.." S %=2 D YN^DICN I %'=1 S Y=-1 Q
 S ^BEEICTRL("TRACE","DENTRIX")=1
 W !,"Inbound Message Trace turned on.."
 R !!,"Press RETURN to continue..",!,X:DTIME
 Q
 ;
TIOFF ;EP TURN TRACE OFF
 W !,"Turn off the EIE Inbound Message Trace"
 W !!,"Are you sure you want to turn on this message.." S %=1 D YN^DICN I %'=1 S Y=-1 Q
 S ^BEEICTRL("TRACE","DENTRIX")=0
 W !,"Inbound Message Trace turned off.."
 R !!,"Press RETURN to continue..",!,X:DTIME
 Q
 ;
ASUFAC ;EP LOOK FOR ALL ACTIVE ASUFAC NUMBERS  
 N X,X1,X2,BEEIX
 S X=0 F  S X=$O(^AUPNPAT(X)) Q:+X=0  D
 .S X1=0 F  S X1=$O(^AUPNPAT(X,41,X1)) Q:+X1=0  D
 ..S X2=$P($G(^AUPNPAT(X,41,X1,0)),"^",3)
 ..I $L(X2) D
 ...I '$D(BEEIX("I",X1)) S BEEIX("I",X1)=0
 ...S BEEIX("I",X1)=BEEIX("I",X1)+1
 ..I '$L(X2) D
 ...I '$D(BEEIX("A",X1)) S BEEIX("A",X1)=0
 ...S BEEIX("A",X1)=BEEIX("A",X1)+1
 W @IOF,!,"     A S U F A C  D I S P L A Y",!
 W !!,"Active  Count",?15,"Facility",?55,"ASUFAC"
 S X=0 F  S X=$O(BEEIX("A",X)) Q:+X=0  D
 .S $P(BEEIX("A",X),"^",2)=$P($G(^DIC(4,X,0)),"^",1)
 .S $P(BEEIX("A",X),"^",3)=$P($G(^AUTTLOC(X,0)),"^",10)
 .W !,"Active:  ",$P(BEEIX("A",X),"^",1),?15,$P(BEEIX("A",X),"^",2),?55,$P(BEEIX("A",X),"^",3)
 W !!,"Inactive Count",?15,"Facility",?55,"ASUFAC"
 S X=0 F  S X=$O(BEEIX("I",X)) Q:+X=0  D
 .S $P(BEEIX("I",X),"^",2)=$P($G(^DIC(4,X,0)),"^",1)
 .S $P(BEEIX("I",X),"^",3)=$P($G(^AUTTLOC(X,0)),"^",10)
 .W !,"Inactive:",$P(BEEIX("I",X),"^",1),?15,$P(BEEIX("I",X),"^",2),?55,$P(BEEIX("I",X),"^",3)
 W !,"Finished.."
 R !!,"Press RETURN to continue..",!,X:DTIME
 Q
