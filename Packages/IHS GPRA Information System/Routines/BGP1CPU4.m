BGP1CPU4 ; IHS/CMI/LAB - calc CMS measures ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
WPOSTINF ;EP
 I $Y>(BGPIOSL-8) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Post-Operative Infection?  ",BGPPOSTI
 I BGPPOSTI="" Q
 W !?2,"NOTE:  Review patient's chart to determine if patient should be excluded"
 W !,"to see if all conditions are true: 1) there is physician/APN/PA documentation"
 W !,"the patient is being treated for an infection, 2) infection occurred during"
 W !,"specified timeframe, and 3) where treatment was administered via an "
 W !,"antibiotic administration route listed in the SIP inclusions for the"
 W !,"Data Element 'Antibiotic Administration Route.'"
 Q
 ;
PERI ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,$S(BGPPEX[1:"*",1:""),"Preoperative Infectious Disease Diagnosis?  ",$P($$ADMPRIM^BGP1CU5(BGPVINP,"BGP CMS INFECTIOUS DXS"),U,2)
 Q
 ;
WANTIRX ;EP
 S X=0,C=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+3)) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Recent Antibiotic Rx Status:  "
 I $D(BGPDATA) S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 ;W !
 Q
 ;
OTHSURG ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Other Surgery with Anesthesia?  "
 K BGPG
 K BGPY S BGPC=0,F=""
 K BGPG
 S Y="BGPG("
 S X=DFN_"^ALL PROCEDURES;DURING "_$$VD^APCLV(BGPVSIT)_"-"_$$DSCH^BGP1CU(BGPVINP) S E=$$START1^APCLDF(X,Y)
 S Y=0 F  S Y=$O(BGPG(Y)) Q:Y'=+Y  S X=+$P(BGPG(Y),U,4) D
 .Q:'$D(^AUPNVPRC(X,0))
 .Q:$P(^AUPNVPRC(X,0),U)=$P(BGPPROC(1),U,2)
 .;Q:$P(^AUPNVPRC(X,0),U,8)'="Y"
 .S D=$S($P(^AUPNVPRC(X,0),U,6)]"":$P(^AUPNVPRC(X,0),U,6),1:$P($P(BGPVSIT0,U),"."))
 .S E=$P(BGPPROC(1),U,3)
 .I $$ABS^XLFMTH($$FMDIFF^XLFDT(D,E))>4 Q  ;more than 4 days
 .W !?4,$$VAL^XBDIQ1(9000010.08,X,.01),"  ",$$DATE^BGP1UTL(D),"  ",$$VAL^XBDIQ1(9000010.08,X,.04) S F=1
 Q:'F
 W !,"NOTE:  To determine if patient should be excluded, review patients chart"
 W !,"to determine if anesthesia was general or spinal anesthesia and occurred"
 W !,"during the specified timeframe."
 Q
 ;
INF ;EP
 I $Y>(BGPIOSL-5) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Infection Documented at Time of Surgery?  ",$S($P(BGPPROC(1),U,4)="":"NO",1:$P(BGPPROC(1),U,4))
 I BGPPROC(1)="" Q
 I $P(BGPPROC(1),U,4)="" Q
 I $P(BGPPROC(1),U,4)["N" Q
 W !,"NOTE:  Review patient's chart to determine if patient should be excluded"
 W !,"when infection was present to see if infection was documented by "
 W !,"physician/APN/PA prior to this surgery."
 Q
WOTHPROC ;EP
 K BGPXX
 S BGPC=0
 S BGPB=(9999999-$$DSCH^BGP1CU(BGPVINP))-1,BGPE=9999999-$P($P(^AUPNVSIT(BGPVSIT,0),U),".")
 F  S BGPB=$O(^AUPNVPRC("AA",DFN,BGPB)) Q:BGPB'=+BGPB!(BGPB>BGPE)  D
 .S X=0 F  S X=$O(^AUPNVPRC("AA",DFN,BGPB,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVPRC(X,0))
 ..Q:$P(^AUPNVPRC(X,0),U)=$P(BGPPROC(1),U,2)
 ..S BGPC=BGPC+1,BGPXX(BGPC)=$$VAL^XBDIQ1(9000010.08,X,.01)_"  "_$$VAL^XBDIQ1(9000010.08,X,.04)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,Y,D,V
 S BGPB=9999999-$$DSCH^BGP1CU(BGPVINP),BGPE=9999999-$P($P(^AUPNVSIT(BGPVSIT,0),U),".")
 F  S BGPB=$O(^AUPNVSIT("AA",DFN,BGPB)) Q:BGPB=""!($P(BGPB,".")>BGPE)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",DFN,BGPB,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S BGPC=BGPC+1,BGPXX(BGPC)=$$VAL^XBDIQ1(9000010.18,X,.01)_"  "_$P($$CPT^ICPTCOD($P(^AUPNVCPT(X,0),U),(9999999-BGPB)),U,3)
 ...Q
 ..Q
 .Q
 S (C,X)=0 F  S X=$O(BGPXX(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+3)) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !?2,"Other Procedures for this Visit:"
 S BGPX=0 F  S BGPX=$O(BGPXX(BGPX)) Q:BGPX'=+BGPX  W !?4,BGPXX(BGPX)
 Q
 ;
WPP1 ;EP
 I $Y>(BGPIOSL-4) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !?2,"Principle Procedure:  ",$P(BGPPROC(1),U,1)
 S X=1 F  S X=$O(BGPPROC(X)) Q:X'=+X  W !?23,$P(BGPPROC(X),U,1)
 W !?2,$S(BGPPPD<$P($P(BGPVSIT0,U),"."):"*",1:""),"Principle Procedure Date:  ",$$DATE^BGP1UTL(BGPPPD)
 Q
 ;
WPP ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W:'$D(BGPNOBA) ! W !?2,"Principle Procedure:  ",BGPDATA(1)
 S X=1 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?23,BGPDATA(X)
 Q
 ;
WDOD(V) ;EP - write dod
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 I $$DOD^AUPNPAT(V)]"" D
 .W !!?2,"*Date of Death:  ",$$DATE^BGP1UTL($$DOD^AUPNPAT(V))
 Q
 ;
WDT(V) ;EP - write discharge type at column 3
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W:'$D(BGPNOBA) ! W !?2,"Discharge Type:  ",$$VAL^XBDIQ1(9000010.02,V,.06)
 Q
 ;
WTT(V) ;EP - write transferred to
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !?2,"Transferred to:  ",$$VAL^XBDIQ1(9000010.02,V,.09)
 Q
 ;
WPPDPOV(V) ;EP
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W:'$D(BGPNOBA) ! W !?2,"Primary Discharge POV: "_$$PRIMPOV^APCLV(V,"C"),"  ",$$PRIMPOV^APCLV(V,"N")
 Q
 ;
 ;
OTHDPOVS(V) ;EP write out other discharge povs
 NEW X,C
 S (X,C)=0 F  S X=$O(^AUPNVPOV("AD",BGPVSIT,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVPOV(X,0))
 .Q:$P(^AUPNVPOV(X,0),U,12)="P"
 .S C=C+1
 .Q
 I $Y>(BGPIOSL-(C+2)) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Other Discharge POVs for this visit:",$S(C=0:"  None",1:"")
 S (X,C)=0 F  S X=$O(^AUPNVPOV("AD",BGPVSIT,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVPOV(X,0))
 .Q:$P(^AUPNVPOV(X,0),U,12)="P"
 .S C=C+1
 .S I=$P(^AUPNVPOV(X,0),U),I=$P($$ICDDX^ICDCODE(I),U,2)
 .S N=$$VAL^XBDIQ1(9000010.07,X,.04),N=$$UP^XLFSTR(N)
 .W !?4,I,?11,N
 Q
GETTXT ;EP - GENERALIZED TEXT PRINTER
 S BGPLETP("DLT")=1,BGPLETP("ILN")=75
 F BGPLETP("Q")=0:0 S:BGPLETP("NRQ")]""&(($L(BGPLETP("NRQ"))+$L(BGPLETP("TXT"))+2)<255) BGPLETP("TXT")=$S(BGPLETP("TXT")]"":BGPLETP("TXT")_"; ",1:"")_BGPLETP("NRQ"),BGPLETP("NRQ")="" Q:BGPLETP("TXT")=""  D GETTXT2
 K BGPLETP("ILN"),BGPLETP("DLT"),BGPLETP("F"),BGPLETP("C"),BGPLETP("TXT")
 Q
GETTXT2 D GETFRAG S BGPLEC=BGPLEC+1,BGPLETXT(BGPLEC)="" F X=1:1:BGPLETP("ICL") S BGPLETXT(BGPLEC)=BGPLETXT(BGPLEC)_" "
 S BGPLETXT(BGPLEC)=BGPLETXT(BGPLEC)_BGPLETP("F"),BGPLETP("ICL")=BGPLETP("ICL")+BGPLETP("DLT"),BGPLETP("ILN")=BGPLETP("ILN")-BGPLETP("DLT"),BGPLETP("DLT")=0
 Q
GETFRAG I $L(BGPLETP("TXT"))<BGPLETP("ILN") S BGPLETP("F")=BGPLETP("TXT"),BGPLETP("TXT")="" Q
 F BGPLETP("C")=BGPLETP("ILN"):-1:1 Q:$E(BGPLETP("TXT"),BGPLETP("C"))=" "
 S BGPLETP("F")=$E(BGPLETP("TXT"),1,BGPLETP("C")-1),BGPLETP("TXT")=$E(BGPLETP("TXT"),BGPLETP("C")+1,255)
 Q
