ADGH01 ; IHS/ADC/PDW/ENM - HELP FOR SYS DEF OPTIONS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
SYS1 ;EP
 D ^XBCLS W !!?20,"PARAMETER SETUP",!
 W !?5,"Use this option to define parameters to customize the"
 W !?5,"Admissions package for your facility.  Each question has"
 W !?5,"help if you do not know how to answer it.",!
 Q
 ;
SYS2 ;EP
 D ^XBCLS W !!?20,"TREATING SPECIALTY SETUP",!
 W !?5,"Use this option to define your admitting treating specialties."
 W !?5,"You will be asked for an abbreviation, IHS Code and Hospital"
 W !?5,"Service for each.",!
 Q
 ;
SYS3 ;EP
 D ^XBCLS W !!?20,"WARD DEFINITION OPTION",!
 W !?5,"Use this option to set up and change the definitions of your"
 W !?5,"inpatient units.  This setup includes breaking down the beds"
 W !?5,"by category for Part III of the M202.",!
 Q
 ;
SYS4 ;EP
 D ^XBCLS W !!?20,"ADD/EDIT INPATIENT BEDS",!
 W !?5,"Use this option to add or change the definition of your"
 W !?5,"inpatient beds.  You will be asked for a room-bed name, "
 W !?5,"description and to which ward it belongs.",!
 Q
 ;
SYS5 ;EP
 D ^XBCLS W !!?20,"CENSUS SETUP: TREATING SPECIATIES",!
 W !?5,"Use this option to initialize your census files.  Pick a"
 W !?5,"date for starting your census (usually the last day of a"
 W !?5,"month).  Enter the number of remaining inpatients in each"
 W !?5,"treating specialty at the end of that day.  DO NOT use this"
 W !?5,"option to edit any other day but that first one!!!",!
 Q
 ;
SYS6 ;EP
 D ^XBCLS W !!?20,"CENSUS SETUP: WARDS",!
 W !?5,"Use this option to initialize your census files.  Pick a"
 W !?5,"date for starting your census (usually the last day of a"
 W !?5,"month).  Enter the number of remaining inpatients in each"
 W !?5,"inpatient unit at the end of that day.  DO NOT use this"
 W !?5,"option to edit any other day but that first one!!!",!
 Q
 ;
SYS7 ;EP
 Q
 ;
SYS8 ;EP
 Q
 ;
SYS9 ;EP
 Q
