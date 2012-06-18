ZIBDR ; IHS/ADC/GTH - SAVES DIR STRING TO EDITORS ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; The string is stored in the "Temp" storage area for the
 ; screen and line editors for the current device.
 ;
SAVE(ZIBDIR) ;EP - Save string in editor global locations.
 ; I ^%ZOSF("OS")'["MSM" D OSNO^XB Q  ; Only supports Micronetics. ;IHS/SET/GTH XB*3*9 10/29/2002
 I ^%ZOSF("OS")'["MSM",'(^%ZOSF("OS")["OpenM") D OSNO^XB Q  ;IHS/SET/GTH XB*3*9 10/29/2002
 I $$VERSION^%ZOSV(1)["MSM" D  Q  ;IHS/SET/GTH XB*3*9 10/29/2002
 . W !!!,"Saving the following line of code in",!,"^%ZUT($I,""Temp"") for the ^%E editor,",!,"and ^ZUT($I,""Temp"") for the ^% editor:",!,ZIBDIR ;IHS/SET/GTH XB*3*9 10/29/2002
 . KILL ^%ZUT($I,"Temp") ;IHS/SET/GTH XB*3*9 10/29/2002
 . S ^%ZUT($I,"Temp",1)=ZIBDIR,^%ZUT($I,"Temp",0)="Temporary storage" ;IHS/SET/GTH XB*3*9 10/29/2002
 .Q  ;IHS/SET/GTH XB*3*9 10/29/2002
 ;W !!!,"Saving the following line of code in",!,"^%ZUT($I,""Temp"") for the ^%E editor,",!,"and ^ZUT($I,""Temp"") for the ^% editor:",!,ZIBDIR ;IHS/SET/GTH XB*3*9 10/29/2002
 W !!!,"Saving the following line of code in",!,"^ZUT($I,""Temp"") for the ^% editor:",!,ZIBDIR ;IHS/SET/GTH XB*3*9 10/29/2002
 ; KILL ^%ZUT($I,"Temp") S ^%ZUT($I,"Temp",1)=ZIBDIR,^%ZUT($I,"Temp",0)="Temporary storage" ;IHS/SET/GTH XB*3*9 10/29/2002
 KILL ^ZUT($I,"Temp") S ^ZUT($I,"Temp",1)=ZIBDIR,^ZUT($I,"Temp",0)="Temporary storage"
 Q
 ;
