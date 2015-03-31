BARCFLD ; IHS/SD/LSL - Computed Fields Routine ; 10/27/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**10,13,23**;OCT 26, 2005
 ;JUL 2013 P.OTTIS ADDED SUPPORT FOR ICD-10
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
 ;RETURNS DX ICD CODE (EXTERNAL)
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
 . I BAR3PDXP=1 S BARPRMDX=1 ;I DUZ=838 W "  <-- PRIM"
 I '+BARPRMDX Q ""
 ;
 ;
 I $T(+1^ICDEX)="" S BARPRMDX=$P($$ICDDX^ICDCODE(BAR3PDX,""),U,2)  ;IHS/SD/SDR 5/1/09 H4329 (P.OTT OLD CODE)
 I $T(+1^ICDEX)]"" S BARPRMDX=$P($$ICDDX^ICDEX(BAR3PDX,""),U,2)  ;P.OTT ICD-10 (NEW API)
 I BARPRMDX=-1 Q ""
 Q BARPRMDX
 ;End changes for CSV
 ;--------------------------------
PRIMDXI() ;EP
 ;
 ;returns IEN of primary DX (ptr into ^ICD9)
 ;
 N BAR,BAR3PLOC,BAR3PIEN,BAR3PDUZ,DIC,DA,BAR3PPC,BARPVIS,BARHOSP,BARDSCH,BARDXDA
 ;
 S BAR=D0
 N D0
 S BAR3PLOC=$$FIND3PB^BARUTL(DUZ(2),BAR)
 I BAR3PLOC="" Q ""
 S BAR3PIEN=$P(BAR3PLOC,",",2)
 S BAR3PDUZ=$P(BAR3PLOC,",")
 ;
 ; Find the primary diagnosis ein
 ;
 S (BARDXDA,BARPRMDX)=0
 F  S BARDXDA=$O(^ABMDBILL(BAR3PDUZ,BAR3PIEN,17,BARDXDA)) Q:'+BARDXDA  D  Q:+BARPRMDX
 . S BAR3PDXP=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,17,BARDXDA,0)),U,2)
 . I BAR3PDXP=1 S BARPRMDX=1 ;I DUZ=838 W "  <-- PRIM"
 I '+BARPRMDX Q ""  ;no primary
 Q BARDXDA
 ;--------------------------------
ICDVER() ;P.OTT
 ;called from A/R Bill File: calculated fld 'ICD CODE INDICATOR"
 ;returns ICD coding string e.g. ICD-9-CM
 ;
 N BARDXA,BARDXS
 S BARDXDA=$$PRIMDXI()
 I BARDXDA="" Q ""
 I $T(+1^ICDEX)="" Q "ICD-9-CM"
 S BARDXS=+$G(^ICD9(BARDXDA,1))
 I 'BARDXS Q ""
 Q $P($G(^ICDS(BARDXS,0)),U,1)
 ;-------------------
ICD10FLG(BARDXDA) ;P.OTT
 ;BARDXDA = IEN TO ^ICD(9
 ;returns 1 if BARDXDA is a valid IDC-10 DX code
 I BARDXDA="" Q ""
 I $T(+1^ICDEX)="" Q 0
 S BARDXS=+$G(^ICD9(BARDXDA,1))
 I 'BARDXS Q ""
 Q BARDXS=30!(BARDXS=31) ;
 ;------------------EOR-------------------
TEST F I=500001:1:500005 W !,I," (10)==>  ",$$ICD10FLG(I),"<=="
 F I=1:1:15 W !,I," (9)==>  ",$$ICD10FLG(I),"<=="
 Q  ;EOR
