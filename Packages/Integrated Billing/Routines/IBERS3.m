IBERS3	;ALB/ARH - APPOINTMENT CHECK-OFF SHEET GENERATOR (CONTINUED); 12/6/91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;gather data continued - dx's
	;first three DXs from patients PTF records (by discharge date) and billing records (by event date) for the last year
	;with a max of 18 (IBPDN), first 3 DX's from the last 6 records in year
	;input: DFN, IBDT
	;
	S IBFD="",IBPDN=18
PTFDX	;701 dx's for last year, or at most 3 dx's from last 6 ptf's
	S (IBST,IBADT)=(IBDT-10000),IBEND=(IBDT+.99)
	;get last years pft records, store in reverse cronological order by discharge date
	F  S IBADT=$O(^DGPT("AAD",DFN,IBADT)) Q:IBADT=""!(IBADT>IBEND)  S IBPTF="" D
	. F  S IBPTF=$O(^DGPT("AAD",DFN,IBADT,IBPTF)) Q:IBPTF=""  D
	.. S IBN=$G(^DGPT(IBPTF,70)) Q:IBN=""!(+IBN>IBEND)  S IBG(-IBN,IBPTF)=IBN
	G:'$D(IBG) ENDPTF S IBDXP1=10,IBDXP2=16,IBDXP3=17,IBCNT=0
	D DX G:'$D(IBD) ENDPTF
	D DX1 G:'$D(IBTMP) ENDPTF S IBLBL="Discharge"
	D DX2
ENDPTF	K IBADT,IBCNT,IBPTF,IBST,IBEND,IBN
	;
BILLDX	;print billing dx's, or at most 3 dx's from last 6 bills
	S (IBST,IBEG)=(IBDT-10000),IBEND=(IBDT+.99),IBBN=""
	;get last years billing records, store in reverse cronological order by event date
	F  S IBBN=$O(^DGCR(399,"C",DFN,IBBN)) Q:IBBN=""  D
	. S IBEDT=$P($G(^DGCR(399,IBBN,0)),"^",3) Q:(IBEDT>IBEND)!(IBEDT<IBEG)
	. S IBN=$G(^DGCR(399,IBBN,"C")) Q:IBN=""  S IBG(-IBEDT,IBBN)=IBN
	G:'$D(IBG) ENDBILL S IBDXP1=14,IBDXP2=15,IBDXP3=16,IBCNT=0
	D DX G:'$D(IBD) ENDBILL
	D DX1 G:'$D(IBTMP) ENDBILL S IBLBL="Billing" S IBX="" D ENDLN
	D DX2
ENDBILL	K IBN,IBCNT,IBST,IBEDT,IBEND,IBEG,IBX,IBBN
	;
END	I IBFD S IBX=IBDSH D ENDLN
	K IBFD,IBPDN
	Q
	;
DX	;get appropriate number of DX codes from choosen records
	S IBDDT="" F  S IBDDT=$O(IBG(IBDDT)) Q:IBDDT=""!(IBPDN'>IBCNT)  D
	. S IBX="" F  S IBX=$O(IBG(IBDDT,IBX)) Q:IBX=""!(IBPDN'>IBCNT)  S IBN=IBG(IBDDT,IBX) D
	.. F IBI=IBDXP1,IBDXP2,IBDXP3 S IBDX=$P(IBN,"^",IBI) I IBDX,(IBPDN>IBCNT),'($G(IBR($E(IBDDT,1,7),IBDX))) D
	... S IBCNT=IBCNT+1,IBD(IBDDT,IBCNT)=IBDX_"^"_$S(IBI=10:"*",1:" ") I IBCNT=IBPDN S IBST=-IBDDT
	... S IBR($E(IBDDT,1,7),IBDX)=1
	K IBDDT,IBX,IBI,IBDX,IBN,IBR,IBG,IBDXP1,IBDXP2,IBDXP3,IBX
	Q
	;
	;format records found that have dx's in past year (from previous steps)
DX1	S IBFD=1,IBDDT="",IBROW=1,IBCOL=3,IBRMAX=(IBCNT\IBCOL)+$S(IBCNT#IBCOL=0:0,1:1)
	;format dx's for printing, 3 columns, descending date
	F  S IBDDT=$O(IBD(IBDDT)) Q:IBDDT=""  S IBX="" F  S IBX=$O(IBD(IBDDT,IBX)) Q:IBX=""  D
	. S IBDX=IBD(IBDDT,IBX),IBDDTE=$$DAT1^IBOUTL(-IBDDT)
	. S IBDX=IBDDTE_" "_$P(IBDX,"^",2)_"("_$J($P($G(^ICD9(+IBDX,0)),"^",1),7)_") "_$P($G(^ICD9(+IBDX,0)),"^",3)
	. I IBROW>IBRMAX S IBROW=1,IBCOL=IBCOL-1,IBRMAX=(IBCNT\IBCOL)+$S(IBCNT#IBCOL=0:0,1:1)
	. S IBTMP(IBROW)=$S($D(IBTMP(IBROW)):IBTMP(IBROW),1:$J("",IB1))_$E(IBDX,1,IB3)_$J("",(IB3-$L(IBDX)))_$J("",IB4)
	. S IBROW=IBROW+1,IBCNT=IBCNT-1
	K IBDDT,IBROW,IBCOL,IBRMAX,IBX,IBDX,IBD,IBDDTE
	Q
	;
	;set results into temp array to be printed on check-off sheet
DX2	S Y=IBST X ^DD("DD") S IBEG=$P(Y,"@",1),Y=IBDT X ^DD("DD") S IBEND=$P(Y,"@",1)
	S IBX=IBLBL_" Diagnosis for "_IBEG_" to "_IBEND,IBW=1 D LINE S IBX="" D ENDLN
	S IBDX="" F  S IBDX=$O(IBTMP(IBDX)) Q:IBDX=""  S IBX=$E(IBTMP(IBDX),1,IOM) D ENDLN
	K Y,IBEG,IBEND,IBX,IBDX,IBTMP,IBLBL
	Q
	;
	;enters a line into the temp file used to had the COS before printing
LINE	;prints 1 (IBW=1) 2 (IBW=2) or three (IBW=3) pieces of data on a formated line
	;use IBW=1 for headers centered on the page: IBX=header text
	;entry at lable ENDLN can be used to insert a line with no additional formating
	I IBW=1 S IBT=IB1+(IB2-($L(IBX)/2)),IBX=$J("",IBT)_IBX G ENDLN
	S IBL=$S(IBW=2:IB2,1:IB3),IBT=IB4
	S IBX=$E(IBX,1,IBL),IBX=$J("",IB1)_IBX_$J("",(IBL-$L(IBX)))
	S IBY=$E(IBY,1,IBL),IBX=IBX_$J("",IBT)_IBY_$J("",(IBL-$L(IBY)))
	I IBW=3 S IBZ=$E(IBZ,1,IBL),IBX=IBX_$J("",IBT)_IBZ_$J("",(IBL-$L(IBZ)))
ENDLN	S IBLC=IBLC+1,^TMP("IBRSP",$J,IBLC)=IBX
	K IBT,IBL
	Q
