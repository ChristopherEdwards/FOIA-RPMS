PSGOEV ;BIR/CML3-VERIFY (MAKE ACTIVE) ORDERS ;08-Mar-2006 10:23;SM
 ;;5.0; INPATIENT MEDICATIONS ;**5,7,15,28,33,50,64,58,77,78,80,1004**;16 DEC 97
 ;
 ; Reference to ^ORD(101 supported by DBIA #872.
 ; Reference to ^PS(50.7 supported by DBIA #2180.
 ; Reference to ^PS(55 supported by DBIA #2191.
 ; Reference to MAIN^TIUEDIT is supported by DBIA 2410.
 ;
 ; Modified - IHS/CIA/PLS - 10/14/05 - Line VFY+39
 ;                          03/08/06 -      VFY+17
 ;
EN(PSGORD) ;
ENSF ; This entry point is used by Speed finish only.
 ; Send SN update to CPRS if autoverify off and from Order Set entry
 I $D(PSGOES),'PSGOEAV,PSGORD["P",$P($G(^PS(53.1,+PSGORD,0)),"^",21)']"" D ORSET^PSGOETO1
 D FULL^VALM1 I 'PSJSYSU W $C(7),$C(7),!!," THIS FUNCTION NOT AVAILABLE TO WARD STAFF." Q
 S CHK=0 I PSGORD["P" S X=$P($G(^PS(53.1,+PSGORD,0)),"^",19) I X,$D(^PS(55,PSGP,5,$P(^(0),"^",19))) S CHK=+PSGORD,PSGORD=X_"U" L -^PS(53.1,CHK) L +^PS(55,PSGP,5,+PSGORD):1 E  W !!,"Another terminal is editing this order." G DONE
 I +PSJSYSU=3 D DDCHK G:CHK DONE
 I PSGORD["P" D CHK($G(^PS(53.1,+PSGORD,0)),$G(^(.2)),$G(^(2)))
 I CHK Q:$D(PSJSPEED)  D EN^VALM("PSJU LM ACCEPT") G:'$G(PSJACEPT) DONE ;G VFY
 G:'$D(^PS(55,PSGP,5,+PSGORD,4)) VFY I +PSJSYSU=3,$P(^(4),"^",3) W $C(7),!!,"THIS ORDER HAS ALREADY BEEN VERIFIED BY A PHARMACIST." S PSGACT=$P(PSGACT,"V")_$P(PSGACT,"V",2) G DONE
 I +PSJSYSU=1,+^PS(55,PSGP,5,+PSGORD,4) W $C(7),!!,"THIS ORDER HAS ALREADY BEEN VERIFIED BY A NURSE." S PSGACT=$P(PSGACT,"V")_$P(PSGACT,"V",2) G DONE
 ;
VFY ; change status, move to 55, and change label record
 NEW PSJDOSE,PSJDSFLG
 ;I 'PSGOEAV D DOSECHK^PSJDOSE
 D DOSECHK^PSJDOSE
 I +$G(PSJDSFLG) D SETVAR^PSJDOSE W !!,PSJDOSE("WARN"),!,PSJDOSE("WARN1") I '$$CONT() W !,"...order was not verified..." D PAUSE^VALM1 D  Q:'$G(PSJACEPT)
 . S PSGOEEF(109)=1
 . S PSJACEPT=0
 . ;D EN^VALM("PSJU LM ACCEPT")
 D DDCHK G:CHK DONE
 W !,"...a few moments, please..."
 ;/I PSGORD["P" S DIE="^PS(53.1,",DA=+PSGORD,DR="28////A" W "." D ^DIE,^PSGOT
 I PSGORD["P" D
 . S PSGORDP=PSGORD ;Used in ACTLOG to update activity log in 55
 . ;NEW PSGX S PSGX=$G(^PS(53.1,+PSGORD,2.5)),PSGRSD=$P(PSGX,U),PSGRFD=$P(PSGX,U,3)
 . D REQDT^PSJLIVMD(PSGORD)
 . S DIE="^PS(53.1,",DA=+PSGORD,DR="28////A" W "." D ^DIE,^PSGOT
 S DA=+PSGORD,DA(1)=PSGP,PSGAL("C")=PSJSYSU*10+22000 D ^PSGAL5 W "." S VND4=$G(^PS(55,PSGP,5,DA,4))
 D:$$PATCH^XPDUTL("BOP*1.0*1") ^BOPSD  ;IHS/CIA/PLS -03/08/2006  - ADS SUPPORT
 I $G(PSGRDTX) D NEWUDAL^PSGAL5(PSGP,PSGORD,6090,"Requested Start Date",+$G(PSGRDTX))
 I $P($G(PSGRDTX),U,3) D NEWUDAL^PSGAL5(PSGP,PSGORD,6090,"Requested Stop Date",+$P($G(PSGRDTX),U,3))
 D:$D(PSGORDP) ACTLOG(PSGORDP,PSGP,PSGORD)
 K PSGRSD,PSGRFD,PSGALFN
 N DUR,DURON S DURON=$S($G(ON)&($G(PSGORD)["U"):ON,$G(PSGORD):PSGORD,1:"") Q:'DURON  D
 . S DUR=$S($P($G(PSGRDTX),U,2)]"":$P($G(PSGRDTX),U,2),1:$$GETDUR^PSJLIVMD(PSGP,+DURON,$S($G(DURON)["P":"P",$G(DURON)["V":"IV",1:5),1),1:"")
 I DUR]"" S $P(^PS(55,PSGP,5,+PSGORD,2.5),"^",2)=DUR
 NEW X S X=0 I $G(PSGONF),(+$G(PSGODDD(1))'<+$G(PSGONF)) S X=1
 I +PSJSYSU=3,PSGORD'["O",$S(X:0,'$P(VND4,"^",9):1,1:$P(VND4,"^",15)) D EN^PSGPEN(+PSGORD)
 S $P(VND4,"^",+PSJSYSU=1+9)=1 S:'$P(VND4,U,+PSJSYSU=3+9) $P(VND4,U,+PSJSYSU=3+9)=+$P(VND4,U,+PSJSYSU=3+9)
 ;S $P(VND4,"^",+PSJSYSU=1+9)=1,$P(VND4,U,+PSJSYSU=3+9)=0
 I PSJSYSL>1 S $P(^PS(55,PSGP,5,+PSGORD,7),U)=PSGDT S:$P(^(7),U,2)="" $P(^(7),U,2)="N"_$S($P(^PS(55,PSGP,5,+PSGORD,0),"^",24)="E":"E",1:"") S PSGTOL=2,PSGUOW=DUZ,PSGTOO=1,DA=+PSGORD D ENL^PSGVDS
 S:$P(VND4,"^",15)&'$P(VND4,"^",16) $P(VND4,"^",15)="" S:$P(VND4,"^",18)&'$P(VND4,"^",19) $P(VND4,"^",18)="" S:$P(VND4,"^",22)&'$P(VND4,"^",23) $P(VND4,"^",22)="" S $P(VND4,"^",PSJSYSU,PSJSYSU+1)=DUZ_"^"_PSGDT,^PS(55,PSGP,5,+PSGORD,4)=VND4
 I '$P(VND4,U,9) S ^PS(55,"APV",PSGP,+PSGORD)=""
 I '$P(VND4,U,10) S ^PS(55,"ANV",PSGP,+PSGORD)=""
 I $P(VND4,U,9) K ^PS(55,"APV",PSGP,+PSGORD)
 I $P(VND4,U,10) K ^PS(55,"ANV",PSGP,+PSGORD)
 W:'$D(PSJSPEED) ! W !,"ORDER VERIFIED.",!
 I '$D(PSJSPEED) K DIR S DIR(0)="E" D ^DIR K DIR
 S:+PSJSYSU=3 ^PS(55,"AUE",PSGP,+PSGORD)="" S PSGACT="C"_$S('$D(^PS(55,PSGP,5,+PSGORD,4)):"E",$P(^(4),"^",16):"",1:"E")_"RS",PSGCANFL=2
 ;S VALMBCK="Q" D EN1^PSJHL2(PSGP,$S(+PSJSYSU=3:"SC",(+PSJSYSU=1)&$G(PSJRNF):"SC",1:"XX"),+PSGORD_"U")
 S VALMBCK="Q" D EN1^PSJHL2(PSGP,$S(+PSJSYSU=3:"SC",+PSJSYSU=1:"SC",1:"XX"),+PSGORD_"U")     ; allow status change to be sent for pharmacists & nurses
 D CALLBOP  ;IHS/CIA/PLS - 10/14/05 - Call to Automated Dispensing System
 D:+PSJSYSU=1 EN1^PSJHL2(PSGP,"ZV",+PSGORD_"U")
 ;
DONE ;
 W:CHK !!,"...order NOT verified..."
 I '$D(PSJSPEED),'CHK,+PSJSYSU=3,$G(PSJPRI)="D" D
 .N DIR W ! S DIR(0)="S^Y:Yes;N:No",DIR("A")="Do you want to enter a Progress Note",DIR("B")="No" D ^DIR
 .Q:Y="N"
 .D MAIN^TIUEDIT(3,.TIUDA,PSGP,"","","","",1)
 S VALMBCK="Q" K CHK,DA,DIE,F,DP,DR,ND,PSGAL,PSGODA,PSJDOSE,PSJVAR,VND4,X Q
 ;
LBL ;
 F Q=0:0 S Q=$O(^PS(59.4,"ALN",Q)) Q:'Q  I $D(^(Q,PSGP,"N",+PSGODA)) S ^PS(59.4,"ALN",Q,PSGP,"A",+PSGORD)=^(+PSGODA) K ^PS(59.4,"ALN",Q,PSGP,"N",+PSGODA)
 I $P(PSJSYSW0,"^",+PSJSYSU=3*4+12)<2 S ^PS(59.4,"ALN",DUZ,PSGP,"A",+PSGORD)=PSJSYSW_"^"_PSGDT,$P(^PS(55,PSGP,5,+PSGORD,7),"^",1,2)=PSGDT_"^N"
 Q
 ;
CHK(ND,DRG,ND2) ; checks for data in required fields
 ; Input: ND  - ^(PS(53.1,PSGORD,0)
 ;        DRG - ^(.2)
 ;        ND2 - ^(2)
 S CHK="" I DRG,$D(^PS(50.7,+DRG,0))
 E  S CHK=1
 I ND="" S CHK=CHK_23
 E  S CHK=CHK_$S($P(ND,"^",3):"",1:2)_$S($P(ND,"^",7)]"":"",1:3)
 ;The naked reference on the line below refers to the variable ND
 ;which is ^PS(53.1,PSGORD,0).
 I ND2="" S CHK=CHK_$S('$D(^(0)):4,$P(^(0),"^",7)="OC":"",1:4)_56
 E  S CHK=CHK_$S($P(ND2,"^")]"":"",ND="":4,$P(ND,"^",7)="OC":"",1:4)_$S($P(ND2,"^",2):"",1:5)_$S($P(ND2,"^",4):"",1:6)
 I $$CHECK^PSGOE8(PSJSYSP),$P(DRG,U,2)="" S CHK=CHK_8
 K PSGDFLG,PSGPFLG S PSGDI=0
 S:'$$DDOK^PSGOE2("^PS(53.45,"_PSJSYSP_",2,",+DRG) CHK=CHK_7,(PSGDFLG,PSGDI)=1
 S:'$$OIOK^PSGOE2(+DRG) PSGPFLG=1
 Q:'CHK
 ;D:(+PSJSYSU=3)!((+PSJSYSU=1)&($G(PSJNORD)=""))  Q:'CHK
 ;.I '$O(^PS(53.45,PSJSYSP,2,0)) S CHK=CHK_7 Q
 ;.N X S X=0
 ;.F Q=0:0 S Q=$O(^PS(53.45,PSJSYSP,2,Q)) Q:'Q  S ND=$G(^(Q,0)) D
 ;..I $P(ND,U,3),($P(ND,U,3)'>PSGDT) Q
 ;..S:$S('$D(^PSDRUG(+ND,0)):0,$P($G(^(2)),U,3)'["U":0,(+$G(^(2)))'=+DRG:0,$G(^PSDRUG(+ND,"I"))="":1,1:^("I")>PSGDT) X=1
 ;.S:X'=1 CHK=CHK_7
 W $C(7)
 ;
CHKM ;
 D FULL^VALM1
 ; changed to remove ^DD ref
 W !!,"THE FOLLOWING ",$S($L(CHK)>1:"ARE",1:"IS")," EITHER INVALID OR MISSING FROM THIS ORDER:" F X=1:1:7 W:CHK[X !?5,$P("ORDERABLE ITEM^MED ROUTE^SCHEDULE TYPE^SCHEDULE^START DATE/TIME^STOP DATE/TIME^DISPENSE DRUG","^",X)
 W !,"Orders with no dispense drugs or multiple dispense drugs",!,"require dosage ordered"
 W:CHK]"" !!,$S($L(CHK)>1:"THESE FIELDS ARE",1:"THIS FIELD IS")," NECESSARY FOR VERIFICATION."
 N DIR S DIR(0)="E" D ^DIR I $D(DUOUT)!$D(DTOUT) S CHK=1 Q
 Q
 ;
CONT() ;
 NEW DIR,DIRUT,Y
 W ! K DIR,DIRUT
 S DIR(0)="Y",DIR("A")="Would you like to continue verifying the order",DIR("B")="Yes"
 D ^DIR
 Q Y
 ;
DDCHK ; dispense drug check
 S DRGF="^PS("_$S(PSGORD["P":"53.1,"_+PSGORD,1:"55,"_PSGP_",5,"_+PSGORD)_",",CHK=$S('$O(@(DRGF_"1,0)")):7,1:0)
 S PSGPD=$G(@(DRGF_".2)"))
 S CHK=$S('$$DDOK^PSGOE2(DRGF_"1,",PSGPD):7,1:0)
 Q:CHK=0
 W $C(7),!!,"This order must have at least one valid, active dispense drug to be verified."
 ;
DDEDIT ;
 ;*** Remove all dispense drug for this order
 K @(DRGF_"1)")
 K ^PS(53.45,PSJSYSP,2) S (X,Q)=0 F  S Q=$O(@(DRGF_"1,"_Q_")")) Q:'Q  S Y=$G(^(Q,0)),X=Q S ^PS(53.45,PSJSYSP,2,Q,0)=Y I Y S ^PS(53.45,PSJSYSP,2,"B",+Y,Q)=""
 I X S ^PS(53.45,PSJSYSP,2,0)="^53.4502P^"_X_"^"_X
 D ENDRG^PSGOEF1(PSGPD,X)
 I 'CHK S %X="^PS(53.45,"_PSJSYSP_",2,",%Y=DRGF_"1," D %XY^%RCR S $P(@(DRGF_"1,0)"),"^",2)=$S(DRGF[53.1:"53.11P",1:"55.07P")
 K DRG,DRGF Q
 ;
AESCREEN() ;
 ; Output: 0 - Required fields missing and DON'T allow accept
 ;         1 - Required fields found.
 Q:'$G(CHK) 1
 S Y=$P($G(^ORD(101,+$G(^ORD(101,DA(1),10,DA,0)),0)),U) I Y="" Q 0
 I Y="PSJU LM ACCEPT EDIT" Q 1
 Q 0
ACTLOG(PSGORDP,DFN,PSGORD) ;Store 53.1 activity log in local array to be moved to 55
 ;PSGORDP: IEN from 53.1
 ;PSGORD : IEN from 55
 NEW PSGX,PSGXDA,PSGAL531,Q,QQ
 F PSGX=0:0 S PSGX=$O(^PS(53.1,+PSGORDP,"A",PSGX)) Q:'PSGX  D
 . S PSGAL531=$G(^PS(53.1,+PSGORDP,"A",PSGX,0))
 . S QQ=$G(^PS(55,DFN,5,+PSGORD,9,0)) S:QQ="" QQ="^55,09D" F Q=$P(QQ,U,3)+1:1 I '$D(^(Q)) S $P(QQ,U,3,4)=Q_U_Q,^(0)=QQ,PSGXDA=Q Q
 . S ^PS(55,DFN,5,+PSGORD,9,PSGXDA,0)=PSGAL531
 Q
 ; Call Automated Dispensing System if present
CALLBOP ;
 D:$$PATCH^XPDUTL("BOP*1.0*1") NEW^BOPCAP
 Q