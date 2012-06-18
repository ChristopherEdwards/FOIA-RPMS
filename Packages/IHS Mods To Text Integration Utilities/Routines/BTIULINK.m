BTIULINK ; IHS/ITSC/LJF - UPDATE TIU DOC UPON VISIT MERGE ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
 ;This routine is called by the PCC Visit Merge Utility.
 ;The input variables are:  APCDVMF - Merge from visit ifn
 ;                          APCDVMT - Merge to visit ifn
 ;
 ;This routine finds the patient involved, scans for this merged visit
 ;among the occurrences for this patient, and updates the visit.
 ;
MRG ;PEP >> PRIVATE ENTRY POINT between TIU and PCC
 N DIE,DA,DR,TIUN,X,Y
 Q:'$D(APCDVMF)  Q:'$D(APCDVMT)
 S TIUN=0
 F  S TIUN=$O(^TIU(8925,"V",APCDVMF,TIUN)) Q:TIUN=""  D
 .S DR=".03////"_APCDVMT,DA=TIUN,DIE="^TIU(8925," D ^DIE
 ;
EXIT Q
