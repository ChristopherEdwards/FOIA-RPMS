LRX ;VA/SLC/BA - /DALISC/FHS - UTILITY ROUTINES -- PREVIOUSLY ^LAB("X","...") ;JUN 21, 2011 7:34 AM
 ;;5.2;LAB SERVICE;**1030**;NOV 01, 1997
 ;;5.2;LAB SERVICE;**65,153,201,217**;Sep 27, 1994
PT ;patient info
 ;
 N X,I,N,Y
 ;D KVAR^VADPT
 ;K LRTREA,LRWRD S (AGE,PNM,SEX,DOB,SSN,VA200,LRWRD,LRRB,LRTREA,VA("PID"),VA("BID"))=""
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1030
 D @$S($$ISPIMS^BLRUTIL:"KVAR^VADPT",1:"KVAR^BLRDPT")
 K LRTREA,LRWRD S (AGE,PNM,SEX,DOB,SSN,HRCN,VA200,LRWRD,LRRB,LRTREA,VA("PID"),VA("BID"))=""
 ; ----- END IHS/OIT/MKK - LR*5.2*1030
 I $G(LRDFN),'$G(LRDPF),$G(^LR(LRDFN,0)) S LRDPF=$P(^(0),U,2),DFN=$P(^(0),U,3)
 S LREND=0 S:$G(DFN)<1!('$G(LRDPF)) LREND=1 Q:$G(LREND)
 I +$G(LRDPF)'=2 D
 . S X=^DIC(+LRDPF,0,"GL")_DFN_",0)",X=$S($D(@X):@X,1:""),LRWRD=$S($D(^(.1)):$P(^(.1),U),1:0),LRRB=$S($D(^(.101)):$P(^(.101),U),1:"")
 . S PNM=$P(X,U),SSN=$P(X,U,9) Q:+$G(LRDPF)=62.3
 . S SEX=$P(X,U,2),SEX=$S(SEX="":"M",1:SEX),DOB=$P(X,U,3),AGE=$S($D(DT)&(DOB?7N):DT-DOB\10000,1:"??")
 I +$G(LRDPF)=2 N I,X,N,Y D
 . ; D OERR^VADPT D:'VAERR
 . D @$S($$ISPIMS^BLRUTIL:"OERR^VADPT",1:"OERR^BLRDPT") D:'VAERR     ; IHS/OIT/MKK LR*5.2*1030
 . . ; S PNM=VADM(1),SEX=$P(VADM(5),U),DOB=$P(VADM(3),U),AGE=VADM(4),SSN=$P(VADM(2),U),LRWRD=$P(VAIN(4),U,2)
 . . S PNM=VADM(1),SEX=$P(VADM(5),U),DOB=$P(VADM(3),U,2),AGE=VADM(4),SSN=$P(VADM(2),U),LRWRD=$P(VAIN(4),U,2) ; IHS/OIT/MKK LR*5.2*1030
 . . S LRWRD(1)=+VAIN(4),LRRB=VAIN(5),LRPRAC=+VAIN(2) S:VAIN(3) LRTREA=+VAIN(3)
 D SSNFM^LRU
 Q
DEM ;Call DEM^VADPT instead of OERR used above
 N X,I,N,Y
 ; D KVAR^VADPT
 ; K LRTREA,LRWRD S (AGE,PNM,SEX,DOB,SSN,VA200,LRWRD,LRRB,LRTREA,VA("PID"),VA("BID"))=""
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1030
 D @$S($$ISPIMS^BLRUTIL:"KVAR^VADPT",1:"KVAR^BLRDPT")
 K LRTREA,LRWRD S (AGE,PNM,SEX,DOB,SSN,HRCN,VA200,LRWRD,LRRB,LRTREA,VA("PID"),VA("BID"))=""
 ; ----- END IHS/OIT/MKK - LR*5.2*1030
 I $G(LRDFN),'$G(LRDPF),$G(^LR(LRDFN,0)) S LRDPF=$P(^(0),U,2),DFN=$P(^(0),U,3)
 S LREND=0 S:$G(DFN)<1!('$G(LRDPF)) LREND=1 Q:$G(LREND)
 I +$G(LRDPF)'=2 D
 . S X=^DIC(+LRDPF,0,"GL")_DFN_",0)",X=$S($D(@X):@X,1:""),LRWRD=$S($D(^(.1)):$P(^(.1),U),1:0),LRRB=$S($D(^(.101)):$P(^(.101),U),1:"")
 . S PNM=$P(X,U),SEX=$P(X,U,2),SEX=$S(SEX="":"M",1:SEX),DOB=$P(X,U,3),AGE=$S($D(DT)&(DOB?7N):DT-DOB\10000,1:"??"),SSN=$P(X,U,9)
 I +$G(LRDPF)=2 N I,X,N,Y D
 . ; D DEM^VADPT D:'VAERR
 . D @$S($$ISPIMS^BLRUTIL:"DEM^VADPT",1:"DEM^BLRDPT") D:'VAERR       ; IHS/OIT/MKK - LR*5.2*1030
 . . S PNM=VADM(1),SEX=$P(VADM(5),U),DOB=$P(VADM(3),U),AGE=VADM(4),SSN=$P(VADM(2),U)
 . . ;
 D SSNFM^LRU
 Q
DD ;date/time format
 S Y=$$FMTE^XLFDT(Y,"5Z")
 S Y=$P(Y,"@")_" "_$P($P(Y,"@",2),":",1,2)
 Q
DDOLD ;OLD
 I $E(Y,4,7)="0000" S Y=$S($E(Y)=2:"19"_$E(Y,2,3),1:"20"_$E(Y,2,3)) Q
 S Y=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)_$S(Y#1:" "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12),1:"")
 Q
DT ;current date format is LRDT0
 N X,DIK,DIC,%I,DICS,%DT
 D DT^DICRW
 S Y=$$FMTE^XLFDT(DT,"5D")
 S LRDT0=Y
 Q
DTOLD ;2-DIGIT
 ;current date format is LRDT0
 N X,DIK,DIC,%I,DICS,%DT
 D DT^DICRW
 S Y=$P(DT,".") D DDOLD S LRDTO=Y
 Q
DASH ;line of dashes
 W !,$E("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",1,IOM-1)
 Q
EQUALS ;line of equals
 W !,$E("====================================================================================================================================================================================================================",1,IOM-1)
 Q
DUZ ;user info
 S (LRUSNM,LRUSI)="" Q:'$D(X)  Q:'$D(^VA(200,+X,0))  S LRUSNM=$P(^(0),"^"),LRUSI=$P(^(0),"^",2)
 Q
DOC ;provider info
 I $L(X),'X S LRDOC=X Q
 S LRDOC=$P($G(^VA(200,+X,0)),U)
 S:LRDOC="" LRDOC="Unknown"
 Q
PRAC(X) ;prac info
 N Y
 I $L(X),'X Q X
 S Y=$P($G(^VA(200,+X,0)),U)
 S:Y="" Y="Unknown"
 Q Y
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
 K LRURG S LRURG(0)="ROUTINE" S I=0 F  S I=$O(^LAB(62.05,I)) Q:I<1  I $D(^(I,0)) S:'$P(^(0),U,3) LRURG(I)=$P(^(0),U)
 Q
ADD ;date format
 S Y=$E("JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC",$E(Y,4,5)*3-2,$E(Y,4,5)*3)_" "_$S(Y#100:$J(Y#100\1,2)_", ",1:"")_(Y\10000+1700)_$S(Y#1:"  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12),1:"")
 Q
INF ;Display Infectious Warning
 I $L($G(IO)),$D(^LR(LRDFN,.091)),$L(^(.091)) W !,$C(7)," Pat Info: ",^(.091) Q
 Q
LRGLIN ;
 N HZ
 D GSET^%ZISS W IOG1
 F HZ=1:1:79 W IOHL
 W IOG0 D GKILL^%ZISS
 W !
 Q
LRUID(LRAA,LRAD,LRAN) ;Extrinsic function call to create a unique 
 ;accession identifier for an accession number.  See description
 ;of field .092 in file 68 for a full explanation of this number.   
 ;This function returns a value equal to the unique ID generated.
 ;LRAA=ien in file 68, accession area
 ;LRAD=ien for accession date in field 68.01
 ;LRAN=ien for accession number in field 68.02
 Q:$S('$G(LRAA):1,'$D(^LRO(68,LRAA,.4)):1,1:0) 0
 N DA,DIE,DLAYGO,DR,LRMNTH,LRUID,LRQTR,LRTYPE,LRYR1,LRYR2,LRJUL
 S LRUID=$P($G(^LRO(68,LRAA,.4)),"^") ;start building LRUID
 S:$L(LRUID)'=2 LRUID="0"_LRUID
 S LRTYPE=$P($G(^LRO(68,LRAA,0)),"^",3)
 S LRYR1=$E(LRAD,3)
 S LRYR2=$E(LRAD,2,3)
 S LRMNTH=$E(LRAD,4,5)
 S LRQTR=0_(LRMNTH\3.1+1)
 I "DW"[LRTYPE D
 . S X1=LRAD,X2=$E(LRAD,1,3)_"0101" D ^%DTC
 . S X=X+1,LRJUL=$E("000",1,3-$L(X))_X
 . S LRUID=LRUID_LRYR1_LRJUL
 . S LRUID=LRUID_$E("0000",1,4-$L(LRAN))_LRAN
 I LRTYPE="Y" D
 . S LRUID=LRUID_LRYR2_$E("000000",1,6-$L(LRAN))_LRAN
 I LRTYPE="Q" D
 . S LRUID=LRUID_LRYR1_LRQTR
 . S LRUID=LRUID_$E("00000",1,5-$L(LRAN))_LRAN
 I LRTYPE="M" D
 . S LRUID=LRUID_LRYR1_LRMNTH_$E("00000",1,5-$L(LRAN))_LRAN
 L +^LRO(68,"C"):99999
 I $D(^LRO(68,"C",LRUID)),'$D(^LRO(68,"C",LRUID,LRAA,LRAD,LRAN)) D
 . N X
 . S X=$E(LRUID,3,10)
 . F  S LRUID="00"_X Q:'$D(^LRO(68,"C",LRUID))  S X=X+1 S:X>99999999 X=11111111
 ;The following fields are also set in rtn LROLOVER
SET3 I $G(LRORDRR)'="R" S DR="16////"_LRUID
 I $G(LRORDRR)="R" D
 . S DR=";16.1////"_+$G(LRRSITE("RSITE"))_";16.2////"_+$G(LRRSITE("RPSITE"))_";16.3////"_LRUID_";16.4////"_LRSD("RUID")
 . I '$G(LRRSITE("IDTYPE")),'$D(^LRO(68,"C",LRSD("RUID"))) S LRUID=LRSD("RUID") ; Use sender's UID, unless previously used.
 . S DR="16////"_LRUID_DR
 S DA=LRAN,DA(1)=LRAD,DA(2)=LRAA,DIE="^LRO(68,"_DA(2)_",1,"_DA(1)_",1,",DLAYGO=68
 D ^DIE
 L -^LRO(68,"C")
 S LRORU3=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.3))
 Q LRUID
 ;
KVAR ;Kill laboratory/VADPT patient demographics
 K LRTREA,LRWRD,PNM,SEX,DOB,SSN,LRWRD,LRRB,LRTREA,VA,LRDFN,LRDPF,LREND,VAERR
 ; D KVA^VADPT
 D @$S($$ISPIMS^BLRUTIL:"KVA^VADPT",1:"KVA^BLRDPT")        ; IHS/OIT/MKK - LR*5.2*1030
 Q
ADDPT ;Returns VAPA( Patient data
 ; N X,I,N,Y D ADD^VADPT Q
 N X,I,N,Y D @$S($$ISPIMS^BLRUTIL:"ADD^VADPT",1:"ADD^BLRDPT") Q      ; IHS/OIT/MKK - LR*5.2*1030
OPDPT ;Returns VAPD( Patient data
 ; N X,I,N,Y D OPD^VADPT Q
 N X,I,N,Y D @$S($$ISPIMS^BLRUTIL:"OPD^VADPT",1:"OPD^BLRDPT") Q      ; IHS/OIT/MKK - LR*5.2*1030
SVCPT ;Returns VASV( Patient data
 ; N X,I,N,Y D SVC^VADPT Q
 N X,I,N,Y D @$S($$ISPIMS^BLRUTIL:"SVC^VADPT",1:"SVC^BLRDPT") Q      ; IHS/OIT/MKK - LR*5.2*1030
OADPT ;Returns VAOA( Patient data
 ; N X,I,N,Y D OAD^VADPT Q
 N X,I,N,Y D @$S($$ISPIMS^BLRUTIL:"OAD^VADPT",1:"OAD^BLRDPT") Q      ; IHS/OIT/MKK - LR*5.2*1030
INPPT ;Returns VAIN( Patient data
 ; N X,I,N,Y D INP^VADPT Q
 N X,I,N,Y D @$S($$ISPIMS^BLRUTIL:"INP^VADPT",1:"INP^BLRDPT") Q      ; IHS/OIT/MKK - LR*5.2*1030
IN5PT ;Returns VAIP( Patient data
 ; N X,I,N,Y D IN5^VADPT Q
 N X,I,N,Y D @$S($$ISPIMS^BLRUTIL:"IN5^VADPT",1:"IN5^BLRDPT") Q      ; IHS/OIT/MKK - LR*5.2*1030
PIDPT ;Returns VA("PID") and VA("BID") Patient Identifier
 ; N X,I,N,Y D PID^VADPT Q
 N X,I,N,Y D @$S($$ISPIMS^BLRUTIL:"PID^VADPT",1:"PID^BLRDPT") Q      ; IHS/OIT/MKK - LR*5.2*1030
 ;
 QUIT
 ;
Y2K(X,LRYR) ;   --> used to convert 2digit year to 4digit century and year
 ; 1/1/91 TO 1/1/1991
 ;
 ;S X=$P(X,".") ;--> Date only. Not time
 S LRYR=$G(LRYR,"5S")
 N YR
 S Y=$$FMTE^XLFDT(X,LRYR)
 I $L($P(Y,"/"))=1 S $P(Y,"/")="0"_$P(Y,"/") ;--> pad for 2digit day
 I $L($P(Y,"/",2))=1 S $P(Y,"/",2)="0"_$P(Y,"/",2) ;--> for 2digit month
 Q Y
 ;
 QUIT
 ;
 I X'?7N,X'?7N1".".N Q "????"
 I '(X\1000000) Q "????"
 S YR=$E(X,1,3)+1700
 S Y=$E(X,4,5)_"/"_$E(X,6,7)_"/"_YR ;_$E(X,8,99)
 ;S Y=$TR(Y,".","@")
 ;I $L(Y)>15 S Y=$E(Y,1,15)_":"_$E(Y,16,99)
 Q Y
 QUIT
