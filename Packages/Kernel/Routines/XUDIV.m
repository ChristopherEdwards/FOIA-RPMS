XUDIV ; jch ; 12 Mar 99 11:02; check, setup, or switch DUZ(2)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;CHCS TOOLS_430; GEN 2; 3-MAR-1994
 ;COPYRIGHT 1988, 1989, 1990, 1993 SAIC
 I '$D(^DG(40.8,0))#2 S DUZ(2)=0 Q
DUZ ; put allowable divisions in DUZ(2,x), DUZ(2)=current division number signed onto
 ; If no Divisions entered in USER file, all divisions allowed ; If divisions entered in USER file, only those divisions allowed
 N A,Y  ; protect for MenuMan
 S:'$D(Z(0)) Z(0)=$G(^DIC(3,+$G(DUZ),0)) D DATE^XQ1
 K DUZ(2) S XUDIV=-1 I '$O(^DIC(3,+DUZ,2,0)) D  ; No entries in user file - all are allowable
 .S I=0 F  S I=$O(^DG(40.8,I)) Q:'I  I '$G(^(I,28)) S DUZ(2,I)=$G(^(0)),XUDIV=XUDIV+1
 E  D  ; entries in user file, get allowables
 .S I=0 F  S I=$O(^DIC(3,+DUZ,2,I)) Q:'I  I '$G(^DG(40.8,I,28)) S:$D(^(0)) DUZ(2,I)=^(0),XUDIV=XUDIV+1
 S DUZ(2)=$P(Z(0),U,16),DUZ(2)=$S(DUZ(2):DUZ(2),'XUDIV:$O(DUZ(2,0)),1:"")
 I '$P($G(DUZ("AG")),U,5) G SNGL ; Check if site parameter switch off - SIR #25662 JLL
 I $D(DUZ(2))'=11 W !,"Contact site manager; you must have an active allowable division to sign on."_$C(7),! H 2 G H^XUS ; SIR 25662
 G:XUDIV<1 SNGL ;Check if only one allowable division. - SIR 25662
 I 'DUZ(2)!'$D(DUZ(2,+DUZ(2))) W !!,"You may avoid the next prompt by entering a DEFAULT DIVISION for yourself after invoking the EDIT USER CHARACTERISTICS option."
 I  D ASK I +Y'>0 W !!,"You have no assigned division - an entry is mandatory to continue."_$C(7),! H 2 G H^XUS
 S DUZ(2)=+DUZ(2)_U_XUDIV_U_$P(DUZ(2,+DUZ(2)),U,1) ; 1st piece is internal of current division, 2nd piece is true if allowed in another division, 3rd is division name
 K XUDIV Q
SNGL ; Site parameter switch off, set duz(2) and go on your merry way
 S Y=$O(DUZ(2,"")) I 'Y S DUZ(2)="0^0^UNKNOWN" K XUDIV Q
 S DUZ(2)=+Y_"^0^"_$P(DUZ(2,+Y),U) K XUDIV
 Q
 ;
SWTCH ;Change divisions
 I '$D(^DG(40.8,0))#2 W !,"You have no division file defined",! Q
 N (DIJC,DIJKT,DIJTT,DT,DTIME,DUZ,DWAP,DWK,DWXY,DWXYXY,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOSR,IOST,IOT,IOX,IOXY,IOY,LRWE,POP,U,XQNOSW)  ; protect application variables
 W:+DUZ(2) !!!,"You are currently signed onto Division: ",$P(DUZ(2),U,3),"."
 I '$P(DUZ(2),U,2) W !,"This is the only Division you may currently access.",!! D  Q
 .I $G(LRWE)]"",'$D(XQNOSW) S LRWE=$$^LRUTWE("L")  ; Lab hook
 ; Application may disallow switching - they can put their own message in XQNOSW
 I $D(XQNOSW)#2 W !!,"Switching divisions has been turned off while you are performing these tasks."_$C(7),!,XQNOSW,! Q
 D ASK
 I $G(LRWE)]"",'$G(XQNOPE) S LRWE=$$^LRUTWE("L")  ; Lab hook
 Q
ASK ;
 K DIC,XQCNT S XQCNT=0,DIC="^DG(40.8,",DIC(0)="AEMQ",DIC("A")="Select DIVISION: ",DIC("S")="I $D(DUZ(2,+Y))" ; Screen out unallowables
ASK1 ;
 W !! D ^DIC
 I +Y>0 K DIC W !,"You are now signed onto Division: "_$P(Y,U,2),".",! D
 .S DUZ(2)=+Y_U_$P(DUZ(2),U,2)_U_$P(DUZ(2,+Y),U),^ZUTL("XQ",$J,"DUZ(2)")=DUZ(2)
 .S I=0 F  S I=$O(^ZUTL("XQ",$J,I)),X=$G(^(I)) Q:'I  I $P(X,U,5)="M",$P(X,U,7)]"",'$$^XUSEC($P(X,U,7)) Q:I=$G(^ZUTL("XQ",$J,"T"))  W "But your divisional access is restricted prior to the ",$P(X,U,3),! S ^("T")=I Q
 I +Y>0 K XQCNT Q
 I $G(DUZ(2)) K DIC W !,"No change - you are still in Division: "_$P(DUZ(2),U,3)_".",! S XQNOPE=1
 I '$G(DUZ(2)) S XQCNT=XQCNT+1 W !!,"You have not selected a division - an entry is mandatory to continue."_$C(7),! G:XQCNT<3&($G(X)'=U)&'$G(DTOUT) ASK1 H 3 G H^XUS
 Q
ALWBL ; called from XUSMGR to find user allowable divisions, set up array XUDIV for USER INQUIRY display
 K XUDIV I '$O(^DIC(3,XQD,2,0)) D  ;No entries in user file - all are allowable
 .S I=0 F  S I=$O(^DG(40.8,I)) Q:'I  S:'$G(^DG(40.8,I,28)) XUDIV(I)=$P($G(^DG(40.8,I,0)),U,1)
 E  D  ;entries in user file - get allowables outta there
 .S I=0 F  S I=$O(^DIC(3,XQD,2,I)) Q:'I  S:$D(^DG(40.8,I,0)) XUDIV(I)=$P($G(^DG(40.8,I,0)),U,1)
 Q
XQTSK ;Set up DUZ(2) array for tasked jobs, it may not be set to the right div - entry point from XQ1
 G:$O(DUZ(2,0)) RESET K DUZ(2) S XUDIV=-1 I '$O(^DIC(3,+DUZ,2,0)) D  ;No entries in user file - all are allowable
 .S I=0 F  S I=$O(^DG(40.8,I)) Q:'I  S:'$G(^DG(40.8,I,28)) DUZ(2,I)=$G(^DG(40.8,I,0)),XUDIV=XUDIV+1
 E  D  ;entries in user file - get allowables outta there
 .S I=0 F  S I=$O(^DIC(3,+DUZ,2,I)) Q:'I  I $D(^DG(40.8,I,0)),'$G(^DG(40.8,I,28)) S DUZ(2,I)=$G(^DG(40.8,I,0)),XUDIV=XUDIV+1
RESET ;
 S:'$D(XUDIV) XUDIV=$S($D(DUZ(2))#2:$P(DUZ(2,+$P(XQT,U,2)),U,2),1:0)
 I $D(DUZ(2,+$P(XQT,U,2))) S (XQTDIV,DUZ(2))=+$P(XQT,U,2)_U_XUDIV_U_$P(DUZ(2,+$P(XQT,U,2)),U,1) K XUDIV Q  ; force duz(2) to be same as division tasked from
 S DUZ(2,+$P(XQT,U,2))=$G(^DG(40.8,+$P(XQT,U,2),0)),DUZ(2)=+$P(XQT,U,2)_U_XUDIV_U_$P(DUZ(2,+$P(XQT,U,2)),U,1) ; don't know who user is so set DUZ(2) for this division
 K XUDIV S XQTDIV=DUZ(2)  ; XQTDIV signals applications this option is divisionally tasked
 Q
CHK ; check node for input template XUADDEDITUSER
 S X=$S($D(DG("0;16")):DG("0;16"),1:$P($G(^DIC(3,DA,0)),U,16)) Q:'$L(X)  ;find value of default div
 I $O(^DIC(3,DA,2,0)),'$D(^DIC(3,DA,2,+X)) W !,"The default division is no longer valid - please correct."_$C(7) H 2 S Y=28.2
 Q
