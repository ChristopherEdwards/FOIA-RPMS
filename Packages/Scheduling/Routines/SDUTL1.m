SDUTL1 ;ALB/MJK - Scheduling Utilities; [ 09/13/2001  2:51 PM ]
 ;;5.3;Scheduling;;Aug 13, 1993
 ;IHS/ANMC/LJF 6/23/2000 automatically enroll IHS patients
 ;                       answer date as NOW and type as OPT
 ;             7/06/2000 removed display of enrollment status
 ;
ENROL(DFN,SDCL) ;
 S SDY=$$CHK(.DFN,.SDCL,1) G ENROLQ:SDY
 ;S SDY=$$ASK G ENROLQ:SDY<0  ;IHS/ANMC/LJF 6/23/2000
 S SDY=1                      ;IHS/ANMC/LJF 6/23/2000
 I SDY=1 S SDY=$$DIE(.DFN,.SDCL) G ENROLQ
 I SDY=0 S SDY=$$CON
ENROLQ Q SDY
 ;
CHK(DFN,SDCL,SHOW) ;
 N SDPRCL,CL,SDE,SDJ,DIS,SDY,SDATA
 S SDY=0,SDPRCL=$$PRIN(.SDCL)
 S SDE=0 F  S SDE=$O(^DPT(DFN,"DE",SDE)) Q:'SDE  S CL=+$G(^(SDE,0)) I CL=SDCL!(CL=SDPRCL) D  G CHKQ:SDY
 .S SDJ=0 F  S SDJ=$O(^DPT(DFN,"DE",SDE,1,SDJ)) Q:'SDJ  S SDATA=$G(^(SDJ,0)) D:$D(SHOW) SHOW(.SDATA) S:'$P(SDATA,U,3) SDY=1
CHKQ Q SDY
 ;
ASK() ;
 S DIR(0)="Y",DIR("A")="Do you wish to enroll the patient" D ^DIR K DIR
 S SDY=$S($D(DIRUT):-1,1:Y) K DIRUT
ASKQ Q SDY
 ;
CON() ;
 S DIR(0)="Y",DIR("A")="Do you wish to schedule patient for a consult" D ^DIR K DIR
 Q Y
 ;
DIE(DFN,SDCL) ;
 N SDPRCL,SDFILE,SDE
 S SDPRCL=$$PRIN(.SDCL)
 S SDE=0 F  S SDE=$O(^DPT(DFN,"DE",SDE)) Q:'SDE  Q:SDPRCL=+$G(^(SDE,0))
FILE I 'SDE K D0,DD S:'$D(^DPT(DFN,"DE",0)) $P(^DPT(DFN,"DE",0),U,2)=$P(^DD(2,3,0),U,2) S X=SDPRCL,DA(1)=DFN,DIC(0)="L",DIC="^DPT("_DA(1)_",""DE""," D FILE^DICN K DIC,DD,D0 G FILE:Y<1 S SDE=+Y,SDFILE=""
DATE ;R !,?10,"DATE OF ENROLLMENT: NOW// ",X:DTIME  ;IHS/ANMC/LJF 6/23/2000
 ;I X["^" D:$D(SDFILE) DIK(.DFN,.SDE) G DIEQ    ;IHS/ANMC/LJF 6/23/2000
 ;S:X="" X="NOW" S %DT="EXT" D ^%DT G:Y<0 DATE  ;IHS/ANMC/LJF 6/23/2000
 S X="NOW" S %DT="EXT" D ^%DT G:Y<0 DATE  ;IHS/ANMC/LJF 6/23/2000
 S:'$D(^DPT(DFN,"DE",SDE,1,0)) $P(^DPT(DFN,"DE",SDE,1,0),U,2)=$P(^DD(2.001,1,0),U,2)
 ;K DO,DD S X=Y,DA(2)=DFN,DA(1)=SDE,DIC("DR")=1,DIC="^DPT("_DA(2)_",""DE"","_DA(1)_",1,",DIC(0)="L" D FILE^DICN K DIC,DD,D0
 K DO,DD S X=Y,DA(2)=DFN,DA(1)=SDE,DIC("DR")="1///O",DIC="^DPT("_DA(2)_",""DE"","_DA(1)_",1,",DIC(0)="L" D FILE^DICN K DIC,DD,D0  ;IHS/ANMC/LJF 6/23/2000
 I Y<1,$D(SDFILE) D DIK(.DFN,.SDE)
 K DIK,DA
DIEQ Q $$CHK(.DFN,.SDCL)
 ;
DIK(DFN,SDE) ;
 N DA,DIK
 S DA(1)=DFN,DA=SDE,DIK="^DPT("_DA(1)_",""DE""," D ^DIK
 Q
 ;
PRIN(CLINIC) ;
 N PRIN
 S PRIN=+$P($G(^SC(CLINIC,"SL")),U,5)
 Q $S($D(^SC(PRIN,0)):PRIN,1:CLINIC)
 ;
SHOW(SDATA) ;
 Q  ;IHS/ANMC/LJF 7/6/2000
 N SDDIS S SDDIS=$P(SDATA,U,3)
 W !,$S('SDDIS:"Current  ",1:"Previous "),"Enrollment: ",$S($P(SDATA,U,2)["O":"OPT",1:"AC")
 I SDDIS W ?41,"Discharged from clinic: ",$$FTIME^VALM1(SDDIS)
 Q
 ;
TEST ;
 S Y=$$ENROL(1,317)
 W !!,Y
