INHUTDT ;MVB,ESS,JSH ; 8 Apr 94 17:01;Function Library, Date and Time functions - non SAIC-CARE version
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
CDATF2H(F,W,Y,M,D,T) ;Convert a Fileman date to $H format
 ;If passed by reference, the following variables are returned:
 ; W = Weekday of date (Saturday=0, Sunday=1, ..., Friday=6)
 ; Y = Year (4 digits)
 ; M = Month (1-12)
 ; D = Day (1-31)
 ; T = 2nd piece of $H result (Time portion)
 S Y=$E(F,1,3)+1700,M=$E(F,4,5),D=$E(F,6,7),T=0
 I $L(F)>8 S F=$P(F,".",2)_"000",T=$E(F,1,2)*60+$E(F,3,4)*60+$E(F,5,6)
 S:Y["BC"&(Y>0) Y=-Y S F=M-14\12,F=4800+Y+F*1461\4-(4900+Y+F\100*3\4)+(M-2-(F*12)*367\12)+D-2331235-94311_","_T,W=F+5#7
 Q F
CDATH2F(X,W,Y,M,D) ;Convert a date in $H format to Fileman format
 ;If passed by reference, the following variables are returned:
 ; W = Weekday of date (Saturday=0, Sunday=1, ..., Friday=6)
 ; Y = Year (4 digits)
 ; M = Month (1-12)
 ; D = Day (1-31)
 N A,B,C,E,F,G,H,I,T S I=94311 S:$G(X)="" X=+$H
 S T=$P(X,",",2)
 S G=X+2367729+I,H=4*G\146097,W=G-(146097*H+3\4),A=W+1*4000\1461001,B=W-(1461*A\4)+1,C=B+30,E=80*C\2447,D=C-(2447*E\80)
 S F=E\11,M=E+2-(12*F),Y=H-49*100+A+F S Y=Y-1700,Y=$S(Y<100:0_Y,1:Y)
 S:M<10 M=0_M S:D<10 D=0_D S W=X+5#7
 I $L(T) S T="."_$E(T\3600+100,2,3)_$E(T\60#60\1+100,2,3)_$E(T#60+100,2,3)
 Q Y_M_D+T
DT() ;Return the current date in Fileman format
 N %DT,X,Y
 S %DT="",X="TODAY" D ^%DT Q Y
 ;
SETDT ;Sets DT = current date in FM format
 S DT=$$DT Q
 ;
DTC(%D1,%D2) ;Compare two dates and return the number of days between them
 S X2=%D2,X1=%D1 D D^%DTC Q X
 ;
NOW(S) ;Return the current date and time in Fileman format
 N % D NOW^%DTC Q %
 ;
DATEFMT(D,FMT,PAD) ;
 ;Format date (optionally with time) D using format string FMT
 ;If D?7N.E assume date in FileMan format, else it is in $H format
 ;In FMT:
 ;  Y = year, M = month (3 or more M means use month names not numbers)
 ;  D = day,  H = hour (24 hour clock),  T = hour (12 hour clock)
 ;  I = minutes,  S = seconds,  P = display AM or PM
 ;  W = day of week
 ;PAD = fill numbers with 0 when less than specified length (0 = NO, 1:default = YES)
 N %,%Y,%M1,%M2,%D,%H,%T,%I,%S,%P,T,Z,Y,X,L,C
 S:$G(PAD)="" PAD=1
 G:D?7N.1".".N F1
 I D?5N!(D?5N1","5N) S D=$$CDATH2F(D) G F1
 S %DT="T",X=D D ^%DT Q:Y<0 ""  S D=Y
F1 S X=D D DOW^%DTC S %W=$P("Sunday^Monday^Tuesday^Wednesday^Thursday^Friday^Saturday",U,Y+1)
 S %Y=1700+$E(D,1,3),%M1=+$E(D,4,5),%M2=$P("January,February,March,April,May,June,July,August,September,October,November,December",",",%M1),%D=+$E(D,6,7)
 S T=$P(D,".",2),%H=+$E(T,1,2),%T=%H#12,%I=+$E(T,3,4),%S=+$E(T,5,6) S:'%T&(T]"") %T=12 S %P=$S(%H>11:"PM",1:"AM") S:T="" %P=""
 Q:$G(FMT)="" ""  S X=""
 F Z=1:0:$L(FMT) S C=$E(FMT,Z) D
 . I "YMDHTISPW"'[C S X=X_C,Z=Z+1 Q
 . F L=1:1 Q:$E(FMT,Z+L)'=C  ;L set to length
 . D @C S Z=Z+L Q
 Q X
Y S X=X_$E(%Y,5-L,4) Q
M I L>2 S X=X_$E(%M2,1,L) Q
 S X=X_$E("0",L=2&($L(%M1)=1)&PAD)_%M1 Q
D S X=X_$E("0",L=2&($L(%D)=1)&PAD)_%D Q
H S X=X_$E("0",L=2&($L(%H)=1)&PAD)_%H Q
T S X=X_$E("0",L=2&($L(%T)=1)&PAD)_%T Q
I S X=X_$E("0",L=2&($L(%I)=1)&PAD)_%I Q
S S X=X_$E("0",L=2&($L(%S)=1)&PAD)_%S Q
P S X=X_%P Q
W S X=X_$E(%W,1,L) Q
