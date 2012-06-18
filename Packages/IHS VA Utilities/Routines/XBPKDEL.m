XBPKDEL ; IHS/ADC/GTH - REMOVE OPTIONS, INPUT,SORT,PRINT TEMPLATES, HELP FRAMES, BULLETINS, FUNCTIONS, AND IF INDICATED, SECURITY KEYS FOR A PACKAGE ; [ 12/11/2000   3:13 PM ]
 ;;3.0;IHS/VA UTILITIES;**8**;FEB 07, 1997
 ; XB*3*8 - IHS/ASDST/GTH - 12-07-00 - Also delete Forms, Protocols, and List templates. Add support for routine XBPKDEL1.
 ;
 ; XBPKNSP must be set to the namespace, e.g. "AICD" if this
 ; routine is called from a preinit.
 ;
 ; If you want security keys deleted, set XBPKEY=1 if this
 ; routine is called from a preinit.
 ;
 ; Call LIST^XBPKDEL to list all namespaced options,
 ; templates, etc.
 ;
 ; Call RUN^XBPKDEL to delete all namespaced options,
 ; templates, etc.
 ;
 ; The RUN and LIST entry points are for programmer use and
 ; are not to be called from a preinit.  Preinit calls
 ; XBPKDEL directly with variables set as indicated above.
 ;
START ;
 I '$D(^DIC(0)) W !,*7,"Filemanager does not exist in this UCI!" Q
 I '$D(XBPKNSP) W !,*7,"Namespace variable does not exist!" Q
 S U="^",DUZ(0)="@",XBPKQUIT=XBPKNSP_"{"
 I $D(XBPKRUN) S XBPKDOC="This routine"
 E  S XBPKDOC="The preinit for this package"
 D ASK
 G:XBPKSTP A
 ; F XBPKGLO="^DIBT(","^DIPT(","^DIE(","^DIC(19,","^XMB(3.6,","^DIC(9.2,","^DD(""FUNC""," D DELETE ; XB*3*8
 F XBPKGLO="^DIBT(","^DIPT(","^SD(409.61,","^DIE(","^DIST(.403,","^DIC(19,","^XMB(3.6,","^DIC(9.2,","^DD(""FUNC"",","^ORD(101," D DELETE ; XB*3*8
 I $D(XBPKEY) S XBPKGLO="^DIC(19.1," D DELETE ;DELETE SECURITY KEYS WITH THIS NAMESPACE
 W !
 S %=1 D ENASK^XQ3 ;CALL TO FIX OPTION POINTERS
 W !,*7,"Be sure to give users a new primary menu option if one of the menu options",!,"deleted within this namespace had been used as a primary menu option."
A ;
 D EOJ
 Q
 ;
ASK ;ASK USER IF WANTS TO CONTINUE
 S XBPKSTP=0
 ; W !!,*7,XBPKDOC," will delete all options, sort, input," ; XB*3*8
 ; W !,"and print templates, bulletins, functions, " ; XB*3*8
 ; W $S($D(XBPKEY):"help frames and security keys",1:"and help frames") ; XB*3*8
 ; W !,"namespaced '",XBPKNSP,"' that are currently in this UCI.  " ; XB*3*8
 ; XB*3*8 begin block
 KILL ^UTILITY($J,"W")
 NEW DIW,DIWL,DIWR,DIWF,DIWT
 S DIWL=1,DIWR=(IOM-10),DIWF="W"
 W !!,*7
 S X=XBPKDOC
 D ^DIWP
 S X="will delete all options, templates (sort, input, list, and print), forms, bulletins, functions, protocols, "
 D ^DIWP
 S X=$S($D(XBPKEY):"help frames and security keys",1:"and help frames")_" namespaced '"_XBPKNSP_"' that are currently in this UCI."
 D ^DIWP,^DIWW
 KILL ^UTILITY($J,"W")
 ; XB*3*8 end block
 W !,"Do you want to continue"
 S %=1
 D YN^DICN
 I %=0 W !!,"If you answer with a ""NO"" or a ""^"" I will stop package initialization.",! G ASK
 I %=2!(%=-1) W:'$D(XBPKRUN) !!,*7,"Package initialization process stopped!" S XBPKSTP=1 KILL DIFQ ;KILLING DIFQ STOPS THE INITIALIZATION PROCESS
 W !
 Q
 ;
DELETE ;
 W !!,"Now deleting `",XBPKNSP,"' namespaced ",$P(@(XBPKGLO_"0)"),U),"S..."
 S XBPKNSPC=XBPKNSP
 I $D(@(XBPKGLO_"""B"",XBPKNSPC)")) S DA=$O(@(XBPKGLO_"""B"",XBPKNSPC,"""")")),DIK=XBPKGLO D ^DIK KILL DIK,DA
 ; F L=0:0 S XBPKNSPC=$O(@(XBPKGLO_"""B"",XBPKNSPC)")) Q:XBPKNSPC=""!(XBPKNSPC]XBPKQUIT)  S DA=$O(@(XBPKGLO_"""B"",XBPKNSPC,"""")")) W !?3,XBPKNSPC S DIK=XBPKGLO D ^DIK KILL DIK,DA ; XB*3*8
 F L=0:0 S XBPKNSPC=$O(@(XBPKGLO_"""B"",XBPKNSPC)")) Q:XBPKNSPC=""!(XBPKNSPC]XBPKQUIT)  S DA=$O(@(XBPKGLO_"""B"",XBPKNSPC,"""")")) W !?3,XBPKNSPC D  S DIK=XBPKGLO D ^DIK KILL DIK,DA ; XB*3*8
 . ; XB*3*8 begin block
 . ; Delete key from holders
 . Q:XBPKGLO'="^DIC(19.1,"
 . S XBPKKIEN=DA
 . NEW DA
 . S XBPKHIEN=0
 . F  S XBPKHIEN=$O(^XUSEC(XBPKNSPC,XBPKHIEN)) Q:'XBPKHIEN  D
 .. S DIE="^VA(200,XBPKHIEN,51,",DA(1)=XBPKHIEN,DA=XBPKKIEN,DR=".01///@"
 .. D ^DIE
 .. Q
 . Q
 ; XB*3*8 end block
 Q
 ;
LIST ; ENTRY POINT FOR LISTING NAMESPACED ITEMS
 I '$D(^DIC(0)) W !,*7,"Filemanager does not exist in this UCI!" Q
 S U="^",DUZ(0)="@"
 W !!,"Utility to list all namespaced items in current UCI",!
 D GETNSP
 G:XBPKNSP["^"!("^"[XBPKNSP) EOJ
 ; W !!,"Listing of items in namespace ",XBPKNSP,! ; XB*3*8
 W @IOF,!!,"Listing of items in namespace ",XBPKNSP,! ; XB*3*8
 W "--------------------------------------",!
 S XBPKQUIT=XBPKNSP_"{",XBPKF=0
 ; F XBPKGLO="^DIBT(","^DIPT(","^DIE(","^DIC(19,","^DIC(19.1,","^XMB(3.6,","^DIC(9.2,","^DD(""FUNC""," D LIST2 ; XB*3*8
 F XBPKGLO="^DIBT(","^DIPT(","^SD(409.61,","^DIE(","^DIST(.403,","^DIC(19,","^DIC(19.1,","^XMB(3.6,","^DIC(9.2,","^DD(""FUNC"",","^ORD(101," D LIST2 ; XB*3*8
 G EOJ
 ;
LIST2 ;
 S XBPKNSPC=$O(@(XBPKGLO_"""B"",XBPKNSP)"))
 I $P(XBPKNSPC,XBPKNSP)]"" W:XBPKF ! S XBPKF=0 W "NO ",$P(@(XBPKGLO_"0)"),"^",1),"S",! Q
 S XBPKF=1
 W !,$P(@(XBPKGLO_"0)"),"^",1),"S",!
 S XBPKNSPC=XBPKNSP
 F  Q:$D(DUOUT)  S XBPKNSPC=$O(@(XBPKGLO_"""B"",XBPKNSPC)")) Q:XBPKNSPC=""!(XBPKNSPC]XBPKQUIT)  S DA=$O(@(XBPKGLO_"""B"",XBPKNSPC,"""")")) W ?3,XBPKNSPC,! I $Y>(IOSL-5) D PAUSE
 Q
 ;
PAUSE ; Screen control for LIST
 S Y=$$DIR^XBDIR("E")
 ; W @IOF ; XB*3*8
 W @IOF,! ; XB*3*8
 Q
 ;
RUN ; ENTRY POINT FOR ACQUIRING CONTROL ARGUMENTS AND DOING DELETIONS
 I '$D(^DIC(0)) W !,*7,"Filemanager does not exist in this UCI!" Q
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) W !,"PROGRAMMER ACCESS REQUIRED",! Q
 W !!,"Utility to delete all namespaced items in current UCI",!
 D GETNSP
 G:XBPKNSP["^"!("^"[XBPKNSP) EOJ
 D GETKEY
 I $D(XBPKEY),XBPKEY="^" G EOJ
 S XBPKRUN=""
 G XBPKDEL
 ;
GETNSP ; CODE TO ACQUIRE NAMESPACE
 R "Namespace to process: ",XBPKNSP:600,!
 Q:("^"[XBPKNSP)!(XBPKNSP["^")
 I XBPKNSP["?" W "Enter null line or '^' to quit.",!
 I XBPKNSP'?1U1.7UN W "Namespace must begin with an upper-case letter and",!," consist only of upper-case letters and numbers",! G GETNSP
 Q
 ;
GETKEY ; CODE TO ACQUIRE SECURITY KEY FLAG
 W "Do you want to delete security keys"
 S %=1
 D YN^DICN
 I %=0 W !!,"If you answer with a ""NO"" security keys will not be deleted.",! G ASK
 I %=2!(%=-1) S:%=-1 XBPKEY="^"
 E  S XBPKEY=""
 Q
 ;
EOJ ;EP - Clean up after this routine or XBPKDEL1 ; XB*3*8
 ; KILL XBPKF,XBPKGLO,XBPKEY,XBPKSTP,XBPKNSP,XBPKNSPC,XBPKQUIT,XBPKRUN,XBPKDOC,DUOUT,DTOUT ; XB*3*8
 KILL XBPKF,XBPKGLO,XBPKHIEN,XBPKKIEN,XBPKEY,XBPKSTP,XBPKNSP,XBPKNSPC,XBPKQUIT,XBPKRUN,XBPKDOC,DUOUT,DTOUT ; XB*3*8
 Q
 ;
