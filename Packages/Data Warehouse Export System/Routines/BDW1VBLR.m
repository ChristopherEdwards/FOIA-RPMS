BDW1VBLR ;IHS/CMI/LAB - RESET visit backload log;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;IHS/CMI/LAB - XTMP
 W !!,"This routine will reset the Data Warehouse Export Log.  You must be",!,"absolutely sure that you have corrected the underlying problem that caused ","the Export process to fail in the first place!",!!
 W "The Data Warehouse Export log entry you choose will be REMOVED from the log",!,"log file and all Utility and Data globals associated with that run will ",!,"be killed!!",!!
 W "You must now select the Log Entry to be RESET.  <<< SELECT CAREFULLY >>>",!
 S DIC="^BDWBLOG(",DIC(0)="AEMQ",DIC("S")="I $P(^BDWBLOG(Y,0),U,15)'=""C"",$P(^BDWBLOG(Y,0),U,15)'=""P""" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G EOJ
 S BDW("RUN LOG")=+Y
 D DISP
 S DIR(0)="Y",DIR("A")="Are you sure you want to do this",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y'=1 D EOJ Q
 S BDWTM=$$DW1TRLR^BHLEVENT(90214,BDW("RUN LOG"))
 S BDW("RUN START")=$P(^BDWBLOG(BDW("RUN LOG"),0),U,3),BDW("RUN STOP")=$P(^BDWBLOG(BDW("RUN LOG"),0),U,4)
 S BDW1L=$P(^BDWBLOG(BDW("RUN LOG"),0),U,19),BDWED=$P($P(^AUPNVSIT(BDW1L,0),U),"."),BDWED=$$FMADD^XLFDT(BDWED,-1)
 D RUNTIME
 S DA=BDW("RUN LOG"),DIE="^BDWBLOG(",DR=".02////"_BDWED_";.13////"_BDWRT_";.14////"_BDWTM_";.15////C" D ^DIE
 W !!,"Log has been reset",!
 D EOJ
 Q
DIK ;
 S DA=BDW("RUN LOG"),DIK="^BDWBLOG(" D ^DIK
 K ^XTMP("BDWBLOG")
 K ^BDWTMP
 K ^BDWDATA
 D EOJ
 Q
DISP ;
DIQ ; CALL TO DIQ
 W !!,"Information for Log Entry ",BDW("RUN LOG"),!
 S DIC="^BDWBLOG(",DA=BDW("RUN LOG"),DR="0;31",DIQ(0)="C" D EN^DIQ
 K DIC,DIQ,DR,DA
 Q
EOJ ;
 D EN^XBVK("BDW")
 K DA,DIK,BDW("RUN LOG"),Y,X,DIR,DIRUT
 Q
RUNTIME ;
 S B=BDW("RUN START")
 S E=BDW("RUN STOP")
 S T=(86400*($P(E,",")-$P(B,",")))+($P(E,",",2)-$P(B,",",2)),H=$P(T/3600,".")
 S:H="" H=0
 S T=T-(H*3600),M=$P(T/60,".")
 S:M="" M=0
 S T=T-(M*60),S=T
 ;W:$D(ZTQUEUED) !!,"RUN TIME (H.M.S): ",H,".",M,".",S
 S BDWRT=H_"."_M_"."_S
 K B,E,H,M,S,T
 Q
