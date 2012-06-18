XBVL ; IHS/ADC/GTH - LOCAL VARIABLE LISTER FRONT END ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**4,9**;FEB 07, 1997
 ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ; XB*3*9 IHS/SET/GTH 06/05/2002 Cache' mods.
 ;
 ; This is the front end for listing local variables.
 ; Implementation specific routines are called from this
 ; routine.  Those routines are in the ZIBVL* namespace.
 ;
 ; I '$L($T(@$P(^%ZOSF("OS"),"-",1))) W !,*7,"OPERATING SYSTEM '",$P(^%ZOSF("OS"),"-",1),"' NOT SUPPORTED." Q ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ; G @$P(^%ZOSF("OS"),"-",1) ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 I ($$VERSION^%ZOSV(1)["Cache")!($$VERSION^%ZOSV(1)["MSM") G ^ZIBVL ;IHS/SET/GTH XB*3*9 10/29/2002
 ; I $P(^%ZOSF("OS"),"^",1)["MSM" G MSM ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err. ;IHS/SET/GTH XB*3*9 10/29/2002
 W !,*7,"OPERATING SYSTEM '",$P(^%ZOSF("OS"),"^",1),"' NOT SUPPORTED." ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 Q  ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ;
MSM ; Micronetics Standard MUMPS.
 G ^ZIBVLMSM
 ;
MESSAGE ;EP - Tell user of limitations.
 W !!?5,"DO routine ^XBVL from programmer mode."
 W !?5,"Not all local variables are available thru the XB menu.",!!
 Q
 ;
