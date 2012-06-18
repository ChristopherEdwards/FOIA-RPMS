BIOUTPT1 ;IHS/CMI/MWR - PROMPTS FOR REPORTS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PROMPTS FOR REPORTS.
 ;
 ;
 ;----------
ORDER(BIORD) ;EP
 ;---> Select Order by which list will be sorted.
 ;---> Called by Protocol BI OUTPUT ORDER.
 ;---> Parameters:
 ;     1 - BIORD (ret) Order by which list will be sorted.
 ;
 ;---> Select Order of sort.
 S:'$G(BIORD) BIORD=1
 D FULL^VALM1
 D TITLE^BIUTL5("SELECT ORDER")
 N DIR
 W !!?3,"Select the Order by which patients should sorted.",!
 W !?5,"1     Patient Age"
 W !?5,"2     Patient Name (alphabetically)"
 W !?5,"3     Patient Chart#"
 W !?5,"4     Case Manager"
 W !?5,"5     Case Manager, then Community"
 W !?5,"6     Community, then Case Manager"
 W !?5,"7     Community, then Patient Age"
 W !?5,"8     Community, then Patient Name"
 W !?5,"9     Community, then Patient Chart#"
 W !?4,"10     Zipcode, then Patient Name"
 W !?4,"11     Designated Provider",!
 N X S X="SAM^1:Patient Age"
 S X=X_";2:Patient Name (alphabetically)"
 S X=X_";3:Patient Chart#"
 S X=X_";4:Case Manager"
 S X=X_";5:Case Manager, then Community"
 S X=X_";6:Community, then Case Manager"
 S X=X_";7:Community, then Patient Age"
 S X=X_";8:Community, then Patient Name"
 S X=X_";9:Community, then Patient Chart#"
 S X=X_";10:Zipcode, then Patient Name"
 S X=X_";11:Designated Provider"
 ;S DIR("B")=$P($P(X,BIORD_":",2),";")
 S DIR("A")="   Select Order: "
 S DIR("B")=BIORD
 S DIR(0)=X K X S DIR("?")="^D ORDERH^BIOUTPT1"
 D ^DIR
 S:+Y>0 BIORD=+Y
 D RESET^BIDU
 Q
 ;
 ;
 ;----------
ORDERH ;EP
 ;---> Help for Select Order prompt.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("SELECT ORDER - HELP",.BITEXT)
 D FULL^VALM1,TITLE^BIUTL5("SELECT ORDER")
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;You may select the order by which patients will sorted in this list.
 ;;
 ;;* Patient Age - will list patients in order of increasing age.
 ;;
 ;;* Patient Name - will list patients by "LAST NAME, FIRST NAME"
 ;;     alphabetically.
 ;;
 ;;* Patient Chart# - will list patients by increasing Chart# (Health
 ;;     Record Number).
 ;;
 ;;* Case Manager - will list patients grouped by Case Manager (and then
 ;;     by Patient Name alphabetically under each Case Manager).
 ;;
 ;;* Case Manager, then Community - will list patients grouped first by
 ;;     Case Manager and then by Community.
 ;;
 ;;* Community, then Case Manager - will list patients grouped first by
 ;;     Community and then by Case Manager.
 ;;
 ;;* Community, then Patient Age - will list patients grouped first by
 ;;     Community and then by Patient Age.
 ;;
 ;;* Community, then Patient Name - will list patients grouped first by
 ;;     Community and then by Patient Name.
 ;;
 ;;* Community, then Patient Chart# - will list patients grouped first
 ;;     by Community and then by Patient Chart#.
 ;;
 ;;* Zipcode, then Patient Name - will begin with lowest zipcodes first.
 ;;
 ;;* Designated Provider - will list patients grouped by Designated Provider
 ;;     (and then by Patient Name alphabetically).
 ;;
 ;;Select the number (1-10) to indicate the order in which you wish to
 ;;have patients listed.
 ;;
 D LOADTX("TEXT1",,.BITEXT)
 Q
 ;
 ;
 ;----------
ADDINFO(BINFO) ;EP
 ;---> Select Additional Information to be included in Due List.
 ;---> Called by Protocol BI OUTPUT ADDITIONAL INFO.
 ;---> Parameters:
 ;     1 - BINFO (ret) Array of Additional Information Items.
 ;
 ;---> NOTE: Sending BINONE=1 param tells BISELECT that NO Items selected
 ;---> means "None" not "ALL." v8.4
 ;
 N BINAM S BINAM="Information Item"
 N BICOL S BICOL="    #  Information Item"
 D SEL^BISELECT(9002084.82,"BINFO",BINAM,,13,,,BICOL,,1)
 D RESET^BIDU
 Q
 ;
 ;
 ;----------
TEXT6 ;EP
 ;;Please select any Items of Additional Patient Information you wish to
 ;;be included in this Patient List by entering the corresponding number(s).
 ;;
 ;;   * To include more than one Item, separate the numbers with commas.
 ;;     Example: 1,2,6  would be Phone Number, Address, and Directions.
 ;;
 ;;     0     No Additional Information
 ;;     1     Phone Number
 ;;     2     Address
 ;;     3     Immunization History
 ;;     4     Immunization History w/Lot#'s
 ;;     5     Immunization Forecast
 ;;     6     Directions to House
 ;;     7     Parent/Guardian
 ;;     8     Case Manager
 ;;     9     Reason Inactivated
 ;;    10     Skin Tests
 ;;    11     Next Appointment (RPMS Scheduling)
 ;;
 D PRINTX("TEXT6")
 Q
 ;
 ;
 ;----------
ADDHELP ;EP
 ;----> Explanation of this report.
 N BITEXT D TEXT7(.BITEXT)
 D START^BIHELP("ADDITIONAL INFORMATION - HELP",.BITEXT)
 D FULL^VALM1,TITLE^BIUTL5("ADDITIONAL INFORMATION"),TEXT6
 Q
 ;
 ;
 ;----------
TEXT7(BITEXT) ;EP
 ;;You may select additional Items of Patient Information to be
 ;;included in the display or printout of this Patient List.
 ;;(This selection does not pertain to the printing of Letters.)
 ;;
 ;;Any combination of Items may be selected by entering the
 ;;corresponding numbers, separated by commas.  Items may also
 ;;be selected inclusively by using a "-" dash.  For example, 1-5
 ;;will include items 1,2,3,4,and 5.
 ;;
 ;;"Directions to House", Item 6, refers to the physical "Location of
 ;;Patient's Home", as edited on Page 9 of Patient Registration.
 ;;
 ;;"Parent/Guardian", Item 7, refers to the patient's parent or guardian
 ;;AS LISTED under "Additional Patient Information" of the Patient View
 ;;in Immunization.
 ;;(NOTE: This is not necessarily the same as the "Father's Name" or
 ;;"Mother's Maiden Name" as listed in the RPMS Patient Registration
 ;;module.)
 ;;
 ;;"Next Appointment", Item 11, refers to the patient's next appointment,
 ;;*if* the RPMS Scheduling package is in use on this system and
 ;;*if* the patient has a future appointment scheduled.
 ;;
 ;;Also note that "Current Community" will automatically appear in the
 ;;right-most column of the Due List when it displays or print.
 ;;"Current Community" here refers to Page 1 (Field# 8) of Patient
 ;;Registration.
 ;;
 D LOADTX("TEXT7",,.BITEXT)
 Q
 ;
 ;
 ;----------
INCLDEC(BIDED,BIRTN) ;EP
 ;---> Answer Yes/No to include CPT Coded Visits in report.
 ;---> Called by Protocol BI OUTPUT INCLUDE CPT.
 ;---> Parameters:
 ;     1 - BICPT  (ret) 1=YES, 0=NO.
 ;     2 - BIRTN  (ret) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("INCLUDE DECEASED PATIENTS IN LIST/REPORT")
 D TEXT2 W ! N B,Y
 S B=$S($G(BIDED):"Yes",1:"No")
 D DIR^BIFMAN("YAO",.Y,,"   Include Deceased Patients in this list/report? (Yes/No): ",B)
 S:Y=0 BIDED=0 S:Y=1 BIDED=1
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;This option allows you to include deceased patients in the
 ;;list or report.  In general deceased patients are left off
 ;;of lists and reports; however, it is sometimes necessary for
 ;;purposes such as tracking recipients of a particular vaccine
 ;;or reconciling various statistical reports.
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
FLH1N1(BIFH,BIRTN) ;EP
 ;---> Answer Yes/No to include CPT Coded Visits in report.
 ;---> Called by Protocol BI OUTPUT INCLUDE CPT.
 ;---> Parameters:
 ;     1 - BICPT  (ret) 1=YES, 0=NO.
 ;     2 - BIRTN  (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("REPORT TYPE: STANDARD FLU OR H1N1")
 W ! D TEXT3 W !
 N DIR,Y
 S DIR("A")="     Select Standard or H1N1: "
 S DIR("B")=$S($G(BIFH)="H":"H1N1",1:"Standard")
 S DIR(0)="SAM^s:Standard;h:H1N1"
 D ^DIR K DIR
 D
 .I Y="h" S BIFH="H" Q
 .S BIFH="F"
 ;
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;Do you want to run the Standard Flu Report or the H1N1 Report?
 ;;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
USERPOP(BIUP,BIRTN) ;EP - Select User Population Parameter.
 ;---> Called by Protocol BI OUTPUT USER POPULATION.
 ;---> Parameters:
 ;     1 - BIUP  (ret) R=Registered Patients; U=User Population (1+ visits)
 ;                     A=Active Users.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
USERPP1 ;
 D FULL^VALM1
 D TITLE^BIUTL5("PATIENT POPULATION GROUP")
 W !?5,"Select the User Population Group you which to include in this report."
 N DIR,Y,BIGPRA,BIPOP
 S (BIGPRA,BIPOP)=0
 ;
 ;---> If GPRA is set up, set BIGPRA=1.
 I $$GPRAIEN^BIUTL6 S BIGPRA=1
 ;
 S DIR(0)="SM^r:"_$$BIUPTX^BIUTL6("r")_";i:"_$$BIUPTX^BIUTL6("i")
 S DIR(0)=DIR(0)_";u:"_$$BIUPTX^BIUTL6("u")_";a:"_$$BIUPTX^BIUTL6("a")
 ;
 S DIR("A")="     Select User Population Group"
 D
 .I $G(BIUP)]"" S DIR("B")=$P($P(DIR(0),BIUP_":",2),";") Q
 .I BIGPRA=1 S DIR("B")="Active Clinical Users (2+ visits)" Q
 .S DIR("B")="User Population (1+ visits)"
 ;
 D HELP1
 D ^DIR K DIR
 ;
 D:((Y="a")&('BIGPRA))
 .W !!?5,"You cannont select for Active Users because the GPRA Software is"
 .W !?5,"not loaded or set up correctly."
 .W !?5,"Contact your site manager or RPMS support for further information."
 .D DIRZ^BIUTL3(.BIPOP)
 ;
 I BIPOP D @("RESET^"_BIRTN) Q
 G:((Y="a")&('BIGPRA)) USERPP1
 ;
 S BIUP=Y
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
HELP1 ; EP
 ;;
 ;;Select the User Population Group you which to include in this report.
 ;;
 ;;If you select "R" for Registered Patients, all patients who have an
 ;;active Health Record in the system and meet the other criteria you
 ;;select will be included in the report.
 ;;
 ;;If you select "I" for Immunization Registry patients, all the patients
 ;;who have an Active Status in the Immunization Registry and meet the
 ;;other criteria you select will be included in the report.
 ;;
 ;;If you select "U" for User Population, only patients who have had at
 ;;least ONE visit in the last 3 years will be included in the report.
 ;;
 ;;If you select "A" for Active Clinical Users, only patients who have had
 ;;at least TWO qualifying visits in the last 3 years will be included in
 ;;the report.  (NOTE: The RPMS GPRA software must be installed for this
 ;;selection.)
 D HELPTX("HELP1",5)
 Q
 ;
 ;
 ;----------
LOADTX(BILINL,BITAB,BITEXT) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
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
HELPTX(BILINL,BITAB) ;
 ;---> Set DIR("?") help array from the specified line label.
 ;
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
