ASU3IUPD ; IHS/ITSC/LMH -POST REPLENISHMENT ISS TRANS ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine provides logic to post (process) ISSUE transactions
 ;to the SAMS master files.
 Q:$G(DDSERROR)>0  Q:$G(ASUT(ASUT,"QTY","REQ"))=""
 S ASUF("SV")=2 D SETMOIS,UPDATE,^ASUMKBPS,^ASUMYDPS
 G EXIT
RVIS ;EP ;REVERSAL ISSUE
 Q:$G(DDSERROR)>0
 S:'$D(ASUT(ASUT,"QTY","ISS")) ASUT(ASUT,"QTY","ISS")=$G(ASUT(ASUT,"QTY"))
 S ASUF("SV")=2 D SETMOIS,UPDATE
 D:ASUT("TRCD")="3K" ^ASUMKBPS,^ASUMYDPS D:ASUT("TRCD")="3L" ^ASUMYDPS
EXIT ;
 ;K ASUT,ASUF("SV") D PSTKL^ASUCOKIL  ;WAR 5/11/99 INCLUDED IF STMT
 I '$D(ASU("DA CNT")) K ASUT,ASUF("SV") D PSTKL^ASUCOKIL
 Q
TXFIS ;EP ;TRANSFER ISSUE
 Q:$G(DDSERROR)>0
 S:$G(ASUT(ASUT,"QTY","ISS"))="" ASUT(ASUT,"QTY","ISS")=$G(ASUT(ASUT,"QTY"))
 S:$G(DDSREFT)="" DDSREFT=$G(ASUV("DDSREFT"))
 ;D SETMOIS
 D UPDATE Q
SETMOIS ;EP;
 S:$G(DDSREFT)="" DDSREFT=$G(ASUV("DDSREFT"))
 N X
 ;Note the following date manipulation should pass requirement for Y2K
 ;two digit voucher year greater than 85 = 1900+yr all others, 2000+yr
 ;beginning Y2K fix 
 ;I $E(ASUT("TRCD"),2)?1N S X=$S($P(ASUT(ASUT,"VOU"),"-")>85:2,1:3)_$P(ASUT(ASUT,"VOU"),"-")_$P(ASUT(ASUT,"VOU"),"-",2)_"00" S:X>ASUMS("LSTISS") ASUMS("LSTISS")=X
 I $E(ASUT("TRCD"),2)?1N D                                 ;Y2000
 .S X=$P(ASUT(ASUT,"VOU"),"-",2)_$P(ASUT(ASUT,"VOU"),"-")  ;Y2000
 .D START^ASUUY2K(.X,1,U,"N")                                   ;Y2000
 .S X=Y                                                    ;Y2000
 .S:X>ASUMS("LSTISS") ASUMS("LSTISS")=X                    ;Y2000
 ;end Y2K fix block
 S X=$P(ASUT(ASUT,"VOU"),"-",2),Y=(ASUT(ASUT,"SIGN")*-1) S:$E(X)=0 X=$E(X,2)
 S ASUMS("DMD","CALL",X)=$G(ASUMS("DMD","CALL",X))+Y
 S:$G(ASUT(ASUT,"QTY","ISS"))="" ASUT(ASUT,"QTY","ISS")=$G(ASUT(ASUT,"QTY"))
 S ASUMS("DMD","QTY",X)=$G(ASUMS("DMD","QTY",X))+(ASUT(ASUT,"QTY","ISS")*Y)
 Q
UPDATE ;EP;
 S ASUMS("VAL","O/H")=ASUMS("VAL","O/H")+(ASUT(ASUT,"VAL")*ASUT(ASUT,"SIGN"))
 S ASUMS("QTY","O/H")=ASUMS("QTY","O/H")+(ASUT(ASUT,"QTY","ISS")*ASUT(ASUT,"SIGN"))
 S ASUS("ADD")=2 D ^ASUMSTWR K ASUS("ADD")
 S:ASUT(ASUT,"FPN")="B" ASUT(ASUT,"FPN")="N"
 D ^ASUJHIST ;Move transaction to History file
 Q
FILLSTAT(X) ;EP ;CALCULATE FILL STATUS (F=FULL, P=PART, N=NONE)
 ; X=Quantity Requested
 Q:$E(ASUT("TRCD"),2)?1A
 N Z
 S (ASUT(ASUT,"B/O"),ASUT(ASUT,"FPN"),ASUT(ASUT,"QTY","ADJ"))=""
 S ASUF("ERR")=0
 ;WAR 5/7/99S ASUF("ERR")=0,ASUT(ASUT,"B/O")="",ASUT(ASUT,"QTY","ADJ")=""
 I $G(ASUT(ASUT,"PST"))="I" D
 .I X=0!(ASUMS("QTY","O/H")=0) D
 ..I ASUMS("QTY","O/H")'>0,X>0 D
 ...S ASUF("ERR")=1,DDSERROR=1,Z="No Quantity On Hand - Issuing "_X_" would cause a credit balance"
 ...S ASUT(ASUT,"FPN")="",ASUT(ASUT,"QTY","ISS")=""
 ...D HLP^ASUJHELP(Z),QTY^ASUJCLER,QTYI^ASUJSAVE(ASUT(ASUT,"QTY","ISS")),FPN^ASUJSAVE(ASUT(ASUT,"FPN"))
 ..S (ASUT(ASUT,"QTY","ISS"),ASUT(ASUT,"QTY"),ASUT(ASUT,"QTY","REQ"))=0
 ..S ASUT(ASUT,"FPN")="N",ASUT(ASUT,"VAL")=0
 .E  D
 ..I ASUMS("QTY","O/H")<X D  Q
 ...S ASUF("ERR")=1,DDSERROR=1,Z="Not enough Quantity On Hand - Issuing "_X_" would cause a credit balance"
 ...S ASUT(ASUT,"FPN")="",ASUT(ASUT,"QTY","ISS")=""
 ...D HLP^ASUJHELP(Z),QTY^ASUJCLER,QTYI^ASUJSAVE(ASUT(ASUT,"QTY","ISS")),FPN^ASUJSAVE(ASUT(ASUT,"FPN"))
 ..S ASUT(ASUT,"FPN")=$G(ASUT(ASUT,"FPN")) S:ASUT(ASUT,"FPN")="" ASUT(ASUT,"FPN")="F"  ;DFM 4/7/99
 ..I $G(ASUT(ASUT,"FPN"))="F" D
 ...S ASUT(ASUT,"QTY","ISS")=X S (Z,Y)="" D MSUNCST(.Z,.Y) S ASUT(ASUT,"VAL")=Y
 ..E  D
 ...I $G(ASUT(ASUT,"FPN"))="P" D
 ....I ASUT(ASUT,"QTY","ISS")]"" D
 .....S (Z,Y)="" D MSUNCST(.Z,.Y) S ASUT(ASUT,"VAL")=Y
 ....E  D
 .....S ASUT(ASUT,"QTY","ISS")=X
 .....S (Z,Y)="" D MSUNCST(.Z,.Y) S ASUT(ASUT,"VAL")=Y
 E  D
 .I ASUT(ASUT,"FPN")="" D
 ..S ASUT(ASUT,"QTY","ADJ")="",ASUS("QTYAJ")=0
 ..S Z=ASUT(ASUT,"QTY","REQ"),Y="" D SPQ^ASU3ISQA(.Z,.Y) S ASUT(ASUT,"QTY","ISS")=Y
 ..I ASUT(ASUT,"QTY","ISS")'=ASUT(ASUT,"QTY","REQ") D
 ...S Z="Requested quantity adjusted to comply with Standard Pack Quantity" D HLP^ASUJHELP(Z) ;DFM P1 9/1/98 WAR 5/3/99
 ...S ASUT(ASUT,"QTY","ADJ")="A",ASUS("QTYAJ")=1
 ..E  D
 ...S ASUT(ASUT,"QTY","ADJ")="",ASUS("QTYAJ")=0
 .;I ASUMS("QTY","O/H")=ASUT(ASUT,"QTY","ISS")!(ASUMS("QTY","O/H")>ASUT(ASUT,"QTY","ISS")) D
 .I ASUMS("QTY","O/H")'<ASUT(ASUT,"QTY","ISS") D  ;WAR 5/5/99
 ..S ASUT(ASUT,"FPN")="F"
 .E  D
 ..I ASUT("TRCD")'=32 D  Q
 ...S ASUF("ERR")=1,DDSERROR=1
 ...S Z="Not enough Quantity On Hand - would cause credit balance" D HLP^ASUJHELP(Z) ;DFM P1 9/1/98 WAR 5/3/99
 ...D QTY^ASUJCLER
 ..;I ASUMS("QTY","O/H")=0!(ASUMS("QTY","O/H")<0) D
 ..I ASUMS("QTY","O/H")'>0 D                         ;WAR 5/5/99
 ...S ASUT(ASUT,"FPN")="N",ASUT(ASUT,"QTY","ISS")=0
 ..E  D
 ...S ASUT(ASUT,"FPN")="P"
 ...S ASUT(ASUT,"QTY","ISS")=ASUMS("QTY","O/H")
 .I ASUT(ASUT,"FPN")="N" S ASUF("ERR")=0 D  ;Q:ASUF("ERR")
 ..;D QTYREQ^ASUJHELP  ;WAR 5/5/99 and the next 5 lines
 ..S Z="No Quantity On Hand - will attempt to Backorder" D HLP^ASUJHELP(Z) ;DFM P1 9/1/98 WAR 5/3/99
 ..S X=ASUT(ASUT,"QTY","REQ")
 ..N Q S Q=X D BKORDR(.Q)
 ..I ASUF("ERR") S:ASUF("ERR")=7 ASUT(ASUT,"FPN")="B" S ASUT(ASUT,"QTY","ISS")=0,ASUT(ASUT,"VAL")=0 D QTY^ASUJCLER,VAL^ASUJCLER Q
 ..S ASUV("CST/U")=0,ASUMS("D/O","QTY")=Q
 .I ASUT(ASUT,"FPN")="P" D
 ..;D QTYREQ^ASUJHELP  ;WAR 5/5/99 and next 10 lines
 ..S X=ASUT(ASUT,"QTY","REQ")-ASUMS("QTY","O/H"),ASUT(ASUT,"QTY","ISS")=ASUMS("QTY","O/H")
 ..S Z="Not enough Quantity to fill order - will attempt to Backorder "_X D HLP^ASUJHELP(Z) ;DFM P1 9/1/98 WAR 5/3/99
 ..N Q S Q=X,ASUF("ERR")=0 D BKORDR(.Q)
 ..I ASUF("ERR") D VAL^ASUJCLER,QTY^ASUJCLER Q
 ..S ASUT(ASUT,"B/O")="B"
 ..S ASUMS("D/O","QTY")=ASUMS("D/O","QTY")+Q
 ..S:'$D(ASUT(ASUT,"PON")) ASUT(ASUT,"PON")=""
 ..S:'$D(ASUT(ASUT,"SUI")) ASUT(ASUT,"SUI")=""
 ..S:'$D(ASUT(ASUT,"SRC")) ASUT(ASUT,"SRC")=""
 ..S:'$D(ASUT(ASUT,"REQ TYP")) ASUT(ASUT,"REQ TYP")=""
 .I ASUMS("QTY","O/H")'>0 D
 ..S ASUT(ASUT,"VAL")=0 D VAL^ASUJCLER
 .E  D
 ..I ASUT(ASUT,"FPN")'="N" S (Z,Y)="" D MSUNCST(.Z,.Y) S ASUT(ASUT,"VAL")=Y
 S:$G(DA)="" DA=ASUHDA
 S DDSERROR="",Z=ASUT(ASUT,"VAL") D VAL^ASUJVALF(.Z,.DDSERROR)
 S Z=ASUT(ASUT,"FPN") D FPN^ASUJSAVE(.Z)
 Q:"2P37"[ASUT("TRCD")
 S DDSERROR="",Z=ASUT(ASUT,"QTY","ISS") D EN^ASUJVALD(.Z,.DDSERROR,"QTYI","N")
 Q
MSUNCST(X,Y) ;EP; -Calculate Unit cost for issue from Station Master QTY & VAL
 N Z S Z=ASUT(ASUT,"QTY","ISS") D UCSVAL(.Z,.X,.Y)
 I ASUMS("QTY","O/H")-ASUT(ASUT,"QTY","ISS")=0 S Y=ASUMS("VAL","O/H")
 I Y>ASUMS("VAL","O/H") S Y=ASUMS("VAL","O/H")
 Q
UCSVAL(Z,X,Y) ;EP
 ;Z - Quantity
 ;X - Returns Unit Cost
 ;Y - Returns value of (Unit cost X Quantity)
 S X=$S(ASUMS("VAL","O/H")=0!(ASUMS("VAL","O/H")=""):0,ASUMS("QTY","O/H")=0!(ASUMS("QTY","O/H")=""):0,1:$FN((ASUMS("VAL","O/H")/ASUMS("QTY","O/H")),"",2))
 I $G(ASUT("TRCD"))=27 S:X=0 X=$G(ASUMS("LPP"))
 I $G(ASUT("TRCD"))=31 S:X=0 X=$G(ASUMS("LPP"))
 S Y=+$G(X)*(+$G(Z)),ASUMB("UCS")=$G(X)
 Q
BKORDR(Q) ;CREATE ISSUE BACKORDER
 ;Q - QUANTITY TO BACKORDER
 S ASUVQBO=Q
 I $G(ASUT(ASUT,"SST"))="" D  Q
 .S Z="Can't Backorder - No Sub Station Code" D HLP^ASUJHELP(Z) S ASUF("ERR")=1 ;DFM P1 9/1/98
 I $G(ASUT(ASUT,"USR"))="" D  Q
 .S Z="Can't Backorder - No User Code" D HLP^ASUJHELP(Z) S ASUF("ERR")=2 ;DFM P1 9/1/98
 S ASUMB("E#","USR")=$G(ASUT(ASUT,"PT","USR")),ASUMB("E#","REQ")=$G(ASUT(ASUT,"PT","REQ")),ASUMB("E#","IDX")=$G(ASUT(ASUT,"PT","IDX"))
 S ASUF("ERR")=0
 ;D REQ^ASUMBOIO(ASUMB("E#","USR")) ;Lookup REQ in Backorder master
 D REQ^ASUMBOIO(ASUMB("E#","REQ"))  ;WAR 5/4/99 line above is incorrect
 I Y<1 D  Q:ASUF("ERR")
 .I Y=0 D  ;No backorders on file for Requsitioner
 ..D REQADD^ASUMBOIO(ASUMB("E#","REQ")) ;Add REQ to Backorder master
 ..N Z I Y<0 D  ;Error in add
 ...S Z="Backorder for Requsitioner : "_ASUMB("E#","REQ")_" not created - error code="_Y D HLP^ASUJHELP(Z) S ASUF("ERR")=3
 .E  D  ;Error -requsitioner not in lookup table
 ..S Z="Requsitioner : "_ASUMB("E#","REQ")_" not valid - error code="_Y D HLP^ASUJHELP(Z) S ASUF("ERR")=4
 N Z S Z(0)=ASUT("TRCD") S ASUT("TRCD")=31 D UCSVAL(.ASUVQBO,.ASUVUCS,.ASUVAL) S ASUT("TRCD")=Z(0) S ASUMB("VAL")=ASUVAL,ASUMB("UCS")=ASUVUCS,ASUMB("QTYB/O")=ASUVQBO
 K ASUVAL,ASUVUCS,ASUVQBO
 S ASUMB("QTYISS")=ASUT(ASUT,"QTY","ISS")
 D IDX^ASUMBOIO(ASUMB("E#","IDX")) ;Lookup IDX in Backorder master
 N Z I Y<1 D  Q:$D(ASUM("ERR"))
 .I Y=0 D  ;No backorder on file for this item for this requsitioner
 ..D IDXADD^ASUMBOIO(ASUMB("E#","IDX")) ;Add IDX to Backorder master
 ..I Y<0 D  ;Error Index master not on file
 ...S Z="Index : "_ASUMB("E#","IDX")_" not valid - error code="_Y D HLP^ASUJHELP(Z) S ASUF("ERR")=5
 .E  D  ;Error Index master not on file
 ..S Z="Index : "_ASUMB("E#","IDX")_" not valid - error code="_Y D HLP^ASUJHELP(Z) S ASUF("ERR")=6
 E  D  Q
 .S Z="Backorder already on file for Vou# "_ASUVOU_" w/this Requsitoner and Index" D HLP^ASUJHELP(Z) S ASUF("ERR")=7
 .S ASUT(ASUT,"VAL")=0,X=0
 D READBO^ASUMBOIO ;Read Backorder master into variables
 D:$G(ASUSB)'=1 PUT^DDSVALF("BOQTY","","",Q)
 S ASUMB("DT")=ASUT(ASUT,"DTR"),ASUMB("DTPS")=ASUK("DT","FM")
 N V S V=ASUT(ASUT,"VOU") D
 .I V["-" D
 ..S ASUMB("VOU")=$P(V,"-")_"-"_$P(V,"-",2)_"-",V("#")=$P(V,"-",3)
 .E  D
 ..S ASUMB("VOU")=$E(V,1,2)_"-"_$E(V,3,4)_"-",V("#")=$E(V,5,8)
 I V("#")<5000 D
 .S V("#")=V("#")+5000
 E  D
 .S V("#")="5"_$E(V("#"),2,4)
 S ASUMB("VOU")=ASUMB("VOU")_V("#")
 I $G(ASUSB)'=1 D PUT^DDSVALF("BOVOU","","",ASUMB("VOU")),PUT^DDSVALF("BOQTY","","",Q)
 E  W "B.O. Vou:",V
 D UPDTBO^ASUMBOIO ;Write Backorder master from variables
 Q
