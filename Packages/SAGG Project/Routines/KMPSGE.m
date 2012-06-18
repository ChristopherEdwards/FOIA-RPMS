KMPSGE ;SF/KAK - Master Routine ;27 AUG 97 1:12 pm
 ;;1.8;SAGG PROJECT;**1**;May 14, 1999
 ;
EN ; Routine can only be run as a TaskMan background job
 ;
 Q:'$D(ZTQUEUED)
 N KMPSVOLS
 S U="^",KMPSX=$P($P(^%ZOSF("OS"),U),"("),KMPSX1=$S(KMPSX="VAX DSM":"VAX",KMPSX="MSM-PC/386":"MSM",KMPSX="MSM-PC/PLUS":"MSMV4",KMPSX="OpenM-NT":"OMNT",1:"ERR")
 I KMPSX1="ERR" W !,"SAGG Project for this environment is NOT implemented !",*7,! K KMPSX,KMPSX1 Q
 I KMPSX1="MSMV4" I $ZV["Windows NT" S KMPSX1="MSM"
 S KMPSMGR=^%ZOSF("MGR"),KMPSPROD=$P(^%ZOSF("PROD"),","),KMPSPROD=$S($P(^KMPS(8970.1,1,0),"^",3)="":KMPSPROD,1:$P(^(0),"^",3))
 S KMPSSITE=^DD("SITE",1),KMPSLOC=$P(^KMPS(8970.1,1,0),"^",2) D NOW^%DTC S KMPSDT=%
 L +^XTMP("KMPS") S ^XTMP("KMPS",0)=%+10000
 K ^XTMP("KMPS",KMPSSITE),^XTMP("KMPS","ERROR"),^XTMP("KMPS","START"),^XTMP("KMPS","STOP")
 S NUM=+$H,^XTMP("KMPS",KMPSSITE,0)=NUM_U_KMPSX1_U_$P($T(+2),";",3)_" "_$P($T(+2),";",5)_U_+$G(^KMPS(8970.1,2,0))
 S X="ERR1^KMPSGE",@^%ZOSF("TRAP")
 S KMPSTEMP=KMPSSITE_U_NUM_U_KMPSLOC_U_KMPSDT_U_KMPSPROD
 S (KMPSSTRT,KMPSVOL)=0 F  S KMPSVOL=$O(^KMPS(8970.1,1,1,"B",KMPSVOL)) Q:KMPSVOL=""!+$G(^XTMP("KMPS","STOP"))  D
 .S KMPSUCIN=0 F  S KMPSUCIN=$O(^KMPS(8970.1,1,1,"B",KMPSVOL,KMPSUCIN)) Q:KMPSUCIN=""  D
 ..S KMPSUCI=$P(^KMPS(8970.1,1,1,KMPSUCIN,0),U,2)
 ..S:KMPSUCI="" KMPSUCI=KMPSPROD S KMPSVA(KMPSUCI_","_KMPSVOL)="",KMPSVOLS(KMPSVOL)=""
 ..D @KMPSX1 S KMPSSTRT=KMPSSTRT+1 I KMPSSTRT=6 D WAIT
 ;
LOOK ;
 D ZER^KMPSLK
LOOP ;
 ;  Wait for all volume sets to complete
 ;
 H 300 I $D(^XTMP("KMPS","START")) G:(+$H<(NUM+3)) LOOP S KMPSTEXT(1)="   The SAGG Project collection routines have been running for more",KMPSTEXT(2)="   than 3 days.  No report has been generated." G MSG^KMPSLK
 K KMPSTEXT I $D(^XTMP("KMPS","ERROR")) S KMPSTEXT(1)="   The SAGG Project has recorded an error on volume set(s):" D  G MSG^KMPSLK
 .S KMPSX=0,KMPSVOL="" F  S KMPSVOL=$O(^XTMP("KMPS","ERROR",KMPSVOL)) Q:KMPSVOL=""  S:KMPSX KMPSTEXT(3)=KMPSTEXT(3)_"   "_KMPSVOL S:'KMPSX KMPSX=1,KMPSTEXT(3)="      "_KMPSVOL
 .S (KMPSTEXT(2),KMPSTEXT(4))="",KMPSTEXT(5)="   See system error log for more details."
 .I KMPSX1="OMNT" S KMPSTEXT(6)="",KMPSTEXT(7)="   Also run INTEGRIT on the listed volume(s)."
 I $D(^XTMP("KMPS","STOP")) S KMPSTEXT(1)="   The SAGG Project collection routines have been STOPPED!  No report",KMPSTEXT(2)="   has been generated." G MSG^KMPSLK
 I '$D(^XTMP("KMPS",KMPSSITE,NUM,KMPSDT)) D  G MSG^KMPSLK
 .S KMPSTEXT(1)="   The SAGG Project collection routines did NOT obtain ANY global",KMPSTEXT(2)="   information.  Please ensure that the SAGG PROJECT file is"
 .S KMPSTEXT(3)="   properly setup.  Then use the 'One-time Option Queue' under",KMPSTEXT(4)="   Task Manager to re-run the KMPS SAGG REPORT option."
 S KMPSX1="" F  S KMPSX1=$O(^XTMP("KMPS",KMPSSITE,NUM,KMPSDT,KMPSX1)) Q:KMPSX1=""  S KMPSX2="" F  S KMPSX2=$O(^XTMP("KMPS",KMPSSITE,NUM,KMPSDT,KMPSX1,KMPSX2)) Q:KMPSX2=""  K KMPSVA(KMPSX2)
 S KMPSX1="" F  S KMPSX1=$O(^XTMP("KMPS",KMPSSITE,NUM," NO GLOBALS ",KMPSX1)) Q:KMPSX1=""  K KMPSVA(KMPSX1)
 I $D(KMPSVA) S KMPSTEXT(1)="   The SAGG Project collection routines did NOT monitor the following:",KMPSTEXT(2)="" D  G MSG^KMPSLK
 .S KMPSX=0,KMPSX1="" F KMPSI=3:1 Q:KMPSX  S KMPSTEXT(KMPSI)="          " F KMPSJ=1:1:5 S KMPSX1=$O(KMPSVA(KMPSX1)) S:KMPSX1="" KMPSX=1 Q:KMPSX1=""  S KMPSTEXT(KMPSI)=KMPSTEXT(KMPSI)_KMPSX1_"   "
 .S KMPSTEXT(KMPSI)="",KMPSTEXT(KMPSI+1)="   Please ensure that the SAGG PROJECT file is properly setup.  Then use"
 .S KMPSTEXT(KMPSI+2)="   the 'One-time Option Queue' under Task Manager to re-run the KMPS SAGG",KMPSTEXT(KMPSI+3)="   REPORT option."
 ;
 ;  PackMan ^XTMP global to KMP1-SAGG-SERVER at Albany CIOFO
 ;
 S U="^",N=$O(^DIC(4,"D",KMPSSITE,0)),NM=$S($D(^DIC(4,N,0)):$P(^(0),"^"),1:KMPSSITE)
 K XMY S:'$D(XMDUZ) XMDUZ=.5 S:'$D(DUZ) DUZ=.5
 S XMSUB=NM_" (Session #"_NUM_") XTMP(""KMPS"") Global",XMTEXT="^XTMP(""KMPS"","_KMPSSITE_"," I $D(IO) K:IO="" IO
 D ENT^XMPG S KMPSXMZ=XMZ K XMTEXT
 S X="S.KMP1-SAGG-SERVER@DOMAIN.NAME",XMN=0 D INST^XMA21 D ENT1^XMD
 ;
 G OUT^KMPSLK
 ;
WAIT ;  Wait here until less than 6 volume sets are running
 ;
 H 300 S KMPSCUR="",KMPSRUN=0 F  S KMPSCUR=$O(^XTMP("KMPS","START",KMPSCUR)) Q:KMPSCUR=""  S KMPSRUN=KMPSRUN+1
 I KMPSRUN>5 G WAIT
 S KMPSSTRT=KMPSRUN Q
ERR1 ;
 S KMPSZE=$ZE,ZUZR=$ZR,X="",@^%ZOSF("TRAP") D @^%ZOSF("ERRTN") K KMPSTEXT S KMPSTEXT(1)="SAGG Project Error: "_KMPSZE_" on "_$ZU(5),KMPSTEXT(2)="See system error log for more details.",^XTMP("KMPS","STOP")="" D MSG^KMPSLK G ^XUSCLEAN
 ;
VAX ; DSM
 J START^%ZOSVKSE:(OPTION="/ROUTINE=["_KMPSMGR_"]/UCI="_KMPSUCI_"/VOLUME="_KMPSVOL_"/DATA="""_KMPSTEMP_"""") Q
 ;
MSM ;
 J START^%ZOSVKSE(KMPSTEMP)[KMPSUCI,KMPSVOL] Q
 ;
MSMV4 ;
 S KMPSFS=$E(KMPSVOL)_"S"_$E(KMPSVOL,3)
 J START^%ZOSVKSE(KMPSTEMP)[KMPSUCI,KMPSVOL,KMPSFS] Q
 ;
OMNT ; OpenM-NT
 J START^%ZOSVKSE(KMPSTEMP_U_KMPSVOL) Q
