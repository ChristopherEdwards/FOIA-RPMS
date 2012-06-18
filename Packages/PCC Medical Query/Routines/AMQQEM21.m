AMQQEM21 ; IHS/CMI/THL - PARSES DATE FORMAT AND GENERATES OUTPUT CODE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 I '$D(AMQQEM("DATE TRANS")),$D(AMQQEM("DATE FORMAT")) S AMQQEM("DATE TRANS")=AMQQEM("DATE FORMAT")
 I $D(AMQQEM("DATE TRANS")) Q
NEW N %,I,J,X,Y,Z,P,A,C,T
VAR S J=0,X=""
 S T="~"
 K AMQQEMNO
RUN D ASK
 I $D(AMQQQUIT)!($D(AMQQEMNO)) G EXIT
 D PARSE
 I $D(AMQQEMNO) D EXIT G VAR
 D CONFIRM
 I $D(AMQQQUIT) G EXIT
 I $D(AMQQEMNO) D EXIT G VAR
 S AMQQEM("DATE TRANS")=C
EXIT K %,I,J,X,Y,Z,P,A,C,T
 Q
 ;
PARSE F I=1:1 S Z=$E(%,I) Q:Z=""  D
 .S Y=$S(Z?1A:"A",Z?1N:"N",1:"P")
 .I Y'=X S J=J+1,P(J)=Z,X=Y Q
 .S P(J)=P(J)_Z
 .Q
EVAL S A=""
 S Z="JUNE^JUN^06^6^03^3^1992^92"
 F J=1:1 Q:'$D(P(J))  S X=P(J) D  I $D(AMQQEMNO) D ERROR Q
 .I X?1.P S A=A_X_T Q
 .I 0
 .F I=1:1 S Y=$P(Z,U,I) Q:Y=""  I Y=X S A=A_I_T Q
 .E  S AMQQEMNO=""
CODE S C=""
 F I=1:1 S X=$P(A,T,I) Q:X=""  D  S C=C_X
 .I C'="" S C=C_"_"
 .I X'=+X S X=""""_X_"""" Q
 .I X=1 S X="$P(""JANUARY^FEBRUARY^MARCH^APRIL^MAY^JUNE^JULY^AUGUST^SEPTEMBER^OCTOBER^NOVEMBER^DECEMBER"",U,+$E(X,4,5))" Q
 .I X=2 S X="$P(""JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC"",U,+$E(X,4,5))" Q
 .I X=3 S X="$E(X,4,5)" Q
 .I X=4 S X="(+$E(X,4,5))" Q
 .I X=5 S X="$E(X,6,7)" Q
 .I X=6 S X="(+$E(X,6,7))" Q
 .I X=7 S X="(1700+$E(X,1,3))" Q
 .I X=8 S X="$E((1700+$E(X,1,3)),3,4)"
 S C="S X="_C
 Q
 ;
ERROR W !!,"Sorry, I can't interpret the date you just entered...Try again!",!,"(Remember, JUNE 3, 1992 must be used as the sample.  No other date will work.)",!!
 Q
 ;
ASK ; GET DATE FORMAT
 W !,"I need to know what date format to use.  You can let me know by entering",!,"the date JUNE 3, 1992 as your example (e.g., 6/3/92 or 3JUN92 or 6.3.92 etc.)",!
 S DIR(0)="F^:"
 S DIR("B")="6/3/92"
 S DIR("A")="Enter JUNE 3, 1992 in the desired format"
 S DIR("?")="Enter the date in the proper format for your application; e.g., 6.3.92 or 3JUN92 or JUNE 3, 1992 etc"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I Y=U S AMQQEMNO="" Q
 I Y?2."^" S AMQQQUIT="" K DTOUT,DUOUT,DIROUT,DIRUT G EXIT
 S %=Y
 Q
 ;
CONFIRM ;
 W !!!,"Let me confirm the format with some examples =>",!
 W !,"APRIL 2, 1958 would be listed as "
 S X=2580402
 X C
 W X
 W !,"OCTOBER 23, 1985 would be listed as "
 S X=2851023
 X C
 W X,!
 S DIR(0)="Y"
 S DIR("A")="Is this OK"
 S DIR("B")="YES"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U S AMQQEMNO=""
 I X="^^" S AMQQQUIT=""
 I 'Y S AMQQEMNO=""
 K DIRUT,DIROUT,DUOUT,DTOUT
 Q
 ;
PATIENT ; ENTRY POINT FROM AMQQEM2
 N Y
 W !!,"Show me, by example, how you want to format each patient's name =>"
 S DIR(0)="S^1:DOE,JOHN QUINCY;2:JOHN QUINCY DOE;3:J. DOE;4:DOE | JOHN QUINCY (2 different fields, LASTNAME and FIRST/MIDDLENAME);5:DOE | JOHN (2 fields, LASTNAME and FIRSTNAME);6:DOE (LASTNAME only)"
 S DIR("A")="Enter the number of your choice"
 S DIR("?")="Choice #4 will create a new field to hold the FIRST/MIDDLENAME)"
 S DIR("B")="1"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U S AMQQEMNO=""
 I X?2."^" S AMQQQUIT=""
 I $D(DIRUT) K DIRUT,DUOUT,DTOUT,DIROUT Q
 I Y=4!(Y=5) D TWO Q
 S @G@(AMQQEMN,2)=$P(";S X=$P(X,"","",2)_"" ""_$P(X,"","");S X=$E($P(X,"","",2)_"".""_$P(X,"",""),1,"_AMQQEM("HLEN")_");;;S X=$P(X,"","")",";",Y)
 I AMQQCCLS="V",Y=1 S @G@(AMQQEMN,2)="S X=$P(^DPT(X,0),U)"
 I Y=1,$G(AMQQEM("DEL"))="," D SUB I $D(AMQQQUIT) Q
 S AMQQEMFS=AMQQEMFS_$S(AMQQCCLS="V":3,1:1)_U
 Q
 ;
TWO S @G@(1,2)="S X=$P(X,"","")",^(0)="^^LAST NAME^F^^"_$E("LAST NAME",1,AMQQEM("HLEN"))_U_($G(AMQQEM("FIX"))+$G(AMQQEM("MLEN")))
 I Y=4 S C=C+1,@G@(C,2)="S X=$P(X,"","",2)",^(1)="S X=$P(^DPT(AMQP(0),0),U)",^(0)="^^FIRST/MIDDLE NAME^F^^"_$E("FIRST/MIDDLE NAME",1,AMQQEM("HLEN"))_U_($G(AMQQEM("FIX"))+$G(AMQQEM("MLEN"))),AMQQEMFS=AMQQEMFS_1_U_C_U Q
 S C=C+1
 S @G@(C,2)="S X=$P(X,"","",2),X=$E(X,"" "")",^(1)="S X=$P(^DPT(AMQP(0),0),U)",^(0)="^^FIRST NAME^F^^"_$E("FIRST NAME",1,AMQQEM("HLEN"))_U_($G(AMQQEM("FIX"))+$G(AMQQEM("MLEN"))),AMQQEMFS=AMQQEMFS_1_U_C_U
 Q
 ;
SUB W !!,"PATIENT NAME field contains a comma. The comma is also your field delimiter!"
 W !,"You should either put the name in quotes or substitute another character",!
 W "to prevent problems.",!!
 W !,"For example, if you substitute an underscore (_) for the comma, the entry"
 W !,"""DOE,JOHN QUINCY"" will be saved as ""DOE_JOHN QUINCY"".",!!
 W "DO NOT use the 'up arrow' (^) as the substitute character!!!",!!
 R !,"Press the <RETURN KEY> to go on...",%:DTIME
 Q
 ;
