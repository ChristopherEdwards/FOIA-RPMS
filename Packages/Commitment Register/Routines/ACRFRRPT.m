ACRFRRPT ;IHS/OIRM/DSD/THL,AEF - RECEIVING REPORT;  [ 11/7/2006  12:48 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**16,19,22**;NOV 05, 2001
 ;;ROUTINE TO PRINT THE RECEIVING REPORT
EN K ^TMP("ACRRR",$J)
 I $D(ACRRR)#2 D
 .S ACRRRX=ACRRR
 .K ACRRR
 .S ACRRR=ACRRRX
 .K ACRRRX
 D EN3
 D PRINT^ACRFPSS
 D EN1
EXIT K ACRRRDA,ACRQUIT,ACRDOCDX,ACRSNUM,^TMP("ACRRR",$J)
 Q
EN1 D HEAD^ACRFRRP1
 N Z,ACRRRDA
 S Z=0
 S (ACRDATE,ACRDATE2)=""
 F  S Z=$O(^TMP("ACRRR",$J,Z)) Q:'Z!$D(ACRQUIT)  D
 .S ACRRRDA=^TMP("ACRRR",$J,Z)
 .Q:'ACRRRDA
 .Q:'$D(^ACRRR(ACRRRDA,0))!'$D(^ACRRR(ACRRRDA,"DT"))
 .S ACRRR0=^ACRRR(ACRRRDA,0)
 .S ACRRRDT=^ACRRR(ACRRRDA,"DT")
 .S ACRSSDA=+ACRRR0
 .Q:'$D(^ACRSS(+ACRSSDA,0))
 .S ACRDUZ=$P(ACRRR0,U,5)
 .S ACRRACP=$P(ACRRRDT,U,3)
 .S ACRDATE=$P(ACRRRDT,U,4)
 .S ACRDATE2=$P(ACRRR0,U,6)
 .;S ACRDUZ=$P(^VA(200,ACRDUZ,0),U)  ;ACR*2.1*19.02 IM16848
 .S ACRDUZ=$$NAME2^ACRFUTL1(ACRDUZ)  ;ACR*2.1*19.02 IM16848
 .S ACRDUZ=$P($P(ACRDUZ,",",2)," ")_" "_$P(ACRDUZ,",")
 .;S:"12"'[+$P(ACRRR0,U,8) (ACRDATE,ACRDATE2,ACRDUZ)=""  ;ACR*2.1*16.15 IM16500
 .D SETSS^ACRFSSA
 .S ACROCDA=$P(ACRSS0,U,4)
 .S ACROC=$P(^AUTTOBJC(ACROCDA,0),U)
 .S ACRSNUM=$P(ACRSS0,U,14)
 .D W
 I $G(ACRDUZ)="",$D(^ACRDOC(ACRDOCDA,"REQ1")) D
 .S ACRDUZ=$P(^ACRDOC(ACRDOCDA,"REQ1"),U,6)
 .I ACRDUZ D
 ..;S ACRDUZ=$P($G(^VA(200,ACRDUZ,0)),U)  ;ACR*2.1*19.02 IM16848
 ..S ACRDUZ=$$NAME2^ACRFUTL1(ACRDUZ)  ;ACR*2.1*19.02 IM16848
 ..S ACRDUZ=$P($P(ACRDUZ,",",2)," ")_" "_$P(ACRDUZ,",")
 S Y=ACRDATE
 X ^DD("DD")
 S ACRDATE=Y
 S Y=ACRDATE2
 X ^DD("DD")
 S ACRDATE2=Y
 Q
W W !,+ACRSS0
 W ?6,$E($P(ACRSSDSC,U),1,25)
 W ?34,ACROC
 W ?39,$J(ACRRQD,6)
 W ?46,ACRUI
 W ?49,$J($FN(ACRUC,"P",2),10)
 W ?60,$J($FN(ACRUC*ACRRACP,"P",2),12)
 W ?73,$J(ACRRACP,6)
 I ACRRACP<ACRRQD W ?79,$S($P(ACRRR0,U,8)=1:"F",$P(ACRRR0,U,8)=2:"P",1:"")
 N J
 F J=2:1:5 I $P(ACRSSDSC,U,J)]"" W !?3,$P(ACRSSDSC,U,J) D:J=2 SNUM
 I $P(ACRSSDT,U,23) D
 .S Y=$P(ACRSSDT,U,23)
 .X ^DD("DD")
 .W !?3,"EXPIRES ON: ",Y
 .D SNUM
 D SNUM
 D NECOP^ACRFRRP1
W1 ;EP;
 ;I IOSL-4<$Y D PAUSE^ACRFWARN Q:$D(ACRQUIT)  S ACRPAGE=ACRPAGE+1 S D0=ACRDOCDA N DXS,DIP,DC,DN D ^ACRRRH  ;ACR*2.1*22.02 IM22606
 I IOSL-4<$Y D PAUSE^ACRFWARN Q:$D(ACRQUIT)  S ACRPAGE=$G(ACRPAGE)+1 S D0=ACRDOCDA N DXS,DIP,DC,DN D ^ACRRRH  ;ACR*2.1*22.02 IM22606
 Q
SNUM ;FORMAT AND PRINT FEDSTRIP SERIAL NUMBER
 Q:'+ACRSNUM
 S ACRX=""
 S $P(ACRX,"0",7-$L(ACRSNUM))=""
 S ACRSNUM=ACRX_ACRSNUM
 W:$X>33 !
 W ?34,ACRSNUM
 S ACRSNUM=""
 Q
RRNO ;EP;
 D RRNO^ACRFRR31
 I '$D(ACRDOC) D                                  ;ACR*2.1*16.08 IM10140
 .S ACRDOC=$S($P(ACRDOC0,U,2)]"":$P(ACRDOC0,U,2),1:$P(ACRDOC0,U))  ;ACR*2.1*16.08 IM10140
 W !!,"There ",$S(ACRRRNO=1:"is ",1:"are "),$S(ACRRRNO:ACRRRNO,1:"NO")," receiving report",$S(ACRRRNO=1:"",1:"s")," on file for PO ",ACRDOC
 I ACRRRNO<1 D PAUSE^ACRFWARN Q
 I ACRRRNO=1 S Y=1 G D1
 S DIR(0)="NOA^1:"_ACRRRNO
 S DIR("A")="Select Receiving Report No.: "
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)!'Y
D1 S ACRRRNO=Y
 S ACRFINAL=""
 S ACRSSNO=$O(^ACRRR("AC",ACRDOCDA,ACRRRNO,0))
 I ACRSSNO D
 .S ACRRRDA=$O(^ACRRR("AC",ACRDOCDA,ACRRRNO,ACRSSNO,0))
 .S:ACRRRDA ACRFINAL=$P(^ACRRR(ACRRRDA,0),U,8),ACRPVN=$P(^(0),U,13)
 Q
RRPT ;EP;
 K ACRPO
 S ACRRR=""
 S (ACRREF,ACRREFX)=499
 S ZTIO=""
 S ZTREQ="@"
 S ACRPODA=$P(^ACRDOC(ACRDOCDA,0),U,8)
 I ACRPODA,$D(^ACRPO(ACRPODA,0)) D
 .S ZTIO1=$P(^ACRPO(ACRPODA,0),U,2)
 .S ZTIO=$P(^ACRPO(ACRPODA,0),U,8)
 .S ZTIO=$P(^AUTTPRG(ZTIO,"DT"),U,10)
 .S (ACRRTN,ZTRTN)="^ACRFQ"
 S:ZTIO ZTIO=$P($G(^%ZIS(1,ZTIO,0)),U)
 S:ZTIO1 ZTIO1=$P($G(^%ZIS(1,ZTIO1,0)),U)
 S ZTIO2=$P(^ACRPO(1,0),U,15)
 S ZTIO3=$P(^ACRPO(1,0),U,16)
 S ZTIO4=$P(^ACRPO(1,0),U,17)
 S:ZTIO2 ZTIO2=$P($G(^%ZIS(1,ZTIO2,0)),U)
 S:ZTIO4 ZTIO4=$P($G(^%ZIS(1,ZTIO4,0)),U)
 I ZTIO3,$P(^ACRPO(1,0),U,20) D  I 1
 .S ZTIO3=$P(^AUTTPRG(ZTIO3,"DT"),U,10)
 .S:ZTIO3 ZTIO3=$P($G(^%ZIS(1,ZTIO3,0)),U)
 E  S ZTIO3=""
 S (ACRDESC,ZTDESC)="RR NO. "_ACRRRNO_" FOR PO NO. "_$P(ACRDOC0,U,2)
 S (ACRDTH,ZTDTH)=$H
 D:ZTIO]"" ZTLOAD
 I ZTIO1]"" D
 .S ZTIO=ZTIO1
 .S ZTDESC=ACRDESC
 .D ZTLOAD
 I ZTIO3]"" D
 .S ZTIO=ZTIO3
 .S ZTDESC=ACRDESC
 .D ZTLOAD
 I ZTIO4]"" D
 .Q
 .S ZTIO=ZTIO4
 .S ZTDESC=ACRDESC
 .D ZTLOAD
 D PROP
 I $D(ACRQUIT),ZTIO2]"" D
 .K ACRQUIT
 .S ZTIO=ZTIO2
 .S ZTDESC=ACRDESC_" (PROPERTY COPY)"
 .D ZTLOAD
 K ACRDESC,ACRRTN,ACRDTH
 Q
ZTLOAD S ZTRTN=ACRRTN
 S ZTDTH=ACRDTH
 S ZTSAVE("ACR*")=""
 S ZTREQ="@"
 D ^%ZTLOAD
 Q
PROP ;EP;TO PRINT REPORT TO AREA PROPERTY PRINTER
 K ACRQUIT
 N ACRSSDA
 S ACRSSDA=0
 F  S ACRSSDA=$O(^ACRSS("J",ACRDOCDA,ACRSSDA)) Q:'ACRSSDA!$D(ACRQUIT)  I $D(^ACRSS(ACRSSDA,0)) S ACROBJDA=$P(^(0),U,4) I ACROBJDA,$D(^AUTTOBJC(ACROBJDA,0)),$E(^(0),1,2)="31"!($E(^(0),1,3)="257"&("6AEJKLMNPQ"[$E(^(0),4))) S ACRQUIT=""
 Q
499 ;EP;
 S ACRRR=""
 D PRINT^ACRFPO1
 Q
REQOFF ;EP;TO PRINT LIST OF ADDITIONAL REQUESTING OFFICES FOR RECEIVING REPORT
 N J,X,Y,Z,I,ACRX
 S (X,J,I)=0
 I '$D(ACRRR)#2 F  S X=$O(^ACRSS("J",ACRDOCDA,X)) Q:'X  I $D(^ACRSS(X,0)),$P(^(0),U,3)'=ACRDOCDA S Y=$P(^(0),U,3) D R1
 I $D(ACRRR)#2,$D(ACRRRNO)#2,ACRRRNO F  S J=$O(^ACRRR("AC",ACRDOCDA,ACRRRNO,J)) Q:'J  S X=0 F  S X=$O(^ACRRR("AC",ACRDOCDA,ACRRRNO,J,X)) Q:'X  D
 .I $D(^ACRRR(X,0)),+^(0),$D(^ACRSS(+^(0),0)),$P(^(0),U,3)'=ACRDOCDA S Y=$P(^(0),U,3) D R1
 Q:'$D(ACRX)
 W !!,"Additional REQUISITIONS with items on this PURCHASE ORDER:"
 S X=""
 F  S X=$O(ACRX(X)) Q:X=""  D
 .S Y=""
 .F  S Y=$O(ACRX(X,Y)) Q:Y=""  S Z=ACRX(X,Y) D
 ..I $D(ACRRR)#2 D  I 1
 ...W !,X
 ...W ?20,Y
 ...W ?52
 ...S Z=$E(Z,1,$L(Z)-1)
 ...F I=1:1:$L(Z,",") W $P(Z,",",I),"," W:$X+$L($P(Z,",",I+1))>75 !?52
 ..E  W !?63,X
 ..N X,Y
 ..D W1
 Q
R1 S I=I+1
 S Z=$P(^AUTTPRG($P(^ACRDOC(Y,"PO"),U,7),0),U)
 S Y=$P(^ACRDOC(Y,0),U)
 S:'$D(ACRX(Y,Z)) ACRX(Y,Z)=""
 S ACRX(Y,Z)=ACRX(Y,Z)_I_","
 Q
EN3 K ACROBJ
 N Z,I
 S (Z,I,ACRTOT)=0
 F  S Z=$O(^ACRRR("AC",ACRDOCDA,ACRRRNO,Z)) Q:'Z  D
 .S ACRRRDA=0
 .F  S ACRRRDA=$O(^ACRRR("AC",ACRDOCDA,ACRRRNO,Z,ACRRRDA)) Q:'ACRRRDA  D
 ..Q:'$D(^ACRRR(ACRRRDA,0))!'$D(^ACRRR(ACRRRDA,"DT"))
 ..S ACRRR0=^ACRRR(ACRRRDA,0)
 ..S ACRRRDT=^ACRRR(ACRRRDA,"DT")
 ..S I=I+1
 ..S ^TMP("ACRRR",$J,I)=ACRRRDA
 ..S ACRSSDA=+ACRRR0
 ..I ACRSSDA,$D(^ACRSS(ACRSSDA,0)) D EN^ACRFRRP1
 Q