UTDT ;MVB,ESS,JSH ; 15 Jan 92 06:02;Function Library, Date and Time functions 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TLS_4603; GEN 1; 14-APR-1999
 ;COPYRIGHT 1988, 1989, 1990, 1991 SAIC
 ;
ADDT(D,A,H,M,S) ;EP - Add days, Hours, Minutes, Seconds to Date D
 N T S D=$$CDATF2H(D,0,0,0,0,.T),T=$G(H)*60+$G(M)*60+$G(S)+T
 I T<0 S D=D-(-T\86400)-1,T=T#86400
 S D=T\86400+D+A,T=T#86400 Q $$CDATH2F(D_","_T)
 Q
CDATA2F(D,F) ;EP - Convert an ascii date to fileman format
 ;D =      date in almost any format you can imagine
 ;         (JULY 20, 1969; 20JUL69; 7/20/69; 20-JUL-1969; 20JUL; etc.)
 ;F =      Flags as follows:
 ;         T  a Time value may be included
 ;         R  a time value is Required to be included
 ;         I  Imprecise dates are allowed (month year only or year only)
 N %,%0,%1,%2,%3,T S F=$G(F),T=F["T"!(F["R")
 S D=$TR(D,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),%=$P(D,"@"),%0=$P(D,"@",2),%2=0 S:%="" %="T"
 I T,%[":"!(%?2.4N)!(%?1.2N.1" "1.2A) S %0=%,%="T" ;Time only was passed
 I %?1.U1P1.N.1U F %1=2:1:$L(%) I $E(%,%1)?1P,"+-"[$E(%,%1) S %2=$E(%,%1+1,99),%=$E(%,1,%1-1),%3=$E(%2,$L(%2)),%2=$E(D,%1)_$S(%3="W":%2*7,%3="M":%2*30,%3="H":"."_+%2,1:+%2) Q
 I %?1.U D  S:'%2 %=%+%2_","_$P(%,",",2) S %=$$CDATH2F(%) S:%2?.1P1"."1.N %=$$ADDT(%,0,$TR(%2,".")) Q:'$L(%0) %
 .I $P("NOW",%)="" S %=$H Q
 .I $P("TODAY",%)="" S %=+$H Q
 .I $P("NOON",%) S %=+$H_",43200" Q  ;note that N and NO mean NOW
 .I $P("MIDNIGHT",%)="" S %=+$H Q
 E  N %5 S %3=$S($E(%)?1N:"1N",1:"1A"),%5=0,%1=0 D
 .I %?6N S %(1)=$E(%,1,2),%(2)=$E(%,3,4),%(3)=$E(%,5,6)
 .E  F %2=1:1 I $E(%,%2)'?@%3 S %1=%1+1,%(%1)=$E(%,1,%2-1) S:%3="1A" %5=%1 Q:%2>$L(%)  F %2=%2:1 I $E(%,%2)'?1P S %=$E(%,%2,99),%2=0,%3=$S($E(%)?1N:"1N",1:"1A") Q
 .I %5 S:%5=2 %5=%(1),%(1)=%(2),%(2)=%5 S %(1)=$F("JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC",$E(%(1),1,3)),%(1)=$S(%(1)-1#3:0,1:%(1)\3) I '%(1) S %=0 Q
 .I %(1)>12 S %=0 Q
 .I F["I",%1<3,%(%1)>31 S %2=$S(%(%1)?2N:200,1:-1700),%=%(%1)+%2*100+$S(%1=2:%(1),1:0)_"00" Q
 .S:%1=2 %(3)=$H+.9\365.25+1841,%1=%1+1 I %1'=3 S %=0 Q
 .S:%(3)?2N %(3)=$S($H<58074:19,1:20)_%(3) S %1=%(1)*2,%=$S(%(2)>$E(" 31"_(%(3)#4=0+28)_"31303130313130313031",%1,%1+1):0,1:%(3)-1700*100+%(1)*100+%(2)) Q
 Q:%'?7N "" I '$L(%0) Q $S(F'["R":%,1:"")
 Q:'T "" S %3=$S(%0["A":1,%0["P":2,1:0)
 I %0[":" S %1=$P(%0,":",2),%2=$P(%0,":",3),%0=$P(%0,":")
 E  S %3=$S($L(%0)>1:-1,1:0),%1=$E(%0,3,4),%2=$E(%0,5,6),%0=$E(%0,1,2)
 Q:%0>23!(%1>59)!(%2>59) "" S:%1<10 %1=0_%1 S:%2<10 %2=0_%2
 S %0=$S(%3=1:%0#12,%3=2&(%0<13):%0+12,%0<6&'%3:%0+12,1:%0)
 S %0=%0#24 S:%0<10 %0=0_%0 Q +(%_"."_%0_%1_%2)
CDATASC(D,DF,TF) ;EP - Convert an internal date value to ascii
 ;D = date in $H or Fileman format. D?7N.E assumes Fileman format.
 ;DF =     1  dd Mon YYYY  dd padded with a zero (default format)
 ;         2  nn/nn/nn     date and month are zero padded
 ;         3  Month day, year
 ;         4  Day, dd Mon yyyy hh:mm:ss    Arpa RFC822 format
 ;TF =     1  @hhmm        If TF not present, no time in output
 ;         2  @hh:mm:ss
 ;         3   hh:mm:ss    leading space instead of @
 N %,%0,%1,W S DF=$G(DF),TF=$G(TF) S:DF<1!(DF>4) DF=1 S:TF<1!(TF>3) TF=0
 I D'?7N,D'?7N1"."1.6N S D=$$CDATH2F(D,.W) ;Cvt $H date to Fileman date
 S %=$E(D,1,3)+1700,%0=$E(D,4,5),%1=$E(D,6,7) D  S %0=""
 .S:'(%0&%1) DF=9 G CDA2:DF=2,CDA3:DF=3,CDA4:DF=4,CDA9:DF=9 ;@("CDA"_DF)
CDA1 .S %1=%1_" "
CDA1A .S %0=%0*3,%=%1_$E("JanFebMarAprMayJunJulAugSepOctNovDec",%0-2,%0)_" "_% Q
CDA2 .S %=%0_"/"_%1_"/"_$E(%,3,4) Q
CDA3 .S %=$P("January,February,March,April,May,June,July,August,September,October,November,December",",",%0)_" "_(+%1)_", "_% Q
CDA4 .S:'$D(W) TF=$$CDATF2H(D,.W) S W=W*3+1,%1=$E("SatSunMonTueWedThuFri",W,W+2)_", "_%1_" ",TF=3 G CDA1A
CDA9 .Q:'%0  S %1="" G CDA1A
 I TF S %1=$E($P(D,".",2)_"000000",1,$S(TF=1:4,1:6)),%0=$S(TF=3:" ",1:"@")_$S(TF=1:%1,1:$E(%1,1,2)_":"_$E(%1,3,4)_":"_$E(%1,5,6))
 Q %_%0
CDATF2H(F,W,Y,M,D,T) ;EP - Convert a Fileman date to $H format
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
CDATH2F(X,W,Y,M,D) ;EP - Convert a date in $H format to Fileman format
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
DT() ;EP - Return the current date in Fileman format
 ;IHS logic
 D ^XQDATE Q $P(%,".")
 ;CHCS logic
 ;Q $$NOW^%DT\1
 ;
SETDT ;EP - Sets DT = current date in FM format
 ;IHS change
 D ^XQDATE S DT=$P(%,".")
 ;OLD CHCS logic
 ;S DT=$$NOW^%DT\1
 Q
 ;
DTC(%D1,%D2) ;Compare two dates and return the number of days between them
 S X2=%D2,X1=%D1 D D^%DTC Q X
 ;
NOW(S) ;EP - Return the current date and time in Fileman format
 ;IHS LOGIC
 D ^XQDATE Q %
 ;Q $$NOW^%DT($G(S))
 ;
DATEFMT(D,FMT,PAD) ;EP
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
 I D?5N!(D?5N1","1.N) S D=$$CDATH2F(D) G F1
 S %DT="T",X=D D ^%DT Q:Y<0 ""  S D=Y
F1 S X=D D DOW^%DTC S %W=$P("Sunday^Monday^Tuesday^Wednesday^Thursday^Friday^Saturday",U,Y+1)
 S %Y=1700+$E(D,1,3),%M1=+$E(D,4,5),%M2=$P("January,February,March,April,May,June,July,August,September,October,November,December",",",%M1),%D=+$E(D,6,7)
 S T=$P(D,".",2)_"000000",%H=+$E(T,1,2),%T=%H#12,%I=+$E(T,3,4),%S=+$E(T,5,6) S:'%T&($P(D,".",2)]"") %T=12 S %P=$S(%H>11:"PM",1:"AM") S:$P(D,".",2)="" %P=""
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
