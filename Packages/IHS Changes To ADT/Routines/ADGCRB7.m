ADGCRB7 ; IHS/ADC/PDW/ENM - A SHEET form ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ; -- form outline
 W !,"26 ICD9   27 Hosp Acq",?24,"28 Established DX",!,DGLIN1,!
 N X F X=1:1:5 D
 . W !,X,"_______   _________________________________"
 . W "____________________________________",!
 W "29 ICD9  30 DX",?18,"31 Op & Selec Procedures"
 W ?55,"32 Post-Op 33   33a Op",!?3,"Code"
 W ?58,"Infec   Date  Phy Code",!,DGLIN1,!
 F X=1:1:3 D
 . W !,X,"_______   _________________________________"
 . W "____________________________________",!
 W "34 Discharge Type",?27,"35 Facility Transferred To"
 W ?63,"36 Facility Code",!
 W !,DGLIN1,!,"37 Disch Service",?24,"38 Disch Srv Code"
 W ?55,"39 # Consults",!
 W !,DGLIN1,!,"40 Injury Date  41 Alleged Injury Cause"
 W ?41,"42 E-Code",?51,"43 Place of Injury  44 Code",!
 W !,DGLIN1,!,"47 Underlying Cause of Death & Code",!
 W !,DGLIN1,!,"49 Date",?15,"50 Attending Physician"
 W ?40,"50a Phys Code",?60,"51 Reviewed By",!
 Q
