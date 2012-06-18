XBVK ; IHS/ADC/GTH - LOCAL VARIABLE KILLER FRONT END ;  [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**5,9**;FEB 07, 1997
 ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent INDIR on NT systems.
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 NT and Cache' mods.
 ;
 ; This is the front end for killing local variables in the
 ; namespaced parameter.  Implementation specific routines
 ; are called from this routine.  Those routines are in the
 ; ZIBVK* namespace.
 ;
 ; This routine is intended to be called by applications
 ; that are thru executing, in order to KILL any remaining
 ; namespaced local variables.  E.g., D EN^XBVK("AG") will
 ; KILL any local variables that exist in the AG namespace.
 ;
 ; Notice that if called in background, and the OS is not
 ; supported, the routine will quit, unpleasantly.  If your
 ; implementation is other than what is supported, below,
 ; and your vendor has implemented all Type A extensions to
 ; the 1990 ANSI M standard, you can safely remove the two
 ; lines that check for OS, and use the existing call to
 ; the MSM-specific routine.
 ;
 Q
 ;
EN(XBVK) ;PEP - Kill vars in namespace of parameter variable.
 ;
 ; I '$L($T(@$P(^%ZOSF("OS"),"-",1))) W !,*7,"OPERATING SYSTEM '",$P(^%ZOSF("OS"),"-",1),"' NOT SUPPORTED." Q  ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent INDIR on NT systems.
 ; I $P(^%ZOSF("OS"),"^",1)'["MSM" W !,*7,"OPERATING SYSTEM '",$P(^%ZOSF("OS"),"^",1),"' NOT SUPPORTED." Q  ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent INDIR on NT systems. ; IHS/SET/GTH XB*3*9 10/29/2002
 I $P(^%ZOSF("OS"),"^",1)'["MSM",$P(^%ZOSF("OS"),"^",1)'["OpenM" W !,*7,"OPERATING SYSTEM '",$P(^%ZOSF("OS"),"^",1),"' NOT SUPPORTED." Q  ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent INDIR on NT systems. ; IHS/SET/GTH XB*3*9 10/29/2002
 ; G @$P(^%ZOSF("OS"),"-",1) ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent INDIR on NT systems.
 I $P(^%ZOSF("OS"),"^",1)["OpenM" D EN^ZIBVKCA(XBVK) Q  ; IHS/SET/GTH XB*3*9 10/29/2002
 ;
MSM ; Micronetics Standard MUMPS.
 D EN^ZIBVKMSM(XBVK)
 Q
 ;
