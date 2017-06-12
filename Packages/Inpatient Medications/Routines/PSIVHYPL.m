PSIVHYPL ;BIR/PR-PRINT OUT LABELS ;05-May-2014 19:00;DU
 ;;5.0; INPATIENT MEDICATIONS ;**58,96,128,178,184,1010,1015,1018**;16 DEC 97;Build 21
 ;
 ; Reference to ^%ZIS(2 is supported by DBIA 3435.
 ; Reference to ^PS(52.6 is supported by DBIA 1231.
 ; Reference to ^PS(52.7 is supported by DBIA 2173.
 ; Reference to ^PS(55 is supported by DBIA 2191.
 ; Reference to ^PS(50.4 is supported by DBIA 2175.
 ; Reference to ^PS(51.2 is supported by DBIA 2178.
 ; Modified - IHS/CIA/PLS - 12/05/03 Line SSWARD+4
 ;NEEDS DFN, ON AND PSIVNOL (Total number of labels to print) and
 ;PSIVCT - $D(PSIVCT) NO COUNT LABEL
 ;
 ; Modified - IHS/MSC/PB - 4/25/12 to add expiration date to the iv label. Added line tag OFFSET,
 ; lines BARCODE+1,2,&3
 ;          - IHS/MSC/PB - 2/11/13 modified line BARCODE + 3 to use a $G to prevent errors if the PRTFLG variable is not set
 ;          - IHS/MSC/PB - 2/13/13 modified line RE+7 to set the TEXT1 variable to "_________" if the offset is '>0
 ;          - IHS/MSC/PB - 3/1/13 modified to incorporate changes made by VA for BCMA project
 ;            IHS/MSC/PLS - 05/05/14 - Removed modifications at BARCODE+1
SSWARD ;Get patient SS# and ward location
 N X0,PSJIO,I
 S I=0 F  S I=$O(^%ZIS(2,IOST(0),55,I)) Q:'I  S X0=^(I,0),PSJIO($P(X0,"^"))=^(1)
 S PSJIO=$S('$D(PSJIO):0,1:1)
 ; IHS/CIA/PLS - 03/31/04 - Change SSN to HRN
 ;D ENIV^PSJAC S VADM(2)=$E(VADM(2),6,9),PSIVWD=$S(+VAIN(4):$P(VAIN(4),U,2),1:"Opt. IV")
 D ENIV^PSJAC S VADM(2)=$G(VA("BID")),PSIVWD=$S(+VAIN(4):$P(VAIN(4),U,2),1:"Opt. IV")
 G:PSIVNOL<1 Q D SETP,^PSIVHYP S PSIVRM=$P(PSIVSITE,U,13),P16=$P($G(^PS(55,DFN,"IV",+ON,9)),U,3) S:PSIVRM<1 PSIVRM=30 I $D(PSIVCT),PSIVCT'=1 K PSIVCT
 I PSJIO,$G(PSJIO("FI"))]"" X PSJIO("FI")
 I $P(PSIVSITE,U,7) D
 . S PSIVFLAG=1,(LINE,PSIV1)=0,PSIV2=PSIVNOL,PSIVNOL=0 D RE
 . S PSIVRP="",PSIVRT=""
 . I $D(^PS(55,DFN,"IV",+ON,.2)) S PSIVRP=$P(^PS(55,DFN,"IV",+ON,.2),U,3) D
 .. I PSIV1'>0!'$P(PSIVSITE,U,3)!($P(PSIVSITE,U,3)=1&(P(4)'="P"))!($P(PSIVSITE,U,3)=2&("AH"'[P(4))) Q   ;QUIT IF "DOSE DUE AT" LINE IS SET TO NOT PRINT
 .. S PSIVRT=$P(^PS(51.2,PSIVRP,0),U,1)
 .. S X="ROUTE: "_PSIVRT D:X]"" PMR
 . S X="Solution: _______________" D PRNTL S X="Additive: _______________" D PRNTL
 . S PSIVNOL=PSIV2
 . I 'PSJIO F LINE=LINE+1:1:(PSIVSITE+$P(PSIVSITE,U,16)) W !
 . I PSJIO,$G(PSJIO("EL"))]"" X PSJIO("EL")
 I '$D(PSIVCT) D NOW^%DTC S Y=%,$P(^PS(55,DFN,"IV",+ON,9),U,1,2)=Y_"^"_PSIVNOL,$P(^(9),U,3)=$P(^(9),U,3)+PSIVNOL
 K PSIVFLAG,PSIVSH
START F PSIV1=1:1:PSIVNOL D
 . S LINE=0 D RE
 . Q:$D(PSIVFLAG)
 . I 'PSJIO F LINE=LINE+1:1:(PSIVSITE+$P(PSIVSITE,U,16)) W !
 . I PSJIO,$G(PSJIO("EL"))]"" X PSJIO("EL")
 I PSJIO,$G(PSJIO("FE"))]"" X PSJIO("FE")
 D:'$D(PSIVCT) ^PSIVSTAT
Q K HYPL,LINE,MESS,P16,PDATE,PDOSE,PSIV,PSIVA,PSIV1,PSIV2,PSIVCT,PSIVDOSE,PSIVFLAG,PSIVRM,PSIVWD,TVOL,HYPLPRT,PSIMESS,TEXT1,IHSEXDT Q
RE I PSIV1 S:P(15)>2880!('P(15)) P(15)=2880 S P(16)=P16+PSIV1#(1440/P(15)+.5\1) S:'P(16) P(16)=1440/P(15)+.5\1
 K DO
 I PSJIO,$G(PSJIO("SL"))]"" X PSJIO("SL")
 I PSIV1 S PSJBCID=$$BCMA^PSIVBCID(DFN,ON,$D(PSIVCT),$G(PSIV1),$G(PSIV2),$G(PSIVNOL)) D BARCODE
 ;IHS/MSC/PB - 4/25/12 - next line computes the IV label expiration date
 I $P($G(^PS(59.5,PSIVSN,9999999)),U)=1 D    ;,$P($G(^PS(55,DFN,"IV",+ON,9999999)),U,1)'="" D
 .;IHS/MSC/PB - 2/13/13 modified the line below to set TEXT1 = "___________" if the offset parameter is 0 or null
 .;Q:$P($G(^PS(55,DFN,"IV",+ON,9999999)),U)'>0
 .N EXDT,XX1
 .I $P($G(^PS(55,DFN,"IV",+ON,9999999)),U)'>0 S (IHSEXDT,TEXT1)="________" Q
 .S XX1=$P(^PS(55,DFN,"IV",+ON,9999999),U),EXDT=$$FMADD^XLFDT($$DT^XLFDT(),XX1)
 .S (IHSEXDT,TEXT1)=$$FMTE^XLFDT(EXDT,"5Z")
 .;MSC/IHS/PB - 3/1/13 modified to incorporate changes by VA for BCMA project
 ;.S IHSEXDT=TEXT1  ;D OFFSET^PSIVLABL(X,TEXT1)
 ;MSC/IHS/PB - 3/1/13 modified to incorporate changes by VA for BCMA project
 ;APSP/PB modified the following line to print the expiration date on the second line.
 ;S X="["_$P(^PS(55,DFN,"IV",+ON,0),U)_"]"_" "_VADM(2)_"  "_PSIVWD_"  "_$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3) D P
 ;S X="["_$P(^PS(55,DFN,"IV",+ON,0),U)_"]"_" "_VADM(2)_"  "_PSIVWD_"  "_$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)
 ;D:$P($G(^PS(59.5,PSIVSN,9999999)),"^")=1&($D(TEXT1)) OFFSET^PSIVLABL(X,TEXT1)
 ;I $G(PRTFLG)=0 S X=$G(PRTLINE)
 ;D PRNTL
 S X="["_$P(^PS(55,DFN,"IV",+ON,0),U)_"]"_" "_VADM(2)_"  "_PSIVWD_"  "_$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3) D PRNTL
 S X=VADM(1) S:$P(PSIVSITE,U,9) X=X_"  "_$S(VAIN(5)]"":VAIN(5),1:"NF") D PRNTL S X=" " D PRNTL
 D:$P(PSIVSITE,U,12) TVOL
 S X="",$P(X,"=",PSIVRM-1)="" D PRNTL
 I $D(PSIVFLAG) F PSIV=0:0 S PSIV=$O(^PS(55,DFN,"IV",+ON,"AD",PSIV)) Q:'PSIV  S Y=^(PSIV,0),X=$S($D(^PS(52.6,+Y,0)):$P(^(0),U),1:"*********")_"  "_$P(Y,U,2)_" " S:$P(Y,U,3)]"" X=X_" ("_$P(Y,U,3)_")" D
 . D PRNTL
 . D MESS
 I $D(PSIVFLAG) F PSIV=0:0 S PSIV=$O(^PS(55,DFN,"IV",+ON,"SOL",PSIV)) Q:'PSIV  S PSIV=PSIV_"^"_+^(PSIV,0),YY=^(0) D
 . D SOL1,PRNTL
 . S X=$P(^PS(52.7,$P(PSIV,U,2),0),U,4) I X]"" S X="   "_X D PRNTL
 G:$D(PSIVFLAG) SOL
 F PSIV=0:0 S PSIV=$O(^PS(55,DFN,"IV",+ON,"SOL",PSIV)) Q:'PSIV  S PSIV=PSIV_"^"_+^(PSIV,0),YY=^(0) D
 . D SOL1,PRNTL I PSIV1 D UP3^PSIVBCID(DFN,PSJBLN,PSIV,YY)
 . S X=$P(^PS(52.7,$P(PSIV,U,2),0),U,4) I X]"" S X="   "_X D PRNTL
 F I=0:0 S I=$O(HYPL(I)) Q:'I  S PSIV="" D
 . F I=I:0 S PSIV=$O(HYPL(I,PSIV)) Q:PSIV=""  S Y="",X=0 D
 .. X "F ZZ=0:0 S Y=$O(HYPL(I,PSIV,Y)) Q:Y=""""  I Y=""ALL""!(Y=""***"")!(Y[P(16)) S X=X+$P(HYPL(I,PSIV,Y),U),PSIVP=HYPL(I,PSIV,Y) D UPD"
 .. I X D HYP
 K HYPAD
SOL S X="",$P(X,"=",PSIVRM-1)="" D PRNTL
 S X=" " D PRNTL I PSIV1'>0!'$P(PSIVSITE,U,3)!($P(PSIVSITE,U,3)=1&(P(4)'="P"))!($P(PSIVSITE,U,3)=2&("AH"'[P(4))) G MEDRT
 S:'$D(PSIVDOSE) PSIVDOSE="" S X=$P(PSIVDOSE," ",PSIV1) D:$E(X)="." CONVER^PSIVLABL S X="Dose due at: "_$S(X="":"________",1:$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)_" "_$E(X#1_"000",2,5)) D PRNTL
 ;
MEDRT ;Find Medication Route
 S PSIVRP="",PSIVRT=""
 I $D(^PS(55,DFN,"IV",+ON,.2)) S PSIVRP=$P(^PS(55,DFN,"IV",+ON,.2),U,3) D
 .S PSIVRT=$P(^PS(51.2,PSIVRP,0),U,1)
 .S X="ROUTE: "_PSIVRT D:X]"" PMR
 ;
INF S X=$P(P(8),"@") D:X]"" PRNTL
 I $D(^PS(55,DFN,"IV",+ON,3)) S X=$P(^(3),U) D:X]"" PRNTL
 S X=P(9) D:X]"" PRNTL
 S X=P(11) D:X]"" PRNTL
 ;PSJ*5*184 - Display all messages if more than one additive has a message.
 I $D(MESS) S PSIMESS="" F  S PSIMESS=$O(MESS(PSIMESS)) Q:PSIMESS=""  S X=PSIMESS D PRNTL
 I $D(^PS(59.5,PSIVSN,4)) S Y=^(4) F PSIV=1:1 S X=$P(Y,U,PSIV) Q:X=""  D PRNTL
 ;MSC/IHS/PB - 3/1/13 modified to incorporate changes by VA for BCMA project
 ;S X=PSIV1_"["_PSIVNOL_"]" D PRNTL
 S X=PSIV1_"["_PSIVNOL_"]" I $G(IHSEXDT) D OFFSET^PSIVLABL(X,"Do Not Use After: "_IHSEXDT) I $G(PRTFLG)=0 S X=PRTLINE  ;PRINT EXP DATE ON LAST LINE
 D PRNTL
 Q
PRNTL N I F LINE=LINE+1:1 D  Q:$L(X)<1
 . I LINE>PSIVSITE D
 .. S LINE=1
 .. I 'PSJIO D  Q
 ... F ZZ=1:1 Q:ZZ>$P(PSIVSITE,"^",16)  W !
 .. F I="EL","SL" I $G(PSJIO(I))]"" X PSJIO(I)
 . K ZZ
 . F I="ST","STF" I $G(PSJIO(I))]"" X PSJIO(I)
 . W $E(X,1,PSIVRM)
 . F I="ETF","ET" I $G(PSJIO(I))]"" X PSJIO(I)
 . I 'PSJIO W !
 . S X=$E(X,PSIVRM+1,999)
 Q
PMR ; Print Med Route on label
 ;
 F LINE=LINE+1:1 D  Q:$L(X)<1
 . I LINE>PSIVSITE D
 .. S LINE=1
 .. I 'PSJIO D  Q
 ... F ZZ=1:1 Q:ZZ>$P(PSIVSITE,"^",16)  W !
 .. F I="EL","SL" I $G(PSJIO(I))]"" X PSJIO(I)
 . K ZZ
 . ;
 . F I="ST","STF","SM","SMF" I $G(PSJIO(I))]"" X PSJIO(I)
 . W $E(X,1,PSIVRM)
 . F I="ETF","ET","EMF","EM" I $G(PSJIO(I))]"" X PSJIO(I)
 . I 'PSJIO W !
 . S X=$E(X,PSIVRM+1,999)
 Q
TVOL ;
 S PSIV=TVOL F X=0:0 S X=$O(^PS(55,DFN,"IV",+ON,"AD",X)) Q:'X  S X=X_"^"_^(X,0) S:$P(X,U,4)[P(16)!($P(X,U,4)="")!'PSIV1 PSIV=PSIV+$S($P(^PS(52.6,$P(X,U,2),0),U,10):$P(X,U,3)/$P(^(0),U,10),1:0)
 S X="Total Volume: "_(PSIV+.5\1) D PRNTL
 Q
SOL1 S X=$S($D(^PS(52.7,$P(PSIV,U,2),0)):$P(^(0),U)_" "_$P(^PS(55,DFN,"IV",+ON,"SOL",+PSIV,0),U,2),1:"**********") Q
HYP ;
 I PSIV="*" S X="*** Error in "_$S(I=50.4:"electrolyte",I=52.7:"solution",1:"additive") D PRNTL Q
 S PSIVA=$S(I=50.4:PSIV,I=52.7:+$G(^PS(55,DFN,"IV",+ON,"SOL",PSIV,0)),1:+$G(^PS(55,DFN,"IV",+ON,"AD",PSIV,0)))
 S X=$S($D(^PS(I,PSIVA,0)):$P(^(0),U),1:"Undefined "_$S(I=50.4:"electrolyte",I=52.7:"solution",1:"additive"))_" "_$S(X<1:"0"_(X+.005\.01/100),1:(X+.005\.01/100))_" "_$P($P(HYPL(I,PSIV,$O(HYPL(I,PSIV,""))),U)," ",2)
 D PRNTL
 Q
SETP S Y=^PS(55,DFN,"IV",+ON,0) F X=1:1:23 S P(X)=$P(Y,U,X)
 Q
MESS ;PSJ*5*184 -make MESS a local array so all messages display for all additives.
 I $P(^PS(52.6,+Y,0),U,9)]"" S MESS($P(^PS(52.6,+Y,0),U,9))=""
 Q
UPD N X,Y,PSIVEL,PSIVAD
 S PSIVEL=$P(PSIVP,"^",2)
 I I=50.4 F PSIVAD=0:0 S PSIVAD=$O(HYPLRPT(PSIVEL,"AD",PSIVAD)) Q:'PSIVAD  D
 .I $D(HYPAD(+PSIVAD)) Q
 .S YY=$G(^PS(55,DFN,"IV",+ON,"AD",+PSIVAD,0))
 .S HYPAD(+PSIVAD)=""
 .I +$P(YY,U,3),(+$P(YY,U,3)'=P(16)) Q
 .D UP2^PSIVBCID(DFN,PSJBLN,PSIV,YY)
 I I'=50.4 S YY=$G(^PS(55,DFN,"IV",+ON,"AD",+PSIV,0)) D UP2^PSIVBCID(DFN,PSJBLN,PSIV,YY)
 Q
BARCODE D PSET^%ZISP
 ;IHS/MSC/PB - 04/25/12 - added the next line to compute line length -- see note before line tag OFFSET
 ;I $P($G(^PS(59.5,PSIVSN,9999999)),"^")=1 D OFFSET^PSIVLABL(PSJBCID,"Do Not Use After:")
 ;IHS/MSC/PB - 2/11/13 - line below modified to to a $G of the variable PRTFLG to prevent errors if the PRTFLG is not defined
 ;I PRTFLG=0 S PSJBCID=PRTLINE
 ;I $G(PRTFLG)=0 S PSJBCID=PRTLINE
 I 'PSJIO D
 . I IOBARON]"" W @IOBARON
 . W PSJBCID
 . I IOBAROFF]"" W @IOBAROFF
 . W !
 I PSJIO D
 . F I="SB","SBF" I $G(PSJIO(I))]"" X PSJIO(I)
 . W PSJBCID
 . F I="EBF","EB" I $G(PSJIO(I))]"" X PSJIO(I)
 Q
