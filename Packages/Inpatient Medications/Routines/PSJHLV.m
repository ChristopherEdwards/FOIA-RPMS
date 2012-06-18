PSJHLV ;BIR/CML3-VERIFY (MAKE ACTIVE) ORDERS ;4/8/99  08:16
 ;;5.0; INPATIENT MEDICATIONS ;**39,42,78,92**;16 DEC 97
 ;
 ; Reference to ^PS(50.7 is supported by DBIA# 2180.
 ; Reference to ^PS(55 is supported by DBIA# 2191.
 ; Reference to ^PSDRUG is supported by DBIA# 2192.
 ;
EN(PSJHLDFN,PSGORD) ;
VFY ; change status, move to 55, and change label record
 N PSJPWD,VAIP,DFN,PSGP,PSGORDP S (DFN,PSGP)=PSJHLDFN D IN5^VADPT S:VAIP(5)]"" PSJPWD=+VAIP(5) G:VAIP(5)']"" DONE
 I $P($G(^PS(53.1,+PSGORD,0)),U,4)'="U" D IV Q
 N PSJSYSP S PSJSYSP=+NURSEACK
 N PSGDT D NOW^%DTC S PSGDT=%
 S CHK=0 D DDCHK G:CHK DONE
 D CHK($G(^PS(53.1,+PSGORD,0)),$G(^(.2)),$G(^(2)))
 G:CHK DONE
 S PSGORDP=PSGORD
 S DIE="^PS(53.1,",DA=+PSGORD,DR="28////A" D ^DIE,^PSGOT
 S DA=+PSGORD,DA(1)=PSJHLDFN,PSGAL("C")=22010 D ^PSGAL5 S VND4=$G(^PS(55,PSJHLDFN,5,DA,4))
 S $P(VND4,"^",10)=1
 S:$P(VND4,"^",15)&'$P(VND4,"^",16) $P(VND4,"^",15)="" S:$P(VND4,"^",18)&'$P(VND4,"^",19) $P(VND4,"^",18)="" S:$P(VND4,"^",22)&'$P(VND4,"^",23) $P(VND4,"^",22)="" S $P(VND4,"^",1,2)=+NURSEACK_"^"_PSGDT,^PS(55,PSJHLDFN,5,+PSGORD,4)=VND4
 I '$P(VND4,U,9) S ^PS(55,"APV",PSJHLDFN,+PSGORD)=""
 I '$P(VND4,U,10) S ^PS(55,"ANV",PSJHLDFN,+PSGORD)=""
 I $P(VND4,U,10) K ^PS(55,"ANV",PSJHLDFN,+PSGORD)
 D:$D(PSGORDP) ACTLOG^PSGOEV(PSGORDP,PSJHLDFN,PSGORD)
 D EN1^PSJHL2(PSJHLDFN,"SC",+PSGORD_"U")
 Q
 ;
IV ;
 NEW DRG,DRGI,DRGN,DRGT,FIL,ON,ON55,P,PSJORD,VADM,VAIN
 S ON=PSGORD,PSIVCHG=0,PSJSYSU=1
 D INP^VADPT
 D GT531^PSIVORFA(PSJHLDFN,PSGORD),ACTIVE^PSIVORC2
 K PSIVCHG,PSJIVORF,PSJORF,PSJORIFN,PSJORL,PSJORNP,PSJPINIT,PSJSYSL,PSJSYSU,PSJSYSW,PSJSYSW0
 Q
DONE ;
 K CHK,DA,DIE,DRGF,DP,DR,ND,PSGAL,PSGODA,PSGPD,VND4 Q
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
 S:'$$OIOK^PSGOE2(+DRG) PSGPFLG=1
 Q
 ;
DDCHK ; dispense drug check
 S DRGF="^PS("_$S(PSGORD["P":"53.1,"_+PSGORD,1:"55,"_PSJHLDFN_",5,"_+PSGORD)_",",CHK=$S('$O(@(DRGF_"1,0)")):7,1:0)
 S PSGPD=$G(@(DRGF_".2)"))
 S CHK=$S('$$DDOK(DRGF_"1,",PSGPD):7,1:0)
 Q
 ;
DDOK(PSJF,OI) ;Check to be sure all dispense drugs that are active in the
  ;order are valid.
  ; Input: PSJF - File root of the order including all but the IEN of 
  ;               the drug. (EX "^PS(53.1,X,1,")
  ;        OI   - IEN of the order's orderable item
  ; Output: 1 - all active DD's in the order are valid
  ;         0 - no DD's active DD's or at least one active is invalid
  N DDCNT,ND,PSJ,X S (X,DDCNT)=0
  I '$O(@(PSJF_"0)")) Q 1
  F PSJ=0:0 S PSJ=$O(@(PSJF_PSJ_")")) Q:'PSJ!X  S ND=$G(@(PSJF_PSJ_",0)"))  D
  .I $P(ND,U,3),($P(ND,U,3)'>PSGDT) Q
  .S DDCNT=DDCNT+1
  .S X=$S('$D(^PSDRUG(+ND,0)):1,$P($G(^(2)),U,3)'["U":1,+$G(^(2))'=+OI:1,$G(^("I"))="":0,1:^("I")'>PSGDT)
  Q $S('DDCNT:0,X=1:0,1:1)
