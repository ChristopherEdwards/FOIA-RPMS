PSGS0 ;BIR/CML3-SCHEDULE PROCESSOR ;29 Jan 99 / 8:04 AM
 ;;5.0; INPATIENT MEDICATIONS ;**12,25,26,50,63,74,83,116**;16 DEC 97
 ;
 ; Reference to ^PS(55   is supported by DBIA 2191
 ; Reference to ^PS(51.1 is supported by DBIA 2177
 ;
ENA ; entry point for train option
 D ENCV^PSGSETU Q:$D(XQUIT)
 F  S (PSGS0Y,PSGS0XT)="" R !!,"Select STANDARD SCHEDULE: ",X:DTIME W:'$T $C(7) S:'$T X="^" Q:"^"[X  D:X?1."?" ENQ^PSGSH I X'?1."?" D EN W:$D(X)[0 $C(7),"  ??" I $D(X)#2,'PSGS0Y,PSGS0XT W "  Every ",PSGS0XT," minutes"
 K DIC,DIE,PSGS0XT,PSGS0Y,Q,X,Y,PSGDT Q
 ;
EN3 ;
 S PSGST=$P($G(^PS(53.1,DA,0)),"^",7) G EN
 ;
EN5 ;
 S PSGST=$P($G(^PS(55,DA(1),5,DA,0)),"^",7)
 ;
EN ; validate
 ;/I X[""""!($A(X)=45)!(X?.E1C.E)!($L(X," ")>2)!($L(X)>70)!($L(X)<1)!(X["P RN")!(X["PR N")!($E(X,1)=" ") K X Q
 I X[""""!($A(X)=45)!(X?.E1C.E)!($L(X," ")>3)!($L(X)>70)!($L(X)<1)!(X["P RN")!(X["PR N")!($E(X,1)=" ") K X Q
 S X=$$TRIM^XLFSTR(X,"R"," ")
 I X?.E1L.E S X=$$ENLU^PSGMI(X) I '$D(PSGOES) D EN^DDIOL("  ("_X_")")
 I X["Q0" K X Q
 ;
ENOS ; order set entry
 I $G(X)="",$G(P(2)),$G(P(3)) S X=$G(P(9))
 I $G(X)="" Q
 S PSGXT=$G(PSGS0XT),(PSGS0XT,PSGS0Y,XT,Y,PSJNSS)="" I X["PRN"!(X="ON CALL")!(X="ON-CALL")!(X="ONCALL") G Q
 S X0=X I X,X'["X",(X?2.4N1"-".E!(X?2.4N)) D ENCHK S:$D(X) Y=X G Q
 I $S($D(^PS(51.1,"AC","PSJ",X)):1,1:$E($O(^(X)),1,$L(X))=X) D DIC I XT]"" G Q
 I X["@" D DW S:$D(X) Y=$P(X,"@",2) G Q
 I Y'>0,$S(X="NOW":1,X="ONCE":1,X="STAT":1,X="ONE TIME":1,X="1 TIME":1,X="1TIME":1,X="1-TIME":1,X="ONETIME":1,1:X="ONE-TIME") W:'$D(PSGOES) "  (ONCE ONLY)" S Y="",XT="O" G Q
 I $G(PSGSCH)=X S PSGS0Y=$G(PSGAT),PSGS0XT=$G(PSGXT) Q
 ;
NS I (X="^")!(X="") K X Q
 N NS S NS=0,PSJNSS=0
 I Y'>0 W:'$D(PSGOES) "  (Nonstandard schedule)" S X=X0,Y="",NS=1,PSJNSS=1
 I $E(X,1,2)="AD" K X G Q
 I $E(X,1,3)="BID"!($E(X,1,3)="TID")!($E(X,1,3)="QID") S XT=1440/$F("BTQ",$E(X)) G Q
 S:$E(X)="Q" X=$E(X,2,99) S:'X X="1"_X S X1=+X,X=$P(X,+X,2),X2=0 S:X1<0 X1=-X1 S:$E(X)="X" X2=1,X=$E(X,2,99)
 S XT=$S(X["'":1,(X["D"&(X'["AD"))!(X["AM")!(X["PM")!(X["HS"&(X'["THS")):1440,X["H"&(X'["TH"):60,X["AC"!(X["PC"):480,X["W":10080,X["M":40320,1:-1) I XT<0,Y'>0 K X G Q
 S X=X0 I XT S:X2 XT=XT\X1 I 'X2 S:X["QO" XT=XT*2 S XT=XT*X1
 ;
Q ;
 ;S PSGS0XT=$S(XT]"":XT,1:""),PSGS0Y=$S(Y:Y,1:"") K QX,SDW,SWD,X0,XT,Z Q
 S PSGS0XT=$S(XT]"":XT,1:""),PSGS0Y=$S(Y:Y,1:"") S:PSGS0XT<0 PSGS0XT=""
Q2 I $G(X)]"" I $D(^PS(51.1,"AC","PSJ",X)) N FREQ S FREQ=PSGS0XT D
 .N PSGS0XT,PSGS0Y,PSGST S PSGS0XT=FREQ D ADMIN^PSJORPOE S PSGS0XT=FREQ I $D(LYN) S I="" F  S I=$O(LYN("DILIST",2,I)) Q:'I!'$G(PSJNSS)  D
 ..S SCHFIL=LYN("DILIST",2,I) I SCHFIL S SCHFIL=$G(^PS(51.1,SCHFIL,0)) I $P(SCHFIL,"^",3) I $P(SCHFIL,"^",3),($P(SCHFIL,"^",3)=$G(PSGS0XT)) S PSJNSS=0
 I ($G(PSJNSS)&($G(VALMBCK)'="Q"))&(($G(PSGS0XT)>0)!($G(PSJLIFNI))) D NSSCONT($S($G(PSGOSCH)]"":$G(PSGOSCH),1:$G(X)),PSGS0XT)
 K QX,SDW,SWD,X0,XT,Z Q
 ;
NSSCONT(SCH,FREQ) ;
 Q:SCH=""!(FREQ="")!($G(VALMBCK)]"")!$G(PSGMARSD)!$G(PSIVFN1)
 I $G(PSGOES),'$G(NSFF) Q
 N PSGS0XT,PSGSCH,DIR,X,Y S PSGSCH=SCH,PSGS0XT=FREQ,PSJNSS=1
 D NSSMSG I PSJNSS]"" W !,PSJNSS S PSJNSS=1
 S DIR(0)="EA",DIR("A")="Press Return to continue..." D ^DIR
 K NSFF Q
 ;
NSSMSG ;
 I '(",D,O,"[(","_$G(PSGST)_",")),$G(PSJNSS),$G(PSGSCH)]"" D  Q
 . S PSJNSS="  WARNING - this non-standard schedule will be due every "_$$NSO^PSGS0(PSGS0XT)
 S PSJNSS="" Q
 ;
NSO(FQ) ;
 Q:'FQ!(FQ<0)!(",D,O,"[(","_$G(PSGST)_",")) ""
 K FRQOUT S FRQOUT=$S(FQ<60:(FQ_"minute"),(FQ<1440)&(FQ#60):(FQ_" minute"),(FQ<1440)!(FQ#1440):(FQ/60_" hour"),1:(FQ/1440_" day")) D
 . S:(+FRQOUT'=1) FRQOUT=FRQOUT_"s"
 Q FRQOUT
 ;
ENCHK ;
 I $S($L($P(X,"-"))>4:1,$L(X)>119:1,$L(X)<2:1,X'>0:1,1:X'?.ANP) K X Q
 S X(1)=$P(X,"-") I X(1)'?2N,X(1)'?4N K X Q
 S X(1)=$L(X(1)) I X'["-",X>$E(2400,1,X(1)) K X Q
 F X(2)=2:1:$L(X,"-") S X(3)=$P(X,"-",X(2)) I $S($L(X(3))'=X(1):1,X(3)>$E(2400,1,X(1)):1,1:X(3)'>$P(X,"-",X(2)-1)) K X Q
 K:$D(X) X(1),X(2),X(3) Q
 ;
DIC ;
 K DIC S DIC="^PS(51.1,",DIC(0)=$E("E",'$D(PSGOES))_"ISZ",DIC("W")="W ""  "","_$S('$D(PSJPWD):"$P(^(0),""^"",2)",'PSJPWD:"$P(^(0),""^"",2)",1:"$S($D(^PS(51.1,+Y,1,+PSJPWD,0)):$P(^(0),""^"",2),1:$P(^PS(51.1,+Y,0),""^"",2))"),D="APPSJ"
 I $D(PSGST) ;S DIC("S")="I $P(^(0),""^"",5)"_$E("'",PSGST'="O")_"=""O"""
 D IX^DIC K DIC S:$D(DIE)#2 DIC=DIE Q:Y'>0
 S XT=$S("C"[$P(Y(0),"^",5):$P(Y(0),"^",3),1:$P(Y(0),"^",5)),X=+Y,Y="" I $D(PSJPWD),$D(^PS(51.1,X,1,+PSJPWD,0)) S Y=$P(^(0),"^",2)
 S (X,X0)=Y(0,0) S:Y="" Y=$P(Y(0),"^",2) Q
DW ;
 S SWD="SUNDAYS^MONDAYS^TUESDAYS^WEDNESDAYS^THURSDAYS^FRIDAYS^SATURDAYS",SDW=X,X=$P(X,"@",2) D ENCHK Q:'$D(X)  S X=$P(SDW,"@"),X(1)="-" I X?.E1P.E,X'["-" F QX=1:1:$L(X) I $E(X,QX)?1P S X(1)=$E(X,QX) Q
 F Q=1:1:$L(X,X(1)) K:SWD="" X Q:SWD=""  S Z=$P(X,X(1),Q) D DWC Q:'$D(X)
 K X(1) S:$D(X) X=SDW Q
DWC I $L(Z)<2 K X Q
 F QX=1:1:$L(SWD,"^") S Y=$P(SWD,"^",QX) I $P(Y,Z)="" S SWD=$P(SWD,Y,2) S:$L(SWD) SWD=$E(SWD,2,50) Q
 E  K X
 Q
