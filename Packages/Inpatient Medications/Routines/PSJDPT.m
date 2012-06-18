PSJDPT ;BIR/JLC - CENTRALIZED PATIENT LOOKUP FOR IPM ;29-Apr-2005 11:37;SM
 ;;5.0; INPATIENT MEDICATIONS ;**53,1003**;16 DEC 97
 ; Reference to ^DPT is supported by DBIA 10035
 ; Reference to ^DGSEC4 is supported by DBIA 3027
 ; Reference to ^DIC is supported by DBIA 10006
 ; Reference to ^DICN is supported by DBIA 10009
 ; Reference to ^DPTLK1 is supported by DBIA 3266
 ;
 ; Modified - IHS/CIA/PLS - 12/05/03 - Line EN+1
 ;                        - 03/18/05 - Line EN+7
EN K DIC S DIC("W")="D DPT^PSJDPT",DIC="^DPT("
 ; IHS/CIA/PLS - Next three lines commented out and lookup call
 ;               modified to use IHS special lookup utility.
 ;F Q=1:1:3 I X?@$P("1A4N^4N^9N","^",Q) Q
 ;I  S D=$P("BS5^BS^SSN","^",Q),DIC(0)="EZI" D IX^DIC I Y>0 K DIC D CHK(.Y) Q
 ;S DIC("W")="D DPT^PSJDPT",DIC(0)="QEMIZ" D ^DIC Q:Y'>0  K DIC
 S DIC("W")="D DPT^PSJDPT",DIC(0)="QEMZ" D ^DIC Q:Y'>0  K DIC
 ; IHS/CIA/PLS - 03/18/05 - Removed duplicate security check.
 ;D CHK(.Y)
 Q
CHK(Y,DISP,PAUSE) N RESULT,RES
 S DISP=$G(DISP),PAUSE=$G(PAUSE)
 D PTSEC^DGSEC4(.RESULT,$P(Y,"^"),1)
 I RESULT(1)'=0 D
 . W !! I DISP W ?(80-$L($P(Y,"^",2)))\2,$P(Y,"^",2),!
 . F I=2:1:9 I $D(RESULT(I)) W ?(80-$L(RESULT(I)))\2,RESULT(I),!
 . I RESULT(1)'=0,RESULT(1)'=2,PAUSE H 2
 . Q:RESULT(1)=1
 . I RESULT(1)=-1!(RESULT(1)=3)!(RESULT(1)=4) S Y=-1 Q
 . I RESULT(1)=2 D ENCONT I Y=-1 Q
 . D NOTICE^DGSEC4(.RES,Y,XQY0,$S(RESULT(1)=1:1,1:3)) I RES=0 S Y=-1 Q
 Q
ENCONT W !,"Do you want to continue processing this patient record"
 S %=2 D YN^DICN I %<0!(%=2) S Y=-1
 I '% W !!,"Enter 'YES' to continue processing, or 'NO' to quit processing this record." G ENCONT
 Q
DPT I $$DOB^DPTLK1(Y)["*SENSITIVE" G SENS
 S ND=$S($D(^DPT(Y,0)):^(0),1:""),NB=$P(ND,"^",3),NS=$P(ND,"^",9)
 I NS W ?42,$E(NS,1,3),"-",$E(NS,4,5),"-",$E(NS,6,10)," "
 I NB W ?55,$E(NB,4,5),"/",$E(NB,6,7),"/",$E(NB,2,3)," "
 I $D(^DPT(Y,.1)) W ?67,$P(^(.1),"^")
 Q
SENS W ?42,"*SENSITIVE* ",?55,"*SENSITIVE* ",?67,"*SENSITIVE*" Q
