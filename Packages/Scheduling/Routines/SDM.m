SDM ;SF/GFT,ALB/BOK - MAKE AN APPOINTMENT ; 08 Nov 2000  2:26 PM
 ;;5.3;Scheduling;**15,32,38,41,44,79,94,167,168,218,223,250,254,296,1005**;AUG 13, 1993
 ;                                           If defined...
 ; appt mgt vars:  SDFN := DFN of patient....will not be asked
 ;                SDCLN := ifn of clinic.....will not be asked    
 ;              SDAMERR := returned if error occurs
 ;IHS/ANMC/LJF  6/29/2000 removed display of enrollment status
 ;                        added prin clinic availability display
 ;              7/05/2000 bypassed pend appt display, race question
 ;                        and address update; added noshow display
 ;              8/18/2000 added DIC("W") to warn if clinic inactivated
 ;              9/29/2000 added call to select by provider, PCP or PCT
 ;             10/18/2000 added check:user have access to princ clinic?
 ;IHS/OIT/LJF 12/30/2005 PATCH 1005 added call to display pending appts when in clinic mode
 ; 
 S:'$D(SDMM) SDMM=0
EN1 ;L  W !! D I^SDUTL I '$D(SDCLN) S DIC="^SC(",DIC(0)="AEMZQ",DIC("A")="Select CLINIC: ",DIC("S")="I $P(^(0),U,3)=""C"",'$G(^(""OOS""))" D ^DIC K DIC G:Y<0!'$D(^("SL")) END    ;IHS/ANMC/LJF 8/18/2000
 L  W !! D I^SDUTL I '$D(SDCLN) S DIC="^SC(",DIC(0)="AEMZQ",DIC("A")="Select CLINIC: ",DIC("S")="I $P(^(0),U,3)=""C"",'$G(^(""OOS""))",DIC("W")=$$INACTMSG^BSDU D ^DIC K DIC   ;IHS/ANMC/LJF 8/18/2000
 I '$D(SDCLN),Y<0 NEW BSDQUIT D ^BSDPRV S X=$S($G(BSDQUIT):"END",1:"EN1") D @X Q  ;IHS/ANMC/LJF 9/29/2000 provider or PCP
 I '$D(SDCLN),$D(^SC("AIHSPC",+Y)) S SDPC=+Y D EN^BSDPC K SDPC G EN1  ;IHS/ANMC/LJF 6/29/2000  principal clinic
 I '$D(SDCLN),'$D(^SC(+Y,"SL")) G END  ;IHS/ANMC/LJF 6/29/2000 rest of original line
 ;
 K SDAPTYP,SDIN,SDRE,SDXXX S:$D(SDCLN) Y=+SDCLN
 I $D(^SC(+Y,"I")) S SDIN=+^("I"),SDRE=+$P(^("I"),U,2)
 K SDINA I $D(SDIN),SDIN S SDINA=SDIN K SDIN
 I $D(SD),$D(SC),+Y'=+SC K SD
 S SL=$G(^SC(+Y,"SL")),X=$P(SL,U,3),STARTDAY=$S($L(X):X,1:8),SC=Y,SB=STARTDAY-1/100,X=$P(SL,U,6),HSI=$S(X=1:X,X:X,1:4),SI=$S(X="":4,X<3:4,X:X,1:4),STR="#@!$* XXWVUTSRQPONMLKJIHGFEDCBA0123456789jklmnopqrstuvwxyz",SDDIF=$S(HSI<3:8/HSI,1:2) K Y
 ;
 ;IHS/ANMC/LJF 10/18/2000
 ;I $D(^SC(+SC,"SDPROT")),$P(^("SDPROT"),U)="Y",'$D(^SC(+SC,"SDPRIV",DUZ)) W !,*7,"Access to ",$$CNAM(+SC)," is prohibited!",!,"Only users with a special code may access this clinic.",*7 S:$D(SDCLN) SDAMERR="" G END:$D(SDCLN),SDM
 I $D(^SC(+SC,"SDPROT")),$P(^("SDPROT"),U)="Y",'$D(^SC(+SC,"SDPRIV",DUZ)),'$D(^SC($$PC^BSDU(+SC),"SDPRIV",DUZ)) D  G END:$D(SDCLN),SDM
 . W !,*7,"Access to ",$$CNAM(+SC)," is prohibited!",!,"Only users with a special code may access this clinic.",*7 S:$D(SDCLN) SDAMERR=""
 ;
 D CS^SDM1A S SDW="",WY="Y"
 ;
 ;IHS/OIT/LJF 12/30/2005 PATCH 1005 added call to display pending appts
 ;I '$D(ORACTION),'$D(SDFN) S (DIC,DIE)="^DPT(",DIC(0)="AQZME" D ^DIC S DFN=+Y G:Y<0 END:$D(SDCLN),^SDM0:X[U,SDM
 I '$D(ORACTION),'$D(SDFN) S (DIC,DIE)="^DPT(",DIC(0)="AQZME" D ^DIC S DFN=+Y G:Y<0 END:$D(SDCLN),^SDM0:X[U,SDM D PTAPPT^BSDAM(DFN)
 ;
 S:$D(SDFN) DFN=SDFN
 I $D(^DPT(DFN,.35)),$P(^(.35),U)]"" W !?10,*7,"PATIENT HAS DIED." S:$D(SDFN) SDAMERR="" G END:$D(SDFN),SDM
 D ^SDM4 I $S('$D(COLLAT):1,COLLAT=7:1,1:0) G:$D(SDCLN) END G SDM
 ;-- get sub-category for appointment type
 S SDXSCAT=$$SUB^DGSAUTL(SDAPTYP,2,"")
 K SDXXX D EN G END:$D(SDCLN),SDM
EN K SDMLT1 W:$P(VAEL(9),U,2)]"" !!,?15,"MEANS TEST STATUS: ",$P(VAEL(9),U,2),!
 ; *** sck, mt blocking removed
 ;S X="EASMTCHK" X ^%ZOSF("TEST") I $T,$$MT^EASMTCHK(DFN,+$G(SDAPTYP),"M") S SDAMERR="" Q
 S Y=DFN,Y(0)=^DPT(DFN,0) I VADM(7)]"" W !?3,*7,VADM(7)
 ;
 Q:$D(SDXXX)  D NOSHOW^BSDU2(DFN,+SC) G E  ;IHS/ANMC/LJF 7/05/2000 no-show display; bypass pending appt & race
 ;
 I $D(^DGS(41.1,"B",DFN)) F I=0:0 S I=$O(^DGS(41.1,"B",DFN,I)) Q:I'>0  I $P(^DGS(41.1,I,0),U,2)'<DT&('$P(^DGS(41.1,I,0),U,13)) W !,"SCHEDULED FOR ADMISSION ON " S Y=$P(^(0),U,2) D DT^SDM0
PEND S %="" W:$O(^DPT(DFN,"S",DT))'>DT !,"NO PENDING APPOINTMENTS"
 I $O(^DPT(DFN,"S",DT))>DT D  G END:%<0,HELP:'%
 .S %=2 W !,"DISPLAY PENDING APPOINTMENTS:"
 .D YN^DICN
 .I %Y["^" S SDMLT1=1
 D:%=1
 .N DX,DY,SDXY,SDEND S SDXY="S DX=$X,DY=0"_$S($L($G(^%ZOSF("XY"))):" "_^("XY"),1:"") X SDXY
 .F Y=DT:0 S Y=$O(^DPT(DFN,"S",Y)) Q:Y'>0  I "I"[$P(^(Y,0),U,2) X:(($Y+4)>IOSL) "D OUT^SDUTL X SDXY" Q:$G(SDEND)  D CHKSO W:$X>9 ! W ?11 D DT^SDM0 W ?32 S DA=+SSC W SDLN,$S($D(^SC(DA,0)):$P(^(0),U),1:"DELETED CLINIC "),COV,"  ",SDAT16
 ;Prompt for ETHNICITY if no value on file
 I '$O(^DPT(DFN,.06,0)) D
 .S DA=DFN,DR="6ETHNICITY",DIE="^DPT("
 .S DR(2,2.06)=".01ETHNICITY"
 .D ^DIE K DR
 ;Prompt for RACE if no value on file
 I '$O(^DPT(DFN,.02,0)) D
 .S DA=DFN,DR="2RACE",DIE="^DPT("
 .S DR(2,2.02)=".01RACE"
 .D ^DIE K DR
 S DA=DFN,DR=$S('$D(^DPT(DA,.11)):"[SDM1]",$P(^(.11),U)="":"[SDM1]",1:"")
 S DIE="^DPT(" D ^DIE:DR]"" K DR Q:$D(SDXXX)
E S Y=$P(SL,U,5)
 S SDW="" I $D(^DPT(DFN,.1)) S SDW=^(.1) W !,"NOTE - PATIENT IS NOW IN WARD "_SDW
 Q:$D(SDXXX)
EN2 F X=0:0 S X=$O(^DPT(DFN,"DE",X)) Q:'$D(^(+X,0))  I ^(0)-SC=0!'(^(0)-Y) F XX=0:0 S XX=$O(^DPT(DFN,"DE",X,1,XX)) Q:XX<1  S SDDIS=$P(^(XX,0),U,3) G ^SDM0:'SDDIS
 I '$D(^SC(+Y,0)) S Y=+SC
 S Y=$P(^SC(Y,0),U)
 ; SCRESTA = Array of pt's teams causing restricted consults
 N SCRESTA
 S SCREST=$$RESTPT^SCAPMCU4(DFN,DT,"SCRESTA")
 IF SCREST D
 .N SCTM
 . S SCCLNM=Y
 . W !,?5,"Patient has restricted consults due to team assignment(s):"
 .S SCTM=0
 .F  S SCTM=$O(SCRESTA(SCTM)) Q:'SCTM  W !,?10,SCRESTA(SCTM)
 IF SCREST&'$G(SCOKCONS) D  Q
 .W !,?5,"This patient may only be given appointments and enrolled in clinics via"
 .W !,?15,"Make Consult Appointment Option, and"
 .W !,?15,"Edit Clinic Enrollment Data option"
 D:$G(SCREST) MAIL^SCMCCON(DFN,.SCCLNM,2,DT,"SCRESTA")
 K DR,SCREST,SCCLNM
 G ^SDM0
 ;
CHKSO S COV=$S($P(^DPT(DFN,"S",Y,0),U,11)=1:" (COLLATERAL)",1:""),HY=Y,SSC=^(0),SDAT16=$S($D(^SD(409.1,+$P(SSC,U,16),0)):$P(^(0),U),1:"")
 F SDJ=3,4,5 I $P(^DPT(DFN,"S",HY,0),U,SDJ)]"" S Y=$P(^(0),U,SDJ) W:$X>9 ! W ?10,"*" D DT^SDM0 W ?32,$S(SDJ=3:"LAB",SDJ=4:"XRAY",1:"EKG")
 S SDLN="" F J=0:0 S J=$O(^SC(+SSC,"S",HY,1,J)) Q:'J  I $D(^(J,0)),+^(0)=DFN S SDLN="("_$P(^(0),U,2)_" MINUTES) " Q
 S Y=HY Q
 ;
END D KVAR^VADPT K SDAPTYP,SDSC,%,%DT,ASKC,COV,DA,DIC,DIE,DP,DR,HEY,HSI,HY,J,SB,SC,SDDIF,SDJ,SDLN,SD17,SDMAX,SDU,SDYC,SI,SL,SSC,STARTDAY,STR
 K WY,X,XX,Y,S,SD,SDAP16,SDEDT,SDTY,SM,SS,ST,ARG,CCX,CCXN,HX,I,PXR,SDINA,SDW,COLLAT,SDDIS I $D(SDMM) K:'SDMM SDMM
 I '$D(SDMLT) K SDMLT1
 Q
 ;
OERR S XQORQUIT=1 Q:'$D(ORVP)  S DFN=+ORVP G SDM
 ;
HELP W !,"YES - TO DISPLAY FUTURE APPOINTMENTS",!,"NO - FUTURE APPOINTMENTS NOT DISPLAYED" G PEND
 ;
CNAM(SDCL) ;Return clinic name
 ;Input: SDCL=clinic ien
 N SDX
 S SDX=$P($G(^SC(+SDCL,0)),U)
 Q $S($L(SDX):SDX,1:"this clinic")
