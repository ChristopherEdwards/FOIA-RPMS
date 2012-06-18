SDUNC ;MAN/GRR - RESTORE CLINIC AVAILABILITY ; [ 01/09/2003  1:54 PM ]
 ;;5.3;Scheduling;**79,1006**;Aug 13, 1993
 ;IHS/ANMC/LJF  8/18/2000 added DIC("W") to warn if clinic inactivated
 ;             11/30/2000 changed $N to $O
 ;             12/13/2000 added code for 10 hour clinic displays
 ;             12/18/2002 added check so only onwers can restore clinic
 ;IHS/OIT/LJF  06/28/2006 PATCH 1006 if clinic pattern was deleted by a future inactivation, cannot restore
 ;
 ;D DT^DICRW S DIC=44,DIC(0)="MEQA",DIC("S")="I $P(^(0),""^"",3)=""C"",'$G(^(""OOS""))",DIC("A")="Select CLINIC NAME: " D ^DIC K DIC("S"),DIC("A") Q:"^"[X  G:Y<0 SDUNC Q:'$D(^SC(+Y,"SL"))  ;IHS/ANMC/LJF 8/18/2000
 D DT^DICRW S DIC=44,DIC(0)="MEQA",DIC("S")="I $P(^(0),""^"",3)=""C"",'$G(^(""OOS""))",DIC("A")="Select CLINIC NAME: ",DIC("W")=$$INACTMSG^BSDU D ^DIC K DIC("S"),DIC("A") Q:"^"[X  G:Y<0 SDUNC Q:'$D(^SC(+Y,"SL"))  ;IHS/ANMC/LJF 8/18/2000
 ;1/9/2003 WAR per P46,LJF37
 I '$$OWNER^BSDU(+Y,+$G(DUZ)) D MSG^BDGF("You are NOT an owner of this clinic.  Please select again.",2,1) G SDUNC  ;IHS/ANMC/LJF 12/18/2002
 I $D(^SC(+Y,0))   ;IHS/ANMC/LJF 12/18/2002 restoring naked reference
 S SC=+Y,SL=^("SL"),%DT="AEXF",%DT("A")="RESTORE '"_$P(Y,U,2)_"' FOR WHAT DATE: " D ^%DT K %DT Q:Y<0  ;NAKED REFERENCE - ^SC(IFN,"SL")
 S (SD,CDATE)=Y,%=$P(SL,U,6),SI=$S(%="":4,%<3:4,%:%,1:4),%=$P(SL,U,3),STARTDAY=$S(%:%,1:8)
 K SDIN,SDIN1,SDRE,SDRE1 I $D(^SC(SC,"I")) S SDIN=+^("I"),SDRE=+$P(^("I"),"^",2),Y=SDIN D DTS^SDUTL S SDIN1=Y,Y=SDRE D DTS^SDUTL S SDRE1=Y
 I $S('$D(SDIN):0,'SDIN:0,SDIN>CDATE:0,SDRE'>CDATE&(SDRE):0,1:1) W !,*7,"Clinic is inactive ",$S(SDRE:"from ",1:"as of "),SDIN1,$S(SDRE:" to "_SDRE1,1:"") G SDUNC
 K SDIN,SDIN1,SDRE,SDRE1 G:'$D(^SC(SC,"ST",SD,1)) NOWAY
 I $D(^SC(SC,"ST",SD,1)),^(1)'["CANCELLED"&(^(1)'["X") G NOWAY
 I $D(^SC(SC,"ST",SD,9)) I $D(^SC(SC,"OST",SD,1)) D FIX Q:^SC(SC,"ST",SD,1)["X"&('$D(SDFR1))  S ^SC(SC,"ST",SD,1)=HOLD K:^(1)'["X" ^SC(SC,"ST",SD,"CAN") W !,"RESTORED!",*7 D CHK Q
 I $D(^SC(SC,"ST",SD,9)),'$D(^SC(SC,"OST",SD,1)) G ERRM^SDUNC1
 ;
 ;IHS/OIT/LJF 06/28/2006 PATCH 1006
 ;D B Q:^SC(SC,"ST",SD,1)["X"&('$D(SDFR1))  S ^SC(SC,"ST",SD,0)=SD,^SC(SC,"ST",SD,1)=DH G N
 D B Q:^SC(SC,"ST",SD,1)["X"&('$D(SDFR1))
 I '$D(DH) W !!,"**** This date CANNOT be RESTORED. ****",!,"Clinic has been INACTIVATED and default slots have been removed.",!,"You must enter the AVAILABILITY again under Set Up A Clinic." Q  ;new code
 S ^SC(SC,"ST",SD,0)=SD,^SC(SC,"ST",SD,1)=DH G N
 ;IHS/OIT/LJF 06/28/2006 end of PATCH 1006 changes
 ;
NOWAY W !,*7,"CLINIC HAS NOT BEEN CANCELLED FOR THAT DATE, SO IT CANNOT BE RESTORED",*7 G SDUNC
B ;S X=SD D DOW^SDM0 S DOW=Y,SS=$N(^SC(SC,"T"_Y,X)) I $D(^(SS,1)),^(1)]"" S DH=$P("SU^MO^TU^WE^TH^FR^SA","^",DOW+1)_" "_$E(SD,6,7)_$J("",SI+SI-6)_^(1),DO=X+1,DA(1)=SC,HOLD=DH D FIX2   ;IHS/ANMC/LJF 11/30/2000
 S X=SD D DOW^SDM0 S DOW=Y,SS=$O(^SC(SC,"T"_Y,X)) I $D(^(+SS,1)),^(1)]"" S DH=$P("SU^MO^TU^WE^TH^FR^SA","^",DOW+1)_" "_$E(SD,6,7)_$J("",SI+SI-6)_^(1),DO=X+1,DA(1)=SC,HOLD=DH D FIX2   ;IHS/ANMC/LJF 11/30/2000 $N->$O
 Q
N I '$F(^SC(SC,"ST",SD,1),"[") K ^SC(SC,"ST",SD) W !,*7,"CLINIC DOES NOT MEET ON THAT DAY" G SDUNC
 K:^SC(SC,"ST",SD,1)'["X" ^SC(SC,"ST",SD,"CAN") W !,"RESTORED!",*7 D CHK Q
FIX I ^SC(SC,"ST",SD,1)["X" S SDREST=^SC(SC,"OST",SD,1) D SEL Q
 S HOLD=^SC(SC,"OST",SD,1)
 Q
CHK ;F N1=SD:0 S N1=$N(^SC(SC,"S",N1)) Q:N1<0!(N1\1-SD)  I $D(^SC(SC,"S",N1,"MES")) D KMES I $D(SDFR1),'$D(^("MES")) Q   ;IHS/ANMC/LJF 11/30/2000
 F N1=SD:0 S N1=$O(^SC(SC,"S",N1)) Q:('N1)!(N1\1-SD)  I $D(^SC(SC,"S",N1,"MES")) D KMES I $D(SDFR1),'$D(^("MES")) Q   ;IHS/ANMC/LJF 11/30/2000 $N->$O
 Q
FIX2 Q:^SC(SC,"ST",SD,1)'["X"
 S SDREST=DH D SEL Q:'$D(SDFR1)  S DH=HOLD
 Q
SEL K SDFR1 Q:'$D(^SC(SC,"SL"))  S SL=^("SL"),%=$P(SL,U,6),SI=$S(%="":4,%<3:4,%:%,1:4),%=$P(SL,U,3),STARTDAY=$S(%:%,1:8)
 W !,"Clinic has been cancelled for the following periods:",!
 ;
 ;IHS/ANMC/LJF 11/30/2000 $N->$O
 ;K SDTEMP,SDZZ S SDZZ=0 F I=SD:0 S I=$N(^SC(SC,"SDCAN",I)) Q:I'>0!(I\1-SD)  S SDZZ=SDZZ+1,X=I D TM S SDFR=X,SDFRX=X1,X="."_$P(^(I,0),"^",2) D TM S SDTO=X,SDTEMP(SDFRX_"-"_X1)=SDFR_"^"_SDTO,SDZZ(SDZZ)=SDFRX_"-"_X1
 K SDTEMP,SDZZ S SDZZ=0 F I=SD:0 S I=$O(^SC(SC,"SDCAN",I)) Q:I'>0!(I\1-SD)  S SDZZ=SDZZ+1,X=I D TM S SDFR=X,SDFRX=X1,X="."_$P(^(I,0),"^",2) D TM S SDTO=X,SDTEMP(SDFRX_"-"_X1)=SDFR_"^"_SDTO,SDZZ(SDZZ)=SDFRX_"-"_X1
 ;F I=SD:0 S I=$N(^SC(SC,"S",I)) Q:I'>0!(I\1-SD)  I $D(^SC(SC,"S",I,"MES")),'$D(^SC(SC,"SDCAN",I)) S X=I D TM S SDFRX=X1,SDFR=X,X="."_$E(^SC(SC,"S",I,"MES"),17,20) D TM S SDZZ=SDZZ+1,SDTEMP(SDFRX_"-"_X1)=SDFR_"^"_X,SDZZ(SDZZ)=SDFRX_"-"_X1
 F I=SD:0 S I=$O(^SC(SC,"S",I)) Q:I'>0!(I\1-SD)  I $D(^SC(SC,"S",I,"MES")),'$D(^SC(SC,"SDCAN",I)) S X=I D TM S SDFRX=X1,SDFR=X,X="."_$E(^SC(SC,"S",I,"MES"),17,20) D TM S SDZZ=SDZZ+1,SDTEMP(SDFRX_"-"_X1)=SDFR_"^"_X,SDZZ(SDZZ)=SDFRX_"-"_X1
 ;F I1=0:0 S I1=$N(SDZZ(I1)) Q:I1'>0  S I=SDTEMP(SDZZ(I1)) W !,?9,"(",$J(I1,2),") ","From: ",$J($P(I,"^",1),8),"   To: ",$J($P(I,"^",2),8)
 F I1=0:0 S I1=$O(SDZZ(I1)) Q:I1'>0  S I=SDTEMP(SDZZ(I1)) W !,?9,"(",$J(I1,2),") ","From: ",$J($P(I,"^",1),8),"   To: ",$J($P(I,"^",2),8)
 ;
A K SDFRX,X1,SDFR,SDTO R !!,"RESTORE WHICH PERIOD?: ",X:DTIME Q:"^"[X
 I X?1"?".E W !,"Enter the # that precedes the time period you want to restore." G A
 S SDR=X I $D(SDZZ(SDR)),$D(SDTEMP(SDZZ(SDR))) W "      ",$P(SDTEMP(SDZZ(SDR)),"^",1)," - ",$P(SDTEMP(SDZZ(SDR)),"^",2) G ROK
 W !,*7,"INVALID CHOICE, TRY AGAIN" G A
ROK S X=$P(SDZZ(SDR),"-",1) D TC S FR=X,SDBEG=%+SI+SI,X=$P(SDZZ(SDR),"-",2) D TC S TO=X,SDEND=%+SI+SI
 S SDFR1=CDATE+(FR/10000) K SDTEMP,SDZZ,SDR
 ;S HOLD=^SC(SC,"ST",SD,1),HOLD=$E(HOLD,1,SDBEG-1)_$E(SDREST,SDBEG,SDEND)_$E(HOLD,SDEND+1,80) K ^SC(SC,"SDCAN",SDFR1) I $D(^SC(SC,"SDCAN",0)) S CNT=$P(^(0),U,4),CNT=$S(CNT>0:CNT-1,1:0),^(0)=$P(^(0),U,1,3)_U_CNT K CNT  ;IHS/ANMC/LJF 12/13/2000
 S HOLD=^SC(SC,"ST",SD,1),HOLD=$E(HOLD,1,SDBEG-1)_$E(SDREST,SDBEG,SDEND)_$E(HOLD,SDEND+1,132) K ^SC(SC,"SDCAN",SDFR1) I $D(^SC(SC,"SDCAN",0)) S CNT=$P(^(0),U,4),CNT=$S(CNT>0:CNT-1,1:0),^(0)=$P(^(0),U,1,3)_U_CNT K CNT  ;IHS/ANMC/LJF 12/13/2000
 K SDBEG,SDEND,SDANS,SI,STARTDAY,FR,TO Q
KMES I '$D(SDFR1) K ^("MES") Q  ;NAKED REFERENCE - ^SC(IFN,"S",DATE,"MES")
 I $D(SDFR1),N1=SDFR1 K ^("MES") Q  ;NAKED REFERENCE - ^SC(IFN,"S",DATE,"MES")
 Q
TC S %=$E(X,3,4),%=X\100-STARTDAY*SI+(%*SI\60)*2
 Q
TM S X=$E($P(X,".",2)_"0000",1,4),X1=X,%=X>1159 S:X>1259 X=X-1200 S X=X\100_":"_$E(X#100+100,2,3)_" "_$E("AP",%+1)_"M" Q
