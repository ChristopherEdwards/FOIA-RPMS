BIPATCO2 ;IHS/CMI/MWR - ADD/DELETE CONTRAINDICATIONS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  ADD AND DELETE CONTRAINDICATIONS VIA LISTMANAGER.
 ;
 ;
 ;----------
ADDCON ;EP
 ;---> Add a Contraindication via List Manager.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI CONTRAINDICATION ADD, an action on the
 ;               List Manager menu protocol: BI MENU CONTRAINDICATIONS.
 ;
 ;            2) This code calls ScreenMan form:
 ;               BI FORM-CONTRAIND ADD/EDIT to add a contraindication.
 ;
 ;            3) SAVCONTR^BIUTL7 uses BI local array to build data
 ;               to pass to ADD^BIRPC4 (which is also called by
 ;               the Broker from the GUI).
 ;
 ;            4) BIRPC4 adds the BI CONTRAINDICATION entry.
 ;
 ;---> Check that DFN for this patient is present.
 I '$G(BIDFN) D ERRCD^BIUTL2(405,,1) D RESET Q
 N BI S BI("A")=BIDFN
 ;
 ;
 ;---> Call Screenman to build BI local array of data by user.
 N BISAVE
 N DR S DR="[BI FORM-CONTRAIND ADD/EDIT]"
 D DDS^BIFMAN(9000001,DR,BIDFN,"S",.BISAVE,.BIPOP)
 ;
 ;---> If user saved data, call ^BIUTL7 to save it.
 D:$G(BISAVE) SAVCONTR^BIUTL7(.BI)
 ;
 D RESET
 Q
 ;
 ;
 ;----------
EDITCON ;EP
 ;---> Edit a Contraindication via List Manager.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI CONTRAINDICATION EDIT, an action on the
 ;               List Manager menu protocol: BI MENU CONTRAINDICATIONS.
 ;
 ;            2) This code gets a Contraindication from List Manager
 ;               and calls the ScreenMan form: BI FORM-CONTRAIND ADD/EDIT
 ;               to edit the contraindication.
 ;
 ;            3) BIRPC4 deletes the BI CONTRAINDICATION entry.
 ;
 ;
 ;---> Check that Contraindication string for this patient is
 ;---> present; if not, set Error Code and quit.
 I '$G(BIDFN) D ERRCD^BIUTL2(415,,1) D RESET Q
 I $G(BICONT(BIDFN))="" D ERRCD^BIUTL2(313,,1) D RESET Q
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
 ;
 S Y=$P(BICONT(BIDFN),U,Y)
 I Y']"" D ERRCD^BIUTL2(303,,1) D RESET Q
 ;
 N BI,BIDIEN
 S BI("A")=BIDFN           ;Patient DFN.
 S BI("I")=$P(Y,"|",1)     ;IEN of this Contraindication.
 S BICONTDA=BI("I")        ;Save IEN of olf Contraindication to delete below.
 ;
 S BI("B")=$P($G(^BIPC(BI("I"),0)),U,2)     ;Vaccine IEN.
 I 'BI("B") D ERRCD^BIUTL2(418,,1) D RESET Q
 ;
 S BI("C")=$P(Y,"|",3)     ;Reason (external text).
 S BI("D")=$P(Y,"|",4)     ;Date (external text).
 ;---> Change Date to internal (in case Screenman doesn't get a chance).
 D
 .N X,Y,%DT S X=BI("D") D ^%DT
 .S BI("D")=Y
 ;
 ;--->Flag: If N=1 this is an EDIT.
 S BI("N")=1
 ;
 ;---> Call Screenman to build BI local array of data by user.
 N BIERR,BISAVE
 N DR S DR="[BI FORM-CONTRAIND ADD/EDIT]"
 D DDS^BIFMAN(9000001,DR,BIDFN,"S",.BISAVE,.BIPOP)
 ;
 ;---> If user saved data, file it.
 I $G(BISAVE) D
 .D SAVCONTR^BIUTL7(.BI,.BIERR)
 .Q:($G(BIERR)]"")
 .;---> Now delete old (original) Contraindication.
 .D:$G(BICONTDA) DELCONT^BIRPC4(,BICONTDA)
 ;
 D RESET
 Q
 ;
 ;
 ;----------
DELETCON ;EP
 ;---> Delete a Contraindication via List Manager.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI CONTRAINDICATION DELETE, an action on the
 ;               List Manager menu protocol: BI MENU CONTRAINDICATIONS.
 ;
 ;            2) This code gets a Contraindication from List Manager
 ;               and calls DELCONT^BIRPC4 (which is also called by
 ;               the Broker from the GUI).
 ;
 ;            3) BIRPC4 deletes the BI CONTRAINDICATION entry.
 ;
 ;
 ;---> Check that Contraindication string for this patient is
 ;---> present; if not, set Error Code and quit.
 I '$G(BIDFN) D ERRCD^BIUTL2(415,,1) D RESET Q
 I $G(BICONT(BIDFN))="" D ERRCD^BIUTL2(313,,1) D RESET Q
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
 ;
 S Y=$P(BICONT(BIDFN),U,Y)
 I Y']"" D ERRCD^BIUTL2(303,,1) D RESET Q
 ;
 D FULL^VALM1
 ;
 ;---> Display contraindication for confirmation.
 ;---> Set Contraindication confirmation display and IEN.
 N BICONTDA,V S V="|"
 S X=$P(Y,V,2)_":  "_$P(Y,V,3)_"  "_$P(Y,V,4)
 ;---> BICONTDA=DA of Contraindication to be deleted.
 S BICONTDA=$P(Y,V)
 ;
 D TITLE^BIUTL5("DELETE A CONTRAINDICATION")
 N A
 S A(1)="Do you really wish to DELETE this Contraindication?"
 S A(1,"F")="!!?3"
 S A(2)="Patient: "_$E($$NAME^BIUTL1(BIDFN),1,25)
 S A(2)=A(2)_"       Chart#: "_$$HRCN^BIUTL1(BIDFN)
 S A(2,"F")="!!?10"
 S A(3)=X,A(3,"F")="!!?10"
 S A(4,"F")="!"
 D EN^DDIOL(.A)
 ;
 N B,BIPOP S BIPOP=0
 S B(1)="     Enter YES to DELETE this Contraindication."
 S B(2)="     Enter NO to leave it unchanged."
 D DIR^BIFMAN("Y",.Y,,"   Enter Yes or No","NO",B(2),B(1))
 ;
 ;---> Failed to confirm.
 I Y<1 D  Q
 .D IO^BIO("NO changes made.")
 .D DIRZ^BIUTL3(),RESET
 ;
 ;---> Delete the visit.
 S BIPOP=""
 D DELCONT^BIRPC4(.BIPOP,BICONTDA)
 ;
 ;---> If an error is passed back, display it.
 N BI31 S BI31=$C(31)_$C(31),BIPOP=$P(BIPOP,BI31,2)
 I BIPOP]"" D IO^BIO(BIPOP),DIRZ^BIUTL3()
 D RESET
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT^BIPATCO,HDR^BIPATCO
 Q
