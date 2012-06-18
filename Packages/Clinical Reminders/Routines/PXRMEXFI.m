PXRMEXFI ; SLC/PKR/PJH - Exchange utilities for file entries. ;24-Mar-2006 13:13;MGH
 ;;1.5;CLINICAL REMINDERS;**5,1002,1004**;Jun 19, 2000
 ;IHS/CIA/MGH -Exclude PCC files from creating entries in reminder exchange
 ;1004 included for backward compatibility
 ;======================================================================
DELETE(FILENUM,DA) ;Delete a file entry.
 N DIK
 S DIK=$$ROOT^DILFD(FILENUM)
 D ^DIK
 Q
 ;
 ;======================================================================
FOKTI(FILENUM) ;Check if it is ok to install/transport this FILE.
 ;
 ;Drugs not allowed.
 I FILENUM=50 Q 0
 ;
 ;VA Generic not allowed.
 I FILENUM=50.6 Q 0
 ;
 ;VA Drug Class not allowed.
 I FILENUM=50.605 Q 0
 ;
 ;Lab tests not allowed.
 I FILENUM=60 Q 0
 ;
 ;Radiology procedures not allowed.
 I FILENUM=71 Q 0
 ;
 ;ICD9 (used in Dialogs) not allowed.
 I FILENUM=80 Q 0
 ;
 ;ICD0 not allowed.
 I FILENUM=80.1 Q 0
 ;
 ;CPT (used in Dialogs) not allowed.
 I FILENUM=81 Q 0
 ;
 ;Order Dialogs not allowed.
 I FILENUM=101.41 Q 0
 ;
 ;Orderable Items not allowed.
 I FILENUM=101.43 Q 0
 ;
 ;Sites cannot create entries in GMRV VITAL TYPE.
 I FILENUM=120.51 Q 0
 ;
 ;IHS -Sites cannot create entries in MEASURMENT FILE
 I FILENUM=9999999.07 Q 0
 ;
 ;IHS- Sites cannot create entries in health factors file
 I FILENUM=9999999.64 Q 0
 ;
 ;IHS-Sites cannot create entries in exam file
 I FILENUM=9999999.15 Q 0
 ;
 ;IHS-Sites cannot create entries in the patient education file
 I FILENUM=9999999.09 Q 0
 ;
 ;IHS-Sites cannot create entries in the ski test file
 I FILENUM=9999999.28 Q 0
 ;
 ;IHS-Sites cannot create entries in the immunization file
 I FILENUM=9999999.14 Q 0
 ;
 ;Mental Health Instruments not allowed.
 I FILENUM=601 Q 0
 ;
 ;If control gets to here then it is an allowed file type.
 Q 1
 ;
 ;======================================================================
GETFACT(PT01,ATTR,NEWPT01,NAMECHG,EXISTS) ;Get the action for a file.
 N ACTION,CHOICES,MSG,RESULT,X,Y
 ;See if this entry is already defined.
CHK ;
 S NEWPT01=""
 S ATTR("PT01")=PT01
 S CHOICES="CIQS"
 I EXISTS="" S EXISTS=$$EXISTS^PXRMEXIU(FILENUM,PT01)
 I EXISTS D
 . W !!,ATTR("FILE NAME")," entry ",PT01," already EXISTS,"
 . W !,"what do you want to do?"
 . S DIR("B")="S"
 . S ACTION=$$GETACT^PXRMEXIU(CHOICES)
 E  D
 . W !!,ATTR("FILE NAME")," entry ",PT01," is NEW,"
 . W !,"what do you want to do?"
 . S DIR("B")="I"
 . S ACTION=$$GETACT^PXRMEXIU(CHOICES)
 ;
 I ACTION="Q" Q ACTION
 I ACTION="C" D
 . S NEWPT01=$$GETUNAME^PXRMEXIU(.ATTR,.TA)
 .;Make sure the NEW .01 passes any input transforms.
 . I NEWPT01="" S ACTION="S"
 . E  D CHK^DIE(ATTR("FILE NUMBER"),.01,"",NEWPT01,.RESULT,"MSG")
 I $G(RESULT)="^" D  G CHK
 . D AWRITE^PXRMUTIL("MSG")
 . K RESULT
 ;
 I (ACTION="I")&(+EXISTS>0) D
 .;If the action is overwrite double check that is what the user
 .;really wants to do.
 . K X,Y
 . S DIR(0)="Y"_U_"A"
 . S DIR("A")="Are you sure you want to overwrite"
 . S DIR("B")="N"
 . D ^DIR K DIR
 . I Y S ACTION="O"
 . E  S ACTION="S"
 ;
 I ACTION="P" D
 . N DIC,Y
 . S DIC=ATTR("FILE NUMBER")
 . S DIC(0)="AEMQ"
 . D ^DIC
 . I Y=-1 S ACTION="S"
 . E  S NEWPT01=$P(Y,U,2)
 ;
 I NEWPT01'="" S NAMECHG(ATTR("FILE NUMBER"),PT01)=NEWPT01
 Q ACTION
 ;
 ;======================================================================
SETATTR(ATTR,FILE) ;Set the file attributes for the file FILE.
 N MSG
 S ATTR("FILE NUMBER")=FILE
 S ATTR("FILE NAME")=$$GET1^DID(FILE,"","","NAME","","MSG")
 ;This call gets the field length.
 D FIELD^DID(FILE,.01,"","FIELD LENGTH","ATTR","MSG")
 S ATTR("MIN FIELD LENGTH")=3
 ;This read of DD is covered by DBIA 2023.
 ;S ATTR("811.9 PTR")=$O(^DD(FILE,0,"PT",811.89))
 Q
 ;
