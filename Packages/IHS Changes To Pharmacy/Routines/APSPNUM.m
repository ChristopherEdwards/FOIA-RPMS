APSPNUM ;IHS/DSD/JRR/JCM - READS ALL RX# AND LIST OF NUMBERS  [ 03/06/2002  2:16 PM ];02-Sep-2005 11:24;SM
 ;;7.0;OUTPATIENT PHARMACY;**1002,1003**;09/03/97
 ; This utility is used to take user selection for rx's or patient
 ; selection.
 ; The entry point is EN and PSONUM would be defined to "RX" if
 ; actual rx numbers are to be input or to "LIST" if a range of
 ; numbers after the showing of a screen profile are to be
 ; evaluated.
 ;
 ; Input Variables: PSONUM = "RX" for Rx# input
 ;                  PSONUM = "LIST" to show profile and choose range
 ;
 ; Output Variables : PSOLIST(#) contains list of RX internal entry
 ;                    numbers separated by commas, if more than 220
 ;                    characters, the next node of PSOLIST( will be
 ;                    defined
 ;
 ;                  PSORX("BAR CODE")=1 if bar coding was used to
 ;                  input the numbers
 ;
 ;                  PSODFN if the PT entry point is used
 ;_________________________________________________________________
 ; Modified - IHS/CIA/PLS - 01/21/04 - Copy of PSONUM from OP v6.0
 ;                          12/27/04 - Line LIST+2
START ;
 K PSOLIST
 I '$D(PSOINST) S PSOINST="000" I $D(^DD("SITE",1)) S PSOINST=^DD("SITE",1)
 I '$P(PSOPAR,"^",21) D GETRXM
 I $P(PSOPAR,"^",21) D RANGE
 G:$G(PSONUM)']"" END
EN ; EP
 K PSOLIST
 D:PSONUM="RX" GETRXM
 D:PSONUM="LIST" RANGE
 G END
 ;
EN1 ;
 K PSOLIST
 D GETRXM
 I $G(PSOQFLG)'=1,$Q(PSOLIST)']"" G EN1
 G END
PT ; EP
 D PAT
 ;
END D EOJ
 Q
 ;------------------------------------------------------------------
GETRXM ;
 K Y
 W !!,$S($G(PSONUM("A"))]"":PSONUM("A"),1:"Select")_" Rx #(s) => "
 R X:DTIME
 I '$T!(X["^") S PSOQFLG=1 K PSOLIST Q
 I X="" S:'$D(PSORX("BAR CODE")) PSOQFLG=1 K:'$D(PSORX("BAR CODE")) PSOLIST Q
 I X["?" D QUES3 G GETRXM
 I "Pp"[$E(X) S:$D(PSOFROM("PTLKUP")) PSONUM="LIST" G GETRXMX
 I 'X D QUES3 G GETRXM
 I X["-" D BARCODE G GETRXM
 D DUPCHK ;return Y with RXM list
 G:Y="" GETRXM
 F I=1:1:$L(Y,",") S RXM=$P(Y,",",I) S GOOD=$D(^PSRX("B",RXM)) W:'GOOD !!?5,"Couldn't Find RX # ",RXM I GOOD S RXN=$O(^PSRX("B",RXM,0)) D LIST
 I $Q(PSOLIST)']"" G GETRXM
GETRXMX Q
 ;
BARCODE ;
 I X'?3N1"-"1.N W !?7,*7,*7,*7,"Improper Barcode Format" G BARCODEX
 I $P(X,"-")'=PSOINST W !?7,*7,*7,*7,"Not From this Institution" G BARCODEX
 S RXN=$P(X,"-",2),PSORX("BAR CODE")=1
 D LIST
BARCODEX Q
 ;
LIST ;
 I $G(^PSRX(RXN,0))']"" W !,*7,"Rx data is not on file !",! G LISTX
 ; IHS/CIA/PLS - 12/27/04
 ;I $P(^PSRX(RXN,0),"^",15)=13 S RXN1=RXN,PSVD=1 D  I PSVD W !,*7,"Rx # ",RXM," has been deleted." G LISTX
 I $G(^PSRX(RXN,"STA"))=13 S RXN1=RXN,PSVD=1 D  I PSVD W !,*7,"Rx # ",RXM," has been deleted." G LISTX
 .;F  S RXN1=$O(^PSRX("B",RXM,RXN1)) Q:'RXN1  I $P($G(^PSRX(RXN1,0)),"^",15)'=13 S RXN=RXN1,PSVD=0
 .F  S RXN1=$O(^PSRX("B",RXM,RXN1)) Q:'RXN1  I $G(^PSRX(RXN1,"STA"))'=13 S RXN=RXN1,PSVD=0
 I $G(PSOLIST(1))']"" S PSOLIST(1)=RXN_"," G LISTX
 F PSOX1=0:0 S PSOX1=$O(PSOLIST(PSOX1)) Q:'PSOX1  S PSOX2=PSOX1
 I $L(PSOLIST(PSOX2))+$L(RXN)<220 S:RXN_","'[PSOLIST(PSOX2) PSOLIST(PSOX2)=PSOLIST(PSOX2)_RXN_","
 E  S:RXN_","'[PSOLIST(PSOX2+1) PSOLIST(PSOX2+1)=RXN_","
LISTX K PSOX1,PSOX2,RXN,PSVD,RXN1
 Q
 ;
RANGE ;
 I '$D(PSOSD) D ^PSOBUILD
 I $D(PSOSD)'>1 W !,"This patient has no prescriptions to act on. " G RANGEX
 S PSOHI=PSOSD
 I $G(PSOOPT)'=3,$G(PSOOPT)'=4 N:$G(PSOOPT)]"" PSOOPT S PSOOPT=-1
 ;D ^PSODSPL Q:PSOQFLG  ;display profile
 ;I '$G(APSPFLG) D ^PSODSPL Q:PSOQFLG  ;IHS/DSD/ENM 3/29/93 display profile
 I '$G(APSPFLG) D ^PSODSPL Q:$G(PSOQFLG)  ;IHS/DSD/ENM 3/29/93 display profile
 ;  dmh 2/27/2002  commented out one before and added next with $G
 S PSOHI=PSOSD  ;dmh added 3/1/2002  it must get deleted in PSODSPL
 ;    ;dmh I need this for the PRINT PATIENT MEDICATION SHEETS
 ;    ;3/1/2002
 D ^APSPLIST ;select range of #s to refill
 I 'Y Q
 F PS=1:1 Q:'$D(Y(PS))
 S M=1,PSOLIST(1)=""
 ;F I=1:1:PS-1 F J=1:1:$L(Y(I),",") S N=$P(Y(I),",",J) S DRG="" F K=1:1:N S DRG=$O(PSOSD("ACTIVE",DRG)),RXN=+PSOSD("ACTIVE",DRG) S:K=N PSOLIST(M)=PSOLIST(M)_RXN_"," S:$L(PSOLIST(M)_RXN_1)>220 M=M+1,PSOLIST(M)=""
 ;
 ;  IHS/BAO/DMH dmh  3/6/2002   modified if no more in "ACTIVE" list Q
 F I=1:1:PS-1 F J=1:1:$L(Y(I),",") S N=$P(Y(I),",",J) S DRG="" F K=1:1:N S DRG=$O(PSOSD("ACTIVE",DRG)) Q:DRG=""  S RXN=+PSOSD("ACTIVE",DRG) S:K=N PSOLIST(M)=PSOLIST(M)_RXN_"," S:$L(PSOLIST(M)_RXN_1)>220 M=M+1,PSOLIST(M)=""
 ;
 ;   dmh commented out the below 4 lines and added to the one above the
 ;   "ACTIVE" node on it....3/4/2002
 ;
 ;  dmh commented out above and added the next 3....2/27/2002
 ;  the PSOSD array now has 2 subscripts.....
 ;S BZD=""
 ;F  S BZD=$O(PSOSD(BZD)) Q:BZD=""  D
 .;S M=1,PSOLIST(1)=""
 .;F I=1:1:PS-1 F J=1:1:$L(Y(I),",") S N=$P(Y(I),",",J) S DRG="" F K=1:1:N S DRG=$O(PSOSD(BZD,DRG)),RXN=+PSOSD(BZD,DRG) S:K=N PSOLIST(M)=PSOLIST(M)_RXN_"," S:$L(PSOLIST(M)_RXN_1)>220 M=M+1,PSOLIST(M)=""
 ;K X,Y,DIR
RANGEX Q
 ;
DUPCHK ;
 S END=$L(X,","),BAD=0
 F I=1:1:END S RXM=$P(X,",",I) I +RXM F J=I+1:1:END S DUP=$P(X,",",J) I DUP=RXM S $P(X,",",J)="" W !?5,*7,"Duplicate RX # ",RXM,"  was found in your list, ignoring it!",! S BAD=1
 S Y=$P(X,",") F I=2:1:END S RXM=$P(X,",",I) S:RXM'?1.N.A BAD=1 I RXM?1.N.A S Y=Y_","_RXM
BAD I BAD W !?15,"=> ",Y
 I BAD W !,"Is this OKAY " S %=1 D YN^DICN I '% D QUES2 G BAD
 I BAD,%'=1 S Y=""
 K BAD
 Q
 ;
PAT ; EP
 S DIC=2,DIC(0)="QEAM" D ^DIC
 I +Y'>0 G PATX
 S PSODFN=+Y
PATX ;
 K X,Y,DIC,DA
 Q
EOJ ;
 K BAD,X,PSONUM,DUP,RXM,DRG,GOOD,BAD,K,M,N
 Q
 ;
QUES2 ;
 W !!?5,"Enter 'YES' to take action on the list as displayed"
 W !?5,"If you answer 'NO' you must re-enter the list"
 Q
QUES3 ;
 W !!?5,"ENTER RX NUMBER OR A LIST OF RX NUMBERS SEPARATED BY COMMAS,"
 W !?5,"e.g. 3233454A,3433434,3223322C"
 W:$D(PSOFROM("PTLKUP")) !!?5,"Enter a 'P' to get a screen profile"
 Q
 ;
