BIDUR1 ;IHS/CMI/MWR - RETRIEVE/STORE PATIENTS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  RETRIEVE/STORE PATIENTS FOR DUE LISTS & LETTERS.
 ;
 ;
 ;----------
STORE(BIDFN,BIFDT,BIORD,BIERR,BIVAL,BISITE) ;EP
 ;---> Store this patient in the Order specified.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN (DFN).
 ;     2 - BIFDT  (req) Forecast date.
 ;     3 - BIORD  (req) Order of listing (default=1, by age).
 ;     4 - BIERR  (ret) Error Code.
 ;     5 - BIVAL  (opt) Value to set ^TMP(Patient...) node equal to.
 ;     6 - BISITE (req) Site IEN.
 ;
 ;---> Check for required Variables.
 I '$G(BIDFN) S BIERR=201 Q
 I '$G(BIFDT) S BIERR=616 Q
 S:'$G(BIORD) BIORD=1
 S:'$G(BISITE) BISITE=$G(DUZ(2)) I '$G(BISITE) S BIERR=109 Q
 ;
 ;---> Store this patient in the Order specified:
 ;
 ;---> By Patient Alphabetically.
 I BIORD=2 D  Q
 .N X,Y,Z
 .S X=1,Y=1,Z=$$NAME^BIUTL1(BIDFN)
 .S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 ;
 ;---> By HRCN/Chart#.
 I BIORD=3 D  Q
 .N X,Y,Z
 .S X=1,Y=1,Z=$$HRCN^BIUTL1(BIDFN,BISITE,1)
 .S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 ;
 ;---> By Case Manager.
 I BIORD=4 D  Q
 .N X,Y,Z
 .S X=$$CMGR^BIUTL1(BIDFN,1),Y=1,Z=$$NAME^BIUTL1(BIDFN)
 .S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 ;
 ;---> By Case Manager, then Current Community.
 I BIORD=5 D  Q
 .N X,Y,Z
 .S X=$$CMGR^BIUTL1(BIDFN,1),Y=$$CURCOM^BIUTL11(BIDFN,1)
 .S Z=$$NAME^BIUTL1(BIDFN)
 .S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 ;
 ;---> By Current Community, then Case Manager.
 I BIORD=6 D  Q
 .N X,Y,Z
 .S X=$$CURCOM^BIUTL11(BIDFN,1),Y=$$CMGR^BIUTL1(BIDFN,1)
 .S Z=$$NAME^BIUTL1(BIDFN)
 .S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 ;
 ;---> By Current Community, then Patient Age.
 I BIORD=7 D  Q
 .N X,Y,Z
 .S X=$$CURCOM^BIUTL11(BIDFN,1),Y=9999999-$$DOB^BIUTL1(BIDFN)
 .S Z=$$NAME^BIUTL1(BIDFN)
 .S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 ;
 ;---> By Current Community, then Patient Name.
 I BIORD=8 D  Q
 .N X,Y,Z
 .S X=$$CURCOM^BIUTL11(BIDFN,1),Y=1,Z=$$NAME^BIUTL1(BIDFN)
 .S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 ;
 ;---> By Current Community, then Patient Chart#.
 I BIORD=9 D  Q
 .N X,Y,Z
 .S X=$$CURCOM^BIUTL11(BIDFN,1),Y=1,Z=$$HRCN^BIUTL1(BIDFN,BISITE,1)
 .S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 ;
 ;---> By Zipcode, then Patient Name.
 I BIORD=10 D  Q
 .N X,Y,Z
 .S X=$$ZIP^BIUTL1(BIDFN),Y=1,Z=$$NAME^BIUTL1(BIDFN)
 .S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 ;
 ;---> By Designated Provider.
 I BIORD=11 D  Q
 .N X,Y,Z
 .S X=$$DPRV^BIUTL1(BIDFN,1),Y=1,Z=$$NAME^BIUTL1(BIDFN)
 .S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 ;
 ;---> By Patient Age (Default, BIORD=1).
 N X,Y,Z
 S X=1,Y=9999999-$$DOB^BIUTL1(BIDFN),Z=$$NAME^BIUTL1(BIDFN)
 S ^TMP("BIDUL",$J,X,Y,Z,BIDFN)=$G(BIVAL)
 Q
 ;
 ;
 ;----------
BENT(BIDFN,BIBEN) ;EP
 ;---> Beneficiary Type indicator.
 ;---> Return 1 if not selecting all Beneficiary Types and if this
 ;---> patient's Beneficiary Type is not one of the ones selected.
 ;
 Q:'$G(BIDFN) 1
 Q:$D(BIBEN("ALL")) 0
 N BIBENT S BIBENT=$$BENTYP^BIUTL11(BIDFN)
 Q:'BIBENT 1
 Q:'$D(BIBEN(BIBENT)) 1
 Q 0
