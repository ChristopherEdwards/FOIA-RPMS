BEHODCH ;MSC/IND/MGH - TIU Dictation Boilerplate Header ;24-Oct-2007 12:55;DKM
 ;;1.1;BEH COMPONENTS;**040002**;Mar 20, 2007
 ;=================================================================
LIST(DFN,TARGET) ;
 N BEHNT,BEHDA,BEHNAME,BEHHRN,BEHDFN,BEHTITLE,BEHSITE
 S (BEHTITLE,BEHNAME)=""
 ; Retrieve author of note using VueCentric Context
 S BEHDA=+$$GETVAR^CIANBUTL("TIU.CO.TIUDA","","BEHODC")
 S @TARGET@(1,0)=$$RJ^XLFSTR("Author: ",20)_$$GET1^DIQ(8925,BEHDA,1202,"E")
 I '$D(TITLE) S TITLE=TIUTYP
 S BEHTITLE=$P($G(^TIU(8925.1,TITLE,0)),U,1)
 S @TARGET@(2,0)=$$RJ^XLFSTR("Document Title: ",20)_BEHTITLE
 ; Retrieve DFN from TIU Document and lookup HRN
 S @TARGET@(3,0)=$$RJ^XLFSTR("Patient Name: ",20)_$G(TIU("PNM"))
 S BEHNAME=$G(TIU("PNM"))
 S BEHDFN="",BEHHRN=""
 S BEHDFN=+$$GET1^DIQ(8925,BEHDA,.02,"I")
 S BEHSITE=$G(DUZ(2))
 S BEHHRN=$P($G(^AUPNPAT(BEHDFN,41,BEHSITE,0)),U,2)
 S @TARGET@(4,0)=$$RJ^XLFSTR("HRN: ",20)_BEHHRN
 ;Clinic and time are available when the visit is selected
 S @TARGET@(5,0)=$$RJ^XLFSTR("Clinic Name: ",20)_$P($G(TIU("LOC")),U,2)
 S @TARGET@(6,0)=$$RJ^XLFSTR("Appointment Date: ",20)_$P($G(TIU("EDT")),U,2)
 Q "~@"_$NA(@TARGET)
 ; Return the current VueCentric TIU Note IEN from the Context Array
IEN(NMSP) ;
 Q $$RJ^XLFSTR("Document Number: ",20)_$$GETVAR^CIANBUTL("TIU.CO.TIUDA","",$G(NMSP))
