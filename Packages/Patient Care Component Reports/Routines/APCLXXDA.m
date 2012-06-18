APCLXXDA ; IHS/OHPRD/TMJ -CREATED BY ^XBERTN ON APR 18, 1996 ;
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
 ;;XBVK ; IHS/ADC/GTH - LOCAL VARIABLE KILLER FRONT END ;  [ 04/04/96   5:04 PM ]
 ;; ;;3.0;IHS/VA UTILITIES;;APR 30, 1996
 ;; ;
 ;; ; This is the front end for killing local variables in the
 ;; ; namespaced parameter.  Implementation specific routines
 ;; ; are called from this routine.  Those routines are in the
 ;; ; ZIBVK* namespace.
 ;; ;
 ;; ; This routine is intended to be called by applications
 ;; ; that are thru executing, in order to KILL any remaining
 ;; ; namespaced local variables.  E.g., D EN^XBVK("AG") will
 ;; ; KILL any local variables that exist in the AG namespace.
 ;; ;
 ;; ; Notice that if called in background, and the OS is not
 ;; ; supported, the routine will quit, unpleasantly.  If your
 ;; ; implementation is other than what is supported, below,
 ;; ; and your vendor has implemented all Type A extensions to
 ;; ; the 1990 ANSI M standard, you can safely remove the two
 ;; ; lines that check for OS, and use the existing call to
 ;; ; the MSM-specific routine.
 ;; ;
 ;; Q
 ;; ;
 ;;EN(XBVK) ;PEP - Kill vars in namespace of parameter variable.
 ;; ;
 ;; I '$L($T(@$P(^%ZOSF("OS"),"-",1))) W !,*7,"OPERATING SYSTEM '",$P(^%ZOSF("OS"),"-",1),"' NOT SUPPORTED." Q
 ;; G @$P(^%ZOSF("OS"),"-",1)
 ;; ;
 ;;MSM ; Micronetics Standard MUMPS.
 ;; D EN^ZIBVKMSM(XBVK)
 ;; Q
 ;; ;
