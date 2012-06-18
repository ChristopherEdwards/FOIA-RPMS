LRX ;SLC/BA- UTILITY ROUTINES -- PREVIOUSLY ^LAB("X","...") ; 3/28/89  19:43 ; [ 09/08/90  7:16 PM ]
 ;;V~5.0~;LAB;;02/27/90 17:09
PT ;patient info
 S U="^" I $D(LRDPF),LRDPF'<1 S X=^DIC(+LRDPF,0,"GL")_DFN_",0)",X=$S($D(@X):@X,1:""),LRWRD=$S($D(^(.1)):$P(^(.1),U),1:"")
 I '$D(LRDPF) S X=$S($D(^DPT(DFN,0))#2:^(0),$D(^LAB(62.3,DFN,0)):^(0),1:""),LRDPF=2
 S PNM=$P(X,U),SEX=$P(X,U,2),SEX=$S(SEX="":"M",1:SEX),DOB=$P(X,U,3),AGE=$S($D(DT)&(DOB?7N):DT-DOB\10000,1:"??"),X=$P(X,U,9),SSN=$S(+LRDPF=2:$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,9),1:X)
 S HRCN=$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^(0),U,2),1:"?")  ;IHS/ANMC/CLS 11/02/89
 I AGE<2 S XN=X,DIC=9000001,DR=1102.98,DA=DFN D ^AUDICLK S AGE=$S($D(LKPRINT):LKPRINT,1:"??"),X=XN K DA,DIC,DR,G,LKPRINT,XN,Y  ;IHS/ANMC/CLS 05/01/90 PRINTABLE AGE
 Q
DD ;date/time format
 S Y=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)_$S(Y#1:" "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12),1:"")
 Q
DT ;current date format is LRDT0
 S %H=+$H D YMD^%DTC S DT=X
 S Y=$P(DT,".",1) D DD S LRDT0=Y
 Q
DASH ;line of dashes
 W !,$E("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",1,IOM-1)
 Q
EQUALS ;line of equals
 W !,$E("====================================================================================================================================================================================================================",1,IOM-1)
 Q
DUZ ;user info
 S (LRUSNM,LRUSI)="" Q:'$D(X)  Q:'$D(^DIC(3,+X,0))  S LRUSNM=$P(^(0),"^",1),LRUSI=$P(^(0),"^",2)
 Q
DOC ;provider info
 S LRDOC=$S($D(^DIC(16,+X,0)):$P(^(0),U),1:"") S:LRDOC="" LRDOC=$S($D(^DIC(6,+X,0)):$P(^(0),U),1:"Unknown")
 Q
YMD ;year/month/date
 S %=%H>21549+%H-.1,%Y=%\365.25+141,%=%#365.25\1,%D=%+306#(%Y#4=0+365)#153#61#31+1,%M=%-%D\29+1,X=%Y_"00"+%M_"00"+%D K %Y,%D,%M,%
 Q
STAMP ;time stamp
 S X="N",%DT="ET" D ^%DT
 Q
KEYCOM ;key to result flags
 D EQUALS W !!,"  ------------------------------  COMMENTS  ------------------------------",!,"  Key:  'L' = reference Low,  'H' = reference Hi, '*' = critical range"
 Q
URG ;urgencys
 K LRURG S LRURG(0)="ROUTINE" F I=0:0 S I=$N(^LAB(62.05,I)) Q:I<1  S LRURG(I)=$P(^(I,0),U)
 Q
ADD ;date format
 S Y=$E("JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC",$E(Y,4,5)*3-2,$E(Y,4,5)*3)_" "_$S(Y#100:$J(Y#100\1,2)_", ",1:"")_(Y\10000+1700)_$S(Y#1:"  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12),1:"")
 Q
INF ;Display Infectious Warning
 I $D(^LR(LRDFN,.091)),$L(^(.091)) W !,*7," Pat Info: ",^(.091) Q
 Q
