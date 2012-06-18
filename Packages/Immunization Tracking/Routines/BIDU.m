BIDU ;IHS/CMI/MWR - DUE LIST/LETTERS, MAIN DRIVER; AUG 10,2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  LIST TEMPLATE CODE FOR DUE LISTS, VIEWING & PRINTING LETTERS.
 ;;  PATCH 1: Fix so that user's DUZ(0) is not always included  INIT+86
 ;
 ;----------
START ;EP
 ;---> Listman Screen for printing Immunization Due Letters.
 ;
 ;---> If Vaccine Table is not standard, display Error Text and quit.
 I $D(^BISITE(-1)) D ERRCD^BIUTL2(503,,1) Q
 ;
 D SETVARS^BIUTL5 N BIRTN
 N BINFO
 D ADDINFO
 D EN
 D EXIT,KILLALL^BIUTL8(1)
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for DUE LISTS & LETTERS.
 D EN^VALM("BI DUE LISTS & LETTERS")
 Q
 ;
 ;
 ;----------
HDR ;EP
 N BILINE,X,Y S BILINE=0 K VALMHDR
 D WH^BIW(.BILINE)
 S X=IOUON_"IMMUNIZATION LISTS & LETTERS" D CENTERT^BIUTL5(.X,42)
 D WH^BIW(.BILINE,X_IOINORM)
 ;D EN^VALM("BI DUE LISTS & LETTERS")
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;---> Variables set by this Init and reside in the local symbol table
 ;---> for use by other List Templates are defined as follows:
 ;---> Variables:
 ;     1 - BIAG   (req) Age Range^Mths/Yrs (See description in ^BIAGE.)
 ;     2 - BIPG   (req) Patient Group Data; see PGRPOUP1^BIOUTPT4 for details.
 ;     3 - BIFDT  (req) Forecast date.
 ;     4 - BICC   (req) Current Community array.
 ;     5 - BICM   (req) Case Manager array.
 ;     6 - BIMMR  (req) Immunizations Received array.
 ;     7 - BIMMD  (req) Immunizations Due array.
 ;     8 - BIHCF  (req) Health Care Facility array.
 ;     9 - BILOT  (req) Lot Number array.
 ;    10 - BIORD  (req) Order of listing.
 ;    11 - BINFO  (ret) Additional Information (not set here).
 ;    12 - BIRDT  (opt) Date Range for Received Imms (form BEGDATE:ENDDATE).
 ;    13 - BIDED  (opt) Include Deceased Patients (0=no, 1=yes).
 ;    14 - BIT    (ret) Total Patients retrieved (not set here).
 ;    15 - BIMD   (req) Minimum Interval days since last letter.
 ;    16 - BIDPRV (req) Designated Provider array.
 ;    17 - BIBEN  (req) Beneficiary Type array: either BIBEN(1) or BIBEN("ALL").
 ;
 ;---> NOTE: For programming work in any of the BIDU* routines,
 ;--->       it is helpful to printscreen the comments (from INIT here)
 ;--->       to use as a guide for the meaning of BI* variables.
 ;
 ;
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 K ^TMP("BIDU",$J)
 N BILINE,X S BILINE=0
 ;
 ;---> Date.
 S:'$G(BIFDT) BIFDT=DT
 D DATE^BIREP(.BILINE,"BIDU",1,$G(BIFDT),"Date of Forecast/Clinic",0,2,32)
 ;
 ;---> Age Range.
 S:$G(BIAG)="" BIAG="1-72"
 N BIAG1
 D
 .I +$G(BIPG)=8 S BIAG1="(set by Search Template)" Q
 .I BIAG="ALL" S BIAG1="All Ages" Q
 .S BIAG1=$$MTHYR^BIAGE(BIAG)
 S X="   2 - Age Range................: "_BIAG1
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Patient Group.
 N BIHEAD,BIPG1 S:'$G(BIPG) BIPG=3
 D PGRP(BIPG,.BIPG1)
 ;
 ;---> If Beneficiary is undefined, default to Am Indian/AK Native.
 S:'$D(BIBEN) BIBEN(1)=""
 S BIHEAD="   3 - Patient Group ("_$S($D(BIBEN("ALL")):"all)",1:"01).")_"......: "
 D
 .I $L(BIHEAD_BIPG1)<46 S X=BIHEAD_BIPG1 D WRITE(.BILINE,X) Q
 .N I,N,V,Z S N=1,V=",",X=""
 .F  D  Q:$P(BIPG1,V,I)=""  Q:$G(BIERR)
 ..F I=N:1 S X=$P(BIPG1,V,N,I) Q:$L(X)>46  Q:$P(BIPG1,V,I)=""
 ..I N>1 S BIHEAD=$$SP^BIUTL5(33)
 ..D WRITE(.BILINE,BIHEAD_$P(BIPG1,V,N,I-1))
 ..S N=I
 D WRITE(.BILINE)
 K X
 ;
 ;---> Current Community.
 D DISP^BIREP(.BILINE,"BIDU",.BICC,"Community",4,1,0,2,32)
 K X
 ;
 ;---> Case Manager.
 D DISP^BIREP(.BILINE,"BIDU",.BICM,"Case Manager",5,3,0,2,32)
 ;
 ;---> Designated Provider.
 D DISP^BIREP(.BILINE,"BIDU",.BIDPRV,"Designated Provider",6,3,0,2,32)
 ;
 ;---> Immunization Received.
 N A,B,C S A="Immunizations Received",B="Immunizations"
 ;---> C=Date Range of Received Imms (form BEGDATE:ENDDATE).
 I $G(BIRDT) S C=$$DATE(BIRDT,1)
 D DISP^BIREP(.BILINE,"BIDU",.BIMMR,A,7,6,0,2,32,B,$G(C)) K A,B,C
 ;
 ;---> Immunization Due.
 N A,B S A="Immunizations"_$S($P(BIPG,U)[2:" Past",1:"")_" Due",B="Immunizations"
 D DISP^BIREP(.BILINE,"BIDU",.BIMMD,A,8,6,0,2,32,B) K A,B
 ;
 ;---> Health Care Facility.
 N A,B S A="Health Care Facility",B="Facilities"
 ;
 ;********** PATCH 1, v8.4, AUG 01,2010, IHS/CMI/MWR
 ;---> Fix so that user's DUZ(0) is not always included
 ;S:$G(DUZ(2)) BIHCF(DUZ(2))=""
 I '$O(BIHCF(0)),$G(DUZ(2)) S BIHCF(DUZ(2))=""
 ;**********
 ;
 D DISP^BIREP(.BILINE,"BIDU",.BIHCF,A,9,2,0,2,32,B) K A,B
 ;
 ;---> Lot Number.
 D DISP^BIREP(.BILINE,"BIDU",.BILOT,"Lot Number",10,7,1,2,32)
 ;
 ;
 ;---> Additional Information.
 N BINFO1
 D
 .N BIHEAD S BIHEAD="  11 - Additional Information...: "
 .I $D(BINFO("ALL")) D WRITE(.BILINE,BIHEAD_"See list") Q
 .I $O(BINFO(0))="" D WRITE(.BILINE,BIHEAD_"None") Q
 .;
 .;---> Display selections.
 .N N S N=""
 .F  S N=$O(BINFO(N)) Q:'N  D
 ..Q:('$D(^BIADDIN(N,0)))
 ..S BINFO1=$G(BINFO1)_$S($G(BINFO1)]"":", ",1:"")_$P(^BIADDIN(N,0),U,3)
 .;
 .;---> Now write the pieces up to 46 characters wide.
 .N I,N,V,Z S N=1,V=",",X=""
 .F  D  Q:$P(BINFO1,V,I)=""
 ..F I=N:1 S X=$P(BINFO1,V,N,I) Q:$L(X)>46  Q:$P(BINFO1,V,I)=""
 ..I N>1 S BIHEAD=$$SP^BIUTL5(33)
 ..D WRITE(.BILINE,BIHEAD_$P(BINFO1,V,N,I-1))
 ..S N=I
 K X
 ;
 ;
 ;---> Order of Listing.
 S:'$G(BIORD) BIORD=1
 ;
 N X S X="Patient Age"
 S X=X_"^Patient Name (alphabetically)"
 S X=X_"^Patient Chart#"
 S X=X_"^Case Manager"
 S X=X_"^Case Manager, then Community"
 S X=X_"^Community, then Case Manager"
 S X=X_"^Community, then Patient Age"
 S X=X_"^Community, then Patient Name"
 S X=X_"^Community, then Patient Chart#"
 S X=X_"^Zipcode, then Patient Name"
 S X=X_"^Designated Provider"
 ;
 N BIORD1 S BIORD1="by "_$P(X,U,BIORD)
 S X="  12 - Order of Listing.........: "_BIORD1
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Include Deceased.
 N BIDED1 S BIDED1=""
 S:'$D(BIDED) BIDED=0
 S BIDED1=$S(BIDED:"Yes",1:"No")
 S X="  13 - Include Deceased.........: "_BIDED1
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE,BIRTN="BIDU"
 S:VALMCNT>16 VALMSG="Scroll down to view more Parameters. Type ?? help."
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIDU",$G(BIVAL),$G(BIBLNK))
 Q
 ;
 ;
 ;----------
PGRP(BIPG,BIPG1) ;EP
 ;---> Return text of Patient Group.
 ;---> Parameters:
 ;     1 - BIPG  (req) Patient Group Data; see PGRPOUP1^BIOUTPT4 for details.
 ;     2 - BIPG1 (ret) Value/text of line (Null=blank line).
 ;
 ;---> If BIPG=null, return unknown.
 I $G(BIPG)="" S BIPG1="Unknown" Q
 ;
 ;---> If BIPG="some text", simply return it.
 I +BIPG=0 S BIPG1=BIPG Q
 ;
 I $P(BIPG,U)=8 S BIPG1="Search Template: "_$P($G(^DIBT(+$P(BIPG,U,8),0)),U) Q
 ;
 N I,X S BIPG1=""
 S X="Due^Past Due^Active^Inactive^Auto-Activated^Refusals^Females Only^Search Template"
 F I=1,2,3,4,5,6,7,8 D
 .I $P(BIPG,U)[I S BIPG1=$G(BIPG1)_$S(BIPG1]"":", ",1:"")_$P(X,U,I)
 .;---> If 2 - Past Due, add "months Past Due".
 .I I=2,$P(BIPG,U)[2,$P(BIPG,U,2) S BIPG1=BIPG1_" ("_$P(BIPG,U,2)_" mths)" Q
 .I I=4,$P(BIPG,U)[4,($P(BIPG,U,4)]"") S BIPG1=BIPG1_$$DATE(BIPG,4)
 .I I=5,$P(BIPG,U)[5,($P(BIPG,U,5)]"") S BIPG1=BIPG1_$$DATE(BIPG,5)
 Q
 ;
 ;
 ;----------
DATE(BIPG,BIGRP) ;EP
 ;---> Return external form of date for Group Date Range in slash format.
 ;---> Parameters:
 ;     1 - BIPG  (req) Patient Group Data; see PGRPOUP1^BIOUTPT4 for details.
 ;     2 - BIGRP (req) Patient Group.
 ;
 Q:'$G(BIPG) "NO DATE"  Q:'$G(BIGRP) "NO DATE"
 N BIX,BIY,BIZ S BIX=""
 S BIY=$P($P(BIPG,U,BIGRP),":",1)
 S BIZ=$P($P(BIPG,U,BIGRP),":",2)
 ;
 ;---> If dates are default (1/1/1900 and TODAY), don't display date range.
 Q:(BIY=2000101&(BIZ=$G(DT))) BIX
 ;
 S BIX=" ("_$$SLDT2^BIUTL5(BIY)_" to "
 S BIX=BIX_$$SLDT2^BIUTL5(BIZ)_")"
 Q BIX
 ;
 ;
 ;----------
ADDINFO ;EP
 ;---> BIDUZF=User-File# identifier to store and retrieve
 ;---> previous lists of selections from this file.
 N BIDUZF S BIDUZF=+$G(DUZ)_"-"_9002084.82
 ;
 I $D(^BISELECT("B",BIDUZF)) D
 .N BIDA S BIDA=$O(^BISELECT("B",BIDUZF,0))
 .Q:'BIDA  Q:$G(^BISELECT(BIDA,0))=""
 .Q:'$O(^BISELECT(BIDA,1,0))
 .N Y S Y=0
 .F  S Y=$O(^BISELECT(BIDA,1,Y)) Q:Y=""  D
 ..S BINFO(Y)=""
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
EXIT ;EP
 ;---> EOJ cleanup.
 K ^TMP("BIDU",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
