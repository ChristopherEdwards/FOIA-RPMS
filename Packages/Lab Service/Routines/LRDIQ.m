LRDIQ ;DALOI/FHS - MODIFIED LAB VERSION OF CAPTIONED TEMPLATE FILEMAN 19 ;1/10/92  10:23 AM
 ;;5.2T9;LR;**1018**;Nov 17, 2004
 ;;5.2;LAB SERVICE;**86,153,263**;Sep 27, 1994
 Q
 ;
GUY S:'$D(DTIME) DTIME=60 K DTOUT,DUOUT,DIRUT,DIR
 S D0=DA,D=DIC_DA_",",DL=1 S:$S('$D(S)#2:1,1:'S) S=3 I '$D(DIQS) W !
 E  S Z=0 F A=0:0 S @("Z=$O("_DIQS_"Z))") S:Z="" Z=-1 Q:Z<0  S @(DIQS_"Z)=""""")
 I $D(DX(0))[0 S DX(0)="Q" D
 . I $D(IOST)#2,IOST?1"C".E S DX(0)="S S=$Y I S>22 N X,Y S DIR(0)=""E"" D ^DIR K DIR W @IOF S S=$S($D(DIRUT):0,1:1)"
 . I $D(IOST)#2,IOST?1"P".E S DX(0)="S S=S+1 I S>60 W @IOF S S=1"
1 I $D(DIQS) S Z=0 F A=0:0 S @("Z=$O("_DIQS_"Z))") Q:Z=""  S A=$O(^DD(DD,"B",Z,0)) Q:A=""  I $D(^DD(DD,A,0)) S C=$P(^(0),U,2) I C["C" D COM S @(DIQS_"Z)=X")
 I N<0,$D(^DD(DD,.001,0)) S W=.001,A=-1,Y=@("D"_(DL\2)) G W
N S @("N=$O("_D_"N))") S:N="" N=-1 I DL=1,@E D LF D:$D(DIQ(0)) ^DIQ1:DIQ(0)["C" G Q
 ;NAKED REFERENCE ^DD(FILE#,FIELD#,N)
 I $D(^(N))#2 S Z=^(N),A=-1 G NS
 I N<0 S DL=DL-1 G B
 I DL#2 S Z=$O(^DD(DD,"GL",N,0,0)) S:Z="" Z=-1 G N:Z<0 S O=0,X=+$P(^DD(DD,Z,0),"^",2) X:$D(DICS) DICS E  G N
 E  G N:N'>0 S X=DD,O=-1,@("D"_(DL\2)_"=N") D LF Q:'S  I $D(DSC(X)) X DSC(X) E  G N
 S DD(DL)=DD,D(DL)=D,N(DL)=N,DL=DL+1 S:+N'=N N=""""_N_"""" S D=D_N_",",N=O,DD=X G 1:DL#2,N
 ;
B I $D(DIQ(0)),DIQ(0)["C",'(DL#2) D ^DIQ1
 S N=N(DL),D=D(DL),DD=DD(DL) D LF Q:'S  G N
 ;
DIQS S @(DIQS_"O)=Y")
NS S A=$O(^DD(DD,"GL",N,A)) S:A="" A=-1 G N:A<0
 S W=$O(^DD(DD,"GL",N,A,0)) I A S Y=$P(Z,"^",A) G W:Y]"",NS
 S Y=$E(Z,+$E(A,2,9),$P(A,",",2)) G NS:Y?." "
W S O=$P(^DD(DD,W,0),"^"),C=$P(^(0),"^",2) I $D(DICS) X DICS E  G NS
 I C["W",'$D(DIQS) D DIQ^DIWW G:$D(DN) Q:'DN S DL=DL-2 G B
 D Y I $D(DIQS) G @("DIQS:$D("_DIQS_"O))"),NS:'$D(^(W)) S O=W G DIQS
 I $X+$L(O)+$L(Y)+2>IOM S O=$E(O,1,253-$L(Y))
 S O=O_": "_Y I  D LF Q:'S
 W O W:$X+8<IOM ?$X+1\25+1*25 G NS
 ;
Y I C["O",$D(^(2)) X ^(2) Q  ;NAKED REFERENCE IS TO ^DD(FILE#,FIELD#,0)
S ;NAKED REFFERENCE ^DD(FILE#,FIELD#,0)
 I C["S" S C=";"_$P(^(0),U,3),%=$F(C,";"_Y_":") S:% Y=$P($E(C,%,999),";",1) Q:N<.01  I N>0 S:$P($G(Z),U,2)]""&(DIC["""CH""") Y=Y_" "_$P(Z,U,2) Q:DIC'["""CH"""  D VER Q
 I C["N" Q:N<.01  I N>0 S:$P($G(Z),U,2)]""&(DIC["""CH""") Y=Y_" "_$P(Z,U,2) Q:DIC'["""CH"""  D VER Q
 I C["F" Q:N<.01  I N>0 S:$P($G(Z),U,2)]""&(DIC["""CH""") Y=Y_" "_$P(Z,U,2) Q:DIC'["""CH"""  D VER Q
 I C["P",$D(@("^"_$P(^(0),U,3)_"0)")) S C=$P(^(0),U,2) Q:'$D(^(+Y,0))  S Y=$P(^(0),U) I $D(^DD(+C,.01,0)) S C=$P(^(0),U,2) G S
 I C["V",+Y,$D(@("^"_$P(Y,";",2)_"0)")) S C=$P(^(0),U,2) Q:'$D(^(+Y,0))  S Y=$P(^(0),U) I $D(^DD(+C,.01,0)) S C=$P(^(0),U,2) G S
 Q:C'["D"  Q:'Y
D S %=$E(Y,4,5)*3,Y=$S(%:$E("JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC",%-2,%)_" ",1:"")_$S($E(Y,6,7):$J(+$E(Y,6,7),2)_", ",1:"")_($E(Y,1,3)+1700)_$S(Y[".":"@"_$E(Y_0,9,10)_":"_$E(Y_"000",11,12)_$S($E(Y,13,14):":"_$E(Y_0,13,14),1:""),1:"") Q
 ;
DT D D:Y W Y Q
H G H^DIO2
 ;
LF I '$D(DIQS),$X W ! X DX(0)
 Q
EN1 S DRX=DR
EN2 S DR=$P(DRX,";",1),DRX=$P(DRX,";",2,999) D EN W ! G EN2:DRX]""&S
 K DRX Q
EN ;From LRLIST,LROE1,LRSOR,LRVR4 Patched for Fileman 20
 S:'$G(S) S=1
 I '$D(IOST)!'$D(IOSL)!'$D(IOM) S IOP="HOME" D ^%ZIS Q:POP
 G Q:'$D(@(DIC_"0)")) S U="^",DD=+$P(^(0),U,2),DK=DD
 I '$D(DR) S N=-1,O=""
 E  S N=$P(DR,":"),N=$S(0[N:-1,+N=N:N-.000001,1:$E(N,1,$L(N)-1)_$C($A(N,$L(N))-1)),O=$P(DR,":",DR[":"+1) G EN1:DR[";"
 S E="N<0" I O]"" S E=E_"!(N]"""_$S(+O=O:"?"")!(N>"_O_")",1:O_""")")
 D GUY S DA=D0 I $D(DIQ(0)),DIQ(0)["A" D AUD^DII
Q K C,O,W,N,E,Z,D,DD,IOP Q
 ;
COM ;NAKED REFERENCE ^DD(FILE#,FIELD#,0)
 X $P(^(0),U,5,99) S C=$P($P(C,"J",2),",",2) I C?1N.E,X S X=$J(X,0,C) Q
VER ;Set non FileMan fields  - only shown on LRVERIFY security key on certain supervisor reports
 ;
 N LRX,LRNG,ZZU,LRSP,LN,LNC
 I N>0,$P($G(LRLABKY),U,2),$P($G(Z),U,4) D
 . S LNC=+$P($P(Z,U,3),"!",3)
 . S ZZ="",ZZU="["_$P(Z,U,4)_$S($P(Z,U,9):"/"_$P(Z,U,9),1:"")_$S(LNC:"/L-"_LNC,1:"")_"]  "
 . I $G(LRLONG)=1 S Y=Y_"  "_ZZU Q  ; set Result[DUZ/INSTITUTION/LOINC CODE]
 . Q:'$G(AGE)!('$G(LRDFN))  S LRNG=$P(Z,U,5) Q:'$L(LRNG)  ;Set normal or therapuetic ranges.
 . F LRX=1,2,3,4,5,11,12 S @("LRNG"_LRX)=$S($L($P(LRNG,"!",LRX)):$P(LRNG,"!",LRX),1:"")
 . I $L(LRNG2)!($L(LRNG3)) S ZZ="  ("_LRNG2_"-"_LRNG3_" "_$P(LRNG,"!",7)_")"
 . I $L(LRNG11)!($L(LRNG12)) S ZZ="  (t* "_LRNG11_"-"_LRNG12_" "_$P(LRNG,"!",7)_")"
 . S $P(LN," ",81)=""
 . S LRSP=(70-($L(ZZ)+$L(ZZU)+$L(Y)+$L(O))) S Y=Y_$E(LN,1,LRSP)_ZZ_" "_ZZU
 Q
