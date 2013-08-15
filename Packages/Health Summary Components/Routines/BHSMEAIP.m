BHSMEAIP ;IHS/CIA/MGH - Health Summary for Inpt Measurements ;13-Aug-2012 09:46;DU
 ;;1.0;HEALTH SUMMARY COMPONENTS;**7**;March 17, 2006;Build 12
 ;===================================================================
 ;Taken from APCHS2
 ; IHS/TUCSON/LAB - PART 2 OF APCHS -- SUMMARY PRODUCTION COMPONENTS ;
 ;;2.0;IHS RPMS/PCC Health Summary;**2,3**;JUN 24, 1997
 ;IHS/CMI/LAB - patch 2 fixed AGE subroutine
 ;IHS/CMI/LAB - patch 3 new imm package
 ;Creation of VA health summary components from IHS health summary components
 ;for V measurement file and immunizations
 ;Patch 2 for patch 16 and CVS changes
 ;Patch 3 to fix a bug in the display
 ;Patch 4 added qualifiers for vitals
 ;Patch 5 fixed a bug with items with / in them
 ;
INPMEAS ; ******************** MEASUREMENTS INPT ********** 9000010.01 *******
 ; <SETUP>
 N BHSPAT,BHSNDM,Y,ARRAY,BHSVST,BHSVDTE,VCNT,BHSINPV,BHSINVDT,APCHMEAS,BHSINPS,X,C,VIEN
 S BHSPAT=DFN
 Q:'$D(^AUPNVMSR("AA",BHSPAT))
 ; <DISPLAY>
 D CKP^GMTSUP Q:$D(GMTSQIT)  W !
 NEW X,Y,V
 S VIEN="",VCNT=0
 S BHSNDM=GMTSNDM-1
 S BHSINVDT=0 F  S BHSINVDT=$O(^AUPNVSIT("AAH",BHSPAT,BHSINVDT)) Q:BHSINVDT=""!(VCNT>BHSNDM)  D
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AAH",BHSPAT,BHSINVDT,VIEN)) Q:VIEN=""!(VCNT>BHSNDM)  D
 ..Q:'$D(^AUPNVSIT(VIEN,0))
 ..Q:$P(^AUPNVSIT(VIEN,0),U,3)="C"  ;don't count contract visits
 ..S BHSINPB=$P($P(^AUPNVSIT(VIEN,0),U,1),".")  ;admission date of last H visit
 ..S BHSINPS=9999999-BHSINPB
 ..S BHSINPD=$$DSCHDATE^APCLV(VIEN)  ;get discharge date
 ..I BHSINPD="" S BHSINPD=DT  ;if no discharge date, set to DT as this means the patient is in-house
 ..S VCNT=VCNT+1
 ..D GET(BHSINPD,BHSINPB)
 D MEASDSP
 ; <CLEANUP>
MEASX K BHSDFN,BHSMT,BHSMT2,BHSMT3,BHSDFN,BHSND2,BHSDAT,BHSMIEN,BHSM,BHSEVD,BHSMDSP,BHSIVD,BHSVSIT,BHSX,BHSWP,APCHWP,APCHMEAS
 Q
 ;Get the visit(s) to check on
GET(BHSINPD,BHSINPB) ;
 ;loop through all visits from adm date to discharge date (or DT) and display measurements from
 ;H and I visits
 S BHSIVD=(9999999-BHSINPD-1)_".9999"
 F  S BHSIVD=$O(^AUPNVSIT("AA",BHSPAT,BHSIVD)) Q:$P(BHSIVD,".")>BHSINPS!(BHSIVD="")  D
 .S BHSVSIT=0 F  S BHSVSIT=$O(^AUPNVSIT("AA",BHSPAT,BHSIVD,BHSVSIT)) Q:BHSVSIT'=+BHSVSIT  D
 ..Q:'$D(^AUPNVSIT(BHSVSIT,0))
 ..Q:"HI"'[$P(^AUPNVSIT(BHSVSIT,0),U,7)  ;only H and I
 ..S BHSM=0 F  S BHSM=$O(^AUPNVMSR("AD",BHSVSIT,BHSM)) Q:BHSM=""  D
 ...;GET EVENT DATE/TIME OR VISIT DATE/TIME
 ...Q:'$D(^AUPNVMSR(BHSM,0))
 ...Q:$P(^AUPNVMSR(BHSM,0),U,1)=""
 ...Q:$P($G(^AUPNVMSR(BHSM,2)),U,1)  ;entered in error so skip it
 ...S BHSEVD=+$E($P($G(^AUPNVMSR(BHSM,12)),U,1),1,12)  ;STRIP OFF SECONDS IF ENTERED PER SUSAN AND MARY ANN EMAIL
 ...I BHSEVD=""!(BHSEVD=0) S BHSEVD=$P(^AUPNVSIT(BHSVSIT,0),U,1)  ;visit date/time if no event date time
 ...I BHSMDSP="D" S APCHMEAS(BHSEVD,$$VAL^XBDIQ1(9000010.01,BHSM,.01),BHSM)=""
 ...I BHSMDSP="T" S APCHMEAS($$VAL^XBDIQ1(9000010.01,BHSM,.01),BHSEVD,BHSM)=""
 Q
MEASDSP ;
 I BHSMDSP="T" G MEASDSPT  ;display by type
 S BHSIVD="" F  S BHSIVD=$O(APCHMEAS(BHSIVD),-1) Q:BHSIVD=""!($D(GMTSQIT))  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W !,?2,$$DT(BHSIVD)
 .S BHSMT="" F  S BHSMT=$O(APCHMEAS(BHSIVD,BHSMT)) Q:BHSMT=""!($D(GMTSQIT))  D
 ..S BHSDFN=0 F  S BHSDFN=$O(APCHMEAS(BHSIVD,BHSMT,BHSDFN)) Q:BHSDFN=""!($D(GMTSQIT))  D MEASDSP1
 Q
MEASDSPT ;
 ;
 S BHSMT="" F  S BHSMT=$O(APCHMEAS(BHSMT)) Q:BHSMT=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W !?1,$S(BHSMT="O2":"O2 Sat",1:BHSMT)
 .S BHSIVD="" F  S BHSIVD=$O(APCHMEAS(BHSMT,BHSIVD),-1) Q:BHSIVD=""!($D(GMTSQIT))  D
 ..S BHSDFN=0 F  S BHSDFN=$O(APCHMEAS(BHSMT,BHSIVD,BHSDFN)) Q:BHSDFN=""!($D(GMTSQIT))  D
 ...D MEASDSP2
 Q
DT(D) ;
 NEW A
 S A=$$FMTE^XLFDT(D,5)
 S A=$P(A,"@",2),A=$P(A,":",1,2)
 NEW B
 S B=$E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
 Q B_$S(A]"":"@",1:"")_A
 ;
MEASDSP1 ;
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W ?21,$S(BHSMT="O2":"O2 Sat",1:BHSMT) D REST
 Q
MEASDSP2 ;
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W:GMTSNPG ?1,$S(BHSMT="O2":"O2 Sat",1:BHSMT)
 W ?9,$$DT(BHSIVD)
 D REST
 Q
REST ;
 W ?29,$P(^AUPNVMSR(BHSDFN,0),U,4)
 I $$VAL^XBDIQ1(9000010.01,BHSDFN,.01)="O2" D
 .Q:$P(^AUPNVMSR(BHSDFN,0),U,10)=""
 .W ?41,"Supplemental O2: ",$P(^AUPNVMSR(BHSDFN,0),U,10),!
 I '$O(^AUPNVMSR(BHSDFN,5,0)) W ! Q   ;no qualifiers
 S C=0,X=0 F  S X=$O(^AUPNVMSR(BHSDFN,5,X)) Q:X'=+X  S C=C+1
 W ?41,"Qualifier"_$S(C>1:"s",1:""),":"
 S BHSX=0,X="" F  S BHSX=$O(^AUPNVMSR(BHSDFN,5,BHSX)) Q:BHSX'=+BHSX  S Y=$P($G(^AUPNVMSR(BHSDFN,5,BHSX,0)),U) I Y S X=X_$S(X]"":", ",1:"")_$P($G(^GMRD(120.52,Y,0)),U,1)
 K APCHWP
 D WP^APCHS82(X,23)
 S BHSX=0,C=0 F  S BHSX=$O(APCHWP(BHSX)) Q:BHSX'=+BHSX!($D(GMTSQIT))  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .S C=C+1
 .I C>1 W !
 .W ?53,APCHWP(BHSX)
 W !
 Q
 ;
INPMEASD ;EP
 S BHSMDSP="D"
 G INPMEAS
 Q
INPMEAST ;EP
 S BHSMDSP="T"
 G INPMEAS
 Q
