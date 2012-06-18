XBKERCLN ; IHS/ADC/GTH - CLEAN OUT KERNEL NAMESPACE ITEMS PRIOR TO INSTALL ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine is a modified XBPKDEL for use specifically
 ; to clean out KERNEL package items prior to new KERNEL
 ; install.  This routine does not delete any security keys.
 ;
 D ^XBKVAR,ASK
 G:AUPKSTP EOJ
 F AUPKNSP="XU","XQ","XM","ZT","ZE","ZI","ZR","ZS" D PKDEL
 S %=1
 D ENASK^XQ3 ;CALL TO FIX OPTION POINTERS
 G EOJ
 ;
PKDEL ;
 I '$D(^DIC(0)) W !,*7,"Filemanager does not exist in this UCI!" G EOJ
 I '$D(AUPKNSP) W !,*7,"Namespace variable does not exist!" G EOJ
 S U="^",DUZ(0)="@",AUPKQUIT=AUPKNSP_"{"
 F AUPKGLO="^DIBT(","^DIPT(","^DIE(","^DIC(19,","^XMB(3.6,","^DIC(9.2,","^DD(""FUNC""," D DELETE
 Q
 ;
ASK ;ASK USER IF WANTS TO CONTINUE
 S AUPKSTP=0
 W !!,*7,"This routine will delete all options, sort,input,print templates,",!,"bulletins, functions, ",$S($D(AUPKEY):"help frames and security keys",1:"and help frames")," namespaced `XU,XQ,XM,ZT,ZE,ZI,ZR,ZS' "
 W !,"that are currently in this UCI.  "
 W "Do you want to continue"
 S %=1
 D YN^DICN
 I %=0 W !!,"If you answer with a ""NO"" or a ""^"" I will stop this package deletion.",! G ASK
 I %=2!(%=-1) S AUPKSTP=1
 W !
 Q
 ;
DELETE ;
 W !!,"Now deleting `",AUPKNSP,"' namespaced ",$P(@(AUPKGLO_"0)"),U),"S..."
 S AUPKNSPC=AUPKNSP
 I $D(@(AUPKGLO_"""B"",AUPKNSPC)")) S DA=$O(@(AUPKGLO_"""B"",AUPKNSPC,"""")")),DIK=AUPKGLO D ^DIK KILL DIK,DA
 F L=0:0 S AUPKNSPC=$O(@(AUPKGLO_"""B"",AUPKNSPC)")) Q:AUPKNSPC=""!(AUPKNSPC]AUPKQUIT)  S DA=$O(@(AUPKGLO_"""B"",AUPKNSPC,"""")")) W !?3,AUPKNSPC S DIK=AUPKGLO D ^DIK KILL DIK,DA
 Q
 ;
LIST ; ENTRY POINT FOR LISTING NAMESPACED ITEMS
 I '$D(^DIC(0)) W !,*7,"Filemanager does not exist in this UCI!" Q
 S U="^",DUZ(0)="@"
 W !!,"Utility to list all Kernel namespaced items in current UCI",!
 D ^%ZIS
 G:POP EOJ
 U IO
 F AUPKNSP="XU","XQ","XM","ZT","ZE","ZI","ZR","ZS" D LIST1
 D ^%ZISC
 G EOJ
 ;
LIST1 ;
 W !!,"Listing of items in namespace ",AUPKNSP,!
 W "--------------------------------------",!
 S AUPKQUIT=AUPKNSP_"{"
 S %=0
 F AUPKGLO="^DIBT(","^DIPT(","^DIE(","^DIC(19,","^DIC(19.1,","^XMB(3.6,","^DIC(9.2,","^DD(""FUNC""," D LIST2
 Q
 ;
LIST2 ;
 S AUPKNSPC=$O(@(AUPKGLO_"""B"",AUPKNSP)"))
 I $P(AUPKNSPC,AUPKNSP)]"" W:% ! S %=0 W "NO ",$P(@(AUPKGLO_"0)"),"^",1),"S",! Q
 S %=1
 W !,$P(@(AUPKGLO_"0)"),"^",1),"S",!
 S AUPKNSPC=AUPKNSP
 F L=0:0 S AUPKNSPC=$O(@(AUPKGLO_"""B"",AUPKNSPC)")) Q:AUPKNSPC=""!(AUPKNSPC]AUPKQUIT)  S DA=$O(@(AUPKGLO_"""B"",AUPKNSPC,"""")")) W ?3,AUPKNSPC,!
 Q
 ;
EOJ ;
 KILL AUPKGLO,AUPKEY,AUPKSTP,AUPKNSP,AUPKNSPC,AUPKQUIT,AUPKRUN,AUPKDOC
 Q
 ;
