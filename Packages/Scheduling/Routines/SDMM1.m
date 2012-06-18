SDMM1 ;ALB/GRR - MULTIPLE BOOKINGS ; [ 04/22/2004  5:18 PM ]
 ;;5.3;Scheduling;**28,206,168,1001**;Aug 13, 1993
 ;IHS/ANMC/LJF 7/06/2000 hard set of date appt made now includes time
 ;            12/13/2000 added check for overbook access by clinic
 ;             6/22/2001 added call to create xref on date appt made
 ;
MAKE S (SDX3,X,SD)=Y,SM=0 D DOW^SDM0 I $D(^DPT(DFN,"S",X)) S I=^(X,0) I $P(I,"^",2)'["C" W !,"PATIENT ALREADY HAS APPOINTMENT ON ",$P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC","^",$E(X,4,5))," ",$E(X,6,7)," AT THAT TIME" Q
 S SDX7=X D SDFT^SDMM S X=SDX7 I $P(SDX3,".")'<SDEDT W !,*7,"EXCEEDS MAXIMUM DAYS FOR FUTURE APPOINTMENT!!",*7 Q
S S SDNOT=0 I '$D(^SC(SC,"ST",$P(X,"."),1)) S SS=$O(^SC(+SC,"T"_Y,X)) G X:'SS,X:^(SS,1)="" S ^SC(+SC,"ST",$P(X,"."),1)=$E($P($T(DAY),U,Y+2),1,2)_" "_$E(X,6,7)_$J("",SI+SI-6)_^(1),^(0)=$P(X,".")
SC S POP=0,SD=X D SC^SDM1 I SDLOCK W ! D DT W " HAS BEEN LOCKED BY ANOTHER USER - APPT NOT BOOKED" L  Q
 G X:POP,OK:SM#9=0 S SDY=Y,Y=X
 ;
 D OB I SDNOT=0 Q  ; check overbook/keys...quit if not ok
 S SM=9 G SC
 ;
OK S ^SC(SC,"ST",$P(X,"."),1)=S,^SC(SC,"S",X,0)=X S:'$D(^DPT(DFN,"S",0)) ^(0)="^2.98^^" S:'$D(^SC(SC,"S",0)) ^(0)="^44.001DA^^" L
 ;
 ;IHS/ANMC/LJF 7/06/2000;6/22/2001
S1 ;L ^SC(SC,"S",X,1):5 G:'$T S1 F Y=1:1 I '$D(^SC(SC,"S",X,1,Y)) S:'$D(^(0)) ^(0)="^44.003PA^^" S ^(Y,0)=DFN_U_(+SL)_U_U_D_U_U_$S($D(DUZ):DUZ,1:"")_U_DT_U_U_U_$S(+SDEMP:+SDEMP,1:"") S SDY=Y L  Q
 L ^SC(SC,"S",X,1):5 G:'$T S1 F Y=1:1 I '$D(^SC(SC,"S",X,1,Y)) S:'$D(^(0)) ^(0)="^44.003PA^^" S ^(Y,0)=DFN_U_(+SL)_U_U_D_U_U_$S($D(DUZ):DUZ,1:"")_U_$$NOW^XLFDT_U_U_U_$S(+SDEMP:+SDEMP,1:"") D XREFC^BSDDAM(SC,X,Y) S SDY=Y L  Q
 ;
 I SM S ^("OB")="O" ;NAKED REFERENCE - ^SC(IFN,"S",Date,1,"OB")
 I $D(^SC(SC,"RAD")),^("RAD")="Y"!(^("RAD")=1) S ^SC("ARAD",SC,X,DFN)=""
 S SDINP=$$INP^SDAM2(DFN,X)
 ;S COV=3,SDYC="",COV=$S(COLLAT=1:1,1:3),SDYC=$S(COLLAT=7:1,1:""),^DPT(DFN,"S",X,0)=SC_"^"_$$STATUS^SDM1A(SC,SDINP,X)_"^^^^^"_COV_"^^^^"_SDYC_"^^^^^"_SDAPTYP_"^^^"_DT_"^^^^^^M^0",SDMADE=1
 S COV=3,SDYC="",COV=$S(COLLAT=1:1,1:3),SDYC=$S(COLLAT=7:1,1:""),^DPT(DFN,"S",X,0)=SC_"^"_$$STATUS^SDM1A(SC,SDINP,X)_"^^^^^"_COV_"^^^^"_SDYC_"^^^^^"_SDAPTYP_"^^^"_$$NOW^XLFDT_"^^^^^^M^0",SDMADE=1   ;IHS/ANMC/LJF 7/06/2000
 D XRDT(DFN,X)  ;xref DATE APPT. MADE field
 K:$D(^DPT("ASDCN",SC,X,DFN)) ^(DFN) K:$D(^DPT(DFN,"S",X,"R")) ^("R")
 S SDRT="A",SDTTM=X,SDPL=SDY,SDSC=SC D RT^SDUTL
 L  W !,"APPOINTMENT MADE ON " S Y=X D DT^DIQ
 D EVT
 Q
 ;
XRDT(DFN,X) ;cross reference DATE APPT. MADE field
 ;Input: DFN=patient ifn
 ;Input: X=appointment date
 N DIK,DA,DIV S DA=X,DA(1)=DFN
 S DIK="^DPT(DA(1),""S"",",DIK(1)=20 D EN1^DIK
 Q
 ;
NOOB S SDMES="NO OPEN SLOTS ON "
WRTER W !,SDMES D DT W:SDNOT " AT THAT TIME" S SDNOT=0 Q
DT W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC","^",$E(X,4,5))," ",$E(X,6,7) Q
DAY ;;^SUN^MON^TUES^WEDNES^THURS^FRI^SATUR
 ;
X L  I SDZ=1 W !,*7,"CLINIC DOES NOT MEET THEN!!" S SDERRFT=1 Q
 S SDMES="CLINIC DOES NOT MEET ON " G WRTER
 ;
EVT ; -- separate tag if need to NEW vars
 ;N D,SI,SC,SL,COLLAT D MAKE^SDAMEVT(DFN,SDTTM,SDSC,SDPL,0)
 N D,SI,SC,SL,COLLAT,SD D MAKE^SDAMEVT(DFN,SDTTM,SDSC,SDPL,0)  ;IHS/ITSC/LJF 4/22/2004 PATCH #1001
 Q
 ;
OB ; check for overbook keys
 N %,D,I,S,ST
 S SDNOT=1
 ;I '$D(^XUSEC("SDOB",DUZ)),'$D(^XUSEC("SDMOB",DUZ)) D NOOB G OBQ ; user has neither key  ;IHS/ANMC/LJF 12/13/2000
 I '$$OVRBKUSR^BSDU(DUZ,+SC) D NOOB G OBQ ; user has neither key  ;IHS/ANMC/LJF 12/13/2000
 S I=$P(SD,".",1),(S,ST)=$P(SL,U,7) ; counter of OBs for day = ST
 I ST F D=I-.01:0 S D=$O(^SC(SC,"S",D)) Q:$P(D,".",1)-I  F %=0:0 S %=$O(^SC(SC,"S",D,1,%)) Q:'%  I $P(^(%,0),"^",9)'["C",$D(^("OB")) S ST=ST-1
 I ST<1 D  G OBQ
 . ;I '$D(^XUSEC("SDMOB",DUZ)) W !,*7,"ONLY "_S_" OVERBOOK"_$E("S",S>1)_" ALLOWED PER DAY!!" D NOOB Q  ;IHS/ANMC/LJF 12/13/2000
 . I '$$MOVBKUSR^BSDU(DUZ,+SC) W !,*7,"ONLY "_S_" OVERBOOK"_$E("S",S>1)_" ALLOWED PER DAY!!" D NOOB Q  ;IHS/ANMC/LJF 12/13/2000
 . S MXOK=$$DIR("WILL EXCEED MAXIMUM ALLOWABLE OVERBOOKS FOR "_$$FMTE^XLFDT(Y)_", OK","YES")
 . I 'MXOK S SM=9,SDNOT=0 Q
 . I MXOK S S=^SC(SC,"ST",I,1),SM=9,MXOK=""
 ;I '$D(^XUSEC("SDOB",DUZ)) D NOOB G OBQ  ;IHS/ANMC/LJF 12/13/2000
 I '$$OVRBKUSR^BSDU(DUZ,+SC) D NOOB G OBQ      ;IHS/ANMC/LJF 12/13/2000
 I '$$DIR($$FMTE^XLFDT(Y)_" WILL BE AN OVERBOOK, OK","NO") S SM=9,SDNOT=0
OBQ Q
 ;
DIR(TEXT,DEF) ; reader processor
 ; Input:  TEXT as text of read
 ;         DEF as default response (if any)
 ;
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="Y",DIR("A")=TEXT
 I $G(DEF)]"" S DIR("B")=DEF
 D ^DIR
 W:'Y !
 Q Y
