ACPT27FX ; IHS/ASDST/SDR - CPT 2.07 FIX ROUTINE ;      [ 01/18/2007  11:05 AM ]
 ;;2007;CPT FILES;**1**;DEC 31, 2006
 ;
 Q
EN ;
 ;this part will remove entries that look like this:
 ;  ^ICPT("00100",0)="^^138"
 ;these were created by the CAT^ACPTPOST tag that looks
 ;for the CPT category for the CPT code.  It has worked
 ;fine in the past but suddenly decided to add the "00100"
 ;entry rather than update the 00100 entry (or 100 as the
 ;IEN
 S ACPTIEN=""
 F  S ACPTIEN=$O(^ICPT(ACPTIEN)) Q:ACPTIEN=""  D
 .Q:$G(^ICPT(ACPTIEN,0))=""
 .I $P($G(^ICPT(ACPTIEN,0)),U)="" D
 ..W !,?2,ACPTIEN,?9,$G(^ICPT(ACPTIEN,0))
 ..S DIK="^ICPT("
 ..S DA=ACPTIEN
 ..D ^DIK
 ..W ?15,"...deleted"
 ;
 ;this next part fixes entries in the Modifier file.  There
 ;were some headers in the data that should have been skipped
 ;but was read in as a Modifier and created an entry.  There
 ;was also a bad entry that I removed (not sure if it was from
 ;this load or not but figured it should be removed as well).
 S ACPTIEN="^AUTTCMOD(""-1-1"",0)"
 K @ACPTIEN
 ;
 S ACPTIEN=0
 F  S ACPTIEN=$O(^AUTTCMOD(ACPTIEN)) Q:+ACPTIEN=0  D
 .K ACPTREC,ACPTTXT
 .S ACPTREC=$G(^AUTTCMOD(ACPTIEN,0))
 .F ACPTLN=1:1:11 D
 ..S ACPTTXT=$P($T(TXT+ACPTLN),";;",2)
 ..I ACPTREC=ACPTTXT D
 ...W !,ACPTTXT
 ...S DIK="^AUTTCMOD("
 ...S DA=ACPTIEN
 ...D ^DIK	
 K ACPTIEN,DIK,DA,ACPTLN,ACPTTXT
 Q
TXT ;;
 ;;U.^. GOVERNMENT RIGHTS. CPT is commercial technical data and/or computer data bases and/or commercial computer software and/or commercial computer software documentation, as applicable, which were developed exclusively at private expense by the American Medical Association, 515 North State Street, Chicago, Illinois 60610.  U.S. Government rights to use, modify, reproduce, release, perform, display, or disclose these technical data and/or computer data bases and/or computer software and/or computer software documentation are subject to the limited rights restrictions of DFARS 252.227-7015 (b) (2) (November 1995) and/or subject to the restrictions of DFARS 227.7202-1 (a) (June 1995) and DFARS 227.7202-3 (a) (June 1995), as applicable for U.S. Department of Defense procurements and the limited rights restrictions of FAR 52.227-14 (June 1987) and/or subject to the restricted rights provisions of FAR 52.227-14 (June 1987) and FAR 52.227-19 (June 1987), as applicable, and any applicable agency FAR Supplements, for non-Department of Defense Federal procurements.   
 ;;An^sthesia Physical Status Modifiers
 ;;Ap^endix A
 ;;Ex^mple
 ;;Fo^ questions regarding the use of CPT codes, please contact the American Medical Association CPT® Network at www.cptnetwork.com.
 ;;Le^el II (HCPCS/National) Modifiers
 ;;Mo^ifiers Approved for Ambulatory Surgery Center (ASC) Hospital Outpatient Use
 ;;Ph^sical Status Modifier P6
 ;;Th^ Physical Status modifiers are consistent with the American Society of Anesthesiologists ranking of patient physical status, and distinguishing various levels of complexity of the anesthesia service provided. All anesthesia services are reported by use of the anesthesia five-digit procedure code (00100-01999) with the appropriate physical status modifier appended.
 ;;To^request a license for distribution of products with CPT content, please see our Web site at www.ama-assn.org/go/cpt or contact the American Medical Association Intellectual Property Services, 515 North State Street, Chicago, Illinois 60610.
 ;;Un^er certain circumstances, when another established modifier(s) is appropriate, it should be used in addition to the physical status modifier.
