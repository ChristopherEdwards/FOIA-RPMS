PXRMPINF ; SLC/PKR - Routines relating to patient information. ;07-May-2009 12:49;MGH
 ;;1.5;CLINICAL REMINDERS;**2,10,1004,1006**;Jun 19, 2000
 ;IHS/CIA/MGH Modified to add variable for HRN
 ;IHS/CIA/MGH Modified to kill health factor cache
 ;=======================================================================
DATACHG ;This entry point is called whenever patient data has changed.
 ;It is attached to the following event points:
 ;PXK VISIT DATA EVENT
 ;
 I '$D(^TMP("PXKCO",$J)) Q
 N DATA,DFN,DGBL,NODE,PXRMDFN,VIEN,VISIT,VF,VFL,VGBL
 S DFN=""
 ;Look for PXK VISIT DATA EVENT data.
 S VISIT=$O(^TMP("PXKCO",$J,""))
 S VIEN=$O(^TMP("PXKCO",$J,VISIT,"VST",""))
 S NODE=$O(^TMP("PXKCO",$J,VISIT,"VST",VIEN,""))
 S DATA=$G(^TMP("PXKCO",$J,VISIT,"VST",VIEN,NODE,"AFTER"))
 I DATA="" S DATA=$G(^TMP("PXKCO",$J,VISIT,"VST",VIEN,NODE,"BEFORE"))
 S DFN=$P(DATA,U,5)
 S PXRMDFN="PXRMDFN"_DFN
 D KILLPC(PXRMDFN)
 ;
 ;Build the list of V Files.
 S VF=""
 F  S VF=$O(^TMP("PXKCO",$J,VISIT,VF)) Q:VF=""  D
 . S DGBL=$S(VF="CPT":"PXD(811.2,",VF="HF":"AUTTHF(",VF="IMM":"AUTTIMM(",VF="PED":"AUTTEDT(",VF="POV":"PXD(811.2,",VF="SK":"AUTTSK(",VF="XAM":"AUTTEXAM(",1:"")
 . S VGBL=$S(VF="CPT":"AUPNVCPT(",VF="HF":"AUPNVHF(",VF="IMM":"AUPNVIMM(",VF="PED":"AUPNVPED(",VF="POV":"AUPNVPOV(",VF="SK":"AUPNVSK(",VF="XAM":"AUPNVXAM(",1:"")
 . S VFL(VF)=DGBL_U_VGBL
 ;
 ;Call the routines that need to process the data.
 D UPDPAT^PXRMMST(DFN,VISIT,.VFL)
 Q
 ;
 ;=======================================================================
DEM(DFN) ;Load the patient demographics.
 I $L(DFN)'>0 Q "NO PATIENT"
 N DATEBLT,EXPDATE,NOW,PATIENT,TEMP
 S PXRMDFN="PXRMDFN"_DFN
 ;Since the Kernel Installation Guide suggests running XUTL once every
 ;7 days we need to check for expired patient caches.
 S TEMP=$G(^XTMP(PXRMDFN,0))
 S DATEBLT=+$P(TEMP,U,2)
 S EXPDATE=+$P(TEMP,U,1)
 ;If the patient's problem list has been modified since the cache was
 ;last built kill it.
 S NOW=$$NOW^XLFDT
 I (NOW>EXPDATE)!((+$$MOD^GMPLUTL3(DFN))>(DATEBLT)) D KILLPC(PXRMDFN)
 E  D KILLHF(PXRMDFN)
 ;
 I '$$LOCKPC(PXRMDFN) Q "NO LOCK"
 I $D(^XTMP(PXRMDFN,0)) D
 . S PATIENT=^XTMP(PXRMDFN,"PATIENT")
 . S PXRMSSN=^XTMP(PXRMDFN,"SSN")
 . ;IHS/CIA/MGH Modified to add health record number-updated patch 1006
 . I '$D(^XTMP(PXRMDFN,"HRCN")) D
 ..S ^XTMP(PXRMDFN,"HRCN")=$$HRCN^PXRMXXT(DFN,+$G(DUZ(2)))
 . S PXRMHRCN=$G(^XTMP(PXRMDFN,"HRCN"))
 . S PXRMDOB=^XTMP(PXRMDFN,"DOB")
 . S PXRMAGE=^XTMP(PXRMDFN,"AGE")
 . S PXRMSEX=^XTMP(PXRMDFN,"SEX")
 . S PXRMDOD=^XTMP(PXRMDFN,"DOD")
 . S PXRMRACE=^XTMP(PXRMDFN,"RACE")
 E  D
 . D DEM^VADPT
 . S (PATIENT,^XTMP(PXRMDFN,"PATIENT"))=VADM(1)
 . S (PXRMSSN,^XTMP(PXRMDFN,"SSN"))=VADM(2)
 . ;IHS/CIA/MGH Modified to add health record number
 . S (PXRMHRCN,^XTMP(PXRMDFN,"HRCN"))=$$HRCN^PXRMXXT(DFN,+$G(DUZ(2)))
 . S (PXRMDOB,^XTMP(PXRMDFN,"DOB"))=$P(VADM(3),U,1)
 . S (PXRMAGE,^XTMP(PXRMDFN,"AGE"))=VADM(4)
 . S (PXRMSEX,^XTMP(PXRMDFN,"SEX"))=VADM(5)
 . S (PXRMDOD,^XTMP(PXRMDFN,"DOD"))=$P(VADM(6),U,1)
 . S (PXRMRACE,^XTMP(PXRMDFN,"RACE"))=$P(VADM(8),U,2)
 . D KVA^VADPT
 . S ^XTMP(PXRMDFN,0)=$$FMADD^XLFDT(NOW,1)_U_NOW_U_"PXRM PATIENT DATA CACHE"
 ;If PXRMDATE has a value then the reminder is evaluated as if PXRMDATE
 ;is the current date.
 I +$G(PXRMDATE)>0 D
 . S PXRMAGE=$$AGE^PXRMAGE(PXRMDOB,PXRMDATE)
 I $L(PATIENT)'>0 Q "NO PATIENT"
 E  Q 1
 ;
 ;=======================================================================
KILLPC(PXRMDFN) ;Kill the patient cache. See DBA 3411 (Inpatient Pharmacy)
 N LOCK
 S LOCK=$$LOCKPC(PXRMDFN)
 I LOCK D
 . K ^XTMP(PXRMDFN)
 . D UNLOCKPC(PXRMDFN)
 Q
 ;
KILLHF(PXRMDFN) ;Kill the health factor cache.
 N LOCK
 S LOCK=$$LOCKPC(PXRMDFN)
 I LOCK D
 .K ^XTMP(PXRMDFN,"HF")
 .D UNLOCKPC(PXRMDFN)
 Q
 ;=======================================================================
LOCKPC(PXRMDFN) ;Lock the patient cache.
 N IND,LOCK
 S LOCK=0
 F IND=1:1:30 Q:LOCK  D
 . L +^XTMP(PXRMDFN):1
 . S LOCK=$T
 Q LOCK
 ;
 ;=======================================================================
UNLOCKPC(PXRMDFN) ;Unlock the patient cache.
 L -^XTMP(PXRMDFN)
 Q
 ;
