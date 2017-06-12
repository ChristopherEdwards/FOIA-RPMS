BHSOB ;IHS/MSC/MGH - Health Summary Components for OB file ;12-Jul-2016 12:54;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**7,9,14**;March 17, 2006;Build 4
 ;===================================================================
OBALL ;EP - display OB visits, date limits and numbers are applicable
 N BHSPAT,V,Y,X,Z,BHSIVD,BHIEN,VIEN,BHSOB,CNT,LINE,BHSOBI,ARRAY,ARRAY2
 S BHSPAT=DFN
 ;Changed this call to use an API from BJPN
 N X,TARGET,LINE,Y
 S (ARRAY,ARRAY2)="",CNT=0
 D PVST^BJPNAPI(DFN,.ARRAY,.ARRAY2)
 S X=""
 D CKP^GMTSUP Q:$D(GMTSQIT)
 F  S X=$O(ARRAY(X)) Q:X=""!(CNT>GMTSNDM)  D
 .S VIEN=$G(ARRAY(X))
 .S CNT=CNT+1
 .S V=$$GET1^DIQ(9000010,VIEN,.01,"E")
 .W !,"Visit: "_V,!
 .S TARGET=$$TMPGBL
 .S Y=$$VPIP^BJPNAPI(TARGET,DFN,VIEN) ;PEP - Returns Prenatal POV Problems for a Visit
 .S LINE=""
 .F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 ..D CKP^GMTSUP Q:$D(GMTSQIT)  I GMTSNPG W !,"Visit: "_V,!
 ..S Z=$G(^TMP("BHSOB",$J,LINE,0))
 ..W Z,!
 ;Q
 Q
 ;I '$D(^AUPNVOB("AA",BHSPAT)) Q  ;no OB data for this patient
 ; <DISPLAY>
 ;K BHSOB
 ;S BHSOBI=0 F  S BHSOBI=$O(^AUPNVOB("AA",BHSPAT,BHSOBI)) Q:BHSOBI=""  D
 ;.S BHSIVD="" F  S BHSIVD=$O(^AUPNVOB("AA",BHSPAT,BHSOBI,BHSIVD)) Q:BHSIVD=""!(BHSIVD>GMTSDLM)  D
 ;..S BHIEN=0 F  S BHIEN=$O(^AUPNVOB("AA",BHSPAT,BHSOBI,BHSIVD,BHIEN)) Q:'+BHIEN  D
 ;...S VIEN=$P($G(^AUPNVOB(BHIEN,0)),U,3)
 ;...S BHSOB(BHSIVD)=VIEN      ;Save off the visits by date
 ;;Now loop through the visits and call the API to return all the problems for that visit
 ;S TARGET=$$TMPGBL
 ;S BHSIVD="",CNT=0
 ;D CKP^GMTSUP Q:$D(GMTSQIT)
 ;F  S BHSIVD=$O(BHSOB(BHSIVD)) Q:BHSIVD=""!(BHSIVD>GMTSDLM)!(CNT>GMTSNDM)  D
 ;.S VIEN=$G(BHSOB(BHSIVD))
 ;.S CNT=CNT+1
 ;.S X=$$GET1^DIQ(9000010,VIEN,.01,"E")
 ;.W !,"Visit: "_X,!
 ;.S TARGET=$$TMPGBL
 ;.S X=$$VPIP^BJPNAPI(TARGET,DFN,VIEN) PEP - Returns Prenatal POV Problems for a Visit
 ;.S LINE=""
 ;.F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 ;..D CKP^GMTSUP Q:$D(GMTSQIT)  I GMTSNPG W !,"Visit",!
 ;..S Y=$G(^TMP("BHSOB",$J,LINE,0))
 ;..W Y,!
 ;Q
APIP ;Get All PIP problems
 N X,TARGET,LINE,Y
 S TARGET=$$TMPGBL
 S X=$$APIP^BJPNAPI(TARGET,DFN,"A")
 S LINE=""
 F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W $G(^TMP("BHSOB",$J,LINE,0)),!
 Q
CPIP ;Get all active problems for current pregnancy
 N X,TARGET,LINE,Y
 S TARGET=$$TMPGBL
 S X=$$APIP^BJPNAPI(TARGET,DFN,"C")
 S LINE=""
 F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W $G(^TMP("BHSOB",$J,LINE,0)),!
 Q
NPIP ;Get all active and inactive problems and notes
 N X,TARGET,LINE,Y
 S TARGET=$$TMPGBL
 S X=$$APIP^BJPNAPI(TARGET,DFN,"A",1)
 S LINE=""
 F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W $G(^TMP("BHSOB",$J,LINE,0)),!
 Q
PIPA ;Get Active problems + visit instructions, goals and care plans
 N X,TARGET,LINE,Y
 S TARGET=$$TMPGBL
 S X=$$PIPA^BJPNAPI(TARGET,DFN,"O")
 S LINE=""
 F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W $G(^TMP("BHSOB",$J,LINE,0)),!
 Q
PIPN ;Get All PIP problems, goals, care plans, visit instructions
 N X,TARGET,LINE,Y
 S TARGET=$$TMPGBL
 S X=$$PIPN^BJPNAPI(TARGET,DFN,"O")
 S LINE=""
 F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W $G(^TMP("BHSOB",$J,LINE,0)),!
 Q
PIPC ;Get active problems for current pregnancy plus goals, care plans, visit instructions
 N X,TARGET,LINE,Y
 S TARGET=$$TMPGBL
 S X=$$PIPC^BJPNAPI(TARGET,DFN,"O")
 S LINE=""
 F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W $G(^TMP("BHSOB",$J,LINE,0)),!
 Q
LPIP ;Get Returns list of all ACTIVE problem entries on the PIP.
 ;For each problem entry, returns all the visit instructions entered for
 ;the latest visit for the patient.
 N X,TARGET,LINE,Y
 S TARGET=$$TMPGBL
 S X=$$LPIP^BJPNAPI(TARGET,DFN,1,"O")
 S LINE=""
 F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W $G(^TMP("BHSOB",$J,LINE,0)),!
 Q
VPIP ;Get All PIP problems for the specified visit and latest visit instructions
 N X,TARGET,LINE,Y
 S TARGET=$$TMPGBL
 S X=$$VPIP^BJPNAPI(TARGET,DFN,"",1,"O")
 S LINE=""
 F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W $G(^TMP("BHSOB",$J,LINE,0)),!
 Q
VPOV ;Get All PIP problems used as a POV for the visit and associated visit instructions
 N X,TARGET,LINE,Y
 S TARGET=$$TMPGBL
 S X=$$VPOV^BJPNAPI(TARGET,DFN,"","O")
 S LINE=""
 F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W $G(^TMP("BHSOB",$J,LINE,0)),!
 Q
TMPGBL() ;EP
 K ^TMP("BHSOB",$J) Q $NA(^($J))
