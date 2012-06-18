IBOCPDS	;ALB/ARH - CLERK PRODUCTIVITY REPORT, SUMMARY ; 10/8/91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
EN	;get parameters then run the report
	D HOME^%ZIS
	S IBHDR="CLERK PRODUCTIVITY SUMMARY REPORT"
	W @IOF,?22,IBHDR,!!
	S IBFLD="Date Entered"
	D RANGE^IBOCPD G:IBQUIT EXIT
	W !!
DEV	;get the device
	S %ZIS="QM",%ZIS("A")="OUTPUT DEVICE: " D ^%ZIS G:POP EXIT
	I $D(IO("Q")) S ZTRTN="ENT^IBOCPDS",ZTDESC="Clerk Productivity Summary Report",ZTSAVE("IB*")="" D ^%ZTLOAD K IO("Q") G EXIT
	U IO
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOCPDS" D T1^%ZOSV ;stop rt clock
ENT	;find, save, and print the data that satisfies the search parameters
	;entry for tasked jobs
	;***
	;S XRTL=$ZU(0),XRTN="IBOCPDS-2" D T0^%ZOSV ;start rt clock
	S IBCDT=IBBEG-.001,IBE=IBEND+.3,U="^",IBQUIT=0
	F  S IBCDT=$O(^DGCR(399,"APD",IBCDT)) Q:IBCDT=""!(IBCDT>IBE)!IBQUIT  S IFN="" D  S IBQUIT=$$STOP
	. F  S IFN=$O(^DGCR(399,"APD",IBCDT,IFN)) Q:IFN=""  D FILE
	I $D(^TMP("IB",$J)),'IBQUIT D PRINT
	;
EXIT	;clean up and quit
	K ^TMP("IB",$J)
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOCPDS" D T1^%ZOSV ;stop rt clock
	Q:$D(ZTQUEUED)
	K IBE,IBBEG,IBBEGE,IBEND,IBENDE,IBCDT,IFN,IBRT,IBCLK,IBTD,IBNODE,IBPGN,IBLN,IBHDR,IBFLD,IBQUIT,IBI,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
	D ^%ZISC
	Q
	;
FILE	;save the data in sorted order in a temporary file
	S IBRT=$P($G(^DGCR(399,IFN,0)),U,7) Q:'IBRT
	S IBCLK=$P($G(^VA(200,+$P($G(^DGCR(399,IFN,"S")),U,2),0)),U,1) Q:IBCLK=""
	S IBTD=$P($G(^DGCR(399,IFN,"U1")),U,1)
	S IBNODE=$G(^TMP("IB",$J)),^($J)=($P(IBNODE,U,1)+1)_U_($P(IBNODE,U,2)+IBTD)
	S IBNODE=$G(^TMP("IB",$J,IBCLK)),^(IBCLK)=($P(IBNODE,U,1)+1)_U_($P(IBNODE,U,2)+IBTD)
	S IBNODE=$G(^TMP("IB",$J,IBCLK,IBRT)),^(IBRT)=($P(IBNODE,U,1)+1)_U_($P(IBNODE,U,2)+IBTD)
	S IBNODE=$G(^TMP("IB",$J,"~~")),^("~~")=($P(IBNODE,U,1)+1)_U_($P(IBNODE,U,2)+IBTD)
	S IBNODE=$G(^TMP("IB",$J,"~~",IBRT)),^(IBRT)=($P(IBNODE,U,1)+1)_U_($P(IBNODE,U,2)+IBTD)
	Q
	;
PRINT	;print the report from the temp sort file to the appropriate device
	S IBCLK="",IBPGN=0
	D HDR F  S IBCLK=$O(^TMP("IB",$J,IBCLK)) Q:IBCLK=""!(IBQUIT)  D LINE
	W !!,"TOTAL:",?50,$J($P(^TMP("IB",$J),U,1),8),?60,$J($P(^($J),U,2),15,2),!
	D:'IBQUIT PAUSE
	Q
	;
LINE	;print all data for a particular clerk
	W !,$S(IBCLK'="~~":$E(IBCLK,1,25),1:"RATE TYPE TOTALS") S IBLN=IBLN+1
	S IBRT="" F  S IBRT=$O(^TMP("IB",$J,IBCLK,IBRT)) Q:IBRT=""!(IBQUIT)  D  S IBLN=IBLN+1 I IBLN>(IOSL-7) D PAUSE,HDR
	. W ?30,$E($P(^DGCR(399.3,IBRT,0),U,1),1,20),?50,$J($P(^TMP("IB",$J,IBCLK,IBRT),U,1),8),?60,$J($P(^(IBRT),U,2),15,2),!
	W ?50,"  ------",?60,"   ------------"
	W !,?30,"SUBTOTAL:",?50,$J($P(^TMP("IB",$J,IBCLK),U,1),8),?60,$J($P(^(IBCLK),U,2),15,2),! S IBLN=IBLN+2
	Q
	;
HDR	;print the report header
	S IBQUIT=$$STOP Q:IBQUIT  S IBPGN=IBPGN+1,IBLN=5
	D NOW^%DTC S Y=$E(%,1,12) D DD^%DT S IBCDT=$P(Y,"@",1)_"  "_$P(Y,"@",2)
	I IBPGN>1!($E(IOST,1,2)["C-") W @IOF
	W "CLERK PRODUCTIVITY SUMMARY FOR ",IBBEGE," - ",IBENDE I IOM<85 W !
	W ?(IOM-30),IBCDT,?(IOM-8),"PAGE ",IBPGN,!
	W !,"ENTERED BY",?30,"RATE TYPE",?53,"COUNT",?69,"AMOUNT",!
	F IBI=1:1:IOM W "-"
	W !
	Q
	;
PAUSE	;pause at end of screen if beeing displayed on a terminal
	Q:$E(IOST,1,2)'["C-"
	S DIR(0)="E" D ^DIR K DIR
	I $D(DUOUT)!($D(DIRUT)) S IBQUIT=1
	Q
	;
STOP()	;determine if user has requested the queued report to stop
	I $D(ZTQUEUED),$$S^%ZTLOAD S ZTSTOP=1 K ZTREQ I +$G(IBPGN) W !,"***TASK STOPPED BY USER***"
	Q +$G(ZTSTOP)
