AMQQSQA2 ; IHS/CMI/THL - SUB-SUBQUERIES ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 I $D(AMQQMMMM) D AUTO G EXIT
VAR D P1
 D V1
 S $P(AMQQSQSQ,U,5,6)=AMQQSQSJ_U_AMQQSQP1
 S AMQQCOMP=";;"
 S %=$P($G(^AMQQ(5,AMQQSQN,5)),U,2)
 I %,%=$P($G(^AMQQ(5,AMQQSQSN,5)),U,2) S $P(AMQQSQSQ,U,7)=1,$P(AMQQSQSQ,U,1,2)="+0^+0" G CKTAX
Q1 W !!,"Do you want to screen each ",AMQQSQAN," according to the",!
 D QX
 W " on the ",@AMQQRV,"SAME",@AMQQNV," visit"
 S %=1
 D YN^DICN
 S:$D(DTOUT)+$D(DUOUT) %Y=U
 K DTOUT,DUOUT
 I %Y=U S AMQQQUIT="" G EXIT
 I %Y?1."?" W !!,"If you answer ""YES"" you can screen each ",AMQQSQAN," according to",!,AMQQSQP1," from on the same visit",!! G Q1
 I "Yy"[$E(%Y) S $P(AMQQSQSQ,U,7)=1,$P(AMQQSQSQ,U,1,2)="+0^+0" G CKTAX
Q2 W !!,"Well then, do you want me to screen each ",AMQQSQAN," according to",!
 D QX
 W " on ",@AMQQRV,"TEMPORALLY RELATED",@AMQQNV," visits"
 S %=1
 D YN^DICN
 S:$D(DTOUT)+$D(DUOUT) %Y=U
 K DTOUT,DUOUT
 I %Y=U S AMQQQUIT="" G EXIT
 I %Y?1."?" W !!,"If you answer ""YES"" you can screen ",AMQQSQP1," according to",!,"the value of a temporally related ",AMQQSQAN,!! G Q2
 I "Yy"'[$E(%Y) S Y=-1 W "  ??",*7 S AMQQQUIT="" G EXIT
DATE W !!
 F Z="start","end" D D1 I $D(AMQQQUIT) G EXIT
 I $P(AMQQSQSQ,U)>$P(AMQQSQSQ,U,2) W "  ??",*7,!!,"The start of the time frame must preceed the end of the time frame!!!",!! G DATE
CKTAX S %=$P(^AMQQ(5,AMQQSQN,0),U,5)
 S:%=9 %=AMQQSQN+($J/100000)
 S %=$P(^AMQQ(1,%,0),U,5)
 S %=$P(^AMQQ(4,%,0),U)
 I %="G"!(%="L") D TAX I $D(AMQQQUIT) G EXIT
EXIT K X,%,%Y,Y,Z
 Q
 ;
V1 S %=$P(^AMQQ(5,AMQQSQN,0),U,5)
 S:%=9 %=AMQQSQN+($J/100000)
 S $P(AMQQSQSQ,U,8,9)=%_U_AMQQSQNM
 S %=$P(^AMQQ(1,%,0),U,5)
 S %=$P(^AMQQ(4,%,0),U)
 S $P(AMQQSQSQ,U,10)=%
 Q
 ;
QX W $S(AMQQSQNM["PROVIDER":"the providers of record ",1:(AMQQSQNM_" values obtained"))
 Q
 ;
D1 W !,"Enter the relative ",Z,"ing point of the time frame: "
 R X:DTIME E  S X=U
 I X="" W !!,"Your answer is mandatory" D HELPD G D1
 I $E(X)=U S AMQQQUIT="" G DENDK
 I X?1."?" D HELPD G D1
 I X=0!(X="0D")!(X="+0D")!(X="-0D") S X="+0D" W "  (Same day)"
 F  Q:X'[" "  S X=$P(X," ")_$P(X," ",2,99)
 I $E(X)?1N S X="+"_X
 I "-+"'[$E(X) W "  ??",*7 G D1
 S AMQQDATE(1)=$E(X),X=$E(X,2,99)
 I $E(X)'?1N W "  ??",*7 G D1
 S AMQQDATE(2)=+X
 S (X,AMQQDATE(3))=$P(X,+X,2)
 I $L(X),"DWMY"[$E(X) S %=$E(X),Y=AMQQDATE(2)*$S(%="D":1,%="W":7,%="M":30.44,1:365.25),Y=Y\1 G DEND
 W "  ??",*7
 G D1
DEND S $P(AMQQSQSQ,U,1+(Z="end"))=AMQQDATE(1)_Y
 S Y=$E(AMQQDATE(3))
 S %=$S(AMQQDATE(1)="-":" BEFORE",1:" AFTER")
 S %=AMQQDATE(2)_" "_$S(Y="D":"DAY",Y="W":"WK",Y="M":"MO",1:"YR")_$S(AMQQDATE(2)>1:"S",1:"")_%
 S $P(AMQQSQSQ,U,3+(Z="end"))=%
DENDK K AMQQDATE,Y
 Q
 ;
HELPD W !!,"Answer in the following format: SIGN_NUMBER_TIME UNIT",!
 W "For example: ""-6 MONTHS"" or ""+12 WEEKS""",!
 W "The SIGN is relative to the primary visit with ""-"" designating a time prior to",!,"the visit and ""+"" designating a time after the visit.",!
 W "If you do not enter a SIGN, I will assume it is a '+'",!
 W "The TIME UNIT can be DAYS, WEEKS, MONTHS or YEARS.  Abbreviations are OK.",!
 W "Enter '0' to indicate the same day as the primary visit",!!!
 Q
 ;
P1 N X,Y
 S X=AMQQSQNM
 I AMQQSQNM["(" S X=$P(AMQQSQNM,"(") D PLEURAL S AMQQSQP1=X_"("_$P(AMQQSQNM,"(",2,99) Q
 D PLEURAL
 S AMQQSQP1=X
 Q
 ;
PLEURAL ; ENTRY POINT FROM MULTIPLE ROUTINES
 I X="DIAGNOSIS" S X="DIAGNOSES" Q
 S Y=$P(X,$L(X))
 I Y="S" S X=$E(X,1,$L(X)-1)_"ES" Q
 S X=X_"S"
 Q
 ;
TAX N AMQQATNM,AMQQLINK,AMQQATN,AMQQSBCT,AMQQTNAR,AMQQTDIC,AMQQTLOK,AMQQTTX,AMQQTAX
 S Y=AMQQSQN_U_AMQQSQNM
 S %=^AMQQ(5,+Y,0)
 S AMQQTTX=$G(^(3))
 S AMQQATNM=$P(Y,U,2)
 S AMQQATN=+Y
 S AMQQSBCT=$P(%,U,20)
 S AMQQTNAR=$P(%,U,15)
 S AMQQTDIC=U_$P(%,U,16)
 S AMQQTLOK=U_$P(%,U,18)
 S AMQQLINK=$P(%,U,5)
 D ^AMQQTX
 I '$D(AMQQTAX) S AMQQQUIT=""
 S $P(AMQQSQSQ,U,11)=AMQQTAX_$S($D(^UTILITY("AMQQ TAX",$J,AMQQURGN,"--")):";INVERSE",$D(^("-")):";NULL",1:"")
 Q
 ;
AUTO S AMQQCOMP=";;"
 I $P(AMQQMMMM,";",2)="MTAX" S AMQQCOMP=";;;"_$P(AMQQMMMM,";",3)
 S $P(AMQQSQSQ,U,1,2)=$P(AMQQMMMM,";",4)_U_$P(AMQQMMMM,";",5)
 D V1
 Q
 ;
