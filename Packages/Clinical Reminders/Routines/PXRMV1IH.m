PXRMV1IH ; SLC/PKR - Inits for new REMINDER package (globals).;05/19/2000
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;
 ;These routines are for properly setting up the
 ; VA-HEP C RISK ASSESSMENT reminder.
 ;
 ;=======================================================================
CTERMS ;Connect the terms to findings.
 N REMIEN,TERMLIST
 S REMIEN=$O(^PXD(811.9,"B","VA-HEP C RISK ASSESSMENT",""))
 D TERMLIST(REMIEN,.TERMLIST)
 D HFTERMS(REMIEN,.TERMLIST)
 D TAXTERMS(REMIEN,.TERMLIST)
 Q
 ;
 ;=======================================================================
HFTERMS(REMIEN,TERMLIST) ;Connect terms using health factors.
 N FDA,FDAIEN,HFIEN
 S HFIEN=$O(^AUTTHF("B","DECLINED HEP C RISK ASSESSMENT",""))
 S FDAIEN(1)=TERMLIST("DECLINED HEP C RISK ASSESSMENT")
 S FDA(811.5,"?1,",.01)="DECLINED HEP C RISK ASSESSMENT"
 S FDA(811.5,"?1,",.02)="N"
 S FDA(811.52,"?+2,?1,",.01)=HFIEN_";AUTTHF("
 D UPDATE(.FDA,.FDAIEN)
 ;
 S HFIEN=$O(^AUTTHF("B","NO RISK FACTORS FOR HEP C",""))
 K FDA,FDAIEN
 S FDAIEN(1)=TERMLIST("NO RISK FACTORS FOR HEP C")
 S FDA(811.5,"?1,",.01)="NO RISK FACTORS FOR HEP C"
 S FDA(811.5,"?1,",.02)="N"
 S FDA(811.52,"?+2,?1,",.01)=HFIEN_";AUTTHF("
 D UPDATE(.FDA,.FDAIEN)
 ;
 S HFIEN=$O(^AUTTHF("B","PREV POS TEST FOR HEP C",""))
 K FDA,FDAIEN
 S FDAIEN(1)=TERMLIST("PREV POSITIVE TEST FOR HEP C")
 S FDA(811.5,"?1,",.01)="PREV POSITIVE TEST FOR HEP C"
 S FDA(811.5,"?1,",.02)="N"
 S FDA(811.52,"?+2,?1,",.01)=HFIEN_";AUTTHF("
 D UPDATE(.FDA,.FDAIEN)
 ;
 S HFIEN=$O(^AUTTHF("B","RISK FACTOR FOR HEPATITIS C",""))
 K FDA,FDAIEN
 S FDAIEN(1)=TERMLIST("RISK FACTOR FOR HEPATITIS C")
 S FDA(811.5,"?1,",.01)="RISK FACTOR FOR HEPATITIS C"
 S FDA(811.5,"?1,",.02)="N"
 S FDA(811.52,"?+2,?1,",.01)=HFIEN_";AUTTHF("
 D UPDATE(.FDA,.FDAIEN)
 Q
 ;
 ;=======================================================================
TAXTERMS(REMIEN,TERMLIST) ;Connect terms using taxonomies.
 N FDA,FDAIEN,TAXIEN
 S TAXIEN=$O(^PXD(811.2,"B","VA-HEPATITIS C INFECTION",""))
 S FDAIEN(1)=TERMLIST("HEPATITIS C INFECTION")
 S FDA(811.5,"?1,",.01)="HEPATITIS C INFECTION"
 S FDA(811.5,"?1,",.02)="N"
 S FDA(811.52,"?+2,?1,",.01)=TAXIEN_";PXD(811.2,"
 D UPDATE(.FDA,.FDAIEN)
 Q
 ;
 ;=======================================================================
TERMLIST(REMIEN,TERMLIST) ;Build the list of terms in the reminder.
 N TERM,TERMNAME
 S TERM=""
 F  S TERM=$O(^PXD(811.9,REMIEN,20,"E","PXRMD(811.5,",TERM)) Q:+TERM=0  D
 . S TERMNAME=$P(^PXRMD(811.5,TERM,0),U,1)
 . S TERMLIST(TERMNAME)=TERM
 Q
 ;
 ;=======================================================================
UPDATE(FDA,FDAIEN) ;Do the update.
 N MSG
 D UPDATE^DIE("","FDA","FDAIEN","MSG")
 Q
 ;
