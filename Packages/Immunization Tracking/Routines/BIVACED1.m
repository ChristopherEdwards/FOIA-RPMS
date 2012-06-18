BIVACED1 ;IHS/CMI/MWR - EDIT VACCINES.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT VACCINE FIELDS: CURRENT LOT, ACTIVE, VIS DATE DEFAULT.
 ;;  PATCH 1: Comment out unnecessary forecast check.  EDIT1+34
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;
 S VALMSG="Enter ?? for more actions."
 S VALM("TITLE")=$$LMVER^BILOGO
 ;
 ;---> Build Listmanager array.
 K ^TMP("BILMVA",$J),BIVAC
 ;
 N BILINE,BIENT,BIN,BIVAC1,I
 S BILINE=0,BIENT=0,BIN=0
 D
 .;I '$D(BICVXD) S BIXREF="AC" Q
 .I '$D(BICVXD) S BIXREF="U" Q
 .S BIXREF="C"
 ;
 F  S BIN=$O(^AUTTIMM(BIXREF,BIN)) Q:BIN=""  D
 .N BI0,BIIEN,X,Y
 .S BIIEN=$O(^AUTTIMM(BIXREF,BIN,0))
 .Q:$D(BIVAC1(BIIEN))
 .S BIVAC1(BIIEN)="",BI0=^AUTTIMM(BIIEN,0)
 .;
 .;---> Set Item# and build Item# array=IEN of Vaccine.
 .S BIENT=BIENT+1,BIVAC(BIENT)=BIIEN
 .;
 .;---> Item#.
 .S X=" "_$S(BIENT<10:" "_BIENT,1:BIENT)
 .;
 .;---> Vaccine (Short) Name.
 .S X=X_"  "_$P(BI0,U,2)
 .S X=$$PAD^BIUTL5(X,17,".")
 .;
 .;---> HL7 Code.
 .S X=X_"("_$P(BI0,U,3)_")"
 .S X=$$PAD^BIUTL5(X,24,".")
 .;
 .;---> Active/Inactive.
 .S X=X_$S($P(BI0,U,7)=1:"Inactive",$P(BI0,U,7)=0:"Active",1:"")
 .;
 .;---> Default Lot#.
 .D:$P(BI0,U,4)
 ..S X=$$PAD^BIUTL5(X,35,".")
 ..S X=X_$$LOTTX^BIUTL6($P(BI0,U,4))
 .;
 .;---> VIS Default Date.
 .D:$P(BI0,U,13)
 ..S X=$$PAD^BIUTL5(X,50,".")
 ..S X=X_$$SLDT2^BIUTL5($P(BI0,U,13),1)
 .;
 .;---> Volume Default.
 .D:$P(BI0,U,18)
 ..S X=$$PAD^BIUTL5(X,60,".")
 ..S X=X_"  "_$P(BI0,U,18)_" ml "
 .;
 .;---> Forecast On/Off.
 .S X=$$PAD^BIUTL5(X,72,".")
 .S X=X_$S($$IMMVG^BIUTL2(BIIEN,3):"YES",1:"NO")
 .;
 .;---> Set this Vaccine display row and index in ^TMP.
 .D WRITE(.BILINE,X,,BIENT)
 .;D WRITE(.BILINE,,,BIENT)
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 I VALMCNT>12 D
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
 D WL^BIW(.BILINE,"BILMVA",$G(BIVAL),$G(BIBLNK),$G(BIENT))
 Q
 ;
 ;
 ;----------
EDIT ;EP
 ;---> Edit a Vaccine.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI VACCINE EDIT, an action on the
 ;               List Manager menu protocol: BI MENU VACCINE EDIT.
 ;
 ;            2) This code calls ScreenMan form:
 ;               BI FORM-VACCINE EDIT to build BI local array
 ;               of data for add/edit of a Vaccine.
 ;               Data already stored in the BI local array is loaded
 ;               into the form by LOADVAC^BIVACED1, which is called
 ;               by the Pre-Action of Block for Vaccine Edit.
 ;
 ;            3) Use BI local array to send data to FDIE^BIFMAN.
 ;
 ;---> Call the Listmanager Generic Selector of items displayed.
 N VALMY
 D EN^VALM2(XQORNOD(0),"OS")
 ;
 ;---> Check that a Listman Item was passed.
 I '$D(VALMY) D ERRCD^BIUTL2(406,,1) D RESET Q
 ;---> Now set Y=Item# selected from the list.
 N Y S Y=$O(VALMY(0))
 I '$G(Y) D ERRCD^BIUTL2(406,,1) D RESET Q
 I $G(BIVAC(Y))="" D ERRCD^BIUTL2(502,,1) D RESET Q
 N BIDA S BIDA=+BIVAC(Y)
 I $G(^AUTTIMM(BIDA,0))="" D ERRCD^BIUTL2(502,,1) D RESET Q
 D EDITSCR(BIDA)
 D FULL^VALM1
 D RESET
 Q
 ;
 ;
 ;----------
EDITSCR(BIVAC) ;EP
 ;---> Edit the fields of a vaccine.
 ;---> Parameters:
 ;     1 - BIVAC (req) Vaccine IEN.
 ;
 ;---> Check that IEN of vaccine is present.
 I '$G(BIVAC) D ERRCD^BIUTL2(441,,1) Q
 N Y S Y=^AUTTIMM(BIVAC,0)
 N BI
 S BI("A")=$P(Y,U,4)      ;Default Lot Number IEN.
 S BI("B")=$P(Y,U,7)      ;Active/Inactive.
 S BI("C")=$P(Y,U,13)     ;VIS Default Date.
 S BI("D")=$P(Y,U,18)     ;Default Volume.
 ;
 ;---> Call Screenman to build BI local array of data by user.
 N BISAVE
 N DR S DR="[BI FORM-VACCINE EDIT]"
 D DDS^BIFMAN(9999999.14,DR,BIVAC,"S",.BISAVE,.BIPOP)
 ;
 ;---> If user saved data, call ^BIUTL7 to save it.
 Q:('$G(BISAVE))
 ;
 ;---> Update data for this vaccine.  (Make this an RPC in the future?)
 ;---> Add contraindication with a reason of Immune Deficiency.
 N BIERR,BIFLD
 S BIFLD(.04)=BI("A"),BIFLD(.07)=BI("B")
 S BIFLD(.13)=BI("C"),BIFLD(.18)=BI("D")
 D FDIE^BIFMAN(9999999.14,BIVAC,.BIFLD,.BIERR)
 ;
 ;---> If there was an error, display it.
 D:$G(BIERR)]""
 .D CLEAR^VALM1,FULL^VALM1,TITLE^BIUTL5("EDIT VACCINE FIELDS")
 .W !!?3,BIERR D DIRZ^BIUTL3()
 ;
 Q
 ;
 ;
 ;----------
LOADVAC ;EP
 ;---> Code to load Vaccine data for ScreenMan Edit form.
 ;---> Called by Pre Action of Block BI BLK-VACCINE EDIT on
 ;---> Form BI FORM-VACCINE EDIT.
 ;
 ;---> Load Parent/Guardian.
 I $G(BI("A"))]"" D PUT^DDSVALF(1,,,BI("A"),"I")
 ;
 ;---> Load Active status.
 I $G(BI("B"))]"" D PUT^DDSVALF(2,,,BI("B"),"I")
 ;
 ;---> Load VIS Default Date.
 I $G(BI("C"))]"" D PUT^DDSVALF(3,,,BI("C"),"I")
 ;
 ;---> Load Mother's HBsAG Status.
 I $G(BI("D"))]"" D PUT^DDSVALF(4,,,BI("D"),"I")
 ;
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT^BIVACED,HDR^BIVACED()
 Q
 ;
 ;
 ;----------
CHGORDR ;EP
 ;---> Change order of display of Vaccine Table (by Short Name or CVX).
 D
 .I '$D(BICVXD) S BICVXD="" Q
 .K BICVXD
 D RESET
 Q
