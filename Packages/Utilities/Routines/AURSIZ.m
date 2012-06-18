AURSIZ ; IHS/TUC-BRJ List routine names and sizes w/overall total. [ 02/26/86  12:13 PM ]
 W !!,"%AURSIZ - List routine names and sizes",!
 K ^UTILITY($J) D ^%RSEL G EXIT:$N(^UTILITY($J,0))<0
SELD ;
 S $ZT="",IOO=$I,%DEF=$I D ^%IOS G EXIT:'$D(%IOD) I %IOD>46&(%IOD<64) C %IOD K %IOD,%DTY,%P W *7,!!,"Please select only terminal or printer devices!!  Thanks... %AURSIZ!!",! G SELD
 S %IO=%IOD
WAIT ;
 R !,"Do you want to free up this terminal? <N> ",WAIT G:'((WAIT?1"N")!(WAIT?1"Y")!(WAIT="")!(WAIT="?")) WAIT
 S:WAIT="" WAIT="N"
 I WAIT="?" W !!,"It may take some time to accumulate all the routine size values.",!,"This is dependent on how many routines you selected.",!!,"Enter ""Y"" to exit this job.  Otherwise enter ""N"" or <CR> to continue." G WAIT
 I WAIT="Y"&(IOO=%IOD) W !!,"Sorry....Can't free device since output device is this terminal." S WAIT=""
DET ;
 I WAIT="Y" W !!,"Closing this device.  Hit <CR> for logon prompt.  B y e...",!!,"Exit",!! C $I,%IO
 E  W !!,"Please wait..."
 S %JB=$J
A1 ;
 I $D(^UTILITY("CRF",%JB))!$D(^UTILITY("CRF1",%JB)) S %JB=%JB+100 G A1
 K ^UTILITY("CRF",%JB),^UTILITY("CRF1",%JB),(%JB,IOO,%IO,%DTY) S (A,%R)=0
 X "F I=1:1 S A=$N(^UTILITY($J,A)),T=0 Q:A<0  ZL @A S %R=%R+1 F J=1:1 S ^UTILITY(""CRF"",%JB,I,J)=$T(+J),T=T+$L($T(+J)) I $T(+J+1)="""" S ^UTILITY(""CRF1"",%JB,I,0)=A_""^""_T Q"
PRT ;
 O %IO U %IO W:IOO'=%IO # S SIZT=0
 I '$D(UCI)!'$D(SYS) D ^%GUCI S UCI=%UCI,SYS=%SYS
 W !!,?13,"%AURSIZ - LIST ROUTINE SIZES  ",?45 D ^%D W !,?25,"of ",UCI,",",SYS,?45 D ^%T W !!,?24,"ROUTINE",?36,"SIZE",!
 F %I=1:1 Q:'$D(^UTILITY("CRF1",%JB,%I,0))  S Y=^(0),NAM=$P(Y,"^",1),SIZ=$P(Y,"^",2) W !?24,NAM,?34,$J(SIZ,6) S SIZT=SIZT+SIZ
 W !!,?24,"TOTAL",?34,$J(SIZT,6)
 W !!,?24,%I-1,"  ROUTINE" W:%I-1>1 "S"
 K ^UTILITY("CRF",%JB),^UTILITY("CRF1",%JB),%JB,%I,HEAD,I,J,N,NAM,S,SIZ,SIZT,T,TRM,V,W,X,Y,Z
EXIT ;
 S $ZT="" K ^UTILITY("CRF",$J),%DT,%R,A,I,IOM,X,%I9,%L9,%MS,%NX,%PF,%ST,%T8,%TM,%TR,%UCI,%UCN,ERA,FIG,LC,%CH,%CP,%DTY,%FS,%SYS,SYS,UCI,WAIT
 I $D(%IO),%IO,IOO'=%IO W # C %IO
 K IOO,%IO
 Q
