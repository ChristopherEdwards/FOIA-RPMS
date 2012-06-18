BHSDTUR ;IHS/CIA/MGH - Health Summary for TURNAROUND FORM file ;17-Mar-2006 10:36;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;;March 17, 2006
 ;===================================================================
 ;Taken from ADETUR
 ;IHS/HQT/MJL  - TURNAROUND FORM ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;VA health summary for dental forms
 ;====================================================================
 ;
DO ;  EP
 N J
 D TITLE Q:$D(GMTSQIT)
 D DATE Q:$D(GMTSQIT)
 D LOC Q:$D(GMTSQIT)
 D PROV Q:$D(GMTSQIT)
 D ADA1 Q:$D(GMTSQIT)
 F J=1:1:12 D ADA2 Q:$D(GMTSQIT)
END Q
TITLE ;------->TITLE
 W !
 D CKP^GMTSUP Q:$D(GMTSQIT)
 S ADETXT="***TURNAROUND FORM***" D PRT Q
DATE ;------->DATE
 D CKP^GMTSUP Q:$D(GMTSQIT)
 S ADETXT="DATE:"  D PRT Q
LOC ;------->LOCATION
 D CKP^GMTSUP Q:$D(GMTSQIT)
 S ADETXT="LOCATION:" D PRT Q
PROV ;------->PROVIDERS
 D CKP^GMTSUP Q:$D(GMTSQIT)
 F ADETXT="REPORTING DENTIST:","AUXILARY:" D PRT
 Q
ADA1 ;------->ADA CODES
 D CKP^GMTSUP Q:$D(GMTSQIT)
 S ADETXT="ADA CODE:   QTY:     OP SITE(S):",ADENRQ="",ADEICL=0 X ADEPRT
 Q
ADA2 S ADETXT="___________|________|______________________________________________________"
 D PRT
 D CKP^GMTSUP Q:$D(GMTSQIT)
 Q
PRT S ADENRQ="",ADEICL=0 X ADEPRT
 Q
