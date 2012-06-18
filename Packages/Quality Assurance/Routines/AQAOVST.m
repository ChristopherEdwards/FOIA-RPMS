AQAOVST ; IHS/ORDC/LJF - UPDATE OCC UPON VISIT MERGE ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine is called by the PCC Visit Merge Utility.
 ;The input variables are:  APCDVMF - Merge from visit ifn
 ;                          APCDVMT - Merge to visit ifn
 ;
 ;This routine finds the patient involved, scans for this merged visit
 ;among the occurrences for this patient, and updates the visit.
 ;
MRG ;PEP >> PRIVATE ENTRY POINT between QAI and PCC
 N DIE,DA,DR,AQAOPT,AQAOV,AQAOIFN,X,Y
 Q:'$D(APCDVMF)  Q:'$D(APCDVMT)
 S AQAOPT=$P($G(^AUPNVSIT(APCDVMT,0)),U,5) Q:AQAOPT=""
 S AQAOV=0
 F  S AQAOV=$O(^AQAOC("AE",AQAOPT,AQAOV)) Q:AQAOV=""  I AQAOV=APCDVMF D
 .S DIE=9002167,DR=".03////"_APCDVMT,AQAOIFN=0
 .F  S AQAOIFN=$O(^AQAOC("AE",AQAOPT,AQAOV,AQAOIFN)) Q:AQAOIFN=""  D
 ..S DA=AQAOIFN D ^DIE
 ;
EXIT Q
