BLRRLV ; cmi/anch/maw - BLR Verify Reference Lab Results ;
 ;;5.2;LR;**1021**;Jul 27, 2006
 ;;1.0;BLR REFERENCE LAB;;MAR 14, 2005
 ;
 ;
 ;
 ;this routine will allow the user to verify reference lab results
 ;before passing them on to PCC
 ;
MAIN ;EP - this is the main routine driver
 S BLRVER=$$ASKV
 I $G(BLRVER) D RFL,EOJ Q
 D LOOP
 D EOJ
 Q
 ;
ASKV() ;-- ask to mark all as verified
 S DIR(0)="Y",DIR("A")="Do you wish to mark all results as verified"
 S DIR("B")="N"
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
LOOP ;-- loop the xref and call VER
 I '$O(^BLRTXLOG("BVER",0)) D  Q
 . W !,"No results to verify"
 S DIC="^BLRTXLOG("
 S BLRVDA=0 F  S BLRVDA=$O(^BLRTXLOG("BVER",BLRVDA)) Q:'BLRVDA!$G(BLRVQ)  D
 . Q:$G(BLRVQ)
 . W @IOF
 . S DA=BLRVDA
 . D DIQ^BLRLM(DIC,DA)
 I '$O(^BLRTXLOG("BVER",0)) D  Q
 . W !!,"No more results to verify"
 I $O(^BLRTXLOG("BVER",0)) D  Q
 . W !!,"Please come back and verify remaining results"
 Q
 ;
UPD(DA) ;-- mark entry as verified
 S DIE="^BLRTXLOG("
 S DR="2006////"_$G(DUZ)_";2007///"_$$GET1^DIQ(200,DUZ,.01,"E")
 D ^DIE
 K ^BLRTXLOG("BVER",BLRVDA)
 D ^BLREVTQ("M","REFILE","REFILE",,BLRVDA)
 Q
 ;
RMV(DA) ;-- remove the entry from the tx log
 S DIK="^BLRTXLOG(" D ^DIK
 K ^BLRTXLOG("BVER",DA)
 Q
 ;
RFL ;-- mark all as verified and refile
 W !,"Now marking all results as verified"
 S BLRVDA=0 F  S BLRVDA=$O(^BLRTXLOG("BVER",BLRVDA)) Q:'BLRVDA  D
 . W "."
 . S DA=BLRVDA
 . S DIE="^BLRTXLOG("
 . S DR="2006////"_$G(DUZ)_";2007///"_$$GET1^DIQ(200,DUZ,.01,"E")
 . D ^DIE
 . K ^BLRTXLOG("BVER",BLRVDA)
 . D ^BLREVTQ("M","REFILE","REFILE",,BLRVDA)
 Q
 ;
VER() ; EP -- verify individual results     
 S DIR(0)="Y",DIR("A")="Mark this result as verified"
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
XREF(XIEN)         ; EP -- setup the x ref for Source Of Data Input
 S BLRRL=$P($G(^BLRSITE(DUZ(2),"RL")),U)
 Q:'BLRRL
 S BLRHLD=$P($G(^BLRRL(BLRRL,0)),U,11)
 Q:'BLRHLD
 S BLRUNI=$P($G(^BLRRL(BLRRL,0)),U,10)
 Q:'BLRUNI
 S ^BLRTXLOG("BVER",DA)="R"
 Q
 ;
EOJ ;-- kill variables
 D JOB^BLRPARAM
 D EN^XBVK("BLR")
 Q
 ;
