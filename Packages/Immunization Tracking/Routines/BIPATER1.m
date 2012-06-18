BIPATER1 ;IHS/CMI/MWR - EDIT PATIENT ERRORS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT/DELETE PATIENT ERRORS.
 ;
 ;
 ;----------
INIT(BIT,BIACT) ;EP
 ;---> Initialize variables and list array.
 ;---> Parameters:
 ;     1 - BIT   (ret) Total Patient Errors.
 ;     2 - BIACT (opt) BIACT=1 include ONLY ACTIVE Patients;
 ;                     BIACT=""/0 include ALL PATIENTS.
 ;
 S VALMSG="Enter ?? for more actions."
 S VALM("TITLE")=" (Immunization v"_$$VER^BILOGO_")"
 ;
 ;---> Order Patient Errors and get Total Patients for Header.
 K ^TMP("BIPTER",$J),^TMP("BIPTER1",$J),^TMP("BIPTER2",$J)
 ;
 ;---> First, order the errors by DOB,Patient Name.
 N BIIEN S BIIEN=0
 F  S BIIEN=$O(^BIPERR(BIIEN)) Q:'BIIEN  D
 .N BIDFN,BIDOB,BINAME
 .S BIDFN=$P(^BIPERR(BIIEN,0),U)
 .;
 .;---> Quit if report is ACTIVE ONLY and this patient is not Active.
 .I $G(BIACT) Q:$$ACTIVE^BIUTL1(BIDFN)'="Active"
 .;
 .S BIDOB=9999999-$$DOB^BIUTL1(BIDFN),BINAME=$$NAME^BIUTL1(BIDFN)
 .;---> If there's a bogus patient error, delete the error and quit.
 .I ('BIDFN)!(BINAME="") D  Q
 ..N DA,DIK S DA=BIIEN,DIK="^BIPERR(" D ^DIK
 .;---> Store in order.
 .S ^TMP("BIPTER1",$J,BIDOB,BINAME,BIIEN)=^BIPERR(BIIEN,0)
 .S BIT=$G(BIT)+1
 ;
 ;---> Now place Patient Error lines in Listmanager array.
 N BIENT,BILINE,BIN
 S (BIENT,BILINE,BIN,BIT)=0
 F  S BIN=$O(^TMP("BIPTER1",$J,BIN)) Q:'BIN  D
 .N BIM S BIM=0
 .F  S BIM=$O(^TMP("BIPTER1",$J,BIN,BIM)) Q:BIM=""  D
 ..N BIIEN S BIIEN=0
 ..F  S BIIEN=$O(^TMP("BIPTER1",$J,BIN,BIM,BIIEN)) Q:'BIIEN  D
 ...N BI0 S BI0=^TMP("BIPTER1",$J,BIN,BIM,BIIEN)
 ...N BIDFN S BIDFN=$P(BI0,U)
 ...;
 ...;---> Set Item# and build Item# array=IEN of Vaccine.
 ...S BIENT=BIENT+1,^TMP("BIPTER2",$J,BIENT)=BIIEN
 ...;
 ...;---> Item#.
 ...S X=" "_$S(BIENT<10:"  "_BIENT,BIENT<100:" "_BIENT,1:BIENT)
 ...;
 ...;---> Patient Name.
 ...S X=X_"  "_$E($$NAME^BIUTL1(BIDFN),1,25)
 ...S X=$$PAD^BIUTL5(X,33,".")
 ...;
 ...;---> Active Status.
 ...S X=X_$E($$ACTIVE^BIUTL1(BIDFN))_"  "
 ...;
 ...;---> Chart#.
 ...S X=X_$J($$HRCN^BIUTL1(BIDFN,$G(DUZ(2))),6)
 ...S X=$$PAD^BIUTL5(X,47," ")
 ...;
 ...;---> Age.
 ...N Y S Y=$$AGEF^BIUTL1(BIDFN)
 ...S Y=$P(Y," ")_$E($P(Y," ",2)) S:+Y<10 Y=" "_Y
 ...S X=X_Y
 ...;
 ...;---> Vaccine Group.
 ...S X=$$PAD^BIUTL5(X,53," ")
 ...S X=X_$P(BI0,U,3)
 ...;
 ...;---> Error Text.
 ...S X=$$PAD^BIUTL5(X,60," ")
 ...D ERRCD^BIUTL2($P(BI0,U,2),.Y,,1)
 ...S X=X_Y
 ...;
 ...;---> Set this Patient Error display row and index in ^TMP.
 ...D WRITE(.BILINE,X,,BIENT)
 ...S BIT=$G(BIT)+1
 ;
 I BILINE=0 D
 .N X S X="   Currently there are no Patient Errors stored"
 .S:$G(BIACT) X=X_" for ACTIVE Patients"  S X=X_"."
 .D WRITE(.BILINE),WRITE(.BILINE,X)
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 I VALMCNT>13 D
 .S VALMSG="Scroll down to view more. Type ?? for more actions."
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK,BIENT) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIPTER",$G(BIVAL),$G(BIBLNK),$G(BIENT))
 Q
 ;
 ;
 ;----------
EDITDEL(BIX) ;EP
 ;---> Edit/Delete a Patient Error.
 ;---> Parameters:
 ;     1 - BIX  (opt) If BIX="" call Edit, if BIX=1 call Delete.
 ;
 ;---> Call the Listmanager Generic Selector of items displayed.
 N VALMY
 D EN^VALM2(XQORNOD(0),"OS")
 ;
 ;---> Check that a Listman Item was passed.
 I '$D(VALMY) D ERRCD^BIUTL2(406,,1) D RESET^BIPATER Q
 ;---> Now set Y=Item# selected from the list.
 N Y S Y=$O(VALMY(0))
 I '$G(Y) D ERRCD^BIUTL2(406,,1) D RESET^BIPATER Q
 ;
 N BIIEN S BIIEN=$G(^TMP("BIPTER2",$J,Y))
 I 'BIIEN D ERRCD^BIUTL2(661,,1) D RESET^BIPATER Q
 ;
 ;---> If this is a call to DELETE an error, delete it and quit.
 I $G(BIX) D  Q
 .N DA,DIK S DA=BIIEN,DIK="^BIPERR("
 .D ^DIK,RESET^BIPATER
 ;
 ;---> This must be a call to EDIT and error.
 N BIDFN S BIDFN=$P($G(^BIPERR(BIIEN,0)),U)
 I 'BIDFN D ERRCD^BIUTL2(216,,1) D RESET^BIPATER Q
 ;
 D
 .N BIACT
 .D HAVEPAT^BIPATVW(BIDFN,DT)
 D RESET^BIPATER
 Q
 ;
 ;
 ;----------
DELALL ;EP
 ;---> Clear/Delete ALL Patient Errors.
 ;
 W !!?3,"Do you REALLY wish to delete ALL Patient Errors?"
 S DIR("?")="     Enter YES to DELETE ALL Patient Errors."
 S DIR(0)="Y",DIR("A")="   Enter Yes or No",DIR("B")="NO"
 D ^DIR W !
 I $D(DIRUT)!('Y) D  Q
 .W !!?3,"No changes made." D DIRZ^BIUTL3()
 ;
 D ZGBL^BIUTL8("^BIPERR(")
 D RESET^BIPATER
 Q
