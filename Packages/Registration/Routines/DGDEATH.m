DGDEATH ;ALB/MRL-PROCESS DECEASED PATIENTS ;19 JUN 87
 ;;5.3;Registration;**45,84,101,149,392**;Aug 13, 1993
 ;
GET S DGDTHEN="" W !! S DIC="^DPT(",DIC(0)="AEQMZ" D ^DIC G Q:Y'>0 S (DA,DFN)=+Y
 I $D(^DPT(DFN,.1)) W !?3,"Patient is currently in-house.  Discharge him with a discharge type of DEATH." G GET
 I $S($D(^DPT(DFN,.35)):^(.35),1:"") F DGY=0:0 S DGY=$O(^DGPM("ATID1",DFN,DGY)) Q:'DGY  S DGDA=$O(^(DGY,0)) I $D(^DGPM(+DGDA,0)),$P(^(0),"^",17)]"" S DGXX=$P(^(0),"^",17),DGXX=^DGPM(DGXX,0) I "^12^38^"[("^"_$P(DGXX,"^",18)_"^") G DIS
 K A W ! S DIE=DIC,DR=".351" D ^DIE G GET
 ;
DIS W !,"Patient has a discharge type of Death",!,"Edit the discharge",!
Q K A,DA,DFN,DGDA,DIC,DIE,DR,DGXX,DGY,DGDTHEN Q
XFR ; called from set x-ref of field .351 of file 2
 N DGPCMM,DGFAPT,DGFAPTI,DGFAPT1
 Q:'$D(DFN)
 K DGTEXT D ^DGPATV S DGDEATH=X,XMSUB="PATIENT HAS EXPIRED",DGCT=0
 D DEMOG
 S DGT=X-.0001,(Y,DGDDT)=X,DG1="" D:DGT]"" ^DGINPW
 S Y=$$FMTE^XLFDT(Y),Y=$S(Y]"":Y,1:"UNKNOWN")
 D LINE("")
 D LINE("      Date/Time of Death: "_Y_$S('DG1:"",$D(DGDTHEN):"",1:"  (While an inpatient)"))
 D LINE("")
 I '$D(ADM),DG1,$D(^DGPM(+DGA1,0)) S ADM=+^DGPM($P(^(0),"^",14),0)
 S Y=$$FMTE^XLFDT($S($D(ADM):ADM,1:""))
 D LINE($S($D(DGDTHEN):"",DG1:"     Admission Date/Time: "_Y_$S((DGDDT-ADM)<1:"  (Within 24 hours of hospitalization)",1:""),1:""))
 D LINE("")
 S DGX=$P($G(^DGPM(+$G(DGA1),0)),"^",6),DGX=$P($G(^DIC(42,+DGX,0)),U,1)
 D LINE($S($D(DGDTHEN):"",('DG1):"",$D(DGA1):"             Admitted To: "_$S(DGX]"":DGX,1:"UNKNOWN"),1:"")) K DGX
 D LINE("")
 I DG1&'$D(DGDTHEN) D 
 . D LINE($S($D(DGXFR0):"           Last Transfer: "_$S($D(^DIC(42,+$P(DGXFR0,"^",6),0)):$P(^(0),"^"),1:"UNKNOWN"),1:""))
 . D LINE("")
F S DGFAPT=DGDEATH,DGFAPTI=""
 F  S DGFAPT=$O(^DPT(DFN,"S",DGFAPT)) Q:'DGFAPT  S DGFAPT1=$G(^(DGFAPT,0)) Q:'DGFAPT1  D  Q:DGFAPTI
 .I $P(DGFAPT1,"^",2)'["C" D LINE("NOTE: Patient has future appointments scheduled!!") S DGFAPTI=1
 S DGSCHAD=0 D SA I DGSCHAD D LINE("NOTE: Patient had scheduled admissions which have been cancelled!!")
 I 'DGVETS D LINE("Patient is a NON-VETERAN."_$S($D(^DIC(21,+$P($G(^DPT(DFN,.32)),"^",3),0)):"  ["_$P(^(0),"^",1)_"]",1:""))
 S DGPCMM=$$PCMMXMY^SCAPMC25(1,DFN,,,0) ;creates xmy array
 S DGCT=$$PCMAIL^SCMCMM(DFN,"DGTEXT",DT)
Q1 S DGB=1 D ^DGBUL S X=DGDEATH
 K DGDEATH,DGSCHAD,DGI,Y,DGDDT D KILL^DGPATV K ADM,DG1,DGA1,DGCT,DGT,DGXX,DGY,Z Q
SA F DGI=0:0 S DGI=$O(^DGS(41.1,"B",DFN,DGI)) Q:'DGI  I $D(^DGS(41.1,DGI,0)),($P(^(0),"^",13)']""),($P(^(0),"^",17)']"") S $P(^(0),"^",13)=DGDEATH,$P(^(0),"^",14)=+DUZ,$P(^(0),"^",15)=1,$P(^(0),"^",16)=2,DGSCHAD=1
 Q
 ;
DEL ; delete death bulletin
 N DGPCMM
 S DFN=+$G(DA) I '$D(^DPT(DFN,0)) Q  ; no patient node
 I +$G(^DPT(DFN,.35)) Q  ; not deletion
 S DGDEATH=X,XMSUB="Patient Death has been Deleted",DGCT=0
 D ^DGPATV
 D LINE("The date of death for the following patient has been deleted.")
 D LINE("")
 D DEMOG
 S DGPCMM=$$PCMMXMY^SCAPMC25(1,DFN,,,0) ;creates xmy array
 S DGCT=$$PCMAIL^SCMCMM(DFN,"DGTEXT",DT)
 S DGB=1 D ^DGBUL S X=DGDEATH
 K DGCT,DGDEATH D KILL^DGPATV
 Q
 ;
DEMOG ; list main demographics
 D LINE("                    NAME: "_DGNAME)
 D LINE("                     SSN: "_$P(SSN,"^",2))
 D LINE("                     DOB: "_$P(DOB,"^",2))
 I DGVETS D
 . N DGX
 . S DGX=$G(^DPT(DFN,.31))
 . S DGLOCATN=$$FIND1^DIC(4,"","MX","`"_+$P(DGX,U,4)),DGLOCATN=$S(+DGLOCATN>0:$P($$NS^XUAF4(DGLOCATN),U),1:"NOT LISTED")
 . D LINE("   CLAIM FOLDER LOCATION: "_$S($D(DGLOCATN):DGLOCATN,1:"NOT LISTED"))
 . D LINE("            CLAIM NUMBER: "_$S($P(DGX,"^",3)]"":$P(DGX,"^",3),1:"NOT LISTED"))
 D LINE("   COORDINATING MASTER OF RECORD: "_DGCMOR)
 Q
 ;
LINE(X) ; add line contained in X to array
 S DGCT=DGCT+1
 S DGTEXT(DGCT,0)=X
 Q
