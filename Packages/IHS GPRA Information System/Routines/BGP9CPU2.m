BGP9CPU2 ; IHS/CMI/LAB - calc CMS measures 02 Jul 2008 9:24 AM ; 
 ;;9.0;IHS CLINICAL REPORTING;**1**;JUL 01, 2009
 ;
WNMIACE ;EP - write out nmi ACE/ARB
 I '$D(BGPDATA) D  Q
 .I $Y>(BGPIOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !!?2,"NMI Refusal?  No"
 .I BGPACPT]"" W !!?4,"CPT: ",BGPACPT
 I $Y>(BGPIOSL-6) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"NMI Refusal:  Yes"
 ;NEW Y S Y=0 F  S Y=$O(BGPDATA(Y)) Q:Y'=+Y  D
 S BGPXX=0 F  S BGPXX=$O(BGPDATA(BGPXX)) Q:BGPXX'=+BGPXX  D
 .I $Y>(IOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !?4,BGPDATA(BGPXX)
 ;W !?4,BGPDATA(Y)
 I $Y>(BGPIOSL-6) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 I BGPACPT]"" W !!?4,"CPT: ",BGPACPT
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if this was"
 W !,"documented by a physician/APN/PA before it is used to exclude patients"
 W !,"from the denominator."
 Q
WLVS ;EP write out lvs FUNCTION
 S X=0,C=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Evaluation of LVS Function? "
 ;S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  D
 S BGPXX=0 F  S BGPXX=$O(BGPDATA(BGPXX)) Q:BGPXX'=+BGPXX  D
 .I $Y>(IOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !?4,BGPDATA(BGPXX)
 ;W !?4,BGPDATA(X)
 ;W !
 Q
WDSCHINT ;EP - write out discharge instructions
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Discharge Instructions?  ",BGPPED,!
 Q
WLVAD ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,$S(BGPPEX[1:"*",1:""),"LVAD/Heart Transplant?  ",BGPLVAD
 Q
WCOMFORT(X) ;EP - write out comfort message
 I X="" D  Q
 .I $Y>(BGPIOSL-4) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !!?2,"Comfort Measures?  None Recorded."
 I $Y>(BGPIOSL-5) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Comfort Measures?  ",X
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if"
 W !,"this was documented by a physician/APN/PA before it is used"
 W !,"to exclude patients from the denominator.   "
 Q
 ;
WDOD(V) ;EP - write dod
 I $Y>(BGPIOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 I $$DOD^AUPNPAT(V)]"" D
 .W !!?2,"*Date of Death:  ",$$DATE^BGP9UTL($$DOD^AUPNPAT(V))
 Q
 ;
WDT(V) ;EP - write discharge type at column 3
 I $Y>(BGPIOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W:'$D(BGPNOBA) ! W !?2,$S(BGPPEX[2:"*",1:""),"Discharge Type:  ",$$VAL^XBDIQ1(9000010.02,V,.06)
 Q
 ;
WTT(V) ;EP - write transferred to
 I $Y>(BGPIOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W:'$D(BGPNOBA) ! W !?2,"Transferred to:  ",$$VAL^XBDIQ1(9000010.02,V,.09)
 Q
 ;
WPPDPOV(V) ;EP
 I $Y>(BGPIOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W:'$D(BGPNOBA) ! W !?2,"Primary Discharge POV: "_$$PRIMPOV^APCLV(V,"C"),"  ",$$PRIMPOV^APCLV(V,"N")
 Q
 ;
OTHDPOVS(V) ;EP write out other discharge povs
 NEW X,C
 S (X,C)=0 F  S X=$O(^AUPNVPOV("AD",BGPVSIT,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVPOV(X,0))
 .Q:$P(^AUPNVPOV(X,0),U,12)="P"
 .S C=C+1
 .Q
 I $Y>(BGPIOSL-(C+2)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Other Discharge POVs for this visit:",$S(C=0:"  None",1:"")
 S (X,C)=0 F  S X=$O(^AUPNVPOV("AD",BGPVSIT,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVPOV(X,0))
 .Q:$P(^AUPNVPOV(X,0),U,12)="P"
 .S C=C+1
 .S I=$P(^AUPNVPOV(X,0),U),I=$P($$ICDDX^ICDCODE(I),U,2)
 .S N=$$VAL^XBDIQ1(9000010.07,X,.04),N=$$UP^XLFSTR(N)
 .W !?4,I,?11,N
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:80)-$L(X)\2)_X
 ;
WPCI ;EP write out 
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"PCI:  "
 W ?4,BGPPCI
 Q:BGPPCI=""  ;only display note if found procedure
 I $Y>(BGPIOSL-5) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !,"NOTE: For this to be used to exclude patients from the denominator, it must "
 W !,"be described as non-primary by a physician/APN/PA.  For this to be used to "
 W !,"include patients in the numerator, the PCI must be performed within 90 "
 W !,"minutes of hospital arrival.  The patient's chart must be reviewed to make"
 W !,"these determinations.",!
 Q
 ;
WFIB ;EP - write out fib meds
 S (X,C)=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 S X=0 F  S X=$O(BGPUD(X)) Q:X'=+X  S Y=0 F  S Y=$O(BGPUD(X,Y)) Q:Y'=+Y  S C=C+1
 I $Y>(BGPIOSL-(C+2)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Fibronolytic Therapy Rx Status?  "
 I $D(BGPDATA) W !?4,"Outpatient Rx: " D
 .S BGPXX=0 F  S BGPXX=$O(BGPDATA(BGPXX)) Q:BGPXX'=+BGPXX!(BGPQUIT)  D
 ..K BGPLETXT S BGPLETP("ICL")=0,BGPLETP("LGTH")=70,BGPLETP("NRQ")=BGPDATA(BGPXX),BGPLETP("TXT")="",BGPLEC=0
 ..D GETTXT^BGP9CPU4
 ..S BGPZZ=0 F  S BGPZZ=$O(BGPLETXT(BGPZZ)) Q:BGPZZ'=+BGPZZ!(BGPQUIT)  D
 ...D:$Y>(BGPIOSL-3) HDR^BGP9CP Q:BGPQUIT  W !?4,BGPLETXT(BGPZZ)
 ;S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 I $D(BGPUD) W !?4,"IV/Unit Dose: " W BGPUD D
 .S BGPXX=0 F  S BGPXX=$O(BGPUD(BGPXX)) Q:BGPXX'=+BGPXX!(BGPQUIT)  D
 ..K BGPLETXT S BGPLETP("ICL")=0,BGPLETP("LGTH")=70,BGPLETP("NRQ")=BGPUD(BGPXX),BGPLETP("TXT")="",BGPLEC=0
 ..D GETTXT^BGP9CPU4
 ..S BGPZZ=0 F  S BGPZZ=$O(BGPLETXT(BGPZZ)) Q:BGPZZ'=+BGPZZ!(BGPQUIT)  D
 ...D:$Y>(BGPIOSL-3) HDR^BGP9CP Q:BGPQUIT  W !?4,BGPLETXT(BGPZZ)
 ;S X=0 F  S X=$O(BGPUD(X)) Q:X'=+X  W !?4,BGPUD(X)
 I BGPTAPRO]"" W !?4,"Procedure: ",BGPTAPRO
 I '$D(BGPDATA),'$D(BGPUD),BGPTAPRO="" Q  ;no data so no note
 I $Y>(BGPIOSL-4) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !,"NOTE: In order to be included in the numerator, the therapy must have been"
 W !,"received within 30 minutes or less from hospital arrival.  The patient's"
 W !,"chart must be reviewed to make this determination.",!
 Q
WLBBB ;EP - write out lbbb on ecg
 I $Y>(BGPIOSL-6) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"LBBB on ECG: "
 W !?4,BGPLBDX
 S X=0 F  S X=$O(BGPLBPC(X)) Q:X'=+X  W !?4,BGPLBPC(X)
 I BGPLBDX="",'$D(BGPLBPC) Q  ;no note if no data
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if other"
 W !,"ST-Segment Elevations or LBBB on ECGs are noted and which was performed"
 W !,"closest to hospital arrival."
 Q
WST ;EP write out st segment elevation
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"ST-Segment Elevation:  "
 W ?4,BGPST1
 I BGPST1="" Q
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if other"
 W !,"ST-Segment Elevations or LBBB on ECGs are noted and which was performed"
 W !,"closest to hospital arrival."
 Q
WCS ;EP -write out circulatory shock
 I $Y>(BGPIOSL-6) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,$S(BGPPEX["B":"*",1:""),"Circulatory Shock? "
 I '$D(BGPDATA) W "  No, Not recorded" Q
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if the patient"
 W !,"should be excluded if circulatory shock occurred on on arrival or within 24"
 W !,"hours after arrival."
 Q
WHF ;EP - write out HF diagnosis
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,$S(BGPPEX["A":"*",1:""),"Heart Failure? "
 I '$D(BGPDATA) W "  No, Not recorded" Q
 ;S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 S BGPXX=0 F  S BGPXX=$O(BGPDATA(BGPXX)) Q:BGPXX'=+BGPXX  D
 .I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !?4,BGPDATA(BGPXX)
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if the patient"
 W !,"should be excluded if heart failure occurred on on arrival or within 24 "
 W !,"hours after arrival."
 Q
W23RD ;EP write out 2/3 degree
 I $Y>(BGPIOSL-5) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"2nd/3rd Degree heart Block? "
 I '$D(BGP23RD) W "  No, Not recorded"
 I $D(BGP23RD),'BGPPACE W "  Yes. "
 I $D(BGP23RD),BGPPACE W "  Yes, but pacemaker present  " ;D
 ;.S X=0 F  S X=$O(BGP23RD(X)) Q:X'=+X  W !?4,BGP23RD(X)
 I $D(BGP23RD) S X=0 F  S X=$O(BGP23RD(X)) Q:X'=+X  W !?4,BGP23RD(X)
 I '$D(BGP23RD) Q
 I $Y>(BGPIOSL-6) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if the patient"
 W !,"should be excluded if the patient has a 2nd/3rd degree heart block "
 W !,"on ECG during stay AND does not have a pacemaker (also see Pacemaker"
 W !,"below)."
PACE ;
 W !!?2,"Pacemaker? ",$S($P(BGPPACE,U,2)]"":$P(BGPPACE,U,2),1:"No, Not recorded")
 Q
 ;
WBRADY6 ;EP write out bradycardia data
 I $Y>(BGPIOSL-4) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,$S(BGPPEX[9:"*",1:""),"Bradycardia? "
 I '$D(BGPBRADY) W "  No, Not recorded" Q
 S BGPXX=0 F  S BGPXX=$O(BGPBRADY(BGPXX)) Q:BGPXX'=+BGPXX  D
 .I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !?4,BGPBRADY(BGPXX)
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if the patient"
 W !,"should be excluded if bradycardia occurred on arrival or within"
 W !,"24 hours after arrival AND if patient was not on a beta blocker at"
 W !,"the time of bradycardia (also see Beta Blocker Rx Status below)."
 Q
WBRADY5 ;EP write out bradycardia data
 I $Y>(BGPIOSL-4) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,$S(BGPPEX[9:"*",1:""),"Bradycardia? "
 I '$D(BGPBRADY) W "  No, Not recorded" Q
 S BGPXX=0 F  S BGPXX=$O(BGPBRADY(BGPXX)) Q:BGPXX'=+BGPXX  D
 .I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !?4,BGPBRADY(BGPXX)
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if the"
 W !,"patient should be excluded if bradycardia occurred on day of discharge"
 W !,"or day prior to discharge AND if patient was not on a beta blocker at"
 W !,"the time of bradycardia (also see Beta Blocker Rx Status below)."
 Q
WPRINPRO ;EP
 K BGPXX
 S BGPC=""
 S BGPB=(9999999-$$DSCH^BGP9CU(BGPVINP))-1,BGPE=9999999-$P($P(^AUPNVSIT(BGPVSIT,0),U),".")
 F  S BGPB=$O(^AUPNVPRC("AA",DFN,BGPB)) Q:BGPB'=+BGPB!(BGPB>BGPE)  D
 .S X=0 F  S X=$O(^AUPNVPRC("AA",DFN,BGPB,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVPRC(X,0))
 ..Q:$P(^AUPNVPRC(X,0),U,7)'="Y"
 ..S BGPC=$$VAL^XBDIQ1(9000010.08,X,.01)_"  "_$$VAL^XBDIQ1(9000010.08,X,.04)
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !?2,"Principle Procedure:  ",BGPC
 Q
WOTHPROS ;EP
 K BGPXX
 S BGPC=0
 S BGPB=(9999999-$$DSCH^BGP9CU(BGPVINP))-1,BGPE=9999999-$P($P(^AUPNVSIT(BGPVSIT,0),U),".")
 F  S BGPB=$O(^AUPNVPRC("AA",DFN,BGPB)) Q:BGPB'=+BGPB!(BGPB>BGPE)  D
 .S X=0 F  S X=$O(^AUPNVPRC("AA",DFN,BGPB,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVPRC(X,0))
 ..S V=$P(^AUPNVPRC(X,0),U,3)
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:"IH"'[$P(^AUPNVSIT(V,0),U,7)
 ..Q:$P(^AUPNVPRC(X,0),U,7)="Y"
 ..S BGPC=BGPC+1,BGPXX(BGPC)=$$VAL^XBDIQ1(9000010.08,X,.01)_"  "_$$VAL^XBDIQ1(9000010.08,X,.04)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,Y,D,V
 S BGPB=9999999-$$DSCH^BGP9CU(BGPVINP),BGPE=9999999-$P($P(^AUPNVSIT(BGPVSIT,0),U),".")
 F  S BGPB=$O(^AUPNVSIT("AA",DFN,BGPB)) Q:BGPB=""!($P(BGPB,".")>BGPE)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",DFN,BGPB,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..Q:"IH"'[$P(^AUPNVSIT(V,0),U,7)
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S BGPC=BGPC+1,BGPXX(BGPC)=$$VAL^XBDIQ1(9000010.18,X,.01)_"  "_$P($$CPT^ICPTCOD($P(^AUPNVCPT(X,0),U),(9999999-BGPB)),U,3)
 ...Q
 ..Q
 .Q
 S (C,X)=0 F  S X=$O(BGPXX(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+3)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !?2,"Other Procedures for this Visit:"
 S BGPX=0 F  S BGPX=$O(BGPXX(BGPX)) Q:BGPX'=+BGPX  W !?4,BGPXX(BGPX)
 Q
 ;
