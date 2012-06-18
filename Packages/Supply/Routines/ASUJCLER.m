ASUJCLER ; IHS/ITSC/LMH -SCREENMAN CLEAR ARRAY ENTRY ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine will be used to set local array field variables
ACC ;EP;Account
 S ASUT(ASUT,"ACC")=""
 S ASUT(ASUT,"PT","ACC")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,.04,"")
 .D PUT^DDSVAL(DIE,.DA,4,"")
 Q
ARE ;EP;Area
 S ASUT(ASUT,"AR","CD")=""
 S ASUT(ASUT,"PT","AR")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,.02,"")
 .D PUT^DDSVAL(DIE,.DA,2,"")
 Q
AUI ;EP;Area Unit of Issue
 S ASUT(ASUT,"AR U/I")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,42,"")
 Q
BCD ;EP;Bar Code
 S ASUT(ASUT,"BCD")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,45,"")
 Q
CAN ;EP;Common Accounting #
 S ASUT(ASUT,"CAN")=""
 Q:ASUT("TYPE")=2
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,15,"")
 Q
CAT ;EP;Category
 S ASUT(ASUT,"CAT")=""
 S ASUT(ASUT,"PT","CAT")=""
 S ASUT(ASUT,"CAT NM")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,49,"")
 .D PUT^DDSVAL(DIE,.DA,.19,"")
 Q
CTG ;EP;Contract Grant #
 S ASUT(ASUT,"CTG")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,35,"")
 Q
FPN ;EP;F P or N fill
 S ASUT(ASUT,"FPN")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,18,"")
 Q
DESC ;EP;Description
 S ASUT(ASUT,"DESC")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,41,"")
 Q
DSO ;EP;Direct Sub Object
 S ASUT(ASUT,"SOBJ")=""
 S ASUT(ASUT,"PT","SOBJ")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,.17,"")
 .D PUT^DDSVAL(DIE,.DA,17,"")
 Q
DTD ;EP ;Date Due
 S ASUT(ASUT,"DTD")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,10,"")
 Q
DTE ;EP;Date Established
 S ASUT(ASUT,"DTE")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,.07,"")
 Q
DTX ;EP;Date Expired
 S ASUT(ASUT,"DTX")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,10,"")
 Q
EOQ ;EP;Eoq type
 S ASUT(ASUT,"EOQ TYP")=""
 S ASUT(ASUT,"EOQ MM")=""
 S ASUT(ASUT,"EOQ AM")=""
 S ASUT(ASUT,"EOQ QM")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVALF("EQTNM","","","")
 .D PUT^DDSVAL(DIE,.DA,16,"")
 .D PUT^DDSVAL(DIE,.DA,52,"")
 .D PUT^DDSVAL(DIE,.DA,54,"")
 .D PUT^DDSVAL(DIE,.DA,53,"")
 Q
IDX ;EP;Index info 
 S ASUT(ASUT,"PT","IDX")="",ASUT(ASUT,"IDX")="" ;DFM P1 8/28/98
 S ASUT(ASUT,"ACC")="",ASUT(ASUT,"ACC","PT")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVALF("DESC","","","")
 .D PUT^DDSVALF("NSN","","","")
 .D PUT^DDSVALF("ACC","","","")
 .D PUT^DDSVALF("ACCNM","","","")
 .D PUT^DDSVAL(DIE,.DA,.05,"")
 .D PUT^DDSVAL(DIE,.DA,5,"")
 .D PUT^DDSVAL(DIE,.DA,.04,"")
 .D PUT^DDSVAL(DIE,.DA,4,"")
 .D REFRESH^DDSUTL
 Q
KEY ;EP;.01 Key
 S ASUT(ASUT,"TRKY")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,.01,"")
 Q
LTM ;EP;Lead time months
 S ASUT(ASUT,"LTM")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,55,"")
 Q
NSN ;EP;National Stock #
 S ASUT(ASUT,"NSN")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,43,"")
 Q
ORD ;EP;Purchase Order #
 S ASUT(ASUT,"ORD")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,9,"")
 Q
PON ;EP;Purchase Order #
 S ASUT(ASUT,"PON")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,9,"")
 Q
PST ;EP;Post
 S ASUT(ASUT,"PST")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,31,"")
 Q
QTY ;EP;Quantity
 S ASUT(ASUT,"QTY")="",ASUT(ASUT,"QTY","REQ")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,6,"")
 Q
QTYI ;EP;Quantity
 S ASUT(ASUT,"QTY","ISS")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,36,"")
 Q
RES ;Resolve DIE and DA if not set
 I $G(DIE)']"" S DIE=$G(ASUJ("FILE"))
 I $D(DA)']"" S DA=$G(ASUHDA)
 Q
REQ ;EP;Requsitioner
 S ASUT(ASUT,"PT","REQ")=""
 Q:ASUT("TYPE")=5  Q:ASUT("TYPE")=0  Q:ASUT("TYPE")=2
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,.15,"")
 .Q:$G(ASUT("TYPE"))=8  Q:$G(ASUT("TYPE"))=7
 .D PUT^DDSVALF("HMARE","","","")
 Q
RQN ;EP;Request #
 S ASUT(ASUT,"RQN")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,34,"")
 Q
RPQ ;EP;Review Point
 S ASUT(ASUT,"RPQ")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,56,"")
 Q
RTP ;EP;Requset type
 S ASUT(ASUT,"REQ TYP")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,33,"")
 Q
SLC ;EP;Storage Location
 S ASUT(ASUT,"SLC")=""
 S ASUT(ASUT,"SLC","NM")=""
 S ASUT(ASUT,"PT","SLC")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVALF("SLCNM","","","")
 .D PUT^DDSVAL(DIE,.DA,51,"")
 Q
SPQ ;EP;Requset type
 S ASUT(ASUT,"SPQ")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,61,"")
 Q
SRC ;EP;Source
 S ASUT(ASUT,"SRC")=""
 S ASUT(ASUT,"SRC","NM")=""
 S ASUT(ASUT,"PT","SRC")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVALF("SRCNM","","","")
 .D PUT^DDSVAL(DIE,.DA,.12,"")
 Q
SSA ;EP ;Sub Sub Activity
 S ASUT(ASUT,"SSA")=""
 S ASUT(ASUT,"PT","SSA")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,.11,"")
 .D PUT^DDSVAL(DIE,.DA,11,"")
 Q:ASUT("TYPE")=8
 S ASUT(ASUT,"CAN")=""
 I $G(ASUSB)'=1 D
 .D PUT^DDSVAL(DIE,.DA,15,"")
 Q
SSO ;EP;Stock Sub Object
 S ASUT(ASUT,"SOBJ")=""
 S ASUT(ASUT,"PT","SOBJ")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,.17,"")
 .D PUT^DDSVAL(DIE,.DA,17,"")
 Q
SST ;EP;Sub Station
 S ASUT(ASUT,"SST")=""
 S ASUT(ASUT,"PT","SST")=""
 S ASUT(ASUT,"SST","NM")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,13,"")
 .D PUT^DDSVAL(DIE,.DA,.13,"")
 Q
STA ;EP;Station
 S ASUT(ASUT,"STA")=""
 S ASUT(ASUT,"PT","STA")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,3,"")
 .D PUT^DDSVAL(DIE,.DA,.03,"")
 Q
SUI ;EP;Source Unit of Issue
 S ASUT(ASUT,"SUI")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,59,"")
 Q
TRN ;EP;Transaction
 S ASUT(ASUT,"TRCD")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,1,"")
 Q
UCS ;EP;Unit cost
 S ASUT(ASUT,"UCS")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,57,"")
 Q
ULQ ;EP;Unit cost
 S ASUT(ASUT,"ULQ")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,60,"")
 Q
USR ;EP;User
 S ASUT(ASUT,"USR")=""
 S ASUT(ASUT,"PT","USR")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,14,"")
 .D PUT^DDSVAL(DIE,.DA,.14,"")
 Q
VAL ;EP;Value
 S ASUT(ASUT,"VAL")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,7,"")
 Q
VEN ;EP;Value
 S ASUT(ASUT,"VEN NM")=""
 S ASUT(ASUT,"PT","VEN")=""
 I $G(ASUSB)'=1 D
 .Q:ASUT("TYPE")=2  Q:ASUT("TYPE")=8
 .D RES,PUT^DDSVAL(DIE,.DA,.19,"@")
 .;D PUT^DDSVAL(DIE,.DA,68,"@")
 Q
VOU ;EP;Voucher #
 S ASUT(ASUT,"VOU")=""
 I $G(ASUSB)'=1 D
 .D RES,PUT^DDSVAL(DIE,.DA,8,"")
 Q
