PSIVSPDC ;BIR/PR,MV-SPEED DC IV ORDERS ;02 Mar 99 / 9:27 AM
 ;;5.0; INPATIENT MEDICATIONS ;**23,29,38,58**;16 DEC 97
 ;
 ; Reference to ^PS(55 is supported by DBIA# 2191.
 ; Reference to ^PSSLOCK is supported by DBIA #2789
 ;
EN ;Loop thru to find IV ien to DC
 I $S(+PSJSYSU=3:0,+PSJSYSU=1:0,1:1) D  Q
 . W !,"You're not allow to DC orders." D PAUSE^VALM1
 NEW ON,ON55,PSIVX,SORT,NAT,PSIVAL,PSJORD,PSGODDD,DIR
 S PSGLMT=$O(^TMP("PSIV",$J,"XB",0))-1
 S:PSGLMT<1 PSGLMT=$G(^TMP("PSJPRO",$J,0))
 Q:'+PSGLMT
 S DIR("?")="Enter the order number(s) to be Discontinued"
 S DIR(0)="L^1:"_PSGLMT,DIR("A")="DISCONTINUE which orders" D ^DIR
 S PSGODDD=Y Q:$D(DIRUT)
 ;prompt for nature of order and requesting provider
 D NATURE^PSIVOREN I '$D(P("NAT"))!'$$REQPROV^PSGOEC W !,$C(7),"No order(s) was DC." H 2 Q
 S NAT=P("NAT") D COMMENT
 S SORT="" F  S SORT=$O(^TMP("PSIV",$J,SORT)) Q:SORT=""  F PSIVX=0:0 S PSIVX=$O(^TMP("PSIV",$J,SORT,PSIVX)) Q:'PSIVX  I PSGODDD[PSIVX S ON=^(PSIVX),ON=(9999999999-ON)_$E(ON,11,11) D SPDCIV
 Q
SPDCIV ;Speed DC orders
 S (PSJORD,ON55)=ON
 I ON["V",$P($G(^PS(55,DFN,"IV",+ON55,.2)),U,4)="D" W !,"             *****        DONE ORDER        *****" D PRNT Q
 I '$$LS^PSSLOCK(DFN,ON) D PRNT Q
 I ON["V" D  Q
 . S P(3)=$P($G(^PS(55,DFN,"IV",+ON55,0)),U,3)
 . D NOW^%DTC Q:P(3)<%
 . D D1^PSIVOPT2
 . S PSIVALT=1,PSIVALCK="STOP",PSIVREA="D",ON=ON55 D LOG
 . S:'$D(P("NAT")) P("NAT")=$G(PSJNOO) D HL^PSIVORA
 . D UNL^PSSLOCK(DFN,ON)
 .;;I $D(PSJNOO) S P("NAT")=PSJNOO D EN1^PSJHL2(DFN,"OC",PSJORD,"ORDER CANCELED")
 N DA,DR,DIE,PSJND S DA=+PSJORD,PSJND=$G(^PS(53.1,DA,0)),P("OLDON")=$P(PSJND,U,25),DIE="^PS(53.1,",DR="28///"_$S($P(PSJND,U,27)="E":"DE",1:"D") D ^DIE
 D HL^PSIVORA
 D UNL^PSSLOCK(DFN,ON)
 Q
COMMENT ;Ask for activity log comments.
 I $G(PSIVALT)=1,'$G(PSJUNDC) K DA,DIR S DIR(0)="55.04,.04" D ^DIR K DA,DIR S PSIVAL=$S($D(DIRUT):"",1:Y)
 Q
LOG ;Record activity log comments.
 S:$G(PSIVALT)=2 PSIVAL="Action taken using OE/RR options." D ENTACT^PSIVAL
 K DA,DIE,DR S DA(2)=DFN,DA(1)=+ON55,DA=PSIVLN,DIE="^PS(55,"_DFN_",""IV"","_+ON55_",""A"",",DR=".02////"_PSIVREA_";.03////"_$P(^VA(200,DUZ,0),U)_";.04////^S X=$G(PSIVAL)"_";.06////"_DUZ D ^DIE
 D STOP^PSIVORAL ;* Record the stop dates
 Q
PRNT ; DISPLAY IV ORDER AND PRINT MESSAGE
 N PSJLINE,PSJOC S PSJLINE=1
 D DSPLORDV^PSJLMUT1(DFN,ON)
 F X=0:0 S X=$O(PSJOC(ON,X)) Q:'X  D
 .W !,$G(PSJOC(ON,X))
 W !,"             ***** NO ACTION TAKEN ON ORDER *****",!
 Q
