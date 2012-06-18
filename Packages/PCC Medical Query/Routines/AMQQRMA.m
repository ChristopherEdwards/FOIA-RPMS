AMQQRMA ; IHS/CMI/THL - RMAN AGE CATEGORY REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
RUN D CURR
 I $D(AMQQQUIT) G EXIT
 S AMQV("OPTION")="AGE"
EXIT K %Y,A,B,C,I,X,Y,Z,N
 Q
 ;
CURR W @IOF
 I $D(^AMQQ(8,DUZ(2),3)) S AMQQRMB=^(3) W !!,"CURRENT SET UP"
 W !
 D LIST
ASK W !,"Do you want to define a new set of age groups"
 S %=2
 D YN^DICN
 I $E(%Y)=U S AMQQQUIT="" G CEXIT
 I %=0 W !,"Answering yes will allow you to define a new set of age groups.",! G ASK
 I "Nn"'[%Y D NEWAGE
AGIN W !,"Do you want to have ages calculated as of a date other than today's date"
 S %=2
 D YN^DICN
 I %=0 W !,"QMAN will detemine the ages of patients based on the date you enter subsequent",!,"to answering yes to this question.",! G AGIN
 I $E(%Y)=U S AMQQQUIT="",AMQQRERF="" G CEXIT
 I "Nn"'[%Y D NEWDATE I 1
 E  S AMQQDTE=DT
 I '$G(^AMQQ(8,DUZ(2),3))="" Q
CEXIT K DUOUT,DTOUT
 Q
 ;
NEWDATE ; Get new date
 S %DT="AEX"
 S %DT("A")="Enter date relative to which age will be calculated: "
 D ^%DT
 Q:U[X
 S AMQQDTE=Y
 I Y<0,X]"" G NEWDATE
 Q
 ;
NEWAGE S %=""
 S A=-1
 W !,"If you exceed 8 groups, the display will wrap...",!!
 F N=1:1 D AGE Q:X=""  I $D(AMQQQUIT) G EXIT
 D CLOSE
 I $D(AMQQQUIT) G NEXIT
 D LIST
NEXIT K X,Y,Z,%,I,L,A
 Q
 ;
AGE W !,"Enter the starting age of the ",$S(%="":"first",1:"next")," age group: "
 R X:DTIME I '$T S X=U
 I X=U S AMQQQUIT="" Q
 I X="" Q
 I X?1."?" D HELP G AGE
 I X?1.3N,X>A D SET Q
 W "  ??",*7
 G AGE
 ;
SET S A=X
 I %="" S %=X Q
 S %=%_":"_(X-1)_";"_X
 Q
 ;
CLOSE I %="" Q
GC W !,"Enter the highest age for the last group: "
 R X:DTIME I '$T S X=U
 I X=U S AMQQQUIT="" Q
 I X?1."?" D HELP G GC
 I X="" S X=199
 I X>199 S X=199
 I X?1.3N,X'<A S %=%_":"_X,^AMQQ(8,DUZ(2),3)=%,AMQQRMB=% Q
 W "  ??",*7
 G GC
 ;
HELP W !,"Enter an age between 0 and 199.  Ages must be entered in ascending order.",!
 Q
 ;
LIST I $G(^AMQQ(8,DUZ(2),3))="" W !!,"At the present time, no set of age groups is on file",!! Q
 W !,"AGE GROUPS =>",!
 S %=^AMQQ(8,DUZ(2),3)
 F I=1:1 S X=$P(%,";",I) Q:X=""  W !,$P(X,":"),$S($P(X,":",2)=199:"+",1:" - ") I $P(X,":",2)'=199 W $P(X,":",2)
 W !!
 Q
 ;
BUCKET ; ENTRY POINT FROM AMQQCMPL
 D VAR
 I $D(AMQQQUIT) Q
 D DEV
 I $D(AMQQQUIT) Q
 I '$D(AMQQRMA)!('$D(AMQQRMB)) S AMQQQUIT="" Q
 S AMQQRMFL="^AMQQRMA1"
 I $D(IO("Q")) D AGETASK Q
 U IO D AGERUN D ^%ZISC
 Q
 ;
VAR K ^UTILITY("AMQQ",$J,"AGE")
 F X=0:0 S X=$O(^UTILITY("AMQQ",$J,"VAR NAME",X)) Q:'X  S Y=+^(X) D V1
 I '$D(^UTILITY("AMQQ",$J,"AGE")) S %="" G VARQ
 S (%,Z)="" F I=1:1 S Z=$O(^UTILITY("AMQQ",$J,"AGE",1,Z)) Q:Z=""  S C=^(Z) D V2
VARQ ;
 D CLIN
 W !!,"Subtotaling Options:"
 W !!,"You now have the option of choosing an attribute such as Sex, Community,"
 W !,"or Tribe that will allow subtotaling (i.e. cross-tabulation) of your"
 W !,"Age Distribution Report.  You may only select one attribute to subtotal by,"
 W !,"and that attribute must have been included in your search logic in order to"
 W !,"be one of your choices below.  If you have not used any demographic attributes"
 W !,"in your search, you will have no subtotaling option and will see only the"
 W !,"choices 'None, Help, and Exit.'  When you have only those choices, choose None"
 W !,"and you will get your Age Distribution Report with no subtotaling.",!
 K AMQQBUCV,AMQQBUCC,AMQQTMPM,AMQQCNTP
 S DIR(0)="SO^"_$S(%="":%,1:(%_";"))_"8:NONE;9:HELP;0:EXIT"
 S DIR("B")="NONE"
 S DIR("A")=$C(10)_"     Your choice"
 S DIR("?")="Select an option or type '??' for instructions"
 S DIR("??")="AMQQAGE"
 D ^DIR
 K DIR
 I $G(DUOUT)+$G(DTOUT)+'Y K DTOUT,DIRUT,DUOUT S AMQQQUIT="",AMQQOPT("SPEC")="" K AMQQPCE Q
 I Y<8,$D(AMQQPCE(Y)) S Y=AMQQPCE(Y)
 I Y<8 S AMQQRMA=^UTILITY("AMQQ",$J,"AGE",2,Y)
 I Y=8 S AMQQRMA=""
 I Y=9 S XQH="AMQQAGE" D EN^XQH G VAR
 K A,B,C,X,Y,Z,%,^UTILITY("AMQQ",$J,"AGE")
 Q
 ;
CLIN ;
 NEW AMQQI,AMQQNCHK,AMQQDFN
 F AMQQI=1:1 Q:'$D(^UTILITY("AMQQ",$J,"Q",AMQQI))  S AMQQDFN=$O(^AMQQ(5,"B",$P(^(AMQQI),U,2),"")) I AMQQDFN,^UTILITY("AMQQ",$J,"Q",AMQQI)'["EXISTS",$P(^AMQQ(5,AMQQDFN,0),U,19)="C" S AMQQNCHK="" Q
 Q:$D(AMQQNCHK)
 S AMQQBUCC=0
 F AMQQPCE=1:1 Q:$P(%,";",AMQQPCE)=""  S AMQQBUCV=$P($P(%,";",AMQQPCE),":",2) I AMQQBUCV]"" S AMQQBUCV=$O(^AMQQ(5,"B",AMQQBUCV,"")) I AMQQBUCV D
 .I $P(^AMQQ(5,AMQQBUCV,0),U,19)="C" D
 ..S AMQQBUCC="C"
 ..S $P(%,";",AMQQPCE)=""
 I AMQQBUCC="C",AMQQPCE>2 D
 .S AMQQTMP=""
 .S AMQQCNTP=0
 .F AMQQPCE=1:1:10 I $P(%,";",AMQQPCE)]"" S AMQQCNTP=AMQQCNTP+1,AMQQPCE(AMQQCNTP)=AMQQPCE S AMQQTMP=AMQQTMP_AMQQCNTP_":"_$P($P(%,";",AMQQPCE),":",2)_";"
 .S %=AMQQTMP
 .I $E(%,$L(AMQQTMP))=";" S %=$E(%,1,($L(%)-1))
 Q
 ;
V1 F %=0:0 S %=$O(^UTILITY("AMQQ",$J,"Q",%)) Q:'%  I +^(%)=Y S Y=^(%) Q
 I '% Q
 S A=$P(Y,U,2)
 S B=$P(Y,U,3)
 S C=+Y
 S C=$G(^AMQQ(1,C,4,1,1))
 I A=""!(B="") Q
 I "SLG"'[B Q
 Q:$D(^UTILITY("AMQQ",$J,"AGE",1,A))  S ^(A)=X_";"_C_";"_A
 Q
 ;
V2 I %'="" S %=%_";"
 S %=%_I_":"_Z
 S ^UTILITY("AMQQ",$J,"AGE",2,I)=C
 Q
 ;
DEV W !
 S %ZIS="Q"
 S %ZIS("B")=""
 D ^%ZIS
 S AMQQIOP=IO
 I POP K POP S AMQQQUIT="" Q
 D PRINT^AMQQSEC E  W "  <= Not a secure device!!",*7 G DEV
 I $D(IO("Q")),IO=IO(0) W !!,"You can not queue a job to a slave printer..Try again",!!,*7 G DEV
 Q
 ;
AGETASK S ZTRTN="AGERUN^AMQQRMA"
 S ZTIO=ION
 S ZTDTH="NOW"
 S ZTDESC="QUERY UTILITY AGE DISTRIBUTION UTILITY"
 F I=1:1 S %=$P("AMQQRM*;AMQV(;AMQQ200(;AMQQRV;AMQQNV;AMQQDTE;AMQQXV;^UTILITY(""AMQQ"",$J,;^UTILITY(""AMQQ RAND"",$J,;^UTILITY(""AMQQ TAX"",$J,",";",I) Q:%=""  S ZTSAVE(%)=""
 D ^%ZTLOAD
 D ^%ZISC
 W !!,$S($D(ZTSK):"Request queued!",1:"Request cancelled!"),!!!
 H 3
 W @IOF
 Q
 ;
AGERUN I IOST'["P" W @IOF
 X AMQV(0)
 D PRINT^AMQQRMA1
 I IOST["P-" W @IOF
 I $D(ZTQUEUED) D EXIT2^AMQQKILL S ZTREQ="@"
 Q
 ;
