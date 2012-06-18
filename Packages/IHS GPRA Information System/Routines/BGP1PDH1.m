BGP1PDH1 ; IHS/CMI/LAB - cover page for gpra del 0 ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
 ;
PEHDR ;EP
 S BGPX=$O(^BGPCTRL("B",2011,0))
 S BGPNODEP=$S($G(BGPSEAT):75,1:34)
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY  D
 .Q:X["ENDCOVERPAGE"
 .S X=^BGPCTRL(BGPX,BGPNODEP,BGPY,0) D SET(X,1,1)
 .Q
 S X=" " D SET(X,1,1)
 Q
PEDCP ;EP
 D PEHDR
 I BGPROT'="P",'$D(BGPGUI) D
 .S X="A delimited output file called "_BGPDELF D SET(X,1,1)
 .S X="has been placed in the "_$$GETDEDIR^BGP1UTL2()_" directory for your use in Excel or some" D SET(X,1,1) S X="other software package.  See your site manager to access this file." D SET(X,1,1)
 S X=" " D SET(X,1,1)
 NEW BGPX
 S BGPX="",BGPC=0 F  S BGPX=$O(BGPSUL(BGPX)) Q:BGPX=""  D
 .S X=$P(^BGPPEDCB(BGPX,0),U,9),X=$O(^AUTTLOC("C",X,0)) S X=$S(X:$P(^DIC(4,X,0),U),1:"?????")
 .S BGPC=BGPC+1,X=BGPC_".  "_$S($P(^BGPPEDCB(BGPX,0),U,17):"*",1:"")_X D SET(X,1,1)
 .Q
 S X=" " D SET(X,1,1)
 S X="The following communities are included in this report:" D SET(X,1,1)
 S BGPX="",BGPC=0 F  S BGPX=$O(BGPSUL(BGPX)) Q:BGPX=""  D
 .S X=$P(^BGPPEDCB(BGPX,0),U,9),X=$O(^AUTTLOC("C",X,0)) S X=$S(X:$P(^DIC(4,X,0),U),1:"?????")
 .S BGPC=BGPC+1,X=BGPC_".  "_$S($P(^BGPPEDCB(BGPX,0),U,17):"*",1:"")_X D SET(X,1,1)
 .S X="Communities: " D SET(X,1,1) S X=0,N=0,Y="",Z="" F  S X=$O(^BGPPEDCB(BGPX,9999,X)) Q:X'=+X  S N=N+1,Y=Y_$S(N=1:"",1:";")_$P(^BGPPEDCB(BGPX,9999,X,0),U)
 .S X=0,C=0 F X=1:3:N S Z=$E($P(Y,";",X),1,20),$P(Z,U,2)=$E($P(Y,";",(X+1)),1,20),$P(Z,U,3)=$E($P(Y,";",(X+2)),1,20) D SET(Z,1,1)
 .I $O(^BGPPEDCB(BGPX,1111,0))  D
 ..S X=" " D SET(X,1,1)
 ..S X="MFI Site: Locations for visits: " D SET(X,1,1) S X=0,N=0,Y="",Z="" F  S X=$O(^BGPPEDCB(BGPX,1111,X)) Q:X'=+X  S N=N+1,Y=Y_$S(N=1:"",1:";")_$P(^BGPPEDCB(BGPX,1111,X,0),U)
 ..S X=0,C=0 F X=1:3:N S Z=$E($P(Y,";",X),1,20),$P(Z,U,2)=$E($P(Y,";",(X+1)),1,20),$P(Z,U,3)=$E($P(Y,";",(X+2)),1,20) D SET(Z,1,1)
 ..Q
 .S X=" " D SET(X,1,1)
 .Q
 S X=" " D SET(X,1,1)
 K BGPX,BGPQUIT
 Q
 ;
SET(Y,F,P) ;set up array
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPDEL",0),U)+F,$P(^TMP($J,"BGPDEL",0),U)=%
 I '$D(^TMP($J,"BGPDEL",%)) S ^TMP($J,"BGPDEL",%)=""
 S $P(^TMP($J,"BGPDEL",%),U,P)=Y
 Q
COMHDR ;EP
 S X=" " D SET(X,1,1)
 Q:$G(BGPSEAT)
 S BGPNODEP=$S(BGPCHSO:24,1:17)
 S BGPX=$O(^BGPCTRL("B",2011,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY  D
 .S X=^BGPCTRL(BGPX,BGPNODEP,BGPY,0) D SET(X,1,1)
 .Q
 S X=" " D SET(X,1,1)
 I $G(BGP1GPU) D SET("See last pages of this report for Performance Summaries.",1,1) D SET(" ",1,1)
 Q
GPRAHDRS ;EP
 S X=" " D SET(X,1,1)
 S BGPNODEP=$S(BGPCHSO:77,1:76)
 S BGPX=$O(^BGPCTRL("B",2011,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY  D
 .S X=^BGPCTRL(BGPX,BGPNODEP,BGPY,0) D SET(X,1,1)
 .Q
 S X=" " D SET(X,1,1)
 Q
PPHDR ;EP
 S X=" " D SET(X,1,1)
 ;Q:$G(BGPSEAT)
 S BGPX=$O(^BGPCTRL("B",2011,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,18,BGPY)) Q:BGPY'=+BGPY  D
 .S X=^BGPCTRL(BGPX,18,BGPY,0) D SET(X,1,1)
 .Q
 S X=" " D SET(X,1,1)
 Q
ALLHDR ;EP
 S X=" " D SET(X,1,1)
 Q:$G(BGPSEAT)
 S BGPNODEP=$S(BGPCHSO:25,1:19)
 S BGPX=$O(^BGPCTRL("B",2011,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY  D
 .S X=^BGPCTRL(BGPX,BGPNODEP,BGPY,0) D SET(X,1,1)
 .Q
 S X=" " D SET(X,1,1)
 Q
DENOMHDR ;EP
 S X=" " D SET(X,1,1)
 Q:$G(BGPSEAT)
 S BGPX=$O(^BGPCTRL("B",2011,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,13,BGPY)) Q:BGPY'=+BGPY  D
 .S X=^BGPCTRL(BGPX,13,BGPY,0) D SET(X,1,1)
 .Q
 S X=" " D SET(X,1,1)
 Q
FOOTER ;EP
 ;I $G(BGPNGR09) D FOOTER10 Q
 D SET(" * Measure definition changed in 2009.",2,1)
 D SET("** Not official GPRA measure but included to show percentage of refusals with",2,1)
 D SET("respect to GPRA measure.",1,1)
 D SET(" + Site Previous and Site Baseline values are not applicable for this measure.",2,1)
 Q
FOOTER10 ;
 D SET("  * GPRA 2012 targets represented here are preliminary targets since they will",2,1)
 D SET("be adjusted for FY 2011 actual results and FY 2012 appropriations.",1,1)
 D SET(" ** Measure definition changed in 2009.",2,1)
 D SET("*** Not official GPRA measure but included to show percentage of refusals with",2,1)
 D SET("respect to GPRA measure.",1,1)
 D SET("  + Site Previous and Site Baseline values are not applicable for this measure.",2,1)
 Q
