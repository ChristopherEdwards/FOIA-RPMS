AUPNPOST ; IHS/CMI/LAB - FIX INCOMPLETE V FILE ENTRIES CAUSED BY DICR BUG 24-MAY-1993 ;
 ;;99.1;IHS DICTIONARIES (PATIENT);;MAR 09, 1999
INFORM ;
 W:$D(IOF) @IOF
 W !!,"This is the post init to the AUPN package.  It will do the following:",!
 W !,"1.  Move the .07 field of V DIAGNOSTIC PROCEDURE to field 1208."
 W !,"2.  Move the .07 field of V Medication to 1202."
 W !,"3.  Move the .09 field of V Lab to 1202."
 W !,"4.  Reindex the AA xref on V CPT"
 W !,"5.  Check to see if you are running MAS 5.0"
VHOSP ;
 ;if running mas 5 do ^AUP1INIT
 S APCD("VERSION")="",APCD("VERSION")=$O(^DIC(9.4,"C","DG",APCD("VERSION"))) I APCD("VERSION")]"" S APCD("VERSION")=^DIC(9.4,APCD("VERSION"),"VERSION")
 I APCD("VERSION")>4.999 D
 .W !! F L=1:1:4 W *7,"*** ATTENTION ***" H 1 W:L'=4 *13,$J("",79),*13
 .W !!,$C(7),$C(7),$C(7),"YOU ARE RUNNING VERSION 5 OR GREATER OF ADT.  PLEASE RUN ^AUP1INIT",!!
CONT ;
 W !!,"If you are an alpha or beta site and this post-init was run successfully",!,"during a previous install, it does not have to run again.  Answer YES"
 W !,"to the next question.",!
 S DIR(0)="Y",DIR("A")="Has this post-init been run to completion once before",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Please answer the question!" G CONT
 I Y G XIT
QUEUE ;
 K ZTSK
 W !! S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run in the background",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D TSKMN Q
PROCESS ;
 S AUPNBT=$H
VDXP ;
 W:'$D(ZTQUEUED) !,"Moving .07 of V DIAGNOSTIC PROCEDURE to 1208..."
 S X=0 F  S X=$O(^AUPNVDXP(X)) Q:X'=+X  I $P(^AUPNVDXP(X,0),U,7)]"" S $P(^AUPNVDXP(X,12),U,8)=$P(^AUPNVDXP(X,0),U,7),$P(^AUPNVDXP(X,0),U,7)=""
 W:'$D(ZTQUEUED) "  Done"
VPRV ;move provider fields
 I '$D(ZTQUEUED) W !,"The obsolete .07 in VLAB and the .09 in V MEDICATION are being moved to the",!,"1202 field. Please wait, a dot will print for every 5000 entries.",!,"This will take awhile."
 ;MOVE V MED .09 TO 1202
 W:'$D(ZTQUEUED) !,"Processing V MEDICATION"
 S (X,C)=0 F  S X=$O(^AUPNVMED(X)) Q:X'=+X  I $P($G(^AUPNVMED(X,12)),U,2)="",$P($G(^AUPNVMED(X,0)),U,9) S $P(^AUPNVMED(X,12),U,2)=$P(^AUPNVMED(X,0),U,9),$P(^AUPNVMED(X,0),U,9)="",C=C+1 I '$D(ZTQUEUED),'(C#5000) W "."
 W:'$D(ZTQUEUED) "   Done"
 W:'$D(ZTQUEUED) !,"Processing V LAB"
 S (X,C)=0 F  S X=$O(^AUPNVLAB(X)) Q:X'=+X  I $P($G(^AUPNVLAB(X,12)),U,2)="",$P($G(^AUPNVLAB(X,0)),U,7) S $P(^AUPNVLAB(X,12),U,2)=$P(^AUPNVLAB(X,0),U,7),$P(^AUPNVLAB(X,0),U,7)="",C=C+1 I '$D(ZTQUEUED),'(C#5000) W "."
CPT ;reindex AA on V CPT
 W:'$D(ZTQUEUED) !!,"Reindexing AA on V CPT",!
 K ^AUPNVCPT("AA")
 S DIK="^AUPNVCPT(",DIK(1)=".03^AA" D ENALL^DIK
MSG ;send mail message when done
 W:'$D(ZTQUEUED) !!,"ALL DONE!!!"
 S AUPNET=$H D DONE
 ;SEND MESSAGE
 S XMDUZ=.5
 S AUPNPOST(1,0)="The AUPN package post init successfully completed on "_$$HTE^XLFDT($H,2),XMTEXT="AUPNPOST("
 S XMSUB="AUPN POST INIT COMPLETION"
 S X=DUZ,XMY(X)=""
 D ^XMD K XMY,XMTEXT
 D XIT
 Q
TSKMN ;
 S ZTIO="",ZTRTN="PROCESS^AUPNPOST",ZTDTH="",ZTDESC="AUPN PACKAGE POST-INIT" D ^%ZTLOAD D XIT K ZTSK Q
XIT ;
 K X,Y,DIE,DIU,DIV,DR,DA,XMTEXT,AUPNPOST,AUPNBT,AUPNET,DIC,C,DIK,XMDUZ,XMZ,AUPN
 Q
DONE ;ENTRY POINT - END OF REPORT TIME DISPLAY
 I $D(AUPNET) S AUPNTS=(86400*($P(AUPNET,",")-$P(AUPNBT,",")))+($P(AUPNET,",",2)-$P(AUPNBT,",",2)),AUPNH=$P(AUPNTS/3600,".") S:AUPNH="" AUPNH=0 D
 .S AUPNTS=AUPNTS-(AUPNH*3600),AUPNM=$P(AUPNTS/60,".") S:AUPNM="" AUPNM=0 S AUPNTS=AUPNTS-(AUPNM*60),AUPNS=AUPNTS S AUPNPOST(2,0)="",AUPNPOST(3,0)="RUN TIME (H.M.S): "_AUPNH_"."_AUPNM_"."_AUPNS
 K AUPNTS,AUPNS,AUPNH,AUPNM,AUPNET
 Q
