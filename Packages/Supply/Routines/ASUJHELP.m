ASUJHELP ; IHS/ITSC/LMH -FIELD HELP ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;NOTE all calls to DDSULT preceeded with W *7 IN P1 9/1/98
 ;;This routine is a utility to be called to display field help
HLP(Z) ;EP
 W *7
 S Y=-1
 I $G(ASUSB)=1 D
 .W !?20,Z
 E  D
 .D HLP^DDSUTL(.Z)
 .S DDSERROR=1
 Q
HLPONLY(Z)         ;No error switch set
 W *7
 D HLP^DDSUTL(.Z)
 Q
MSG(Z) ;EP
 I $G(ASUSB)=1 D
 .W !?5,$G(Z) S Z("C")=0 F  S Z("C")=$O(Z(Z("C"))) Q:Z("C")']""  W !,Z(Z("C"))
 E  D
 .D MSG^DDSUTL(.Z)
 Q
ACC ;EP;Account
 N Z S Z=X_" is not a valid account code in the ACCOUNT table"
 D HLP(Z) Q
ARE ;EP;Area
 S Z="Invalid Area Code - must be in table" D HLP(Z) Q
AUI N Z S Z="Area Unit of Issue - such as CS (case), BX (box) etc."
 D HLP(Z) Q
BOIDX ;EP;Backorder index
 N Z S Z="There are no BackOrders on file for this index #" D HLP(Z) Q
BCD ;EP;Bar Code
 N Z S Z="Bar Code may be 1 - 15 numeric characters" D HLP(Z) Q
CAN ;EP;Common Accounting #
 N Z S Z="CAN "_X_" not valid for Requsitioner "
 S Z=Z_$G(ASUL(20,"REQ","NM"))
 D HLP(Z) S Y=-4 Q
CANSS ;EP;Can/ no Sub Sta
 N Z
 S Z="Sub Station must be entered before Common Accounting Number."
 D HLP(Z) Q
CANUS ;EP;Can/ no User
 S Z="User must be entered before Common Accounting Number."
 D HLP(Z) S Y=-2 Q
CATAC ;EP;Cat/ No Account
 N Z S Z="Account must be entered before Category" D HLP(Z) S Y=-2 Q
CATSO ;EP;Cat/ No Sub Object
 N Z S Z="Object Sub Object  must be entered before Category"
 D HLP(Z) S Y=-3 Q
CAT ;EP;Category Invalid
 I +$G(DDSERROR)=0 D
 .N Z S Z="Category "_X_" not valid for Account "_ASUT(ASUT,"ACC")
 .S Z=Z_" and Object-Sub-Object "_ASUT(ASUT,"SOBJ") D HLP(Z)
 Q
CTG ;EP;CTR GRANT #
 N Z S Z="Enter appropriate data to identify Contract/Grant" D HLP(Z) Q
DTD ;EP;Date Due
 D DTE Q
DTE ;EP;Date Established
 N Z S Z="Invalid date.  Must follow today" D HLP(Z) Q
DTR ;EP;Date of Request
 N Z S Z="Invalid date." D HLP(Z) Q
FPNTR ;EP;FPN/ no Tran
 N Z S Z="Cannot determine F, P or N code without transaction type"
 D HLP(Z) Q
FPNQT ;EP; FPN/ no N with qty
 S Z="Quantity entered - F, P or N code must be F (Full) or P (Part)"
 D HLP(Z) S Y=-2 Q
DESC ;EP;Description
 N Z
 S Z("Q")="""",Z(1)="Description must start with an alphabetic"
 S Z(1)=Z(1)_"character, and contain no '"_Z("Q")_"'s."
 S Z(2)="The first character may be followed by up to 59 characters."
 D HLP(Z) Q
DSO ;EP;Direct Sub Object
 D XDSO Q
EOQ ;EP;Eoq Type
 N Z S Z="EOQ Type must be contained in EOQ Type table" D HLP(Z) Q
EOQZR ;EP;Eoq type P or N if qty 0
 N Z S Z="Review Point Quantity = 0, EOQ Type must be 'P' or 'Y'"
 D HLP(Z) Q
EQAM(X) ;EP;Eoq Action Modifier
 D:X=0  Q
 .N Z S Z="One action month quarter must be set to other than zero"
 .D HLP(Z) S Y=-3
 D EQAM1:Y=1,EQAM2:Y=2,EQAM3:Y=3,EQAM4:Y=4
 Q
EQAM1 ;
 N Z S Z="First quarter action month must be 0, 1, 2, 3 or blank"
 D HLP(Z) Q
EQAM2 ;
 N Z S Z="Second quarter action month must be 0, 4, 5, 6 or blank"
 D HLP(Z) Q
EQAM3 ;
 N Z S Z="First quarter action month must be 1, 2, 3 or blank"
 D HLP(Z) Q
EQAM4 ;
 N Z S Z="Fourth quarter action month must be 00 ,10, 11, 12 or blank"
 D HLP(Z) Q
EQMM ;EP;Eoq Month Modifier
 N Z S Z="Enter Month to modify (01-12)" D HLP(Z) Q
EQQM ;EP;Eoq Qty Modifier
 N Z S Z="Enter Quantity to modify" D HLP(Z) Q
IDX ;EP;Index #
 N Z S Z="Index number may not be blank and must pass the mod11 test"
 D HLP(Z) Q
IDX11 ;EP;Index # mod11
 N Z S Z="Index "_X_" failed mod11 test - invalid" D HLP(Z) Q
IDXDL ;EP;Index was deleted
 N Z S Z="Index "_X_", has already been deleted" D HLP(Z)
 I ASUT="STD" S ASUPOP=1  ;WAR4/30/99 called by ASUMDIRM
 Q
IDXFS ;EP;Index needed first
 N Z S Z="Index must be selected so Qty and Value can be validated"
 D HLP(Z) Q
IDXNF ;EP;Index not found
 N Z S Z="Index not on file" D HLP(Z) Q
IDXOF ;EP;Index On file
 N Z S Z="Can't ADD "_$E(X,3,8)_" - already in the Master"
 D HLP(Z),IDX^ASUJCLER Q
KEY ;EP;.01 Key
 Q
LTM ;EP;Lead time months
 N Z S Z(1)="Lead Time mos. must be :"
 S Z(2)="A minimum of .5"
 S Z(3)="Divisable by .5"
 S Z(4)="Not greater than 9.5"
 D HLP(.Z) Q
NSN ;EP;National Stock #
 N Z S Z(1)="National Stock Number format:"
 S Z(2)="1. FSC 4 numeric digits (not all zero - required)"
 S Z(3)="2. NATO/FIIN 9 numeric digits (not all zero - optional)"
 S Z(4)="3. SUFFIX 1 alpha character (optional)"
 S Z(5)="May be blank on a 'Change' (4C) record"
 D HLP(.Z) S Y=-2 Q
OBJ ;EP;Sub Object
 N Z S Z="Invalid Sub Sub Object" D HLP(Z) Q
ORD ;EP;Order Number
 N Z S Z="Order number must be an 'M' followd by any characters "
 S Z=Z_"or 13 numeric + one alpha" D HLP(Z) Q
PLSCONT ;EP;Please con't msg
 N Z S Z="Please continue to enter this field" D HLPONLY(Z) Q
POCK ;EP;PO# Check
 N Z S Z="Checking Due In's for P.O." D HLPONLY(Z) Q
PON ;EP;Purchase Order #
 N Z S Z="Enter appropriate data to identify Purchase Order Number"
 D HLP(Z) Q
POMATCH ;EP;PO match msg.
 N Z S Z="P.O. Matches Due In" D HLPONLY(Z) Q
PST ;EP;Post
 N Z S Z="Post Posting Code must be 'I' or blank" D HLP(Z) Q
QTY ;EP;Quantity
 N Z S Z="Quantity must be "_X_" - 9999999" D HLP(Z) Q
QTYCB ;EP;Quantity Credit Balance
 N Z S Z="A Quantity of "_X_" would result in a master credit balance"
 D HLP(Z) Q
QTYORDI ;EP;Qty and/or Due ins are not zero
 N Z
 I ASUT="STD" S ASUPOP=1  ;WAR 4/30/99 called by ASUMDIRM
 S Z="Can not delete this record - Qty/OH & all Due In/Out's must be 0"
 D HLPONLY(Z) Q
QTYREQ ;EP;Qty requested
 S Z(1)="REQ QTY is greater than QTYOH.  A  B/O QTY for the difference WILL NOT"
 S Z(2)="be generated at this time. Please check the following:"
 S Z(3)="1) That all receipts have been entered for this item"
 S Z(4)="2) That an accurate warehouse count, matches the QTYOH"
 D HLPONLY(.Z) Q
QTYVAL0 ;EP;Qty but Val 0
 N Z S Z="Master Value would be 0 but Master Quantity would not. "
 S Z=Z_"Please re-enter Quantity"
 D HLP(Z) Q
RECQTY ;EP;Rec qty or value > Due in qty or value
 N Z S Z="Receipt Quantity/Value exceeds Due in Quantity/Value"
 D MSG(Z) Q
REQ ;EP;No Req entry for Sub Sta / User
 N Z S Z="No Requsitioner entry for User "_$G(ASUL(19,"USR","NM"))
 S Z=Z_" at Sub Station "_$G(ASUL(18,"SST","NM"))
 D HLP(Z) Q
RQN ;EP;Request #
 N Z S Z="Request Number may not be blank or longer than 8 characters"
 D HLP(Z) Q
RPQ ;EP;Review Point
 N Z S Z="Review Point Quantity must be numeric 1-99" D HLP(Z) Q
RTP ;EP;Request type
 N Z S Z="Type of Request must be 1 for 'Scheduled' or "
 S Z=Z_"2 for 'Unscheduled'"
 D HLP(Z) Q
SIXOF ;EP;Index On file
 N Z S Z="Station Index already on Master - can't ADD"
 D HLP(Z),IDX^ASUJCLER Q
SLC ;EP;Storage Location
 N Z S Z="Storage Location must be in the standard table" D HLP(Z) Q
SPQ ;EP;Standard Pack
 N Z S Z="Standard Pack Quantity must be numeric 1-99" D HLP(Z) Q
SRC ;EP;Source
 N Z S Z=X_" is not a valid SOURCE code in the SOURCE code table"
 D HLP(Z) Q
SSA ;EP;Sub Activity
 N Z S Z=X_" is not a valid Sub Sub Activity in the SSA code table"
 D HLP(Z) Q
SSO ;EP;Stock Sub Object
 D XSSO Q
SST ;EP;Sub Station
 N Z S Z="Sub Station "_X_" not in table for "_$G(ASUL(1,"AR","NM"))
 S Z=Z_" Area." D HLP(Z) Q
STA ;EP;Station
 N Z S Z="Station "_X_" not in table for "_$G(ASUL(1,"AR","NM"))
 S Z=Z_" Area." D HLP(Z) Q
UCS ;EP;Unit Cost
 Q
UI ;EP;Unit Issue
 N Z S Z="Enter appropriate alpha characters to name unit of issue"
 D HLP(Z) Q
ULQ ;EP;Quantity
 N Z S Z="User Level Quantity must be .1 - 99.9" D HLP(Z) Q
USR ;EP;User
 N Z S Z="User "_X_" not in table for "_$G(ASUL(1,"AR","NM"))_" Area."
 D HLP(Z) Q
VAL(X) ;EP;Value
 N Z S Z="Value must be between "_X_" and 9999999.99"
 D HLP(Z) Q
VALCB ;EP;Value
 N Z S Z="A Value of "_X_" would result in a Master credit balance. "
 S Z=Z_"Please re-enter Value"
 D HLP(Z) Q
VALQTY0 ;EP;Val but qty 0
 N Z S Z="Master Quantity would be 0 but Master Value would not. "
 S Z=Z_"Please re-enter Quantity"
 D HLP(Z) Q
VOU ;EP;Voucher #
 N Z S Z(1)="Voucher Number must be 8 numeric digits, not all zeros "
 S Z(1)=Z(1)_"in format FYMMSER#"
 S Z(2)="Fiscal Year (FY) must be current fiscal year or previous "
 S Z(2)=Z(2)_"fiscal year,"
 S Z(3)="Month (MM) must be 01 through 12,"
 S Z(4)="and Serial number (SER#) must be 0001 through 9999."
 D HLP(.Z) Q
VOUMO ;EP;Voucher month
 N Z S Z="Month must be 01-12"
 D HLP(Z) Q
VOUSR ;EP;Voucher Ser
 N Z S Z="Voucher Serial Number must be 4 numeric digits but not "
 S Z=Z_"all zeros"
 D HLP(Z) Q
VOUYR ;EP;Voucher year
 N Z S Z="Voucher year not equal to current"
 I ASUK("DT","MO")="09" D
 .S Z=Z_", next "
 E  D
 .S Z=Z_" "
 S Z=Z_"or previous FY"
 D HLP(Z) Q
XACC ;EP;Account table
 N DIC D XTBL(9) Q
XARE ;EP;Area table
 N DIC D XTBL(1) Q
XDSO ;EP;Direct Sub Object table
 N DIC
 S:$D(ASUL(9,"ACC")) DIC("S")="I $P(^(0),U,2)=ASUL(9,""ACC"")" D XTBL(4) Q
XBUD ;EP;Budget table
 N DIC D XTBL(21) Q
XCAT ;EP;Category table
 N DIC
 S:$D(ASUL(9,"ACC")) DIC("S")="I $P(^(0),U,2)=ASUL(9,""ACC"")"
 S:$D(ASUL(3,"SOBJ")) DIC("S")=$S($G(DIC("S"))]"":DIC("S")_",$P(^(0),U,3)=ASUL(3,""SOBJ"",""E#"")",1:"I $P(^(0),U,3)=ASUL(3,""SOBJ"",""E#"")")
 D XTBL(7) Q
XEOQ ;EP;Eoq type table
 N DIC D XTBL(6) Q
XEQTB ;EP;Eoq table table
 N DIC D XTBL(8) Q
XPGM ;EP;Program table
 N DIC D XTBL(22) Q
XREQ ;EP;Requsitioner table
 N DIC D XTBL(20) Q
XSLC ;EP;Storage Location table
 N DIC D XTBL(10) Q
XSRC ;EP;Source table
 N DIC D XTBL(5) Q
XSSA ;EP;Sub Sub Activity table
 N DIC D XTBL(17) Q
XSSO ;EP;Stock Sub Object table
 N DIC
 S:$D(ASUL(9,"ACC")) DIC("S")="I $P(^(0),U,2)=ASUL(9,""ACC"")" D XTBL(3) Q
XSST ;EP;Sub Statixn table
 N DIC D XTBL(18) Q
XSTA ;EP;Station table
 N DIC D XTBL(2) Q
XUSR ;EP;User table
 N DIC D XTBL(19) Q
XVEN ;EP;Vendor file
 N DIC S DIC="^AUTTVNDR(",DIC(0)="EM",DZ="??",D="B" D DQ^DICQ Q
XTBL(Z) ;EP ;Table entry listings (Z=table #)
 S DIC="^ASUL("_Z_",",DIC(0)="EM",DZ="??",D="B" D DQ^DICQ Q
