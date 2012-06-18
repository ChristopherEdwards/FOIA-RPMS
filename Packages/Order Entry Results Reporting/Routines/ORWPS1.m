ORWPS1 ; SLC/Staff - Meds Tab;17-Jun-2009 16:26;PLS
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,1003,1004**;Dec 17, 1997
 ;IHS/MSC/DKM - Modified to accept dialog type:
 ;   i=inpatient; o=outpatient; h=outside meds
NEWDLG(Y,DTP) ; Return order dialog info for New Medication
 N DGRP,ID,IEN,TXT,TYP,X,X0,X5
 S:DTP=+DTP DTP=$S(DTP:"i",1:"o") ; For backward compatibility
 S X=$$GET^XPAR("ALL","ORWDX NEW MED",DTP,"I")
 S IEN=+X,X0=$G(^ORD(101.41,IEN,0)),X5=$G(^(5))
 S TYP=$P(X0,U,4),DGRP=+$P(X0,U,5),ID=+$P(X5,U,5),TXT=$P(X5,U,4)
 S Y=IEN_";"_ID_";"_DGRP_";"_TYP_U_TXT
 Q
PICKUP(Y) ; Return default for refill location
 I $D(^PSX(550,"C")) S Y="M"
 E  S Y="W"
 Q
REFILL(Y,ORDERID,REFLOC,ORVP,ORNP,ORL) ; Refill Request
 S ORVP=ORVP_";DPT(",ORL(2)=ORL_";SC(",ORL=ORL(2)
 D REF^ORMBLDPS(ORDERID,REFLOC)
 S Y=""
 Q
