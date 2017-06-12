AMER3P6 ;GDIT/HS/BEE - AMER v3.0 Patch 6 Post Install ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**6**;MAR 03, 2009;Build 30
 ;
 Q
 ;
PST ;EP - Front end for AMER*3.0*6 post install
 ;
 ;Change the 9009082.2 "ICD9 CODE" entry to "ICD CODE"
 D
 . NEW DIC,X,Y,AMEREDT,ERROR
 . ;
 . S DIC="9009082.2",DIC(0)="X",X="ICD9 CODE"
 . D ^DIC
 . I +Y<0 Q
 . ;
 . ;Update entry
 . S AMEREDT(9009082.2,+Y_",",.01)="ICD CODE"
 . D FILE^DIE("","AMEREDT","ERROR")
 ;
 ;Add an entry to ER INPUT MAP file
 D
 . NEW DIC,X,Y,AMEREDT,ERROR,RTYPE
 . ;
 . S DIC="9009082.3",DIC(0)="LX",X="QD28"
 . D ^DIC
 . I +Y<0 Q
 . ;
 . ;Add in the extra information
 . S RTYPE=$O(^AMER(2,"B","ADMISSION SUMMARY",""))
 . S AMEREDT(9009082.3,+Y_",",".02")="D"
 . S AMEREDT(9009082.3,+Y_",",".03")="28"
 . S AMEREDT(9009082.3,+Y_",",".05")="12.8"
 . S AMEREDT(9009082.3,+Y_",",".06")="Q"
 . I RTYPE]"" S AMEREDT(9009082.3,+Y_",",".08")=RTYPE
 . S AMEREDT(9009082.3,+Y_",",".09")="1"
 . S AMEREDT(9009082.3,+Y_",",".12")="1"
 . S AMEREDT(9009082.3,+Y_",","2")="Decision to admit at"
 . D FILE^DIE("","AMEREDT","ERROR")
 ;
 ;Update QD25 Print Header in ER INPUT MAP file
 D
 . NEW DIC,X,Y,AMEREDT,ERROR,RTYPE
 . ;
 . S DIC="9009082.3",DIC(0)="X",X="QD25"
 . D ^DIC
 . I +Y<0 Q
 . ;
 . ;Add in the extra information
 . S AMEREDT(9009082.3,+Y_",","2")="Medical Screening Exam Time"
 . D FILE^DIE("","AMEREDT","ERROR")
 ;
 ;Update QD21 Print Header in ER INPUT MAP file
 D
 . NEW DIC,X,Y,AMEREDT,ERROR,RTYPE
 . ;
 . S DIC="9009082.3",DIC(0)="X",X="QD21"
 . D ^DIC
 . I +Y<0 Q
 . ;
 . ;Add in the extra information
 . S AMEREDT(9009082.3,+Y_",","2")="ED Provider"
 . D FILE^DIE("","AMEREDT","ERROR")
 ;
 ;Update Cause of Injury definition entry in ER INPUT MAP file
 D
 . NEW DIC,X,Y,AMEREDT,ERROR,RTYPE
 . ;
 . S DIC="9009082.3",DIC(0)="X",X="QD33"
 . D ^DIC
 . I +Y<0 Q
 . ;
 . ;Add in the extra information
 . S AMEREDT(9009082.3,+Y_",",".09")=7
 . D FILE^DIE("","AMEREDT","ERROR")
 ;
 ;Add "NO SAFETY DEVICE" as a safety device
 D
 . NEW DIC,X,Y,AMEREDT,ERROR
 . S DIC="9009083",DIC(0)="XL",X="NO SAFETY DEVICE"
 . D ^DIC
 . I +Y<0 Q
 . ;
 . ;Get the safety type
 . S SAFIEN=$O(^AMER(2,"B","SAFETY EQUIPMENT","")) Q:SAFIEN=""
 . ;
 . ;Add it to the entry
 . S AMEREDT(9009083,+Y_",",1)=SAFIEN
 . D FILE^DIE("","AMEREDT","ERROR")
 ;
 Q
