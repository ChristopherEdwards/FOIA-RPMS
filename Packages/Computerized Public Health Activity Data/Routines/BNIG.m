BNIG ; IHS/CMI/LAB - group entry for bni ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;; ;
START ; Write Header
 D EOJ ; -- kill all vars before starting
 W:$D(IOF) @IOF
 F J=1:1:13 S X=$P($T(TEXT+J),";;",2) W !?80-$L(X)\2,X
 K X,J
START1 ;
 I '$O(^BNISITE(0)) W !!,"Site parameters have not been set up.  Please see the system manager." D PAUSE,EOJ Q
 W !!
 D GETSITE
 I BNISITE="" D EOJ Q
 D ADDQ
 I BNIADDQ="" G START1
AGR ;
 D FULL^VALM1
 W !!
MNTH ;
 S (BNIMNTH,BNIDATE,BNIYR)=""  ;,DIR(0)="DO^:"_DT_":EPTX",DIR("A")="Enter Date of Activity" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 S DIR(0)="S^1:JANUARY;2:FEBRUARY;3:MARCH;4:APRIL;5:MAY;6:JUNE;7:JULY;8:AUGUST;9:SEPTEMBER;10:OCTOBER;11:NOVEMBER;12:DECEMBER",DIR("A")="Enter the MONTH the activity took place" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE G EOJ
 S BNIMNTH=Y I $L(BNIMNTH)=1 S BNIMNTH="0"_BNIMNTH
YR ;
 S BNIYR=""
 S (BNIPER,BNIVDT)=""
 K DIR S DIR(0)="D^::EP",DIR("B")=$$FMTE^XLFDT(($E(DT,1,3)_"0000"))
 S DIR("A")="Enter Year"
 S DIR("?")="Enter the year the activity took place. E.g. 2006 or 06"
 D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE G MNTH
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G YR
 S BNIYR=Y
 S BNIDATE=BNIYR,$E(BNIDATE,4,5)=BNIMNTH
 I BNIDATE>DT W !!,"Future dates are not allowed!",! G MNTH
 ;
ADDR ;
 K DIC S DIC(0)="EL",DIC="^BNIGROUP(",DLAYGO=90510.5,DIADD=1,X=BNIDATE
 S DIC("DR")=".02////"_DT_";.03////"_DUZ_";.06////"_DUZ(2)_";.07////"_DUZ(2)
 K DD,DO,D0 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"CPHAD Group Record is NOT complete!!  Deleting Record.",! D PAUSE,EOJ Q
 ;update multiple of user last update/date edited
 S BNIGR=+Y
ADDR1 ;
 S DA=BNIGR,DDSFILE=90510.5,DR=$S($G(BNIADDQ):"[BNIA GROUP ENTRY]",1:"[BNI GROUP ENTRY]") D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" D PAUSE,EOJ Q
 ;check record for completeness
 D CHECKREC
 I Q D  G:BNIA="E" ADDR1  D DELR,PAUSE,EOJ Q
 .S BNIA="" K DIR
 .S DIR(0)="S^E:Edit and complete the Group Record;D:Delete the Incomplete Group Record",DIR("A")="Do you wish to",DIR("B")="E" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BNIA="D"
 .S BNIA=Y
GROUP ;
 W !!,"I will now create an individual activity record for the following:"
 S X=0 F  S X=$O(^BNIGROUP(BNIGR,16,X)) Q:X'=+X  W !?5,$P(^VA(200,$P(^BNIGROUP(BNIGR,16,X,0),U),0),U)
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"No records created." D PAUSE,EOJ Q
 S BNIX=0 F  S BNIX=$O(^BNIGROUP(BNIGR,16,BNIX)) Q:BNIX'=+BNIX  D
 .S BNIPRV=$P(^BNIGROUP(BNIGR,16,BNIX,0),U)
 .W !,"Creating record for ",$P(^VA(200,BNIPRV,0),U)
 .K DIC S DIC(0)="EL",DIC="^BNIREC(",DLAYGO=90510,DIADD=1,X=BNIDATE
 .S DIC("DR")=".02////"_DT_";.03////"_DUZ_";.06////"_DUZ(2)_";.08////"_BNIPRV
 .K DD,DO,D0 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 .I Y=-1 W !!,$C(7),$C(7),"Creating record for ",$P(^VA(200,BNIPRV,0),U)," failed!!  Deleting Record.",! D PAUSE,EOJ Q
 .;update multiple of user last update/date edited
 .S BNIR=+Y
 .S DIE="^BNIREC(",DA=BNIR,DR="1500///NOW",DR(2,90510.0115)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 .F BNIZ=7,9,11:1:18 S $P(^BNIREC(BNIR,0),U,BNIZ)=$P(^BNIGROUP(BNIGR,0),U,BNIZ)
 .F BNIZ=1,2 I $P($G(^BNIGROUP(BNIGR,11)),U,BNIZ)]"" S $P(^BNIREC(BNIR,11),U,BNIZ)=$P(^BNIGROUP(BNIGR,0),U,BNIZ)
 .F BNIZ=1 I $P($G(^BNIGROUP(BNIGR,12)),U,BNIZ)]"" S $P(^BNIREC(BNIR,12),U,BNIZ)=$P(^BNIGROUP(BNIGR,12),U,BNIZ)
 .S BNIW=0 F  S BNIW=$O(^BNIGROUP(BNIGR,14,BNIW)) Q:BNIW'=+BNIW  D
 ..S ^BNIREC(BNIR,14,BNIW,0)=^BNIGROUP(BNIGR,14,BNIW,0)
 ..S ^BNIREC(BNIR,14,0)="^^"_BNIW_"^"_BNIW_"^"_DT_"^"
 .S DA=BNIR,DIK="^BNIREC(" D IX1^DIK
 W !,"Records created."
 D PAUSE
 D EOJ
 Q
 ;
EOJ ;EOJ CLEANUP
 D CLEAR^VALM1
 D EN^XBVK("BNI")
 Q
GETSITE ;
 S BNISITE=""
 W ! K DIC S DIC="^BNISITE(",DIC("A")="Enter your Site: ",DIC("B")=$P(^DIC(4,DUZ(2),0),U),DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 Q
 S BNISITE=+Y
 Q
ADDQ ;
 S BNIADDQ=""
 W !
 K DIR
 S DIR(0)="Y",DIR("A")="Do you want to be prompted for Travel Time and Number Served",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BNIADDQ=Y
 Q
DATE(D) ;
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
 ;
TEXT ;
 ;;Computerized Public Health Activity (CPHAD) Group Data Entry
 ;;
 ;;***************************************
 ;;* Update CPHAD Group Activity Records *
 ;;***************************************
 ;;
 ;;This option is used to enter a GROUP Activity Record.
 ;;You will be asked to enter all information about the activity
 ;;including all persons who participated in the activity. 
 ;;When all information is entered a public health activity record
 ;;will be generated for each person who participated in the
 ;;group activity.
 ;;
 Q
SHT(G) ;EP - called from screenman screen
 I $G(G)="" Q ""
 NEW X
 S X=$O(^BNISHT("AA",G,1,0))
 I X,$D(^BNISHT(X,0)) Q $P(^BNISHT(X,0),U,1)
 Q ""
GHCPOST ;EP - called from screenman
 D REQ^DDSUTL(4,2,1,$S('$G(X):0,$P(^BNIGHC(X,0),U,3)=1:1,1:0)) ;require other if Other
 I 'X D PUT^DDSVAL(DIE,.DA,1101,"") ;empty out 1101 if not Other
 I X,'$P(^BNIGHC(X,0),U,3) D PUT^DDSVAL(DIE,.DA,1101,"")
 D UNED^DDSUTL(4,2,1,$S('$G(X):1,$P(^BNIGHC(X,0),U,3)=1:0,1:1)) ;don't allow field 7 if not other
 S BNISMGNC=X
 NEW Z
 S Z=$$GET^DDSVAL(DIE,.DA,.12)
 I Z="" D PUT^DDSVAL(DIE,.DA,.12,$$SHT(BNISMGNC))
 I Z]"" D
 .Q:$P(^BNISHT(Z,0),U,3)=BNISMGNC
 .D PUT^DDSVAL(DIE,.DA,.12,$$SHT(BNISMGNC))
 .Q
 D REFRESH^DDSUTL
 Q
SHTPOST ;EP - called from screenman
 D REQ^DDSUTL(6,2,1,$S('$G(X):0,$P(^BNISHT(X,0),U,5)=1:1,1:0)) ;require other if Other
 I 'X D PUT^DDSVAL(DIE,.DA,1102,"") ;empty out 1101 if not Other
 I X,'$P(^BNISHT(X,0),U,5) D PUT^DDSVAL(DIE,.DA,1102,"")
 D UNED^DDSUTL(6,2,1,$S('$G(X):1,$P(^BNISHT(X,0),U,5)=1:0,1:1)) ;don't allow field 8 if not other
 D REFRESH^DDSUTL
 Q
TOAPOST ;EP - called from screenman
 D REQ^DDSUTL(8,2,1,$S('$G(X):0,$P(^BNITOA(X,0),U,3)=1:1,1:0)) ;require other if Other
 I 'X D PUT^DDSVAL(DIE,.DA,1103,"") ;empty out 1101 if not Other
 I X,'$P(^BNITOA(X,0),U,3) D PUT^DDSVAL(DIE,.DA,1103,"")
 D UNED^DDSUTL(8,2,1,$S('$G(X):1,$P(^BNITOA(X,0),U,3)=1:0,1:1)) ;don't allow field 8 if not other
 D REFRESH^DDSUTL
 Q
GSPOST ;EP - called from screenman
 D REQ^DDSUTL(10,2,1,$S('$G(X):0,$P(^BNIGS(X,0),U,3)=1:1,1:0)) ;require other if Other
 I 'X D PUT^DDSVAL(DIE,.DA,1104,"") ;empty out 1101 if not Other
 I X,'$P(^BNIGS(X,0),U,3) D PUT^DDSVAL(DIE,.DA,1104,"")
 D UNED^DDSUTL(10,2,1,$S('$G(X):1,$P(^BNIGS(X,0),U,3)=1:0,1:1)) ;don't allow field 10 if not other
 D REFRESH^DDSUTL
 Q
ASPOST ;EP - called from screenman
 D REQ^DDSUTL(12,2,1,$S('$G(X):0,$P(^BNIAS(X,0),U,3)=1:1,1:0)) ;require other if Other
 I 'X D PUT^DDSVAL(DIE,.DA,.16,"") ;empty out 1101 if not Other
 I X,'$P(^BNIAS(X,0),U,3) D PUT^DDSVAL(DIE,.DA,.16,"")
 D UNED^DDSUTL(12,2,1,$S('$G(X):1,$P(^BNIAS(X,0),U,3)=1:0,1:1)) ;don't allow field 12 if not other
 D REFRESH^DDSUTL
 Q
SHTSCR(I) ;EP - called from screen on dd 90510 FIELD .12
 I '$G(BNISMGNC) Q 1
 I $P(^BNISHT(I,0),U,3)'=BNISMGNC Q 0
 Q 1
COMM(I) ;EP - called from screen on dd 90510 field .16
 I '$G(BNISITE) Q 1
 NEW Z,C
 S Z=$P($G(^BNISITE(BNISITE,0)),U,3)
 I 'Z Q 1
 S C=$P(^AUTTCOM(Y,0),U)
 I '$D(^ATXAX(Z,0)) Q 1
 I '$D(^ATXAX(Z,21,"B",C)) Q 0
 Q 1
CHECKREC ;
 S Q="" F F=.07,.09,.11,.12,.13 I $P(^BNIGROUP(BNIGR,0),U,+$P(F,".",2))="" D
 .W !,$P(^DD(90510,F,0),U)," is a required field and is missing." S Q=1
 I $P($G(^BNISITE(BNISITE,0)),U,2),$P(^BNIGROUP(BNIGR,0),U,15)="" D
 .W !,"ACTIVITY SETTING is required and is missing." S Q=1
 S X=$P(^BNIGROUP(BNIGR,0),U,11) I X,$P(^BNIGHC(X,0),U,3),$P($G(^BNIGROUP(BNIGR,11)),U,1)="" D
 .W !,"GENERAL HEALTH CONCERN is ",$P(^BNIGHC(X,0),U),!,"   and the text of GENERAL HEALTH CONCERN (OTHER) is missing." S Q=1
 S X=$P(^BNIGROUP(BNIGR,0),U,12) I X,$P(^BNISHT(X,0),U,5),$P($G(^BNIGROUP(BNIGR,11)),U,2)="" D
 .W !,"SPECIFIC HEALTH TOPIC is ",$P(^BNISHT(X,0),U),!,"   and the text of SPECIFIC HEALTH TOPIC (OTHER) is missing." S Q=1
 S X=$P(^BNIGROUP(BNIGR,0),U,13) I X,$P(^BNITOA(X,0),U,3),$P($G(^BNIGROUP(BNIGR,11)),U,3)="" D
 .W !,"TYPE OF ACTIVITY is ",$P(^BNITOA(X,0),U),!,"   and the text of TYPE OF ACTIVITY (OTHER) is missing." S Q=1
 S X=$P(^BNIGROUP(BNIGR,0),U,14) I X,$P(^BNIGS(X,0),U,3),$P($G(^BNIGROUP(BNIGR,12)),U,1)="" D
 .W !,"GROUP SERVED is ",$P(^BNIGS(X,0),U),!,"   and the text of GROUP SERVED (OTHER) is missing." S Q=1
 S X=$P(^BNIGROUP(BNIGR,0),U,15) I X,$P(^BNIAS(X,0),U,3),$P($G(^BNIGROUP(BNIGR,0)),U,16)="" D
 .W !,"ACTIVITY SETTING is ",$P(^BNIAS(X,0),U),!,"   and the COMMUNITY is missing." S Q=1
 I '$O(^BNIGROUP(BNIGR,16,0)) W !!,"You must enter at least one participating individual." S Q=1
 Q
DELR ;
 S DA=BNIGR,DIK="^BNIGROUP(" D ^DIK K DIK,DA
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
