DG53507T ;ALB/SCK - POST INSTALL ROUTINE FOR DG*5.3*507 ; 3/21/2003
 ;;5.3;Registration;**507**;Aug 13, 1993
 ;
EN ; Entry point for the DG*5.3*507 post-install
 ; This routine will update the description field of the INCOME DATA MISSING
 ; data element in the INCONSISTENT DATA ELEMENTS File, #38.6.  The exisiting
 ; description field will be removed and the new description posted.
 ;
 N DGIEN,DGNEW,DGERR,DGOUT,DGMSG
 ;
 S DGIEN=$O(^DGIN(38.6,"B","INCOME DATA MISSING",0))
 ;
 S DGMSG(1)="Updating 'INCOME DATA MISSING' description in the INCONSISTENT DATA ELEMENTS"
 S DGMSG(2)="File (#38.6), IEN = "_DGIEN
 D MES^XPDUTL(.DGMSG)
 ;
 ; Set up new description array.
 S DGNEW("WP",1)="This inconsistency results if all of the income questions on screen 9"
 S DGNEW("WP",2)="are null and the patient has not declined to provide their income"
 S DGNEW("WP",3)="information on his/her last Means Test (yet screen 9 is turned on"
 S DGNEW("WP",4)="for this type of patient)."
 S DGNEW("WP",5)=" "
 S DGNEW("WP",6)="You will not be able to edit the inconsistency by using the checker"
 S DGNEW("WP",7)="option.  You must edit the data on load/edit screen 9."
 S DGNEW("WP",8)=" "
 S DGNEW("WP",9)="Note: Collection of income data or agreement to pay the maximum"
 S DGNEW("WP",10)="medical care copayments is mandatory for all NSC and 0% SC"
 S DGNEW("WP",11)="noncompensable patients who do not have any special eligibilities."
 S DGNEW("WP",12)="This data will be utilized for IVM (Income Verification Matching)"
 S DGNEW("WP",13)="with the IRS.  Although you may turn this consistency check off,"
 S DGNEW("WP",14)="it is STRONGLY RECOMMENDED it remain ON."
 ;
 D WP^DIE(38.6,DGIEN_",",50,"K","DGNEW(""WP"")","DGERR")
 I $D(DGERR) D
 . D BMES^XPDUTL("NOTE: An error occurred when updating the description")
 . D MSG^DIALOG("AS",.DGOUT,"","","DGERR")
 . D MES^XPDUTL(.DGOUT)
 . D BMES^XPDUTL("Please contact the VistA Help Desk.")
 ;
 D:'$D(DGERR) BMES^XPDUTL("Post-Installation Complete, the description has been updated.")
 Q
