ASULARST ; IHS/ITSC/LMH -AREA & STATION TABLE LOOKUP ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which provides entry points to do lookups
 ;and verification for Area Code and Station Code.
 Q:$D(ASUL(1,"AR","AP"))
 D CLS^ASUUHDG W *7 D:'$D(ASUL(1,"AR","E#")) SETAREA I $D(ASUL(1,"AR","AP")) I ASUL(1,"AR","AP")=U Q
 W !?14,"Reminder, Area Code you are signed on with is : ",ASUL(1,"AR","E#"),!
 W !!?35-($L(ASUL(1,"AR","NM"))/2),ASUL(1,"AR","NM"),!!
 W !?10,"If this is correct, enter <cr> to continue."
 W !?10,"Otherwise, enter '^', exit form the KERNEL S.A.M.S. MENU"
 W !?15,"and then re-enter with the correct Area.",!!
 S DIR(0)="E" D ^DIR K DIR
 I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) S ASUL(1,"AR","E#")=U
 S ASUL(1,"AR","AP")=ASUL(1,"AR","E#")
 K ASUL(1,"AR","E#")
 Q
SETAREA ;EP ;SET ASUL(1,"AR","E#") BASED ON DUZ(2) THEN SET ASUL(1) ARRAY
 D LOOKUP S ASUF("LOOKA")=0 D AREA K ASUF("LOOKA")
 Q
LOOKUP ;EP ;LOOKUP AREA BASED ON DUZ(2)
 I '$D(DUZ(2)) S (X,ASUL(1,"AR","AP"))=$P(^ASUSITE(1,0),U) D ARE(ASUL(1,"AR","AP")) Q
 D:'$D(U) ^XBKVAR
 S (X,ASUL(1,"AR","E#"))=$E($P(^AUTTAREA($P(^AUTTLOC(DUZ(2),0),U,4),0),U,4),2,3)
 S ASUK("LOC")=$P(^AUTTLOC(DUZ(2),0),U,2)
 S ASUK("ASUFAC")=$P(^AUTTLOC(DUZ(2),0),U,10)
 I ASUL(1,"AR","E#")']"" W "No Accounting Point stored in your SITE file; contact site manager",!,"Program can not continue -Aborting",! S ASUL(1,"AR","AP")="^" Q
 Q
ARPRINT ;EP; Write out Area Name and save Area Lookup table EIN
 D:$G(ASUL(1,"AR","NM"))']"" ARL
 W " ",ASUL(1,"AR","NM") Q
AREA ;EP -Lookup Area Name. X=AREA CODE
 S ASUF("LOOKA")=$G(ASUF("LOOKA"))
 S:ASUF("LOOKA")="" ASUF("LOOKA")=1
ARL ;
 I '$D(ASUL(1,"AR","AP")) D  ;Q:ASUF("LOOKA")=0
 .I ASUF("LOOKA"),'$D(X) D SETAREA S ASUF("LOOKA")=0 Q
 .S ASUL(1,"AR","AP")=X
 D ARE(X)
 S ASUF("LOOKA")=$G(ASUF("LOOKA"))
 D:ASUF("LOOKA") LOOKUP
 Q
FINDAREA ;EP ;FIND AREA FROM TABLE 01
 N DIR
 S DIR(0)="PO^9002039.01:EM",DIR("A")="SELECT AREA" D ^DIR
 Q:$D(DIRUT)  Q:+Y<0
 S X=+Y
 G AREX
ARE(X) ;EP ;LOOKUP AREA IN TABLE 01
AREX ;
 S (ASUL(1,"AR","E#"),ASUL(1,"AR","AP"))=X
 I $D(^ASUL(1,X,0)) D
 .S ASUL(1,"AR","NM")=$P(^ASUL(1,X,0),U)
 .S ASUL(1,"AR","STA1")=$P(^ASUL(1,X,1),U)
 .S ASUL(1,"AR","WHSE")=$P(^ASUL(1,X,1),U,2)
 .S ASUL(1,"AR","DLTM")=$P(^ASUL(1,X,1),U,3)
 E  D
 .S ASUL(1,"AR","NM")="NOT FOUND",(ASUL(1,"AR","STA1"),ASUL(1,"AR","WHSE"))=""
 Q
STPRINT ;
 S:'$D(X1) X1=$G(ASUK("STA","CD"))
 D STA(X1) W " ",ASUL(2,"STA","NM") Q
STAT ;EP -Lookup Station Name. X=AREA CODE, X1=STATION CODE.
 I '$D(ASUL(1,"AR","AP")) D
 .I '$D(X) D
 ..D SETAREA
 .E  D
 ..D ARE(X)
 I $G(ASUL(2,"STA","E#"))']"" D  Q:ASUL(2,"STA","E#")']""
 .I '$D(X1) S ASUL(2,"STA","E#")="",ASUL(2,"STA","NM")="UNKNOWN" Q
 .S ASUL(2,"STA","E#")=X1
 D:'$D(ASUL(1,"AR","E#")) SETAREA
 D STA(X1)
 Q
STA(X) ;EP ; DIRECT STATION TABLE LOOKUP
 I $L(X)=3 S X=ASUL(1,"AR","AP")_X
 I $L(X)=2 S X=ASUL(1,"AR","AP")_"0"_X
 I X'?5N D  Q
 .S Y=-4 Q  ;Input paramater did not pass Station IEN edit
 I $D(^ASUL(2,X,0)) D
 .S (Y,ASUL(2,"STA","E#"))=X ;Record found for input parameter
 .S ASUL(2,"STA","CD")=$P(^ASUL(2,X,1),U)
 .S ASUL(2,"STA","NM")=$P(^ASUL(2,X,0),U)
 .S ASUL(2,"STA","TYP")=$P(^ASUL(2,X,1),U,2)
 .S ASUL(2,"STA","CTP")=$P(^ASUL(2,X,1),U,3)
 .S ASUL(2,"STA","TP#")=$P(^ASUL(2,X,1),U,4)
 .S ASUL(2,"STA","EOQTB")=$P(^ASUL(2,X,1),U,6)
 .S:ASUL(2,"STA","EOQTB")']"" ASUL(2,"STA","EOQTB")=50
 E  D
 .S ASUL(2,"STA","E#")=X ;IEN to use for LAYGO call
 .S ASUL(2,"STA","CD")="N/F",ASUL(2,"STA","NM")="UNKNOWN",ASUL(2,"STA","EOQTB")=50
 .S Y=-1 ;No record found for Input parameter
 Q
TRN(X) ;EP ;TRANSACTION CODE
 K ASUL(11)
 I X?1N.N,$D(^ASUL(11,+X)) S ASUL(11,"TRN","E#")=+X
 E  S:$E(X)'="T" X="T"_X S ASUL(11,"TRN","E#")=$O(^ASUL(11,"B",X,""))
 I $G(ASUL(11,"TRN","E#"))']"" S Y=-1 Q
 E  S Y=$G(^ASUL(11,ASUL(11,"TRN","E#"),0))
 S ASUL(11,"TRN","KEY")=$P(Y,U,1)
 S ASUL(11,"TRN","CDE")=$E(Y,2,3)
 S ASUL(11,"TRN","NAME")=$P(Y,U,2)
 N Z S (Z,ASUL(11,"TRN","TYPE"))=$P(Y,U,3)
 S ASUL(11,"TRN","TYPN")=$S(Z=1:"DUE IN",Z=2:"RECEIPT",Z=3:"ISSUE",Z=4:"INDEX",Z=5:"STATION",Z=6:"ADJUSTMENT",Z=7:"TRANSFER DUE IN",Z=8:"TRANSFER IN",Z=9:"TRANSFER OUT",Z=0:"DIRECT ISSUE",1:"TRANSFER ISSUE")
 S (Z,ASUL(11,"TRN","EXT"))=$P(Y,U,4)
 S ASUL(11,"TRN","EXTN")=$S(Z=0:"ADD",Z=1:"CHANGE",Z=2:"DELETE",Z=3:"USER LEVEL",Z=4:"PURCHASED",Z=5:"UNREQUIRED",Z=6:"DONATED",Z=7:"EXCESS",Z=8:"STOCK REPLENISHMENT",Z=9:"NON REPLENISHMENT",1:"")
 S ASUL(11,"TRN","DRCR")=$P(Y,U,5)
 S ASUL(11,"TRN","DBCR")=$S(ASUL(11,"TRN","TYPE")=4:"",ASUL(11,"TRN","TYPE")=5:"",ASUL(11,"TRN","DRCR")=-1:"CREDIT",1:"DEBIT")
 S ASUL(11,"TRN","REV")=$P(Y,U,6)
 S ASUL(11,"TRN","TAG")=$P(Y,U,7)
 S ASUL(11,"TRN","FIL")=$P(Y,U,8)
 Q
