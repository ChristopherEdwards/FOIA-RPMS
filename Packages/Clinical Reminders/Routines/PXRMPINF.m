PXRMPINF ;SLC/PKR - Routines relating to patient information. ;23-Mar-2015 10:39;DU
 ;;2.0;CLINICAL REMINDERS;**1001,12,17,24,1005**;Feb 04, 2005;Build 23
 ;
 ;IHS/MSC/MGH Patch 1001 IHS is not currently using military sexual trauma
 ;======================================================
DATACHG ;This entry point is called whenever patient data has changed.
 ;It is attached to the following event points:
 ;PXK VISIT DATA EVENT via PXRM PATIENT DATA CHANGE
 ;
 I '$D(^TMP("PXKCO",$J)) Q
 N EVENT,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 S EVENT="PXRM PXK EVENT"_$J_" "_$$NOW^XLFDT
 ;Make sure EVENT is unique.
 I $D(^XTMP(EVENT)) H 1 S EVENT="PXRM PXK EVENT"_$J_" "_$$NOW^XLFDT
 K ^XTMP(EVENT)
 S ^XTMP(EVENT,0)=$$FMADD^XLFDT(DT,3)_U_DT
 M ^XTMP(EVENT)=^TMP("PXKCO",$J)
 L +^XTMP(EVENT):DILOCKTM
 S ZTSAVE("EVENT")=""
 S ZTSAVE("XTMP(")=""
 S ZTRTN="DATACHGR^PXRMPINF"
 S ZTDESC="Clinical Reminders PXK VISIT DATA EVENT handler"
 S ZTDTH=$H
 S ZTIO=""
 D ^%ZTLOAD
 Q
 ;
 ;======================================================
DATACHGR ;Process data from PXK VISIT DATA EVENT
 N DATA,DFN,DGBL,NODE,PXRMDFN,VIEN,VISIT,VF,VFL,VGBL
 S ZTREQ="@"
 ;Look for PXK VISIT DATA EVENT data.
 S VISIT=$O(^XTMP(EVENT,0))
 S VIEN=$O(^XTMP(EVENT,VISIT,"VST",""))
 S NODE=$O(^XTMP(EVENT,VISIT,"VST",VIEN,""))
 S DATA=$G(^XTMP(EVENT,VISIT,"VST",VIEN,NODE,"AFTER"))
 I DATA="" S DATA=$G(^XTMP(EVENT,VISIT,"VST",VIEN,NODE,"BEFORE"))
 S DFN=$P(DATA,U,5)
 ;Build the list of V Files.
 S VF=""
 F  S VF=$O(^XTMP(EVENT,VISIT,VF)) Q:VF=""  D
 . S DGBL=$S(VF="CPT":"PXD(811.2,",VF="HF":"AUTTHF(",VF="IMM":"AUTTIMM(",VF="PED":"AUTTEDT(",VF="POV":"PXD(811.2,",VF="SK":"AUTTSK(",VF="XAM":"AUTTEXAM(",1:"")
 . S VGBL=$S(VF="CPT":"AUPNVCPT(",VF="HF":"AUPNVHF(",VF="IMM":"AUPNVIMM(",VF="PED":"AUPNVPED(",VF="POV":"AUPNVPOV(",VF="SK":"AUPNVSK(",VF="XAM":"AUPNVXAM(",1:"")
 . S VFL(VF)=DGBL_U_VGBL
 ;Call the routines that need to process the data.
 ;IHS/MSC/MGH Patch 1001 IHS is not currently using military sexual trauma or suicide
 ;D UPDPAT^PXRMMST(EVENT,DFN,VISIT,.VFL)
 ;D SUICIDE^PXRMNTFY(EVENT,DFN,VISIT)
 ;L -^XTMP(EVENT)
 ;K ^XTMP(EVENT)
 Q
 ;
 ;======================================================
DEM(DFN,TODAY,DEMARR) ;Load the patient demographics into DEMARR
 ;The patient's age is calculated using whatever date is passed as
 ;TODAY. If there is a date of death and it is greater than TODAY
 ;then set the date of death to null. Direct read of patient file
 ;supported DBIA #10035. DATE OF BIRTH and SEX are required fields
 ;in the patient file.
 N TEMP
 K DEMARR
 I $L(DFN)'>0 S DEMARR("PATIENT")="" Q
 S TEMP=$G(^DPT(DFN,0))
 I TEMP="" S DEMARR("PATIENT")="" Q
 S DEMARR("PATIENT")=$P(TEMP,U,1)
 S DEMARR("SEX")=$P(TEMP,U,2)
 S DEMARR("DOB")=$P(TEMP,U,3)
 S DEMARR("SSN")=$P(TEMP,U,9)
 ;IHS/MSC/MGH PATCH 1001 Add in HRCN
 S DEMARR("HRCN")=$$HRCN^PXRMXXT(DFN,+$G(DUZ(2)))
 S DEMARR("DOD")=$P($G(^DPT(DFN,.35)),U,1)
 I DEMARR("DOD")>TODAY S DEMARR("DOD")=""
 S DEMARR("DFN")=DFN
 S DEMARR("AGE")=$$AGE^PXRMAGE(DEMARR("DOB"),DEMARR("DOD"),TODAY)
 ;DBIA #1096
 S TEMP=$O(^DGPM("ATID1",DFN,""))
 I TEMP'="" S TEMP=9999999.999999-TEMP
 S DEMARR("LAD")=TEMP
 Q
 ;
