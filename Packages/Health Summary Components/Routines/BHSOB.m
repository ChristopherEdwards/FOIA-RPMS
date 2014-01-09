BHSOB ;IHS/MSC/MGH - Health Summary Components for OB file ;31-Jul-2012 16:08;DU
 ;;1.0;HEALTH SUMMARY COMPONENTS;**7**;March 17, 2006;Build 12
 ;===================================================================
OBALL ;EP - display OB visits, date limits and numbers are applicable
 N BHSPAT,V,Y,X,BHSIVD,BHIEN,VIEN,BHSOB,CNT,LINE,BHSOBI
 S BHSPAT=DFN
 I '$D(^AUPNVOB("AA",BHSPAT)) Q  ;no OB data for this patient
 ; <DISPLAY>
 K BHSOB
 S BHSOBI=0 F  S BHSOBI=$O(^AUPNVOB("AA",BHSPAT,BHSOBI)) Q:BHSOBI=""  D
 .S BHSIVD="" F  S BHSIVD=$O(^AUPNVOB("AA",BHSPAT,BHSOBI,BHSIVD)) Q:BHSIVD=""!(BHSIVD>GMTSDLM)  D
 ..S BHIEN=0 F  S BHIEN=$O(^AUPNVOB("AA",BHSPAT,BHSOBI,BHSIVD,BHIEN)) Q:'+BHIEN  D
 ...S VIEN=$P($G(^AUPNVOB(BHIEN,0)),U,3)
 ...S BHSOB(BHSIVD)=VIEN      ;Save off the visits by date
 ;Now loop through the visits and call the API to return all the problems for that visit
 S TARGET=$$TMPGBL
 S BHSIVD="",CNT=0
 D CKP^GMTSUP Q:$D(GMTSQIT)
 F  S BHSIVD=$O(BHSOB(BHSIVD)) Q:BHSIVD=""!(BHSIVD>GMTSDLM)!(CNT>GMTSNDM)  D
 .S VIEN=$G(BHSOB(BHSIVD))
 .S CNT=CNT+1
 .S X=$$GET1^DIQ(9000010,VIEN,.01,"E")
 .W !,"Visit: "_X,!
 .S TARGET=$$TMPGBL
 .S X=$$VPIP^BJPNAPI(TARGET,DFN,VIEN) ;PEP - Returns Prenatal POV Problems for a Visit
 .S LINE=""
 .F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 ..D CKP^GMTSUP Q:$D(GMTSQIT)  I GMTSNPG W !,"Visit",!
 ..S Y=$G(^TMP("BHSOB",$J,LINE,0))
 ..W Y,!
 Q
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
PIPN ;Get all active and inactive problems and notes
 N X,TARGET,LINE,Y
 S TARGET=$$TMPGBL
 S X=$$APIP^BJPNAPI(TARGET,DFN,"A",1)
 S LINE=""
 F  S LINE=$O(^TMP("BHSOB",$J,LINE)) Q:LINE=""  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W $G(^TMP("BHSOB",$J,LINE,0)),!
 Q
TMPGBL() ;EP
 K ^TMP("BHSOB",$J) Q $NA(^($J))
