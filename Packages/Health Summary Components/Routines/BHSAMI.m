BHSAMI ;IHS/MSC/MGH - Health Summary Components for V AMI file ;03-Oct-2013 06:01;JS
 ;;1.0;HEALTH SUMMARY COMPONENTS;**8**;March 17, 2006;Build 22
 ; ==================================================================
 ;
AMI ;EP - display AMI visits, date limits and numbers are applicable
 N BHSPAT,BHSAMI,V,Y,X,BHSIVD,BHIEN,VIEN,BHSOB,CNT,LINE,BHSOBI,TARGET,ZMAX,ZVIST
 S BHSPAT=DFN
 S ZMAX=$S(+($G(GMTSNDM))>0:+($G(GMTSNDM)),1:9999)
 I '$D(^AUPNVAMI("AA",BHSPAT)) Q  ;no AMI data for this patient
 ; <DISPLAY>
 K BHSOB
 S BHSOBI=0 F  S BHSOBI=$O(^AUPNVAMI("AA",BHSPAT,BHSOBI)) Q:BHSOBI=""  D
 .S BHSIVD="" F  S BHSIVD=$O(^AUPNVAMI("AA",BHSPAT,BHSOBI,BHSIVD)) Q:BHSIVD=""!(BHSIVD>GMTSDLM)  D
 ..S BHIEN=0 F  S BHIEN=$O(^AUPNVAMI("AA",BHSPAT,BHSOBI,BHSIVD,BHIEN)) Q:'+BHIEN  D
 ...S VIEN=$P($G(^AUPNVAMI(BHIEN,0)),U,3)
 ...Q:$G(VIEN)=""
 ...S BHSAMI(VIEN,BHSIVD)=""      ;Save off the visits by date
 ;Now loop through the visits and call the API to return all the problems for that visit
 S VIEN="",CNT=0
 D CKP^GMTSUP Q:$D(GMTSQIT)
 S TARGET=$$TMPGBL
 F  S VIEN=$O(BHSAMI(VIEN)) Q:VIEN=""!(CNT>ZMAX)!($D(GMTSQIT))  D
 .S CNT=CNT+1
 .S ZVIST=$$GET1^DIQ(9000010,VIEN,.01,"E")
 .W !,"Visit: "_ZVIST,!,"------------------------------------------------------------",!!
 .K @TARGET
 .S X=$$VAMI^BTIUVAMI(DFN,TARGET,VIEN) ;PEP - Returns AMI entry for a Visit
 .S LINE=""
 .F  S LINE=$O(^TMP("BTIUVAMI",$J,LINE)) Q:LINE=""  D
 ..D CKP^GMTSUP Q:$D(GMTSQIT)  I GMTSNPG W !!!
 ..S Y=$G(^TMP("BTIUVAMI",$J,LINE,0))
 ..W Y,!
 K @TARGET
 Q
STR ;EP-Display STROKE visits, date limits and numbers are applicable
 N BHSPAT,V,Y,X,BHSIVD,BHIEN,VIEN,BHSOB,CNT,LINE,BHSOBI,BHSTR,TARGET,ZMAX,ZVIST
 S BHSPAT=DFN
 S ZMAX=$S(+($G(GMTSNDM))>0:+($G(GMTSNDM)),1:9999)
 I '$D(^AUPNVSTR("AA",BHSPAT)) Q  ;no STROKE data for this patient
 ; <DISPLAY>
 K BHSOB
 S BHSOBI=0 F  S BHSOBI=$O(^AUPNVSTR("AA",BHSPAT,BHSOBI)) Q:BHSOBI=""  D
 .S BHSIVD="" F  S BHSIVD=$O(^AUPNVSTR("AA",BHSPAT,BHSOBI,BHSIVD)) Q:BHSIVD=""!(BHSIVD>GMTSDLM)  D
 ..S BHIEN=0 F  S BHIEN=$O(^AUPNVSTR("AA",BHSPAT,BHSOBI,BHSIVD,BHIEN)) Q:'+BHIEN  D
 ...S VIEN=$P($G(^AUPNVSTR(BHIEN,0)),U,3)
 ...Q:$G(VIEN)=""
 ...S BHSTR(VIEN,BHSIVD)=""      ;Save off the visits by date
 ;Now loop through the visits and call the API to return all the problems for that visit
 S VIEN="",CNT=0
 D CKP^GMTSUP Q:$D(GMTSQIT)
 S TARGET=$$TMPGBL2
 F  S VIEN=$O(BHSTR(VIEN)) Q:VIEN=""!(CNT>ZMAX)!($D(GMTSQIT))  D
 .S CNT=CNT+1
 .S ZVIST=$$GET1^DIQ(9000010,VIEN,.01,"E") ; VISIT/ADMIT DATE&TIME
 .W !,"Visit: "_ZVIST,!,"------------------------------------------------------------",!!
 .K @TARGET
 .S X=$$VSTR^BTIUVSTR(DFN,TARGET,VIEN) ;PEP - Returns STROKE entry(s) for a Visit
 .S LINE=""
 .F  S LINE=$O(^TMP("BTIUVSTR",$J,LINE)) Q:LINE=""  D
 ..D CKP^GMTSUP Q:$D(GMTSQIT)  I GMTSNPG W !!!
 ..S Y=$G(^TMP("BTIUVSTR",$J,LINE,0))
 ..W Y,!
 K @TARGET
 Q
STSCORE ;EP-Display STROKE scores
 N BHSPAT,BHSTR,HCNT,V,Y,X,BHSIVD,BHIEN,VIEN,BHSOB,CNT,LINE,BHSOBI,TARGET,ZMAX,ZVIST
 S BHSPAT=DFN
 S ZMAX=$S(+($G(GMTSNDM))>0:+($G(GMTSNDM)),1:9999)
 I '$D(^AUPNVSTR("AA",BHSPAT)) Q  ;no STROKE data for this patient
 ; <DISPLAY>
 K BHSOB
 S BHSOBI=0 F  S BHSOBI=$O(^AUPNVSTR("AA",BHSPAT,BHSOBI)) Q:BHSOBI=""  D
 .S BHSIVD="" F  S BHSIVD=$O(^AUPNVSTR("AA",BHSPAT,BHSOBI,BHSIVD)) Q:BHSIVD=""!(BHSIVD>GMTSDLM)  D
 ..S BHIEN=0 F  S BHIEN=$O(^AUPNVSTR("AA",BHSPAT,BHSOBI,BHSIVD,BHIEN)) Q:'+BHIEN  D
 ...S VIEN=$P($G(^AUPNVSTR(BHIEN,0)),U,3)
 ...Q:$G(VIEN)=""
 ...S BHSTR(VIEN,BHSIVD)=""      ;Save off the visits by date
 ;Now loop through the visits and call the API to return all the problems for that visit
 S VIEN="",CNT=0
 D CKP^GMTSUP Q:$D(GMTSQIT)
 S HCNT=GMTSNDM
 S TARGET=$$TMPGBL2
 F  S VIEN=$O(BHSTR(VIEN)) Q:VIEN=""!(CNT>ZMAX)!($D(GMTSQIT))  D
 .S CNT=CNT+1
 .S CNT=GMTSNDM=HCNT
 .K @TARGET
 .S X=$$STSCALE^BTIUSTSC(DFN,TARGET,VIEN,.HCNT) ;PEP - Returns STROKE scales
 .S LINE=""
 .F  S LINE=$O(^TMP("BTIUVSTR",$J,LINE)) Q:LINE=""  D
 ..D CKP^GMTSUP Q:$D(GMTSQIT)  I GMTSNPG W !!!
 ..S Y=$G(^TMP("BTIUVSTR",$J,LINE,0))
 ..W Y,!
 K @TARGET
 Q
TMPGBL() ;EP
 K ^TMP("BTIUVAMI",$J) Q $NA(^($J))
TMPGBL2() ;EP
 K ^TMP("BTIUVSTR",$J) Q $NA(^($J))
