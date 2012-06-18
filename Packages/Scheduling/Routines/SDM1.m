SDM1 ;SF/GFT - MAKE APPOINTMENT ; 27 Nov 2000 11:15 AM
 ;;5.3;Scheduling;**32,167,168,80,223,263,273,1005**;Aug 13, 1993
 ;IHS/ANMC/LJF 12/13/2000 added check for overbook access by clinic
 ;              6/15/2001 print all special instructions
 ;IHS/OIT/LJF  03/08/2006 PATCH 1005 if max days for future booking<3 and appt on Monday, is okay
 ;
1 L  Q:$D(SDXXX)  S CCXN=0 K MXOK,COV,SDPROT Q:DFN<0  S SC=+SC
 S X1=DT,SDEDT=365 S:$D(^SC(SC,"SDP")) SDEDT=$P(^SC(SC,"SDP"),"^",2)
 ;
 ;IHS/OIT/LJF 03/08/2006 PATCH 1005 save maximum days for future booking parameter
 NEW BSDMAX S BSDMAX=SDEDT
 ;
 S X2=SDEDT D C^%DTC S SDEDT=X D WRT
 ;
 ;IHS/ANMC/LJF 6/15/2001 print all special instructions
 ;I $D(^SC(SC,"SI")),$O(^("SI",0))>0 W !,*7,?8,"**** SPECIAL INSTRUCTIONS ****",! S %I=0 F %=0:1 S %I=$O(^SC(SC,"SI",%I)) Q:%I'>0  W ^(%I,0) W:% ! I '%,$O(^SC(SC,"SI",%I))>0 S POP=0 D SPIN Q:POP
 I $D(^SC(SC,"SI")),$O(^("SI",0))>0 W !,*7,?8,"**** SPECIAL INSTRUCTIONS ****",! S %I=0 F  S %I=$O(^SC(SC,"SI",%I)) Q:%I'>0  W ^(%I,0),!
 ;IHS/ANMC/LJF 6/15/2001 end of changes
 ;
 I $D(SDINA),SDINA>DT D IN W !,?8,@SDMSG K SDMSG
 G:SDMM RDTY^SDMM
 ;
ADT S:'$D(SDW) SDW=""
 S SDSOH=$S('$D(^SC(SC,"SL")):0,$P(^("SL"),"^",8)']"":0,1:1),CCX=""
 S SDONCE=$G(SDONCE)+1  ;Prevent repetitive iteration
 S X=$S(SDONCE<2:$G(SDSDATE),1:"")  ;Use default date/time if specified as 'desired date'  
 I 'X R !,"DATE/TIME: ",X:DTIME G:X="M"!(X="m") MORDIS^SDM0 I "^"[X D  Q
 .;
 .;Wait List Hook/teh patch 263
 .;
WL .I $D(SC) S SDWLFLG=0 D
 ..I $D(^SDWL(409.32,"B",+SC)) S SDWLFLG=1
 ..I 'SDWLFLG S SDWLDSS=$P($G(^SC(+SC,0)),U,7) I $D(^SDWL(409.31,"B",SDWLDSS)) S SDWLFLG=2
 ..I SDWLFLG=1 S SDWLSC=$O(^SDWL(409.32,"B",+SC,0)) I $P(^SDWL(409.32,SDWLSC,0),U,4) S SDWLFLG=0
 ..I SDWLFLG=2 S SDWLDS=$O(^SDWL(409.31,"E",DUZ(2),0)) I $D(^SDWL(409.31,SDWLDSS,"I",+SDWLDS,0)),$P(^(0),U,4) S SDWLFLG=0
 ..I SDWLFLG D
 ...K SDWLSC,SDWLDSS,SDWLDS,SDWLFLG
 ...S SDWLOPT=1,SDWLERR=0 D OPT^SDWLE D EN^SDWLKIL
 .Q
 .;
 I X="D"!(X="d") S X=$$REDDT() G:X>0 MORD2^SDM0 S X="" W "  ??",! G ADT
 I X?1"?".E D  G ADT
 .W !,"Enter a date/time for the appointment"
 .W:$D(SD) " or a space to choose the same date/time as the patient you have just previously scheduled into this clinic"
 .W ".",!,"You may also select 'M' to display the next month's availability or"
 .W !,"'D' to specify an earlier or later date to begin the availability display."
 I X=" ",$D(SD),SD S Y=SD D AT^SDUTL W Y S Y=SD G OVR
 I $E($P(X,"@",2),1,4)?1.4"0" K %DT S X=$P(X,"@"),X=$S($L(X):X,1:"T"),%DT="XF" D ^%DT G ADT:Y'>0 S X1=Y,X2=-1 D C^%DTC S X=X_.24
 K %DT S %DT="TXEF" D ^%DT
 I $P(Y,".",2)=24 S X1=$P(Y,"."),X2=1 D C^%DTC S Y=X_".000001"
OVR I $D(^HOLIDAY($P(Y,"."),0)),'SDSOH W *7,?50,$P(^(0),U,2),"??" K SDSDATE G ADT
 I $D(SDINA),$P(Y,".")'<SDINA,$S('$D(SDRE):1,SDRE>$P(Y,".")!('SDRE):1,1:0) D IN W !,*7,@SDMSG K SDMSG K SDSDATE G ADT
 I Y#1=0 K SDSDATE G 1
 ;
 ;IHS/OIT/LJF 03/08/2006 PATCH 1005 if max days for future = 1 or 2, Monday appt okay
 I BSDMAX<3,$$FMDIFF^XLFDT(Y,DT)<4,$$DOW^XLFDT(Y)="Monday" G EN1
 I $P(Y,".")'<SDEDT W !,*7,"EXCEEDS MAXIMUM DAYS FOR FUTURE APPOINTMENT!!",*7 K SDSDATE G ADT
 ;
EN1 S (X,SD)=Y,SM=0 D DOW
 F S=$P(SD,"."):0 S S=+$O(^DPT(DFN,"S",S)) Q:$P(S,".")-($P(SD,"."))  S I=+^(S,0) G ^SDM2:$P(^(0),U,2)'["C"
 ;
PRECAN I $D(^DPT(DFN,"S",SD,0)),$P(^(0),U,2)["P" S %=1 W !,"THIS TIME WAS PREVIOUSLY CANCELLED BY THE PATIENT",!,"ARE YOU SURE THAT YOU WANT TO PROCEED" D YN^DICN W:'% !,"ANSWER WITH (Y)ES OR (N)O" I (%-1) K SDSDATE G ADT
 W !
 ;
S I '$D(^SC(SC,"ST",$P(SD,"."),1)) S SS=+$O(^SC(+SC,"T"_Y,SD)) G XW:SS'>0,XW:^(SS,1)="" S ^SC(+SC,"ST",$P(SD,"."),1)=$E($P($T(DAY),U,Y+2),1,2)_" "_$E(SD,6,7)_$J("",SI+SI-6)_^(1),^(0)=$P(SD,".")
LEN I $P(SL,U,2)]"" W !,"LENGTH OF APPOINTMENT (IN MINUTES): ",+SL,"// " R S:DTIME I S]"" G:$L(S)>3 LEN Q:U[S  S POP=0 D L G LEN:POP,S:S\5*5'=S,S:S>360,S:S<5 S SL=S_U_$P(SL,U,2,99)
 ;
SC S SDLOCK=$S('$D(SDLOCK):1,1:SDLOCK+1) G:SDLOCK>9 LOCK
 L ^SC(SC,"ST",$P(SD,"."),1):5 G:'$T SC
 S SDLOCK=0,S=^SC(SC,"ST",$P(SD,"."),1)
 S I=SD#1-SB*100,ST=I#1*SI\.6+($P(I,".")*SI),SS=SL*HSI/60*SDDIF+ST+ST
 G X:(I<1!'$F(S,"["))&(S'["CAN")
 I SM<7 S %=$F(S,"[",SS-1) S:'%!($P(SL,"^",6)<3) %=999 I $F(S,"]",SS)'<%!(SDDIF=2&$E(S,ST+ST+1,SS-1)["[") S SM=7
 ;
SP I ST+ST>$L(S),$L(S)<80 S S=S_" " G SP
 S SDNOT=1
 F I=ST+ST:SDDIF:SS-SDDIF S ST=$E(S,I+1) S:ST="" ST=" " S Y=$E(STR,$F(STR,ST)-2) G C:S["CAN"!(ST="X"&($D(^SC(+SC,"ST",$P(SD,"."),"CAN")))),X:Y="" S:Y'?1NL&(SM<6) SM=6 S ST=$E(S,I+2,999) S:ST="" ST=" " S S=$E(S,1,I)_Y_ST
 Q:SDMM  G OK^SDM1A:SM#9=0,^SDM3:$P(SL,U,7)]""&('$D(MXOK))
 ;
E ;G:'$D(^XUSEC("SDOB",DUZ)) NOOB      ;IHS/ANMC/LJF 12/13/2000
 G:'$$OVRBKUSR^BSDU(DUZ,+SC) NOOB     ;IHS/ANMC/LJF 12/13/2000
 S %=2 W *7,!,$E($T(@SM),5,99),"...OK" D YN^DICN
 I '% W !,"RESPOND YES OR NO" G E
 S SM=9 G SC:'(%-1) K SDSDATE G 1
 ;
LOCK Q:SDMM  W !,*7,"ANOTHER USER HAS LOCKED THIS DATE - TRY AGAIN LATER" Q
 ;
6 ;;OVERBOOK!
7 ;;THAT TIME IS NOT WITHIN SCHEDULED PERIOD!
C S POP=1 W !,*7,"CAN'T BOOK WITHIN A CANCELLED TIME PERIOD!",!
 Q:SDMM  K SDSDATE G 1
 ;
DAY ;;^SUN^MON^TUES^WEDNES^THURS^FRI^SATUR
 ;
DOW S %=$E(X,1,3),Y=$E(X,4,5),Y=Y>2&'(%#4)+$E("144025036146",Y)
 F %=%:-1:281 S Y=%#4=1+1+Y
 S Y=$E(X,6,7)+Y#7 Q
 ;
X I SDMM S POP=1 Q
 G:I<1 XW
 S:Y'?1NL&(SM<6) SM=6
 G OK^SDM1A:SM#9=0,^SDM3:$P(SL,U,7)]""&('$D(MXOK))
XW W *7,"  WHEN??" K SDSDATE G 1
 ;
NOOB W !,"NO OPEN SLOTS THEN",*7 K SDSDATE G 1
 ;
WRT W !,+SL," MINUTE APPOINTMENTS "
 W $S($P(SL,U,2)["V":"(VARIABLE LENGTH)",1:"") Q
 ;
L S SDSL=$S($P(SL,"^",6)]"":60/$P(SL,"^",6),1:"") Q:'SDSL
 I S\(SDSL)*(SDSL)'=S W *7,!,"Appt. length must = or be a multiple of the increment minutes per hour (",SDSL,")",! S POP=1
 Q
 ;
IN S SDHY=$S($D(Y):Y,1:""),Y=SDINA D DTS^SDUTL S Y1=Y,Y=SDRE
 D:Y DTS^SDUTL
 S SDMSG="""*** Note: Clinic is scheduled to be inactivated on "","_""""_Y1_""""_$S(SDRE:",!,?10,"_""" and reactivated on "","_""""_Y_"""",1:""),Y=SDHY K Y1,SDHY
 Q
 ;
SPIN W !,"There are more special instructions. Do you want to display them"
 S %=2 D YN^DICN
 I '% W !,"Enter Y to see the remaining special instructions, or N if you don't wish to see them" G SPIN
 I (%-1) S POP=1 Q
 W !,^SC(SC,"SI",%I,0),! Q
 ;
REDDT() ;Prompt for availability redisplay date
 N %DT,X,Y
 S %DT="AEX"
 S %DT("A")="DATE TO BEGIN THE RE-DISPLAY OF CLINIC AVAILABILITY: "
 W ! D ^%DT
 Q Y
