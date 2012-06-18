BIVGRP1 ;IHS/CMI/MWR - EDIT VACCINES.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT VACCINE FIELDS: CURRENT LOT, ACTIVE, VIS DATE DEFAULT.
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;
 S VALMSG="Enter ""C"" to Change a Vaccine Group."
 S VALM("TITLE")=" Immunization v"_$$VER^BILOGO
 ;
 ;---> Build Listmanager array.
 K ^TMP("BIVGRP",$J),BIVAC
 ;
 N BILINE,BIENT,BIN,BIVAC1,I
 S BILINE=0,BIENT=0,BIN=0
 S BIXREF="B"
 ;
 F  S BIN=$O(^BISERT(BIXREF,BIN)) Q:BIN=""  D
 .N BI0,BIIEN,X,Y
 .S BIIEN=$O(^BISERT(BIXREF,BIN,0))
 .Q:$D(BIVAC1(BIIEN))
 .S BIVAC1(BIIEN)="",BI0=^BISERT(BIIEN,0)
 .;--->Quit if this group should not be displayed.
 .Q:'$P(BI0,U,6)
 .;
 .;---> Set Item# and build Item# array=IEN of Vaccine.
 .S BIENT=BIENT+1,BIVAC(BIENT)=BIIEN
 .;
 .;---> Item#.
 .S X="   "_$S(BIENT<10:" "_BIENT,1:BIENT)
 .;
 .;---> Vaccine (Short) Name.
 .S X=X_"  "_$P(BI0,U)
 .S X=$$PAD^BIUTL5(X,24,".")
 .;
 .;---> Forecast Exclude/Include.
 .S X=X_$S($P(BI0,U,5):"YES",1:"NO")
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
 D WL^BIW(.BILINE,"BIVGRP",$G(BIVAL),$G(BIBLNK),$G(BIENT))
 Q
 ;
 ;
 ;----------
EDIT ;EP
 ;---> Edit a Vaccine.
 ;---> Call the Listmanager Generic Selector of items displayed.
 N VALMY
 D EN^VALM2(XQORNOD(0),"OS")
 ;
 ;---> Check that a Listman Item was passed.
 I '$D(VALMY) D ERRCD^BIUTL2(406,,1) D RESET Q
 ;---> Now set Y=Item# selected from the list.
 N Y S Y=$O(VALMY(0))
 I '$G(Y) D ERRCD^BIUTL2(406,,1) D RESET Q
 I $G(BIVAC(Y))="" D ERRCD^BIUTL2(510,,1) D RESET Q
 N BIDA S BIDA=+BIVAC(Y)
 I $G(^BISERT(BIDA,0))="" D ERRCD^BIUTL2(510,,1) D RESET Q
 ;
 ;---> Save previous setting of Forecast Yes/No (0=YES,1=NO).
 N BIFORC S BIFORC=$P(^BISERT(BIDA,0),U,5)
 D
 .I BIFORC=1 S $P(^BISERT(BIDA,0),U,5)=0 Q
 .S $P(^BISERT(BIDA,0),U,5)=1
 D RESET
 Q
 ;
 ;
 ;----------
DISPLAY ;EP
 I $G(BIPOP) D FULL^VALM1,RESET Q
 ;
 ;---> *** THE FOLLOWING CODE COULD BE USED TO DISPLAY WHICH VACCINES ARE
 ;--->     AFFECTED BY TURNING ON/OFF A VACCINE GROUP.  NOT USED FOR NOW. ***
 D
 .Q
 .;
 .N BINF D CONTRHL7^BIUTL11(BIDA,.BINF)
 .Q:'$D(BINF)
 .;
 .N N,BIHDR S N=0
 .F  S N=$O(BINF(N)) Q:'N  D
 ..N BIIEN S BIIEN=$$HL7TX^BIUTL2(N)
 ..Q:'BIIEN
 ..Q:BIIEN=BIDA
 ..D:'$G(BIHDR)  S BIHDR=1
 ...W !!?5,"The following related Vaccines will also change:"
 ...W !!?5,"VACCINE        FORECAST",!?5,"-----------------------"
 ..S $P(^AUTTIMM(BIIEN,0),U,16)=BIFORC1
 ..W !?5,$$VNAME^BIUTL2(BIIEN),?20,$S(BIFORC1:"NO",1:"YES")
 ;
 D DIRZ^BIUTL3()
 D FULL^VALM1
 D RESET
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT^BIVGRP,HDR^BIVGRP()
 Q
