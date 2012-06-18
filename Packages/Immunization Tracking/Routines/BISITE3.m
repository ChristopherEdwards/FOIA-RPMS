BISITE3 ;IHS/CMI/MWR - EDIT SITE PARAMETERS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT SITE PARAMETERS.
 ;
 ;
 ;----------
FORECAS ;EP
 ;---> Edit the parameter that determines whether the ImmServe
 ;---> Forecasting utility is called ("enabled") or not.
 ;---> Called by Protocol BI SITE FORECAST ENABLE.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("ENABLE/DISABLE FORECASTING"),TEXT1
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="SOA^E:Enable;D:Disable"
 S DIR("A")="     Please select either Enable or Disable: "
 S DIR("B")=$S($$FORECAS^BIUTL2(BISITE):"Enable",1:"Disable")
 D ^DIR
 D:'$D(DIRUT)
 .N BIFLD,BIERR S BIFLD(.11)=Y
 .D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 .I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;
 ;;If the ImmServe Forecasting Utility is properly installed and
 ;;Immunizations Due should be forecast when viewing and editing
 ;;patient histories, printing Due Lists, etc., choose "Enable" below.
 ;;If the ImmServe Utility is not installed, choose "Disable" below.
 ;;
 ;;NOTE: If at any point in the software an <XCALL> error occurs,
 ;;      this is due to the ImmServe Utility being called without
 ;;      it being installed.  In this case, either the ImmServe
 ;;      Utility should be installed (see Installation Notes in
 ;;      the Technical Manual), or this parameter should be Disabled.
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
DASHES ;EP
 ;---> Edit the parameter that determines whether Chart#s should
 ;---> be displayed with dashes inserted or not.
 ;---> Called by Protocol BI SITE CHART# DASHES.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("DISPLAY CHART# WITH DASHES"),TEXT2
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="SOA^0:No Dashes;1:Dashes Included"
 S DIR("A")="     Please select No Dashes or Dashes Included: "
 S DIR("B")=$S($$DASH^BIUTL1(BISITE):"Dashes Included",1:"No Dashes")
 D ^DIR
 D:'$D(DIRUT)
 .N BIFLD,BIERR S BIFLD(.12)=Y
 .D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR)
 .I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;You may select whether Chart#'s (Health Record Numbers) are
 ;;displayed throughout the Immunization package with dashes or not.
 ;;
 ;;Chart# displayed without dashes..:  12345
 ;;Same Chart# displayed with dashes:  01-23-45
 ;;
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
OFFREC ;EP
 ;---> Select the Letter that will serve as the Official Immunization
 ;---> Record.
 ;---> Called by Protocol BI SITE OFFICIAL PT RECORD.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("OFFICIAL IMMUNIZATION RECORD"),TEXT3
 D DIE^BIFMAN(9002084.02,".13",BISITE)
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;The Official Immunization Record is the letter that presents all of
 ;;a patient's Immunization information and is generally used to send
 ;;to schools, parents, other clinics, etc.
 ;;
 ;;The letter selected here will be used as the patient's Official
 ;;Immunization Record whenever users select that action.
 ;;
 ;;In order to select the letter for this Site Parameter, it must
 ;;already have been created.  To create the Official Immunization
 ;;Record letter, select LET under the Manager Menu (MGR-->LET).
 ;;Create a new letter named "Official Immunization Record," and then
 ;;return to this site parameter to choose it.
 ;;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
PNUFLU ;EP
 ;---> Edit Pneumo, Flu, and Zoster site parameters.  v8.5
 ;
 ;---> Edit the age at which adults should be forecast to receive
 ;---> pneumococcal vaccines.
 ;---> Called by Protocol BI SITE PNEUMO AGE.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("EDIT AGE APPROPRIATE FOR PNEUMO"),TEXT4
 N BIDFLT,BIPOP,DIR,DIRUT,Y
 S DIR(0)="NOA^1:9999:0"
 S DIR("A")="     Adult Age for Pneumo: "
 S DIR("B")=$P($$PNMAGE^BIPATUP2(BISITE),U)
 S DIR("?")="       Enter a number between 1 and 99 years of age."
 D ^DIR
 I $D(DIRUT) D RESET^BISITE Q
 ;
 N BIFLD,BIERR S BIFLD(.1)=+Y
 D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR)
 I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3(),RESET^BISITE Q
 ;
 ;---> Flu Forecast for ALL question.
 D TITLE^BIUTL5("SELECT FLU FORECASTING AGES"),TEXT11
 N BIDFLT,BIHELP,BIHELP1,BIPRMPT,X,Y
 S BIPRMPT="     Forecast Flu vaccination for ALL patients"
 S BIHELP1="        Enter Yes to forecast Flu for ALL patients."
 S BIHELP="        Enter No to limit Flu forecasting (6m-18y, 50y+)."
 S BIDFLT=$S($$FLUALL^BIPATUP2(BISITE):"YES",1:"NO")
 W !
 D DIR^BIFMAN("YO",.Y,,BIPRMPT,BIDFLT,BIHELP,BIHELP1)
 I $G(Y)="^" D RESET^BISITE Q
 D DIE^BIFMAN(9002084.02,".27///"_Y,BISITE)
 ;
 ;---> Zoster Vaccine Forecast question.
 D TITLE^BIUTL5("SELECT FORECASTING FOR ZOSTER VACCINE"),TEXT12
 N BIDFLT,BIHELP,BIHELP1,BIPRMPT,X,Y
 S BIPRMPT="     Forecast Zoster vaccine for ALL patients over age 60"
 S BIHELP1="        Enter Yes to forecast Zoster vaccine for ALL patients over age 60."
 S BIHELP="        Enter No to disable Zoster vaccine forecasting."
 S BIDFLT=$S($$ZOSTER^BIPATUP2(BISITE):"YES",1:"NO")
 W !
 D DIR^BIFMAN("YO",.Y,,BIPRMPT,BIDFLT,BIHELP,BIHELP1)
 I $G(Y)="^" D RESET^BISITE Q
 D DIE^BIFMAN(9002084.02,".29///"_Y,BISITE)
 ;
 D RESET^BISITE
 Q
 ;
 ;---> q6-year parameter no longer used.  Feb 2010.
 ;W !!?5,"For people "_+Y_" years of age and older, should Pneumo-PS"
 ;W !?5,"be routinely forecast every 6 years after the age of "_+Y_", "
 ;W !?5,"or should it be a one-time immunization?"
 ;S BIDFLT=$P($G(^BISITE(BISITE,0)),U,22)
 ;S BIDFLT=$S(BIDFLT:"YES",1:"NO")
 ;W !
 ;D DIR^BIFMAN("YO",.Y,.BIPOP,"     Forecast every 6 years",BIDFLT)
 ;D:'$G(BIPOP)
 ;.N BIFLD,BIERR S BIFLD(.22)=+Y
 ;.D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR)
 ;.I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 ;D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT4 ;EP
 ;;Enter the adult age at which you wish pneumococcal immunizations
 ;;to be routinely forecast (prescribed).  Typically this is set to
 ;;65 years of age.
 ;;
 D PRINTX("TEXT4")
 Q
 ;
 ;
 ;----------
TEXT11 ;EP
 ;;Influenza vaccine is recommend for ALL ages.
 ;;You can, however, choose to limit influenza vaccine forecasting to
 ;;patients ages 6 months to 18 years and to those 50 years and older.
 ;;
 ;;Do you wish to forecast Flu vaccination for ALL patients (over 6 months)?
 ;;
 D PRINTX("TEXT11")
 Q
 ;
 ;
 ;----------
TEXT12 ;EP
 ;;A single dose of Zoster vaccine vaccination is recommended for ALL
 ;;patients over 60 years of age.
 ;;
 ;;Do you wish to forecast Zoster vaccine for ALL patients over age 60?
 ;;
 D PRINTX("TEXT12")
 Q
 ;
 ;
 ;----------
DEFPRV ;EP
 ;---> Edit the parameter that determines whether the User
 ;---> should appear as the Default Provider.
 ;---> Called by Protocol BI SITE DEFAULT PROVIDER.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("USER AS DEFAULT PROVIDER"),TEXT5
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="SOA^0:No;1:Yes"
 S DIR("A")="     Should the User appear as the Default Provider: "
 S DIR("B")=$S($$DEFPROV^BIUTL6(BISITE):"Yes",1:"No")
 D ^DIR
 D:'$D(DIRUT)
 .N BIFLD,BIERR S BIFLD(.16)=Y
 .D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 .I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT5 ;EP
 ;;When new Immunizations or new Skin Tests are being added,
 ;;it is possible to have the User appear as the Default Provider.
 ;;In other words, when the screen for a new Visit first comes up,
 ;;the Provider field is already filled in with the User's name.
 ;;(The User is the person logged on and entering the data.)
 ;;
 ;;This will ONLY occur if the User is a Provider (has been given
 ;;the Provider Key).  This will NOT occur on edits of pre-existing
 ;;Visits, whether they have a Provider or not.
 ;;
 D PRINTX("TEXT5")
 Q
 ;
 ;
 ;----------
IMMSVDIR ;EP
 ;---> Edit the parameter indicating the Immserve Directory.
 ;
 K BIDFLT,DIR,DIRUT,X,Y
 D TITLE^BIUTL5("INDICATE IMMSERVE DIRECTORY"),TEXT7
 S DIR(0)="FOA^3:70"
 S DIR("A")="     "
 S DIR("B")=$$IMMSVDIR^BIUTL8(BISITE)
 S X="       Enter the path for ImmServe files.  Simply enter the directory"
 S DIR("?",1)=X
 S X="       name with its path.  Terminate the path with a slash."
 S DIR("?")=X K X
 D ^DIR
 S:Y="" Y="@"
 S Z=0
 D CHKSLASH^BISITE2(.Y,.Z)
 G:Z IMMSVDIR
 D:'$D(DIRUT)
 .N BIFLD,BIERR S BIFLD(.18)=Y
 .D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR)
 .I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT7 ;EP
 ;;
 ;;Enter or edit, if necessary, the full path of the directory in which
 ;;the ImmServe Files will be stored.  (Path length may not be more than
 ;;70 characters long.)
 ;;
 ;;For Immunization v8.1 the settings should be:
 ;;
 ;;   AIX:    /usr/local/immserve84/
 ;;   NT/XP:  C:\Program Files\Immserve84\
 ;;
 ;;
 ;;Enter or edit the Immserve Directory Path below:
 ;;
 D PRINTX("TEXT7")
 Q
 ;
 ;
 ;----------
LOTREQ ;EP
 ;---> Edit the parameter for whether Lot Numbers should be required.
 ;---> Called by Protocol BI SITE LOT# REQ'D.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("LOT NUMBER REQUIRED"),TEXT9
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="SOA^Y:YES;N:NO"
 S DIR("A")="     Please select either Yes or No: "
 S DIR("B")=$S($$LOTREQ^BIUTL2(BISITE):"Yes",1:"No")
 D ^DIR
 D:'$D(DIRUT)
 .N BIFLD,BIERR S BIFLD(.09)=Y
 .D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 .I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 ;
 D FULL^VALM1,TITLE^BIUTL5("LOT NUMBER LOW SUPPLY ALERT"),TEXT10
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="NOA^0:9999"
 S DIR("A")="     Please enter a Low Supply Alert number: "
 S DIR("B")=$$LOTLOW^BIUTL2(BISITE)
 D ^DIR
 D:'$D(DIRUT)
 .N BIFLD,BIERR S BIFLD(.25)=Y
 .D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 .I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT9 ;EP
 ;;
 ;;If Lot Numbers should be required when entering Immunization visits,
 ;;enter YES for this parameter.  If Lot Numbers should be optional,
 ;;enter NO.
 ;;
 ;;Note: Lot Numbers will NOT be required for Immunizations with a
 ;;      Category of "Historical Event", even if this site parameter
 ;;      is to YES.
 ;;
 ;;
 D PRINTX("TEXT9")
 Q
 ;
 ;
 ;----------  vvv83
TEXT10 ;EP
 ;;
 ;;When the number of remaining doses of a given Lot falls below
 ;;its Low Supply Alert (set by the manager when editing Lot Numbers),
 ;;a "Low Supply Alert" will pop up on the screen as a user is
 ;;adding or editing an immunization with that particular Lot Number.
 ;;
 ;;The number entered here, under the Site Parameters, is the Low
 ;;Supply Alert DEFAULT.  In the absence of a specific Low Supply Alert
 ;;for a given Lot Number, this Default will be used.
 ;;
 ;;NOTE: No alert will occur if a "Starting Amount" has not been entered
 ;;for the particular Lot Number in the EDIT LOT NUMBER TABLE.
 ;;
 ;;
 D PRINTX("TEXT10")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
