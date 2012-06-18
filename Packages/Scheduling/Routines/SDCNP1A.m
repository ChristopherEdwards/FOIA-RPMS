SDCNP1A ;ALB/LDB - CANCEL APPT. (continued) ; [ 09/13/2001  2:21 PM ]
 ;;5.3;Scheduling;**167**;Aug 13, 1993
 ;IHS/ANMC/LJF 11/29/2000 added screen for prohibited clinics
 ;             11/30/2000 set BSDNO to prevent appt letter printing
 ;
LOOP S SDCNT1=0 F SDAP=0:0 S SDAP=$O(^UTILITY($J,"SDCNP2","REBK",DFN,SDAP)) Q:SDAP'>0  S SDP1=^(SDAP),S1=$P(SDP1,"^",2),S9=$P(^SC(S1,0),"^") D SDDT Q:X8="^"  D RBK S MAX=1
 Q
SDDT W !!,"IN ",S9 D:'$D(DT) DT^SDUTL D DT S %DT="AEX",%DT("A")="START REBOOKING FROM WHAT DATE: "_D S %DT(0)=DT D ^%DT K %DT S X8=X Q:$D(DTOUT)!(X="^")  S:X8="" Y=DT G:Y<0 SDDT S SDDT=+Y\1 K X,Y,DIC S X1=SDDT,X2=DT D ^%DTC
 S (M8,MAX)=0,S1=$P(SDP1,"^",2),S2=$P(SDP1,"^"),M1=$S($D(^SC(S1,"SDP")):$P(^("SDP"),"^",4),1:0) D MAX G:M8 SDDT
 I S2>DT S X1=SDDT,X2=1 D C^%DTC S SDDT=X
 Q
MAX I X>M1 S M8=1 W !!,"Exceeds maximum number of days for rebooking in ",S9 S MAX=0
 Q
RBK ;
 NEW BSDNO S BSDNO=1    ;IHS/ANMC/LJF 11/30/2000
 S GDATE=S2,SC=S1,LEN=$P(SDP1,"^",6),A=DFN_"^"_LEN,(CDATE,DATE)=SDDT D OVR1,SDIN D ^SDAUT1 D:'MAX NRBK D:MAX ^SDAUT2,SDNP K SDIN Q
OVR1 N X S SL=$S($D(^SC(SC,"SL")):^("SL"),1:"") Q:'SL  S X=$P(SL,U,6),SI=$S(X="":4,X<3:4,X:X,1:4),X=$P(SL,U,3),STARTDAY=$S($L(X):X,1:8),SDSTRTDT=$S(DT>DATE:DT,1:DATE),STIME=$S($D(^SC(SC,"SDP")):$P(^("SDP"),U,3),1:"0800"),SDSTRTDT=SDSTRTDT+2
 Q
SDIN I $D(^SC(SC,"I")) S SDIN=+^("I") Q
 Q
SDNP S SDCL(SDAP)=SC_"^"_GDATE_"^"_NDATE S:NDATE SDCNT1=SDCNT1+1 Q
NRBK W !,"NO REBOOKING ALLOWED FOR ",$P(^SC(SC,0),"^") Q
DT S X1=$P(DT,"."),X2=10 D C^%DTC S Y=X D D^DIQ S D=Y_"//" Q
 ;
 ;IHS/ANMC/LJF 11/29/2000
PROT ;S SDPRT=0 I $D(^SC(+I,"SDPROT")),$P(^("SDPROT"),U)="Y",'$D(^SC(+I,"SDPRIV",DUZ)) W !,*7,"Appt. in ",$P(^SC(+I,0),"^")," NOT CANCELLED ",!,"Access to this clinic is restricted to only privileged users!",*7 S SDPRT=1 Q
 S SDPRT=0
 I $D(^SC(+I,"SDPROT")),$P(^("SDPROT"),U)="Y",'$D(^SC(+I,"SDPRIV",DUZ)),'$D(^SC(+$$PC^BSDU(+I),"SDPRIV",DUZ)) W !,*7,"Appt. in ",$P(^SC(+I,0),"^")," NOT CANCELLED ",!,"Access to this clinic is restricted to only privileged users!",*7 S SDPRT=1 Q
 ;
 Q
FLEN S COV=$S($P(^DPT(DFN,"S",NDT,0),"^",11)=1:" (COLLATERAL) ",1:"") I $D(^SC(SC,"S",NDT)) F ZL=0:0 S ZL=$O(^SC(SC,"S",NDT,1,ZL)) Q:ZL'>0  I +^(ZL,0)=DFN S APL=$P(^(0),"^",2) Q
 Q
LOOP1 S SDCNT1=0 F L=0:0 S L=$O(^UTILITY($J,"SDCNP",L)) Q:L'>0  I ^(L)["JUST CANCELLED" S $P(SDCL(L),"^")=$P(^(L),"^",2),$P(SDCL(L),"^",2)=$P(^(L),"^")
 K ^UTILITY($J) Q
SDLET U IO D Q F SDAP=0:0 S SDAP=$O(SDCL(SDAP)) Q:SDAP'>0  S SDP1=SDCL(SDAP),SDC=+SDP1,GDATE=$P(SDP1,"^",2),NDATE=$P(SDP1,"^",3),SDV1=$P(^SC(SDC,0),"^",15) S:'SDV1 SDV1=+$O(^DG(40.8,0)) D F S:SDLET ^UTILITY($J,SDLET,+A,GDATE)=SDC_"^"_NDATE
 F SDLET=0:0 S SDLET=$O(^UTILITY($J,SDLET)) Q:SDLET'>0  F B0=0:0 S A1=B0,B0=$O(^UTILITY($J,SDLET,B0)) D:'B0 R Q:'B0  D:A1&(A1'=B0) R S A=B0 D ^SDLT,APP
 I $D(^UTILITY($J,"NO")) W @IOF,! F SC=0:0 S SC=$O(^UTILITY($J,"NO",SC)) Q:SC'>0  W !,$P(^SC(SC,0),"^")," Clinic is not assigned a letter",!!
 K A,SDCL D CLOSE^DGUTQ
Q K A1,SDFORM,SDLET,SDT,SDNDT,SDP1,SDV1,^UTILITY($J) Q
F S SDFORM="" I $D(^DG(40.8,SDV1,"LTR")),^("LTR") S SDFORM=^("LTR")
 S SDLET="" I $D(^SC(SDC,"LTR")) S:SDWH["P" SDLET=$P(^("LTR"),"^",4) S:SDWH'["P" SDLET=$P(^("LTR"),"^",3)
 I 'SDLET S ^UTILITY($J,"NO",SDC)=""
 Q
R I $D(^UTILITY($J,"R",SDLET,A1)) W !!,"The appointment(s) have been rescheduled as follows:",! F A2=0:0 S A2=$O(^UTILITY($J,"R",SDLET,A1,A2)) Q:A2'>0  S (X,SDX)=A2,SDC=+^(A2),A=A1,SDS=^DPT(DFN,"S",SDX,0) D WRAPP^SDLT K X,SDX
 D REST^SDLT Q
APP F SDX=0:0 S SDX=$O(^UTILITY($J,SDLET,A,SDX)) Q:SDX'>0  S S=^DPT(+A,"S",SDX,0),SDC=+^(0) D WRAPP^SDLT I $P(^UTILITY($J,SDLET,A,SDX),"^",2) S ^UTILITY($J,"R",SDLET,A,$P(^UTILITY($J,SDLET,A,SDX),"^",2))=$P(^(SDX),"^")
 Q
CKK I $L(SDDI)>4!($L(SDDM)>4) S SDERR=1 W !,"There is no appointment number ",$S($L(SDDI)>5:SDDI,1:SDDM) Q
 Q
CKK1 F Z0=SDDI,SDDM Q:'SDDI!('SDDM&(SDDI-Z0))  S SDERR=0 S:$L(Z0)>5 SDERR=1 Q:SDERR  S:$L(SDDI)<5 SDDI=+SDDI S:$L(SDDM)<5 SDDM=+SDDM I $L(Z0)>5!('$D(^UTILITY($J,"SDCNP",Z0,"CNT"))) S SDERR=1 Q
 W:SDERR !,*7,"There is no appointment number ",Z0 H 2 Q
CKK2 F Z0=SDDI,SDDM Q:'SDDI!('SDDM&(SDDI-Z0))  S SDERR=0 S:$L(Z0)>5 SDERR=1 Q:SDERR  S:$L(SDDI)<5 SDDI=+SDDI S:$L(SDDM)<5 SDDM=+SDDM I $L(Z0)>5!('$D(^UTILITY($J,"SDCNP2",DFN,Z0))) S SDERR=1 Q
 W:SDERR !,*7,"There is no appointment number ",Z0 Q
