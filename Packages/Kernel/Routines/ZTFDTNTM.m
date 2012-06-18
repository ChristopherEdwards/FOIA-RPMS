%ZTFDT ; jch,EdM ; 10 Dec 97 12:26;Function Library, Date and Time functions 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;CHCS TLS_4603; GEN 1; 21-MAY-1999
 ;COPYRIGHT 1997 SAIC
 N %,N,R,L,T W !,"Available functions in library ^"_$T(+0)
 S N=0 F %=2:1 S R=$T(+%) Q:R=""  D
 .S L=$P(R," "),T=$E(R,$F(R," "),999)
 .I $L(L),$E(T)=";" W !!,$P(L,"(")_" ("_$P(L,"(",2,99) S N=1
 .I N,$E(T)=";" W !,"    "_T Q
 .S N=0
 Q
ADDT(D,D0,H,M,S) ;Add days, Hours, Minutes, Seconds to Date D
 N T S D=$$CDATF2H(D,0,0,0,0,.T),T=$G(H)*60+$G(M)*60+$G(S)+T
 I T<0 S D=D+(T+1\86400)-1,T=T#86400 ; *21508
 S D=T\86400+D+D0,T=T#86400 Q $$CDATH2F(D_","_T)
ADDM(D,M) ;Add months to Date D
 N I,X,Y
 I 'M Q D
 I M<0 S X=D F I=1:1:-M S X=X-100 S:$E(X,4,5)="00" X=X-8800
 I M>0 S X=D F I=1:1:M S X=X+100 S:$E(X,4,5)="13" X=X+8800
 S I=$P("31 28 31 30 31 30 31 31 30 31 30 31"," ",$E(X,4,5))
 I I=28 S Y=X\10000+1700 S:'(Y#4) I=29 S:'(I#100) I=28 S:'(I#400) I=29
 S:$E(X,6,7)>I X=X-$E(X,6,7)+I Q X
CDATA2F(D,F) ;Convert ASCII date to fileman format
 ;D = date in almost any format (JULY 20, 1969; 20JUL69; 7/20/69; 20-JUL-1969; 20JUL; etc.)
 ;F =      Flags as follows:
 ;  F["T"  Time value may be included
 ;  F["R"  Time value is Required
 ;  F["R"  Imprecise dates allowed
 N %,%0,%1,%2,%3,T S F=$G(F),T=F["T"!(F["R")
 S D=$$UPCASE^%ZTF(D),%=$P(D,"@"),%0=$P(D,"@",2),%2=0 S:%="" %="T"
 I T,%[":"!(%?2.4N)!(%?1.2N.1" "1.2A) S %0=%,%="T" ;Time only was passed
 I %?1.U1P1.N.1U F %1=2:1:$L(%) I $E(%,%1)?1P,"+-"[$E(%,%1) S %2=$E(%,%1+1,99),%=$E(%,1,%1-1),%3=$E(%2,$L(%2)),%2=$E(D,%1)_$S(%3="W":%2*7,%3="M":%2*30,%3="H":"."_+%2,1:+%2) Q
 I %?1.U D  S:$$ABS^%ZTF(%2)'<1 %=%+%2_","_$P(%,",",2) S %=$$CDATH2F(%) S:%2?.1P1"."1.N %=$$ADDT(%,0,$TR(%2,".")) Q:'$L(%0) %
 .I $P("NOW",%)="" S %=$H Q
 .I $P("TODAY",%)="" S %=+$H Q
 .I $P("NOON",%)="" S %=+$H_",43200" Q  ;note that N and NO mean NOW
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
 Q:'T "" S %3=$S(%0["A":1,%0["P":2,1:0) Q:%0?5N&'$E(%0) ""  Q:%0?3N&(%0<100) ""
 S:%0?3N&$E(%0) %0=0_%0 I %0[":" S %1=$P(%0,":",2),%2=$P(%0,":",3),%0=$P(%0,":")
 E  S %3=$S($L(%0)>1:-1,1:0),%1=$E(%0,3,4),%2=$E(%0,5,6),%0=$E(%0,1,2)
 Q:'%0&'%1&'%2 "" Q:%0>24!(%1>59)!(%2>59) "" Q:%0>23&((%1>0)!(%2>0)) "" S:%1<10&(%1'?1"0"1N) %1=0_%1 S:%2<10&(%2'?1"0"1N) %2=0_%2
 S %0=$S(%3=1:%0#12,%3=2&(%0<13):%0+12,%0<6&'%3:%0+12,1:%0)
 S %0=$S(%0<24:%0#24,1:%0) S:%0<10 %0=0_%0 Q +(%_"."_%0_%1_%2)
CDATASC(D,DF,TF) ;Convert internal date value to ASCII
 ;D = date in $H or Fileman format. D?7N.E assumes Fileman format.
 ;DF =     1  dd Mon YYYY  dd padded with a zero (default format)
 ;         2  nn/nn/nn     date and month are zero padded
 ;         3  Month day, year
 ;         4  Day, dd Mon yyyy hh:mm:ss    Arpa RFC822 format
 ;TF =     1  @hhmm        If TF not present, no time in output
 ;         2  @hh:mm:ss
 ;         3   hh:mm:ss    leading space instead of @
 N %,%0,%1,W S DF=$G(DF),TF=$G(TF) S:DF<1!(DF>4) DF=1 S:TF<1!(TF>3) TF=0
 I D'?7N,D'?7N1"."1.6N S D=$$CDATH2F(D,.W) ;$H date to Fileman date
 Q:'D "" S %=$E(D,1,3)+1700,%0=$E(D,4,5),%1=$E(D,6,7) D  S %0=""
 .S:'(%0&%1) DF=9 G CDA2:DF=2,CDA3:DF=3,CDA4:DF=4,CDA9:DF=9
CDA1 .S %1=%1_" "
CDA1A .S %0=%0*3,%=%1_$E("JanFebMarAprMayJunJulAugSepOctNovDec",%0-2,%0)_" "_% Q
CDA2 .S %=%0_"/"_%1_"/"_$E(%,3,4) Q
CDA3 .S %=$P("January,February,March,April,May,June,July,August,September,October,November,December",",",%0)_" "_(+%1)_", "_% Q
CDA4 .S:'$D(W) TF=$$CDATF2H(D,.W) S W=W*3+1,%1=$E("SatSunMonTueWedThuFri",W,W+2)_", "_%1_" ",TF=3 G CDA1A
CDA9 .Q:'%0  S %1="" G CDA1A
 I TF S %1=$E($P(D,".",2)_"000000",1,$S(TF=1:4,1:6)),%0=$S(TF=3:" ",1:"@")_$S(TF=1:%1,1:$E(%1,1,2)_":"_$E(%1,3,4)_":"_$E(%1,5,6))
 Q %_%0
CDATF2H(F,W,Y,M,D,T) ;Convert Fileman date to $H format
 ;If passed by reference, variables returned:
 ; W = Weekday (Sat=0, Sun=1, ... Fri=6), Y = Year (4 digits), M = Month (1-12), D = Day (1-31), T = 2nd piece of $H result (Time portion)
 N %,H S Y=$E(F,1,3)+1700,M=$E(F,4,5),D=$E(F,6,7),T=""
 I $L(F)>8 S F=$P(F,".",2)_"000",T=$E(F,1,2)*60+$E(F,3,4)*60+$E(F,5,6)
 S:'M M=1 S:'D D=1  ;Imprecise dates (no day/month) convert to the 1st
 S H=M>2&'(Y#4)+$P("^31^59^90^120^151^181^212^243^273^304^334","^",M)+D-(M>2&'(Y#100))+(M>2&'(Y#400)),%=Y-1841,H=H+(%*365)+(%\4)-(%>59)
 S %=$E(F+.000000001#1,2,7),%=$E(%,1,2)*3600+($E(%,3,4)*60)+$E(%,5,6),W=H+5#7 Q H_$S(T]"":","_T,1:"")
CDATH2F(H,W,Y,M,D) ;Convert date in $H format to Fileman format
 ;If passed by reference, variables returned:
 ; W = Weekday (Sat=0, Sun=1, ... Fri=6),  Y = Year (4 digits),  M = Month (1-12), D = Day (1-31)
 Q:'H ""  N T S T=$P(H,",",2),M=H>21608+(H>94657)+H-.1,Y=M\365.25+1841,M=M#365.25\1,D=M+306#(Y#4=0+365)#153#61#31+1,M=M-D\29+1,W=H+5#7
 I $L(T) S T="."_$TR($J(T\3600,2)_$J(T#3600\60,2)_$J(T#60,2)," ",0)
 Q Y-1700*10000+(M*100)+D+T
DT() ;Return the current date in Fileman format
 Q $$CDATH2F(+$H)
DTC(D1,D2) ;Compare two dates and return the number of days between them
 Q $S(D1?7N.E:$$CDATF2H(D1),1:D1)-$S(D2?7N.E:$$CDATF2H(D2),1:D2)
NOW() ;Return the current date and time in Fileman format
 Q $$CDATH2F($H)
DATEOUT(DT,F) ;Return date as specified in SSPM
 ; DT is a date (in FileMan or $H format) to be translated to
 ; F  format. If DT is an invalid date then a -1 is returned.
 ;      1    "02 Aug 1987"
 ;      2    "02 Aug 1987@1300"
 ;      3    "02 Aug 87"
 ;      4    "02Aug"
 ;      5    "02Aug@1300"
 ;      6    "02Aug87"
 ;      7    "02Aug87@1300"
 ;      8    "02 August 1987 @ 1300"
 ;      9    "02 August 1987 1300"
 ;     10    "02 Aug 87 @ 1300"
 ;
 N FF,T,TM,X,Y,%DT
 I (DT'?1.N)&(DT'?7N1"."1.6N)&(DT'?1.6N1","1.N)!(DT<1) Q -1
 I DT?1.N1","1.N!($L(DT)<7) S DT=$$CDATH2F(DT) ;Convert DT to FileMan format
 S X=DT\1 D ^%DT I Y=-1 Q -1    ;Checks for invalid date
 S T=$$CDATASC(DT,1,1)
 I '$E(X,4,5)!'$E(X,6,7) S T=$P(T,"@") ;Remove time if month or day is 00
 S TM=$P(T,"@",2) I TM>2399!(TM#100>59) Q -1 ;Checks for invalid time
 ;
 ; Formats the output in T
 S FF=" "_F_" "
 S Y=$S($P(T," ",2)="":T,+T:$E(T,8,11),1:$E(T,5,8)) ;*S21525
 S:" 3 6 7 10 "[FF Y=$E(Y,3,4) S:" 4 5 "[FF Y=""
 S T=$S($P(T," ",2)="":Y,+T:$E(T,1,7)_Y_$E(T,12,$L(T)),1:$E(T,1,4)_Y_$E(T,9,$L(T))) ;*S21525
 S:" 1 3 4 6 "[FF T=$P(T,"@") S:" 4 5 6 7 "[FF T=$TR(T," ")
 S:" 8 10 "[FF&(T["@") T=$P(T,"@")_" @ "_TM
 S:" 9 "[FF&(T["@") T=$P(T,"@")_" "_TM
 I " 8 9 "[FF D
 .S X=1 I $P(T," ")'?3A S X=2 I $P(T," ",2)'?3A Q
 .S $P(T," ",X)=$P("January,February,March,April,May,June,July,August,September,October,November,December",",",$E(DT,4,5))
 Q T
 ;
ERRNL Q ""  ;RETURN NULL STRING ON ERROR
ERR0 Q 0  ;RETURN 0 ON ERROR
