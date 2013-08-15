BIELIG1 ;IHS/CMI/MWR - EDIT ELIGIBILITY CODES.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**3**;SEP 10,2012
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT ELIG CODE FIELDS: ACTIVE, LOCAL LABEL/TEXT, REPORT ABBREV.
 ;;  PATCH 3: This entire routine to edit Eligibility Codes is new.
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
 K ^TMP("BIELIG",$J),BIVAC
 ;
 N BILINE,BIENT,BIN,BIELIG1,I
 S BILINE=0,BIENT=0,BIN=0
 ;
 ;---> Use this code for selection of xrefs or see rtn BILOT1 code.
 ;D
 ;.I '$D(BICVXD) S BIXREF="B" Q
 ;.S BIXREF="C"
 ;
 N BIA
 F BIA=0,1 D
 .N BIN S BIN=0
 .F  S BIN=$O(^BIELIG("AC",BIA,BIN)) Q:BIN=""  D
 ..N BI0,BIIEN,X,Y
 ..S BIIEN=$O(^BIELIG("AC",BIA,BIN,0))
 ..Q:$D(BIELIG1(BIIEN))
 ..S BIELIG1(BIIEN)="",BI0=^BIELIG(BIIEN,0)
 ..;
 ..;---> Set Item# and build Item# array=IEN of Vaccine.
 ..S BIENT=BIENT+1,BIELIG(BIENT)=BIIEN
 ..;
 ..;---> Item#.
 ..S X=" "_BIENT_$S(BIENT<10:"   ",BIENT<100:"  ",1:" ")
 ..;
 ..;---> Code.
 ..S X=X_$P(BI0,U,1)
 ..S X=$$PAD^BIUTL5(X,15,".")
 ..;
 ..;---> Label of Code.
 ..S X=X_$E($P(BI0,U,2),1,21)
 ..S X=$$PAD^BIUTL5(X,38,".")
 ..;
 ..;---> Active/Inactive.
 ..S X=X_$S($P(BI0,U,3)=1:"Inactive",1:"Active")
 ..S X=$$PAD^BIUTL5(X,48,".")
 ..;
 ..;---> Local Text.
 ..S X=X_$E($P(BI0,U,4),1,20)
 ..S X=$$PAD^BIUTL5(X,70,".")
 ..;
 ..;---> Forecast On/Off.
 ..S X=X_$P(BI0,U,5)
 ..;
 ..;---> Set this Vaccine display row and index in ^TMP.
 ..D WRITE(.BILINE,X,,BIENT)
 ..;D WRITE(.BILINE,,,BIENT)
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
 D WL^BIW(.BILINE,"BIELIG",$G(BIVAL),$G(BIBLNK),$G(BIENT))
 Q
 ;
 ;
 ;----------
EDIT ;EP
 ;---> Edit an Eligibility Code.
 ;---> Called by Protocol: BI ELIGIBILITY CODE EDIT.
 ;---> Call the Listmanager Generic Selector of items displayed.
 N VALMY
 D EN^VALM2(XQORNOD(0),"OS")
 ;
 ;---> Check that a Listman Item was passed.
 I '$D(VALMY) D ERRCD^BIUTL2(406,,1) D RESET Q
 ;---> Now set Y=Item# selected from the list.
 N Y S Y=$O(VALMY(0))
 I '$G(Y) D ERRCD^BIUTL2(406,,1) D RESET Q
 I $G(BIELIG(Y))="" D ERRCD^BIUTL2(514,,1) D RESET Q
 N BIDA S BIDA=+BIELIG(Y)
 I $G(^BIELIG(BIDA,0))="" D ERRCD^BIUTL2(514,,1) D RESET Q
 ;---> Use next line and called code if you want to use Screenman.
 ;D EDITSCR(BIDA)
 D EDITFM(BIDA)
 D FULL^VALM1
 D RESET
 Q
 ;
 ;
 ;----------
EDITFM(BIELIG) ;EP
 ;---> Edit the fields of am Eligibility Code by Fileman.
 ;---> Parameters:
 ;     1 - BIELIG (req) Eligibility Code IEN.
 ;
 ;---> Check that IEN of Elig Code is present.
 I '$G(BIELIG) D ERRCD^BIUTL2(514,,1) Q
 N Y S Y=^BIELIG(BIELIG,0)
 D TITLE^BIUTL5("EDIT ELIGIBILITY CODE")
 W !?5,"          Elig Code: ",$P(Y,U)
 W !?5,"    Code Label/Text: ",$P(Y,U,2)
 W !?5,"      Active Status: ",$S($P(Y,U,3):"Inactive",1:"Active")
 W !?5,"         Local Text: ",$P(Y,U,4)
 W !?5,"Report Abbreviation: ",$P(Y,U,5),!!!
 ;
 S DR=".03;.04;.05"
 D DIE^BIFMAN(9002084.83,DR,+BIELIG,.BIPOP)
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
 N Y S Y=^BIELIG(BIVAC,0)
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
 D INIT^BIELIG,HDR^BIELIG()
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
