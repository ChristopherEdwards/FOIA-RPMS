DG53P273 ;BP-CIOFO/KEITH - Pre/post inits ; 21 May 2001  7:11 PM
 ;;5.3;Registration;**273**;AUG 13, 1993
 ;
POST ;Post init
 N DGFLD,DGOUT,DGFILE
 ;File cross references
 F DGFLD=.01,.03,.09,.351 D XR(.DGFLD)
 ;Recompile templates
 I $O(DGFLD(2,0)) D
 .D MES^XPDUTL("     >>> Recompiling templates...")
 .D DIEZ^DIKCUTL3(2,.DGFLD)
 .Q
 ;Check/update triggering field definitions
 D MES^XPDUTL("     >>> Checking triggering field definitions...")
 D TRIG^DICR(.DGFLD,.DGOUT)
 S DGFILE=0 F  S DGFILE=$O(DGOUT(DGFILE)) Q:'DGFILE  D
 .S DGFLD=0 F  S DGFLD=$O(DGOUT(DGFILE,DGFLD)) Q:'DGFLD  D
 ..D MES^XPDUTL("         Field #"_DGFLD_" of file #"_DGFILE_" updated.")
 ..Q
 .Q
 Q
 ;
XR(DGFLD) ;File index type cross references
 ;
 N DGFDA,DGIEN,DGWP,DGERR,DGXR,DGVAL,DGOUT,DIERR
 ;Set up x-refs. Any value that has a ".", will have the period
 ;replaved with a "D" to prevent x-ref's such as .11 and 11 having
 ;identical xref names
 S DGXR=$S(DGFLD[".":"ADGFMD"_$P(DGFLD,".",2),1:"ADGFM"_DGFLD)
 ;Check for existing x-ref
 S DGVAL(1)=2,DGVAL(2)=DGXR
 D FIND^DIC(.11,"","@;IXIE","KP",.DGVAL,"","","","","DGOUT")
 I $D(DGOUT("DILIST",1)) D  Q
 .D MES^XPDUTL("     >>> Cross reference "_DGXR_" already exists, nothing filed.")
 .Q
 ;Create filer array
 S DGFDA(.11,"+1,",.01)=2                           ;FILE
 S DGFDA(.11,"+1,",.02)=DGXR                        ;NAME
 S DGFDA(.11,"+1,",.11)="This x-ref calls the DG FIELD MONITOR event point."     ;SHORT DESCRIPTION
 S DGFDA(.11,"+1,",.2)="MU"                         ;TYPE
 S DGFDA(.11,"+1,",.4)="F"                          ;EXECUTION
 S DGFDA(.11,"+1,",.41)="I"                         ;ACTIVITY
 S DGFDA(.11,"+1,",.5)="I"                          ;ROOT TYPE
 S DGFDA(.11,"+1,",.51)=2                           ;ROOT FILE
 S DGFDA(.11,"+1,",.42)="A"                         ;USE
 S DGFDA(.11,"+1,",1.1)="D FC^DGFCPROT(.DA,2,"_DGFLD_",""SET"",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q"     ;SET LOGIC
 S DGFDA(.11,"+1,",2.1)="D FC^DGFCPROT(.DA,2,"_DGFLD_",""KILL"",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q"     ;KILL LOGIC
 ;CROSS REFERENCE VALUES
 S DGFDA(.114,"+2,+1,",.01)=1                       ;ORDER NUMBER
 S DGFDA(.114,"+2,+1,",1)="F"                       ;TYPE OF VALUE
 S DGFDA(.114,"+2,+1,",2)=2                         ;FILE NUMBER
 S DGFDA(.114,"+2,+1,",3)=DGFLD                     ;FIELD NUMBER
 S DGFDA(.114,"+2,+1,",7)="F"                       ;COLLATION
 ;DESCRIPTION
 S DGWP(1)="This cross reference activates the DG FIELD MONITOR event point."
 S DGWP(2)="Applications that wish to monitor edit activity related to this field may"
 S DGWP(3)="subscribe to that event point and take action as indicated by the changes"
 S DGWP(4)="that occur.  Refer to the DG FIELD MONITOR protocol for a description of"
 S DGWP(5)="the information available at the time of the event."
 ;File INDEX record
 D UPDATE^DIE("","DGFDA","DGIEN","DGERR")
 I $D(DIERR) D  Q
 .N DGI S DGI=""
 .D MES^XPDUTL("     >>> A problem has occurred during the filing of x-ref. "_DGXR_"!")
 .D MES^XPDUTL("         Please contact Customer Support.")
 .F  S DGI=$O(DGERR("DIERR",1,"TEXT",DGI)) Q:DGI=""  D
 ..D MES^XPDUTL(DGERR("DIERR",1,"TEXT",DGI))
 ..Q
 .Q
 S DGFLD(2,DGFLD)=""  ;Create list to recompile templates
 D MES^XPDUTL("     >>> "_DGXR_" cross reference filed.")
 ;File DESCRIPTION field
 D WP^DIE(.11,DGIEN(1)_",",.1,"","DGWP")
 Q
