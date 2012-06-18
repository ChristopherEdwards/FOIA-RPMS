ABSPFUNC ;IHS/ITSC/ENM - MISC FUNCTIONS [ 02/24/2004  9:00 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**10**;JUN 21, 2001
 ;
 ;-------------------------------------------------------------
 ;IHS/SD/lwj 03/10/04 Patch 10
 ; This routine is being borrowed from Outpatient Pharmacy 6.0 and
 ; was originated by Edgar Moore.  Eventually, the real routine
 ; (APSPFUNC) will be distributed in an official release of Outpatient
 ; Pharmacy V6.0 and V7.0 as an API, but due to urgent issues 
 ; presented by the onset of the EHR project, an immediate release
 ; of this code needed to be done within the individual packages
 ; affected by the change in the NDC refill field location.
 ;
 ; This routine is being included in POS as a result of:
 ;NOTICE TO ALL DEVELOPERS WITH APPLICATIONS THAT REFERENCE THE
 ; OUTPATIENT PHARMACY PRESCRIPTION FILE #52 (REFILL SUB-FILE,
 ; NDC FIELD #11)
 ; The Veterans Administration, Outpatient Pharmacy Developers have
 ; made a Data Dictionary change to the NDC field #11 in the Prescription
 ; File 52, REFILL Sub-File.  This change was made in Outpatient Pharmacy
 ; V.7.0 Patch #29.
 ;----------------------------------------------------------------------
 ;
 ; Return NDC value
 ;input: RXIEN - Prescription IEN
 ;       RFIEN - Refill IEN
 ; Output: NDC value
NDCVAL(RX,RF)      ; EP - API Return NDC Value
 ; NDC value for prescription is returned if Refill IEN is not supplied
 N IENS,FILE,FLD
 S RF=$G(RF,0)
 Q:'$G(RX) ""
 S IENS=$S(RF:RF_","_RX_",",1:RX_",")
 S FILE=$S(RF:52.1,1:52)
 S FLD=$S(RF:11,1:27)
 Q $$GET1^DIQ(FILE,IENS,FLD)
 Q
RFNDC(RX,RF,APSPNDC)       ;EP API SET NDC FLD #11
 ;Set Refill NDC
 ;Input RX - Prescription IEN
 ;      RF - Refill IEN
 ; APSPNDC - NDC
 Q:'$G(RX) ""
 S DA(1)=RX,DIE="^PSRX(DA(1),1,"
 S DA=RF
 S DR="11////"_APSPNDC
 D ^DIE
 K DA,DIE,DR,DA,APSPNDC,RX,RF
 Q
