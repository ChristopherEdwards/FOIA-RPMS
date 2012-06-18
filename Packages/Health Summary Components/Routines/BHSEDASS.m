BHSEDASS ;IHS/CIA/MGH - Encounters from ed assess ;17-Mar-2006 10:36;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;;March 17, 2006
 ;===================================================================
 ;Taken from APCHS4A
 ; IHS/TUCSON/LAB - PART 4A OF APCH -- SUMMARY PRODUCTION COMPONENTS ;  [ 02/20/04  1:28 PM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**8,11,12**;JUN 24, 1997
 ;
EDUCASSE ;EP - called from component educational assessment
 N BHSPAT,C,D,BHSX,H
 S BHSPAT=DFN
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W !,"Most recent Health Factor recorded.",!
 W !,"   Learning Preference:  ",$$LASTHF^BHSMU(BHSPAT,"LEARNING PREFERENCE","B"),!
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W !,"    Readiness to Learn:  ",$$LASTHF^BHSMU(BHSPAT,"READINESS TO LEARN","B"),!
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W !,"  Barriers to Learning:  "
 S C=$O(^AUTTHF("B","BARRIERS TO LEARNING",0)) ;ien of category passed
 I '$G(C) Q
 S H=0 K BHSO
 F  S H=$O(^AUTTHF("AC",C,H))  Q:'+H  D
 .  Q:'$D(^AUPNVHF("AA",BHSPAT,H))
 .  S D=$O(^AUPNVHF("AA",BHSPAT,H,""))
 .  Q:'D
 .  S BHSO(H,D)=$O(^AUPNVHF("AA",BHSPAT,H,D,""))
 .  Q
 S BHSX="" F  S BHSX=$O(BHSO(BHSX)) Q:BHSX=""!($D(BHSQIT))  D
 .S D=$O(BHSO(BHSX,0))
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W ?25,$$VAL^XBDIQ1(9000010.23,BHSO(BHSX,D),.01)_"  "_$$FMTE^XLFDT((9999999-D)),!
 Q
