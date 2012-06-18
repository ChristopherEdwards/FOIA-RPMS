PXRMPDEM ; SLC/PKR - Computed findings for patient demographics. ;11/14/2002
 ;;1.5;CLINICAL REMINDERS;**2,7,14**;Jun 19, 2000
 ;
 ;=======================================================================
DOB(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for checking a patient's
 ;date of birth.
 S DATE=DT
 I PXRMDOB="" S TEST=0
 E  D
 . S TEST=1
 . S VALUE=PXRMDOB
 Q
 ;
 ;=======================================================================
DOD(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for checking a patient's
 ;date of death.
 S DATE=DT
 I PXRMDOD="" S TEST=0
 E  D
 . S TEST=1
 . S VALUE=PXRMDOD
 Q
 ;
 ;=======================================================================
RACE(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for checking a patient's race.
 S DATE=DT
 I PXRMRACE="" S TEST=0
 E  D
 . S TEST=1
 . S VALUE=PXRMRACE
 Q
 ;
 ;=======================================================================
NEWRACE(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for checking a for 
 ;                        patient's new race value.
 N CNT,CNT1,RACE,VADM
 S TEST=0
 S RACE=""
 S DATE=DT
 D DEM^VADPT
 Q:$D(VADM(12))'=11
 S (CNT,CNT1)=0
 F  S CNT=$O(VADM(12,CNT)) Q:CNT=""  D
 . S CNT1=CNT1+1
 . I CNT1=1 S RACE=RACE_$P($G(VADM(12,CNT)),U,2)
 . I CNT1>1 S RACE=RACE_", "_$P($G(VADM(12,CNT)),U,2)
 S VALUE=RACE
 I $G(VALUE)'="" S TEST=1
 Q
 ;
 ;=======================================================================
ETHNY(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for a patient's ethicity.
 ;                        patient's new ethnicity value.
 N CNT,CNT1,ETHNY,VADM
 S TEST=0
 S ETHNY=""
 S DATE=DT
 D DEM^VADPT
 Q:$D(VADM(11))'=11
 S (CNT,CNT1)=0
 F  S CNT=$O(VADM(11,CNT)) Q:CNT=""  D
 . S CNT1=CNT1+1
 . I CNT1=1 S ETHNY=ETHNY_$P($G(VADM(11,CNT)),U,2)
 . I CNT1>1 S ETHNY=ETHNY_", "_$P($G(VADM(11,CNT)),U,2)
 S VALUE=ETHNY
 I $G(VALUE)'="" S TEST=1
 Q
 ;=======================================================================
VETERAN(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for checking if a
 ;patient is a veteran.
 N VAEL
 S DATE=DT
 D ELIG^VADPT
 S TEST=VAEL(4)
 S VALUE=""
 Q
 ;
