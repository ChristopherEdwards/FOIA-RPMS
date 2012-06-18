BNIE ; IHS/CMI/LAB - Data entry for BNI ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;; ;
START ; Write Header
 D EOJ ; -- kill all vars before starting
 W:$D(IOF) @IOF
 F J=1:1:11 S X=$P($T(TEXT+J),";;",2) W !?80-$L(X)\2,X
 K X,J
START1 ;
 I '$O(^BNISITE(0)) W !!,"Site parameters have not been set up.  Please see the system manager." D PAUSE,EOJ Q
 W !!
 D GETSITE
 I BNISITE="" D EOJ Q
 D WHICH
 I BNIPRV="" D EOJ Q
 D ADDQ
 I BNIADDQ="" G START1
 D EN,FULL^VALM1,EXIT
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
WHICH ;
 S BNIPRV=""
 D ^XBFMK
 W ! K DIC S DIC=200,DIC(0)="AEMQ",DIC("A")="Enter Person who Performed the Activity: ",DIC("B")=$P(^VA(200,DUZ,0),U) D ^DIC K DIC
 I Y=-1 Q
 S BNIPRV=+Y
 Q
ADDQ ;
 S BNIADDQ=""
 W !
 K DIR
 S DIR(0)="Y",DIR("A")="Do you want to be prompted for Travel Time and Number Served",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BNIADDQ=Y
 Q
EN ; EP -- main entry point for BNI UPDATE ACTIVITY RECORDS
 S VALMCC=1
 D EN^VALM("BNI UPDATE ACTIVITY RECORDS")
 D CLEAR^VALM1
 ;S DTIME=BNIKDTIM
 K BNIKDTIM
 Q
 ;
HDR ;EP -- header code
 S VALMHDR(1)=$$REPEAT^XLFSTR("-",80)
 S VALMHDR(2)="Person Performing Activity:  "_$P(^VA(200,BNIPRV,0),U)
 S VALMHDR(3)=$$REPEAT^XLFSTR("-",80)
 I $E($G(^TMP("BNIRECS",$J,1,0)))="N" S BNIRCNT=0,VALMHDR(4)=^TMP("BNIRECS",$J,1,0) K ^TMP("BNIRECS",$J)
 E  S X="",$E(X,2)="#",$E(X,5)="DATE",$E(X,15)="PRV",$E(X,20)="TIME",$E(X,25)="General Health",$E(X,41)="Spec Hlth Topic",$E(X,57)="Activity",$E(X,73)="Setting",VALMHDR(4)=X
 Q
 ;
INIT ;EP -- init variables and list array
 ;S VALMSG="Q - Quit ?? for more actions + next screen - prev screen"
 S VALMSG="                               ?? for more actions"
 D GATHER ;gather up all records for display
 S VALMCNT=BNIRCNT
 I VALMCNT>11 S VALMSG="+ for more records, - to back up  ?? for more actions"
 Q
 ;
GATHER ;
 ;gather up all records
 K ^TMP($J,"BNIRECS") S BNIRCNT=0
 ;I '$D(^BNIREC("AC",BNIPRV)) S ^TMP("BNIRECS",$J,1,0)="No CPHAD activity records on file for this provider" Q
 S (BNIRCNT,BNIIDAT,C)=0 F  S BNIIDAT=$O(^BNIREC("AE",BNIIDAT)) Q:BNIIDAT=""  D
 .S BNIV=0 F  S BNIV=$O(^BNIREC("AE",BNIIDAT,BNIV)) Q:BNIV'=+BNIV  D
 ..Q:'$$ALLOW(BNIV)
 ..S BNIRCNT=BNIRCNT+1,BNIRS=BNIRCNT,^TMP("BNIRECS",$J,"IDX",BNIRCNT,BNIRCNT)=BNIV
 ..S BNIREC=^BNIREC(BNIV,0) D REC
 ..S ^TMP("BNIRECS",$J,BNIRCNT,0)=BNIX
 K BNIX,BNIV,BNIREC
 Q
 ;
REC ;
 S BNIX=$J(BNIRS,3)
 S $E(BNIX,5)=$$DATE($P(BNIREC,U))
 S X=$P(BNIREC,U,8) I X S X=$P($G(^VA(200,X,0)),U,2) I X="" S X="???"
 S $E(BNIX,15)=X
 S $E(BNIX,20)=$P(BNIREC,U,9)
 S $E(BNIX,25)=$E($$VAL^XBDIQ1(90510,BNIV,.11),1,15)
 S $E(BNIX,41)=$E($$VAL^XBDIQ1(90510,BNIV,.12),1,15)
 S $E(BNIX,57)=$E($$VAL^XBDIQ1(90510,BNIV,.13),1,15)
 S $E(BNIX,73)=$E($$VAL^XBDIQ1(90510,BNIV,.15),1,10)
 Q
DATE(D) ;
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K BNIRCNT,^TMP("BNIRECS",$J)
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
TEXT ;
 ;;Computerized Public Health Activity Data System (CPHAD) Data Entry
 ;;
 ;;*********************************
 ;;* Update CPHAD Activity Records *
 ;;*********************************
 ;;
 ;;This option is used to update CPHAD activity records.
 ;;You will be asked to specify which records will be displayed
 ;;for editing.  You will also be asked if you want to display
 ;;only your records or all records.
 ;;
 Q
SHT(G) ;EP - called from screenman screen
 I $G(G)="" Q ""
 NEW X
 S X=$O(^BNISHT("AA",G,1,0))
 I X,$D(^BNISHT(X,0)) Q $P(^BNISHT(X,0),U,1)
 Q ""
GHCPOST ;EP - called from screenman
 D REQ^DDSUTL(5,2,1,$S('$G(X):0,$P(^BNIGHC(X,0),U,3)=1:1,1:0)) ;require other if Other
 I 'X D PUT^DDSVAL(DIE,.DA,1101,"") ;empty out 1101 if not Other
 I X,'$P(^BNIGHC(X,0),U,3) D PUT^DDSVAL(DIE,.DA,1101,"")
 D UNED^DDSUTL(5,2,1,$S('$G(X):1,$P(^BNIGHC(X,0),U,3)=1:0,1:1)) ;don't allow field 7 if not other
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
 D REQ^DDSUTL(7,2,1,$S('$G(X):0,$P(^BNISHT(X,0),U,5)=1:1,1:0)) ;require other if Other
 I 'X D PUT^DDSVAL(DIE,.DA,1102,"") ;empty out 1101 if not Other
 I X,'$P(^BNISHT(X,0),U,5) D PUT^DDSVAL(DIE,.DA,1102,"")
 D UNED^DDSUTL(7,2,1,$S('$G(X):1,$P(^BNISHT(X,0),U,5)=1:0,1:1)) ;don't allow field 8 if not other
 D REFRESH^DDSUTL
 Q
TOAPOST ;EP - called from screenman
 D REQ^DDSUTL(9,2,1,$S('$G(X):0,$P(^BNITOA(X,0),U,3)=1:1,1:0)) ;require other if Other
 I 'X D PUT^DDSVAL(DIE,.DA,1103,"") ;empty out 1101 if not Other
 I X,'$P(^BNITOA(X,0),U,3) D PUT^DDSVAL(DIE,.DA,1103,"")
 D UNED^DDSUTL(9,2,1,$S('$G(X):1,$P(^BNITOA(X,0),U,3)=1:0,1:1)) ;don't allow field 8 if not other
 D REFRESH^DDSUTL
 Q
GSPOST ;EP - called from screenman
 D REQ^DDSUTL(11,2,1,$S('$G(X):0,$P(^BNIGS(X,0),U,3)=1:1,1:0)) ;require other if Other
 I 'X D PUT^DDSVAL(DIE,.DA,1104,"") ;empty out 1101 if not Other
 I X,'$P(^BNIGS(X,0),U,3) D PUT^DDSVAL(DIE,.DA,1104,"")
 D UNED^DDSUTL(11,2,1,$S('$G(X):1,$P(^BNIGS(X,0),U,3)=1:0,1:1)) ;don't allow field 8 if not other
 D REFRESH^DDSUTL
 Q
ASPOST ;EP - called from screenman
 D REQ^DDSUTL(13,2,1,$S('$G(X):0,$P(^BNIAS(X,0),U,3)=1:1,1:0)) ;require other if Other
 I 'X D PUT^DDSVAL(DIE,.DA,.16,"") ;empty out 1101 if not Other
 I X,'$P(^BNIAS(X,0),U,3) D PUT^DDSVAL(DIE,.DA,.16,"")
 D UNED^DDSUTL(13,2,1,$S('$G(X):1,$P(^BNIAS(X,0),U,3)=1:0,1:1)) ;don't allow field 8 if not other
 D REFRESH^DDSUTL
 Q
SHTSCR(I) ;EP - called from screen on dd 90510 FIELD .12
 I '$G(BNISMGNC) Q 1
 I $P(^BNISHT(I,0),U,3)'=BNISMGNC Q 0
 Q 1
COMM(I) ;EP - called from screen on dd 90510 field .16
 I '$G(BNISITE) Q 1
 NEW Z,C
 ;S Z=$P($G(^BNISITE(BNISITE,0)),U,3)
 ;I 'Z Q 1
 I '$O(^BNISITE(BNISITE,11,0)) Q 1
 ;S C=$P(^AUTTCOM(Y,0),U)
 ;I '$D(^ATXAX(Z,0)) Q 1
 ;I '$D(^ATXAX(Z,21,"B",C)) Q 0
 I '$D(^BNISITE(BNISITE,11,"B",I)) Q 0
 Q 1
ADD ;EP - ADD a record
 D FULL^VALM1
 W !!
MNTH ;
 S (BNIMNTH,BNIDATE,BNIYR)=""  ;,DIR(0)="DO^:"_DT_":EPTX",DIR("A")="Enter Date of Activity" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 S DIR(0)="S^1:JANUARY;2:FEBRUARY;3:MARCH;4:APRIL;5:MAY;6:JUNE;7:JULY;8:AUGUST;9:SEPTEMBER;10:OCTOBER;11:NOVEMBER;12:DECEMBER",DIR("A")="Enter the MONTH the activity took place" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE G ADDX
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
 K DIC S DIC(0)="EL",DIC="^BNIREC(",DLAYGO=90510,DIADD=1,X=BNIDATE
 S DIC("DR")=".02////"_DT_";.03////"_DUZ_";.06////"_DUZ(2)_";.07///"_DUZ(2)_";.08////"_BNIPRV
 K DD,DO,D0 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"CPHAD Record is NOT complete!!  Deleting Record.",! D PAUSE G ADDX
 ;update multiple of user last update/date edited
 S BNIR=+Y
 S DIE="^BNIREC(",DA=BNIR,DR="1500///NOW",DR(2,90510.0115)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
ADDR1 ;
 S DA=BNIR,DDSFILE=90510,DR=$S($G(BNIADDQ):"[BNIA UPDATE ACTIVITY RECORD]",1:"[BNI UPDATE ACTIVITY RECORD]") D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" D PAUSE G ADDX
 ;check record for completeness
 D CHECKREC
 I Q D  G:BNIA="E" ADDR1  D DELR,PAUSE G ADDX
 .S BNIA="" K DIR
 .S DIR(0)="S^E:Edit and complete the Record;D:Delete the Incomplete Record",DIR("A")="Do you wish to",DIR("B")="E" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BNIA="D"
 .S BNIA=Y
ADDX ;
 D BACK
 Q
CHECKREC ;
 D FULL^VALM1,CLEAR^VALM1
 S Q="" F F=.07,.08,.09,.11,.12,.13 I $P(^BNIREC(BNIR,0),U,+$P(F,".",2))="" D
 .W !,$P(^DD(90510,F,0),U)," is a required field and is missing." S Q=1
 I $P($G(^BNISITE(BNISITE,0)),U,2),$P(^BNIREC(BNIR,0),U,15)="" D
 .W !,"ACTIVITY SETTING is required and is missing." S Q=1
 S X=$P(^BNIREC(BNIR,0),U,11) I X,$P(^BNIGHC(X,0),U,3),$P($G(^BNIREC(BNIR,11)),U,1)="" D
 .W !,"GENERAL HEALTH CONCERN is ",$P(^BNIGHC(X,0),U),!,"   and the text of GENERAL HEALTH CONCERN (OTHER) is missing." S Q=1
 S X=$P(^BNIREC(BNIR,0),U,12) I X,$P(^BNISHT(X,0),U,5),$P($G(^BNIREC(BNIR,11)),U,2)="" D
 .W !,"SPECIFIC HEALTH TOPIC is ",$P(^BNISHT(X,0),U),!,"   and the text of SPECIFIC HEALTH TOPIC (OTHER) is missing." S Q=1
 S X=$P(^BNIREC(BNIR,0),U,13) I X,$P(^BNITOA(X,0),U,3),$P($G(^BNIREC(BNIR,11)),U,3)="" D
 .W !,"TYPE OF ACTIVITY is ",$P(^BNITOA(X,0),U),!,"   and the text of TYPE OF ACTIVITY (OTHER) is missing." S Q=1
 S X=$P(^BNIREC(BNIR,0),U,14) I X,$P(^BNIGS(X,0),U,3),$P($G(^BNIREC(BNIR,12)),U,1)="" D
 .W !,"GROUP SERVED is ",$P(^BNIGS(X,0),U),!,"   and the text of GROUP SERVED (OTHER) is missing." S Q=1
 S X=$P(^BNIREC(BNIR,0),U,15) I X,$P(^BNIAS(X,0),U,3),$P($G(^BNIREC(BNIR,0)),U,16)="" D
 .W !,"ACTIVITY SETTING is ",$P(^BNIAS(X,0),U),!,"   and the COMMUNITY is missing." S Q=1
 Q
DELR ;
 W !!,"Deleting CPHAD record for ",$$VAL^XBDIQ1(90510,BNIR,.01)
 S DA=BNIR,DIK="^BNIREC(" D ^DIK K DIK,DA
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
BACK ;EP
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 S VALMCNT=BNIRCNT
 Q
 ;
EDITR ;EP - called from protocol
 K DIR S DIR(0)="N^1:"_BNIRCNT_":0",DIR("A")="Edit Which Record" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No record selected." D PAUSE G EDITX
 S BNIR1=+Y I 'BNIR1 K VALMY,XQORNOD W !,"No record selected." D PAUSE G EDITX
 S BNIR=^TMP("BNIRECS",$J,"IDX",BNIR1,BNIR1) I 'BNIR K BNIRDEL,BNIR D PAUSE G EDITX
 I '$D(^BNIREC(BNIR,0)) W !,"Not a valid CPHAD RECORD." K BNIRDEL,BNIR D PAUSE G EDITX
 D FULL^VALM1
 W:$D(IOF) @IOF W !,"You are editing the following record:",!!,VALMHDR(4),!,$$REPEAT^XLFSTR("-",80),! W ^TMP("BNIRECS",$J,BNIR1,0),!!!
 D FULL^VALM1
EDIT ;EP
 S DIADD=1,DIE="^BNIREC(",DA=BNIR,DR="1500///NOW",DR(2,90510.0115)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR,DIADD
EDIT1 ;
 S DA=BNIR,DDSFILE=90510,DR=$S($G(BNIADDQ):"[BNIA UPDATE ACTIVITY RECORD]",1:"[BNI UPDATE ACTIVITY RECORD]") D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" D PAUSE G BACK
 ;check record for completeness
 D CHECKREC
 I Q D  G:BNIA="E" EDIT1  D DELR,PAUSE G EDITX
 .S BNIA="" K DIR
 .S DIR(0)="S^E:Edit and complete the Record;D:Delete the Incomplete Record",DIR("A")="Do you wish to",DIR("B")="E" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BNIA="D"
 .S BNIA="E"
EDITX ;
 D BACK
 Q
DISPR ;EP - called from protocol to display a record
 K DIR S DIR(0)="N^1:"_BNIRCNT_":0",DIR("A")="Display Which Record" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No record selected." D PAUSE G DISPX
 S BNIR1=+Y I 'BNIR1 K VALMY,XQORNOD W !,"No record selected." D PAUSE G DISPX
 S BNIR=^TMP("BNIRECS",$J,"IDX",BNIR1,BNIR1) I 'BNIR K BNIRDEL,BNIR D PAUSE G DISPX
 I '$D(^BNIREC(BNIR,0)) W !,"Not a valid CPHAD RECORD." K BNIRDEL,BNIR D PAUSE G DISPX
 D FULL^VALM1
 S BNIREC=BNIR D ^BNIRD
DISPX ;
 D BACK
 Q
DELETER ;EP - called from protocol to display a record
 K DIR S DIR(0)="N^1:"_BNIRCNT_":0",DIR("A")="Delete Which Record" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No record selected." D PAUSE G DELETERX
 S BNIR1=+Y I 'BNIR1 K VALMY,XQORNOD W !,"No record selected." D PAUSE G DELETERX
 S BNIR=^TMP("BNIRECS",$J,"IDX",BNIR1,BNIR1) I 'BNIR K BNIRDEL,BNIR D PAUSE G DELETERX
 I '$D(^BNIREC(BNIR,0)) W !,"Not a valid CPHAD RECORD." K BNIRDEL,BNIR D PAUSE G DELETERX
 D FULL^VALM1
 ;
 S DA=BNIR,DIC="^BNIREC(" D EN^DIQ
 W !! S DIR(0)="Y",DIR("A")="Are you sure you want to DELETE this record",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) DELETERX
 G:'Y DELETERX
 D DELR
DELETERX ;
 D BACK
 Q
ATIP(X) ;EP - called from input transform on activity time field
 I '$G(X) D EN^DDIOL(" * must be a value greated than 0 *") Q 0
 I $P(X,".",2)="" Q 1
 NEW %
 S %=$P(X,".",2)
 I %'="0",%'="25",%'="5",%'="75" Q 0
 Q 1
ALLOW(R) ;EP
 I $D(^BNISITE(BNISITE,12,"B",DUZ)) Q 1  ;allow all with access
 I $P(^BNIREC(R,0),U,8)=DUZ Q 1
 I $P(^BNIREC(R,0),U,3)=DUZ Q 1
 Q 0
