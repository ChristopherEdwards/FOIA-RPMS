DGVPR1 ;ALB/MLI - DG PRE-INIT (SAVE AND RESTORE QUEUED JOBS) ; 6/25/89@1000
 ;;5.3;Registration;;Aug 13, 1993
 ;
SAV(LIST) ; -- save queued values
 W !!,">>> Saving times for queued jobs...will be restored in post-init to original",!?4,"values..",!
 F DGI=1:1 S O=$P($T(@LIST+DGI),";;",2) Q:O="$END"  S DGEDIT=0 D OCC
 Q
 ;
OCC S X=$E("'"_O_"'......................................",1,35) W !?4,X S ON=$O(^DIC(19,"B",$E(O,1,30),0)) D OC I 'DGER S DGX=^DIC(19,+ON,200) D OCW
 K O,ON,I Q
OC S DGER=0 I '$D(^DIC(19,+ON,0)) W "No such option on file..." S DGER=1 Q
 I '$D(^DIC(19,+ON,200)) W "Not a ""tasked"" job..." S DGER=1 Q
 S DGTJ(+ON)=^DIC(19,+ON,200)
 Q
 ;
RES ; -- restore queued jobs invoked from post-init
 Q:$O(DGTJ(0))=""
 S ON=0 F I1=0:0 S ON=$O(DGTJ(ON)) Q:ON=""  S X="'"_$E($P(^DIC(19,+ON,0),"^",1)_"'....................................",1,35) W !?4,X S DGX=DGTJ(ON) D OCW
 Q
 ;
OCW W "Queued to run",?58,": " S Y=$S($P(DGX,"^",1)]"":$P(DGX,"^",1),1:"NOT QUEUED") X ^DD("DD"):Y W $J(Y,20)
 W !?39,"Device for Output",?58,": " S Y=$S($P(DGX,"^",2)]"":$P(DGX,"^",2),1:"NONE SELECTED") W $J(Y,20)
 W !?39,"Rescheduling Freq.",?58,": " S Y=$S($P(DGX,"^",3)]"":$P(DGX,"^",3),1:"NONE") W $J(Y,20)
 Q:'DGEDIT
 N DGY S DR="",DGY=$S($D(^DIC(19,ON,200)):^(200),1:"")
 I DGX D NOW^%DTC S $P(DGX,"^")=$S((%+.0003)>DGX:"",1:DGX) ; date/time in past then can't set
 F I=1:1:4 S $P(DGX,"^",I)=$S($P(DGX,"^",I)]"":$P(DGX,"^",I),$P(DGY,"^",I)="":"",1:"@") I $P(DGX,"^",I)]"" S DR=DR_(200+(I-1))_"///"_$S(I=2:$P($P(DGX,"^",I),";",1),1:$P(DGX,"^",I))_";"
 Q:DR']""  S DIE="^DIC(19,",(DA,Y)=ON,DIC(0)="L" D ^DIE K DR,DIE,DIC,DA,Y Q
 Q
 ;
DG ;
 ;;DG G&L RECALCULATION AUTO
 ;;DG RUG BACKGROUND JOB
 ;;DG RUG SEMI ANNUAL - TASKED
 ;;DG PTF BACKGROUND JOB
 ;;DGJ IRT UPDATE (Background)
 ;;$END
SD ;
 ;;SDAM BACKGROUND JOB
 ;;$END
