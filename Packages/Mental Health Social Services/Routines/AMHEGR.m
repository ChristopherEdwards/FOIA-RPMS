AMHEGR ; IHS/CMI/LAB - GROUP ENTRY ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
START ;
 W:$D(IOF) @IOF
 D DONE
 ;
DATES ;
 K AMHRED,AMHRBD
 W !,"Please enter the date range for displaying Group definitions."
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date"
 D ^DIR Q:Y<1  S AMHRBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date"
 D ^DIR Q:Y<1  S AMHRED=Y
 ;
 I AMHRED<AMHRBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
 D EN,FULL^VALM1
 D DONE
 Q
DONE ;
 D EN^XBVK("AMH")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
EN ;
 K ^TMP($J,"AMHEGR")
 D ^AMHLEIN
 D GATHER
 D EN^VALM("AMH GROUP ENTRY")
 D CLEAR^VALM1
 Q
GATHER ;
 D GATHER^AMHEGR1
 Q
CTR(X,Y) ;EP - Center
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
HDR ; -- header code
 S VALMHDR(1)="Group Entry             * - Unsigned Group Note"
 S X="",$E(X,7)="Date",$E(X,16)="Group Name",$E(X,37)="Activity",$E(X,48)="Prg",$E(X,52)="Cln",$E(X,59)="Prov",$E(X,69)="TOC",$E(X,73)="POV"
 S VALMHDR(2)=X
 Q
 ;
INIT ;
 D GATHER
 S VALMCNT=AMHLINE
 Q
 ;
HELP ;
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXPND ; -- expand code
 Q
REV ;
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT Q
 S AMHNG=0 S AMHNG=^TMP($J,"AMHEGR","IDX",R,R)
 I '$D(^AMHGROUP(AMHNG,0)) W !,"Not a valid GROUP." K AMHNG,R,AMHG,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 I $P(^AMHGROUP(AMHNG,0),U,18) W !!,"The notes associated with this group entry have been signed. ",!,"You can edit other items in this entry but not the notes." D PAUSE
 NEW P,X,G,A,R
 K A
 S P=0 F  S P=$O(^AMHGROUP(AMHNG,61,P)) Q:P'=+P  S R=$P(^AMHGROUP(AMHNG,61,P,0),U,1) S X=$P($G(^AMHREC(R,0)),U,8) S A(X)=""
 S P=0,G=0 F  S P=$O(^AMHGROUP(AMHNG,51,P)) Q:P'=+P  S X=$P(^AMHGROUP(AMHNG,51,P,0),U) D
 .I '$D(A(X)) S G=1
 I G W !!,"All of the visits have not been entered for this group.  Use Sign Note or ","Edit Group Definition to add visits.",! D PAUSE,EXIT Q
 D ^AMHEGS
 D EXIT
 Q
EDITDEF ;
 D FULL^VALM1
 W !!,"This action should be used to edit a group definition only.  If visits have"
 W !,"already been entered for this group, you will not be able to edit the group"
 W !,"definition.",!
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT Q
 S AMHNG=0 S AMHNG=^TMP($J,"AMHEGR","IDX",R,R)
 I '$D(^AMHGROUP(AMHNG,0)) W !,"Not a valid GROUP." K AMHNG,R,AMHG,R1 D PAUSE D EXIT Q
 D FULL^VALM1
 I $O(^AMHGROUP(AMHNG,61,0)) W !!,"This group already has visits created.  You must use the REVIEW/EDIT",!,"GROUP VISITS to modify visits within this group." D PAUSE,EXIT Q
 I $P(^AMHGROUP(AMHNG,0),U,18) W !!,"This Group's Notes have been signed.  You cannot edit the Group.",! D PAUSE,EXIT Q
 S AMHDATE=$P($P(^AMHGROUP(AMHNG,0),U),".")
 D EDITGRP
 Q
ADDGRP ;
 D FULL^VALM1
 ;add new group 
 K DIR S DIR(0)="D^:"_DT_":EP",DIR("A")="Enter Date of the Group Activity" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"date not entered." D PAUSE,EXIT Q
 S AMHDATE=Y
 S X=AMHDATE,DIC="^AMHGROUP(",DLAYGO=9002011.67,DIADD=1,DIC(0)="L" K DD,DO D FILE^DICN
 I Y=-1 W !!,"entry of new group failed." K DIADD,DLAYGO D ^XBFMK D EXIT Q
 S AMHNG=+Y
 K DIADD,DLAYGO D ^XBFMK
EDITGRP ;EP
 S APCDOVRR=1
 S DA=AMHNG,DDSFILE=9002011.67,DR="[AMH GROUP ADD/EDIT]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG D PAUSE,EXIT Q
 ;must have a pov/provider
 S E=0
 I '$O(^AMHGROUP(AMHNG,11,0)) W !!,"Group must have at least one Provider defined." S E=1
 NEW X,G,C
 S X=0,G=0,C=0 F  S X=$O(^AMHGROUP(AMHNG,11,X)) Q:X'=+X  I $P($G(^AMHGROUP(AMHNG,11,X,0)),U,2)="P" S G=1,C=C+1
 I C>1 W !!,"Group must not have 2 PRIMARY PROVIDER's defined." S E=1
 I 'G W !!,"Group must have at least one PRIMARY PROVIDER defined." S E=1
 I '$O(^AMHGROUP(AMHNG,21,0)) W !!,"Group must have at least one POV defined." S E=1
 I '$O(^AMHGROUP(AMHNG,51,0)) W !!,"Group must have at least one Patient defined." S E=1
 S X=0,G=0 F  S X=$O(^AMHGROUP(AMHNG,31,X)) Q:X'=+X  I $G(^AMHGROUP(AMHNG,31,X,0))]"" S G=1
 I 'G W !!,"Group must have a group narrative defined.  " S E=1
 I E S AMHE="" D  G:AMHE="E" EDITGRP D:AMHE="Q" PAUSE,EXIT Q:AMHE="Q"  W !!,"deleting group definition." S DA=AMHNG,DIK="^AMHGROUP(" D ^DIK D PAUSE,EXIT Q
 .S DIR(0)="S^E:Edit the Group definition;D:Delete this Group definition;Q:to exit and edit it later without deleting the group definition",DIR("A")="This group definition is not complete, do you wish to",DIR("B")="E" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) Q
 .S AMHE=Y
 .Q
 ;now loop through patients and add records
 D ^XBFMK
 W !!,"You have added the following group definition, please review it carefully",!,"before you proceed.",!
 S DA=AMHNG,DIC="^AMHGROUP(" D EN^DIQ
 S DIR(0)="S^Y:Yes, group definition is accurate, continue on to add visits;N:No, I wish to edit the group definition;Q:I wish to QUIT and exit",DIR("A")="Do you wish to continue on to add patient visits for this group"
 S DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE,EXIT Q
 I Y="Q" D PAUSE,EXIT Q
 I Y="N" G EDITGRP
SENS ;check for sensitive patients
 S AMHQ=0
 NEW AMHRESU
 S AMHX=0 F  S AMHX=$O(^AMHGROUP(AMHNG,51,AMHX)) Q:AMHX'=+AMHX!(AMHQ)  D
 .S AMHPAT=$P(^AMHGROUP(AMHNG,51,AMHX,0),U,1)
 .K AMHRESU
 .D PTSEC^AMHUTIL2(.AMHRESU,AMHPAT,1)
 .I '$G(AMHRESU(1)) Q
 .I $G(AMHRESU(1))=3!($G(AMHRESU(1))=4)!($G(AMHRESU(1))=5) D DISPDG^AMHLE S AMHQ=1 Q
 .D DISPDG^AMHEGS
 .W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue to add visits for this group",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I 'Y S AMHQ=1 Q
 .K AMHRESU
 .D NOTICE^DGSEC4(.AMHRESU,AMHPAT,,3)
 K AMHPAT
 W !!!
 I AMHQ D  D EXIT Q
 .W !!,"You have selected not to continue and add visits for a patient in this group."
 .W !,"You must go back and remove the patient from the group definition before "
 .W !,"you can continue on to add the visits for the group.",!!!!
 .D PAUSE^AMHLEA
 D ADDREC
 D EXIT
 Q
DUP ;EP -
 D DUP^AMHEGR1
 Q
DISP ;EP - called from protocol
 D DISP^AMHEGR1
 Q
PRTEF ;EP
 D PRTEF^AMHEGR1
 Q
DEL ;EP - called from protocol
 D DEL^AMHEGR1
 Q
ADDREC ;EP
 D FULL^VALM1
 K DIR
 W !!,"Adding records for each individual patient in this group.",!
 K AMHDELQ S AMHNGX=0 F  S AMHNGX=$O(^AMHGROUP(AMHNG,51,AMHNGX)) Q:AMHNGX'=+AMHNGX!($G(AMHDELQ))  D ADDREC1
SIGN ;EP
 S AMHSIGN=0
 S P=$$PP(AMHNG)
 I $D(^AMHSITE(DUZ(2),19,"B",P)) W !!,"No E-Sig Required.  Provider opted out of E-Sig." G PCCLINK
 S D=$P($P(^AMHGROUP(AMHNG,0),U),".")
 I '$$ESIGREQ^AMHESIG(,D) W !!,"No E-Sig required.  Date prior to Version 4.0." G PCCLINK
 I P'=DUZ W !!,"You are not the primary provider for this group, no electronic",!,"signature will be applied and no PCC link will occur.",!,"The primary provider will need to sign these at a later time." D PAUSE,EXIT Q
 W !!,"You can now sign all of the progress notes for this group of visits."
 D SIG^XUSESIG
 I X1="" W !!,"You will need to sign them later." K X1 D PAUSE,EXIT Q
 S AMHSIGN=1
PCCLINK ;
 D PCCLINK^AMHEGR1
 K X1
SIGN1 D PAUSE,EXIT
 Q
ADDREC1 ;EP
 S (AMHPAT,DFN)=$P(^AMHGROUP(AMHNG,51,AMHNGX,0),U)
ADDREC2 ;
 S AMHG0=^AMHGROUP(AMHNG,0)
 S APCDOVRR=1,AMHOVRR=1
 S AMHVTYPE="R",AMHLOC=$P(AMHG0,U,5),AMHPROG=$P(AMHG0,U,2),AMHDATE=$P(AMHG0,U),AMHCLN=$P(AMHG0,U,14),AMHCOMM=$P(AMHG0,U,6),AMHACT=$P(AMHG0,U,7),AMHCONT=$P(AMHG0,U,8),AMHINT="",AMHPTYPE=AMHPROG,AMHCC=$G(^AMHGROUP(AMHNG,12))
 S AMHTIME=$P(AMHG0,U,11)
 S AMHNUM=0,X=0 F  S X=$O(^AMHGROUP(AMHNG,51,X)) Q:X'=+X  S AMHNUM=AMHNUM+1
 S AMHACTP=AMHTIME\AMHNUM I AMHACTP<1 S AMHACTP=1
 S AMHACTN=1
 W !!,"Creating new BH record for ",$P(^DPT(AMHPAT,0),U),"."
 K DD,D0,DO,DIC,DA,DR S DIC("DR")="",DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE,DIC("DR")="1111////1" D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Record is NOT complete!!  Deleting Record.",! D PAUSE,^XBFMK Q
 S (DA,AMHR)=+Y,AMHAWIXX="A",DIE="^AMHREC(",DR="[AMH ADD RECORD NO INTERACT]" D CALLDIE^AMHLEIN K AMHAWIXX
 I $D(Y) D  S AMHDELQ=1 Q
 .W !!,"ERROR -- Incomplete record!! You have exited before a complete record"
 .W !,"had been added.  I have to delete the record.  Please complete the",!,"entry of patient visits for this group at a later time.",!!
 .D DELR^AMHEGR1 Q
 S AMHVTYPE=$P(^AMHREC(AMHR,0),U,33)
 K DIADD,DLAYGO
 D ^XBFMK
 S DIE="^AMHREC(",DA=AMHR
 S DR=".09////1;.11////U;.19////"_DUZ_";.33////R;.28////"_DUZ_";.22///A;.21///^S X=DT;.25////"_$P(AMHNG,U,14)_";.34////1;.12////"_AMHACTP_";1109////"_$P(^AMHGROUP(AMHNG,0),U,3)  ;_";2101///"_$P($G(^AMHGROUP(AMHNG,12)),U,1)
 D ^DIE
 I $D(Y) W !!,"updating record for patient ",$P(^DPT(DFN,0),U)," failed." D PAUSE,EXIT Q
 S DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 I $P($G(^AMHGROUP(AMHNG,12)),U,1)]"" S $P(^AMHREC(AMHR,21),U,1)=$P(^AMHGROUP(AMHNG,12),U,1)
 ;add in providers,povs,cpts,subjective
ADDPRV ;
 S AMHP=0 F  S AMHP=$O(^AMHGROUP(AMHNG,11,AMHP)) Q:AMHP'=+AMHP  D
 .S AMHP1=$P(^AMHGROUP(AMHNG,11,AMHP,0),U)
 .Q:'AMHP1
 .Q:'$D(^VA(200,AMHP1,0))
 .S X=AMHP1,DIC("DR")=".02////"_$G(AMHPAT)_";.03////"_AMHR_";.04///"_$P(^AMHGROUP(AMHNG,11,AMHP,0),U,2),DIC="^AMHRPROV(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.02 K DD,DO D FILE^DICN
 .K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 .I Y=-1 W !!,"Creating Provider entry failed!!!",$C(7),$C(7) H 2
ADDPOV ;
 S AMHP=0 F  S AMHP=$O(^AMHGROUP(AMHNG,21,AMHP)) Q:AMHP'=+AMHP  D
 .S AMHP1=$P(^AMHGROUP(AMHNG,21,AMHP,0),U)
 .Q:'AMHP1
 .Q:'$D(^AMHPROB(AMHP1,0))
 .S AMHNAR=$P(^AMHGROUP(AMHNG,21,AMHP,0),U,2) ;,AMHNAR=$P(^AUTNPOV(AMHNAR,0),U,1),AMHNAR=$TR(AMHNAR,";",",")
 .S X=AMHP1,DIC("DR")=".02////"_$G(AMHPAT)_";.03////"_AMHR_";.04///`"_AMHNAR,DIC="^AMHRPRO(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.01 K DD,DO D FILE^DICN
 .K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 .I Y=-1 W !!,"Creating POV entry failed!!!",$C(7),$C(7) H 2
 D EP2^AMHEGRPV
ADDCPTS ;
 S AMHP=0 F  S AMHP=$O(^AMHGROUP(AMHNG,41,AMHP)) Q:AMHP'=+AMHP  D
 .S AMHP1=$P(^AMHGROUP(AMHNG,41,AMHP,0),U)
 .Q:'AMHP1
 .Q:'$D(^ICPT(AMHP1,0))
 .S X=AMHP1,DIC("DR")=".02////"_$G(AMHPAT)_";.03////"_AMHR,DIC="^AMHRPROC(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.04 K DD,DO D FILE^DICN
 .K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 .I Y=-1 W !!,"Creating CPT entry failed!!!",$C(7),$C(7) H 2
ADDPTED ;
 K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 S AMHP=0 F  S AMHP=$O(^AMHGROUP(AMHNG,71,AMHP)) Q:AMHP'=+AMHP  D
 .S AMHP1=$P(^AMHGROUP(AMHNG,71,AMHP,0),U)
 .S AMHP0=^AMHGROUP(AMHNG,71,AMHP,0)
 .S AMHP11=$P($G(^AMHGROUP(AMHNG,71,AMHP,11)),U)
 .S AMHP12=$P($G(^AMHGROUP(AMHNG,71,AMHP,11)),U,2)
 .Q:'AMHP1
 .Q:'$D(^AUTTEDT(AMHP1,0))
 .S X=AMHP1
 .S DIC("DR")=".02////"_$G(AMHPAT)_";.03////"_AMHR_";.04///`"_$P(AMHP0,U,2)_";.05///"_$P(AMHP0,U,3)_";.06///"_$P(AMHP0,U,4)_";.07////"_$P(AMHP0,U,5)_";.08///"_$P(AMHP0,U,6)_";.09///"_$P(AMHP0,U,7)_";.11///"_$P(AMHP0,U,8)_";1102////"_AMHP12
 .S DIC="^AMHREDU(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.05 K DD,DO D FILE^DICN
 .K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 .I Y=-1 W !!,"Creating PT ED entry failed!!!",$C(7),$C(7) H 2
 .I AMHP11]"" S $P(^AMHREDU(+Y,11),U,1)=AMHP11
CC ;
 W !!
 S DA=AMHR,DIE="^AMHREC(",DR=2101 D ^DIE
 W !
SOAP ;put in standard soap
 D SOAP^AMHEGR1
 Q
PAUSE ;EP
 K DIR
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
EXIT ;EP -- exit code
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER
 S VALMCNT=AMHLINE
 D HDR
 K X,Y,Z,I
 Q
NOSHOW ;EP - CALLED FROM PROTOCOL
 D FULL^VALM1
 W !!,"This option is used to enter a No-Show visit for a client who failed"
 W !,"to show for his/her group session."
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." D EXIT Q
 S R=$O(VALMY(0)) I 'R K R,VALMY,XQORNOD W !,"No record selected." D EXIT Q
 S AMHG=0 S AMHG=^TMP($J,"AMHEGR","IDX",R,R)
 I '$D(^AMHGROUP(AMHG,0)) W !,"Not a valid GROUP." K AMHRDEL,R,AMHG,R1 D PAUSE,EXIT Q
 S AMHDATE=$P(^AMHGROUP(AMHG,0),U)
 S AMHPTYPE=$P(^AMHGROUP(AMHG,0),U,2)
 S AMHVTYPE="R"
 S AMHPAT=""
 D GETPAT^AMHLEA
 I AMHPAT="" W !!,"No patient entered" H 2 D EXIT Q
 S DFN=AMHPAT
 D ADDNS
 K AMHPAT,DFN,AMHDATE,AMHPTYPE,AMHVTYPE
 D EXIT
 Q
ADDNS ;EP
 D ADDNS^AMHEGS
 Q
INTX(X) ;
 I '$D(^AUPNPAT(X)) Q 0
 I '$$ALLOWP^AMHUTIL(DUZ,X) D NALLOWP^AMHUTIL Q 0
 NEW %,D
 S %=$$DOD^AUPNPAT(X) I %="" Q 0
 S D=$S($G(AMHDATE):$P(AMHDATE,"."),$G(DA(1)):$P(^AMHGROUP(DA(1),0),U,1))
 I $G(D),$P(D,".")>% K X Q 0
 Q 1
ALIVE ;EP
 I '$D(X) Q
 NEW %,D
 S %=$$DOD^AUPNPAT(X) I %="" Q
 S D=$S($G(AMHDATE):$P(AMHDATE,"."),$G(DA(1)):$P(^AMHGROUP(DA(1),0),U,1))
 I $G(D),$P(D,".")>% K X D EN^DDIOL("Patient is deceased as of the visit date.") K X Q
 Q
PP(G) ;EP
 NEW X,Y
 S Y=""
 S X=0 F  S X=$O(^AMHGROUP(G,11,X)) Q:X'=+X  I $P(^AMHGROUP(G,11,X,0),U,2)="P" S Y=$P(^AMHGROUP(G,11,X,0),U,1)
 Q Y
