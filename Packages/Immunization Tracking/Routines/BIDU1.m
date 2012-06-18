BIDU1 ;IHS/CMI/MWR - DUE LIST/LETTERS, HELP; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  DUE LISTS/LETTERS, HELP.
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Enter ""L"" to view or print a list of patients according to the"
 W !?5,"selection criteria above.  Enter ""P"" to print letters to the list"
 W !?5,"of patients selected above.  Or enter ""H"" to view the full help text"
 W !?5,"of the lists, letters, and parameters above."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RESET^BIDU
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;----> Explanation of this report.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("DUE LISTS AND LETTERS - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;The IMMUNIZATION LISTS & LETTERS screen provides a single point from
 ;;which to view Due Lists and Master Lists, and to print Due Letters.
 ;;
 ;;There are 13 items or "parameters" on the screen that you may
 ;;change in order to select for a specific group of patients.
 ;;To change an item, enter its left column number (1-12) at the
 ;;prompt on the bottom of the screen.  Use "?" at any prompt where
 ;;you would like help or more information on the parameter you are
 ;;changing.
 ;;
 ;;Once you have the parameters set to retrieve the group of patients
 ;;you want, select L to print or view the List of patients, or
 ;;select P to Print Due Letters.
 ;;
 ;;In building this list to view or print, the computer must examine
 ;;every patient in the Immunization Register.  For this reason, on
 ;;some computer systems it may take some time before the list appears.
 ;;
 ;;For the parameters: DATE OF FORECAST, AGE RANGE,  PATIENT GROUP,
 ;;ADDITIONAL INFORMATION, and ORDER OF LISTING detailed help will be
 ;;displayed when you select these items.
 ;;
 ;;COMMUNITIES: If you select for specific Communities, only patients
 ;;whose Current Community (under Patient Registration) is one of the
 ;;selected Communities will be included in the Lists and Letters.
 ;;
 ;;CASE MANAGERS: If you select for specific Case Managers, only
 ;;patients who have the selected Case Managers will be included
 ;;in the Lists and Letters.
 ;;
 ;;DESIGNATED PROVIDERS: If you select for specific Designated Primary
 ;;Providers, only patients who have the selected Providers will be
 ;;included in the Lists and Letters.
 ;;
 ;;IMMUNIZATIONS RECEIVED: If you select for specific Immunizations
 ;;Received, then only patients who have received the Vaccines selected
 ;;will be included in the Lists and Letters.  If you further limit your
 ;;criteria to a date range, then only patients who have received the
 ;;the selected vaccines within the date range will be included.  You can
 ;;then choose to display only the history of the vaccines you selected.
 ;;
 ;;NOTE: If you select for ALL vaccines and do NOT limit it by date
 ;;range, then this criterium "Immunizations Received" will have
 ;;NO limiting effect.  This feature allows you to create lists that
 ;;include patients who have never received an immunization at your
 ;;site--for example, a Due List that includes newcomers.
 ;;
 ;;IMMUNIZATIONS DUE: If you select for specific Immunizations Due,
 ;;then only patients who are due for the Vaccines selected will be
 ;;included in the Lists and Letters.
 ;;
 ;;NOTE: This parameter is only used to limit a list to patients who
 ;;are due for specific vaccines.  If you simply leave the parameter
 ;;as "ALL" it will have no limiting effect on the Patient Group chosen
 ;;in parameter 3 of the Lists & Letters Menu.
 ;;
 ;;LOT NUMBERS: If you select for specific Lot Numbers, only patients
 ;;who have received immunizations with the specified Lot Numbers will
 ;;be included in the Lists and Letters.
 ;;
 ;;HEALTH CARE FACILITIES: If you select for specific Facility, only
 ;;patients who have a Health Record Number at one of the selected
 ;;Health Care Facilities will be included in the Lists and Letters.
 ;;
 D LOADTX("TEXT1",,.BITEXT)
 Q
 ;
 ;
 ;----------
LOADTX(BILINL,BITAB,BITEXT) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
 Q
