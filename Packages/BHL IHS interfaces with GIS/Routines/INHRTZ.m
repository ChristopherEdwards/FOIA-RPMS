INHRTZ ;DP; 5 Jan 96 08:54;27 Dec 95 10:39;Throughput analyzer report  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
EN ;Main entry point
 N DES,N,I,X,INLOAD,DET,INBEG,INEND,INENDX
 W @IOF Q:'$$PARM
 ;Device handling & Tasking logic
 K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ"
 D ^%ZIS G:POP QUIT
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." G QUIT
 I IO'=IO(0) D  G QUIT
 .S ZTDESC="Throughput analyzer report",ZTIO=IOP,ZTRTN="ENQUE^INHRTZ"
 .S ZTSAVE("INLOAD")=INLOAD
 .D ^%ZTLOAD
ENQUE ;Taskman entry point
 K ^UTILITY($J)
 S ST=$P(INLOAD,U),DET=$P(INLOAD,U,2),DES=$P(INLOAD,U,3)
 S INBEG=$P(INLOAD,U,4),INEND=$P(INLOAD,U,5)
 ;   INDES flag for destination list
 ;    1 List
 ;    0 All destinations
 S INDES=0 I $L(DES)>1 S INDES=1 D
 .F I=1:1:$L(DES,",")-1 S X=$P(DES,",",I),DES(X)=$P(^INRHD(X,0),U)
 S PAG=1,X1=0,DV=1
 D COMP,DEV,OUTPUT
 F I=$Y:1:(IOSL-1) W !
 S X="*** End of Report ***" W ?IOM-$L(X)\2,X
 K ^UTILITY($J)
 ;
QUIT ;Exit point
 D ^%ZISC
 Q
 ;
COMP ;Compile statistics
 ;
 ; C = holder of creation totals
 ; T = holder of transmission totals
 ;
 S LOOP=$O(^INTHU("B",INBEG,"")),C="CC",T="TT"
 ;   get the last internal number for the ending date
 S INENDX=$O(^INTHU("B",INEND,""))-1
 F CNT=1:1  S LOOP=$O(^INTHU(LOOP)) Q:'LOOP!(LOOP>INENDX)  D
 .  I IO=$P W:'(CNT#1000) "."
 .  S ZE=$G(^INTHU(LOOP,0))
 .  ; quit if date is out of range
 .  Q:+ZE>INEND
 .  ; message creation date 
 .  S MSGDTTM=+$E($P(ZE,U),1,10)
 .  ; get destination
 .  S DES=$P(ZE,U,2) Q:DES=""
 .  ;quit if destination is not on the selected array.
 .  I INDES Q:'$D(DES(DES))
 .  ;for message that was created befor the begining date make
 .  ;sure to quit if no work was done later.
 .  I +ZE<INBEG  Q:$P(ZE,U,14)<INBEG  D MULT Q
 .  ;
 .  ;Quit if status is not part of the selection string
 .  Q:$F(ST,$P(ZE,U,3))<2
 .  S STAT=$P(ZE,U,3)
 .  S ^UTILITY($J,MSGDTTM,C)=$G(^UTILITY($J,MSGDTTM,C))+1 S:^(C)>DV DV=^(C)
 .  ;stor details only if detail flag DET is on.
 .  I DET S ^UTILITY($J,MSGDTTM,DES,STAT,C)=$G(^UTILITY($J,MSGDTTM,DES,STAT,C))+1 S:^(C)>DV DV=^(C)
 .  D MULT
 Q
MULT ; Look for activity on the multiple level
 S ACT=0
 F ACTLOOP=0:1 S ACT=$O(^INTHU(LOOP,1,ACT)) Q:'ACT&ACTLOOP  D
 .S ACTZE=""
 .S:ACT ACTZE=$G(^INTHU(LOOP,1,ACT,0))
 .; Get status
 .Q:$F(ST,$P(ACTZE,U,2))<2  S STAT=$P(ACTZE,U,2)
 .; Quit if messages has no date/time.
 .Q:+ACTZE=0  S DTTM=$P(ACTZE,U)
 .Q:DTTM>INEND
 .S DTTM=+$E(DTTM,1,10)
 .S ^UTILITY($J,DTTM,T)=$G(^UTILITY($J,DTTM,T))+1 S:^(T)>DV DV=^(T)
 .  ;stor details only if detail flag DET is on.
 .Q:'DET
 .S ^UTILITY($J,DTTM,DES,STAT,T)=$G(^UTILITY($J,DTTM,DES,STAT,T))+1 S:^(T)>DV DV=^(T)
 Q
 ;
OUTPUT ;Output data
 S (DT1,DTTM)=0,ASTRX="",$P(ASTRX,"*",80)=""
 F  S DTTM=$O(^UTILITY($J,DTTM)) Q:DTTM=""  D
 .D DT S FLG=1 F I=C,T D @I
 .; quit here if this is not a detailed report
 .Q:'DET  W !
 .S FLG=0,DES=""
 .F  S DES=$O(^UTILITY($J,DTTM,DES)) Q:DES=""  D  W:$X>20 !
 ..; display destination
 ..Q:DES'?.N  I $Y>(IOSL-2) D HDR,DT
 ..W:$X>50 ! W ?15,$E($P(^INRHD(DES,0),U),1,30)
 ..; display status
 ..S ST="" F  S ST=$O(^UTILITY($J,DTTM,DES,ST)) Q:ST=""  D
 ...Q:ST'?1A  W:$X>50 !
 ...I $Y>(IOSL-2) S DT1="" D HDR,DT
 ...W ?46,ST
 ...F I=C,T S X=$G(^UTILITY($J,DTTM,DES,ST,I)) D @I
 .I $Y>IOSL D HDR,DT
 Q
 ;
CC ;Dsplay details for creation rate
 I $Y>IOSL S DT1="" D HDR,DT
 I FLG S X=$G(^UTILITY($J,DTTM,I))
 Q:X=""  S P=54 S:'DET P=22 W ?(P-$L(X)),X
 ; display the astrics line
 S X=$E(ASTRX,1,$J(X/DV,0,0)) S:'$L(X) X="*"
 S:$L(X)>SE X=$E(X,1,(SE-2))_">>" W ?(P+2),X
 Q
TT ;Display details for transmission rate
 N X0 I FLG S X=$G(^UTILITY($J,DTTM,I))
 Q:X=""  S X0=X,X=$E(ASTRX,1,$J(X/DV,0,0))
 S:'$L(X) X="*" S:$L(X)>SE X="<<"_$E(X,1,(SE-2))
 S X=X_$J(X0,7) W ?(IOM-1)-$L(X),X
 Q
DT ;Print date time
 I $Y>(IOSL-3) S DT1="" D HDR
 S DT2=$$CDATASC^%ZTFDT(DTTM,2,1)
 I DT1'=$P(DTTM,".") S DT1=$P(DTTM,".") W !,$P(DT2,"@")
 W:'DET!($X>55) ! W ?9,$P(DT2,"@",2)
 Q
 ;
DEV ;Calculate the devisor
 S SE=16 I 'DET S DV=DV/2,SE=31
 S DV=$S(DV>9000:1000,DV>4500:500,DV>1900:250,DV>900:100,1:25)
 ;
 ; Set header
 S X=$$CDATASC^%ZTFDT($H,1,1),X(0)=X_" Page "
 S X(1)="Throughput analyzer report" I DET S X(1)=X(1)_" - Detailed"
 S X="From: "_$$CDATASC^%ZTFDT($E(INBEG,1,10),3,1)
 S X(2)=X_"      To: "_$$CDATASC^%ZTFDT($E(INEND,1,10),3,1)
 D ST1 S X(3)="Status: "_X3
 S X(5)="Divisor: "_DV
 ;get the site name
 S X(6)=$S($D(^DIC(4,^DD("SITE",1),0)):^(0),1:^DD("SITE"))
 S X(6)=$S($P(X(6),U,4)]"":$P(X(6),U,4),1:$P(X(6),U,1))
 S LN="",$P(LN,"-",IOM)=""
 ;
HDR ;Print header
 W @IOF,!,X(6)
 S X=X(0)_PAG,PAG=PAG+1,DT1=""
 W ?IOM-$L(X)-2,X,!!
 F I=1:1:4 I $G(X(I))'="" W !?IOM-$L(X(I))\2,X(I)
 W !,"Destination:" D
 .I 'INDES W " All",! Q
 .S II="" F  S II=$O(DES(II)) Q:II=""  W !?14,DES(II)
 W !!,X(5),!!,LN
 W !,"  Date   Time" W:DET ?15,"Destination"
 W:DET ?42,"Status"
 S P=15 S:DET P=40 W !?P,"Creation Rates "
 S X="Transmission Rates" W ?IOM-$L(X)-2,X
 W !,LN
 Q
 ;
PARM() ;Get parameters
 ;
 S DIC=4005,DIC(0)="AEMNQZ"
 D DES Q:'Y
 S (INBEG,INEND)=0
 Q:'$$GETRNG(.INBEG,.INEND) 0
 S POP=0 D STU Q:POP 0
 I ST="" S ST=X1 W "ALL"
 D DET Q:POP 0
 Q 1
 ;
DES ;Get multiple destinations
 K X,X1,X2 S X2="" F I=1:1 D  W:Y=-1&(X2="") "ALL" Q:Y=-1
 .D ^DIC Q:+Y<1
 .S X(+Y)=$P(^INRHD(+Y,0),U)
 .S X1(X(+Y))="",X2=X2_(+Y)_","
 Q
GETRNG(START,STOP) ;get start & stop dates
 ;
 S START=1,STOP=999999999
 W ! Q:'$$IEN(.START,"Starting Date: ") 0
 ; search starts on the previous day at midnight.
 S INBEG=$O(^INTHU("B",($P(Y,".")-2)_".999999"))
 W ! Q:'$$IEN(.STOP,"  Ending Date: ") 0
 ;Ending date
 S INEND=$O(^INTHU("B",($P(IEN2,".")_".999999")),-1)
 S:INEND<INBEG INEND=INBEG
 Q 1
 ;
IEN(IEN,ASK) ;read date
 ;
 S %DT="TAEX",%DT("A")=$G(ASK) D ^%DT Q:Y<1 0
 S IEN=$Q(^INTHU("B",Y,0))
 I $QS(IEN,1)'="B" S IEN="^INTHU(""B"",3000101,9999999999999)"
 S (IEN,IEN2)=$QS(IEN,2)
 Q 1
 ;
 Q
DET ;Detail yes/no
 W ! S X=$$YN^UTSRD("Detailed: ;N")
 I X[U S POP=1 Q
 W @IOF,!,"Destination: " I $L(X2)=0 W "All "
 E  F I=1:1:$L(X2,",")-1 W ?13,$P(^INRHD($P(X2,",",I),0),U),!
 W !,"Status(s): " F I=1:1:$L(ST) W ?13,$P($P(X3,";",I),":",2),!
 W !,"From: ",$$CDATASC^%ZTFDT($E(INBEG,1,10),3,1)
 W !,"  To: ",$$CDATASC^%ZTFDT($E(INEND,1,10),3,1),!
 W !,"Detail: ",$S(X=1:"Yes",1:"No"),!!
 S Z=$$YN^UTSRD("O.K To continue? ")
 I Z[U!(Z=0) S POP=1 Q
 ; taskman variables
 ; ST    = status string
 ; X     = detail 1 yes 0 no
 ; X2    = destination list (IEN,...)
 ; INBEG = beginning date@time
 ; INEND = ending date@time
 ;
 S INLOAD=ST_U_X_U_X2_U_INBEG_U_INEND
 W ! Q
 ;
STU ;Build status string
 N I,C S (X1,ST)=""
 S X3=$P(^DD(4001,.03,0),U,3,99)
 F I=1:1:$L(X3,":")-1 S X1=X1_$P($P(X3,";",I),":")
 W ! F I=1:1 D ST Q:C=""!(POP)
 Q
ST ;Display status list
 W ! D ^UTSRD("Status: ") Q:POP
 S C=X Q:C=""
 I C=U S POP=1 Q
 I C="ALL" S ST=X1,C="" Q
 ; enter a "-" to remove an item
 I C["-",$L(ST)>0 S C=$E(C,2) D  Q
 .S ST=$E(ST,1,($F(ST,C)-2))_$E(ST,($F(ST,C)),99)
 I X1[(C) W " ",$P($P(X3,";",($F(X1,C)-1)),":",2) S ST=ST_C Q
 N I W !,"Please select from:"
 F I=1:1:$L(X1) W !," ",$P($P(X3,";",I),":"),"  ",$P($P(X3,";",I),":",2)
 W !," ALL"
 S:$$CR^UTSRD POP=1
 Q
ST1 ;get the status string to be printed as part of the header.
 N I
 S X=$P(^DD(4001,.03,0),U,3,99),(X3,X4)=""
 F I=1:1:$L(ST) S X3=X3_$P($P(X,";",I),":",2) S:I<$L(ST) X3=X3_", "
 I $L(X3)>(IOM-8) S X4=X3 D
 .F I=$L(X4,","):-1 S X3=$P(X4,",",1,I) I $L(X3)<(IOM-8) S X4=$P(X4,",",(I+1),99) Q
 S X(3)=X3,X(4)=X4
 Q
