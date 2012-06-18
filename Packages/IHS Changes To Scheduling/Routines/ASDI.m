ASDI ; IHS/ADC/PDW/ENM - CHECK-IN/UNSCH APPT/CR TODAY ;  [ 12/01/2000  10:49 AM ]
 ;;5.0;IHS SCHEDULING;**5,7**;MAR 25, 1999
 ;PATCH 5:  saved old check-in date/time if changed
 ;PATCH 7:  ask to change check-in time if only one appt in list
 ;
PAT ; -- select patient
 Q:$G(SDPEP)
 K ASDCR,SDZPL S (DFN,DIV)="" D PAT^ASDM I 'DFN!($D(ASDQUIT)) D END Q
PAT2 ;PEP; called when patient already known    
 ; calling routine must set DFN=patient ien, SDPEP=1,DIV=""
 ; calling routine must kill SDPEP and pre-save DFN value
 D APPT ;                                displays today's appts
 D WARD^ASDM ;                           display if inpt
 ;
CHOOSE ; -- ask what user wants to do
 S SDSEX=AUPNSEX="F"
 W !! K DIR S DIR(0)="NO^1:3"
 S DIR("A",1)="  1. ADD NEW UNSCHEDULED APPOINTMENT (WALK-IN)"
 S DIR("A",2)="  2. CHECK-IN PATIENT FOR SCHEDULED APPOINTMENT"
 S DIR("A",3)="  3. REQUEST CHART FOR REVIEW"
 S DIR("A")="Choose Action" D ^DIR I $D(DIRUT) G ASDI
 I Y=2 D CHK G PAT
 I Y=3 D CR G PAT
 W ! D NEW^SDI G PAT
 ;
 ;
END ; -- eoj
 D END^SDI K ASDCT,ASDS,ASDE,ASDA,DIR,ASDQUIT,HRCN,DFN,SEX,AGE,SSN
 Q
 ;
CHK ; -- SUBRTN to check patient in for appt     
 NEW X
 I '$D(ASDA) W !!,"NO SCHEDULED APPOINTMENTS; CANNOT CHECK IN" Q
 S X=$O(ASDA(0))
 I '$O(ASDA(X)) D  Q
 . S SDPR=+ASDA(X),I(SDPR)=$P(ASDA(X),U,3)                    ;PATCH 7
 . I $P(ASDA(X),U,2)=1 S ASDCKO=$P(ASDA(X),U,4) G CHK2        ;PATCH 7
 . ;S ASDCKO=$P(ASDA(X),U,4)  ;PATCH 5                        ;PATCH 7
 . ;S SDPR=+ASDA(X),I(SDPR)=$P(ASDA(X),U,3),I=$$SCX D GOT^SDI ;PATCH 7
 . S I=$$SCX D GOT^SDI
 ;
 D APPT
 K DIR S DIR(0)="NO^1:"_ASDCT,DIR("A")="Which APPOINTMENT"
 D ^DIR Q:$D(DIRUT)  Q:Y<1
 S SDPR=+ASDA(Y),I(SDPR)=$P(ASDA(Y),U,3)
 I $P(ASDA(Y),U,2)=0 S I=$$SCX D GOT^SDI Q
 S ASDCKO=$P(ASDA(X),U,4)  ;PATCH 5
 ;
CHK2 ;PATCH 7
 S ASD=Y K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="PATIENT ALREADY CHECKED IN; WANT TO UPDATE CHECK-IN TIME"
 D ^DIR I Y=1 S I=$$SCX D GOT^SDI Q
 ;
 G CHK
 ;
 ;
CR ; -- SUBRTN to request chart
 K DIC S DIC=44,DIC(0)="AEMQ"
 S DIC("A")="REQUEST CHART FOR WHICH CLINIC: "
 S DIC("S")="I $P(^(0),U,3)=""C"",$D(^(""SL""))"
 D ^DIC K DIC Q:X[U!(Y<0)
 S SC=+Y,YY=Y,SDSL=$S($D(^SC(SC,"SL")):+^("SL"),1:"") K SDRE,SDIN,SDRE1
 ;
 I $D(^SC(SC,"I")) D
 . S SDIN=+^SC(SC,"I"),SDRE=+$P(^("I"),U,2),Y=SDRE D DTS^SDUTL S SDRE1=Y
 ;
 I $S('$D(SDIN):0,'SDIN:0,SDIN>DT:0,SDRE'>DT&(SDRE):0,1:1) D  G CR
 . W !,*7,"Clinic is inactive ",$S(SDRE:"from ",1:"as of ")
 . S Y=SDIN D DTS^SDUTL W Y,$S(SDRE:" to "_SDRE1,1:"")
 ;
 K DIR S DIR(0)="D^::EXR",DIR("B")="NOW"
 S DIR("A")="REQUEST DATE/TIME:" D ^DIR Q:$D(DIRUT)  Q:Y=-1
 D OKTD^SDI
 Q
 ;
 ;
APPT ; -- SUBRTN to display today's appointments
 K ASDCT,ASDS,ASDE,ASDA
 ;
 S ASDS=DT-.0001,ASDE=DT+.2400
 S X=$O(^DPT(DFN,"S",ASDS)) I 'X!(X>ASDE) D  Q
 . W !!?5,"** NO PENDING APPOINTMENTS FOR TODAY **",!
 ;
 W !!?20,"**** TODAY'S APPOINTMENTS ****"
 F  S ASDS=$O(^DPT(DFN,"S",ASDS)) Q:'ASDS!(ASDS>ASDE)  D
 . I "I"[$P(^DPT(DFN,"S",ASDS,0),U,2) D
 .. S ASDCT=$G(ASDCT)+1
 .. S Y=ASDS D CHKSO^SDM W:$X>9 !,ASDCT W ?11 D DT^SDM0 W ?32 S DA=+SSC
 .. W SDLN,$S($D(^SC(DA,0)):$P(^(0),U),1:"DELETED CLINIC ")
 .. W COV,"  "
 .. I $P(^DPT(DFN,"S",ASDS,0),U,7)=4 D  Q
 ... ;W "UNSCHEDULED" S ASDA(ASDCT)=ASDS_U_1_U_+SSC  ;PATCH 5
 ... W "UNSCHEDULED" S ASDA(ASDCT)=ASDS_U_1_U_+SSC_U_$$CHECKIN  ;PATCH 5
 .. I $P(^DPT(DFN,"S",ASDS,0),U,7)=3 D  K ASDCKI
 ... S ASDCKI=$$CHECKIN I ASDCKI="" S ASDA(ASDCT)=ASDS_U_0_U_+SSC Q
 ... W !?15,"CHECKED-IN at " S Y=ASDCKI D DT^SDM0
 ... ;S ASDA(ASDCT)=ASDS_U_1_U_+SSC  ;PATCH 5
 ... S ASDA(ASDCT)=ASDS_U_1_U_+SSC_U_ASDCKI  ;PATCH 5
 Q
 ;
CHKR ;EP; called by CHKR to print IHS forms
 NEW DIR S DIR(0)="YO",DIR("B")="YES"
 S DIR("A")="WANT TO PRINT ROUTING SLIP NOW" D ^DIR Q:Y<1  S SDZRS=Y
 K IOP S (SDX,SDSTART,ORDER,SDREP,SDZCV)=""
 S (SDZEF,SDZHS,SDZMP,SDZAI)=1 D FORMS
 S SDZSC=SC,SDZDFN=DFN I SDZRS=1 D EN^SDROUT1
 I $P($G(^DG(40.8,$$DIV^ASDUT,"IHS")),U,4)'=1 D HS
 K SDZCV,SDZHS,SDZEF,SDZMP,SDZAI,SDZSC,SDZRS,SDZDFN
 Q
 ;
FORMS ; -- checks if forms to be printed
 Q:$P($G(^DG(40.8,$$DIV^ASDUT,"IHS")),U,4)'=1
FORMS1 ;
 I $P($G(^SC(SC,9999999)),U)="Y",$$HSTYP^ASDUT(SC,DFN)]"" S SDZHS=0_U_$$HSTYP^ASDUT(SC,DFN)
 I $P($G(^SC(SC,9999999)),U,5)="Y" S SDZEF=0
 I $P($G(^SC(SC,9999999)),U,3)="Y" S SDZMP=0
 I $P($G(^SC(SC,9999999)),U,4)="Y" S SDZAI=0
 Q
 ;
HS ; -- prints HS and other forms if set to YES for clinic
 NEW SC,DFN
 S SC=SDZSC,DFN=SDZDFN
 I $P($G(^SC(SC,9999999)),U,1)'="Y" Q
 S (SDZEF,SDZHS,SDZMP,SDZAI)=1 D FORMS1
 I (SDZEF=1),(+SDZHS=1),(SDZMP=1),(SDZAI=1) Q
 I $$DFWI="" D  Q:POP
 . W !!,"Ready to print Health Summary now . . "
 . S %ZIS="" D ^%ZIS
 S ZTIO=$S($$DFWI]"":$$DFWI,1:ION)
 S ZTRTN="HS1^ASDI",ZTDESC="HS & OTHER FORMS",ZTDTH=$H
 F I="DFN","SDZEF","SDZHS","SDZMP","SDZAI","SDZSC","SDPR" S ZTSAVE(I)=""
 D ^%ZTLOAD K ZTSK D HOME^%ZIS Q
 ;
HS1 ;EP; called by ZTLOAD to print forms
 U IO
 I SDZEF=0 D EF^ASDFORM(SDZSC,DFN,SDPR)
 I +SDZHS=0 D HS^ASDFORM(DFN,$P(SDZHS,U,2))
 I SDZMP=0 D MP^ASDFORM(DFN)
 I SDZAI=0 D AIU^ASDFORM(DFN)
 D ^%ZISC
 Q
 ;
DFWI() ; -- returns default health summary printer
 Q $$VAL^XBDIQ1(40.8,$$DIV^ASDUT,9999999.06)
 ;
CHECKIN() ; -- returns check-in time
 NEW X,Y,QUIT,CLN
 S CLN=$$CLN
 S X=0 F  S X=$O(^SC(CLN,"S",ASDS,1,X)) Q:'X!($D(QUIT))  D
 . Q:$P(^SC(CLN,"S",ASDS,1,X,0),U)'=DFN
 . S Y=$G(^SC(CLN,"S",ASDS,1,X,"C")) I Y]"" S QUIT=""
 Q $G(Y)
 ;
SCX() ; -- returns multiple ien for patient in ^sc
 NEW X
 S X=0
 F  S X=$O(^SC(I(SDPR),"S",SDPR,1,X)) Q:'X  Q:(+^(X,0)=DFN)
 Q X
 ;
CLN() ; -- returns clinic ien
 Q $P(^DPT(DFN,"S",ASDS,0),U)
 ;
