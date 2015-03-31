BGP4AUEX ; IHS/CMI/LAB - BUILD SITE GPRA FILES, EXPORT TO AREA ; 05 Nov 2013  12:13 PM
 ;;14.0;IHS CLINICAL REPORTING;;NOV 14, 2013;Build 101
 ;
 ;Thanks to Anne Fughat.  The original routines were written by
 ;Anne Fughat, Phoexnix Area Office.  They were copied into the
 ;BGP namespace and modified for national use.
 ;;Some code in EN taken from the BGP4DGPU routine.
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;; 
 ;;This routine automatically extracts the GPRA data, creates a
 ;;text file, and sends it to the area.  It should be autoqueued
 ;;to run each month via option BGP4AUEX AUTO GPRA EXTRACT.
 ;;$$END
 ;
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
AUTO ;EP -- AUTOQUEUED JOB ENTRY POINT
 ;
 N BGPD,BGPDT,BGPEND,BGPM,BGPY,ZTDTH,BGPSITE,BGPT
 ;
 S Q=0
 F F=.02,4.2,4.3,4.4,4.5,5.1 I $$VAL^XBDIQ1(90241.04,DUZ(2),F)="" S Q=1
 I Q Q  ;W !!,"These values must be entered into the parameter file",!,"before you can run this option.",! D PAUSE^BGP4DU Q
 S BGPSITE=$S($G(BGPLOC):BGPLOC,1:DUZ(2))  ;site who queued report
 S BGPT=$P(^BGPGP2PM(BGPSITE,0),U,2)
 I BGPT="T" D  Q
 .S BGPDT=$$FMADD^XLFDT(DT,-60)
 .S BGPY=$E(BGPDT,1,3)
 .S BGPM=+$E(BGPDT,4,5)
 .S BGPD=$P("31^28^31^30^31^30^31^31^30^31^30^31",U,BGPM)
 .I BGPM=2 S BGPD=BGPD+$$LEAP^XLFDT2(BGPY+1700)
 .S BGPD=$E("00",1,2-$L(BGPD))_BGPD
 .S BGPM=$E("00",1,2-$L(BGPM))_BGPM
 .S BGPEND=BGPY_BGPM_BGPD
 .S ZTDTH=""
 .D QUE(BGPEND)
 S Y=$O(^BGPCTRL("B",2014,0))
 S Y=^BGPCTRL(Y,0)
 ;S BGPEND=$P(Y,U,9)
 S BGPEND=$S(+$E(DT,4,7)<701:$E(DT,1,3)_"0630",1:$E(DT,1,3)+1_"0630")
NT1 ;
 S ZTDTH=""
 D QUE(BGPEND)
 Q
MAN ;EP -- MANUALLY RUN GPRA EXTRACT
 ;
 N BGPEND,DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y,ZTSK,F,Q
 ;
 ;D ^XBKVAR  -user should be in kernel, no need to do this
 ;
 N DIC,BGPSITE
 S BGPSITE=""
 S DIC="^BGPGP2PM(",DIC(0)="AEMQ",DIC("A")="Enter the site to run the extract for: ",DIC("S")="I $P(^(0),U,1)=DUZ(2)" D ^DIC
 I Y=-1 Q
 S BGPSITE=+Y
 I BGPSITE'=DUZ(2) W !,"You need to be logged in as ",$$VAL^XBDIQ1(90241.04,BGPSITE,.01)," to run the report",!,"for that site." G MAN
 S BGPT=$P(^BGPGP2PM(BGPSITE,0),U,2)
 S Q=0
 F F=.02,4.2,4.3,4.4,4.5 I $$VAL^XBDIQ1(90241.04,BGPSITE,F)="" W !,$P(^DD(90241.04,F,0),U,1)," is missing." S Q=1
 I Q W !!,"These values must be entered into the parameter file",!,"before you can run this option.",! D PAUSE^BGP4DU Q
 I BGPT="T" D  G MAN1
 .S BGPDT=$$FMADD^XLFDT(DT,-60)
 .S BGPY=$E(BGPDT,1,3)
 .S BGPM=+$E(BGPDT,4,5)
 .S BGPD=$P("31^28^31^30^31^30^31^31^30^31^30^31",U,BGPM)
 .I BGPM=2 S BGPD=BGPD+$$LEAP^XLFDT2(BGPY+1700)
 .S BGPD=$E("00",1,2-$L(BGPD))_BGPD
 .S BGPM=$E("00",1,2-$L(BGPM))_BGPM
 .S BGPEND=BGPY_BGPM_BGPD
 .S (BGPBD,BGPED,BGPTP)=""
 .S BGPBD=$$FMADD^XLFDT(BGPEND,-364),BGPED=BGPEND,BGPPER=$E(BGPED,1,3)_"0000"
 .S BGPVDT=3000000 ;***HARD CODED TO BASELINE YEAR 2000
 .S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 .S X=X_"0000"
 .S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 .S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 .S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 .S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 S X=$O(^BGPCTRL("B",2014,0))
 S Y=^BGPCTRL(X,0)
 S BGPBD=$S(+$E(DT,4,7)<701:$E(DT,1,3)-1_"0701",1:$E(DT,1,3)_"0701")
 S (BGPEND,BGPED)=$S(+$E(DT,4,7)<701:$E(DT,1,3)_"0630",1:$E(DT,1,3)+1_"0630")
 ;S BGPPBD=$P(Y,U,10),BGPPED=$P(Y,U,11)
 S BGPPBD=$E(BGPBD,1,3)-1_"0701",BGPPED=$E(BGPED,1,3)-1_"0630"
 S BGPBBD=$P(Y,U,12),BGPBED=$P(Y,U,13)
 S BGPPER=$P(Y,U,14)
 S BGPQTR=3
 S BGPVDT=3000000 ;***HARD CODED TO BASELINE YEAR 2000
MAN1 S BGPAMEX=1,BGPERRM=""
 S X=$$DEMOCHK^BGP4UTL2()
 I 'X W !!,"Exiting Report....." D PAUSE^BGP4DU,XIT Q
 W !!,"Specify the community taxonomy to determine which patients will be",!,"included in the report.  You should have created this taxonomy using QMAN.",!
 K BGPTAX
 S BGPTAXI=""
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: "
 S B=$P($G(^BGPSITE(DUZ(2),0)),U,5) I B S DIC("B")=$P(^ATXAX(B,0),U)
 D ^DIC
 I Y=-1 W !!,"Exiting Report..." D PAUSE^BGP4DU,XIT Q
 S BGPTAXI=+Y
 ;S BGPAMFN="BGPGPAM121"_DT_$P(^AUTTLOC(BGPSITE,0),U,10)_$$LZERO^BGP4UTL(BGPLOG)_".TXT"
 W:$D(IOF) @IOF
 W !,$$CTR^BGP4DNG("SUMMARY OF NATIONAL GPRA/GPRAMA REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 S BGPMAN=1
 D QUE(BGPEND)
 I $G(ZTSK) D
 . ;
 . W !,"GPRA EXTRACT QUEUED AS TASK #",ZTSK
 . ;W !!,"The BGPGPAM121"_DT_$P(^AUTTLOC(DUZ(2),0),U,10)_"nnnnnn.TXT file will be sent to the Area Office.",!
 . W ! D PAUSE^BGP4DU
 D XIT
 Q
 ;
QUE(BGPEND,ZTDTH) ;EP
 ;------ QUEUEING CODE
 ;
 I '$G(BGPMAN) D DQ Q   ;AUTO
 ;
 N ZTDESC,ZTRTN,ZTIO
 ;
 S ZTSAVE("BGP*")=""
 S ZTRTN="DQ^BGP4AUEX"
 S ZTDESC="BGP4 AUTO GPRA DATA EXTRACT"
 S ZTIO=""
 D ^%ZTLOAD
 ;
 Q
DQ ;EP -- QUEUED JOB STARTS HERE
 ;
 D EN(BGPEND)
 ;now reschedule for the 1st Friday of next month
 I $G(BGPMAN) Q  ;not manual
 ;GET FIRST OF NEXT MONTH AND RESCHEDULE
 ;ADD 1 UNTIL DAY IS 01
 S X=DT F  S X=$$FMADD^XLFDT(X,1) Q:$E(X,6,7)="01"
 S BGPX=$$FRIDAY(X)
 S ZTDTH=BGPX
 S ZTSAVE("BGP*")=""
 S ZTRTN="AUTO^BGP4AUEX"
 S ZTDESC="BGP4 AUTO GPRA DATA EXTRACT"
 S ZTIO=""
 D ^%ZTLOAD
 K BGPEND
 Q
EN(BGPEND) ;EP -- MAIN ENTRY POINT
 ;
 ;      INPUT:
 ;      BGPEND  =  REPORT END DATE
 ;
 N BGPED,BGPPER,BGPRTYPE,BGP1RPTH,BGP1GPU,BGPBD,BGPED,BGPTP,BGPVDT
 N X,BGPBBD,BGPBED,BGPPBD,BGPPED,BGPTAX,BGPBEN,BGPBENF
 N BGPHOME,BGPINDJ,BGPEXPT,BGPEXCEL,BGPUF,BGPQUIT,BGPRPT,BGPFILE
 ;
 ;D ^XBKVAR - KERNAL VARS SHOULD BE SET UP BY TASKMAN
 ;
 S BGPAMEX=1  ;in automated
 S BGPRTYPE=1,BGP1RPTH="",BGP1GPU=1
 S (BGPBD,BGPED,BGPTP)=""
 S BGPT=$P(^BGPGP2PM(BGPSITE,0),U,2)
 I BGPT="G" D
 .S X=$O(^BGPCTRL("B",2014,0))  ;get GPRA year dates
 .;per Megan - run automated report for gpra year dates
 .;
 .S Y=^BGPCTRL(X,0)
 .S BGPBD=$S(+$E(DT,4,7)<701:$E(DT,1,3)-1_"0701",1:$E(DT,1,3)_"0701")
 .S (BGPEND,BGPED)=$S(+$E(DT,4,7)<701:$E(DT,1,3)_"0630",1:$E(DT,1,3)+1_"0630")
 .;S BGPPBD=$P(Y,U,10),BGPPED=$P(Y,U,11)
 .S BGPPBD=$E(BGPBD,1,3)-1_"0701",BGPPED=$E(BGPED,1,3)-1_"0630"
 .S BGPBBD=$P(Y,U,12),BGPBED=$P(Y,U,13)
 .S BGPPER=$P(Y,U,14)
 .S BGPQTR=3
 .S BGPVDT=3000000 ;***HARD CODED TO BASELINE YEAR 2000
 I BGPT="T" D
 .S (BGPBD,BGPED,BGPTP)=""
 .S BGPBD=$$FMADD^XLFDT(BGPEND,-364),BGPED=BGPEND,BGPPER=$E(BGPED,1,3)_"0000"
 .S BGPVDT=3000000 ;***HARD CODED TO BASELINE YEAR 2000
 .S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 .S X=X_"0000"
 .S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 .S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 .S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 .S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
COM ;
 S BGPTAXI=$P($G(^BGPGP2PM(DUZ(2),5)),U)
 S X=0
 I BGPTAXI F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 . S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 S BGPBEN=1
 S BGPBENF="Indian/Alaskan Native (Classification 01)"
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 S X=0 F  S X=$O(^BGPINDJ("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDJ="G"
 S BGPEXPT=1
 S BGPEXCEL=""
 S BGPUF=$$GETDIR^BGP4UTL2()
 D REPORT^BGP4UTL   ;***CREATES THE ENTRIES IN THE BGP 14 DATA FILES AND RETURNS BGPRPT
 I $G(BGPQUIT) D XIT Q
 I BGPRPT="" D XIT Q
 S BGPAMFN="BGPAM140"_BGPEND_$P(^AUTTLOC(BGPSITE,0),U,10)_$$LZERO^BGP4UTL(BGPRPT,6)_".TXT"
 D ^BGP4D1
 D GS^BGP4UTL  ;***CREATES BG140 FILE
 S BGPFILE=BGPAMFN
 D LOG(BGPFILE,BGPBD,BGPEND,BGPERRM)
 D XIT
 Q
LOG(BGPFILE,BGPBD,BGPEND,BGPERRM) ;
 ;----- LOG EXTRACT DATE AND FILE NAME
 ;
 N DA,DD,DIC,DIE,DO,DR,X,Y
 ;
 S X=$$NOW^XLFDT
 S DA(1)=BGPSITE
 S DIC="^BGPGP2PM("_DA(1)_",8,"
 S DIC(0)=""
 D FILE^DICN
 Q:+Y'>0
 S DA=+Y
 S DIE=DIC
 S DR=".02///"_BGPFILE_";.03///"_BGPBD_";.04///"_BGPEND_";.05///"_BGPERRM
 D ^DIE
 Q
ASUFAC() ;
 ;---- RETURNS ASUFAC OF MAIN SITE IN RPMS SITE FILE
 ;
 N Y
 S Y=""
 S Y=$P($G(^AUTTLOC(+$P($G(^AUTTSITE(1,0)),U),0)),U,10)
 Q Y
FRIDAY(DT) ;
 ;----- RETURNS DATE/TIME FOR THE NEXT FRIDAY BEGINNING WITH DT
 ;      Prevents the auto job from running on a weekday which could spill
 ;      over into business hours impacting system performance.  This will
 ;      find the first Friday after the date passed in DT.  If the date
 ;      passed is already a Friday it returns the original date passed.
 ;      The time of 22:00 is concatenated to the date.     
 ;
 N X,Y
 S Y=""
 S X=DT,BGPDT=DT
 D DW^%DTC
 I X'="FRIDAY" D
 . S BGPDT=DT
 . F  D  Q:X="FRIDAY"
 . . S (X,BGPDT)=$$FMADD^XLFDT(BGPDT,1)
 . . D DW^%DTC
 S Y=BGPDT_".22"
 Q Y
XIT ;
 D ^%ZISC
 D EN^XBVK("BGP") I $D(ZTQUEUED) S ZTREQ="@"
 K DIRUT,DUOUT,DIR,DOD
 K DIADD,DLAYGO
 D KILL^AUPNPAT
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K BD,ED
 D KILL^AUPNPAT
 D ^XBFMK
 Q
AUTOEX ;EP
 NEW XBGL S XBGL="BGPDATA"
 S F=BGPAMFN
 NEW XBFN,XBMED,XBF,XBFLT
 S XBMED="F",XBFN=F,XBTLE="SAVE OF CRS AUTOMATED DATA",XBF=0,XBFLT=1
 S XBS1="BGP GPRA AUTO SEND "_$P(^AUTTLOC(BGPSITE,0),U,10)
 S XBUF=BGPUF D ^XBGSAVE
 S BGPERRM=""
 I XBFLG'=0 D
 . I XBFLG(1)="" S BGPERRM="GPRA DATA file successfully created"
 . I XBFLG(1)]"" S BGPERRM="GPRA DATA file NOT successfully created"
 . S BGPERRM="File was NOT successfully transferred. "_XBFLG(1)
 L -^BGPDATA
 K ^TMP($J),^BGPDATA ;NOTE:  kill of unsubscripted global for use in export to area.
 Q
 ;
SITEPAR ;EP - called from option
 ;GET ENTRY
 ;
 W !!,"This option is used by Area Office personnel to set up an"
 W !,"automated GPRA extract for the site you select.  All "
 W !,"questions are mandatory and must be answered before the"
 W !,"first extract will be queued to run.",!,"You must be logged into the site for which you want to schedule",!,"this extract.",!!
 ;
 S DIC(0)="AEMQL",DIC="^BGPGP2PM(",DIC("S")="I $P(^(0),U,1)=DUZ(2)" D ^DIC K DIC
 I Y=-1 K Y Q
 S (BGPSITE,BGPLOC)=+Y
 S BGPTASK=$$CHKFQT(BGPSITE)  ;check for currently queued task, allow user to edit params or to delete scheduled task
 I BGPTASK D EDITDEL Q
 D EDITPAR
 D SCHED
 ;D QUE
 Q
SCHED ;EP -scedule task in option scheduling
 K DIR,DIRUT S DIR(0)="Y",DIR("A")="Do you wish to continue to schedule this monthly" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
SCHEDGUI  ;EP - gui entry point to schedule
 S BGPERR="",BGPX=""
 ;get 1st Friday of this month, if it is already passed find 1st Friday of next month.
 ;
 S BGPX=$$FRIDAY($E(DT,1,5)_"00")
 I $P(BGPX,".")<DT D
 .S BGPX=$E(DT,4,5),BGPX=$S(+BGPX="12":"01",1:BGPX+1),BGPX=$S($L(BGPX)=1:"0"_BGPX,1:BGPX),BGPX=$S(BGPX="01":$E(DT)_($E(DT,2,3)+1)_BGPX_"00",1:$E(DT,1,3)_BGPX_"00")
 .S BGPX=$$FRIDAY(BGPX)
 G NT
 ;
 S BGPX=$$FMADD^XLFDT($$NOW^XLFDT,,,5) ;LORI TAKE OUT WHEN DONE TESTING
NT ;
 D BMES^XPDUTL("SETTING OPTION 'BGP 14 AUTO GPRA EXTRACT' to run in taskman")
 ;
 ;S BGPOPT="BGP 14 AUTO GPRA EXTRACT"
 ;S BGPOPTD0=$O(^DIC(19,"B",BGPOPT,0))
 ;I 'BGPOPTD0 D  Q
 ;. D BMES^XPDUTL("'BGP 14 AUTO GPRA EXTRACT' OPTION NOT FOUND!")
 ;Q:'BGPOPTD0
 ;S BGPD0=$O(^DIC(19.2,"B",BGPOPTD0,0))
 ;D ADDOPT(BGPOPTD0,.BGPD0)
 ;I 'BGPD0 D  Q
 ;. D BMES^XPDUTL("UNABLE TO SCHEDULE OPTION 'BGP 14 AUTO GPRA EXTRACT'")
 ;D RESCH^XUTMOPT("BGP 14 AUTO GPRA EXTRACT",BGPX,"","1M","L",.BGPERR)
 ;D; EDITOPT(BGPD0)
 ;S BGPTSK=+$G(^DIC(19.2,BGPD0,1))
 S ZTDTH=BGPX
 S ZTSAVE("BGP*")=""
 S ZTRTN="AUTO^BGP4AUEX"
 S ZTDESC="BGP4 AUTO GPRA DATA EXTRACT"
 S ZTIO=""
 D ^%ZTLOAD
 S BGPTSK=$G(ZTSK)
 D BMES^XPDUTL("OPTION 'BGP4 AUTO GPRA EXTRACT' SCHEDULED AS TASK #"_BGPTSK)
 Q
ADDOPT(BGPOPTD0,BGPD0) ;
 ;----- ADD OPTION TO OPTION SCHEDULING FILE
 ;
 N DD,DIC,DO,X,Y
 ;
 S BGPD0=0
 S X=BGPOPTD0
 S DIC="^DIC(19.2,"
 S DIC(0)=""
 D FILE^DICN
 Q:+Y'>0
 S BGPD0=+Y
 Q
EDITOPT(BGPD0) ;
 ;----- EDIT OPTION SCHEDULING OPTION
 ;
 N %DT,%L,%X,%Y,BGPDT,BGPF,DIFROM,D,D0,DA,DI,DIC,DIE,DIE,DQ,DR,X,Y
 ;
 S BGPF="1M"
 S DA=BGPD0
 S DIE="^DIC(19.2,"
 S DR="2///^S X=BGPX;6///^S X=BGPF"
 D ^DIE
 Q
 ;
EDITPAR ;
 S DA=BGPSITE,DIE="^BGPGP2PM(",DR=".02;5.1;4.2;4.3;4.4;4.5" D ^DIE
 S Q=0
 F F=.02,4.2,4.3,4.4,4.5,5.1 I $$VAL^XBDIQ1(90241.04,BGPSITE,F)="" W !!,$P(^DD(90241.04,F,0),U,1)," is missing." S Q=1
 I Q W !!,"These values must be entered into the parameter file",!,"before you can schedule the automated report option.",! D PAUSE^BGP4DU Q
 S BGPZIB=$O(^%ZIB(9888888.93,"B","BGP GPRA AUTO SEND "_$P(^AUTTLOC(BGPSITE,0),U,10),0))
 I 'BGPZIB D CZIB
 I 'BGPZIB Q
 S DA=BGPZIB,DIE="^%ZIB(9888888.93,",DR=".02///"_$P($G(^BGPGP2PM(BGPSITE,4)),U,2)_";.05///"_$P($G(^BGPGP2PM(BGPSITE,4)),U,3)_";.03///"_$P($G(^BGPGP2PM(BGPSITE,4)),U,4)_";.04///"_$P($G(^BGPGP2PM(BGPSITE,4)),U,5)
 D ^DIE
 K DA,DIE,DR
 Q
CZIB ;create entry in ZISH SEND PARAMETERS
 S BGPZIB=""
 K DIADD,DLAYGO,DIC,DD,D0,DO
 S X="BGP GPRA AUTO SEND "_$P(^AUTTLOC(BGPSITE,0),U,10),DIC(0)="L",DIC="^%ZIB(9888888.93," D FILE^DICN
 I Y=-1 W !!,"error creating ZISH SEND PARAMETERS entry" Q
 S (BGPZIB,DA)=+Y,DIE="^%ZIB(9888888.93,",DR=".06///-u;.07///B;.08///sendto"
 D ^DIE
 I $D(Y) W !!,"error updating ZISH SEND PARAMETERS entry, NOTIFY IT" Q
 K DIADD,DLAYGO,DIC,DD,D0,DO
 Q
CHKFQT(F) ;EP -check for queued task (BGP AUTO GPRA EXTRACT and BGPSITE variable within the task
 NEW X,Y,Z,Q
 S F=$G(F)
 S Y=$$FMTH^XLFDT(DT)
 S Q=""  ;not found
 S X=0
 F  S X=$O(^%ZTSK(X)) Q:X'=+X  D
 .Q:$P($G(^%ZTSK(X,0)),U,1,2)'="AUTO^BGP4AUEX"
 .Q:$P($G(^%ZTSK(X,.03)),U,1)'="BGP4 AUTO GPRA DATA EXTRACT"  ;"BGP 14 AUTO GPRA EXTRACT"  ;not the gpra export
 .S Z=$P($G(^%ZTSK(X,.3,"DUZ(",2)),U,1)
 .Q:Z'=F
 .Q:$P($G(^%ZTSK(X,0)),U,6)<Y
 .S Q=X  ;found it scheduled
 Q Q
EDITDEL ;does user just want to edit the parameters or delete the scheduled task?
 W !!,"It seems that the automated GPRA extract is already scheduled to run."
 W !,"You can't schedule it to run twice, but you can edit the parameters"
 W !,"or delete the scheduled task so it won't run in the future.",!!
 S DIR(0)="S^E:Edit Auto Extract Parameters;D:Delete/Unschedule the Auto Extract Task;Q:Quit, I don't want to do either"
 S DIR("A")="Which would you like to do",DIR("B")="E"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y="Q" Q
 I Y="E" D EDITPAR Q
 I Y="D" D DELTASK Q
 Q
DELTASK ;EP
 ;CHECK STATUS OF TASK - IF RUNNING WARN USER TO DO THIS LATER
 S ZTSK=BGPTASK
 D STAT^%ZTLOAD
 I ZTSK(1)=2,ZTSK(2)="Active: Running" W !!,"The task may be currently running.  Please try this later." K ZTSK
 S ZTSK=BGPTASK
 D KILL^%ZTLOAD
 W !!,"Deleted Task ",BGPTASK,!
 K ZTSK
 Q
