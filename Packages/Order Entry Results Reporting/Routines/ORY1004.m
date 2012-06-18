ORY1004 ; IHS/MSC/DKM - Pre and Post-init for patch OR*3.0*1004;04-May-2006 12:33;DKM
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**1004**;May 1, 2006
 ; Environment Check
EC Q
 ; Pre-init
PRE Q
 ; Post-init
POST D CHG^XPAR("PKG","ORWD NONVA REASON",1,"Outside medication not recommended by provider.")
 D CHG^XPAR("PKG","ORWD NONVA REASON",2,"Outside medication recommended by provider.")
 D CHG^XPAR("PKG","ORWD NONVA REASON",3,"Patient buys OTC/Herbal product without medical advice.")
 D CHG^XPAR("PKG","ORWD NONVA REASON",4,"Medication prescribed by another provider.")
 D PUT^XPAR("PKG","ORWDX NEW MED","h",$$FIND1^DIC(101.41,,"X","PSH OERR"))
 Q
