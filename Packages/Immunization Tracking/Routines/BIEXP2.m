BIEXP2 ;IHS/CMI/MWR - EXPORT IMMUNIZATION RECORDS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXPORT IMMUNIZATION RECORDS: SELECT PATIENTS BY GROUP.
 ;
 ;
 ;----------
START ;EP
 ;---> Listman Screen for selecting Export Parameters, by Group.
 ;
 D SETVARS^BIUTL5
 ;---> Main entry point for Export by Individual Patients.
 D EN^VALM("BI EXPORT BY GROUP")
 D EXIT
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X S BILINE=0
 D WRITE(.BILINE)
 S X=IOUON_"EXPORT DATA BY GROUP" D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM,1)
 K X
 ;
 ;---> Survey Date.
 S:'$G(BISVDT) BISVDT=DT
 S X="     1 - Survey Date..............: "_$$TXDT1^BIUTL5(BISVDT)
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Age Range.
 S:$G(BIAG)="" BIAG="1-72"
 N BIAG1
 D
 .I BIAG="ALL" S BIAG1="All Ages" Q
 .S BIAG1=$$MTHYR^BIAGE(BIAG)
 S X="     2 - Age Range................: "_BIAG1
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;
 ;---> Patient Group.
 S:('$G(BIPG)!($G(BIPG)=9)) BIPG=1 N X
 D
 .I BIPG=1 S X="ACTIVE in the Register." Q
 .I BIPG=2 S X="BOTH Active and Inactive." Q
 .I BIPG=3 S X="ALL who have had an Immunization." Q
 .I BIPG=4 S X="ALL who have had a Visit of any kind." Q
 .I BIPG=5 S X="ALL Patients (including those w/o a Visit)." Q
 .S X="Make a selection." Q
 S X="     3 - Patient Group............: "_X
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Health Care Facility.
 N BIHCF1 S BIHCF1=""
 D
 .S:'$D(BIHCF) BIHCF("ALL")=""
 .I $D(BIHCF("ALL")) S BIHCF1="ALL" Q
 .N I,M,N
 .S N=0
 .F I=0:1 S N=$O(BIHCF(N)) Q:'N  S M=N
 .I I=1 S BIHCF1=$$INSTTX^BIUTL6(M) Q
 .S BIHCF1="List (Select ""4"" to review list.)"
 S X="     4 - Health Care Facility.....: "_BIHCF1
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Current Community.
 N BICC1 S BICC1=""
 D
 .S:'$D(BICC) BICC("ALL")=""
 .I $D(BICC("ALL")) S BICC1="ALL" Q
 .N I,M,N
 .S N=0
 .F I=0:1 S N=$O(BICC(N)) Q:'N  S M=N
 .I I=1 S BICC1=$$CCTX^BIUTL6(M) Q
 .S BICC1="List (Select ""5"" to review list.)"
 S X="     5 - Community................: "_BICC1
 D WRITE(.BILINE,X)
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
 .S BIMMR1="List (Select ""6"" to review list.)"
 S X="     6 - Immunizations Received...: "_BIMMR1
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
 .S BIDE1="List (Select ""7"" to review list.)"
 S X="     7 - Data Elements............: "_BIDE1
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> File Format (1=ASCII,2=HL7,3=ImmServe).
 S:'$G(BIFMT) BIFMT=1
 N BIFMT1
 S BIFMT1=$S(BIFMT=2:"HL7",BIFMT=3:"ImmServe",1:"ASCII")
 S X="     8 - File Format..............: "_BIFMT1
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Output.
 D
 .I '$G(BIOUT) S BIOUT=0,BIFLNM="" Q
 .I $G(BIFLNM)="" S BIOUT=0
 N BIOUT1
 S BIOUT1=$S(BIOUT:"File: "_$G(BIPATH)_BIFLNM,1:"SCREEN")
 S X="     9 - Output Device............: "_BIOUT1
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 S BIRTN="BIEXP2"
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
 D WL^BIW(.BILINE,"BIEXP2",$G(BIVAL),$G(BIBLNK))
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
 D TITLE^BIUTL5("EXPORT DATA BY GROUP - HELP, page 1 of 2")
 D TEXT1,DIRZ^BIUTL3(.BIPOP)
 I $G(BIPOP) D RESET Q
 D TITLE^BIUTL5("EXPORT DATA BY GROUP - HELP, page 2 of 2")
 D TEXT2,DIRZ^BIUTL3()
 D RESET
 Q
 ;
 ;
 ;----------
TEXT1 ;
 ;;The EXPORT DATA BY GROUP screen provides a menu of options for
 ;;exporting the data of groups of patients.
 ;;
 ;;There are 8 items or "parameters" on the screen that you may
 ;;change in order to specify which patients and which data will be
 ;;exported, as well as the output device for the export.
 ;;
 ;;To change an item, enter its left column number (1-8) at the
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
 ;;COMMUNITIES: If you select for specific Communities, only patients
 ;;whose Current Community (under Patient Registration) is one of the
 ;;selected Communities will be included in the export.
 ;;
 ;;HEALTH CARE FACILITIES: If you select for specific Health Care
 ;;Facilities, only patients who have had AT LEAST ONE immunization
 ;;at one of the selected Health Care Facilities will be included in
 ;;the export.
 ;;
 ;;VACCINES: If you select for specific Vaccines, only immunizations
 ;;given with the selected vaccines will be included in the export.
 ;;
 ;;DATE ELEMENTS: Select the group of Data Elements you wish to export
 ;;for each immunization.
 ;;
 ;;SURVEY DATE, PATIENT GROUP, FILE FORMAT and OUTPUT DEVICE:
 ;;Detailed help will be given when you select these items.
 D PRINTX("TEXT2")
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
 K ^TMP("BIEXP2",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
