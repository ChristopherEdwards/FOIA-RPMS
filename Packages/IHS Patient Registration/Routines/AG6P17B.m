AG6P17B ;IHS/ASDST/GTH - Patient Registration 6.0 Patch 17 CONT. ; 
 ;;7.0;IHS PATIENT REGISTRATION;;MAR 28, 2003
 ;
 ; IHS/SET/GTH AG*6*17 10/01/2002
 ;
P17 ;EP -- Update EXIT ACTION of AGMENU to call AG^AGHL7.
 ;;D AG^AGHL7,PHDR^AG,KILL^AG I $D(AGSADUZ2) S DUZ(2)=AGSADUZ2 K AGSADUZ2
 ;
 NEW DA,DIE,DR
 S DA=""
 F  S DA=$O(^DIC(19,"B","AGMENU",DA)) Q:DA=""  D
 . Q:^DIC(19,DA,15)=$P($T(P17+1),";",3)
 . S DIE="^DIC(19,",DR="15///"_$P($T(P17+1),";",3)
 . D ^DIE
 .Q
 Q
 ;
INDXC ;EP - Index "C" x-ref on Elig. Upload log file.
 D BMES^XPDUTL("Indexing new 'C' x-ref on ELIGIBILITY UPLOAD LOG file...")
 NEW DIK
 S DIK="^AGELUPLG(",DIK(1)=".03^C"
 D ENALL^DIK
 D MES^XPDUTL("Index of 'C' complete.")
 Q
 ;
COVIT ;EP - Check MCD Coverage Types.
 D BMES^XPDUTL("Checking Medicaid Coverage Types.")
 ;
 KILL ^TMP("AG6P17B",$J)
 ;
 D RSLT("The following Patients have bad Coverage Type values in their")
 D RSLT("Medicaid Eligibility information.  This was caused by a bug")
 D RSLT("present for many years.  The value of the Coverage Type(s) can")
 D RSLT("be corrected by editing the Patient's Medicaid information on")
 D RSLT("Patient Registration, Page 5."),RSLT(" ")
 D RSLT("  ( To re-run the report:  D COVIT^AG6P17B )  .")
 D RSLT($J("PATIENT",20)_$J("HRN",8)_"  MEDICAID #"_"  ELIG. DATE    COVERAGE TYPE")
 D RSLT("--------------------  ------  ----------  ------------  -------------")
 ;
 NEW AGD2,AGD2,AGD1,AGIT,DFN
 ;
 S AGIT=$P(^DD(9000004.11,.03,0),U,5,99)
 F AGD2=0:0 S AGD2=$O(^AUPNMCD(AGD2)) Q:'AGD2  D
 . F AGD1=0:0 S AGD1=$O(^AUPNMCD(AGD2,11,AGD1)) Q:'AGD1  D
 .. S X=$P(^AUPNMCD(AGD2,11,AGD1,0),U,3)
 .. Q:'$L(X)
 .. X AGIT
 .. Q:$D(X)
 .. S DFN=$P(^AUPNMCD(AGD2,0),U)
 .. D RSLT($J($P(^DPT(DFN,0),U,1),20)_$J($P($G(^AUPNPAT(DFN,41,DUZ(2),0),"??"),U,2),8)_$J($P(^AUPNMCD(AGD2,0),U,3),12)_"  "_$$FMTE^XLFDT(AGD1)_"  '"_$P(^AUPNMCD(AGD2,11,AGD1,0),U,3)_"'")
 ..Q
 .Q
 ;
 D MES^XPDUTL("Sending e-mail to local data entry person(s).")
 ;
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 S XMSUB="** Report Bad Medicaid Coverage Types **",XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AG6P17B"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="AGZMENU","ABMDZ ELIGIBILITY EDIT","XUMGR","XUPROG","XUPROGMODE" D SINGLE^AG6P17A(%)
 D ^XMD
 KILL ^TMP("AG6P17B",$J)
 ;
 D MES^XPDUTL("...Done.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("AG6P17B",$J,0))+1,^(^(0))=% D MES^XPDUTL(%)
 Q
 ;
AGTX ;EP - Remove options from AGTX menu.
 D BMES^XPDUTL("Removing ""AG TX CONFIG"" and ""AGTXALL"" option from export menu ""AGTX"".")
 D MES^XPDUTL("These are the ""CONF"" and ""ALL"" options used for the NPIRS re-load.")
 NEW AGOPT,DIK,DA,X
 S DA(1)=$O(^DIC(19,"B","AGTX",0))
 I 'DA(1) D MES^XPDUTL("...Option 'AGTX' not found in file 19:  ERROR.")
 I DA(1) F AGOPT="AG TX CONFIG","AGTXALL" D
 . S DA=$O(^DIC(19,"B",AGOPT,0))
 . I 'DA(1) D MES^XPDUTL("...Option '"_AGOPT_"' not found in file 19:  ERROR.") Q
 . S DA=$O(^DIC(19,DA(1),10,"B",DA,0))
 . I 'DA D MES^XPDUTL("...Option '"_AGOPT_"' wasn't atch'd to 'AGTX'.  That's OK.") Q
 . S DIK="^DIC(19,DA(1),10,"
 . D ^DIK
 . D MES^XPDUTL("Option '"_AGOPT_"' removed from 'AGTX'.")
 .Q
 D MES^XPDUTL("...Done.")
 Q
 ;
DELR ;EP - Delete unneeded AGTXX* and AGTXZ* routines.
 D BMES^XPDUTL("Deleting unneeded AGTXX* and AGTXZ* routines.")
 KILL ^TMP("AG6P17B",$J)
 I $$RSEL^ZIBRSEL("AGTXX*","^TMP(""AG6P17B"","_$J_",") D DEL
 I $$RSEL^ZIBRSEL("AGTXZ*","^TMP(""AG6P17B"","_$J_",") D DEL
 D MES^XPDUTL("...Done.")
 Q
DEL ;
 NEW X
 S X=""
 F  S X=$O(^TMP("AG6P17B",$J,X)) Q:X=""  X ^%ZOSF("DEL")  I $G(XPDA) D MES^XPDUTL(X_$E("...........",1,11-$L(X))_"<poof'd>")
 KILL ^TMP("AG6P17B",$J)
 Q
 ;
EV ;EP - Process 270/271 components.
 D BMES^XPDUTL("Processing 270/271 fields/components.")
 D MES^XPDUTL("Updating Eligibility Checking Period.")
 NEW DR
 I $G(XPDQUES("POS1")) D  I 1
 . NEW DA,DIC,DIE,DR
 . S DA=DUZ(2),DIE="^AGFAC(",DR="35///"_XPDQUES("POS1")
 . D ^DIE
 . D MES^XPDUTL("...parameter updated.")
 .Q
 E  D MES^XPDUTL("***error: Could not find parameter in post-install.")
 ;
 D MES^XPDUTL("Attaching the '270/271 processing' menu to the 'Eligibility' menu.")
 I $$ADD^XPDMENU("AG TM ELIGIBILITY","AGEV MENU","ECHK") D MES^XPDUTL("....successfully atch'd."),MES^XPDUTL("NOTE:  Security Key *NOT* allocated.") I 1
 E  D BMES^XPDUTL("....Attachment *FAILED*.")
 D MES^XPDUTL("End Processing 270/271 fields/components.")
 Q
 ;
