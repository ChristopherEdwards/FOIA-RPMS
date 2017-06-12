BSTSVICD ;GDIT/HS/BEE-Standard Terminology API Program - ICD Checking ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
VRSN(ICD,VDT,PARMS) ;Evaluate whether ICD10 code is active on date
 ;
 NEW RET,DIEN,EFFDT
 ;
 I $G(ICD)="" Q 0
 ;
 ;If no VDT, get from PARMS
 I $G(VDT)="",$G(PARMS)]"" D
 . NEW PC,PRM,VST
 . S VST=""
 . F PC=1:1:$L(PARMS) S PRM=$P(PARMS,";",PC) X:PRM["VST=" ("S "_PRM) I VST]"" Q
 . S VDT=$$GET1^DIQ(9000010,VST_",",.01,"I") S:VDT="" VDT=DT  ;Get visit date
 I $G(VDT)="" S VDT=DT
 ;
 ;Locate the ICD entry
 S DIEN=$O(^ICD9("AB",ICD_" ","")) Q:DIEN="" 0
 ;
 ;Loop through status multiple to try to find effective range
 S RET=1,EFFDT=$O(^ICD9(DIEN,66,"B",VDT),-1) I EFFDT]"" D
 . NEW EIEN,STATUS,IENS,DA
 . ;
 . S EIEN=$O(^ICD9(DIEN,66,"B",EFFDT,"")) Q:EIEN=""
 . ;
 . ;Get the status
 . S DA(1)=DIEN,DA=EIEN,IENS=$$IENS^DILF(.DA)
 . S STATUS=$$GET1^DIQ(80.066,IENS,.02,"I")
 . I 'STATUS S RET=0
 ;
 Q RET
