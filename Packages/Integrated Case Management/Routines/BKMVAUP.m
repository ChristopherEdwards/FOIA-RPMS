BKMVAUP ;PRXM/HC/CLT - AUDIT PRINT ROUTINE ; 28 Apr 2005  1:49 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 QUIT
 ;
EN ; Display entire audit file (90455) by date/time
 ; Input variables:
 ;  n/a
 ; Output variables:
 ;  n/a
 ; Initialize variables
 N BKMVDTS,BKMVIEN
 ; Loop through audit file by date/time stamp
 S BKMVDTS=""
 F  S BKMVDTS=$O(^BKMV(90455,"B",BKMVDTS)) Q:BKMVDTS=""  D
 . S BKMVIEN=""
 . F  S BKMVIEN=$O(^BKMV(90455,"B",BKMVDTS,BKMVIEN)) Q:BKMVIEN=""  D EN1(BKMVIEN)
 Q
 ;
EN1(BKMVIEN) ;ENTRY POINT - Display one Audit (90455) file entry (Called by tags in BKMVAUC).
 ; Input variables:
 ;  BKMVIEN - IEN from File 90455 Audit
 ; Output variables:
 ;  n/a
 N BKMVDT,BKMVREG,BKMVU,BKMVE,BKMPT,BKMPAT,BKMFLD,BKMFLDTY
 N BKMFRM,BKMTO,BKMOPT,BKMFILNO,BKMFLDNO
 ;
 D
 .; Date/time
 .;S Y=$$GET1^DIQ(90455,BKMVIEN_",",.01,"I")
 .;D DD^%DT
 .;S BKMVDT=Y
 .S BKMVDT=$$FMTE^XLFDT($$GET1^DIQ(90455,BKMVIEN_",",.01,"I"),1)
 .; Register
 .S BKMVREG=$$GET1^DIQ(90455,BKMVIEN_",",6,"E")
 .; User
 .S BKMVU=$$GET1^DIQ(90455,BKMVIEN_",",5,"E")
 .; Event Type
 .S BKMVE=$$GET1^DIQ(90455,BKMVIEN_",",1,"E")
 .; Option Accessed
 .S BKMOPT=$$GET1^DIQ(90455,BKMVIEN_",",7,"E")
 .; Patient name
 .S BKMPAT=$$GET1^DIQ(90455,BKMVIEN_",",8,"E")
 .; If key to 90451 exists, retrieve .01 field (PATIENT NAME)
 .;S BKMPT=$$GET1^DIQ(90455,BKMVIEN_",",2,"I")
 .;S BKMPAT=$S(+BKMPT>0:$$GET1^DIQ(90451,BKMPT_",",.01,"E"),BKMPT'="":BKMPT,1:"")
 .; Determine the field name and type based on Event Field
 .S BKMFLD=$$FLDINFO^BKMVFLD(BKMVIEN)
 .S BKMFLDTY=$P(BKMFLD,U,2)
 .S BKMFILNO=$P(BKMFLD,U,3)
 .S BKMFLDNO=$P(BKMFLD,U,4)
 .S BKMFLD=$P(BKMFLD,U,1)
 .S BKMFRM=$$GET1^DIQ(90455,BKMVIEN_",",4)
 .S BKMTO=$$GET1^DIQ(90455,BKMVIEN_",",4.5)
 .I BKMVE'="VIEW",BKMVE'="DELETE",BKMVE'="NEW" D CNVT(BKMFLD,BKMFLDTY,.BKMFRM,.BKMTO,BKMFILNO,BKMFLDNO)
 .D PRT(BKMVDT,BKMVREG,BKMVE,BKMVU,BKMPAT,BKMOPT,BKMFLD,BKMFRM,BKMTO)
 .K X,Y
 Q
 ;
CNVT(BKMFLD,BKMTYP,BKMFRM,BKMTO,BKMFILNO,BKMFLDNO) ; CONVERT INTERNALS TO EXTERNALS
 ; Input variables:
 ;  BKMFLD - File 90451 Field Name (LABEL)
 ;  BKMTYP - File 90451 Field Type (ex. SET, POINTER, DATE/TIME)
 ;  BKMFRM - File 90455 Field 4 Value - by reference
 ;  BKMTO  - File 90455 Field 4.5 Value - by reference
 ; Output variables
 ;  BKMFRM - File 90455 Field 4 Value - converted to external value
 ;  BKMTO  - File 90455 Field 4.5 Value - converted to external value
 ; DATE/TIME conversion
 I BKMTYP="DATE/TIME" D  Q
 .;PRXM/HC/BHS - 11/01/2005 - Modified external format to Mon DD,CCYY
 .;I BKMFRM'="" S Y=BKMFRM D DD^%DT S BKMFRM=$$DATE^BKMIDTF(Y)
 .;I BKMTO'="" S Y=BKMTO D DD^%DT S BKMTO=$$DATE^BKMIDTF(Y)
 .I BKMFRM'="" S BKMFRM=$$FMTE^XLFDT(BKMFRM,"1")
 .I BKMTO'="" S BKMTO=$$FMTE^XLFDT(BKMTO,"1")
 ;
 ; SET OF CODES conversion
 I BKMTYP="SET" D  Q
 .S BKMFRM=$$CODEDESC^BKMVFLD(BKMFILNO,BKMFLDNO,BKMFRM)
 .S BKMTO=$$CODEDESC^BKMVFLD(BKMFILNO,BKMFLDNO,BKMTO)
 ;
 ; Pointer conversion based on field name
 I BKMTYP="POINTER" D  Q
 .S BKMFRM=$$PNTRDESC^BKMVFLD(BKMFILNO,BKMFLDNO,BKMFRM)
 .S BKMTO=$$PNTRDESC^BKMVFLD(BKMFILNO,BKMFLDNO,BKMTO)
 Q
 ;
PRT(BKMVDT,BKMVREG,BKMVE,BKMVU,BKMPAT,BKMOPT,BKMFLD,BKMFRM,BKMTO) ; PRINT AN AUDIT ENTY
 ; Input variables:
 ;  BKMVDT - Date/time stamp
 ;  BKMVREG - Register
 ;  BKMVE - Event
 ;  BKMVU - User
 ;  BKMPAT - Patient Name
 ;  BKMFLD - Field Name
 ;  BKMFRM - File 90455 Field 4 Value - by reference
 ;  BKMTO  - File 90455 Field 4.5 Value - by reference
 ; Output variables
 ;  n/a
 W !,?1,BKMVDT
 I BKMVREG'="" W ?30," Register: ",$$GET1^DIQ(90450,BKMVREG_",",.01,"E")
 W !,?2,"Event:",?11,BKMVE,?31,"User:",?41,BKMVU
 I BKMVE'="ACCESSED MENU" W !,?2,"Patient: ",BKMPAT
 I BKMVE="ACCESSED MENU" W !,?2,"Option:  ",BKMOPT
 I BKMVE="CHANGE" D
 . W ?31,"Field:",?41,BKMFLD
 . I $G(BKMFRM)="" D
 .. W !,?2,"Added:   ",$G(BKMTO)
 . E  I $G(BKMTO)="" D
 .. W !,?2,"Removed: ",$G(BKMFRM)
 . E  D
 .. W !,?2,"   From: ",$G(BKMFRM)
 .. W !,?2,"     To: ",$G(BKMTO)
 W !
 Q
 ;
 ;
