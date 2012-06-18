SCMCWAIT ;ALB/SCK - Broker Utilities for Placement on Wait List ; 30 Oct 2002  3:42 PM
 ;;5.3;Scheduling;**264**;AUG 13, 1993
 ;
 Q
 ;
WAIT(SCOK,SC) ; Place patient on wait list
 ;  'SC BLD PAT CLN LIST'
 ;
 ;M ^JDS=SC
 S TEAM=$G(SC("TEAM")),POS=$G(SC("POSITION")),DFN=$G(SC("DFN")),COMMENT=$G(SC("COMMENT")),SC=$G(SC("SC"))
 S INST=+$P($G(^SCTM(404.51,+$G(TEAM),0)),U,7)
 D INPUT^SDWLRP1(.RES,DFN_U_$S(POS:2,1:1)_U_TEAM_U_$S(POS:POS_U_DUZ,1:U_DUZ)_U_COMMENT_U_SC)
 Q
WAITS(DFN,TEAM,POS,SC) ;
 N DR
 N Y
 D INPUT^SDWLRP1(.RES,DFN_U_$S(POS:2,1:1)_U_TEAM_U_$S(POS:POS_U_DUZ,1:U_DUZ)_"^^"_SC)
 I $G(RES) S OK=0,DA=+$P(RES,U,2),DIE="^SDWL(409.3,",DR="25;S OK=1" D ^DIE  I '$G(OK) S DIK=DIE D ^DIK W !,"Wait list entry deleted" S RES=0
 Q RES
TEAMRM(DFN,TEAM) ;
 N I
 F I=0:0 S I=$O(^SDWL(409.3,"B",+$G(DFN),I)) Q:'I  S A=$G(^SDWL(409.3,I,0)) D
 .I 12'[$P(A,U,5) Q
 .;I $P(A,U,6)'=$G(TEAM) Q
 .I $G(^SDWL(409.3,I,"DIS")) Q
 .;INACTIVATE I
 .N:0 FDA S FDA(409.3,I_",",21)="SA"
 .S FDA(409.3,I_",",19)=DT,FDA(409.3,I_",",23)="C"
 .S FDA(409.3,I_",",20)=DUZ
 .D UPDATE^DIE("","FDA")
 Q
POSRM(TEAMP,POS) ;
 S DFN=+$G(^SCPT(404.42,+$G(TEAMP),0))
 ;S ^JDS("TEAMP")=TEAMP,^JDS("POS")=POS,^JDS("DFN")=DFN
 N I
 F I=0:0 S I=$O(^SDWL(409.3,"B",+$G(DFN),I)) Q:'I  S A=$G(^SDWL(409.3,I,0)) D
 .I 12'[$P(A,U,5) Q
 .;I $P(A,U,7)'=$G(POS) Q
 .I $G(^SDWL(409.3,I,"DIS")) Q
 .N FDA S FDA(409.3,I_",",21)="SA",FDA(409.3,I_",",23)="C"
 .S FDA(409.3,I_",",19)=DT
 .S FDA(409.3,I_",",20)=DUZ
 .D FILE^DIE("","FDA")
 .;INACTIVATE
 Q
ONWAIT(DFN) ;is patient on wait list
 D DEM^VADPT I $G(VADM(6)) Q 9  ;Patient is dead
 N I
 S X=0
 F I=0:0 S I=$O(^SDWL(409.3,"B",+$G(DFN),I)) Q:'I  S A=$G(^SDWL(409.3,I,0)) D  Q:X
 .I 12'[$P(A,U,5) Q
 .I $G(^SDWL(409.3,I,"DIS")) Q
 .S X="3;ON WAITLIST TEAM: "_$P($G(^SCTM(404.51,+$P(A,U,6),0)),U)
 .I $P(A,U,7) S X=X_" POSITION: "_$P($G(^SCTM(404.57,+$P(A,U,7),0)),U)
 I X Q X
 ;Q X
 ;CHECK IF ON TEAM
 N SCD,SCDT S SCOK=$$TMPT^SCAPMC3(DFN,"SCDT","","SCD","SCER1") I $D(SCD(1)) S X=1
 N SCPOS S SCOK=$$TPPT^SCAPMC(DFN,.SCDT,"","","","","","SCPOS","SCBKERR") I $D(SCPOS(1)) S X=2
 Q X
 ;CHECK IF ON POSITION
SORT ;From sort template
 S X=0
 Q
PC(RESULT,POS) ;rpc to see if provider can be pc
 ;S ^JDS("POS")=POS
 D ROLE(.RES,POS) I RES=1 S RESULT(0)=0 Q
 S POENT=+$O(^SCTM(404.52,"AIDT",+$G(POS),1,-(DT+.1))),POENT=$O(^(POENT,0))
 ;S PROV=+$P($G(^SCTM(404.52,+$G(POENT),0)),U,3)
 I 'POENT S RESULT(0)=1 Q
 N D0 S D0=+$G(POENT) D SORT S RESULT(0)=X
 Q
ROLE(RESULT,POS) ;rpc to see if role of position is resident
 N ZERO S ZERO=$G(^SCTM(404.57,+$G(POS),0))
 I $P(ZERO,U,4) S RESULT=0 Q  ;Already pc let them change it.
 S RESULT=0
 I $P($G(^SD(403.46,+$P(ZERO,U,3),0)),U)="RESIDENT (PHYSICIAN)" S RESULT=1
 Q
SC(DFN) ;Is patient 0-50 sc%
 N TEAM,INST S TEAM=$P(DFN,U,2),INST=+$P($G(^SCTM(404.51,+TEAM,0)),U,7)
 S X=0,DFN=+DFN
 N A D ELIG^VADPT S A=$G(VAEL(3)) I $P(A,U)'="Y" Q 0
 I $P(A,U,2)<50 Q $P(A,U,2)
 Q 0
SCLI(RESULT,SC) ;sc sc list
 K RESULT
 S DFN=+$G(SC("DFN"))
 D SDSC^SDWLRP3(.RES,DFN) I RES=-1 S RESULT(0)=-1 Q
 S RESULT(0)="<RESULTS>" N CNT,I S CNT=1 F I=0:0 S I=$O(^TMP("SDWLRP3",$J,I)) Q:'I  S RESULT(CNT)=^(I),CNT=CNT+1
