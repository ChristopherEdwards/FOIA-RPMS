BGP9DH ; IHS/CMI/LAB - cover page for gpra 28 Apr 2008 11:30 AM 02 Jul 2008 9:25 AM ; 
 ;;9.0;IHS CLINICAL REPORTING;**1**;JUL 01, 2009
 ;
 S BGPQHDR=0,BGPHPG=0
 D HDR
 Q:BGPQHDR
 D MD
 D PD
 I BGPRTYPE=1,$G(BGPDESGP) W !!,"Designated Provider:  ",$P(^VA(200,BGPDESGP,0),U,1)
 D ENDTIME
 I BGPRTYPE=4,BGP9RPTH="C" D COMHDR
 I BGPRTYPE=4,BGP9RPTH="P" D PPHDR
 I BGPRTYPE=4,BGP9RPTH="A" D ALLHDR
 I BGPRTYPE=1,'$G(BGP9GPU),'$G(BGPSUMON) D GPRAHDR
 I BGPRTYPE=1,'$G(BGP9GPU),$G(BGPSUMON) D GPRAHDRS
 I BGPRTYPE=1,$G(BGP9GPU) D COMHDR
 I BGPRTYPE=6 D PEHDR
 I BGPRTYPE=7 D ONMHDR
 Q:BGPQHDR
 I $Y>(BGPIOSL-3) D HDR Q:BGPQHDR
 I $G(BGPEXPT),BGPRTYPE=1,'$G(BGPNGR09) W !!,"A file will be created called BG09",$P(^AUTTLOC(DUZ(2),0),U,10)_"."_BGPRPT,".",!,"It will reside in the public/export directory.",!,"This file should be sent to your Area Office.",!
 I $Y>(BGPIOSL-3) D HDR Q:BGPQHDR
 I $G(BGPEXPT),BGPRTYPE=7 W !!,"A file will be created called BG09",$P(^AUTTLOC(DUZ(2),0),U,10)_".ONM"_BGPRPT,".",!,"It will reside in the public/export directory.",!,"This file should be sent to your Area Office.",!
 I $Y>(BGPIOSL-3) D HDR Q:BGPQHDR
 I $G(BGPYWCHW)=2 W !!,"HT/WT filename:  ",BGPFN,!
 I BGPRTYPE=6,$G(BGPPEEXP) D  Q:BGPQHDR
 .I $Y>(BGPIOSL-3) D HDR Q:BGPQHDR
 .W !,"A file will be created called BG09",$P(^AUTTLOC(DUZ(2),0),U,10)_".PED"_BGPRPT," and will reside",!,"in the public/exort directory.",!,"This file should be sent to your Area Office.",!
 I BGPROT'="P",'$D(BGPGUI) D  Q:BGPQHDR
 .I $Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .W !,"A delimited output file called ",BGPDELF,!,"has been placed in the public directory for your use in Excel or some",!,"other software package.",!,"See your site manager to access this file.",!
 I $G(BGPALLPT) D  Q:BGPQHDR
 .I $Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .W !!,"All Communities Included.",!
 I BGP9RPTH="P" K BGPX,BGPQUIT
 I '$G(BGPALLPT),'$G(BGPSEAT) D  Q:BGPQHDR
 .I $Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .W !?10,"Community Taxonomy Name: ",$P(^ATXAX(BGPTAXI,0),U)
 I '$G(BGPALLPT),'$G(BGPSEAT) D  Q:BGPQHDR
 .W !?10,"The following communities are included in this report:",! D
 ..S BGPZZ="",BGPN=0,BGPY="" F  S BGPZZ=$O(BGPTAX(BGPZZ)) Q:BGPZZ=""!(BGPQHDR)  S BGPN=BGPN+1,BGPY=BGPY_$S(BGPN=1:"",1:";")_BGPZZ
 ..S BGPZZ=0,C=0 F BGPZZ=1:3:BGPN D  Q:BGPQHDR
 ...I $Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 ...W !?10,$E($P(BGPY,";",BGPZZ),1,20),?30,$E($P(BGPY,";",(BGPZZ+1)),1,20),?60,$E($P(BGPY,";",(BGPZZ+2)),1,20)
 Q:BGPQHDR
 I $G(BGPMFITI) W !!?10,"MFI Visit Location Taxonomy Name: ",$P(^ATXAX(BGPMFITI,0),U)
 I $G(BGPMFITI) W !?10,"The following Locations are used for patient visits in this report:",! D
 .S BGPZZ="",BGPN=0,BGPY="" F  S BGPZZ=$O(^ATXAX(BGPMFITI,21,"B",BGPZZ)) Q:BGPZZ=""  S BGPN=BGPN+1,BGPY=BGPY_$S(BGPN=1:"",1:";")_$P($G(^DIC(4,BGPZZ,0)),U)
 .S BGPZZ=0,C=0 F BGPZZ=1:3:BGPN D  Q:BGPQHDR
 ..I $Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 ..W !?10,$E($P(BGPY,";",BGPZZ),1,20),?30,$E($P(BGPY,";",(BGPZZ+1)),1,20),?60,$E($P(BGPY,";",(BGPZZ+2)),1,20)
 ..Q
 K BGPX,BGPQUIT
 Q
 ;
MD ;
 I BGPRTYPE=6 W !!,"Measures: Patient Education Performance Measures"
 I BGPRTYPE=4 W !!,"Measures: ",$P($T(@BGPINDT),";;",2)
 I BGPRTYPE=1 W !!,"Measures: GPRA, GPRA Developmental, and PART Denominators and Numerators and ",!,"Selected Other Clinical Denominators and Numerators"
 I BGPRTYPE=7 W !!,"Measures: Key Clinical Denominators and Numerators for Non-GPRA National",!,"Reporting"
 Q
 ;
PD ;
 I BGPRTYPE=1,$G(BGP9GPU) W !,"Population: ",$S(BGPBEN=1:"AI/AN Only (Classification 01)",BGPBEN=2:"non AI/AN Only (Classification NOT 01)",BGPBEN=3:"All (Both AI/AN and non AI/AN)",1:"")
 I BGPRTYPE=4,BGP9RPTH'="P" W !,"Population: ",$S(BGPBEN=1:"AI/AN Only (Classification 01)",BGPBEN=2:"non AI/AN Only (Classification NOT 01)",BGPBEN=3:"All (Both AI/AN and non AI/AN)",1:"")
 I BGPRTYPE=4,BGP9RPTH="P" W !,"Population:  ",$P(^DIBT(BGPSEAT,0),U)
 I BGPRTYPE=1,'$G(BGP9GPU)!(BGPRTYPE=7) W !!,"Population:  AI/AN Only (Classification 01)"
 I BGPRTYPE=6,'$G(BGPSEAT) W !,"Population: ",$S(BGPBEN=1:"AI/AN Only (Classification 01)",BGPBEN=2:"non AI/AN Only (Classification NOT 01)",BGPBEN=3:"All (Both AI/AN and non AI/AN)",1:"")
 I BGPRTYPE=6,$G(BGPSEAT) W !!,"Patient Population:  ",$P(^DIBT(BGPSEAT,0),U)
 I BGPRTYPE=7 W !,"Population: ",$S(BGPBEN=1:"AI/AN Only (Classification 01)",BGPBEN=2:"non AI/AN Only (Classification NOT 01)",BGPBEN=3:"All (Both AI/AN and non AI/AN)",1:"")
 Q
 ;
HDR ;EP
 I 'BGPHPG G HDR1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQHDR=1 Q
HDR1 ;
 S BGPHPG=BGPHPG+1 I BGPHPG'=1 W:$D(IOF) @IOF
 W !,$$CTR("Cover Page "_BGPHPG,80)
 I BGPRTYPE=4,$G(BGP9RPTH)="C" W !!,$$CTR("*** IHS 2009 Selected Measures with Community Specified Report ***",80) G N
 I BGPRTYPE=4,$G(BGP9RPTH)="A" W !!,$$CTR("*** IHS 2009 Selected Measures with All Communities Report ***",80) G N
 I BGPRTYPE=4,$G(BGP9RPTH)="P" W !!,$$CTR("*** IHS 2009 Selected Measures with Patient Panel Population Report ***",80)
 I BGPRTYPE=6,'$G(BGPEDPP) W !!,$$CTR("*** IHS 2009 Patient Education with Community Specified Report ***",80)
 I BGPRTYPE=6,$G(BGPEDPP) W !!,$$CTR("*** IHS 2009 Patient Education with Patient Panel Population Report ***",80)
 I BGPRTYPE=1,$G(BGPNGR09) W !!,$$CTR("*** IHS 2010 National GPRA & PART Report, Run Using 2009 Logic ***",80) G N
 I BGPRTYPE=1,$G(BGPDESGP) W !!,$$CTR("*** IHS 2009 National GPRA & PART Report by Designated Provider ***",80) G N
 I BGPRTYPE=1,'$G(BGP9GPU),'$G(BGPSUMON) W !!,$$CTR("*** IHS 2009 National GPRA & PART Report ***",80)
 I BGPRTYPE=1,'$G(BGP9GPU),$G(BGPSUMON) W !!,$$CTR("*** IHS 2009 National GPRA & PART Report Clinical Performance Summaries ***",80)
 I BGPRTYPE=1,$G(BGP9GPU) W !!,$$CTR("*** IHS 2009 GPRA Performance & PART Report ***",80)
 I BGPRTYPE=7 W !!,$$CTR("*** IHS 2009 Other National Measures Report ***",80)
N ;
 I $G(BGPCPPL) W !,$$CTR("** Including Comprehensive Patient List **",80)
 W !,$$CTR($$RPTVER^BGP9BAN,80)
 W !,$$CTR("Date Report Run: "_$$FMTE^XLFDT(DT),80)
 W !,$$CTR("Site where Run: "_$P(^DIC(4,DUZ(2),0),U),80)
 W !,$$CTR("Report Generated by: "_$$USR,80)
 S X="Report Period:  "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) W !,$$CTR(X,80)
 S X="Previous Year Period:  "_$$FMTE^XLFDT(BGPPBD)_" to "_$$FMTE^XLFDT(BGPPED) W !,$$CTR(X,80)
 S X="Baseline Period:  "_$$FMTE^XLFDT(BGPBBD)_" to "_$$FMTE^XLFDT(BGPBED) W !,$$CTR(X,80)
 W !!
 Q
PEHDR ;
 D PEHDR^BGP9DH1
 Q
COMHDR ;
 D COMHDR^BGP9DH1
 Q
ONMHDR ;
 D ONMHDR^BGP9DH1
 Q
 ;
PPHDR ;
 D PPHDR^BGP9DH1
 Q
DENOMHDR ;
 W !
 Q:$G(BGPSEAT)
 S BGPX=$O(^BGPCTRL("B",2009,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,13,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I $Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .W !,^BGPCTRL(BGPX,13,BGPY,0)
 .Q
 W !
 Q
ALLHDR ;
 D ALLHDR^BGP9DH1
 Q
AREAHDR ;
 W !
 S BGPX=$O(^BGPCTRL("B",2009,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,15,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I $Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .W !,^BGPCTRL(BGPX,15,BGPY,0)
 .Q
 Q
GPRAHDRA ;
 W !
 S BGPX=$O(^BGPCTRL("B",2009,0))
 S BGPNODEP=$S(BGPCHSO&('BGPCHSN):23,(BGPCHSO+BGPCHSN)=2:29,1:14)
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I $Y>(BGPIOSL-2) D AHDR^BGP9DH1 Q:BGPQHDR
 .W !,^BGPCTRL(BGPX,BGPNODEP,BGPY,0)
 .Q
 Q
GPRAHDRS ;
 D GPRAHDRS^BGP9DH1
 Q
COMHDRA ;
 W !
 S BGPX=$O(^BGPCTRL("B",2009,0))
 S BGPNODEP=$S(BGPCHSO&('BGPCHSN):24,(BGPCHSO+BGPCHSN)=2:31,1:17)
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I $Y>(BGPIOSL-2) D AHDR^BGP9DH1 Q:BGPQHDR
 .W !,^BGPCTRL(BGPX,BGPNODEP,BGPY,0)
 .Q
 I $G(BGP9GPU) W !,"See last pages of this report for Performance Summaries."
 Q
GPRAHDR ;
 W !
 S BGPNODEP=$S(BGPCHSO:23,1:14)
 S BGPX=$O(^BGPCTRL("B",2009,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I $Y>(BGPIOSL-2) D HDR Q:BGPQHDR
 .W !,^BGPCTRL(BGPX,BGPNODEP,BGPY,0)
 .Q
 Q
ENDTIME ;
 I $D(BGPET) S BGPTS=(86400*($P(BGPET,",")-$P(BGPBT,",")))+($P(BGPET,",",2)-$P(BGPBT,",",2)),BGPHR=$P(BGPTS/3600,".") S:BGPHR="" BGPHR=0 D
 .S BGPTS=BGPTS-(BGPHR*3600),BGPM=$P(BGPTS/60,".") S:BGPM="" BGPM=0 S BGPTS=BGPTS-(BGPM*60),BGPS=BGPTS W !!,"RUN TIME (H.M.S): ",BGPHR,".",BGPM,".",BGPS
 Q
 ;
AREACP ;EP - 
 S BGPQHDR=0,BGPHPG=0
 D AHDR^BGP9DH1
 Q:BGPQHDR
 D MD
 D PD
 D ENDTIME
 I BGPRTYPE=6 D PEDCP Q
 S BGPCHSO="",X=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  I $P(^BGPGPDCN(X,0),U,17) S BGPCHSO=1
 S BGPCHSN="",X=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  I '$P(^BGPGPDCN(X,0),U,17) S BGPCHSN=1
 I BGPRTYPE=1,'$G(BGP9GPU) D GPRAHDRA
 I BGPRTYPE=1,$G(BGP9GPU) D COMHDRA
 I BGPRTYPE=7 D ONMHDR
 I $G(BGPEXCEL),'$G(BGP9GPU),BGPRTYPE=1 W !!,"National GPRA filenames:  ",!?15,BGPFGNT1,!?15,BGPFGNT2,!?15,BGPFGNT3,!?15,BGPFGNT4
 I $G(BGPEXCEL),BGPRTYPE=7 W !,"Other National Measures filenames: ",!,?15,BGPFONN1,!?15,BGPFONN2,!?15,BGPFONN3
 I BGPROT'="P",'$D(BGPGUI) W !!,"A delimited output file called ",BGPDELF,!,"has been placed in the public directory for your use in Excel or some",!,"other software package.  See your site manager to access this file.",!
 W !!?1,"Report includes data from the following facilities:"
 NEW BGPX
 S BGPX="",BGPC=0 F  S BGPX=$O(BGPSUL(BGPX)) Q:BGPX=""!(BGPQHDR)  D
 .I $Y>(BGPIOSL-3) D AHDR^BGP9DH1 Q:BGPQHDR
 .S BGPC=BGPC+1
 .S X=$P(^BGPGPDCN(BGPX,0),U,9),X=$O(^AUTTLOC("C",X,0)) S X=$S(X:$P(^DIC(4,X,0),U),1:"?????")
 .W !?3,BGPC,".  ",$S($P(^BGPGPDCN(BGPX,0),U,17):"*",1:""),X
 W !!?1,"The following communities are included in this report:"
 NEW BGPX
 S BGPX="",BGPC=0 F  S BGPX=$O(BGPSUL(BGPX)) Q:BGPX=""!(BGPQHDR)  D
 .I $Y>(BGPIOSL-3) D AHDR^BGP9DH1 Q:BGPQHDR
 .S BGPC=BGPC+1
 .S X=$P(^BGPGPDCN(BGPX,0),U,9),X=$O(^AUTTLOC("C",X,0)) S X=$S(X:$P(^DIC(4,X,0),U),1:"?????")
 .W !!?3,BGPC,".  ",$S($P(^BGPGPDCN(BGPX,0),U,17):"*",1:""),X
 .W !?3,"Community Taxonomy Name: ",$P(^BGPGPDCN(BGPX,0),U,18)
 .;W !?5,"Communities: " 
 .S BGPXX=0,BGPXN=0,BGPXY="" F  S BGPXX=$O(^BGPGPDCN(BGPX,9999,BGPXX)) Q:BGPXX'=+BGPXX  S BGPXN=BGPXN+1,BGPXY=BGPXY_$S(BGPXN=1:"",1:";")_$P(^BGPGPDCN(BGPX,9999,BGPXX,0),U)
 .S BGPX1=0,C=0 F BGPX1=1:3:BGPXN D
 ..I $Y>(BGPIOSL-2) D AHDR^BGP9DH1 Q:BGPQHDR
 ..W !?10,$E($P(BGPXY,";",BGPX1),1,20),?30,$E($P(BGPXY,";",(BGPX1+1)),1,20),?60,$E($P(BGPXY,";",(BGPX1+2)),1,20)
 .Q:BGPQHDR
 .I $O(^BGPGPDCN(BGPX,1111,0)) D
 ..I $Y>(BGPIOSL-2) D AHDR^BGP9DH1 Q:BGPQHDR
 ..W !!?5,"MFI Visit Locations: " S BGPXX=0,BGPXN=0,BGPXY="" F  S BGPXX=$O(^BGPGPDCN(BGPX,1111,BGPXX)) Q:BGPXX'=+BGPXX  S BGPXN=BGPXN+1,BGPXY=BGPXY_$S(BGPXN=1:"",1:";")_$P(^BGPGPDCN(BGPX,1111,BGPXX,0),U)
 ..S BGPX1=0,C=0 F BGPX1=1:3:BGPXN Q:BGPQHDR  W !?10,$E($P(BGPXY,";",BGPX1),1,18),?30,$E($P(BGPXY,";",(BGPX1+1)),1,20),?60,$E($P(BGPXY,";",(BGPX1+2)),1,18)
 .Q
 Q:BGPQHDR
 I BGPCHSO D
 .I $Y>(BGPIOSL-2) D AHDR^BGP9DH1 Q:BGPQHDR
 .W !!,"* CHS-only site.  Uses Active Clinical CHS Population definition vs. Active",!,"Clinical."
 K BGPX,BGPQUIT
 Q
PEDCP ;
 D PEHDR
 I BGPROT'="P",'$D(BGPGUI) W !!,"A delimited output file called ",BGPDELF,!,"has been placed in the public directory for your use in Excel or some",!,"other software package.  See your site manager to access this file.",!
 W !!?1,"Report includes data from the following facilities:"
 NEW BGPX
 S BGPX="",BGPC=0 F  S BGPX=$O(BGPSUL(BGPX)) Q:BGPX=""!(BGPQHDR)  D
 .I $Y>(BGPIOSL-3) D AHDR^BGP9DH1 Q:BGPQHDR
 .S BGPC=BGPC+1
 .S X=$P(^BGPPEDCN(BGPX,0),U,9),X=$O(^AUTTLOC("C",X,0)) S X=$S(X:$P(^DIC(4,X,0),U),1:"?????")
 .W !?3,BGPC,".  ",$S($P(^BGPPEDCN(BGPX,0),U,17):"*",1:""),X
 W !!?1,"The following communities are included in this report:"
 NEW BGPX
 S BGPX="",BGPC=0 F  S BGPX=$O(BGPSUL(BGPX)) Q:BGPX=""!(BGPQHDR)  D
 .I $Y>(BGPIOSL-3) D AHDR^BGP9DH1 Q:BGPQHDR
 .S BGPC=BGPC+1
 .S X=$P(^BGPPEDCN(BGPX,0),U,9),X=$O(^AUTTLOC("C",X,0)) S X=$S(X:$P(^DIC(4,X,0),U),1:"?????")
 .W !!?3,BGPC,".  ",$S($P(^BGPPEDCN(BGPX,0),U,17):"*",1:""),X
 .W !?5,"Communities: " S BGPXX=0,BGPXN=0,BGPXY="" F  S BGPXX=$O(^BGPPEDCN(BGPX,9999,BGPXX)) Q:BGPXX'=+BGPXX  S BGPXN=BGPXN+1,BGPXY=BGPXY_$S(BGPXN=1:"",1:";")_$P(^BGPPEDCN(BGPX,9999,BGPXX,0),U)
 .S BGPX1=0,C=0 F BGPX1=1:3:BGPXN D
 ..I $Y>(BGPIOSL-2) D AHDR^BGP9DH1 Q:BGPQHDR
 ..W !?10,$E($P(BGPXY,";",BGPX1),1,20),?30,$E($P(BGPXY,";",(BGPX1+1)),1,20),?60,$E($P(BGPXY,";",(BGPX1+2)),1,20)
 .Q:BGPQHDR
 .I $O(^BGPPEDCN(BGPX,1111,0)) D
 ..I $Y>(BGPIOSL-2) D AHDR^BGP9DH1 Q:BGPQHDR
 ..W !!?5,"MFI Visit Locations: " S BGPXX=0,BGPXN=0,BGPXY="" F  S BGPXX=$O(^BGPPEDCN(BGPX,1111,BGPXX)) Q:BGPXX'=+BGPXX  S BGPXN=BGPXN+1,BGPXY=BGPXY_$S(BGPXN=1:"",1:";")_$P(^BGPPEDCN(BGPX,1111,BGPXX,0),U)
 ..S BGPX1=0,C=0 F BGPX1=1:3:BGPXN Q:BGPQHDR  W !?10,$E($P(BGPXY,";",BGPX1),1,18),?30,$E($P(BGPXY,";",(BGPX1+1)),1,20),?60,$E($P(BGPXY,";",(BGPX1+2)),1,18)
 .Q
 Q:BGPQHDR
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
A ;;AREA Director Performance Measures (All)
H ;;HEDIS Measures (All)
D ;;Diabetes-Related Measures
C ;;Cardiovascular Disease Prevention for At-Risk Patients
S ;;Selected Measures (User Defined)
W ;;Women's Health-Related Measures
P ;;Prevention Related Indictors
 ;
