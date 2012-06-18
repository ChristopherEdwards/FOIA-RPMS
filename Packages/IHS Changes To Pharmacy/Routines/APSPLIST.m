APSPLIST ;BHAM/ISC/JCM - LIST OF NUMBERS READER  [ 02/20/2001  3:38 PM ];21-Mar-2004 20:35;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**3**;09/03/97
 ; Copied from v6.0 PSOLIST - PSOLIST is not delivered with 7.0
 ; Modified - IHS/CIA/PLS - 02/15/04
 ;requires PSOHI, optionally PSOLO
 ;returns Y array
 I $G(APSPID)]"" D ENMDT Q  ;IHS/DSD/ENM 5.1.95 APSPID FM APSPSLBL
ASK S:'$D(PSOLO) PSOLO=1 S Y=""
 W !,$S($G(PSONUM("A"))]"":PSONUM("A"),1:"Select ")_PSOLO_" - "_PSOHI_" > "
 R X:DTIME
 I '$T!(X["^") S PSOQFLG=1 K PSOLIST Q
 I X["." W !,"WHAT'S WITH THE DOTS!!" G ASK ;IHS/OKCAO/POC 06/10/98
 I X="" S:'$D(PSORX("BAR CODE")) PSOQFLG=1 K:'$D(PSORX("BAR CODE")) PSOLIST Q
 S:X="ALL" X=PSOLO_":"_PSOHI
 I X="" S Y="" G EXIT
 I "Pp"[$E(X),$D(PSOSD) D ^PSODSPL G ASK
 I "Rr"[$E(X) D GMRA^PSODEM G ASK
 I X["?" D QUES G ASK
 I X["-" D BARCODE^APSPNUM G ASK
 G:$G(PSORX("BAR CODE"))]"" EXIT
L ; LIST OR RANGE
 S Y(1)="",PSOC=1,PSOERR=0 S:'$D(PSOLO) PSOLO=1
 ;D DUPCHK F PSOI=1:1 S PSOX=$P(X,",",PSOI) Q:PSOERR!'$L($P(X,",",PSOI,999))  S:PSOX'?.".".N.".".":".N.":".N.".".N PSOERR=1 D L0:'PSOERR
 F PSOI=1:1 S PSOX=$P(X,",",PSOI) Q:PSOERR!'$L($P(X,",",PSOI,999))  S:PSOX'?.".".N.".".":".N.":".N.".".N PSOERR=1 D L0:'PSOERR ;IHS/OKCAO/POC DO DUP CHECK LATER
 D DUPCHK ;DO DUPCHK NOW IHS/OKCAO/POC
 I PSOERR W !!?5,"Response should be no less than "_+PSOLO_" and no greater than "_PSOHI G ASK
 S Y=Y(1) K PSO
EXIT K DUP,PSO,PSOA,PSOI,PSOLO,PSOHI,PSOX,PSOC,PSOJ
 Q
L0 S:+PSOX<PSOLO!(PSOX>PSOHI) PSOERR=2 S PSO=$P(PSOX,":",2) I PSO,PSO>PSOHI!(PSO<PSOX) S PSOERR=3
 Q:PSOERR  I PSOX?.N!(PSOX?1N.".".N) S PSOJ=PSOX G L1
 I PSOX#1 S Y(PSOC)=Y(PSOC)_+PSOX_",",$P(PSOX,":")=PSOX\1+1
 F PSOJ=$P(PSOX,":"):1:$P(PSOX,":",2) D L1
 I $P(PSOX,":",2)#1>0 S Y(PSOC)=Y(PSOC)_$P(PSOX,":",2)_","
 Q
L1 I $L(Y(PSOC)_PSOJ)>220 S PSOC=PSOC+1,Y(PSOC)=""
 F PSO=1:1:PSOC I Y(PSO)_","[(","_PSOJ_",") S PSO=-1 Q
 I PSO'<0 S Y=PSOJ S Y(PSOC)=Y(PSOC)_PSOJ_","
 Q
 ;
QUES W !!?5,"Enter a number, or a list of numbers sperated by commas,"
 W !?5,"or a range of numbers seperated by a semicolon."
 W !!?5,"Examples:"
 W !!?5,"1,4,6,7",!?5,"3,5:9,2"
 W !?5,"'ALL'  (to select all)"
 W !?5,"'R' to list allergies/adverse reactions"
 I $D(PSOSD) W !?5,"'P'  (to see profile)",!
 Q
DUPCHK ;ADD NEXT LINE
 N X S X=Y(1) ;ADDED IHS/OKCAO/POC
 S END=$L(X,","),BAD=0
 W ! F I=1:1:END S RXM=$P(X,",",I) I +RXM F J=I+1:1:END S DUP=$P(X,",",J) I DUP=RXM S $P(X,",",J)="" W !?5,*7,"Duplicate # "_RXM_" was found in your list, ignoring it!" S BAD=1
 S DUP=$P(X,",") F I=2:1:END S RXM=$P(X,",",I) S:RXM'?1.N.A BAD=1 I RXM?1.N.A S DUP=DUP_","_RXM
BAD I BAD W !!?15,"=> "_DUP,!,"Is this OKAY " S %=1 D YN^DICN I '% D QUES2^APSPNUM G BAD
 I BAD,%'=1 S DUP="",PSOERR=1
 S:DUP]"" X=DUP K BAD,RNM,DUP,%,END
 Q
ENMDT ;IHS/DSD/ENM 5.1.95 DATE ORDER SETUP
 S %DT("A")="Select Date: ",%DT="AEXP" D ^%DT S APSPBDT=Y-1,APSPEDT=Y ;IHS/DSD/ENM 01/29/96 'P' ADDED TO %DT
 I APSPEDT=-1 W !,"No date selected so I'm quitting!!",! Q
 S Y(1)="",Y=0
 S APSPK="",APSPL="" F APSPK=APSPBDT:0 S APSPK=$O(APSPZDT(APSPK)) Q:'APSPK!(APSPK>APSPEDT)  F  S APSPL=$O(APSPZDT(APSPK,APSPL)) Q:'APSPL  D ESET
 Q
ESET S Y(1)=Y(1)_APSPL_",",Y=Y+1
 Q
