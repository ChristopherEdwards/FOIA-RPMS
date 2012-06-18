ASDOI ; IHS/ADC/PDW/ENM - ADD/EDIT OTHER INFORMATION ; [ 09/30/2002  9:25 AM ]
 ;;5.0;IHS SCHEDULING;**8**;MAR 25, 1999
 ;IHS/ITSC/KMS, 09/30/2002 - Cache' compliancy.
 ;
 S:'$D(DTIME) DTIME=300 D:'$D(DT) DT^SDUTL S HDT=DT,APL=""
RD S DIC="^DPT(",DIC(0)="AEQM",CNT=0 D ^DIC I X=U!(X="") G END
 S DFN=+Y,NAME=$P(Y,U,2) W ! I $O(^DPT(DFN,"S",HDT))'>0 D NO G RD
 S NDT=HDT,L=0
 F J=1:1 S NDT=$O(^DPT(DFN,"S",NDT)) Q:'NDT  D
 . S X=$P(^DPT(DFN,"S",NDT,0),U,2) I $S(X="":1,X["I":1,1:0) D
 .. D CHKSO S SC=+^DPT(DFN,"S",NDT,0),L=L+1 D FLEN
 .. S Z(L)=NDT_U_SC_U_APL_U_COMMENT_U_ZL
 I L'>0 D NO G RD
 F ZZ=1:1:L D
 . W !!,ZZ,") " S Y=$P($P(Z(ZZ),U,1),".",1)
 . D DT^SDM0 S X=$P(Z(ZZ),U,1) X ^DD("FUNC",2,1)
 . W " ",$J(X,8)," (",$P(Z(ZZ),U,3)," MINUTES)  "
 . W $P(^SC($P(Z(ZZ),U,2),0),U,1)," ",$P(Z(ZZ),U,4)
 ;
WH W !! K DIR S DIR(0)="NO^1:"_ZZ
 S DIR("A")="ADD/EDIT OTHER INFO FOR WHICH NUMBERED APPOINTMENT"
 S DIR("?")="Enter the number that corresponds to the appointment."
 D ^DIR S APP=Y I $D(DIRUT) G RD
 S SD=$P(Z(APP),U,1),SCX=$P(Z(APP),U,2),SDY=$P(Z(APP),U,5),CNT=CNT+1
 D OTHER G RD
 ;
 ;
NO W !,"NO PENDING APPOINTMENTS",*7,*7,*7 Q
 ;
FLEN ; find appt multiple
 I $D(^SC(SC,"S",NDT)) F ZL=0:0 S ZL=$O(^SC(SC,"S",NDT,1,ZL)) Q:'ZL  I +^SC(SC,"S",NDT,1,ZL,0)=DFN S APL=$P(^SC(SC,"S",NDT,1,ZL,0),U,2) Q
 Q
 ;
CHKSO ; -- check if tests scheduled
 S COMMENT="",SDAPAV=^DPT(DFN,"S",NDT,0),SDANAM="LAB"_U_"XRAY"_U_"EKG"
 F SDJ=3,4,5 D
 . I $P(SDAPAV,U,SDJ)]"" D
 .. S:$L(COMMENT) COMMENT=COMMENT_","
 .. S COMMENT=COMMENT_$S(SDJ=3:"LAB",SDJ=4:"XRAY",1:"EKG")
 .. S @($P(SDANAM,U,SDJ-2))=$P(SDAPAV,U,SDJ)
 S:$L(COMMENT) COMMENT="("_COMMENT_" TEST SCHEDULED)"
 Q
 ;
END K CNT,NDT,L,J,HDT,SC,SD,APL,COMMENT,Z,ZZ,APP,ZL,SDJ,X,%DT,DIC,DFN
 K NAME,Y,POP,SDAPAV,SDTY,SDX,SDY,%,D,SCX Q
 ;
OTHER ; -- edits other info field
 L +^SC(SCX,"S",SD):3 I '$T D  Q
 . W !,*7,"APPOINTMENT ENTRY LOCKED; TRY AGAIN SOON"
 ;IHS/ITSC/KMS, 09/30/2002,  Added extra space " " after DO for Cache' compliance.
 ;I '$D(^SC(SCX,"S",SD,1,0)) D ;searhc/maw patch to add header
 I '$D(^SC(SCX,"S",SD,1,0)) D  ;searhc/maw patch to add header
 . S ^SC(SCX,"S",SD,1,0)="^44.003PA^^" ;maw added
 W ! S DIE="^SC("_SCX_",""S"","_SD_",1,",DA=SDY,DA(1)=SD,DA(2)=SCX
 S DR="3T" D ^DIE L -^SC(SCX,"S",SD)
 Q
