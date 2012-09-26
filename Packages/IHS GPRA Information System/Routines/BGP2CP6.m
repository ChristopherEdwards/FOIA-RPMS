BGP2CP6 ; IHS/CMI/LAB - IHS gpra print ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
SCALL ;EP
 ;I $Y>(BGPIOSL-3) D HDR^BGP2CP Q:BGPQUIT  D L1H^BGP2CP
 ;S BGPNOBA=1
 ;D WDT^BGP2CPU4(BGPVINP)
 ;Q:BGPQUIT
 ;I $$TRANS^BGP2CU(BGPVINP) D WTT^BGP2CPU4(BGPVINP) Q:BGPQUIT
 ;K BGPDATA
 ;D SCIP^BGP2CU5(DFN,$P($P(BGPVSIT0,U),"."),$$DSCH^BGP2CU(BGPVINP),.BGPDATA)
 ;D WPP^BGP2CPU4
 ;D WPPDPOV^BGP2CPU4(BGPVSIT)
 ;K BGPNOBA
 ;Q
 I $Y>(BGPIOSL-3) D HDR^BGP2CP Q:BGPQUIT  D L1H^BGP2CP
 S BGPNOBA=1
 D WRACE^BGP2CPU(DFN)
 Q:BGPQUIT
 D WDOB^BGP2CPU(DFN)
 Q:BGPQUIT
 D WZIP^BGP2CPU(DFN)
 Q:BGPQUIT
 D WINS^BGP2CPU(BGPVSIT,DFN)
 Q:BGPQUIT
 D WADM^BGP2CPU(BGPVINP)
 Q:BGPQUIT
 D WADM92^BGP2CPU(BGPVINP)
 Q:BGPQUIT
 D WADMS92^BGP2CPU(BGPVINP)
 Q:BGPQUIT
 D WDT^BGP2CPU(BGPVINP)
 Q:BGPQUIT
 D WDSGS92^BGP2CPU(BGPVINP)
 Q:BGPQUIT
 I $$TRANS^BGP2CU(BGPVINP) D WTT^BGP2CPU(BGPVINP) Q:BGPQUIT
 K BGPNOBA
 D WPPDPOV^BGP2CPU(BGPVSIT)
 Q:BGPQUIT
 S BGPNOBA=1
 D OTHDPOVS^BGP2CPU(BGPVSIT)
 Q:BGPQUIT
 K BGPDATA
 D SCIP^BGP2CU5(DFN,$P($P(BGPVSIT0,U),"."),$$DSCH^BGP2CU(BGPVINP),.BGPDATA)
 D WPP^BGP2CPU4
 Q:BGPQUIT
 D WOTHPROS^BGP2CPU2
 K BGPNOBA
 Q
 ;
SCIP1 ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP2CP Q:BGPQUIT  D L1H^BGP2CP
 D WDT^BGP2CPU4(BGPVINP)
 Q:BGPQUIT
 K BGPPROC
 D SCIP1^BGP2CU5(DFN,$P($P(BGPVSIT0,U),"."),$$DSCH^BGP2CU(BGPVINP),.BGPPROC)
 S BGPPPD=$P(BGPPROC(1),U,3)  ;principle procedure date
 D WPP1^BGP2CPU4
 Q:BGPQUIT
 D WOTHPROC^BGP2CPU4
 K BGPDATA
 Q:BGPQUIT
 D WPPDPOV^BGP2CPU4(BGPVSIT)
 Q:BGPQUIT
 D OTHDPOVS^BGP2CPU4(BGPVSIT)
 Q:BGPQUIT
 I 'BGPEXCL D PERI^BGP2CPU4
 Q:BGPQUIT
 D INF^BGP2CPU4
 Q:BGPQUIT
 D OTHSURG^BGP2CPU4
 Q:BGPQUIT
 K BGPDATA
 ;antibiotic rx status?
 D ANTIRX^BGP2CU3(DFN,$$FMADD^XLFDT($P($P(^AUPNVSIT(BGPVSIT,0),U),"."),-365),$$FMADD^XLFDT($P($P(^AUPNVINP(BGPVINP,0),U),"."),30),.BGPDATA)
 D WANTIRX^BGP2CPU3
 Q:BGPQUIT
 D ALLALG1^BGP2CU1(DFN,DT,$$DSCH^BGP2CU(BGPVINP),.BGPDATA)
 D WALLALG^BGP2CPU
 Q:BGPQUIT
 K BGPDATA
 D ALLALGA1^BGP2CU1(DFN,DT,.BGPDATA)
 D WALLALGT^BGP2CPU
 K BGPDATA
 D IVUD^BGP2CU1(DFN,$P($P(BGPVSIT0,U),"."),$$DSCH^BGP2CU(BGPVINP),,.BGPDATA)
 D WIVUD^BGP2CPU
 Q
 ; 
SCIP3 ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP2CP Q:BGPQUIT  D L1H^BGP2CP
 D WDT^BGP2CPU4(BGPVINP)
 Q:BGPQUIT
 K BGPPROC
 D SCIP1^BGP2CU5(DFN,$P($P(BGPVSIT0,U),"."),$$DSCH^BGP2CU(BGPVINP),.BGPPROC)
 S BGPPPD=$P(BGPPROC(1),U,3)  ;principle procedure date
 D WPP1^BGP2CPU4
 Q:BGPQUIT
 D WOTHPROC^BGP2CPU4
 K BGPDATA
 Q:BGPQUIT
 D WPPDPOV^BGP2CPU4(BGPVSIT)
 Q:BGPQUIT
 D OTHDPOVS^BGP2CPU4(BGPVSIT)
 Q:BGPQUIT
 I 'BGPEXCL D PERI^BGP2CPU4
 Q:BGPQUIT
 D INF^BGP2CPU4
 Q:BGPQUIT
 K BGPDATA
 S BGPPOSTI=$$POSTINF^BGP2CU5(DFN,$$DSCH^BGP2CU(BGPVINP),BGPPROC(1))
 D WPOSTINF^BGP2CPU4
 Q:BGPQUIT
 K BGPDATA
 D OTHSURG^BGP2CPU4
 Q:BGPQUIT
 K BGPDATA
 ;antibiotic rx status?
 D ANTIRX^BGP2CU3(DFN,$$FMADD^XLFDT($P($P(^AUPNVSIT(BGPVSIT,0),U),"."),-365),$$FMADD^XLFDT($P($P(^AUPNVINP(BGPVINP,0),U),"."),30),.BGPDATA)
 D WANTIRX^BGP2CPU3
 Q:BGPQUIT
 D ALLALG1^BGP2CU1(DFN,DT,$$DSCH^BGP2CU(BGPVINP),.BGPDATA)
 D WALLALG^BGP2CPU
 Q:BGPQUIT
 K BGPDATA
 D ALLALGA1^BGP2CU1(DFN,DT,.BGPDATA)
 D WALLALGT^BGP2CPU
 K BGPDATA
 D IVUD^BGP2CU1(DFN,$P($P(BGPVSIT0,U),"."),$$DSCH^BGP2CU(BGPVINP),,.BGPDATA)
 D WIVUD^BGP2CPU
 Q
 ; 
TRANSIN ;
 I $Y>(BGPIOSL-4) D HDR^BGP2CP Q:BGPQUIT  D L1H^BGP2CP
 W !!?3,"NOTE:  Since Admission Type was ","""","Transferred,",""""," review patient's chart"
 W !,"to determine if patient should be excluded if transfer was from another"
 W !,"acute care hospital, including ER from another hospital.",!
 Q
 ;
TRANSN ;
 I $Y>(BGPIOSL-4) D HDR^BGP2CP Q:BGPQUIT  D L1H^BGP2CP
 W !!?3,"NOTE:  Since Discharge Type was ","""","Transferred,",""""," review patient's chart"
 W !,"to determine if patient should be excluded if transferred to another"
 W !,"acute care hospital or federal hospital.",!
 Q
 ;
