ASDM ; IHS/ADC/PDW/ENM - IHS CHANGES TO MAKE APPT ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
PAT ;EP; called by SDM to ask patient
 Q:$D(ORACTION)  S DFN="" K DIV
 Q:$G(SDPEP)
 S DIC="^DPT(",DIC(0)="AQZME" D ^DIC K DIC Q:X=""  Q:X=U  G PAT:Y<1
 S DFN=+Y
 W !?5,$$FIELDNM(9000001,.14),": ",$$PCP^ASDUT(DFN)
 D ^ASDREG
 Q
 ;
SPEC ;EP; called by SDM1 to print special instructions
 NEW I,IORVON,IORVOFF
 S X="IORVON;IORVOFF" D ENDR^%ZISS
 I $D(^SC(SC,"SI")),$O(^("SI",0)) D
 . W !,*7,?20,IORVON,"**** SPECIAL INSTRUCTIONS ****",IORVOFF,!
 . S I=0 F  S I=$O(^SC(SC,"SI",I)) Q:'I  W IORVON,^(I,0),IORVOFF,!
 Q
 ;
RS ;EP; -- routing slip
 NEW %
 Q:$P($G(^DG(40.8,$$DIV^ASDUT,"IHS")),U)'=1
 S %=2 W !,"WANT TO PRINT AN APPOINTMENT SLIP NOW"
 D YN^DICN I '% W !,"RESPOND YES OR NO" G RS
 I (%-1) W:%<0 " NO" Q
 S DIV="" D DIV^SDUTL I $T D ROUT^SDDIV Q:Y<0
 K IOP S (SDX,SDSTART,ORDER,SDREP,SDZMK)="",(SDZHS,SDZEF,SDZAI,SDZMP)=1
 D EN^SDROUT1
 K SDZHS,SDZEF,SDZAI,SDZMP,SDZMK
 Q
 ;
HS ; -- health summary
 ; -- calling rtn can send % set to default answer
 S SDZHS="" W !,"WANT TO PRINT HEALTH SUMMARY NOW" D YN^DICN
 I '% W !,"RESPOND YES OR NO" G HS
 I (%-1) W:%<0 " NO" S SDZHS=1 Q
 S SDZHS=0
 Q
 ;
PEND ;PEP; called by SDM & AMER1 to display pending appts
 W:$O(^DPT(DFN,"S",DT))'>DT !,"NO PENDING APPOINTMENTS"
 I $O(^DPT(DFN,"S",DT))>DT D
 . S X="Y" W !!?20,"**** PENDING APPOINTMENTS ****",!
 I  F Y=DT:0 S Y=$O(^DPT(DFN,"S",Y)) Q:Y'>0  D
 . I "I"[$P(^DPT(DFN,"S",Y,0),U,2) D
 .. D CHKSO^SDM W:$X>9 ! W ?11 D DT^SDM0 W ?32 S DA=+SSC
 .. W SDLN,$S($D(^SC(DA,0)):$P(^(0),U),1:"DELETED CLINIC ")
 D WARD,NOSHOW Q
 ;
WARD ;EP; called if only inpat status needed
 S SDW=""
 I $D(^DPT(DFN,.1)) S SDW=^(.1) D
 . W !!?10,*7,"*** NOTE - PATIENT IS NOW IN "_SDW_" WARD ***",!
 Q
 ;
NOSHOW ; -- called to print # noshows for patient
 NEW SDATE,SDATE2,X1,X2,X,TOTL,NOCLN,LMT,LMT2,SDPC,PCNT
 Q:'$G(DFN)  Q:'$G(SC)
 S SDPC=$P($G(^SC(+SC,"SL")),U,5) ;princ clinic
 S (TOTL,NOCLN,PCNT)=0
 S LMT=$$VAL^XBDIQ1(40.8,$$DIV^ASDUT,9999999.15)
 S LMT2=$$VAL^XBDIQ1(44,+SC,9999999.6),LMT2=$S(LMT2="":LMT,1:LMT2)
 S X1=DT,X2=-$S(LMT]"":LMT,1:365) D C^%DTC S SDATE=X
 S X1=DT,X2=-LMT2 D C^%DTC S SDATE2=X
 F  S SDATE=$O(^DPT(DFN,"S",SDATE)) Q:'SDATE  D
 . Q:$P(^DPT(DFN,"S",SDATE,0),U,2)'["N"  S TOTL=TOTL+1
 F  S SDATE2=$O(^DPT(DFN,"S",SDATE2)) Q:'SDATE2  D
 . Q:$P(^DPT(DFN,"S",SDATE2,0),U,2)'["N"
 . I +^DPT(DFN,"S",SDATE2,0)=+SC S NOCLN=NOCLN+1
 . I SDPC]"",$D(^SC("AIHSPC",+SDPC,+^DPT(DFN,"S",SDATE2,0))) S PCNT=PCNT+1
 I TOTL>0!(NOCLN>0)!(PCNT>0) D
 . W !!,"Total No-shows (ALL clinics) in last ",LMT\30," months:",?50,TOTL
 . I SDPC]"" W !,"No-shows in principal clinic (last ",LMT2\30," months):",?50,PCNT
 . W !,"No-shows in this clinic (last ",LMT2\30," months):",?50,NOCLN,!
 Q
 ;
EN2 ;EP; called by SDM
 NEW X,SDOK
 S X=0 F  S X=$O(^DPT(DFN,"DE",X)) Q:'X  Q:'$D(^(X,0))  D
 . I ^DPT(DFN,"DE",X,0)-SC=0!'(^(0)-Y) D
 .. S XX=0 F  S XX=$O(^DPT(DFN,"DE",X,1,XX)) Q:XX<1  Q:$D(SDOK)  D
 ... S SDDIS=$P(^DPT(DFN,"DE",X,1,XX,0),U,3) S:'SDDIS SDOK=""
 .. G ^SDM0:'SDDIS
 I '$D(^SC(+Y,0)) S Y=+SC
 S Y=$P(^SC(Y,0),U)
 S SDY=Y
 S X="NOW" S %DT="EXT" D ^%DT S HEY=Y
 S DA=DFN,DR="3///"_SDY,(DIE,DIC)="^DPT(",DP=2
 S DR(2,2.001)=".01///"_SDY_";1///"_HEY
 S DR(3,2.011)=".01///"_HEY_";S DIE(""NO^"")="""";1////O"
 L +^DPT(DFN,"DE"):3 I '$T D  Q
 . W !,*7,"PATIENT ENTRY LOCKED; TRY AGAIN SOON"
 D ^DIE K DR,DP L -^DPT(DFN,"DE")
 G ^SDM0:'$D(Y)
 Q
 ;
QUES1 ;EP; called by SDM1 for date/time help   
 W !?5,"Enter a DATE & TIME for the appointment (ex. 11/2@0930)"
 W !?5,"OR enter ""M"" to see the next month's availability"
 W !?5,"OR enter ""L"" to list appointments for a specific date"
 W !?5,"OR enter ""S"" to see a shortened list of appts for a date"
 W !?5,"OR enter ""B"" to backup to choose another starting date"
 W !?10,"and to see the patient's pending appointments again"
 W !?5,"OR press RETURN to choose another clinic.",!
 Q
 ;
OTHER ;EP -- other info; called by ^SDI
 W ! K DIE,DIC
 S DIE="^SC("_SC_",""S"","_SDPR_",1,",DA=I,DA(1)=SDPR,DA(2)=SC,DR="3T"
 I $D(SDZPL) S DR="3///^S X=SDZPL"
 L +^SC(SC,"S",SDPR):3 I '$T D  G OTHER
 . W !,*7,"APPOINTMENT ENTRY LOCKED; TRY AGAIN"
 D ^DIE L -^SC(SC,"S",SDPR) Q
 ;
LIST(SC,TYPE) ;EP -- list appointments; called by SDM1
 NEW A,ALL,DFN,DIC,I,INC,K,M,PCNT,POP,PT,SD,SD1,SDB,SDCC,SDCP,SDD
 NEW SDEM1,SDDIF,SDDIF1,SDEA,SDEC,SDEDT,SDEM,SDEND,SDFL,SDFS,SDIN
 NEW SDNT,SDOI,SDPD,SDREV,SDT,SDTT,SDX,SDXX,SDZ,VADAT,VADATE,VAUTC
 NEW VAUTD,VAQK,X,Y,Y1,Y2,Z
 S VAUTC=0,VAUTD=0,VAUTC($P(^SC(SC,0),U))=SC,M=1
 S VAUTD(+$O(^DG(40.8,"C",DUZ(2),0)))=$P(^DG(40.8,$O(^(0)),0),U)
 K DIC("S") S %DT("A")="LIST APPOINTMENTS FOR WHICH DATE: ",%DT="AEXF"
 D ^%DT K %DT,% I (X["^")!(Y<0) Q
 I TYPE=1 S SDD=Y D START^SDAL Q
 I TYPE=2 D SHORT^ASDAL(SC,Y) Q
 ;
FIELDNM(F,N) ; -- returns field name from file
 Q $P($G(^DD(F,N,0)),U)
