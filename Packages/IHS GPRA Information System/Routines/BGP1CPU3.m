BGP1CPU3 ; IHS/CMI/LAB - calc CMS measures ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
EXCL487 ;EP
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 S BGPXX=$$LASTDXI^BGP1UTL1(DFN,"487.0",$P($P(BGPVSIT0,U),"."),$$DSCH^BGP1CU(BGPVINP),"HI") I BGPXX S BGPN=$$VAL^XBDIQ1(9000010.07,$P(BGPXX,U,5),.04)
 W !!?2,$S(BGPPEX["L":"*",1:""),"Influenza Dx: "_$S(BGPPEX["L":"Yes, 487.0 "_BGPN,1:"No")
 Q
WFLU ;EP
 S X=0,C=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+8)) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Influenza IZ Status?  "
 I '$D(BGPDATA) Q
 I $D(BGPDATA) S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 W !,"NOTE:  If Influenza vaccine received prior to admission, in order to be "
 W !,"included in the CMS measure, it must be determined if the patient received"
 W "it during the CURRENT flu season.  The CMS Data Abstraction Guidelines"
 W !,"define current flu season as beginning when this season's flu vaccine "
 W !,"is made available to the public, e.g. if the vaccine is available in"
 W !,"September, then the flu season is September-February.  However, for this "
 W !,"measure, the hospitals are only responsible for discharges October-February."
 ;W !
 Q
 ;
WWOUND ;EP - write transferred to
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,$S(BGPPEX["J":"*",1:""),"Home Wound Care?  ",$P(X,U,2)
 Q
 ;
WNURSHOM ;EP
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,$S(BGPPEX["H":"*",1:""),"Nursing Home Visit?  ",$P(X,U,2)
 Q
 ;
WHOS2DAY ;EP
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,$S(BGPPEX["G":"*",1:""),"Hospitalized for 2 days in past 3 months?  ",$P(X,U,2)
 Q
 ;
WPRIORHO ;EP
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,$S(BGPPEX["F"!(BGPPEX["G"):"*",1:""),"Prior Hospitalization?  ",$S(X]""!(Y]""):"Yes",1:"No")
 W !?4,"Hospital Stay prior 14 days: ",$S(X]"":"Yes, ",1:"No "),$P(X,U,2)
 W !?4,"Hospitalized at least 2 days: ",$S(Y]"":"Yes",1:"No") I Y]"" W !?6,$P(Y,U,2)," ",$P(Y,U,3)
 Q
 ;
WEXCL1 ;EP
 S X=0,C=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+4)) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 S BGPAST=""
 I BGPPEX["A"!(BGPPEX["B")!(BGPPEX["C")!(BGPPEX["D")!(BGPPEX["E")!(BGPPEX["K")!(BGPPEX["I") S BGPAST=1
 W !!?2,$S(BGPAST:"*",1:""),"HIV Positive/AIDS, Systemic Chemotherapy/Immunosuppressive Therapy,"
 W !?2,"Leukemia, Lymphoma, Radiation Therapy, or Chronic Dialysis?  "
 I '$D(BGPDATA) W !?4,"No, Not recorded." Q
 I $D(BGPDATA) S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 ;W !
 Q
WOTHINF ;EP
 I $Y>(BGPIOSL-7) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Other Suspected Source of Infection? "
 I X W !?4,"Admitting Diagnosis: ["_$P(X,U,2)_"]"
 I X="" Q
 W !,"NOTE:  If patient had other suspected source of infection, this criterion "
 W !,"should only be used to exclude patients when the patient did not receive"
 W !,"an antibiotic regimen recommended for pneumonia but did receive"
 W !,"antibiotics within the first 24 hours of hospitalization."
 Q
 ;
WPSEUDO ;EP
 I $Y>(BGPIOSL-7) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Pseudomonas Risk?  "
 I BGPPSE]"" W !?4,$P(BGPPSE,U,2)
 I BGPCOPD]"" W !?4,$P(BGPCOPD,U,2)
 I BGPCOPD]"",BGPPSE="" D
 .W !,"NOTE:  The patient's chart needs to be reviewed to see if there is"
 .W !,"physician/NP/PA documented history of repeated antibiotics or chronic "
 .W !,"corticosteroid use before this patient can be considered to have risk of"
 .W !,"pseudomonas."
 .Q
 Q
 ;
WERBC ;EP
 S X=0,C=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+2)) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,$S(BGPPEX[6:"*",1:""),"ER Visit with Blood Culture Status:  "
 I $D(BGPDATA) S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 W !
 Q
WANTIRX ;EP
 S X=0,C=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+2)) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,$S(BGPPEX[8!(BGPPEX[7):"*",1:""),"Recent Antibiotic Rx Status:  "
 I $D(BGPDATA) S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 ;W !
 Q
 ;
WPNEUMO ;EP
 S X=0,C=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+2)) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Pneumovax Status?  "
 I $D(BGPDATA) S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 W !
 Q
 ;
WCYSTIC ;EP
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,$S(BGPPEX[5:"*",1:""),"Cystic Fibrosis?  ",$P(X,U,2)
 Q
 ;
WADMDX ;EP
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,$S(BGPPEX[3:"*",1:""),"Admitting Dx?  ",$$VAL^XBDIQ1(9000010.02,BGPVINP,.12)_"  "_$P($$ICDDX^ICDCODE($P(^AUPNVINP(BGPVINP,0),U,12),$$VD^APCLV(BGPVSIT)),U,4)
 Q
 ;
WERPNEU ;EP 
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,$S(BGPPEX[4:"*",1:""),"ER Visit w/ No Pneumonia DX?  ",$P(X,U,2)
 Q
 ;
WCHEST ;EP - write out chest xray data
 S X=0,C=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S Y=0 F  S Y=$O(BGPDATA(X,Y)) Q:Y'=+Y  S C=C+1
 S X=0 F  S X=$O(BGPSCAN(X)) Q:X'=+X  S Y=0 F  S Y=$O(BGPSCAN(X,Y)) Q:Y'=+Y  S C=C+1
 I $Y>(BGPIOSL-(C+3)) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Chest X-ray/CT Scan?  "
 I $D(BGPDATA)!($D(BGPSCAN)) D
 .S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S Y=0 F  S Y=$O(BGPDATA(X,Y)) Q:Y'=+Y  W !?4,BGPDATA(X,Y)
 .S X=0 F  S X=$O(BGPSCAN(X)) Q:X'=+X  S Y=0 F  S Y=$O(BGPSCAN(X,Y)) Q:Y'=+Y  W !?4,BGPSCAN(X,Y)
 .W !,"NOTE: The patient's chart needs to be reviewed to determine if patient"
 .W !,"should be excluded if the finding was not abnormal."
 Q
 ;
WABGPO ;EP - write out chest xray data
 S X=0,C=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+6)) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"ABG/PO Status?  "
 I '$D(BGPDATA) Q
 I $D(BGPDATA) S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 W !,"NOTE: The patient's chart needs to be reviewed to determine if"
 W !,"the oxygen saturation was performed either within 24 hours prior"
 W !,"to arrival or within 24 hours after hospital arrival."
 ;W !
 Q
WCOMFORT(X) ;EP - write out comfort message
 I X="" D  Q
 .I $Y>(BGPIOSL-4) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 .W !!?2,"Comfort Measures?  None Recorded."
 I $Y>(BGPIOSL-4) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !!?2,"Comfort Measures?  ",X
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if"
 W !,"this was documented by a physician/APN/PA before it is used"
 W !,"to exclude patients from the denominator."
 Q
 ;
WDOD(V) ;EP - write dod
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 I $$DOD^AUPNPAT(V)]"" D
 .W !!?2,"Date of Death:  ",$$DATE^BGP1UTL($$DOD^AUPNPAT(V))
 Q
 ;
WDT(V) ;EP - write discharge type at column 3
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W:'$D(BGPNOBA) ! W !?2,$S(BGPPEX[2:"*",1:""),"Discharge Type:  ",$$VAL^XBDIQ1(9000010.02,V,.06)
 Q
 ;
WDT9(V) ;EP - write discharge type at column 3
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W:'$D(BGPNOBA) ! W !?2,$S(BGPPEX[9:"*",1:""),"Discharge Type:  ",$$VAL^XBDIQ1(9000010.02,V,.06)
 Q
WTT(V) ;EP - write transferred to
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 W !?2,"Transferred to:  ",$$VAL^XBDIQ1(9000010.02,V,.09)
 Q
 ;
WPNEUPOV(V) ;EP
 I $Y>(BGPIOSL-4) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
 S X=$$PNEUMODX^BGP1CU(V)
 W:'$D(BGPNOBA) ! W !?2,"Pneumonia Discharge POV:"
 W !?4,$P(X,U) I $P(X,U,2)]"" W !?4,$P(X,U,2)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:80)-$L(X)\2)_X
WPPDPOV(V) ;EP
 I $Y>(BGPIOSL-2) D HDR^BGP1CP Q:BGPQUIT  D L1H^BGP1CP
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
