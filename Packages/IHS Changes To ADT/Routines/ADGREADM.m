ADGREADM ; IHS/ADC/PDW/ENM - READMISSION CHECKS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> called by other routines to check if patient was readmitted
 ;within time limits set by facility as stated in site parameters
 ;Input variables:  DFN=patient internal #
 ;                  DGPMDA=admission internal #
 ;
 I '$D(DGOPT) D VAR^ADGVAR
 K DGRE,DGLSTA,DGDS,DGDSA Q:'$D(DFN)  Q:'$D(DGPMDA)
LAD ; -- last admission
 S DGLSTA=+$G(^DGPM(+$$M3P,0)) S:$$RE DGRE="A"
LDS ;--last day surgery
 S (DGDSA,DGDS)="" Q:'$D(^ADGDS(DFN))
 S DGDSA=$$DSP,DGDS=+$G(^ADGDS(DFN,"DS",+DGDSA,0))
 Q:$P($G(^ADGDS(DFN,"DS",+DGDSA,2)),U,3,4)["Y"  ;no-show or canceled
 Q:'DGDS  S X=DGDT D H^%DTC S X1=%H,X=DGDS D H^%DTC
 I (X1'<%H),(X1-%H)'>$P(DGOPT("QA1"),U,2) D
 . S DGRE=$S($D(DGRE):"A&D",1:"D")
 I $P($G(^ADGDS(DFN,"DS",+DGDSA,2)),U,2)="Y",$D(DGRE) D
 . S DGRE=$S(DGRE["A":"A&DS",1:"DS")   ;adm directly from DS
 Q
 ;
RE() ; -- readmission
 N X,Y S X=+$G(^DGPM(+$$M3P,0)) D H^%DTC S Y=%H
 S X=+^DGPM(DGPMDA,0) D H^%DTC Q $S((%H-Y)'>$$RA:1,1:0)
 ;
RA() ; -- QA time length for readmission
 Q +$G(^DG(43,1,9999999.02))
 ;
M3P() ; -- movement, discharge, previous
 Q $O(^DGPM("ATID3",DFN,+$O(^DGPM("ATID3",DFN,9999999.9999999-^DGPM(DGPMDA,0))),0))
 ;
M1P() ; -- movement, admission, previous
 Q $O(^DGPM("ATID1",DFN,+$O(^DGPM("ATID1",DFN,9999999.9999999-^DGPM(DGPMDA,0))),0))
 ;
DSP() ; -- day surgery previous
 Q $O(^ADGDS("APID",DFN,+$O(^ADGDS("APID",DFN,9999999.9999999-^DGPM(DGPMDA,0))),0))
