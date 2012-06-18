BIEXP1 ;IHS/CMI/MWR - EXPORT IMMUNIZATION RECORDS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXPORT IMMUNIZATION RECORDS: SELECT BY INDIVIDUAL PATIENTS.
 ;
 ;
 ;----------
START ;EP
 ;---> Listman Screen for selecting Export Parameters, by Individual.
 ;
 D SETVARS^BIUTL5
 ;---> Main entry point for Export by Individual Patients.
 D EN^VALM("BI EXPORT BY INDIVIDUALS")
 D EXIT
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 S BIPG=9,BIAG="",BIHCF("ALL")="",BICC("ALL")=""
 ;
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X S BILINE=0
 D WRITE(.BILINE)
 S X=IOUON_"EXPORT DATA BY INDIVIDUALS" D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM)
 K X
 ;
 ;---> Survey Date.
 D WRITE(.BILINE,,1)
 S:'$G(BISVDT) BISVDT=DT
 S X="     1 - Survey Date..............: "_$$TXDT1^BIUTL5(BISVDT)
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Patients, individuals.
 N BII,BIPAT1 S BII=0,BIPAT1=""
 D
 .I '$D(BIPAT) S BIPAT1="None" Q
 .I $D(BIPAT("ALL")) S BIPAT1="ALL" Q
 .N M,N
 .S N=0
 .F BII=0:1 S N=$O(BIPAT(N)) Q:'N  S M=N
 .I BII=1 S BIPAT1=$$NAME^BIUTL1(M) Q
 .S BIPAT1="List (Select ""2"" to review list.)"
 S X="     2 - Patient"_$S(BII=1:".",1:"s")
 S X=X_".................: "_BIPAT1
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Immunizations Received.
 N BIMMR1 S BIMMR1=""
 D
 .S:'$D(BIMMR) BIMMR("ALL")=""
 .I $D(BIMMR("ALL")) S BIMMR1="ALL" Q
 .N I,M,N
 .S N=0
 .F I=0:1 S N=$O(BIMMR(N)) Q:'N  S M=N
 .I I=1 S BIMMR1=$$VNAME^BIUTL2(M) Q
 .S BIMMR1="List (Select ""3"" to review list.)"
 S X="     3 - Immunizations Received...: "_BIMMR1
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Data Elements.
 N BIDE1 S BIDE1=""
 D
 .I '$D(BIDE) S BIDE1="None" Q
 .I $D(BIDE("ALL")) S BIDE1="ALL" Q
 .N I,M,N
 .S N=0
 .F I=0:1 S N=$O(BIDE(N)) Q:'N  S M=N
 .I I=1 S BIDE1=$$DETX^BIUTL6(M) Q
 .S BIDE1="List (Select ""4"" to review list.)"
 S X="     4 - Data Elements............: "_BIDE1
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> File Format (1=ASCII,2=HL7,3=ImmServe).
 S:'$G(BIFMT) BIFMT=1
 N BIFMT1
 S BIFMT1=$S(BIFMT=2:"HL7",BIFMT=3:"ImmServe",1:"ASCII")
 S X="     5 - File Format..............: "_BIFMT1
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Output.
 D
 .I '$G(BIOUT) S BIOUT=0,BIFLNM="" Q
 .I $G(BIFLNM)="" S BIOUT=0
 N BIOUT1
 S BIOUT1=$S(BIOUT:"File: "_$G(BIPATH)_BIFLNM,1:"SCREEN")
 S X="     6 - Output Device............: "_BIOUT1
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 S BIRTN="BIEXP1"
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
 D WL^BIW(.BILINE,"BIEXP1",$G(BIVAL),$G(BIBLNK))
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
HELP ;EP
 ;---> Help code.
 D FULL^VALM1 N BIPOP
 D TITLE^BIUTL5("EXPORT DATA BY INDIVIDUALS - HELP, page 1 of 2")
 D TEXT1,DIRZ^BIUTL3(.BIPOP)
 I $G(BIPOP) D RESET Q
 D TITLE^BIUTL5("EXPORT DATA BY INDIVIDUALS - HELP, page 2 of 2")
 D TEXT2,DIRZ^BIUTL3()
 D RESET
 Q
 ;
 ;
 ;----------
TEXT1 ;
 ;;The EXPORT DATA BY INDIVIDUALS screen provides a menu of options
 ;;for exporting the data of individual patients.
 ;;
 ;;There are 6 items or "parameters" on the screen that you may
 ;;change in order to specify which patients and which data will be
 ;;exported, as well as the output device for the export.
 ;;
 ;;To change an item, enter its left column number (1-6) at the
 ;;prompt on the bottom of the screen.  Use "?" at any prompt where
 ;;you would like help or more information on the parameter you are
 ;;changing.
 ;;
 ;;Once you have the parameters set to retrieve the patients and data
 ;;you want, select E to Export the data.
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;SURVEY DATE: A past or prsent date, after which immunizations
 ;;will not be included in the export.
 ;;
 ;;PATIENTS: Select the patients whose data you wish to export.
 ;;
 ;;VACCINES: If you select for specific Vaccines, only immunizations
 ;;given with the selected vaccines will be included in the export.
 ;;
 ;;DATE ELEMENTS: Select the group of Data Elements you wish to export
 ;;for each immunization.
 ;;
 ;;FILE FORMAT and OUTPUT DEVICE: Detailed help will be given when
 ;;you select these items.
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
TEXT3 ;
 ;;                              NOTE
 ;;                             ------
 ;;
 ;;The Quarterly Immunization Report may contain some patients who
 ;;were ACTIVE prior to the Quarter Ending Date you selected, but who
 ;;are now INACTIVE.
 ;;
 ;;The Due List you are about to view will contain only ACTIVE patients
 ;;unless you specify otherwise.
 ;;
 ;;
 ;;
 ;;
 ;;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> EOJ cleanup.
 K ^TMP("BIEXP1",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
