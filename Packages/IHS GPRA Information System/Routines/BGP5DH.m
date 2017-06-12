BGP5DH ; IHS/CMI/LAB - cover page for gpra 28 Apr 2010 11:30 AM 02 Jul 2010 9:25 AM ; 19 Feb 2015  11:07 AM
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;
 S BGPQHDR=0,BGPHPG=0
 D HDR
 I BGPPTYPE="P" Q:BGPQHDR
 D MD
 D PD
 I BGPRTYPE=1,$G(BGPDESGP) D W^BGP5DP("Designated Provider:  "_$P(^VA(200,BGPDESGP,0),U,1),0,2,BGPPTYPE)
 D ENDTIME
 I $G(BGPDASH) D DASH^BGP5DH2 G N1
 I BGPRTYPE=4,BGPYRPTH="C" D COMHDR
 I BGPRTYPE=4,BGPYRPTH="P" D PPHDR
 I BGPRTYPE=4,BGPYRPTH="A" D ALLHDR
 I BGPRTYPE=1,'$G(BGPYGPU),'$G(BGPSUMON) D GPRAHDR
 I BGPRTYPE=1,'$G(BGPYGPU),$G(BGPSUMON) D GPRAHDRS
 I BGPRTYPE=1,$G(BGPYGPU),'$G(BGPSEAT) D GPRAHDR
 I BGPRTYPE=1,$G(BGPYGPU),$G(BGPSEAT) D GPUPPHDR^BGP5DH1
 I BGPRTYPE=6 D PEHDR
 I BGPRTYPE=7 D ONMHDR
N1 I BGPPTYPE="P" Q:BGPQHDR
 I BGPPTYPE="P",$Y>(BGPIOSL-3) D HDR Q:BGPQHDR
 I $G(BGPEXPT),BGPRTYPE=1 D   ;,'$G(BGPNGR09) D
 .D W^BGP5DP("A file will be created called BG151"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_BGPRPT,0,2,BGPPTYPE)
 .D W^BGP5DP("It will reside in the "_BGPUF_" directory.",0,1,BGPPTYPE)
 .D W^BGP5DP("This file should be sent to your Area Office.",0,1,BGPPTYPE)
 .D W^BGP5DP("",0,1,BGPPTYPE)
 I BGPPTYPE="P",$Y>(BGPIOSL-3) D HDR Q:BGPQHDR
 I $G(BGPEXPT),BGPRTYPE=7 D
 .D W^BGP5DP("A file will be created called BG151"_$P(^AUTTLOC(DUZ(2),0),U,10)_".ONM"_BGPRPT,0,2,BGPPTYPE)
 .D W^BGP5DP("It will reside in the "_BGPUF_" directory.",0,1,BGPPTYPE)
 .D W^BGP5DP("This file should be sent to your Area Office.",0,1,BGPPTYPE)
 .D W^BGP5DP("",0,1,BGPPTYPE)
 I BGPPTYPE="P",$Y>(BGPIOSL-3) D HDR Q:BGPQHDR
 I BGPRTYPE=6,$G(BGPPEEXP) D  Q:BGPQHDR
 .I BGPPTYPE="P",$Y>(BGPIOSL-3) D HDR Q:BGPQHDR
 .D W^BGP5DP("A file will be created called BG151"_$P(^AUTTLOC(DUZ(2),0),U,10)_".PED"_BGPRPT_" and will reside",0,1,BGPPTYPE)
 .D W^BGP5DP("in the "_BGPUF_" directory.  This file should be sent to your Area Office.",0,1,BGPPTYPE)
 .D W^BGP5DP("",0,1,BGPPTYPE)
 I BGPROT'="P",'$D(BGPGUI) D  I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .I BGPDELF]"" D W^BGP5DP("A delimited output file called "_BGPDELF,0,2,BGPPTYPE) D
 ..D W^BGP5DP("has been placed in the "_$$GETDEDIR^BGP5UTL2()_" directory for your use in Excel or some",0,1,BGPPTYPE),W^BGP5DP("other software package.  See your site manager to access this file.",0,1,BGPPTYPE)
 I $G(BGPALLPT) D  I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .D W^BGP5DP("All Communities Included.",0,2,BGPPTYPE)
 I BGPYRPTH="P" K BGPX,BGPQUIT
 I '$G(BGPALLPT),'$G(BGPSEAT) D  I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .D W^BGP5DP("Community Taxonomy Name: "_$P(^ATXAX(BGPTAXI,0),U),0,2,BGPPTYPE,1,10)
 .D W^BGP5DP("The following communities are included in this report:",0,1,BGPPTYPE,1,10) D
 ..S BGPZZ="",N=0,Y="" F  S BGPZZ=$O(BGPTAX(BGPZZ)) Q:BGPZZ=""  S N=N+1,Y=Y_$S(N=1:"",1:";")_BGPZZ
 ..S BGPZZ=0,C=0 F BGPZZ=1:3:N D
 ...D W^BGP5DP($E($P(Y,";",BGPZZ),1,20),0,1,BGPPTYPE,1,10)
 ...D W^BGP5DP($E($P(Y,";",(BGPZZ+1)),1,20),0,0,BGPPTYPE,2,30)
 ...D W^BGP5DP($E($P(Y,";",(BGPZZ+2)),1,20),0,0,BGPPTYPE,3,60)
 ...Q
 D W^BGP5DP("",0,1,BGPPTYPE)
 I BGPRTYPE'=6,BGPPTYPE="D" D W^BGP5DP("ENDCOVERPAGE",0,1,BGPPTYPE)
 K BGPX,BGPQUIT
 Q
 ;
MD ;EP
 I $G(BGPDASH) D W^BGP5DP("Measures: GPRA Denominators and Numerators",0,1,BGPPTYPE) Q
 I BGPRTYPE=6 D W^BGP5DP("Measures: Patient Education Performance Measures",0,1,BGPPTYPE) Q
 I BGPRTYPE=4 D W^BGP5DP("Measures: "_$P($T(@BGPINDK),";;",2),0,1,BGPPTYPE) Q
 I BGPRTYPE=1 D W^BGP5DP("Measures: GPRA Developmental, GPRA/GPRAMA Denominators and Numerators and",0,1,BGPPTYPE),W^BGP5DP("Selected Other Clinical Denominators and Numerators",0,1,BGPPTYPE) Q
 I BGPRTYPE=7 D W^BGP5DP("Measures: Key Clinical Denominators and Numerators for Non-GPRA National",0,1,BGPPTYPE),W^BGP5DP("Reporting",0,1,BGPPTYPE) Q
 Q
 ;
PD ;EP
 I BGPRTYPE=1,$G(BGPYGPU),'$G(BGPSEAT) D W^BGP5DP("Population: "_$S(BGPBEN=1:"AI/AN Only (Classification 01)",BGPBEN=2:"non AI/AN Only (Classification NOT 01)",BGPBEN=3:"All (Both AI/AN and non AI/AN)",1:""),0,1,BGPPTYPE)
 I BGPRTYPE=1,$G(BGPYGPU),$G(BGPSEAT) D W^BGP5DP("Patient Population:  "_$P(^DIBT(BGPSEAT,0),U),0,2,BGPPTYPE)
 I BGPRTYPE=4,BGPYRPTH'="P" D W^BGP5DP("Population: "_$S(BGPBEN=1:"AI/AN Only (Classification 01)",BGPBEN=2:"non AI/AN Only (Classification NOT 01)",BGPBEN=3:"All (Both AI/AN and non AI/AN)",1:""),0,1,BGPPTYPE)
 I BGPRTYPE=4,BGPYRPTH="P" D W^BGP5DP("Population:  "_$P(^DIBT(BGPSEAT,0),U),0,1,BGPPTYPE)
 I BGPRTYPE=1,'$G(BGPYGPU)!(BGPRTYPE=7) D W^BGP5DP("Population:  AI/AN Only (Classification 01)",0,2,BGPPTYPE)
 I BGPRTYPE=6,'$G(BGPSEAT) D W^BGP5DP("Population: "_$S(BGPBEN=1:"AI/AN Only (Classification 01)",BGPBEN=2:"non AI/AN Only (Classification NOT 01)",BGPBEN=3:"All (Both AI/AN and non AI/AN)",1:""),0,1,BGPPTYPE)
 I BGPRTYPE=6,$G(BGPSEAT) D W^BGP5DP("Patient Population:  "_$P(^DIBT(BGPSEAT,0),U),0,2,BGPPTYPE)
 I BGPRTYPE=7 D W^BGP5DP("Population: "_$S(BGPBEN=1:"AI/AN Only (Classification 01)",BGPBEN=2:"non AI/AN Only (Classification NOT 01)",BGPBEN=3:"All (Both AI/AN and non AI/AN)",1:""),0,1,BGPPTYPE)
 Q
 ;
HDR ;EP
 I BGPPTYPE="P",'BGPHPG G HDR1
 I BGPPTYPE="P" I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQHDR=1 Q
HDR1 ;
 I BGPPTYPE="P" S BGPHPG=BGPHPG+1 I BGPHPG'=1 W:$D(IOF) @IOF
 I $G(BGPGUI),BGPPTYPE="P",BGPHPG'=1 D W^BGP5DP("ZZZZZZZ",0,0,BGPPTYPE),W^BGP5DP("",0,1,BGPPTYPE)  ;GUI
 D W^BGP5DP("Cover Page",1,2,BGPPTYPE)
 I $G(BGPNPL) D W^BGP5DP("*** IHS 2015 GPRA/GPRAMA Patient List ***",1,2,BGPPTYPE) G N
 I $G(BGPDASH) D W^BGP5DP("*** IHS 2015 National GPRA Dashboard ***",1,2,BGPPTYPE) G N
 I BGPRTYPE=4,$G(BGPYRPTH)="C" D W^BGP5DP("*** IHS 2015 Selected Measures with Community Specified Report ***",1,2,BGPPTYPE) G N
 I BGPRTYPE=4,$G(BGPYRPTH)="A" D W^BGP5DP("*** IHS 2015 Selected Measures with All Communities Report ***",1,2,BGPPTYPE) G N
 I BGPRTYPE=4,$G(BGPYRPTH)="P" D W^BGP5DP("*** IHS 2015 Selected Measures with Patient Panel Population Report ***",1,2,BGPPTYPE) G N
 I BGPRTYPE=6,'$G(BGPEDPP) D W^BGP5DP("*** IHS 2015 Patient Education with Community Specified Report ***",1,2,BGPPTYPE) G N
 I BGPRTYPE=6,$G(BGPEDPP) D W^BGP5DP("*** IHS 2015 Patient Education with Patient Panel Population Report ***",1,2,BGPPTYPE) G N
 I BGPRTYPE=1,$G(BGPNGR09) D W^BGP5DP("*** IHS 2015 National GPRA/GPRAMA Report, Run Using 2015 Logic ***",1,2,BGPPTYPE) G N
 I BGPRTYPE=1,$G(BGPDESGP) D W^BGP5DP("*** IHS 2015 National GPRA/GPRAMA Report by Designated Provider ***",1,2,BGPPTYPE) G N
 I BGPRTYPE=1,'$G(BGPYGPU),'$G(BGPSUMON) D W^BGP5DP("*** IHS 2015 National GPRA/GPRAMA Report ***",1,2,BGPPTYPE)
 I BGPRTYPE=1,'$G(BGPYGPU),$G(BGPSUMON) D W^BGP5DP("*** IHS 2015 National GPRA/GPRAMA Report Clinical Performance Summaries ***",1,2,BGPPTYPE)
 I BGPRTYPE=1,$G(BGPYGPU) D W^BGP5DP("*** IHS 2015 GPRA/GPRAMA Performance Report ***",1,2,BGPPTYPE)
 I BGPRTYPE=7 D W^BGP5DP("*** IHS 2015 Other National Measures Report ***",1,2,BGPPTYPE)
N ;
 I $G(BGPCPPL) D W^BGP5DP("** Including Comprehensive Patient List **",1,1,BGPPTYPE)
 D W^BGP5DP($$RPTVER^BGP5BAN,1,1,BGPPTYPE)
 D W^BGP5DP("Date Report Run: "_$$FMTE^XLFDT(DT),1,1,BGPPTYPE)
 D W^BGP5DP("Site where Run: "_$P(^DIC(4,DUZ(2),0),U),1,1,BGPPTYPE)
 D W^BGP5DP("Report Generated by: "_$$USR,1,1,BGPPTYPE)
 S X="Report Period:  "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) D W^BGP5DP(X,1,1,BGPPTYPE)
 S X="Previous Year Period:  "_$$FMTE^XLFDT(BGPPBD)_" to "_$$FMTE^XLFDT(BGPPED) D W^BGP5DP(X,1,1,BGPPTYPE)
 I '$G(BGPDASH) S X="Baseline Period:  "_$$FMTE^XLFDT(BGPBBD)_" to "_$$FMTE^XLFDT(BGPBED) D W^BGP5DP(X,1,1,BGPPTYPE)
 D W^BGP5DP("",0,2,BGPPTYPE)
 Q
PEHDR ;
 D PEHDR^BGP5DH1
 Q
COMHDR ;
 D COMHDR^BGP5DH1
 Q
ONMHDR ;EP
 D ONMHDR^BGP5DH1
 Q
 ;
PPHDR ;
 D PPHDR^BGP5DH1
 Q
DENOMHDR ;
 D W^BGP5DP("",0,1,BGPPTYPE)
 Q:$G(BGPSEAT)
 S BGPX=$O(^BGPCTRL("B",2015,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,13,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .D W^BGP5DP(^BGPCTRL(BGPX,13,BGPY,0),0,1,BGPPTYPE)
 .Q
 D W^BGP5DP("",0,1,BGPPTYPE)
 Q
ALLHDR ;
 D ALLHDR^BGP5DH1
 Q
AREAHDR ;
 D W^BGP5DP("",0,1,BGPPTYPE)
 S BGPX=$O(^BGPCTRL("B",2015,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,15,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .D W^BGP5DP(^BGPCTRL(BGPX,15,BGPY,0),0,1,BGPPTYPE)
 .Q
 Q
GPRAHDRS ;EP
 D GPRAHDRS^BGP5DH1
 Q
COMHDRA ;EP
 D W^BGP5DP("",0,1,BGPPTYPE)
 S BGPX=$O(^BGPCTRL("B",2015,0))
 S BGPNODEP=17
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D AHDR^BGP5DH1 Q:BGPQHDR
 .D W^BGP5DP(^BGPCTRL(BGPX,BGPNODEP,BGPY,0),0,1,BGPPTYPE)
 .Q
 I $G(BGPYGPU) D W^BGP5DP("See last pages of this report for Performance Summaries.",0,2,BGPPTYPE)
 Q
GPRAHDR ;
 D W^BGP5DP("",0,1,BGPPTYPE)
 S BGPNODEP=14
 S BGPX=$O(^BGPCTRL("B",2015,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .D W^BGP5DP(^BGPCTRL(BGPX,BGPNODEP,BGPY,0),0,1,BGPPTYPE)
 .Q
 Q
ENDTIME ;EP
 I $D(BGPET) S BGPTS=(86400*($P(BGPET,",")-$P(BGPBT,",")))+($P(BGPET,",",2)-$P(BGPBT,",",2)),BGPHR=$P(BGPTS/3600,".") S:BGPHR="" BGPHR=0 D
 .S BGPTS=BGPTS-(BGPHR*3600),BGPM=$P(BGPTS/60,".") S:BGPM="" BGPM=0 S BGPTS=BGPTS-(BGPM*60),BGPS=BGPTS D W^BGP5DP("RUN TIME (H.M.S): "_BGPHR_"."_BGPM_"."_BGPS,0,2,BGPPTYPE)
 Q
 ;
AREACP ;EP -
 D AREACP^BGP5DH1
 Q
PEDCP ;EP
 D PEHDR
 I BGPROT'="P",'$D(BGPGUI) W !!,"A delimited output file called ",BGPDELF,!,"has been placed in the "_$$GETDEDIR^BGP5UTL2()_" directory for your use in Excel or some",!,"other software package.  See your site manager to access this file.",!
 D W^BGP5DP("Report includes data from the following facilities: ",0,2,BGPPTYPE)
 NEW BGPX
 S BGPX="",BGPC=0 F  S BGPX=$O(BGPSUL(BGPX)) Q:BGPX=""  D
 .S X=$P(^BGPPEDCK(BGPX,0),U,9),X=$O(^AUTTLOC("C",X,0)) S X=$S(X:$P(^DIC(4,X,0),U),1:"?????")
 .S BGPC=BGPC+1,X=BGPC_".  "_$S($P(^BGPPEDCK(BGPX,0),U,17):"*",1:"")_X D W^BGP5DP(X,0,1,BGPPTYPE,1,3)
 .Q
 S X=" " D W^BGP5DP(X,0,1,BGPPTYPE)
 S X="The following communities are included in this report:" D W^BGP5DP(X,0,1,BGPPTYPE,1,1)
 S BGPX="",BGPC=0 F  S BGPX=$O(BGPSUL(BGPX)) Q:BGPX=""  D
 .S X=$P(^BGPPEDCK(BGPX,0),U,9),X=$O(^AUTTLOC("C",X,0)) S X=$S(X:$P(^DIC(4,X,0),U),1:"?????")
 .S BGPC=BGPC+1,X=BGPC_".  "_$S($P(^BGPPEDCK(BGPX,0),U,17):"*",1:"")_X D W^BGP5DP(X,0,1,BGPPTYPE,1,3)
 .;S X="Communities: " D W^BGP5DP(X,0,1,BGPPTYPE,1,5)
 .S X="Community Taxonomy Name: "_$P(^BGPPEDCK(BGPX,0),U,18) D W^BGP5DP(X,0,1,BGPPTYPE,1,5)
 .S BGPXX=0,BGPXN=0,BGPXY="" F  S BGPXX=$O(^BGPPEDCK(BGPX,9999,BGPXX)) Q:BGPXX'=+BGPXX  S BGPXN=BGPXN+1,BGPXY=BGPXY_$S(BGPXN=1:"",1:";")_$P(^BGPPEDCK(BGPX,9999,BGPXX,0),U)
 .S BGPX1=0,C=0 F BGPX1=1:3:BGPXN D
 ..D W^BGP5DP($E($P(BGPXY,";",BGPX1),1,20),0,1,BGPPTYPE,1,10)
 ..D W^BGP5DP($E($P(BGPXY,";",(BGPX1+1)),1,20),0,0,BGPPTYPE,2,30)
 ..D W^BGP5DP($E($P(BGPXY,";",(BGPX1+2)),1,20),0,0,BGPPTYPE,3,60)
 ..Q
 .Q
 D W^BGP5DP(" ",0,1,BGPPTYPE)
 I BGPPTYPE="P" Q:BGPQHDR
 K BGPX,BGPQUIT
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 I $D(DIRUT) S BGPQHDR=1
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
 ;;
E ;;Elder Care-Related Measures
G ;;GPRA Measures (All)
A ;;Asthma Related Measures
H ;;HEDIS Measures (All)
D ;;Diabetes-Related Measures
C ;;Cardiovascular Disease Prevention for At-Risk Patients
S ;;Selected Measures (User Defined)
W ;;Women's Health-Related Measures
P ;;Pharmacy Quality Alliance
I ;;Improving Patient Care
 ;
