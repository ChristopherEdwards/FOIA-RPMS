BILOT2 ;IHS/CMI/MWR - EDIT LOT NUMBERS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT VACCINE FIELDS: CURRENT LOT, ACTIVE, VIS DATE DEFAULT.
 ;
 ;
 ;----------
LOTDVAL(BIX) ;EP
 ;---> Sub-Lot data validation for Field 1.5, BI FORM-LOT NUMBER EDIT
 ;---> Parameters:
 ;     1 - BIX (req) The value of the Lot Number.
 ;
 Q:($G(X)="")  Q:($G(X)=0)
 ;
 I $D(^AUTTIML("B",BIX)) D  Q
 .S DDSSTACK="BI PAGE-LOT DUPLICATE WARNING"
 .;N Y S Y="This Lot Number already exists.  Please exit and select it from"
 .;S Y=Y_" the list.  (NOTE: It It may be Inactive. Try displaying Inactive as"
 .;S Y=Y_"well as Active.)"
 .;D HLP^DDSUTL(Y) S DDSERROR=1
 ;
 I BIX["*" D
 .S Y="The Lot Number may not contain an asterisk, ""*"". (This symbol is used to"
 .S Y=Y_" separate the Lot Number from the Sub-lot, if one is appended.)"
 .D HLP^DDSUTL(Y) S DDSERROR=1
 Q
 ;
 ;
 ;----------
SUBLOTD(BIA,BIX) ;EP
 ;---> Sub-Lot data validation for Field 1.5, BI FORM-LOT NUMBER EDIT
 ;---> Parameters:
 ;     1 - BIA (req) The value of the Lot Number.
 ;     2 - BIX   (req) The sub-lot entered.
 ;
 N Y,X
 Q:($G(BIX)="")
 S X=+(19-$L($G(BIA)))
 I $L($G(BIX))>(19-$L($G(BIA))) D  Q
 .S Y="The Sub-lot you entered, "_$G(BIX)_", is too long for this Lot Number."
 .S Y=Y_"  This Sub-lot must be "_X_" characters or less."
 .D HLP^DDSUTL(Y) S DDSERROR=1
 ;
 I BIX["*" D
 .S Y="The Sub-lot may not contain an asterisk, ""*"".  This symbol is used to"
 .S Y=Y_" separate the Lot Number from the Sub-lot."
 .D HLP^DDSUTL(Y) S DDSERROR=1
 Q
 ;
 ;
 ;----------
SUBLOTH(BIA) ;EP
 ;---> Sub-Lot Help for Field 1.5, BI FORM-LOT NUMBER EDIT
 ;---> Parameters:
 ;     1 - BIA (req) The value of the Lot Number.
 ;
 N X,Y
 S X=+(19-$L($G(BIA)))
 S Y="Enter/edit the Sub-lot suffix, if desired.  "
 D
 .I X S Y=Y_"The suffix for this Lot Number may be up to "_X_" characters long." Q
 .S Y=Y_"This Lot Number is too long for a sub-lot suffix."
 D HLP^DDSUTL(Y)
 Q
 ;
 ;
 ;----------
CHGORDR ;EP
 ;---> Edit the parameter directing the ImmServe Forecast to return
 ;---> Immunization Due dates for either the Minimum Acceptable Age
 ;---> or the Recommended Age.
 ;---> Called by Protocol BI SITE FORC MIN VS RECOMM
 ;
 D FULL^VALM1,TITLE^BIUTL5("SELECT LOT LISTING ORDER"),TEXT2^BILOT1
 N DIR,Y
 S DIR(0)="SOA^"_$G(BISUBT)
 S DIR("A")="     Please select 1, 2, 3, 4, 5, or 6: "
 S DIR("B")=$G(BICOLL)
 D ^DIR
 S:(Y>0) BICOLL=Y
 I Y="^" D RESET^BILOT1 Q
 ;
 ;---> Include Inacive Lots?
 W !!,"   Do you wish to include INACTIVE Lots in this display?"
 S DIR("?")="     Enter YES to include INACTIVE Lots."
 S DIR(0)="Y",DIR("A")="   Enter Yes or No",DIR("B")="NO"
 D ^DIR
 S BIINACT=$S(Y>0:1,1:0)
 D RESET^BILOT1
 Q
