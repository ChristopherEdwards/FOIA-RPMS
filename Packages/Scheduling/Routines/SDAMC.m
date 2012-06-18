SDAMC ;ALB/MJK - Cancel Appt Action ; 2/4/92
 ;;5.3;Scheduling;**20,28,32,46,263,1005,1010,1012**;Aug 13, 1993
 ;IHS/ANMC/LJF 12/06/2000 prevent cancel if appt already checked in
 ;IHS/OIT/LJF  01/26/2006 PATCH 1005 added OTHER INFO to Cancel Remarks
 ;cmi/anch/maw 09/04/2008 PATCH 1010 added hard cancel if node in DPT but not SC
 ;cmi/flag/maw 06/02/2010 PATCH 1012 RQMT149 added for appt check in list view
 ;
EN ; -- protocol SDAM APPT CANCEL entry pt
 ; input:  VALMY := array entries
 ;
 N SDI,SDAT,VALMY,SDAMCIDT,CNT,L,SDWH,SDCP,SDREM,SDSCR,SDMSG
 K ^UTILITY($J)
 ;
 ;
 I '$D(DFN),$G(SDFN),($G(SDAMTYP)="P") S DFN=SDFN
 ;
 S VALMBCK=""
 D SEL^VALM2,CHK G ENQ:'$O(VALMY(0))
 D FULL^VALM1 S VALMBCK="R"
 S SDWH=$$WHO,SDCP=$S(SDWH="C":0,1:1) G ENQ:SDWH=-1
 S SDSCR=$$RSN(SDWH) G ENQ:SDSCR=-1
 S SDREM=$$REM G ENQ:SDREM=-1
 S (SDI,CNT,L)=0
 F  S SDI=$O(VALMY(SDI)) Q:'SDI  I $D(^TMP("SDAMIDX",$J,SDI)) K SDAT S SDAT=^(SDI) W !,^TMP("SDAM",$J,+SDAT,0) D CAN($P(SDAT,U,2),$P(SDAT,U,3),.CNT,.L,SDWH,SDCP,SDSCR,SDREM)
 I SDAMTYP="P" D MES,NOPE,BLD^SDAM1
 I SDAMTYP="C" D BLD^SDAM3
ENQ Q
 ;
CAN(DFN,SDT,CNT,L,SDWH,SDCP,SDSCR,SDREM) ;
 N A1,NDT S NDT=SDT
 I $P($G(^DPT(DFN,"S",NDT,0)),U,2)["C" W !!,"Appointment already cancelled" H 2 G CANQ
 ;
 ;IHS/ANMC/LJF 12/06/2000 new code to screen for checked in patients
 NEW IEN,C S C=+$G(^DPT(DFN,"S",NDT,0)),IEN=$$SCIEN^BSDU2(DFN,C,NDT)
 ;cmi/anch/maw 9/4/2008 PIMS Patch 1010 for hanging cancellations from GUI Scheduling
 I '$G(IEN) D  G CANQ
 . S $P(^DPT(DFN,"S",NDT,0),U,2)="C"  ;mark the appointment as cancelled
 . W !!,"Appointment cancelled" H 2
 I $$CI^BSDU2(DFN,C,NDT,IEN) D MSG^BDGF("Patient already checked-in.  Cannot cancel unless check-in date deleted.",2,1),PAUSE^BDGF Q
 ;IHS/ANMC/LJF 12/06/2000 end of new code
 ;
 ;IHS/OIT/LJF 01/26/2006 PATCH 1005 add OTHER INFO to end of Cancel Remarks
 ; (using C and IEN set above) this way OTHER INFO is stored after cancellation
 NEW X S X=$P($G(^SC(C,"S",SDT,1,IEN,0)),U,4) I X]"" S SDREM=SDREM_"["_X_"]",SDREM=$E(SDREM,1,160)
 ;
 I $D(^DPT(DFN,"S",NDT,0)) S SD0=^(0) I $P(SD0,"^",2)'["C" S SC=+SD0,L=L\1+1,APL="" D FLEN^SDCNP1A S ^UTILITY($J,"SDCNP",L)=NDT_"^"_SC_"^"_COV_"^"_APL_"^^"_APL D CHKSO^SDCNP0
 S APP=1,A1=L\1 D BEGD^SDCNP0
 I SDAMTYP="C" D MES,NOPE W ! S (CNT,L)=0 K ^UTILITY($J,"SDCNP")
CANQ ;
 ;Wait List Message
 ;
 I $D(SDCLN),$D(^SDWL(409.3,"SC",SDCLN)) D
 .W !,?1,"There are Patients on the Wait List waiting for an Appointment in this Clinic."
 S DIR(0)="E" D ^DIR
 Q
MES ; -- set error message
 S SDMSG="W !,""Enter appt. numbers separated by commas and/or a range separated"",!,""by dashes (ie 2,4,6-9)"" H 2"
 Q
 ;
WHO() ;
 W ! S DIR(0)="SOA^PC:PATIENT;C:CLINIC",DIR("A")="Appointments cancelled by (P)atient or (C)linic: ",DIR("B")="Patient"
 D ^DIR K DIR
 Q $S(Y=""!(Y="^"):-1,1:Y)
 ;
RSN(SDWH) ;
RSN1 W ! S DIC="^SD(409.2,",DIC(0)="AEMQ",DIC("S")="I '$P(^(0),U,4),"""_$E(SDWH)_"B""[$P(^(0),U,2)" D ^DIC K DIC
 I X["^" G RSNQ
 I Y<0 W *7 G RSN1
RSNQ Q +Y
 ;
REM() ;
 W ! S DIR(0)="2.98,17" D ^DIR K DIR
 I $E(X)="^" S Y=-1
 Q Y
 ;
NOPE ;
 N SDEND,SDPAUSE
 S:'CNT SDPAUSE=1
 D NOPE^SDCNP1
 D:$G(SDPAUSE) PAUSE^VALM1
 Q
 ;
CHK ; -- check if status of appt permits cancelling
 N SDI S SDI=0
 F  S SDI=$O(VALMY(SDI)) Q:'SDI  I $D(^TMP("SDAMIDX",$J,SDI)) K SDAT S SDAT=^(SDI) D
 . I $P(SDAT,U,6)]"" W !!,*7,">>> This is not a valid appointment." K VALMY(SDI) D PAUSE^VALM1 Q  ;cmi/maw 6/2/2010 PATCH 1012 for list view
 . I '$D(^SD(409.63,"ACAN",1,+$$STATUS^SDAM1($P(SDAT,U,2),$P(SDAT,U,3),+$G(^DPT(+$P(SDAT,U,2),"S",+$P(SDAT,U,3),0)),$G(^(0))))) D
 ..W !,^TMP("SDAM",$J,+SDAT,0),!!,*7,"You cannot cancel this appointment."
 ..K VALMY(SDI) D PAUSE^VALM1
 Q
