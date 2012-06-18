ABMDSTAT ; IHS/ASDST/DMJ - Display Processing Status ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
HD ; EP for writing heading
 Q:$D(ZTQUEUED)
 G ERR1:'$D(ABMXB("TOT-REC"))
 S ABMXB="",$P(ABMXB,"-",80)="" W !,ABMXB
 W !?5,"Records to Process: ",$FN(ABMXB("TOT-REC"),",",0),?40,"Start Time: "
 D NOW^%DTC W $$MDT^ABMDUTL(%)
 W !,ABMXB
 S ABMXB("STIME")=$P($H,",",2)
 W !?55,"Estimated"
 W !?11,"Records",?25,"Current",?40,"Percent",?55,"Completion"
 W !?10,"Processed",?26,"Time",?40,"Complete",?58,"Time"
 W !?7,"============================================================="
 W !?17,0
 Q
 ;
WRT ;EP for displaying the processing status
 Q:$D(ZTQUEUED)
 G ERR1:'$D(ABMXB("TOT-REC")),ERR2:'$D(ABMXB("STIME")),ERR3:'$D(ABMXB("CUR-REC"))
 S:'$D(ABMXB("INCR")) ABMXB("INCR")=1
 I ABMXB("CUR-REC")#ABMXB("INCR")=0 D
 .F ABMXB("J")=1:1:75 W *8
 .S ABMXB("RATE")=ABMXB("CUR-REC")/ABMXB("TOT-REC")
 .W ?10,$J($FN(ABMXB("CUR-REC"),",",0),7),?25
 .D NOW^%DTC W $P($$MDT^ABMDUTL(%)," ",2,3),?40,$J(100*ABMXB("RATE"),5,1)," %"
 .Q:ABMXB("RATE")*100<.1
 .S ABMXB("ETIME")=($P($H,",",2)-ABMXB("STIME"))\ABMXB("RATE")
 .S %H=$P($H,",")_","_(ABMXB("ETIME")+ABMXB("STIME")) D YX^%DTC
 .S Y=$P($P(Y,"@",2),":",1,2)
 .W ?56 W $J($S(Y>12:Y-12,1:+Y),2),":",$P(Y,":",2)," ",$S(Y>12:"PM",1:"AM")
 Q
 ;
END ;EP for displaying Ending Time and Cleaning Variables
 S ABMXB="",$P(ABMXB,"-",80)="" W !,ABMXB
 K ABMXB
 D NOW^%DTC
 W !!?10,"Ending Time: ",$$MDT^ABMDUTL(%)
 Q
 ;
ERR1 W !!,*7,"ERROR: The variable ABMXB(""TOT-REC"") is UNDEFINED!" Q
ERR2 W !!,*7,"ERROR: The variable ABMXB(""STIME"") is UNDEFINED!" Q
ERR3 W !!,*7,"ERROR: The variable ABMXB(""CUR-REC"") is UNDEFINED!" Q
 ;
TEST S ABMXB("TOT-REC")=199 D HD
 F ABMXB("CUR-REC")=0:1:ABMXB("TOT-REC") H 1 D WRT
 D END
