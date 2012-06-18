AMQQHELP ; IHS/CMI/THL - HELP MESSAGES FORQUERY UTILITY ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
RUN ; - EP -
 N Y,Z,I,%,A,B,C,AMQQLNO
 S AMQQLNO=0
EN1 ; - EP - FROM ^AMQQHEL2 AND ^AMQQSQA0
 N S,J,Y,Z,I,%,A,B,C,AMQQLNO
 S S=X
 S AMQQLNO=0
 I S["~" D MULT W !! Q
 D L0
 W !!
 Q
 ;
L0 S A=$P(X,U)
 S C=$P(X,U,2)
 F I=1:1 S B=$P(C,";",I) Q:B=""  S Y="" F  S Y=$O(^AMQQ(5,A,B,Y)) Q:Y=""  D L1 I Y=999999999 G LISTX
LISTX Q
 ;
L1 I X="AF^51",'$$WHP(Y) Q
 S AMQQLNO=AMQQLNO+1
 I AMQQLNO=1 W !!,"Possible choices:" D TYPE
 I $D(AMQQMSPF) K AMQQMSPF S AMQQLNO=4 W !?3,"ALL",!?3,"ANY",!?3,"EXISTS",!?3,"NULL" G L1
 I AMQQLNO#(IOSL-4)=1,AMQQLNO>1 D L2 I Y=999999999 Q
 W !,?3,Y
 Q
 ;
L2 W !!,"Enter '^' to stop listing or any other key to see more <>"
 R Z:DTIME E  S Y=999999999 Q
 I Z=U S Y=999999999 Q
 W @IOF
 Q
 ;
LISTG ; ENTRY POINT FROM AMQQ1
 N Y,Z,I,%,AMQQLNO
 S Y=""
 S AMQQLNO=0
 F  S Y=$O(^AMQQ(5,"GOAL",Y)) Q:Y=""  D L1
 W !!
 Q
 ;
MULT F J=1:1 S X=$P(S,"~",J) Q:X=""  D L0
 W !!
 Q
 ;
ITEM ; - EP - FROM ^AMQQATA AND ^AMQQSQA0
 W @IOF,?20,"*****  ATTRIBUTE CATEGORIES  *****"
ATTS S DIR(0)="SO^1:DEMOGRAPHICS;2:DENTAL CODES;3:DIAGNOSES;4:EXAMS;5:INPATIENT;6:IMMUNIZATIONS;7:LAB;8:MEASUREMENTS;9:MEDICATIONS;10:PATIENT ED;11:PROCEDURES;13:SKIN TESTS;14:TREATMENTS;15:VISIT INFO;16:WOMEN'S HEALTH"
 S DIR("A")="Your choice"
 D ^DIR
 K DIR
 I X=U S AMQQQUIT=""
 I "^"[X K DIRUT,DTOUT,DUOUT Q
 I Y=1 S X="AF^11" D RUN Q
 I Y=2 W !,"Type ""ADA CODE"" and the enter the code number or procedure name",! Q
 I Y=3 W !,"Type ""DX""<RETURN> and then enter the ICD code or diagnosis",! Q
 I Y=14 W !,"Type ""TREATMENT""<RETURN> and then enter the name of the treatment",! Q
 I Y=9 W !,"Type ""RX""<RETURN> and then enter the name of the prescription",! Q
 I Y=11 W !,"Type ""PROCEDURE""<RETURN> and then enter the procedure code or name",! Q
 I Y=12 S X="AF^16" D RUN Q
 I Y=7 S X="AF^3" D RUN Q
 I Y=6 S X="AF^1" D RUN Q
 I Y=8 S X="AF^5" D RUN Q
 I Y=13 S X="AF^18" D RUN Q
 I Y=4 S X="AF^22" D RUN Q
 I Y=15 S X="AF^17" D RUN Q
 I Y=16 S X="AF^48" D RUN Q
 W !,"Sorry, these attributes are not currently available",!
 Q
 ;
TYPE I $G(AMQQSQST)="Q" S AMQQLNO=4 W !!,?3,"POSITIVE",!?3,"NEGATIVE",! Q
 I $G(AMQQSQST)="S" W ! S AMQQLNO=2 N %,I,X D  W ! Q
 .S %=$P($G(^AMQQ(5,AMQQSQSN,0)),U,5) I % S %=$P($G(^AMQQ(1,%,0)),U,6) I % S %="^DD("_%_",0)" I $D(@%) S %=$P(^(0),U,3) F I=1:1 S X=$P(%,";",I) Q:X=""  W !?3,$P(X,":",2) S AMQQLNO=AMQQLNO+1
 Q
 ;
WHP(Y) ; SCREEN WH PROCEDURE ATTRIBUTES
 I '$D(^BWAA("AC")) Q 1
 N %,Z,T
 ; DON'T SCREEN IF THERE IS MORE THAN ONE PROCEDURE SELECTED
 S T=$O(^UTILITY("AMQQ TAX",$J,+$G(AMQQTAX),0)) I $O(^(T)) Q 1
 S %=$O(^AMQQ(5,"B",Y,0))
 I '% Q 1
 S Z=+$P($G(^AMQQ(1,%,0)),U,4)
 I Z="" Q 1
 I $D(^BWAA("AC",Z,T)) Q 1
 Q 0
 ;
