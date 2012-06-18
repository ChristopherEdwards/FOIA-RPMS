DGVPT ;ALB/MRL - DG POST-INIT DRIVER ; 05 JUN 87
 ;;5.3;Registration;;Aug 13, 1993
 ;
EN ; -- main entry point
 S XQABT4=$H
 I '$D(DGVREL) D VERS^DGVPP G ENQ:'$D(DGVREL)
 S DGVFLD=102 D TIME^DGVPR
 ;
 D LINE^DGVPP,EVTS                   ; protocols
 D LINE^DGVPP,LISTS                  ; list templates
 D EN^DGV53PT                        ; current version specific tasks
 D LINE^DGVPP,TASKS                  ; restore queued times
 D LINE^DGVPP,STAN                   ; std output defaults
 D LINE^DGVPP,^DGVPT2                ; file protection
 D LINE^DGVPP,COMP^DGVPT3            ; re-compile note
 D LINE^DGVPP,OBS                    ; obsolete routine note
 D LINE^DGVPP,CENSUS                 ; annual PTF census dates
 ; -- delete options
 S DGPACK="DG" D LINE^DGVPP,^DGVPT1
 S DGPACK="VA" D ^DGVPT1
 S DGPACK="EDR" D ^DGVPT1
 ;
 S DGVFLD=103 D TIME^DGVPR S ^DG(43,1,"VERSION")=DGVNEW
 S XQABT5=$H
 S X="DGINITY" X ^%ZOSF("TEST") I $T D ^DGINITY
 W !!,*7,">>> Initialization of Version ",DGVNEWVR," of DG Complete."
 W !!,"After you've been up and running for about a week or so we would appreciate"
 W !,"it if you would utilize the 'Transmit/Generate Release Comments' option"
 W !,"of the PIMS package to provide us with your (and your users) initial"
 W !,"impression of this release.  Thank you.",!!
ENQ G Q^DGVPP
 ;
EVTS ;Move DG Options to Protocol File
 S X="" D ^DGONIT
 Q
 ;
LISTS ; -- load list templates
 W !!,">>> List Template installation..."
 D ^DGVLT
 Q
 ;
TASKS ; -- requeue tasked jobs
 I $O(DGTJ(0))'="" W !!,">>> Restoring queued jobs to original state...",! S DGEDIT=1 D RES^DGVPR1 K DGTJ
 K DA,DGI,DIC,DIE,DR,X,Y,DGEDIT
 Q
 ;
STAN ;Set-up standard output template defaults
 W !!,">>> Setting standard output template defaults...",! D STAN^DGTEMP
 Q
 ;
 ;
OBS ;List Obsolete Routines
 Q:'$O(^DG(48,DGVREL,"DR",0))
 W !!,">>> The following routines are considered obsolete with this release and may",!?4,"be removed from your system when time permits.  They are no longer",!?4,"supported by the development ISC.",!!?4
 S C=0 F I=0:0 S I=$O(^DG(48,DGVREL,"DR",I)) Q:'I  S X=$P(^(I,0),"^",1),X=$E(X_"          ",1,10),C=C+1 W:'(C#7) !?4 W X
 W !!,"NOTE:  If you would like to have the module automatically delete these routines,",!?7,"you can call DEL^DGVPT1 after initialization of this version is",!?7,"completed."
 Q
 ;
CENSUS ;--- add new census date
 ;    These dates should be update each year per MAS VACO.
 ;
 N CENDATE,CLOSDATE,OKTOXM,ACTIVE,CPSTART
 ;
 ;-- ALL DATES ARE FOR '93 CENSUS
 ;
 ;-- Census Date 9-30-93
 S CENDATE=2930930
 ;-- Close-out Date 11-1-93
 S CLOSDATE=2931101
 ;-- ok to x-mit PTF date 11-22-93
 S OKTOXM=2931122
 ;-- currently active
 S ACTIVE=1
 ;-- Census Period Start Date 10-1-92
 S CPSTART=2921001
 ;
 W !!,">>> Updating Census Dates..."
 ;
 S X=$O(^DG(45.86,"AC",0)) I X S X=$O(^DG(45.86,"AC",X,0)),DIE="^DG(45.86,",DA=X,DR=".04////0" D ^DIE K DIE,DR,DA
 S DIC="^DG(45.86,",X=CENDATE,DIC(0)="L" K DD,DO D ^DIC K DIC
 S DIE="^DG(45.86,",DA=+Y,DR=".02////"_CLOSDATE_";.03////"_OKTOXM_";.04////"_ACTIVE_";.05////"_CPSTART
 D ^DIE K DIE,DR,DA
 ;
 W "Done."
 Q
 ;
