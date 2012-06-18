BIPATCO ;IHS/CMI/MWR - EDIT CONTRAINDICATIONS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT PATIENT'S CONTRAINDICATIONS THROUGH LISTMANAGER.
 ;
 ;
 ;----------
START ;EP
 ;---> Lookup patients and Add/Edit their Contraindications.
 ;---> NOT CALLED BY ANY MENU OPTION AT THIS POINT.
 ;
 D SETVARS^BIUTL5 N BIDFN
 F  D  Q:$G(BIDFN)<1
 .D TITLE^BIUTL5("ADD/EDIT CONTRAINDICAIONS")
 .D PATLKUP^BIUTL8(.BIDFN)
 .Q:$G(BIDFN)<1
 .D EN(BIDFN)
 D EXIT
 Q
 ;
 ;
 ;----------
HAVEPAT(BIDFN) ;EP
 ;---> Entry point when patient already known.
 D SETVARS^BIUTL5
 K ^TMP("BILMCO",$J)
 D EN(BIDFN)
 Q
 ;
 ;
 ;----------
EN(BIDFN) ;EP
 ;---> Entry point called by Protocol BI CONTRAINDICATIONS.
 ;     1 - BIDFN (req) Patient's IEN in VA PATIENT File #2.
 ;
 ;---> If <STKOV> errors appear here, increase STACK in SYSGEN,
 ;---> System Configuration Parameters.
 ;
 ;---> Quit if BIDFN not provided.
 I '$G(BIDFN) D ERRCD^BIUTL2(206,,1) Q
 ;
 ;---> Quit if this patient is Locked (being edited by another user).
 L +^BIP(BIDFN):0 I '$T D ERRCD^BIUTL2(212,,1) Q
 N BIDFNSAV S BIDFNSAV=BIDFN
 D
 .N BIDFNSAV
 .D EN^VALM("BI PATIENT CONTRAINDICATIONS")
 ;
 ;---> Unlock Patient.
 S BIDFN=BIDFNSAV
 L -^BIP(BIDFN)
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code.
 Q:'$D(BIDFN)
 N X,Y
 S VALMHDR(1)=""
 S Y=$E($$NAME^BIUTL1(BIDFN),1,25)
 S X=" Patient: "_IORVON_Y_IOINORM
 S X=X_$$SP^BIUTL5(27-$L(Y))_"DOB: "_IORVON_$$DOBF^BIUTL1(BIDFN)_IOINORM
 S VALMHDR(2)=X
 ;
 S X="  Chart#: "_IORVON_$$HRCN^BIUTL1(BIDFN)
 S Y=$E($$INSTTX^BIUTL6($G(DUZ(2))),1,17)
 S X=X_" at "_Y_IOINORM
 S X=X_$$SP^BIUTL5(20-$L(Y))_$$ACTIVE^BIUTL1(BIDFN)
 S X=X_"     "_$$SEXW^BIUTL1(BIDFN)
 S VALMHDR(3)=X
 ;
 ;---> Set Screen Title.
 S VALM("TITLE")="CONTRAIND (IMM v"_$$VER^BILOGO_")"
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 D INIT^BIPATCO1
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 W !!?5,"Enter ""H"" for Help with this feature or ""??"" for more options."
 D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;----> Explanation of this report.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("CONTRAINDICATION SCREEN - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;This is the Patient Contraindication Screen, the point from
 ;;which you add or delete the patient's contraindications.
 ;;
 ;;The TOP of the screen lists the patient's demographic information,
 ;;most of which is edited through the RPMS Patient Registration.
 ;;
 ;;The MIDDLE of the screen lists any Contraindications to vaccines
 ;;that the patient may have, along with the Reason for the
 ;;contraindication and the Date it was Noted.
 ;;
 ;;The BOTTOM of the screen provides the  Actions to Add or Delete
 ;;Contraindications, or to view this Explanation.
 ;;
 ;;Contraindications added for the patient here will cause the
 ;;contraindicated vaccine to be eliminated from the Forecast
 ;;(in the right column of the main Patient View screen).
 ;;
 ;;HOWEVER, if the Reason chosen for a Contraindication is
 ;;"Patient Refusal", the vaccine will NOT be eliminated from
 ;;the Forecast.
 ;;
 ;;If you choose "Immune Deficiency," then MMR, Varicella, OPV, and
 ;;Flu-Nasal (all live vaccines) are automatically contraindicated.
 ;;
 ;;NOTE: You may select TST-PPD INTRADERMAL (PPD) as the "vaccine."
 ;;In this case, the only reason selectable will be "Positive TB Skin Test."
 ;;This allows the system to display a contraindication to future PPD tests.
 ;;
 D LOADTX("TEXT1",,.BITEXT)
 Q
 ;
 ;
 ;----------
LOADTX(BILINL,BITAB,BITEXT) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> EOJ cleanup.
 K ^TMP("BILMCO",$J) D KILLALL^BIUTL8()
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
