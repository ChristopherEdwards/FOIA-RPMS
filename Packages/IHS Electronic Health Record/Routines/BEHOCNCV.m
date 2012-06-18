BEHOCNCV ;MSC/IND/PLS/DKM - Cover Sheet: Consult Orders;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**028001;Mar 20, 2007
 ;=================================================================
 ; List consult orders
 ; ADT = Number of hours prior to retrieve
LIST(DATA,DFN,ADT) ;
 N ORGRP,ORVP,ORLIST,LP,X,YY
 S DATA=$$TMPGBL^CIAVMRPC,ADT=+$G(ADT)
 K ^TMP("GMRCR",$J)
 D OER^GMRCSLM1(DFN,"","","","",2)                                     ; Condensed format
 I $P($G(^TMP("GMRCR",$J,"CS",0)),U,4)>0 D
 .S LP=0
 .F  S LP=$O(^TMP("GMRCR",$J,"CS",LP)) Q:LP<1  D
 ..S X=^TMP("GMRCR",$J,"CS",LP,0)
 ..S YY=$$FDATA(X)
 ..S:$L(YY) @DATA@(LP)=YY
 K ^TMP("GMRCR",$J)
 Q
 ; Formats data, returning IEN^STATUS^FORMATTED DATE^TYPE^FM DT
FDATA(X) Q $S('$L(X):"",1:$P(X,U)_U_$P(X,U,4)_U_$$ENTRY^CIAUDT($P(X,U,2))_U_$P(X,U,3)_U_$P(X,U,2))
 ; Detail of specific consult order
 ; IEN = IEN of consult order
DETAIL(DATA,DFN,IEN) ;
 N GMRCOER
 S GMRCOER=2                                                           ; Data style
 K ^TMP("GMRCR",$J)
 D DT^GMRCSLM2(+IEN)
 S DATA=$NA(^TMP("GMRCR",$J,"DT"))
 Q
