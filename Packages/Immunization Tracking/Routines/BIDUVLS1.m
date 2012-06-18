BIDUVLS1 ;IHS/CMI/MWR - VIEW DUE LIST.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  LIST TEMPLATE CODE FOR VIEWING PATIENTS.
 ;;  PATCH 1: Corrects Patient Group for not displaying Age Range.  HDR+21
 ;
 ;
 ;----------
START(BIFDT,BINFO,BIPG,BIAG,BIT,BIVAL,BIDASH,BITITL,BIRPDT,BIBEN) ;EP
 ;---> Display Immunizations Due List via Listman.
 ;---> Parameters:
 ;     1 - BIFDT  (req) Forecast/Clinic Date.
 ;     2 - BINFO  (req) Array of Additional Information elements for each patient.
 ;     3 - BIPG   (req) Patient Group Data; see PGRPOUP1^BIOUTPT4 for details.
 ;     4 - BIAG   (opt) Age Range.  If 2nd ^-piece=1, display "years."
 ;     5 - BIT    (req) Total Patients retrieved.
 ;     6 - BIVAL  (opt) Value indicates which patients:
 ;                      0=All, 1=Rejects only, 2=Appropriate only.
 ;     7 - BIDASH (opt) 1=Omit Dash line between records; 0=include it.
 ;     8 - BITITL (opt) Report Name, if present will replace "Clinic Date"
 ;                      in report header.
 ;     9 - BIRPDT (opt) Report Date: Today unless passed from reports
 ;                                   (e.g., Quarterly Report).
 ;    10 - BIBEN  (req) Beneficiary Type array: either BIBEN(1) or BIBEN("ALL").
 ;
 ;----------
MAIN ;EP
 ;---> Listman Screen for printing Immunization Due Letters.
 D SETVARS^BIUTL5
 S:'$G(BIFDT) BIFDT=DT
 S:'$G(BIRPDT) BIRPDT=DT
 N VALMCNT
 D EN
 D EXIT
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point.
 D EN^VALM("BI DUE LIST VIEW")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code
 I '$D(BIPG) D ERRCD^BIUTL2(620,,1) S VALMQUIT="" Q
 K VALMHDR
 N BIDASH,BILINE,X,Y,Z S BILINE=0
 S:'$G(BIRPDT) BIRPDT=DT
 ;
 S X="WARNING: Confidential Patient Information, Privacy Act applies."
 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X,1)
 ;
 S X=$$REPHDR^BIUTL6(DUZ(2)),BIDASH=$L(X)+2 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 S X=$$SP^BIUTL5(BIDASH,"-") D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X="       Report Date: "_$$TXDT1^BIUTL5(BIRPDT)
 S X=X_"        Total Patients: "_$G(BIT)
 ;
 D:$G(BIAG)]""
 .;---> For Patient Group (8=Search Template) to not display Age Range.
 .Q:(+BIPG=8)
 .I BIAG="ALL" S X=X_"  (All Ages)" Q
 .S X=X_" ("_$$MTHYR^BIAGE(BIAG)_")"
 I +BIPG'=8 S X=X_" *"_$S($D(BIBEN("ALL")):"All",1:"01")
 D WH^BIW(.BILINE,X)
 ;
 D
 .I $G(BITITL)]"" S X="      Report Title: "_$$PAD^BIUTL5(BITITL,11) Q
 .I $G(BINFO)["5," S X="       Clinic Date: "_$$TXDT1^BIUTL5(BIFDT) Q
 .S X=""
 ;
 N BIHEAD,BIPG1
 D PGRP^BIDU(BIPG,.BIPG1)
 S BIHEAD="Patient Group: "
 D
 .I X]"",$L(BIHEAD_BIPG1)<41 D  Q
 ..S X=X_$$SP^BIUTL5(9)_BIHEAD_BIPG1 D WH^BIW(.BILINE,X)
 .;---> If Clinic Date & Patient Group won't fit, write Clinic Date and go on.
 .I X]"" D WH^BIW(.BILINE,X)
 .;---> Now write Patient Group info on the next line(s).
 .N I,N,V,Z S N=1,V=",",X="",BIHEAD="     "_BIHEAD
 .F  D  Q:$P(BIPG1,V,I)=""  Q:$G(BIERR)
 ..F I=N:1 S X=$P(BIPG1,V,N,I) Q:$L(X)>60  Q:$P(BIPG1,V,I)=""
 ..I N>1 S BIHEAD=$$SP^BIUTL5(19)
 ..D WH^BIW(.BILINE,BIHEAD_$P(BIPG1,V,N,I-1))
 ..S N=I
 ;
 ;---> If necessary, write a dashed line for subheader,
 ;---> otherwise write a blank line.
 N I K X
 F I="CC","CM","DPRV","MMR","MMD","HCF","LOT" D
 .I $O(@("BI"_I_"(0)")) S X=1
 D WH^BIW(.BILINE,$S($G(X):$$SP^BIUTL5(79,"-"),1:""))
 ;
 D
 .;---> If specific Communities were selected (not ALL), then print
 .;---> the Communities in a subheader at the top of the report.
 .D SUBH^BIOUTPT5("BICC","Community",,"^AUTTCOM(",.BILINE,.BIERR,,11)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Case Managers, print Case Manager subheader.
 .D SUBH^BIOUTPT5("BICM","Case Manager",,"^VA(200,",.BILINE,.BIERR,,11)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Designated Providers, print Designated Provider subheader.
 .D SUBH^BIOUTPT5("BIDPRV","Designated Provider",,"^VA(200,",.BILINE,.BIERR,,11)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Immunizations Received, print subheader.
 .S X="Immunization Rcvd",Y="Immunizations Rcvd"
 .I $G(BIRDT) N Z S Z=" "_$$DATE^BIDU(BIRDT,1)
 .D SUBH^BIOUTPT5("BIMMR",X,Y,"^AUTTIMM(",.BILINE,.BIERR,2,11,$G(Z))
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Immunizations Due, print subheader.
 .S X="Immunization Due",Y="Immunizations Due"
 .D SUBH^BIOUTPT5("BIMMD",X,Y,"^AUTTIMM(",.BILINE,.BIERR,2,11)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Health Care Facilities, print subheader.
 .D SUBH^BIOUTPT5("BIHCF","Facility",,"^DIC(4,",.BILINE,.BIERR,,11)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Lot Numbers, print subheader.
 .D SUBH^BIOUTPT5("BILOT","Lot Number",,"^AUTTIML(",.BILINE,.BIERR,,11)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 ;
 ;
 ;---> Build Column Headers.
 N BICOL S BICOL="  Name                HRCN#     DOB"
 D
 .I BIFDT'=DT D  Q
 ..S BICOL=BICOL_" & Age on "_$$TXDT1^BIUTL5(BIFDT)_"  Current Community"
 .;"Age Today" vvv83
 .S BICOL=BICOL_"        Age Today  Sex Current Community"
 S BICOL=$$PAD^BIUTL5(BICOL,80)
 ;
 ;---> Set Column Headers for Listman.
 S:$D(VALMCAP) VALMCAP=BICOL
 ;
 ;---> If Header array is being built for Listmananger,
 ;---> reset display window margins for Communities, etc. and quit.
 I $D(VALM("BM")) D  Q
 .S VALM("TM")=BILINE+3
 .S VALM("LINES")=VALM("BM")-VALM("TM")+1
 .;---> Safeguard to prevent divide/0 error.
 .S:VALM("LINES")<1 VALM("LINES")=1
 ;
 ;---> If Header array is being built for a printout, write
 ;---> in the column headers.
 D WH^BIW(.BILINE,BICOL)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 S VALM("TITLE")=$$LMVER^BILOGO
 N BILINE,BI31,X S BILINE=0,BI31=$C(31)_$C(31)
 S:'$D(BINFO) BINFO(0)=0
 I '$D(BIPG) D ERRCD^BIUTL2(620,,1) S VALMQUIT="" Q
 ;
 ;
 ;---> Loop through ^TMP("BIDUL",$J,...,BIDFN) adding patients to list.
 ;---> Seed loops with -1 to pick up entries with a subscript of 0. Imm v8.5.
 N BIDFN,N,M,P
 S N=-1
 F  S N=$O(^TMP("BIDUL",$J,N)) Q:N=""  D
 .S M=-1
 .F  S M=$O(^TMP("BIDUL",$J,N,M)) Q:M=""  D
 ..S P=-1
 ..F  S P=$O(^TMP("BIDUL",$J,N,M,P)) Q:P=""  D
 ...N BIVAL1
 ...S BIDFN=0
 ...F  S BIDFN=$O(^TMP("BIDUL",$J,N,M,P,BIDFN)) Q:'BIDFN  S BIVAL1=^(BIDFN) D
 ....;---> BIVAL=0=All (no filter), 1=Rejects, 2=Appropriate.
 ....I $G(BIVAL) Q:BIVAL'=BIVAL1
 ....N N,M,P
 ....;---> Write line to ^TMP("BIDULV",$J,BILINE,0)=BIVAL global.
 ....D PATIENT^BIDUVLS2(.BILINE,BIDFN,.BINFO,$G(BIDASH),.BIMMRF,.BIMMLF)
 ;
 ;---> If no records were found to match, report it.
 D:'$G(BIT)
 .D WRITE^BIDUVLS2(.BILINE)
 .N X S X="     No Patient Records match the selected criteria."
 .D WRITE^BIDUVLS2(.BILINE,X)
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 D ZSAVES^BIUTL3
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT Q
 ;
 ;
 ;----------
PRINTVW ;EP
 ;---> Print Due List from View Screen.  (No queueing.)
 ;---> Called by Protocol BI DUE LIST VIEW PRINT from
 ;---> Menu Protocol BI MENU DUE LIST VIEW.
 ;
 D
 .N BIPOP W !?3,"Printout may not be queued at this point."
 .D ZIS^BIUTL2(.BIPOP)
 .Q:$G(BIPOP)
 .D PRTLST^BIUTL8("BIDULV")
 S VALMBCK="R"
 D RE^VALM4
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Use arrow keys to scroll up and down through the list, or"
 W !?5,"type ""??"" for more actions, such as Search and Print List."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> Cleanup, EOJ.
 K ^TMP("BIDULV",$J)
 Q
