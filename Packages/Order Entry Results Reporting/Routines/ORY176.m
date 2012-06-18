ORY176 ; slc/CLA - Pre and Post-init for patch OR*3*176 ; Mar 19, 2003@11:02:31
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**176**;Dec 17, 1997
 ;
PRE ;initiate pre-init processes
 N FDA,ERR
 S FDA(9.4,"?+1,",.01)="HERBAL/OTC/NON-VA MEDS"
 S FDA(9.4,"?+1,",1)="PSH"
 S FDA(9.4,"?+1,",2)="Non-VA Medications"
 D UPDATE^DIE("","FDA","","ERR")
 I $D(ERR) D BMES^XPDUTL("Error creating HERBAL/OTC/OUTSIDE MEDS Package entry.")
 Q
 ;
POST ;initiate post-init processes
 ;update Pharmacy Display Group:
 N FDA,ERR
 S FDA(100.98,"?1,",.01)="PHARMACY"
 S FDA(100.981,"?+2,?1,",.01)="NON-VA MEDICATIONS"
 D UPDATE^DIE("E","FDA","","ERR")
 I $D(ERR) D BMES^XPDUTL("Error adding OUTSIDE MEDICATIONS to Pharmacy Display Group.")
 ;
 D BMES^XPDUTL("Updating OE/RR Orderable Item file with Outside Meds...")
 S XPDIDTOT=0 D UPDATE^XPDID(0)     ; reset status bar
 S XPDIDTOT=$P(^PS(50.7,0),"^",4)  ; Pharmacy Orderable Item file
 ;
 ;call PDM to send Master File Updates to CPRS
 N OI,PSSCROSS,PSSTEST
 S OI=0,PSSCROSS=1
 F  S OI=$O(^PS(50.7,OI)) Q:'OI  D
 . I '(OI#100) D UPDATE^XPDID(OI)   ; update status bar
 . I '$P(^PS(50.7,OI,0),"^",10) Q
 . S PSSTEST=OI D EN1^PSSPOIDT
 ;
 Q
