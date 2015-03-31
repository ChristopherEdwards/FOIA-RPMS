PSOLMPAT ;BHAM ISC/SAB - update pharmacy patient data using listman ;17-Jun-2013 14:18;DU
 ;;7.0;OUTPATIENT PHARMACY;**15,117,1007,1011,149,233,268,1015**;DEC 1997;Build 62
 ;External reference ^PS(55 supported by DBIA 2228
 ; Modified - IHS/MSC/PLS - 07/11/08 - Line EX+1
 ;            IHS/MSC/PLS - 03/28/11 - Line P55+2
 ;            IHS/MSC/MGH - 06/12/13 - Line EN+3
EN I '$D(PSOPAR) D ^PSOLSET I '$D(PSOPAR) S VALMSG="Site Parameters must be Defined!" G EX
 D HLDHDR^PSOLMUTL S DA=DFN,PI=""
 ;IHS/MSC/MGH Commented out section to us old address method
 ;I '$P($G(PSOPAR),"^",22),'$D(^XUSEC("PSO ADDRESS UPDATE",+$G(DUZ))) G P55
 ;L +^PS(55,DA):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3) I '$T D MSG G EX
 ;S PSODFN=DA D UPDATE^PSOBAI S DA=PSODFN
 ;W !
 L +^DPT(DA):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3) I '$T D MSG G EX
 ;S DIE="^DPT(",DR="[PSO OUTPT]"
 ;New input parameter
 S DIE="^DPT(",DR="[APSP OUTPT]"
 ;end patch 1015 mods
 D FULL^VALM1,^DIE L -^DPT(DA)
P55 I '$D(^PS(55,DFN)) K DIC S DIC="^PS(55,",DIC(0)="LZ",(X,DINUM)=DFN K DD,DO D FILE^DICN K DIC
 I $G(DFN),$P($G(^PS(55,DFN,0)),"^")="" S $P(^PS(55,DFN,0),"^")=DFN K DIK S DA=DFN,DIK="^PS(55,",DIK(1)=.01 D EN^DIK K DIK S DA=DFN
 ;IHS/MSC/PLS - 03/28/2011
 ;S DIE="^PS(55,",DR=".02;.03;.05;.04;1;3;40:41.1;106;106.1" W !!?5,">>PHARMACY PATIENT DATA<<",! D ^DIE
 S DIE="^PS(55,",DR=".02;.03;.05;.04;1;3;40:41.1" W !!?5,">>PHARMACY PATIENT DATA<<",! D ^DIE
EX L -^PS(55,DA),-^DPT(DA) D ^PSOORUT2 S VALMBCK="R"
 ; IHS/MSC/PLS - 07/11/08 - Kill of PSOFROM causing problems with autorelease
 ;K DIC,X,Y,DIE,D0,DA,DFN,PI,DR,%,%Y,%X,C,DI,DIPGM,DQ,PSOFROM
 K DIC,X,Y,DIE,D0,DA,DFN,PI,DR,%,%Y,%X,C,DI,DIPGM,DQ
 Q
MSG S VALMSG="Patient Data is Being Edited by Another User!" Q
