BCHEGR ; IHS/CMI/LAB - GROUP ENTRY 08 Nov 2011 3:34 PM ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
 ;
 ;
START ;
 W:$D(IOF) @IOF
 D DONE
 ;
DATES ;
 W !!,"You will be presented with a list of group definitions for the"
 W !,"CHR you select for the date range you select.  You will then"
 W !,"be able to select one of the group definitions which will be "
 W !,"duplicated and used as a template for the group data you are "
 W !,"about to enter.",!
 S BCHPROV=""
 D GETPROV^BCHUAR
 I 'BCHPROV D DONE Q
 K BCHRED,BCHRBD
 W !,"Please enter the date range for displaying Group definitions."
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date"
 D ^DIR Q:Y<1  S BCHRBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date"
 D ^DIR Q:Y<1  S BCHRED=Y
 ;
 I BCHRED<BCHRBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
 ;
 D EN,FULL^VALM1
 D DONE
 Q
DONE ;
 D EN^XBVK("BCH")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
EN ;
 K ^TMP($J,"BCHEGR")
 D GATHER
 D EN^VALM("BCH GROUP ENTRY")
 D CLEAR^VALM1
 Q
GATHER ;
 D GATHER^BCHEGR1
 Q
CTR(X,Y) ;EP - Center
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
HDR ; -- header code
 S VALMHDR(1)="Group Entry"
 S X="",$E(X,7)="Date",$E(X,16)="Group Name",$E(X,37)="CHR",$E(X,54)="# SERVED",$E(X,63)="ASSESSMENTS"
 S VALMHDR(2)=X
 Q
 ;
INIT ;
 D GATHER
 S VALMCNT=BCHLINE
 Q
 ;lori edit
HELP ;
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXPND ; -- expand code
 Q
EDITDEF ;
 D FULL^VALM1
 W !!,"This action should be used to edit a group definition only.  If visits have"
 W !,"already been entered for this group, you will not be able to edit the group"
 W !,"definition.",!
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT Q
 S BCHNG=0 S BCHNG=^TMP($J,"BCHEGR","IDX",R,R)
 I '$D(^BCHGRPD(BCHNG,0)) W !,"Not a valid GROUP." K BCHNG,R,BCHG,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 I $O(^BCHGRPD(BCHNG,61,0)) W !!,"This group already has visits created.  You must use the REVIEW/EDIT",!,"GROUP VISITS to modify visits within this group." D PAUSE,EXIT Q
 I $P(^BCHGRPD(BCHNG,0),U,18) W !!,"This Group's Notes have been signed.  You cannot edit the Group.",! D PAUSE,EXIT Q
 S BCHDATE=$P($P(^BCHGRPD(BCHNG,0),U),".")
 D EDITGRP
 Q
ADDGRP ;
 D FULL^VALM1
 ;add new group 
 K DIR S DIR(0)="D^:"_DT_":EP",DIR("A")="Enter Date of the Group Activity" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"date not entered." D PAUSE,EXIT Q
 S BCHDATE=Y
 S X=BCHDATE,DIC="^BCHGRPD(",DLAYGO=90002.67,DIADD=1,DIC(0)="L",DIC("DR")=".07////"_BCHPROV_";.04////"_DT_";.12////"_DUZ K DD,DO D FILE^DICN
 I Y=-1 W !!,"entry of new group failed." K DIADD,DLAYGO D ^XBFMK D EXIT Q
 S BCHNG=+Y
 K DIADD,DLAYGO D ^XBFMK
EDITGRP ;EP
 S APCDOVRR=1
 S DA=BCHNG,DDSFILE=90002.67,DR="[BCH EDIT GROUP DEFINITION]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG D PAUSE,EXIT Q
 ;must have a pov/provider
 S E=0
 I $P(^BCHGRPD(BCHNG,0),U,7)="" W !!,"Group must have CHR defined." S E=1
 NEW X,G,C
 I '$O(^BCHGRPDA("AD",BCHNG,0)) W !!,"Group must have at least one POV defined." S E=1
 I E S BCHE="" D  G:BCHE="E" EDITGRP D:BCHE="Q" PAUSE,EXIT Q:BCHE="Q"  W !!,"deleting group definition." S DA=BCHNG,DIK="^BCHGRPD(" D ^DIK D PAUSE,EXIT Q
 .S DIR(0)="S^E:Edit the Group definition;D:Delete this Group definition;Q:to exit and edit it later without deleting the group definition",DIR("A")="This group definition is not complete, do you wish to",DIR("B")="E" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) Q
 .S BCHE=Y
 .Q
 ;now loop and get patients for the group
 D ^XBFMK
 W !!,"You have added the following group definition, please review it carefully",!,"before you proceed to add/update the patients in the group.",!
 D DISP2^BCHEGR1
 S DIR(0)="S^Y:Yes-group definition is accurate-continue to Patient List;N:No, I wish to edit the group definition;Q:I wish to QUIT and exit",DIR("A")="Do you wish to continue on to add patient visits for this group"
 S DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE,EXIT Q
 I Y="Q" D DELGRP,PAUSE,EXIT Q
 I Y="N" G EDITGRP
SENS ;check for sensitive patients
 K BCHPAT
 W !!!
 W !,"You will be prompted to confirm the list of patients who were in the"
 W !,$$VAL^XBDIQ1(90002.67,BCHNG,.03)," group on ",$$VAL^XBDIQ1(90002.67,BCHNG,.01),".",!
 S BCHQ=""
 D GETPATS
 I BCHQ Q
 D ADDREC
 D EXIT
 Q
DUP ;EP -
 D DUP^BCHEGR1
 Q
DISP ;EP - called from protocol
 D DISP^BCHEGR1
 Q
PRTEF ;EP
 D PRTEF^BCHEGR1
 Q
DELGRP ;EP - called from protocol
 NEW BCHX
 S BCHX=0 F  S BCHX=$O(^BCHGRPDA("AD",BCHNG,BCHX)) Q:BCHX'=+BCHX  S DA=BCHX,DIK="^BCHGRPDA(" D ^DIK
 S DA=BCHNG,DIK="^BCHGRPD(" D ^DIK
 Q
ADDREC ;EP
 D FULL^VALM1
 K DIR
 W !!,"Adding records for each individual patient in this group.",!
 S BCHNUM=$P(^BCHGRPD(BCHNG,0),U,9)  ; # SERVED
 K BCHDELQ S BCHNGX=0,BCHHIT=0 F  S BCHNGX=$O(^BCHGRPD(BCHNG,51,BCHNGX)) Q:BCHNGX'=+BCHNGX!($G(BCHDELQ))  D ADDREC1
 K X1
SIGN1 D PAUSE,EXIT
 Q
ADDREC1 ;EP
 S BCHHIT=BCHHIT+1
 S (DFN,BCHNRPAT)=""
 S X=$P(^BCHGRPD(BCHNG,51,BCHNGX,0),U)
 I X["AUPNPAT" S DFN=+X
 I X["BCHRPAT" S BCHNRPAT=+X
ADDREC2 ;
 S BCHG0=^BCHGRPD(BCHNG,0)
 S APCDOVRR=1,BCHOVRR=1
 S BCHEV("TYPE")="A"
 D ^XBFMK
 W !!,"Creating new record for ",$S(DFN:$P(^DPT(DFN,0),U),1:$P(^BCHRPAT(BCHNRPAT,0),U,1)),"."
 ;I 'DFN W !!,"Creating CHR record."
 K DD,D0,DO,DIC,DA,DR S DIC(0)="EL",DIC="^BCHR(",DLAYGO=90002,DIADD=1,X=$P(^BCHGRPD(BCHNG,0),U,1)
 S DIC("DR")=".02////"_$P(BCHG0,U,2)_";.03////"_$P(BCHG0,U,7)_";.04////"_$G(DFN)_";1112///"_$G(BCHNRPAT)_";.05////"_$P(BCHG0,U,10)_";.06////"_$P(BCHG0,U,5)_";.12///1"
 S DIC("DR")=DIC("DR")_";.16////"_DUZ_";.17////"_DT_";.22////"_DT_";.26////H;.29///1"
 S DIC("DR")=DIC("DR")_";.11////"_$S(BCHHIT=1:$P(BCHG0,U,8),1:0) ;IHS/CMI/TMJ PATCH #16 Travel time to one patient
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"ERROR generating CHR record!!  Deleting Record.",! D ^XBFMK Q
 S BCHR=+Y
POV ;create pov records
 S BCHOVRR=1
 S BCHX=0 F  S BCHX=$O(^BCHGRPDA("AD",BCHNG,BCHX)) Q:BCHX'=+BCHX  D
 .S BCHG0=^BCHGRPDA(BCHX,0)
 .D ^XBFMK
 .S BCHPOVM=$P(BCHG0,U,5)/BCHNUM S BCHPOVM=(BCHPOVM+.5)\1
 .K DD,D0,DO,DIC,DA,DR S DIC="^BCHRPROB(",DIC(0)="EL",DLAYGO=90002.01,DIADD=1,X=$P(BCHG0,U)
 .S DIC("DR")=".02////"_$G(DFN)_";.03////"_BCHR_";.04////"_$P(BCHG0,U,4)_";.05///"_BCHPOVM_";.06////"_$P(BCHG0,U,6)
 .D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,DO
 .I Y<0 W !!,"Creating pov record failed.!!  Notify PROGRAMMER!",!!
 D ^XBFMK
 D GETMEAS
EDITR ;
 S DIR(0)="Y",DIR("A")="Do you wish to edit anything in this record",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y D EDIT
 ;DO PCC LINK
 ;D PROTOCOL^BCHUADD1
 S BCHHIT=BCHHIT+1
 ;update 2101 multiple
 D ^XBFMK K DIADD,DLAYGO
 S DIC="^BCHGRPD("_BCHNG_",61,",DIC(0)="L",DIC("P")=$P(^DD(90002.67,6101,0),U,2),DA(1)=BCHNG,X="`"_BCHR D ^DIC
 I Y=-1 W !!,"adding visit to group file entry failed.  Notify supervisor." H 2
 D ^XBFMK K DIADD,DLAYGO
 Q
GETMEAS ;
 I '$G(DFN),'$G(^BCHR(BCHR,11))="" Q  ;no patient so no measurements
 W !
 S DIR(0)="Y",DIR("A")=$S('$G(BCHUABFO):"Any MEASUREMENTS, TESTS or REPRODUCTIVE FACTORS",1:"Any MEASUREMENTS/TESTS"),DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 S DA=BCHR,DDSFILE=90002,DR="[BCH ENTER MEASUREMENTS/TESTS" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG D ^XBFMK Q
 D ^XBFMK
 Q
EDIT ;
 W !
 S DA=BCHR,DDSFILE=90002,DR="[BCH EDIT RECORD DATA]" D ^DDS
 K DR,DA,DDSFILE,DIC,DIE
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG Q
 S BCHPAT=$P(^BCHR(BCHR,0),U,4)
 Q:BCHPAT=""
 ;backfill pt ptr in CHR POV
 S BCHX=0 F  S BCHX=$O(^BCHRPROB("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 .S DIE="^BCHRPROB(",DA=BCHX,DR=".02////"_BCHPAT,DITC=""
 .D ^DIE
 .K DIE,DA,DR,DIU,DIV,DIW,DIY,DITC
 .I $D(Y) W !,"error updating pov's with patient, NOTIFY PROGRAMMER" H 5
 .Q
 ;backfill pt ptr in CHR EDUC
 ;S BCHX=0 F  S BCHX=$O(^BCHRPED("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 ;.S DIE="^BCHRPED(",DA=BCHX,DR=".02////"_BCHPAT,DITC=""
 ;.D ^DIE
 ;.K DIE,DA,DR,DIU,DIV,DIW,DIY,DITC
 ;.I $D(Y) W !,"error updating educ's with patient, NOTIFY PROGRAMMER" H 5
 ;.Q
 Q
EXIT ;EP - clean up and exit
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER
 S VALMCNT=BCHLINE
 D HDR
EOJ ;
 K BCHV,BCHF,BCHDR,DFN,BCHR,BCHQUIT,BCHRDEL,BCHV,BCHVDLT,BCHNAME,BCHPTSV,BCHX,DFN,BCHERROR,BCHR0,BCHPNP,BCHGRPX
 K BCHC,BCHD,BCHDONE,BCHEV,BCHG,BCHG0,BCHLINE,BCHN,BCHNG,BCHNGX,BCHMUM,BCHNRPAT,BCMP,BCHPATS,BCHPOVM,BCHPROB,BCHQ,BCHR,BCHX,BCHY
 K DFN
 D DIRX^BCHUADD
 K DIC,DR,DA,X,Y,DIU,DIU,D0,DO,DI
 K BCHHIT,BCHX
 K DIR,X,Y,DIC,DR,DA,D0,DO,DIZ,D
 Q
PAUSE ;
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
DEL ;
 S DIK="^BCHR(",DA=BCHR D ^DIK K DA,DIK
 W !,"Record deleted."
 D PAUSE
 Q
GETPATS ;
 K BCHPATS
 S X=0 F  S X=$O(^BCHGRPD(BCHNG,51,X)) Q:X'=+X  S BCHPATS($P(^BCHGRPD(BCHNG,51,X,0),U,1))=""
GETPATSA ;
 I '$D(BCHPATS) G GETPATS1
 W !!,"The following patients are currently assigned to this group:"
 S BCHP=0,BCHC=0 F  S BCHP=$O(BCHPATS(BCHP)) Q:BCHP=""  D
 .S BCHC=BCHC+1
 .W !?2,BCHC,")  ",$$VAL^XBDIQ1($S(BCHP["AUPNPAT":2,1:90002.11),$P(BCHP,";",1),.01)
GETPATS1 ;
 D EN^DDIOL("","","!!")
 K DIR
 S DIR(0)="S^A:Add a Patient to the Group;D:Delete a Patient from the Group;F:Finished Entering Patients for this Group"
 S DIR("A")="Which action",DIR("B")="" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GETPATSE
 I Y="F" S BCHDONE=1 G GETPATSE
 S Y="FM"_Y
 D @Y
 G GETPATSA
GETPATSE ;
 S X=0,Y="",C=0
 F  S X=$O(BCHPATS(X)) Q:X=""  D
 .S C=C+1
 W !,"You entered ",C," Patient Names.  Is this the total number of patients"
 S DIR(0)="Y",DIR("A")="that were in the group",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 S BCHY=Y
 I $D(DIRUT) S BCHQ="" D  D:BCHQ DELGRP G:BCHQ EXIT  G GETPATSE
 .W !!,"You ""^""'ed out."
 .S DIR(0)="S^D:DELETE the entire Group Definition and Quit;G:Go back to entering Patients",DIR("A")="What do you wish to do",DIR("B")="D" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BCHQ=1 Q
 .I Y="D" S BCHQ=1 Q
 I 'Y G GETPATSA
 D SET51
 Q
FMD ;
 ;pick one here
 W !!,"The following patients are currently assigned to this group:"
 S BCHP=0,BCHC=0 F  S BCHP=$O(BCHPATS(BCHP)) Q:BCHP=""  D
 .S BCHC=BCHC+1
 .W !?2,BCHC,")  ",$$VAL^XBDIQ1($S(BCHP["AUPNPAT":2,1:90002.11),$P(BCHP,";",1),.01)
 S DIR(0)="N^1:"_BCHC_":",DIR("A")="Which one do you want delete from the group" D ^DIR KILL DIR,DA
 I $D(DIRUT) Q
 I 'Y Q
 S X="",C=0 F  S X=$O(BCHPATS(X)) Q:X=""  S C=C+1 I Y=C K BCHPATS(X)
 Q
FMA ;
 D GETPAT^BCHEGR2
 I BCHPT S BCHPATS(BCHPT_";"_$S(BCHPTT="R":"AUPNPAT(",1:"BCHRPAT("))="" Q
 Q
SET51 ;
 K ^BCHGRPD(BCHNG,51)
 S X="",C=0 F  S X=$O(BCHPATS(X)) Q:X=""  S C=C+1,^BCHGRPD(BCHNG,51,C,0)=X,^BCHGRPD(BCHNG,51,"B",X,C)=""
 S ^BCHGRPD(BCHNG,51,0)="^90002.6751AV^"_C_"^"_C
 S DA=BCHNG,DIE="^BCHGRPD(",DR=".09///"_C D ^DIE K DIE,DR,DA
 Q
