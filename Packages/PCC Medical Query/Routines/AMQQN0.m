AMQQN0 ; IHS/CMI/THL - NATL LANGUAGE PRELIMINARY SETUP ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
PREP F %=" DURING "," IN " I X[% D DUR Q
 I X[" BORN " D BORN
 I X'[" BETWEEN " F  Q:X'[" AND "  S X=$P(X," AND ")_" &"_$P(X," AND ",2,99)
 I X["&" D AND G EXIT
 I X["BETWEEN" S %=$P(X,"BETWEEN",2) I %[" AND " S AMQQNV2=$P(X," AND ",2),X=$P(X,(" AND "_AMQQNV2))
RUN D SPEC
 D STRIP
 D UNITS
 D PRELIM
EXIT K Y
 Q
 ;
SPEC N A,B,C,%,N,I
 I ($E(X,1,6)="WOMEN "!($E(X,1,6)="WOMEN")),X'["CHILD" S X="FEMALES "_$E(X,7,999)
 S %="PTS'^CLIENTS'^CLIENT'S^EVERYONE'S^EVERYBODY'S^PTS^CLIENTS^EVERYONE^EVERYBODY^PEOPLE^FOLKS"
 F I=1:1 S A=$P(%,U,I) Q:A=""  S A=A_" " I X[A S X=$P(X,A)_"PATIENTS "_$P(X,A,2) Q
 F %=" WHO ARE "," WHO IS "," WHO WERE " F  Q:X'[%  S X=$P(X,%)_" "_$P(X,%,2,99)
 S %=" WHO HAVE "
 I X[% S X=$P(X,%)_" WITH "_$P(X,%,2)
 S %="ALL OF "
 I X[% S X=$P(X,%)_"ALL "_$P(X,%,2)
 I X'["AGE" G SP1
 S %=" THE AGE OF "
 I X[% S X=$P(X,%)_" AGE "_$P(X,%,2)
 S %="ABOVE^GREATER THAN^MORE THAN^OVER^BEYOND^>^LESS THAN^BELOW^HIGHER THAN^UNDER^<"
 F I=1:1 S A=$P(%,U,I) Q:A=""  S Y=" "_A_" AGE " I X[Y S X=$P(X,Y)_" AGE "_A_" "_$P(X,Y,2) Q
SP1 S %=" WITH "
 I X[%,$L($P(X,%,2)," ")<3 S X=$P(X,%)_" DX OF "_$P(X,%,2)
 F %="WHAT IS ","WHAT WAS " I X[% S X=$P(X,%)_$P(X,%,2,99)
 S %=" OF "
 I X["PATIENT" F  Q:X'[%  S X=$P(X,%,1)_" = "_$P(X,%,2,99)
 S %="FROM^LIVING IN^LIVE IN^LIVES IN"
 F I=1:1 S A=$P(%,U,I) Q:A=""  S A=" "_A_" " I X[A S X=$P(X,A)_" CURRENT COMMUNITY = "_$P(X,A,2) Q
 S %="WHO ARE TAKING^WHO TAKE^TAKING^ON"
 F I=1:1 S A=$P(%,U,I) Q:A=""  S A=" "_A_" " I X[A S X=$P(X,A)_" RX = "_$P(X,A,2) Q
 I X'["DEAD" Q
 F I=1:1 S A=$P(X," ",I) I A="DEAD" S X="PATIENTS WHO DIED AFTER 1800" Q
 Q
 ;
STRIP S Y(1)=";SEE;GIVE;FIND;PRINT;LIST;GET;SHOW;I;ME;FOR;DISPLAY;TO;WANT;WOULD;LIKE;NEED;REQUEST;ALL;LET;VIEW;SEARCH;WHAT;KNOW;A;AN;TELL;MUCH;DOES;"
 S Y(2)=";THE;THEIR;THAN;REPORT;LIST;LISTING;BRING;WHOSE;WHO;EVERY;PRINT;MAKE;EVERY;EACH;WITH;FIND;NOW;HIS;HER;A;YOU;COULD;PLEASE;"
STP F  Q:X'["."  S %=$E(X,$F(X,".")) S X=$P(X,".")_$S(%=+%:"~~~",1:"")_$P(X,".",2,99)
 F  Q:X'["~~~"  S X=$P(X,"~~~")_"."_$P(X,"~~~",2,99)
 F I=1:1 S Z=$P(X," ",I) Q:Z=""  F J=0:0 S J=$O(Y(J)) Q:'J  D ST1
 Q
 ;
ST1 I I=1,Y(J)[(";"_Z_";") S X=$P(X," ",2,99),I=I-1,J=99 Q
 I Y(J)[(";"_Z_";") S X=$P(X," ",1,I-1)_" "_$P(X," ",I+1,99),I=I-1,J=99
 Q
 ;
UNITS N %,Y,Z
 F %="WEIGH","WT" I X[% F Y="LBS.","lbs.","LBS","lbs","POUNDS","LB.","LB","lb.","lb" I X[Y S Z="WTL" D INSERT G UXIT
 F %="WEIGH","WT" I X[% F Y="KBS.","kgs.","KGS","kgs","KILOGRAMS","KG.","KG","kg.","kg" I X[Y S Z="WTK" D INSERT G UXIT
 F %="HEIGH","HT" I X[% F Y="INS.","ins.","INS","ins","INCHES","IN.","IN","in.","in" I X[Y S Z="HTI" D INSERT G UXIT
 F %="HEIGH","HT" I X[% F Y="CMS.","cms.","CMS","cms","CENTIMETERS","CM.","CM","cm.","cm" I X[Y S Z="HTC" D INSERT G UXIT
UXIT Q
 ;
PRELIM F  Q:X'["  "  S X=$P(X,"  ")_S_$P(X,"  ",2,99)
 I $E(X)=" " S X=$E(X,2,999)
 I $E(X,$L(X))=" " S X=$E(X,1,$L(X)-1)
 Q
 ;
INSERT N A,B
 S A=$P(X,%)
 S B=$P(X,%,2)
 S B=$P(B," ",2,99)
 S X=A_Z_" "_B
 Q
 ;
AND F I=1:1 S %=$P(X,"&",I) Q:%=""  S AMQQNAP(I)=%
 F AMQQNAP=0:0 S AMQQNAP=$O(AMQQNAP(AMQQNAP)) Q:'AMQQNAP  S X=AMQQNAP(AMQQNAP) D RUN S AMQQNAP(AMQQNAP)=X
 S X=AMQQNAP(1)
 Q
 ;
BORN S %=" BORN ON "
 I X[% S X=$P(X,%)_" DOB = "_$P(X,%,2) Q
 S %=" BORN DURING "
 I X[% D IN Q
 S %=" BORN IN "
 I X[% D IN Q
 S %=" BORN "
 I X[% S X=$P(X,%)_" DOB "_$P(X,%,2)
 Q
 ;
IN S A=$P(X,%,2)
 I A'?4N Q
 S X=$P(X,%)_" DOB BETWEEN "_A_" AND "_(A+1)
 Q
 ;
DUR N Y,Z,A,B,C
 S Y=$P(X,%,2)
 S C=%
 I Y?1.2N S Y=$$YEAR^AMQQN0(Y) ;Y2000
 I Y?4N S X=$P(X,%)_" BETWEEN 1/1/"_Y_" AND 12/31/"_Y Q
 D DUR1
 I Y=-1 Q
 I $E(Y,6,7)'="00" Q
 S A=$E(Y,1,3)+1700
 S A=+$E(Y,4,5)_"/1/"_A
 S Z=+$E(Y,4,5)
 S Z=$E("303232332323",Z)+28
 S B=+$E(Y,4,5)_"/"_Z_"/"_($E(Y,1,3)+1700)
 S X=$P(X,%)_" BETWEEN "_A_" AND "_B
 Q
 ;
DUR1 N X,%
 S X=Y
 S %DT=""
 D ^%DT
 Q
 ;
YEAR(X) ;EP - CONVERTS 2 DIGIT YEAR INTO A FOUR DIGIT YEAR
 N Y,%,%DT
 S:$L(X)<2 X="0"_X ;Y2000
 S %DT="P"
 D ^%DT
 Q Y\10000+1700 ;Y2000
 ;
