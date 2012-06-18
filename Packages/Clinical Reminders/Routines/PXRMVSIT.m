PXRMVSIT ; SLC/PKR - Visit related info for reminders. ;22-May-2009 08:53;MGH
 ;;1.5;CLINICAL REMINDERS;**2,1006**;Jun 19, 2000
 ;
 ;1006 Fixed issue where the visit field in a V file was null
 ;=======================================================================
HLCV(NLINES,TEXT,VIEN,INDEX) ;Display location and comment for historical
 ;encounters associated with the V files.
 N COMMENT,FACILITY,LOCATION
 S FACILITY=$P($G(^AUPNVSIT(VIEN,0)),U,6)
 I FACILITY'="" S LOCATION=$$GET1^DIQ(4,FACILITY,.01)_" "_$$GET1^DIQ(4,FACILITY,99)
 E  S LOCATION=$G(^AUPNVSIT(VIEN,22))
 I $L(LOCATION)>0 D
 . S NLINES=NLINES+1
 . S TEXT(NLINES)="   Historical Encounter Location: "_LOCATION
 I $D(^AUPNVSIT(VIEN,811)) D
 . S COMMENT=^AUPNVSIT(VIEN,811)
 . S NLINES=NLINES+1
 . S TEXT(NLINES)="   Comment:  "_COMMENT
 . I $D(PXRMDEV) D
 .. N UID
 .. S UID="HEINFO VISIT "_VIEN
 .. S ^TMP(PXRMPID,$J,PXRMITEM,UID,INDEX,"COMMENT")=$G(COMMENT)
 .. S ^TMP(PXRMPID,$J,PXRMITEM,UID,INDEX,"LOCATION")=$G(LOCATION)
 Q
 ;
 ;=======================================================================
ISHIST(VIEN) ;Return true if the encounter was historical.
 ;IHS/MSC/MGH Line added to quit if null VIEN
 I +VIEN=0 Q 0
 I $P($G(^AUPNVSIT(VIEN,0)),U,7)="E" Q 1
 E  Q 0
 ;
