%AUPKDEL ;DG/TPA;REMOVE OPTIONS, INPUT,SORT,PRINT TEMPLATES, HELP FRAMES, BULLETINS, FUNCTIONS,, AND IF INDICATED, SECURITY KEYS FOR A PACKAGE [ 07/19/89  11:48 AM ]
 ;
 ;;AUPKNSP must be set to the namespace, i.e. "AICD" if this routine is called from a preinit.
 ;;If you want security keys deleted, set AUPKEY=1 if this routine is called from a preinit
 ;;
 ;;Call LIST^%AUPKDEL to list all namespaced options, templates, etc.
 ;;Call RUN^%AUPKDEL to delete all namespaced options, templates, etc.
 ;;The RUN and LIST entry points are for programmer use and are not to
 ;;be called from a preinit.  Preinit calls %AUPKDEL directly with
 ;;variables set as indicated above
 ;
 I '$D(^DIC(0)) W !,*7,"Filemanager does not exist in this UCI!" Q
 I '$D(AUPKNSP) W !,*7,"Namespace variable does not exist!" Q
 S U="^",DUZ(0)="@",AUPKQUIT=AUPKNSP_"{"
 I $D(AUPKRUN) S AUPKDOC="This routine"
 E  S AUPKDOC="The preinit for this package"
 D ASK G:AUPKSTP A
 F AUPKGLO="^DIBT(","^DIPT(","^DIE(","^DIC(19,","^XMB(3.6,","^DIC(9.2,","^DD(""FUNC""," D DELETE
 I $D(AUPKEY) S AUPKGLO="^DIC(19.1," D DELETE ;DELETE SECURITY KEYS WITH THIS NAMESPACE
 W !
 S %=1 D ENASK^XQ3 ;CALL TO FIX OPTION POINTERS
 W !,*7,"Be sure to give users a new primary menu option if one of the menu options",!,"deleted within this namespace had been used as a primary menu option."
A D EOJ
 Q
 ;
ASK ;ASK USER IF WANTS TO CONTINUE
 S AUPKSTP=0
 W !!,*7,AUPKDOC," will delete all options, sort,input,print templates,",!,"bulletins, functions, ",$S($D(AUPKEY):"help frames and security keys",1:"and help frames")," namespaced `",AUPKNSP,"' "
 I $D(AUPKEY) W !,"that are currently in this UCI.  "
 E  W !,"that are currently in this UCI.  "
 W "Do you want to continue" S %=1 D YN^DICN
 I %=0 W !!,"If you answer with a ""NO"" or a ""^"" I will stop package initialization.",! G ASK
 I %=2!(%=-1) W:'$D(AUPKRUN) !!,*7,"Package initialization process stopped!" S AUPKSTP=1 K DIFQ ;KILLING DIFQ STOPS THE INITIALIZATION PROCESS
 W ! Q
 ;
DELETE ;
 W !!,"Now deleting `",AUPKNSP,"' namespaced ",$P(@(AUPKGLO_"0)"),U)_"S..."
 S AUPKNSPC=AUPKNSP
 I $D(@(AUPKGLO_"""B"",AUPKNSPC)")) S DA=$O(@(AUPKGLO_"""B"",AUPKNSPC,"""")")),DIK=AUPKGLO D ^DIK K DIK,DA
 F L=0:0 S AUPKNSPC=$O(@(AUPKGLO_"""B"",AUPKNSPC)")) Q:AUPKNSPC=""!(AUPKNSPC]AUPKQUIT)  S DA=$O(@(AUPKGLO_"""B"",AUPKNSPC,"""")")) W !,?3,AUPKNSPC S DIK=AUPKGLO D ^DIK K DIK,DA
 Q
 ;
LIST ; ENTRY POINT FOR LISTING NAMESPACED ITEMS
 I '$D(^DIC(0)) W !,*7,"Filemanager does not exist in this UCI!" Q
 S U="^",DUZ(0)="@"
 W !!,"Utility to list all namespaced items in current UCI",!
 D GETNSP G:AUPKNSP="" EOJ
 W !!,"Listing of items in namespace ",AUPKNSP,!
 W "--------------------------------------",!
 S AUPKQUIT=AUPKNSP_"{"
 S %=0
 F AUPKGLO="^DIBT(","^DIPT(","^DIE(","^DIC(19,","^DIC(19.1,","^XMB(3.6,","^DIC(9.2,","^DD(""FUNC""," D LIST2
 G EOJ
LIST2 ;
 S AUPKNSPC=$O(@(AUPKGLO_"""B"",AUPKNSP)"))
 I $P(AUPKNSPC,AUPKNSP)'="" W:% ! S %=0 W "NO ",$P(@(AUPKGLO_"0)"),"^",1),"S",! Q
 S %=1
 W !,$P(@(AUPKGLO_"0)"),"^",1),"S",!
 S AUPKNSPC=AUPKNSP
 F L=0:0 S AUPKNSPC=$O(@(AUPKGLO_"""B"",AUPKNSPC)")) Q:AUPKNSPC=""!(AUPKNSPC]AUPKQUIT)  S DA=$O(@(AUPKGLO_"""B"",AUPKNSPC,"""")")) W ?3,AUPKNSPC,!
 Q
 ;
RUN ; ENTRY POINT FOR ACQUIRING CONTROL ARGUMENTS AND DOING DELETIONS
 I '$D(^DIC(0)) W !,*7,"Filemanager does not exist in this UCI!" Q
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) W !,"PROGRAMMER ACCESS REQUIRED",! Q
 W !!,"Utility to delete all namespaced items in current UCI",!
 D GETNSP G:AUPKNSP["^"!("^"[AUPKNSP) EOJ
 D GETKEY I $D(AUPKEY),AUPKEY="^" G EOJ
 S AUPKRUN="" G %AUPKDEL
 ;
GETNSP ; CODE TO ACQUIRE NAMESPACE
 R "Namespace to process: ",AUPKNSP:600,!
 Q:("^"[AUPKNSP)!(AUPKNSP["^")
 I AUPKNSP["?" W "Enter null line or '^' to quit.",!
 I AUPKNSP'?1U1.7UN W "Namespace must begin with an upper-case letter and",!," consist only of upper-case letters and numbers",! G GETNSP
 Q
GETKEY ; CODE TO ACQUIRE SECURITY KEY FLAG
 W "Do you want to delete security keys" S %=1 D YN^DICN
 I %=0 W !!,"If you answer with a ""NO"" security keys will not be deleted.",! G ASK
 I %=2!(%=-1) S:%=-1 AUPKEY="^"
 E  S AUPKEY=""
 Q
 ;
EOJ ;
 K AUPKGLO,AUPKEY,AUPKSTP,AUPKNSP,AUPKNSPC,AUPKQUIT,AUPKRUN,AUPKDOC
 Q
 ;
