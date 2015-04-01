BINDC2 ;IHS/CMI/MWR - EDIT NDC NUMBERS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**9**;OCT 01,2014
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT VACCINE FIELDS: CURRENT NDC, ACTIVE, VIS DATE DEFAULT.
 ;   PATCH 2: Make Display Inactives a separate Action.  CHGORDR+11
 ;   PATCH 3: Correct leftover prompt from Inactive question. DISPLYI+7
 ;
 ;
 ;----------
NDCDVAL(BIX) ;EP
 ;---> Sub-Lot data validation for Field 1.5, BI FORM-NDC NUMBER EDIT
 ;---> Parameters:
 ;     1 - BIX (req) The value of the Lot Number.
 ;
 Q:($G(X)="")  Q:($G(X)=0)
 ;
 I $D(^AUTTIML("B",BIX)) D  Q
 .S DDSSTACK="BI PAGE-NDC DUPLICATE WARNING"
 .;N Y S Y="This NDC Code already exists.  Please exit and select it from"
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
CHGORDR ;EP
 ;---> Menu for selecting Lot listing order.
 ;
 D FULL^VALM1,TITLE^BIUTL5("SELECT NDC LISTING ORDER"),TEXT2^BINDC1
 N DIR,Y
 S DIR(0)="SOA^"_$G(BISUBT)
 S DIR("A")="     Please select 1 or 2: "
 S DIR("B")=$G(BICOLL)
 D ^DIR
 S:(Y>0) BICOLL=Y
 ;
 D RESET^BINDC1
 Q
 ;
 ;
 ;----------
DISPLYI ;EP
 ;---> Display Inactive Lot Numbers.
 ;---> Called by Protocol:
 ;
 D FULL^VALM1,TITLE^BIUTL5("DISPLAY INACTIVE NDC NUMBERS YES/NO")
 W !!,"   Do you wish to include INACTIVE NDC Codes in this display?"
 N DIR
 S DIR("?")="     Enter YES to include INACTIVE NDC Codes."
 S DIR(0)="Y",DIR("A")="   Enter Yes or No",DIR("B")="NO"
 D ^DIR
 S BIINACT=$S(Y>0:1,1:0)
 D RESET^BINDC1
 Q
