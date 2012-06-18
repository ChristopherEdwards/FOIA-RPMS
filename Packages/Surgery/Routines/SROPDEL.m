SROPDEL ;B'HAM ISC/MAM - DELETE CASE ; [ 04/26/97   3:03 PM ]
 ;;3.0; Surgery ;**67**;24 Jun 93
DEL W !!,"Are you sure that you want to delete this case ?  NO//  " R SRYN:DTIME I '$T!(SRYN["^") S SRSOUT=1 Q
 S:SRYN="" SRYN="N" S SRYN=$E(SRYN)
 I "YyNn"'[SRYN W !!,"Enter 'YES' to delete this surgical case from your records.  If you have",!,"selected this option inadvertantly and do not want to remove this case,",!,"enter RETURN or 'NO'." G DEL
 I "Yy"'[SRYN S SRSOUT=1 Q
 S SRCC="",SROPCOM="Operation..."
 I $P($G(^SRF(SRTN,.2)),"^",12)'="" W !!,"This case has been completed and must remain in the file for your records." D RET Q
 I $D(^SRF(SRTN,"LOCK")),^("LOCK")=1 W !!,"This case has been verified and locked.  It cannot be deleted unless unlocked",!,"by your Chief of Surgery, or someone appointed by him." D RET Q
 I $D(^SRF(SRTN,30)),$P(^(30),"^") S SROPCAN=1
 I $D(^SRF(SRTN,31)),$P(^(31),"^",8)'="" S SROPCAN=1
 I $D(SROPCAN) W !!,"This case has been cancelled and must remain in the file for your records." D RET Q
 I $D(^SRF(SRTN,31)),$P(^(31),"^",4) W !!,"You cannot delete a procedure that has already been scheduled.  If you",!,"would like to cancel this procedure, use the option 'Cancel Scheduled ",!,"Operation'." D RET Q
KILL ; delete entry
 S SRCONC=0 I $D(^SRF(SRTN,"CON")),$P(^("CON"),"^")'="" S SRCONC=^("CON") K ^SRF(SRCONC,"CON")
 D DEL^SROERR
 W !!,"  Deleting "_SRCC_SROPCOM I $P($G(^SRF(SRTN,.2)),"^",10) S DIE=130,DA=SRTN,DR=".205///@" D ^DIE K DA
 S (DA,SRTN1)=SRTN,DIK="^SRF(" D ^DIK K SRTN
 I SRCONC D CON I SRCONC D KILL
 Q
CON ; delete concurrent case ?
 S SRTN=SRCONC W !!,"There is a concurrent procedure associated with this case.  Do you want to",!,"delete it also ?  YES//  " R SRYN:DTIME I '$T!(SRYN["^") S SRCONC=0 Q
 S SRYN=$E(SRYN) S:SRYN="" SRYN="Y"
 I "YyNn"'[SRYN W !!,"Enter RETURN to delete this concurrent case.  If you are not sure whether to",!,"delete the other case, enter 'NO'.  It can be removed later if necessary." G CON
 I "Nn"[SRYN S SRCONC=0
 Q
RET W !!,"Press RETURN to continue  " R X:DTIME K SRTN
 Q
