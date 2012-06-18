BILETPR2 ;IHS/CMI/MWR - PRINT PATIENT LETTERS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PRINT PATIENT LETTERS.
 ;
 ;
 ;----------
INDIVLET(BIDFN,BIRTN) ;EP
 ;---> Select and Print a letter for an individual patient.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI LETTER PRINT INDIVDUAL, an action on the
 ;               Listmanager menu protocol: BI MENU PATIENT VIEW.
 ;
 ;---> Parameters:
 ;     1 - BIDFN (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIRTN (opt) Calling routine for reset.
 ;
 I '$G(BIDFN) D ERRCD^BIUTL2(201,,1) S VALMBCK="R" Q
 S:'$G(BIFDT) BIFDT=DT
 ;
 D
 .D FULL^VALM1 S BIPOP=0
 .D TITLE^BIUTL5("LETTER SELECTION")
 .D ASKLET^BILETPR(.BILET,.BIDLOC,.BIPOP) Q:BIPOP
 .D DEVICE^BILETPR Q:BIPOP
 .D PRINT^BILETPR(BIDFN,BILET,$G(BIDLOC),ION,BIFDT)
 .D ^%ZISC
 ;
 Q:$G(BIRTN)=""
 S VALMBCK="R"
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
PATLETS ;EP
 ;---> Lookup patients, select and print letters.
 ;
 D SETVARS^BIUTL5 N BIDFN,BIFDT
 F  D  Q:$G(BIDFN)<1
 .D TITLE^BIUTL5("PRINT INDIVIDUAL PATIENT LETTERS")
 .D PATLKUP^BIUTL8(.BIDFN)
 .Q:$G(BIDFN)<1
 .D INDIVLET(BIDFN)
 .D UNLOCK^BIPATVW($G(BIDFN))
 Q
 ;
 ;
 ;----------
OFFICIAL(BIDFN,BIRTN) ;EP
 ;---> Print Official Immunization Record for a patient.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI LETTER PRINT INDIVDUAL, an action on the
 ;               Listmanager menu protocol: BI MENU PATIENT VIEW.
 ;
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIRTN  (opt) Calling routine for reset.
 ;
 ;---> Required Variable:
 ;     1 - DUZ(2) (req) User's Site IEN.
 ;
 D
 .D FULL^VALM1 S BIPOP=0
 .I '$G(BIDFN) D ERRCD^BIUTL2(201,,1) Q
 .N BILET S BILET=$$DEFLET^BIUTL2(DUZ(2),,1)
 .I 'BILET D ERRCD^BIUTL2(113,,1) Q
 .I '$D(^BILET(BILET,0)) D  Q
 ..N DA,DIE S DIE="^BISITE(",DA=DUZ(2),DR=".13////@" D ^DIE
 ..D ERRCD^BIUTL2(114,,1)
 .;
 .D DEVICE^BILETPR Q:BIPOP
 .D PRINT^BILETPR(BIDFN,BILET,,ION,$G(DT))
 .D ^%ZISC
 ;
 I $G(BIRTN)]"" S VALMBCK="R" D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
DATELOC(BILET,BILINE,BIDLOC) ;EP
 ;---> Store Date/Location line in WP ^TMP global.
 ;---> Parameters:
 ;     1 - BILET  (req) IEN of Letter in BI LETTER File.
 ;     2 - BILINE (ret) Last line written into ^TMP array.
 ;     3 - BIDLOC (req) Text of Date/Location line.
 ;
 ;---> Quit if this Form Letter does not included a Date/Loc line.
 Q:'$P(^BILET(BILET,0),U,4)
 S:$G(BIDLOC)="" BIDLOC="     Date/Location line not provided."
 D WRITE^BILETPR1(.BILINE),WRITE^BILETPR1(.BILINE,"     "_BIDLOC),WRITE^BILETPR1(.BILINE)
 Q
