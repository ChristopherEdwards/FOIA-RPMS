INHPCO1 ; FRW ; 12 Nov 97 13:36;  Manipulate GIS control files - cont. 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;
 ;
 Q
 ;
ACTONE(INPROD) ;Fully activate an environment
 ;INPROD - production flag ( 1 - production ; 0 - development )
 ;
 S INVERBOS=1
ACTIVVB ;activate in Verbose mode
 S INPROD=+$G(INPROD)
 D:'$G(DUZ) ENV^UTIL
 ;Activate non-production stuff
 I 'INPROD D ACTIVTST
 ;Turn on all background processes
 D BCKPROC(1)
 ;Activate all transaction types (Except MHCMIS?)
 D TTALL(1)
 ;Reconnect replicated transaction types
 D REP(1)
 ;Deactivate development stuff if production area
 I INPROD D DEACTST
 ;Recompile all messages
 D RECOMP
 ;Repopulate environmental control data
 D REFRESH
 ;Update last active date
 S $P(^INRHT("ALAST"),U,2)=$$NOW^%ZTFDT
 K INVERBOS
 Q
 ;
PREP ;Prep globals for packaging
 ;Verbose mode => 0 - verbose ; 1 - not verbose
 S INVERBOS=1
PREPVB ;Verbose mode
 D:'$G(DUZ) ENV^UTIL
 ;Gather environemental information
 D REMEMBER
 ;Deactivate non-production stuff
 D DEACTST
 ;Turn off all background processes
 D BCKPROC(0)
 ;Clean up background process file
 D BCKCLN
 ;Deactivate all trasnsaction types
 D TTALL(0)
 ;Clean up destination file
 D DEST(0)
 ;Disconnect REPlicated transaction types - delete Parent TT field
 D REP(0)
 ;Recompile all messages
 ;D RECOMP    ;The SCRIPT file is no longer sent out populated
 ;Re-index control files
 D CONTROLS^INHPCO2
 ;Do miscellaneous
 D MISC^INHPCO
 K INVERBOS
 ;Update last prep date
 S $P(^INRHT("ALAST"),U,1)=$$NOW^%ZTFDT
 Q
 ;
RECOMP ;Recompile all messages
 ;
 ;Kill off script file
 K ^INRHS S ^INRHS(0)="INTERFACE SCRIPT^4006"
 ;Delete SCRIPT field from all transaction types
 K DR,DIE S DIE=4000,DA=0,DR=".03///@"
 F C=0:1 S DA=$O(^INRHT(DA)) Q:'DA  D ^DIE I '$G(INVERBOS) I '$G(INVERBOS) W !,"SCRIPT field deleted for Transaction Type: ",$P(^INRHT(DA,0),U)
 ;delete script fieldS from all messages
 K DR,DIE S DIE=4011,DA=0,DR="100///@;101///@"
 F C=0:1 S DA=$O(^INTHL7M(DA)) Q:'DA  D ^DIE I '$G(INVERBOS) I '$G(INVERBOS) W !,"SCRIPT field(s) deleted for Script Generator Message: ",$P(^INTHL7M(DA,0),U)
 ;Recompile all messages
 D ALLAUTO^INHSGZ
 ;
 Q
 ;
TTALL(INST) ;Deactivate/Activate all transaction types
 ;
 W:'$G(INVERBOS) !,"*** Processing Transaction Type file ***"
 ;Loop through all transaction types and take action
 S INST=+$G(INST) N DIE,DR,INSTMSG
 S INSTMSG=$S('INST:"DEACTIVATED",1:"ACTIVATED")
 S DIE=4000,DR=".05///"_INST
 ;Loop through background process control file
 S DA=0
 F  S DA=$O(^INRHT(DA)) Q:'DA  D
 .  D ^DIE
 .  I '$G(INVERBOS) W !,"Transaction Type: ",$P(^INRHT(DA,0),U),"    ",INSTMSG
 Q
 ;
BPCONE(DA,INST) ;Activate/Deactivate one background process
 ;INPUT:
 ;  DA - entry to process (ien)
 ;  INST - what to do  0 - deactivate (def) ; 1 - activate
 ;
 S INST=+$G(INST) N DIE,DR,INSTMSG
 S INSTMSG=$S('INST:"DEACTIVATED",1:"ACTIVATED")
 S DIE=4004,DR=".02///"_INST D ^DIE
 W:'$G(INVERBOS) !,"Background Process: ",$P(^INTHPC(DA,0),U),"    ",INSTMSG
 Q
 ;
TTONE(DA,INST) ;Deactivate/activate one transaction type
 ;
 S INST=+$G(INST) N DIE,DR,INSTMSG
 ;Do not activate MHCMIS I (DGM*) tt's
 S INSTMSG=$P($G(^INRHT(DA,0)),U,1) Q:$E(INSTMSG,1,3)="DGM"&INST
 S INSTMSG=$S('INST:"DEACTIVATED",1:"ACTIVATED")
 S DIE=4000,DR=".05///"_INST D ^DIE
 W:'$G(INVERBOS) !,"Transaction Type: ",$P(^INRHT(DA,0),U),"    ",INSTMSG
 Q
 ;
 ;Should script also be deleted when deactivating? 
 ;    - YES for non-production stuff
 ;Should PARENT be deactivated if it has no other active children 
 ;   - probably
 ;Should anything be done with the Message Replication File
 ;Should script be recompiled if activating 
 ;   - probably
 ;Should parent be activated if not already
 ;   - probably 
 ;   - display warning if parent was inactive but had active children
 ;
MSGONE(DA,INST) ;Deactivate one message
 ;
 S INST=+$G(INST) N DIE,DR,INSTMSG
 ;Do not activate MHCMIS I (DGM*) msgs
 S INSTMSG=$P($G(^INTHL7M(DA,0)),U,1) Q:$E(INSTMSG,1,3)="DGM"&INST
 S INSTMSG=$S('INST:"DEACTIVATED",1:"ACTIVATED")
 ;Set INACTIVE flag
 S DIE=4011,DR=".08///"_$S('INST:1,1:0) D ^DIE
 W:'$G(INVERBOS) !,"Script Generator Message: ",$P(^INTHL7M(DA,0),U),"    ",INSTMSG
 Q
 ;
 ;?? Should transaction types for messages also be deactivated
 ;?? Should scripts for message also be deactivated
 ;?? Should anything be done with the Message Replication File
 Q
 ;
LOOP(INGL,INEXE,INGLDAT) ;Loop through a "B" x-ref
 ;INBGL - global to loop down
 ;INEXE - Executable code - DA will be the ien
 ;INGLDAT - global storage of file
 ;WON'T GET ANYTHNG THAT STARTS WITH inname
 N INNAME,INLEN,INLOOP,DA
 F INNAME="DGM","PROTO","TEST" D
 .  S INLEN=$L(INNAME),INLOOP=INNAME
 .  F  S INLOOP=$O(@INGL@(INLOOP)) Q:$E(INLOOP,1,INLEN)'=INNAME  D
 ..   S DA=0 F  S DA=$O(@INGL@(INLOOP,DA)) Q:'DA  D
 ...    X INEXE
 Q
 ;
BCKPROC(INST) ;Deactivate/Activate background processes
 ;
 W:'$G(INVERBOS) !,"*** Processing Background Process Control File ***"
 S INST=+$G(INST) N DIE,DR,INSTMSG
 S INSTMSG=$S('INST:"DEACTIVATED",1:"ACTIVATED")
 S DIE=4004,DR=".02///"_INST
 ;Loop through background process control file
 S DA=2
 F  S DA=$O(^INTHPC(DA)) Q:'DA  D
 .  D ^DIE
 .  I '$G(INVERBOS) W !,"Background Process: ",$P(^INTHPC(DA,0),U),"    ",INSTMSG
 Q
 ;
ACTSTONE(DA) ;Activate one non-production message
 ;
 Q:$E($P(^INTHL7M(DA,0),U),1,3)="DGM"
 N DR,DIE S DR=".08///0",DIE=4011
 D ^DIE
 I '$G(INVERBOS) W !,"Message: ",$P(^INTHL7M(DA,0),U),"   ","ACTIVATED"
 Q
 ;
DEST(INST) ;Destination file
 ;
 S INST=+$G(INST) N DA,INSTMSG
 S INSTMSG=$S('INST:"DEACTIVATED",1:"ACTIVATED")
 I '$G(INVERBOS) W !,"*** Processing Destination file ***"
 S DIE=4005,DR="7.02///@"
 ;Clean up ADDRESS ID and ROUTE ID field
 I 'INST D
 .  S DA=0 F  S DA=$O(^INRHD(DA)) Q:'DA  K ^INRHD(DA,5),^(9) D ^DIE
 .  I '$G(INVERBOS) W !,"Destination file cleaned up"
 ;
 Q
 ;
REP(INST) ;Disconnect/Connect replicated transactions
 ;
 ;;DO NOT ACTIVATE THIS MODULE WITHOUT DETAILED ANALYSIS OF IMPACTS
 ;
 Q
 ;
 I INST Q  ;Currently not supporting replication
 I '$G(INVERBOS) W !,"*** Processing Replicated Transaction Types ***"
 S INST=+$G(INST) N DA,INSTMSG
 S INSTMSG=$S('INST:"Parent deleted",1:"Parent = ")
 N DA,DIE,DR S DA=2,DIE=4000,DR=".06///^S X=INEDIT"
 S INEDIT="@"
 F  S DA=$O(^INRHT(DA)) Q:'DA  D
 .  Q:$P(^INRHT(DA,0),U)'["(REP)"
 .  I INST D  Q:'$L(INEDIT)
 ..   S INEDIT=$P($P(^INRHT(DA,0),U),"(REP)")_"(PARENT)"
 ..   I '$D(^INRHT("B",INEDIT)) W !,"Parent: ",INEDIT,"  not foud for Transaction Type: ",$P(^INRHT(DA,0),U) S INEDIT="" Q
 .  D ^DIE
 .  I '$G(INVERBOS) W !,$P(^INRHT(DA,0),U),"   ",INSTMSG,INEDIT
 Q
 ;
DEACTST ;Deactivate test stuff
 D DEACTST^INHPCO Q
 ;
ACTIVTST ;Activate test stuff
 D ACTIVTST^INHPCO Q
 ;
REMEMBER ;Remember environmental variables
 D REMEMBER^INHPCO Q
 ;
REFRESH ;Refresh environmental variables
 D REFRESH^INHPCO Q
 ;
BCKCLN ;Clean up background process control file
 D BCKCLN^INHPCO Q
 ;
