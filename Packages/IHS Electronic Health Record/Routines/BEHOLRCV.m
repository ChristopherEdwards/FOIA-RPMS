BEHOLRCV ;MSC/IND/DKM - Support for lab cover sheet component ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**032001**;Mar 20, 2007
 ;=================================================================
 ; RPC: BEHOLRCV LIST
LIST(DATA,DFN) ;EP - return lab order for patient
 D LIST^ORQOR1(.DATA,DFN,"LAB",4,"T-"_$$RNGLAB(DFN),"T","AW",1)
 Q
 ; RPC: BEHOLRCV DETAIL
DETAIL(DATA,DFN,ORID,ID) ;EP - Return results of order identified by ID
 N ORESULTS,ORVP,LCNT
 K ^TMP("ORXPND",$J)
 S ORESULTS=1,LCNT=0,ORVP=DFN_";DPT("
 D ORDERS^ORCXPND1
 K ^TMP("ORXPND",$J,"VIDEO")
 S DATA=$NA(^TMP("ORXPND",$J))
 Q
 ; Return days back for patient
RNGLAB(DFN) ;
 N INOUT
 S INOUT=$S($L($G(^DPT(DFN,.1))):"I",1:"O")
 Q $$GET^XPAR("ALL","BEHOLRCV DATE RANGE",INOUT,"I")
