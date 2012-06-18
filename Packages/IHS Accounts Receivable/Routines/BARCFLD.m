BARCFLD ; IHS/SD/LSL - Computed Fields Routine ; 10/27/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**10,13**;OCT 26, 2005
 ;
 Q
 ; ********************************************************************
 ;
DSCHSVC() ;EP
 ; New as of V1.7 patch 1 - needed for financial report sorting
 ; Discharge Service Field on A/R Bill File (field 23 of file 90050.01)
 ; Will actually return a pointer to FACILITY TREATING SPECIALTY file
 ;
 N BAR,BAR3PLOC,BAR3PIEN,BAR3PDUZ,DIC,DA,BAR3PPC,BARPVIS,BARHOSP,BARDSCH
 ;
 ; First find 3P Bill
 S BAR=D0
 N D0
 S BAR3PLOC=$$FIND3PB^BARUTL(DUZ(2),BAR)
 I BAR3PLOC="" Q ""
 S BAR3PIEN=$P(BAR3PLOC,",",2)
 S BAR3PDUZ=$P(BAR3PLOC,",")
 ;
 ; Find primary Visit
 S BAR3PPC=0
 F  S BAR3PPC=$O(^ABMDBILL(BAR3PDUZ,BAR3PIEN,11,BAR3PPC)) Q:'+BAR3PPC  D
 . I $P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,11,BAR3PPC,0)),U,2)="P" D  Q
 . . S BARPVIS=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,11,BAR3PPC,0)),U)
 . . Q
 I $G(BARPVIS)="" Q ""
 ;
 ; Find Discharge Service
 S BARHOSP=$O(^AUPNVINP("AD",BARPVIS,0))
 I '+BARHOSP Q ""
 S BARDSCH=$P($G(^AUPNVINP(BARHOSP,0)),U,5)
 Q BARDSCH
 ; ********************************************************************
 ;
PRIMDIAG() ;EP
 ; New as of V1.7 Patch 1 - needed for financial report sorting
 ; Primary Diagnosis Field on A/R Bill File (field 24 of file 90050.01)
 ; Will actually return the .01 value of the ICD DIAGNOSIS file
 ; (ICD9 Diagnosis Code)
 ; (routine released in 1.7 patch 1, field not released til V1.8)
 ;
 N BAR,BAR3PLOC,BAR3PIEN,BAR3PDUZ,DIC,DA,BAR3PPC,BARPVIS,BARHOSP,BARDSCH
 ;
 ; First find 3P Bill
 S BAR=D0
 N D0
 S BAR3PLOC=$$FIND3PB^BARUTL(DUZ(2),BAR)
 I BAR3PLOC="" Q ""
 S BAR3PIEN=$P(BAR3PLOC,",",2)
 S BAR3PDUZ=$P(BAR3PLOC,",")
 ;
 ; Find the primary diagnosis
 S (BAR3PDX,BARPRMDX)=0
 F  S BAR3PDX=$O(^ABMDBILL(BAR3PDUZ,BAR3PIEN,17,BAR3PDX)) Q:'+BAR3PDX  D  Q:+BARPRMDX
 . S BAR3PDXP=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,17,BAR3PDX,0)),U,2)
 . S:BAR3PDXP=1 BARPRMDX=1
 I '+BARPRMDX Q ""
 ;Begin changes for CSV MRS:BAR*1.8*10 D148-1
 ;Q $$GET1^DIQ(80,BAR3PDX,.01)
 ;S BARPRMDX=$$CODEC^ICDCODE(BAR3PDX,80)  ;IHS/SD/SDR 5/1/09
 S BARPRMDX=$P($$ICDDX^ICDCODE(BAR3PDX,""),U,2)  ;IHS/SD/SDR 5/1/09 H4329
 I BARPRMDX=-1 Q ""
 Q BARPRMDX
 ;End changes for CSV
