BIOUTPT2 ;IHS/CMI/MWR - PROMPTS FOR REPORTS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PROMPTS FOR REPORT PARAMETERS.
 ;
 ;
 ;----------
SVDATE(BISVDT,BIPG,BIRTN) ;EP
 ;---> Select Survey Date.  Called by Protocol BI EXPORT SURVEY DATE.
 ;---> Parameters:
 ;     1 - BISVDT (ret) Survey Date, Fileman format.
 ;                (opt) Default Date.
 ;     2 - BIPG   (req) Patient Group being surveyed.
 ;     3 - BIRTN  (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 I $G(BIPG)="" D ERRCD^BIUTL2(639,,1),@("RESET^"_BIRTN) Q
 ;
 ;
SVDATE1 ;EP
 S:$G(BISVDT)="" BISVDT=DT
 N BIDFLT,DIR S BIDFLT=$$TXDT^BIUTL5(BISVDT)
 S DIR(0)="DA^::PEX"
 S DIR("A")="     Please enter a Survey Date: ",DIR("B")=BIDFLT
 D FULL^VALM1
 D TITLE^BIUTL5("SELECT SURVEY DATE")
 D TEXT1 D:BIPG'=9 TEXT2,HELP2
 D ^DIR W !
 I $D(DIRUT) D RESET^BIDU Q
 S BISVDT=$P(Y,".")
 I BISVDT>DT D  G SVDATE1
 .W !?5,"The date may not be in the future.  "
 .W "It must be today or in the past."
 .K BISVDT D DIRZ^BIUTL3()
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;Please select a Survey Date (no future dates).
 ;;
 ;;If the Survey Date is in the past, patient age(s) will be calculated
 ;;for that date, and immunizations given after that Survey Date will
 ;;not be included.
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;If you specify Age Range or Active Status, these will be calculated
 ;;based on the Survey Date you select here.
 ;;
 ;;If you specify a Patient Group based on visits, only visits up to
 ;;and including the Survey Date will be examined.
 ;;
 ;;Enter a "?" for further explanation.
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
HELP2 ;EP
 ;;If you select a specific Age Range and a Survey Date in the past,
 ;;only patients whose ages fell within the Age Range on Survey Date
 ;;will be included in the export.
 ;;
 ;;If you select a group of patients based on Active Status, only
 ;;those patients who were Active on the Survey Date will be included.
 ;;Patients who became Inactive prior to the Survey Date will not be
 ;;included.
 ;;
 ;;If you select for all patients who have had immunizations, only
 ;;patients who have had immunizations on or before the Survey Date
 ;;will be included.
 D HELPTX("HELP2")
 Q
 ;
 ;
 ;----------
PATIENT(BIPAT,BIRTN) ;EP
 ;---> Select Patient.  Called by Protocol BI EXPORT PATIENT.
 ;---> Parameters:
 ;     1 - BIPAT (ret) Local array of Patient DFNs.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Select one or more Patients.
 ;---> Display Identifiers: Sex, DOB, Chart#.
 N BIID S BIID="2;S X=$P(BI0,U,2)_""  ""_$$DOBF^BIUTL1(BIIEN,,1)"
 S BIID=BIID_"_""  ""_$$HRCN^BIUTL1(BIIEN,$G(DUZ(2)));40"
 N BIABBR S BIABBR=$$LOCABBR^BIUTL6($G(DUZ(2)))
 S:BIABBR="" BIABBR=$E($$INSTTX^BIUTL6($G(DUZ(2))),1,11)
 N BICOL S BICOL="    #  Patient                          Sex  DOB"
 S BICOL=BICOL_"          Chart# at "_BIABBR
 D SEL^BISELECT(9000001,"BIPAT","Patient",,,,BIID,BICOL,.BIPOP,1)
 I $D(BIPAT("ALL")) D  Q
 .D FULL^VALM1,TITLE^BIUTL5("SELECTING PATIENTS"),TEXT7
 .K BIPAT D DIRZ^BIUTL3()
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT7 ;EP
 ;;
 ;;You have selected ALL patients.  In order to work with a group of
 ;;this size, other information is needed (such as Active Status, Age
 ;;Range, Communities, etc.).
 ;;
 ;;Please begin this export process again.  The very first question
 ;;asks if you wish to select patients INDIVIDUALLY or by GROUP.
 ;;Choose "2) Select patients by GROUP", and proceed from there.
 ;;
 D PRINTX("TEXT7")
 Q
 ;
 ;
 ;----------
DATAEL(BIDE,BIRTN) ;EP
 ;---> Select Data Elements.
 ;---> Called by Protocol BI OUTPUT DATA ELEMENTS.
 ;---> Parameters:
 ;     1 - BIDE  (ret) Local array of Lot Number IENs.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1 N BIPOP
 D TITLE^BIUTL5("SELECT DATA ELEMENTS"),TEXT3
 D DIRZ^BIUTL3(.BIPOP)
 I $G(BIPOP) D @("RESET^"_BIRTN) Q
 ;
 ;---> Screen: only Data Elements for Immunizations or All.
 N BIIT S BIIT="Data Element"
 N BISCR S BISCR="I ""AI""[$P(^BIEXPDD(Y,0),U,4)"
 N BICOL S BICOL="    #  Data Element                       Synonym"
 D SEL^BISELECT(9002084.91,"BIDE",BIIT,BISCR,,,"3;;40",BICOL,.BIPOP,1)
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;
 ;;                               NOTES
 ;;                              -------
 ;;Data Element selection only pertains to exports with ASCII Format.
 ;;(ImmServe Data Elements are predetermined.)
 ;;
 ;;The very first (or top) record will list, by title, the selected
 ;;Data Elements in the order in which they occur in the following
 ;;records.
 ;;
 D PRINTX("TEXT3")
 Q
 ;;(HL7 and ImmServe Data Elements are predetermined.)
 ;;
 ;;If you intend to export in HL7 or ImmServe formats, disregard this
 ;;Data Element selection.
 Q
 ;
 ;
 ;----------
FORMAT(BIFMT,BIRTN) ;EP
 ;---> Select Format for record export.
 ;---> Called by Protocol BI EXPORT FORMAT.
 ;---> Parameters:
 ;     1 - BIFMT (ret) File Format (1=ASCII,2=HL7,3=ImmServe).
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("SELECT EXPORT FORMAT"),TEXT4
 N Y S:'$G(BIFMT) BIFMT=1
 S A="     Please select a Format: "
 ;
 ;---> Remove HL7, at least for now.
 ;D DIR^BIFMAN("SM^1:ASCII;2:HL7;3:ImmServe",.Y,.BIPOP,A,"ASCII")
 D DIR^BIFMAN("SM^1:ASCII;3:ImmServe",.Y,.BIPOP,A,"ASCII")
 S:Y BIFMT=Y
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT4 ;EP
 ;;You may export records in either ASCII or ImmServe format.
 ;;
 ;;ASCII format will produce the Data Elements you specify for each
 ;;immunization on a separate line or record.  Data Elements will be
 ;;separated by quote-comma-quote (known as a CSV file).
 ;;
 ;;ImmServe is a commercial, vendor-specific format of use only to
 ;;programmers working with this software.
 D PRINTX("TEXT4")
 Q
 ;;---> Removed from above, for now at least.
 ;;HL7 will produce Immunization records according to the HL7 standard.
 ;
 ;
 ;----------
OUTPUT(BIOUT,BIFLNM,BIPATH,BIRTN) ;EP
 ;---> Select Output Device for Export Data.
 ;---> Called by Protocol BI EXPORT OUTPUT DEVICE.
 ;---> Parameters:
 ;     1 - BIOUT  (ret) 0=Screen, 1=File.
 ;     2 - BIFLNM (ret) File name given by the user.
 ;     3 - BIPATH (ret) Path name set in Site Parameters.
 ;     4 - BIRTN  (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("SELECT OUTPUT DEVICE"),TEXT5
 N BIPOP,Y S:'$D(BIOUT) BIOUT=0
 ;
 N A,B S A="   Select SCREEN or FILE: "
 S B=$S(BIOUT:"FILE",1:"SCREEN")
 D DIR^BIFMAN("SAM^0:SCREEN;1:FILE",.Y,.BIPOP,A,B)
 ;
 ;---> If user chose Screen, or ^out, quit.
 S BIOUT=Y
 I 'BIOUT!($G(BIPOP)) D @("RESET^"_BIRTN) Q
 ;
 ;---> Enter file name, if required.
 D TITLE^BIUTL5("ENTER OUTPUT FILE NAME")
 F  D  Q:BIPOP  Q:BIFLNM]""
 .N Q,Z D TEXT6
 .S Q="     Contact your site manager for assistance."
 .S Z="     Enter the file name without any path "
 .S Z=Z_"--just the file name itself."
 .D DIR^BIFMAN("FA",.BIFLNM,.BIPOP,"   Enter file name: ","",Q,Z)
 .Q:BIPOP
 .I BIFLNM["\"!(BIFLNM["/")!(BIFLNM[":")!(BIFLNM[";")!(BIFLNM[" ") D
 ..W !!?5,"File name must not contain ""\"", ""/"", "":"" or spaces."
 ..S BIFLNM=""
 ;
 ;---> Quit if user up-arrowed out.
 I BIFLNM["^" S BIFLNM="" D @("RESET^"_BIRTN) Q
 ;
 ;---> Return path, open Host File and test access and close it.
 D HFS^BIEXPRT8(BIFLNM,.BIPATH,0,.BIPOP)
 I $G(BIPOP) D @("RESET^"_BIRTN) Q
 ;
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT5 ;EP
 ;;There are two methods of exporting the data.
 ;;
 ;;You may either:
 ;;
 ;; * Select SCREEN to send the data to your screen.  If you are using
 ;;   a PC, this method will allow you to capture the output of data to
 ;;   your screen and then save it as a file.  However, you must refer
 ;;   to your PC software documentation for help with this procedure.
 ;;or
 ;;
 ;; * Select FILE, to send the exported data to a host file.
 ;;   If your data is sent to a host file, it can then be copied to
 ;;   a floppy or transmitted to another computer for processing.
 ;;   See your sitemanager for help with this procedure.
 ;;
 D PRINTX("TEXT5")
 Q
 ;
 ;
 ;----------
TEXT6 ;EP
 ;;
 ;;Enter a name for the file you are exporting.  The file name must
 ;;conform the filenaming conventions of your operating system.
 ;;Do not include any slashes, colons, or spaces in the file name.
 ;;
 ;;The Export File will have a path name prepended to the filename you
 ;;enter here.  The path is set in the Site Parameters (MGR-->ESP) by
 ;;your Site Manager or Package Manager.
 ;;
 D PRINTX("TEXT6")
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
HELPTX(BILINL,BITAB) ;EP
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
