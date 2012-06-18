SC53272P ;JDS/ALB -PREINIT ; 16 Dec 2002  11:14 AM  ; Compiled January 6, 2003 15:50:04
 ;;5.3;Scheduling;**272**;AUG 13, 1993
HL7EVNT ;Create HL7 event B02 - HL7 EVENT TYPE CODE file (#779.001)
 ;
 ;Input  : None
 ;Output : None
 ;Note   : This is a KIDS complient check point
 ;
 ;Declare variables
 ;
 Q:$D(^HL(779.001,"B","B02"))
 N DIC,X,Y,DLAYGO,DTOUT,DUOUT,NEWENTRY,MSGTXT,PTREVNT,DIE,DA,DR
 ;Create/find entry
 D BMES^XPDUTL(">>> Creating entry for B02 in HL7 EVENT TYPE CODE file (#779.001)")
 S DIC="^HL(779.001,"
 S DIC(0)="L"
 S DIC("DR")="2///PCMM Workload Transmission"
 S DLAYGO=779.001
 S X="B02"
 D ^DIC
 S PTREVNT=+Y
 S NEWENTRY=+$P(Y,"^",3)
 S MSGTXT(1)="    Existing entry found - support of HL7 v2.4 will be added/verified"
 S:(NEWENTRY) MSGTXT(1)="    Entry created - support of HL7 v2.4 will be added"
 I (PTREVNT<0) D
 .S MSGTXT(1)="    ** Unable to create entry for B02"
 .S MSGTXT(2)="    ** Entry must be created manually"
 D MES^XPDUTL(.MSGTXT)
 K MSGTXT
 ;Don't continue if entry wasn't created
 Q:(PTREVNT<0)
 ;Add support for HL7 version 2.4
 S DIC="^HL(779.001,"_PTREVNT_",1,"
 S DIC(0)="LX"
 S DIC("P")=$P(^DD(779.001,100,0),"^",2)
 S DA(1)=PTREVNT
 S DLAYGO=779.001
 S X="2.4"
 D ^DIC
 S MSGTXT(1)="    Support for HL7 v2.4 "_$S($P(Y,"^",3):"added",1:"verified")
 I (Y<0) D
 .S MSGTXT(1)="    ** Unable to add support for HL7 v2.4"
 .S MSGTXT(2)="    ** Support for HL7 v2.4 must be added manually"
 D MES^XPDUTL(.MSGTXT)
 Q:$D(^HL(771.2,"B","PMU"))
 D BMES^XPDUTL(">>> Creating entry for PMU in HL7 MESSAGE TYPE file (#771.2)")
 S DIC="^HL(771.2,"
 S DIC(0)="L"
 S DIC("DR")="2///Workload Message;3///2.4"
 S DLAYGO=771.2
 S X="PMU"
 D ^DIC
 S MSGTXT(1)="    Support for HL7 Message Type PMU added"
 I (Y<0) D
 .S MSGTXT(1)="    ** Unable to add support forHL7 Message Type PMU"
 .S MSGTXT(2)="    ** Support for HL7 Message Type PMU must be added manually"
 D MES^XPDUTL(.MSGTXT)
 ;Done
 Q
POST ;look for active FTEE assignments and update data
 D MES^XPDUTL("Placing current FTEE workload designations in PCMM HL7 EVENT file")
 F DA=0:0 S DA=$O(^SCTM(404.52,DA)) Q:'DA  D
 .S X=$G(^SCTM(404.52,DA,0)) Q:'$P(X,U,9)
 .I $O(^SCTM(404.52,"AIDT",+X,0,-$P(X,U,2)),-1) Q
 .S X=$P(X,U,9)
 .D POSBXREF^SCMCHLX(DA,404.52)
