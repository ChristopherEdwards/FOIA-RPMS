BZDMCDER ;routine to print the medicaid stuff errors [ 04/17/2000  1:42 PM ]
 D ^XBCLS
 S P1=0,P2=0,LINE=0
 U 0 W !!,"Medicaid Download Error Report"
 R !!,"Enter Month_Year you want Error Report for (ex: 032000): ",MY
 I (MY="")!(MY="^") Q
 I MY'?6N W *7," ??" H 2 G BZDMCDER
 D ^%ZIS
 I '$D(^BZDMERST(MY)) U 0 W *7,!!,"NO ERRORS ON FILE FOR THAT MONTH.." H 2 G BZDMCDER
 U 0 W !!,"....Please Hold...."
P1 ;
 S BZD1=0
 F  S BZD1=$O(^BZDMERST(MY,BZD1)) Q:BZD1=""  D
 .S DFN=""
 .F  S DFN=$O(^BZDMERST(MY,BZD1,"INACT",DFN)) Q:DFN=""  D
 ..I (LINE=0)!(LINE>58)!(P1=0) D HEAD1
 ..U IO W !,$P(^DPT(DFN,0),"^",1)
 ..S LINE=LINE+1
 S LINE=0
 S P2=0
P2 ;
 S BZD2=0
 F  S BZD2=$O(^BZDMERST(MY,BZD2)) Q:BZD2=""  D
 .S DFN=0
 .F  S DFN=$O(^BZDMERST(MY,BZD2,2,DFN)) Q:+DFN=0  D
 ..I (LINE=0)!(LINE>58)!(P2=0) D HEAD2
 ..U IO W !,$P(^DPT(DFN,0),"^",1)
 ..S LINE=LINE+1
 G END
HEAD1 ;
 U IO
 S P1=P1+1
 W #
 W ?5,"Medicaid Download Errors--Inactive HRN",?60,"PAGE: ",P1
 W !,?5,"Download Month: ",$E(MY,1,2)_"-"_$E(MY,3,6),!
 S LINE=3
 Q
HEAD2 ;
 U IO
 S P2=P2+1
 W #
 W ?5,"Medicaid Download Errors",?60,"PAGE: ",P2
 W !,?5,"Download Month: ",$E(MY,1,2)_"-"_$E(MY,3,6),!
 S LINE=3
 Q
END ;      
 K P1,P2,BZD1,BZD2,LINE,DFN,MY
 D ^%ZISC
 Q
