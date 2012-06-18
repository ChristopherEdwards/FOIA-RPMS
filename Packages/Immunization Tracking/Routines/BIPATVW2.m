BIPATVW2 ;IHS/CMI/MWR - ADD/EDIT/DELETE VISITS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  ADD, EDIT, DELETE VISITS VIA LIST MANAGER.
 ;;  PATCH 1: Do not stuff default VFC if patient < 19 yrs.  ADDIMM+33
 ;
 ;
 ;----------
ADDIMM ;EP
 ;---> Add an Immunization via List Manager.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI IMMUNIZATION VISIT ADD, an action on the
 ;               List Manager menu protocol: BI MENU PATIENT VIEW
 ;
 ;            2) This code calls ScreenMan form:
 ;               BI FORM-IMM VISIT ADD/EDIT to build BI local array
 ;               of data for add/edit of Immunization visit.
 ;               Data already stored in the BI local array is loaded
 ;               into the form by LOADVIS^BIUTL7, which is called
 ;               by the Pre-Action of Blocks for Imm/Skin Edits.
 ;
 ;            3) SAVISIT^BIUTL7 uses BI local array to build data
 ;               to pass to ADDEDIT^BIRPC3 (which is also called by
 ;               the Broker from the GUI).
 ;
 ;            4) BIRPC3 calls ADDV^BIVISIT, which adds the
 ;               Visit to the V Files.
 ;
 ;---> Variables:
 ;     1 - BIDFN   (req) Patient DFN.
 ;     2 - BIDUZ2  (req) DUZ(2) of User (for Site Parameters).
 ;     3 - BIDEFDT (opt) Default date of new Visit.
 ;
 ;---> Check that DFN for this patient is present.
 I '$G(BIDFN) D ERRCD^BIUTL2(405,,1) D RESET Q
 N BI S BI("A")=BIDFN
 ;
 ;---> Set default VFC Eligibility.
 ;---> If Patient Ben Type is 01 (Am Indian/AK Native), set VFC default=4.
 ;
 ;********** PATCH 1, v8.3.1, Dec 30,2008, IHS/CMI/MWR
 ;---> Do NOT stuff VFC default is patient is not < 19 years old.
 ;I $$BENTYP^BIUTL11(BIDFN,2)="01" S BI("P")=4
 I $$AGE^BIUTL1(BIDFN,1)<19,$$BENTYP^BIUTL11(BIDFN,2)="01" S BI("P")=4
 ;**********
 ;
 ;---> Set default date.
 S BI("E")=$G(BIDEFDT)
 ;
 ;---> Get Site IEN for parameters.
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 I '$G(BIDUZ2) D ERRCD^BIUTL2(105,,1) Q
 S BI("Z")=BIDUZ2
 ;
 ;---> Call Screenman to build BI local array of data by user.
 ;---> NOTE: The absence of BI("K") (IEN of Old V File entry) signals
 ;--->       a NEW V Immunizaton.
 ;---> BISAVE=Flag to call BIUTL7 to save data (below).  vvv83
 ;---> BITOLONG=Flag used in Screenman to display pop-up: Other Loc too long.
 N BISAVE,BITOLONG
 N DR S DR="[BI FORM-IMM VISIT ADD/EDIT]"
 D DDS^BIFMAN(9000001,DR,BIDFN,"S",.BISAVE,.BIPOP)
 ;
 ;---> If user saved data, call ^BIUTL7 to save it.
 D:$G(BISAVE) SAVISIT^BIUTL7("I",.BI)
 ;
 D RESET
 Q
 ;
 ;
 ;----------
ADDSK ;EP
 ;---> Add a Skin Test via List Manager.
 ;---> Steps are the same as ADDIMM above.
 ;
 ;---> Check that DFN for this patient is present.
 I '$G(BIDFN) D ERRCD^BIUTL2(405,,1) D RESET Q
 N BI S BI("A")=BIDFN
 ;
 ;---> Set default date and volume.
 S BI("E")=$G(BIDEFDT),BI("W")=.1
 ;
 ;---> Get Site IEN for parameters.
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 I '$G(BIDUZ2) D ERRCD^BIUTL2(105,,1) Q
 S BI("Z")=BIDUZ2
 ;
 ;---> Call Screenman to build BI local array of data by user.
 ;---> NOTE: The absence of BI("K") (IEN of Old V File entry) signals
 ;--->       a NEW V Skin Test.
 ;---> BISAVE=Flag to call BIUTL7 to save data (below).  vvv83
 ;---> BITOLONG=Flag used in Screenman to display pop-up: Other Loc too long.
 N BISAVE,BITOLONG
 N DR S DR="[BI FORM-SKIN VISIT ADD/EDIT]"
 D DDS^BIFMAN(9000001,DR,BIDFN,"S",.BISAVE,.BIPOP)
 ;
 ;---> If user saved data, call ^BIUTL7 to save it.
 D:$G(BISAVE) SAVISIT^BIUTL7("S",.BI)
 ;
 D RESET
 Q
 ;
 ;
 ;----------
EDITIMM ;EP
 ;---> Edit an Immunization via List Manager.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI V FILE VISIT EDIT, an action on the
 ;               List Manager menu protocol: BI MENU PATIENT VIEW
 ;
 ;            2) This code gets an Imm Visit from List Manager
 ;               and loads the data into the Screenman form:
 ;               BI FORM-IMM VISIT ADD/EDIT to build BI local array
 ;               of data for add/edit of Immunization visit.
 ;               Data already stored in the BI local array is loaded
 ;               into the form by LOADVIS^BIUTL7, which is called
 ;               by the Pre-Action of Blocks for Imm/Skin Edits.
 ;
 ;            3) SAVISIT^BIUTL7 uses BI local array to build data
 ;               to pass to ADDEDIT^BIRPC3 (which is also called by
 ;               the Broker from the GUI).
 ;
 ;            4) BIRPC3 calls DELETE^BIVISIT and ADDV^BIVISIT,
 ;               which broker Visits to the V Files.
 ;
 ;
 ;---> Call the List Manager Generic Selector of items displayed.
 N VALMY
 D EN^VALM2(XQORNOD(0),"OS")
 ;
 ;---> Check that Imm History string for this patient is present.
 ;---> If Imm History not supplied, set Error Code and quit.
 I '$G(BIDFN) D ERRCD^BIUTL2(405,,1) D RESET Q
 I $G(BIHX(BIDFN))']"" D ERRCD^BIUTL2(303,,1) D RESET Q
 ;
 ;---> Check that a Listman Item was passed; if so, set Y=which
 ;---> item (Imm Visit) was passed/selected.
 ;I '$D(VALMY) D ERRCD^BIUTL2(406,,1) D RESET Q
 I '$D(VALMY) D RESET Q
 N Y S Y=$O(VALMY(0))
 I '$G(Y) D ERRCD^BIUTL2(406,,1) D RESET Q
 ;
 ;---> Get V Type: Imm or Skin.
 N BIVTYPE S BIVTYPE=$P($P(BIHX(BIDFN),U,Y),"|")
 ;
 ;---> If BIVTYPE does not="I" (Immunization Visit) and it does
 ;---> not="S" (Skin Test Visit), then set Error Code and quit.
 I ($G(BIVTYPE)'="I")&($G(BIVTYPE)'="S") D  Q
 .D ERRCD^BIUTL2(410,,1) D RESET
 ;
 ;---> Set BIVFIEN=V File IEN.
 N BIVFIEN S BIVFIEN=$P($P(BIHX(BIDFN),U,Y),"|",4)
 ;
 ;---> Gather data for this Visit to load for Screenman edit.
 D GET^BIRPC1(.Y,BIVFIEN,BIVTYPE)
 ;
 ;---> If an error is passed back, display it and quit.
 N BI31,BIERR S BI31=$C(31)_$C(31)
 S BIERR=$P(Y,BI31,2)
 I BIERR]"" D IO^BIO(BIERR),DIRZ^BIUTL3() D RESET Q
 ;
 ;---> If no error, then set Y=data (1st BI31 piece).
 S Y=$P(Y,BI31)
 ;
 ;---> Build BI array of Visit data for ScreenMan Edit form.
 N BI,DR,V S V="|"
 ;
 ;---> Build array for Immunization Visit.
 D:BIVTYPE="I"
 .S BI("A")=+BIDFN          ;Patient DFN.
 .S BI("B")=+$P(Y,V,7)      ;Vaccine Name IEN.
 .S BI("C")=$P(Y,V,3)       ;Dose# of Immunization.
 .S BI("D")=$P(Y,V,9)       ;Lot Number IEN.
 .S BI("E")=$P(Y,V,6)       ;Date/Time of Imm Visit (ext form).
 .S BI("F")=+$P(Y,V,11)     ;Location of Encounter IEN.
 .S BI("G")=$P(Y,V,13)      ;Other Location of Encounter Text.
 .S BI("I")=$P(Y,V,12)      ;Catgegory of Visit (A,E,I).
 .S BI("J")=$P(Y,V,22)      ;Visit IEN.
 .S BI("K")=BIVFIEN         ;Old V File IEN - indicates EDIT of previous Imm.
 .S BI("O")=+$P(Y,V,15)     ;Reaction to Immunization on this Visit.
 .S BI("P")=$P(Y,V,23)      ;VFC Eligibility.  vvv83
 .S BI("Q")=$P(Y,V,17)      ;Release/Revision Date of VIS (DD-Mmm-YYYY).
 .S BI("R")=$P(Y,V,18)      ;Immunization Provider.
 .S BI("S")=$P(Y,V,19)      ;Dose Override.
 .S BI("T")=$P(Y,V,20)      ;Injection Site.
 .S BI("W")=$P(Y,V,21)      ;Volume.
 .S BI("Y")=$P(Y,V,24)      ;Imported From Outside Source (=1).
 .S BI("H")=$P(Y,V,25)      ;NDC Code pointer IEN.
 .;
 .S DR="[BI FORM-IMM VISIT ADD/EDIT]"
 ;
 ;---> Build array for Skin Test Visit.
 D:BIVTYPE="S"
 .S BI("A")=+BIDFN          ;Patient DFN.
 .S BI("B")=+$P(Y,V,13)     ;Skin Test IEN.
 .S BI("E")=$P(Y,V,4)       ;Date/Time of Skin Test Visit (ext form).
 .S BI("F")=+$P(Y,V,5)      ;Location of Encounter IEN.
 .S BI("G")=$P(Y,V,7)       ;Other Location of Encounter Text.
 .S BI("I")=$P(Y,V,6)       ;Catgegory of Visit (A,E,I).
 .S BI("J")=$P(Y,V,18)      ;Visit IEN.
 .S BI("K")=BIVFIEN         ;Old V File IEN (for edits).
 .S BI("L")=$P(Y,V,9)       ;Skin Test Result.
 .S BI("M")=$P(Y,V,10)      ;Skin Test Reading.
 .S BI("N")=$P(Y,V,11)      ;Skin Test Date Read.
 .S BI("R")=$P(Y,V,14)      ;Skin Test Provider.
 .S BI("T")=$P(Y,V,15)      ;Injection Site.
 .S BI("W")=$P(Y,V,16)      ;Volume.
 .S BI("X")=$P(Y,V,17)      ;Skin Test Reader.
 .;
 .S DR="[BI FORM-SKIN VISIT ADD/EDIT]"
 ;
 ;
 ;---> Get Site IEN for parameters.
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 I '$G(BIDUZ2) D ERRCD^BIUTL2(105,,1) Q
 S BI("Z")=BIDUZ2
 ;
 ;---> Call Screenman to build BI local array of data edited by user.
 ;---> BISAVE=Flag to call BIUTL7 to save data (below).  vvv83
 ;---> BITOLONG=Flag used in Screenman to display pop-up: Other Loc too long.
 N BISAVE,BITOLONG
 D DDS^BIFMAN(9000001,DR,BIDFN,"S",.BISAVE,.BIPOP)
 ;
 ;---> If user saved data, call ^BIUTL7 to save it.
 D:$G(BISAVE) SAVISIT^BIUTL7(BIVTYPE,.BI)
 ;
 D RESET
 Q
 ;
 ;
 ;----------
DELETIMM ;EP
 ;---> Delete an Immunization or Skin Test via List Manager.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI V FILE VISIT DELETE, an action on the
 ;               List Manager menu protocol: BI MENU PATIENT VIEW
 ;
 ;            2) This code gets an Imm or Skin Visit from List Manager
 ;               and calls DELETE^BIRPC3 (which is also called by
 ;               the Broker from the GUI).
 ;
 ;            5) BIRPC3 calls DELETE^BIVISIT, which will
 ;               delete the V File entry.
 ;
 ;---> Call the List Manager Generic Selector of items displayed.
 N VALMY
 D EN^VALM2(XQORNOD(0),"OS")
 ;
 ;---> Check that Imm History string for this patient is present.
 ;---> If Imm History not provided, set Error Code and quit.
 I '$G(BIDFN) D ERRCD^BIUTL2(405,,1) D RESET Q
 I $G(BIHX(BIDFN))']"" D ERRCD^BIUTL2(303,,1) D RESET Q
 ;
 ;---> Check that a Listman Item was passed.
 I '$D(VALMY) D ERRCD^BIUTL2(406,,1) D RESET Q
 N Y S Y=$O(VALMY(0))
 I '$G(Y) D ERRCD^BIUTL2(406,,1) D RESET Q
 ;
 S Y=$P(BIHX(BIDFN),U,Y)
 I Y']"" D ERRCD^BIUTL2(303,,1) D RESET Q
 ;
 D FULL^VALM1
 ;
 ;---> Display visit for confirmation.
 N BIVFIEN,BIVTYPE,V S V="|"
 ;
 S BIVTYPE=$P(Y,V)
 ;---> If BIVTYPE does not="I" (Immunization Visit) and it does
 ;---> not="S" (Skin Test Visit), then set Error Code and quit.
 I ($G(BIVTYPE)'="I")&($G(BIVTYPE)'="S") D  Q
 .D ERRCD^BIUTL2(410,,1) D RESET Q
 ;
 ;---> Set Immunization confirmation display fields and Visit IEN.
 I BIVTYPE="I" D
 .S X=$P(Y,V,7)_"  "_$P(Y,V,2)_"   "_$P(Y,V,5)
 .S BIVFIEN=$P(Y,V,4)
 ;
 ;---> Set Skin Test confirmation display fields and Visit IEN.
 I BIVTYPE="S" D
 .S X=$P(Y,V,7)_"  "_$P(Y,V,11)_"   "_$P(Y,V,8)_"  "_$P(Y,V,9)
 .S:$P(Y,V,9) X=X_" mm"
 .S X=X_"  "_$P(Y,V,5)
 .S BIVFIEN=$P(Y,V,4)
 ;
 ;
 D TITLE^BIUTL5("DELETE AN IMMUNIZATION VISIT")
 N A
 S A(1)="Do you really wish to DELETE this Visit?"
 S A(1,"F")="!!?3"
 S A(2)="Patient: "_$E($$NAME^BIUTL1(BIDFN),1,25)
 S A(2)=A(2)_"       Chart#: "_$$HRCN^BIUTL1(BIDFN)
 S A(2,"F")="!!?10"
 S A(3)=X,A(3,"F")="!!?10"
 S A(4,"F")="!"
 D EN^DDIOL(.A)
 ;
 N B,BIERR S BIERR=0
 S B(1)="     Enter YES to DELETE this Visit."
 S B(2)="     Enter NO to leave it unchanged."
 D DIR^BIFMAN("Y",.Y,,"   Enter Yes or No","NO",B(2),B(1))
 ;
 ;---> Failed to confirm.
 I Y<1 D  Q
 .D IO^BIO("NO changes made.")
 .D DIRZ^BIUTL3(),RESET
 ;
 ;---> Delete the visit.
 S BIERR=""
 D DELETE^BIRPC3(.BIERR,BIVFIEN,BIVTYPE)
 ;
 ;---> If an error is passed back, display it.
 N BI31 S BI31=$C(31)_$C(31),BIERR=$P(BIERR,BI31,2)
 I BIERR]"" D IO^BIO(BIERR),DIRZ^BIUTL3()
 D RESET
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listman.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D HDR^BIPATVW(),INIT^BIPATVW
 Q
