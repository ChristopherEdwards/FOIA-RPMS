ADGWMM2 ; IHS/ADC/PDW/ENM - WARD MEDICARE/MEDICAID PRINT ; [ 10/29/1999  1:31 PM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**3**;MAR 25, 1999
 ;
LDT ;EP; -- loop by disch date
 K ^TMP("ADGWMM",$J)
 NEW DGD,END,DGN
 S DGD=DGBD-.0001,END=DGED+.2400
 F  S DGD=$O(^DGPM("ATT3",DGD)) Q:'DGD!(DGD>END)  D
 . S DGN=0 F  S DGN=$O(^DGPM("ATT3",DGD,DGN)) Q:'DGN  D
 .. S DFN=$P(^DGPM(DGN,0),U,3),DGPMCA=$P(^(0),U,14)
 .. D CHECK I DGMR="",DGMD="",DGPI="" Q
 .. S W=$$DWD
 .. S W=$$VAL^XBDIQ1(42,W,.01) I (DGW'=0),(W'=DGW) Q
 .. S ^TMP("ADGWMM",$J,W,DGD,DGN)=DFN_U_DGPMCA_U_DGMR_U_DGMD_U_DGPI_U_DGPINM
 ;
 D HDH,TMPLP Q
 ;
TMPLP ; -- loop thru tmp file
 NEW X
 ;IHS/DSD/ENM NEXT LINE COPIED/MODIFIED
 ;S W=0 F  S W=$O(^TMP("ADGWMM",$J,W)) Q:'W!(DGSTOP=U)  D
 S W=0 F  S W=$O(^TMP("ADGWMM",$J,W)) Q:W']""!(DGSTOP=U)  D
 . S DGD=0 F  S DGD=$O(^TMP("ADGWMM",$J,W,DGD)) Q:'DGD!(DGSTOP=U)  D
 .. S DGN=0
 .. F  S DGN=$O(^TMP("ADGWMM",$J,W,DGD,DGN)) Q:'DGN!(DGSTOP=U)  D
 ... S DGS=^TMP("ADGWMM",$J,W,DGD,DGN),DFN=+DGS
 ... D PRINT
 Q
 ;
CHECK ; -- check for insurance types requested
 S (DGMD,DGMR,DGPI,DGPINM)=""
 I $D(^AUPNMCR("B",DFN)) S IFN=$O(^(DFN,0)) D MCR
 I $D(^AUPNMCD("B",DFN)) S IFN=$O(^(DFN,0)) D MCD
 I $D(^AUPNPRVT("B",DFN)) S IFN=$O(^(DFN,0)) D INS
 Q
 ;
MCR ; -- medicare
 NEW ED,EED
 F ED=0:0 S ED=$O(^AUPNMCR(IFN,"11",ED)) Q:'ED  D
 . S EED=$P(^AUPNMCR(IFN,11,ED,0),U,2),DGMR="" I EED>DT!('+EED) D
 .. S DGMR=$P(^AUPNMCR(IFN,0),U,3)_$P(^AUTTMCS($P(^(0),U,4),0),U)
 Q
 ;
MCD ; -- medicaid
 NEW ED,EED
 F ED=0:0 S ED=$O(^AUPNMCD(IFN,"11",ED)) Q:'ED  D
 . S EED=$P(^AUPNMCD(IFN,11,ED,0),U,2),DGMD=""
 . I EED>DT!('+EED) S DGMD=$P(^AUPNMCD(IFN,0),U,3)
 Q
 ;
INS ; -- private insurance 
 NEW ED,EED
 F ED=0:0 S ED=$O(^AUPNPRVT(IFN,"11",ED)) Q:'ED  D
 . S EED=$P(^AUPNPRVT(IFN,11,ED,0),U,7),DGPI="" I EED>DT!('+EED) D
 .. S DGPI=$P(^AUPNPRVT(IFN,"11",ED,0),U,2)
 .. S DGPINM=$P(^AUTNINS($P(^AUPNPRVT(IFN,"11",ED,0),U,1),0),U,1)
 Q
 ;
PRINT ; -- print
 NEW MR,MD,PV,PVN
 I $Y>(IOSL-6) D NEWPG Q:DGSTOP=U
 W !,$E($P(^DPT(DFN,0),U),1,20)  ;name
 I $D(DUZ(2))&($D(^AUPNPAT(DFN,41,DUZ(2),0))) W ?22,$J($P(^(0),U,2),6)
 S DGPMCA=$P(DGS,U,2) ;corr admit
 S Y=+^DGPM(DGPMCA,0) X ^DD("DD") W ?32,Y  ;admission date/time
 S Y=DGD X ^DD("DD") W ?50,Y ;dsch date/time
 W ?72,$E(W,1,5)
 W !?2,"Admit Dx: ",$P(^DGPM(DGPMCA,0),U,10)  ;admitting Dx
 S MR=$P(DGS,U,3),MD=$P(DGS,U,4),PV=$P(DGS,U,5),PVN=$P(DGS,U,6)
 I MD W ?40,"MCAID #: ",MD
 I MR W ?61,"MCARE #: ",MR
 I PV W !?2,"Insurer: ",PVN,"  #",PV
 W ! Q
 ;
HDH ; -- heading
 I DGPG>0!(IOST["C-") W @IOF
 D CONF^ADGUTIL(12)
 W !?24,"MEDICARE/MEDICAID/INSURANCE LIST"
 S DGPG=DGPG+1
 S Y=DT X ^DD("DD") W ?69,Y
 W !?17,"for Discharge Dates: ",$$RANGE
 W !?2,"Patient Name",?23,"HRCN",?32,"Admit Date",?50,"Dsch Date"
 W ?72,"Ward"
 S LN="",$P(LN,"-",IOM)="" W !,LN Q
 ;
NEWPG ; -- end of page control
 I IOST["C-" K DIR S DIR(0)="E" D ^DIR S DGSTOP=X Q:X=U
 D HDH Q
 ;
RANGE() ; -- printable date range
 NEW X,Y,R
 S Y=DGBD X ^DD("DD") S R=Y_" to "
 S Y=DGED X ^DD("DD") S R=R_Y
 Q R
 ;
DWD() ; -- find disch ward
 N X,Y,Z S Y=$G(^DGPM(+$P(^DGPM(DGPMCA,0),U,17),0)),Y=$$IDATE(+Y)
 S X=$O(^DGPM("ATID2",DFN,Y))
 I X>$$IDATE(+^DGPM(DGPMCA,0)) S Z=DGPMCA
 I X]"",'$D(Z) S Z=$O(^DGPM("ATID2",DFN,X,0))
 I X="" S Z=DGPMCA
 Q $P($G(^DGPM(+Z,0)),U,6)
 ;
IDATE(X) ; -- inverse date
 Q (9999999.9999999-X)
