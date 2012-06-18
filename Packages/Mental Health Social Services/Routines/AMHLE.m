AMHLE ; IHS/CMI/LAB - MENTAL HLTH ROUTINE 16-AUG-1994 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;; ;
 ;CMI/TUCSON/LAB - 10/06/97 - PATCH 1 reformat header
START ; Write Header
 D TERM^VALM0
 I AMHDET="R" D  Q:'Y
 .W !!,$G(IORVON)_"The RDE option will be deactivated in the next application release.  Users are"
 .W !,"encouraged to begin utilizing the PDE or SDE options.",$G(IORVOFF),!
 .D PAUSE^AMHLEA
 D EN^AMHEKL ; -- kill all vars before starting
 W:$D(IOF) @IOF
 F J=1:1:5 S X=$P($T(TEXT+J),";;",2) W !?80-$L(X)\2,X
 K X,J
 W !!
 D ^AMHLEIN ;Initialize vars, etc.
 ;loop through until user wants to quit
 S AMHPTYPE="" D GETTYPE Q:AMHPTYPE=""  S AMHDATE="" F  D GETDATE Q:AMHDATE=""  D EN,FULL^VALM1,EXIT
 D EOJ
 Q
 ;
EOJ ;EOJ CLEANUP
 D CLEAR^VALM1
 D EN^AMHEKL
 Q
GETTYPE ;EP
 I $G(AMHPATCE) D FULL^VALM1 W:$D(IOF) @IOF
 S AMHPTYPE=""
 W !,"Please enter the appropriate set of defaults to be used in Data entry.",!,"This applies to default clinic, location, community and program.",!
 S DIR(0)="S^M:MENTAL HEALTH DEFAULTS;S:SOCIAL SERVICES DEFAULTS;C:CHEMICAL DEPENDENCY or ALCOHOL/SUBSTANCE ABUSE;O:OTHER",DIR("A")="Which set of defaults do you want to use in Data Entry" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S AMHPTYPE=Y
 Q
GETDATE ;EP - GET DATE OF ENCOUNTER
 W !!
 S AMHDATE="",DIR(0)="DO^:"_DT_":EPTX",DIR("A")="Enter ENCOUNTER DATE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S AMHDATE=Y
 Q
EN ; EP -- main entry point for AMH UPDATE ACTIVITY RECORDS
 ;S AMHKDTIM=DTIME S:DTIME<3600 DTIME=3600
 S VALMCC=1
 D EN^VALM("AMH UPDATE ACTIVITY RECORDS")
 D CLEAR^VALM1
 ;S DTIME=AMHKDTIM
 K AMHKDTIM
 Q
 ;
HDR ;EP -- header code
 S VALMHDR(1)=AMHDASH
 S VALMHDR(2)="Date of Encounter:  "_$$DOW^XLFDT(AMHDATE)_"  "_$$FTIME^VALM1(AMHDATE)_$S($$ESIGREQ^AMHESIG(,AMHDATE):"      * unsigned note",1:"")
 S VALMHDR(3)=AMHDASH
 I $E($G(^TMP("AMHVRECS",$J,1,0)))="N" S AMHRCNT=0,VALMHDR(4)=^TMP("AMHVRECS",$J,1,0) K ^TMP("AMHVRECS",$J)
 E  S VALMHDR(4)=" #  PRV PATIENT NAME         HRN      LOC  ACT PROB    NARRATIVE"
 Q
 ;
INIT ;EP -- init variables and list array
 ;S VALMSG="Q - Quit ?? for more actions + next screen - prev screen"
 S VALMSG="                               ?? for more actions"
 D GATHER^AMHLEL ;gather up all records for display
 S VALMCNT=AMHRCNT
 I VALMCNT>11 S VALMSG="+ for more contacts, - to back up  ?? for more actions"
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K AMHRCNT,^TMP("AMHVRECS",$J)
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
TEXT ;
 ;;BH Data Entry Module
 ;;
 ;;************************
 ;;* Update BH Visits  *
 ;;************************
 ;;
 Q
DISPDG ;EP
 W !!,"You are processing a record for the following sensitive patient:",!
 W !?5,$P(^DPT(AMHPAT,0),U,1),?40,"DOB: ",$$FMTE^XLFDT($$DOB^AUPNPAT(AMHPAT)),?65,"HRN: ",$$HRN^AUPNPAT(AMHPAT,DUZ(2))
 S X=1 F  S X=$O(AMHRESU(X)) Q:X'=+X  W !,$$CTR^AMHLEIN(AMHRESU(X))
 Q
