BILETPR3 ;IHS/CMI/MWR - PRINT PATIENT LETTERS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  BUILD ^TMP WP ARRAY FOR PRINTING LETTERS.
 ;
 ;
 ;----------
HISTORY2(BILINE,BIHX,BIDFN,BIFORM,BINVAL,BIPDSS) ;EP
 ;---> Set Immunization History in Listman Letter array, sorted
 ;---> by Vaccine.
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line written into ^TMP array.
 ;     2 - BIHX   (req) Patient's Immunization History (string).
 ;     3 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     4 - BIFORM (opt) 3=List by Vaccine, 4=Vaccine w/Lot#.
 ;     5 - BINVAL (opt) 0=Include Invalid Doses, 1=Exclude Invalid Doses.
 ;     6 - BIPDSS (opt) Returned string of Visit IEN's that are
 ;                        Problem Doses, according to ImmServe.
 ;
 S:'$G(BIFORM) BIFORM=3
 N I,V,X,Y,Z S V="|",Z=""
 ;
 ;---> IMMUNIZATIONS
 ;---> PC  DATA
 ;---> --  ----
 ;--->  1 = Visit Type: "I"=Immunization, "S"=Skin Test.
 ;--->  2 = Vaccine Name, Short.
 ;--->  3 = Vaccine Components.  ;v8.0
 ;--->  4 = IEN, V File Visit.
 ;--->  5 = Location (or Outside Location) where Imm was given.
 ;--->  6 = Vaccine Group (Series Type) for grouping of vaccines.
 ;--->  7 = Vaccine Lot#, Text.
 ;--->  8 = Skin Test Result.
 ;--->  9 = Skin Test Reading.
 ;---> 10 = Skin Test Name.
 ;---> 11 = Reaction to Immunization, text.
 ;---> 12 = Date of Visit Fileman format (YYYMMDD).
 ;---> 13 = Dose Override.
 ;---> 14 = Vaccine Component CVX Code.
 ;
 S X="       Immunization          Date Received   Location"
 S:BIFORM=4 X=X_"           Lot#"
 D WRITE(.BILINE,X)
 S X="       ------------          -------------   ---------------"
 S:BIFORM=4 X=X_"    ----------"
 D WRITE(.BILINE,X)
 ;
 ;---> Loop through "^"-pieces of Imm History, displaying Immunizations.
 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;
 .;---> Quit if this is not an Immunization.
 .Q:$P(Y,V)'="I"
 .;
 .;---> If not the same Vaccine Group, insert a blank line.
 .I $P(Y,V,6)'=Z D:I>1 WRITE(.BILINE) S Z=$P(Y,V,6)
 .;
 .;---> Set display line for this Immunization and Date.
 .N BIPDSSA S BIPDSSA=0
 .D
 ..;---> Prepend asterisk if this Dose has a User Override or is
 ..;---> an ImmServe Problem Dose (flag stored in BIPDSSA).
 ..I $P(Y,V,13) S X="      *" Q
 ..I $$PDSS^BIUTL8($P(Y,V,4),$P(Y,V,14),$G(BIPDSS)) S X="      *",BIPDSSA=1 Q
 ..S X="       "
 .;
 .S X=X_$P(Y,V,2),X=$$PAD^BIUTL5(X,29)
 .S X=X_$$TXDT1^BIUTL5($P(Y,V,12))
 .;
 .;---> Pad with spaces to line up in columns, add Location.
 .S X=$$PAD^BIUTL5(X,45)_$E($P(Y,V,5),1,17)
 .;
 .;---> If Lot#'s specified, pad with spaces, add Lot#.
 .D:BIFORM=4
 ..S X=$$PAD^BIUTL5(X,64)_$P(Y,V,7)
 .D WRITE(.BILINE,X)
 .;
 .;
 .;---> If this is a Dose Override by user, set another line to display it.
 .;---> NOT USED FOR NOW.
 .;D:$P(Y,V,13)
 .;.;---> Do not display if Override Reason is "FORCED VALID" (per Ros Singleton).
 .;.Q:$P(Y,V,13)=9
 .;.S X="                             -"_$$DOVER^BIUTL8($P(Y,V,13))_"-"
 .;.D WRITE(.BILINE,X)
 .;
 .;---> If this is a Problem Dose by ImmServe, set another line to display it.
 .;---> NOT USED FOR NOW.
 .;D:$G(BIPDSSA)
 .;.S X="                             -INVALID--SEE IMMSERVE-"
 .;.;---> Pad Result with trailing spaces to justify columns.
 .;.D WRITE(.BILINE,X)
 .;
 .;
 .;---> If there was a Reaction, set another line to display it.
 .D:$P(Y,V,11)]""
 ..S X="                                Reaction: "_$P(Y,V,11)
 ..;---> Pad Result with trailing spaces to justify columns.
 ..D WRITE(.BILINE,X)
 ;
 ;
 ;---> SKIN TESTS
 ;---> PC  DATA
 ;---> --  ----
 ;--->  1 = Visit Type: "I"=Immunization, "S"=Skin Test.
 ;--->  4 = V Skin Test File IEN.
 ;--->  5 = Location (or Outside Location) where Imm was given.
 ;--->  8 = Skin Test Result.
 ;--->  9 = Skin Test Reading.
 ;---> 10 = Skin Test Name.
 ;---> 12 = Date of Visit Fileman format (YYYMMDD).
 ;
 ;---> Do not print Skin Test headers if patient has no Skin Tests.
 I $G(BIDFN) Q:'$D(^AUPNVSK("AC",BIDFN))
 ;
 D WRITE(.BILINE),WRITE(.BILINE)
 S X="       Skin Test      Date Received     Location"
 S X=X_"            Result"
 D WRITE(.BILINE,X)
 S X="       ------------   -------------     ---------------"
 S X=X_"     ---------"
 D WRITE(.BILINE,X)
 ;
 ;---> Loop through "^"-pieces of Imm History, displaying Skin Tests.
 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;
 .;---> Quit if this is not a Skin Test.
 .Q:$P(Y,V)'="S"
 .;
 .;---> Set display line for this Skin Test Name and Date.
 .S X="       "_$P(Y,V,10),X=$$PAD^BIUTL5(X,22)
 .S X=X_$$TXDT1^BIUTL5($P(Y,V,12))
 .;
 .;---> Pad with spaces to line up in columns, add Location.
 .S X=$$PAD^BIUTL5(X,40)_$E($P(Y,V,5),1,15)
 .;
 .;---> Pad with spaces to line up in columns, add Result.
 .S X=$$PAD^BIUTL5(X,60)
 .D
 ..I $P(Y,V,8)]"" S X=X_$P(Y,V,8) Q
 ..I $P(Y,V,9) S X=X_$P(Y,V,9)_" mm" Q
 ..S X=X_"Not recorded"
 .D WRITE(.BILINE,X)
 ;
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL) ;EP
 ;---> Write a line to the ^TMP global for WP or Listman.
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# in the WP ^TMP global.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;
 Q:'$D(BILINE)
 D WRITE^BILETPR1(.BILINE,$G(BIVAL))
 Q
