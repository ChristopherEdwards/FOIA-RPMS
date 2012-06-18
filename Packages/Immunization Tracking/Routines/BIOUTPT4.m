BIOUTPT4 ;IHS/CMI/MWR - PROMPTS FOR REPORTS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PROMPTS FOR REPORT PARAMETERS.
 ;
 ;
 ;----------
PGROUP1(BIPG,BIRTN) ;EP
 ;---> Select Patient Group.
 ;---> Called by Protocol BI OUTPUT PATIENT GROUP.
 ;---> Parameters:
 ;     1 - BIPG  (ret) Patient Group numbers 1-8, 1-7 may be combined.
 ;                     Patient Group (^-pc 1): 1=DUE, 2=PAST DUE, 3=ACTIVE,
 ;                     4=INACTIVE, 5=AUTOMATICALLY ACTIVATED, 6=REFUSALS
 ;                     7=FEMALES ONLY, 8=SEARCH TEMPLATE.
 ;                     If ^-pc1=2, then pc2=Minimum number of months past due.
 ;                     If ^-pc1=4, then pc4=Date Range for date made Inactive:
 ;                                             BeginDate_":"_EndDate
 ;                     If ^-pc1=5, then pc5=Date Range for Auto Activated:
 ;                                             BeginDate_":"_EndDate
 ;                     If ^-pc1=6, then pc6=Date Range for Auto Activated:
 ;                                             BeginDate_":"_EndDate_"|"_
 ;                                             Vaccine IEN(1)_"|"_Vaccine IEN(2), etc.
 ;                     If ^-pc1=8, then pc8=IEN of Search Template of patients.
 ;
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 ;
PGRP11 ;---> Go here if 8 selected with other attributes.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 S:'$G(BIPG) BIPG=3
 D FULL^VALM1
 D TITLE^BIUTL5("PATIENT GROUP"),TEXT1 W !
 N DIR,Y S DIR("A")="   Select Patient Group: "
 S DIR(0)="LAO^1:8"
 S DIR("?")="^D HELP1^BIOUTPT4"
 S DIR("B")=$P(BIPG,U)
 D ^DIR
 I (Y=-1)!("@^"[$E(Y)) S:'$G(BIPG) BIPG=3 D @("RESET^"_BIRTN) Q
 D
 .;---> If both 1 and 2 (DUE and PAST DUE), remove 2.
 .I Y[1&(Y[2) S Y=$P(Y,2)_$P(Y,2,2)
 .;---> Remove extraneous commas.
 .I Y[",," S Y=$P(Y,",,")_","_$P(Y,",,",2)
 .I '$E(Y) S Y=$E(Y,2,99)
 .I '$E(Y,$L(Y)) S Y=$E(Y,1,$L(Y)-1)
 .S $P(BIPG,U)=Y
 ;
 ;---> If Search Template was used in combo with others, start over.
 I $P(BIPG,U)'=8&($P(BIPG,U)[8) D  G PGRP11
 .W !!?5,"8 - SEARCH TEMPLATE is a pre-defined group of Patients and"
 .W !?9,"may not be used in combination with other Patient Groups."
 .K DIR("B") D DIRZ^BIUTL3(.BIPOP) S BIPG=1
 ;
 ;
 ;---> If 2-PAST DUE, get months Past Due.
 D:$P(BIPG,U)[2
 .N X D PASTNU(.X)
 .I '$G(X) S BIPG=1 Q
 .S BIPG=BIPG_U_X
 .S $P(BIPG,U,2)=X
 .;
 .;---> If Past Due only, make explicit this will be Active only.
 .;I $P(BIPG,U)=2 S $P(BIPG,U)="2,3"
 ;
 ;
 ;---> If 4-INACTIVE, get Date Range.
 N BIPOP
 D:$P(BIPG,U)[4
 .N BIBEGDT,BIENDDT,BIBEGDF,BIENDDF,X,Y
 .S X=$P(BIPG,U,4) S BIBEGDF=$P(X,":"),BIENDDF=$P(X,":",2)
 .S:'BIBEGDF BIBEGDF=2000101 S:'BIENDDF BIENDDF=$G(DT)
 .D TITLE^BIUTL5("SELECT INACTIVE DATE RANGE")
 .D TEXT3 W !
 .N DIR S DIR(0)="YA",DIR("A")="     Enter Yes or No: ",DIR("B")="YES"
 .S DIR("?",1)="       Enter YES to limit the group to an Inactive date range."
 .S DIR("?")="       Enter No to include ALL Inactive Patients."
 .D ^DIR W !
 .I 'Y S $P(BIPG,U,4)="2000101:"_$G(DT) Q
 .;---> Specify a date range.
 .D ASKDATES^BIUTL3(.BIBEGDT,.BIENDDT,.BIPOP,BIBEGDF,BIENDDF)
 .Q:$G(BIPOP)
 .S:'BIBEGDT BIBEGDT=2000101 S:'BIENDDT BIENDDT=$G(DT)
 .S $P(BIPG,U,4)=BIBEGDT_":"_BIENDDT
 G:$G(BIPOP) PGRP11
 ;
 ;
 ;---> If 5-Automatically Activated, get Date Range.
 N BIPOP
 D:$P(BIPG,U)[5
 .N BIBEGDT,BIENDDT,BIBEGDF,BIENDDF,X,Y,Z
 .S X=$P(BIPG,U,5) S BIBEGDF=$P(X,":"),BIENDDF=$P(X,":",2)
 .S:'BIBEGDF BIBEGDF=2000101 S:'BIENDDF BIENDDF=$G(DT)
 .D TITLE^BIUTL5("SELECT AUTO-ACTIVATED DATE RANGE")
 .D TEXT4 W !
 .N DIR S DIR(0)="YA",DIR("A")="     Enter Yes or No: ",DIR("B")="YES"
 .S Z="       Enter YES to limit the group to Actvated within date range."
 .S DIR("?",1)=Z
 .S DIR("?")="       Enter No to include ALL Automatically Activated Patients."
 .D ^DIR W !
 .I 'Y S $P(BIPG,U,5)="2000101:"_$G(DT) Q
 .;---> Specify a date range.
 .D ASKDATES^BIUTL3(.BIBEGDT,.BIENDDT,.BIPOP,BIBEGDF,BIENDDF)
 .Q:$G(BIPOP)
 .S:'BIBEGDT BIBEGDT=2000101 S:'BIENDDT BIENDDT=$G(DT)
 .S $P(BIPG,U,5)=BIBEGDT_":"_BIENDDT
 G:$G(BIPOP) PGRP11
 ;
 ;*********************************
 ;
 ;                     If ^-pc1=6, then pc6=Date Range for Auto Activated:
 ;                                             BeginDate_":"_EndDate_"|"_
 ;                                             Vaccine IEN(1)_"|"_Vaccine IEN(2), etc.
 ;
 ;---> If 6-Refusals, get particular Vaccines and Date Range.
 ;N BIPOP
 ;D:$P(BIPG,U)[6
 ;.N BIBEGDT,BIENDDT,BIBEGDF,BIENDDF,X,Y,Z
 ;.S X=$P(BIPG,U,5) S BIBEGDF=$P(X,":"),BIENDDF=$P(X,":",2)
 ;.S:'BIBEGDF BIBEGDF=2000101 S:'BIENDDF BIENDDF=$G(DT)
 ;.D TITLE^BIUTL5("SELECT REFUSALS DATE RANGE")
 ;.D TEXT5 W !
 ;.N DIR S DIR(0)="YA",DIR("A")="     Enter Yes or No: ",DIR("B")="YES"
 ;.S Z="       Enter YES to limit the group to Actvated within date range."
 ;.S DIR("?",1)=Z
 ;.S DIR("?")="       Enter No to include ALL Automatically Activated Patients."
 ;.D ^DIR W !
 ;.I 'Y S $P(BIPG,U,5)="2000101:"_$G(DT) Q
 ;.;---> Specify a date range.
 ;.D ASKDATES^BIUTL3(.BIBEGDT,.BIENDDT,.BIPOP,BIBEGDF,BIENDDF)
 ;.Q:$G(BIPOP)
 ;.S:'BIBEGDT BIBEGDT=2000101 S:'BIENDDT BIENDDT=$G(DT)
 ;.S $P(BIPG,U,5)=BIBEGDT_":"_BIENDDT
 ;G:$G(BIPOP) PGRP11
 ;
 ;*********************************
 ;
 ;---> If 8-SEARCH TEMPLATE, select Search Template.
 N BITMPL
 D:$P(BIPG,U)=8
 .D SEARCH(.BITMPL)
 .;---> Set BIPG=8^^^^^^^IEN of Template.
 .S $P(BIPG,U,8)=BITMPL
 ;---> If user failed to choose a Search Template, change Patient Group
 ;--->back to default (Active).
 I $P(BIPG,U)=8&($G(BITMPL)<1) S $P(BIPG,U)=3 G PGRP11
 ;
 D:($P(BIPG,U)'=8)
 .D TITLE^BIUTL5("INDIANS/AK NATIVES ONLY or ALL PATIENTS")
 .D TEXT7
 .S B=$S($D(BIBEN("ALL")):"Yes",1:"No") K BIBEN
 .D DIR^BIFMAN("YAO",.Y,,"     Include non-Native Beneficiaries? (Yes/No): ",B)
 .I 'Y S BIBEN(1)="" Q
 .S BIBEN("ALL")=""
 ;
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;---> Help for Select Order prompt.
 N BITEXT D TEXT11^BIOUTPT5(.BITEXT)
 D START^BIHELP("PATIENT GROUP - HELP",.BITEXT)
 D FULL^VALM1,TITLE^BIUTL5("PATIENT GROUP"),TEXT1
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;Please select the Patient Group for this list or letter.
 ;;You may include any combination of attributes 1-6 by entering the
 ;;numbers separated by commas.  For example: 1,3,4 would produce a
 ;;list of both ACTIVE and INACTIVE Patients DUE for immunizations.
 ;;
 ;;DUE and PAST DUE, if selected alone, will include only ACTIVE
 ;;patients, unless INACTIVE is also selected.
 ;;
 ;;   1 - DUE......................(Patients Due for immunizations)
 ;;   2 - PAST DUE.................(Only Patients who are PAST Due)
 ;;   3 - ACTIVE...................(List of Active Patients)
 ;;   4 - INACTIVE.................(Inactive Patients, by date if desired)
 ;;   5 - AUTOMATICALLY ACTIVATED..(By date if desired)
 ;;   6 - REFUSALS.................(Patients who have refused any vaccines)
 ;;   7 - FEMALES ONLY.............(Only female patients included)
 ;;   8 - SEARCH TEMPLATE..........(Pre-selected group of Patients)
 ;;   Enter "?" for further explanation.
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
PASTNU(BIPG1) ;EP
 ;---> Select minimum number of months Past Due.
 ;---> Parameters:
 ;     1 - BIPG1 (ret) BIPG1=Number of months PAST DUE or greater.
 ;
 ;---> Select Order of sort.
 S BIPG1=0
 D FULL^VALM1
 D TITLE^BIUTL5("NUMBER OF MONTHS PAST DUE")
 D TEXT2 N DIR
 N DIR D HELP2
 S DIR("A")="   Number of Months Past Due: "
 S DIR(0)="NA^1:999:0"
 D ^DIR
 S BIPG1=+Y S:BIPG1<1 BIPG1=0
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;You have chosen to limit this listing to patients who are
 ;;PAST DUE for one or more immunizations.  You must now specify
 ;;the MINIMUM number of months a patient must be PAST DUE to be
 ;;included in this listing.
 ;;
 ;;NOTE: This will be the number of months that the patient was
 ;;      PAST DUE before the Forecast/Clinic Date you select
 ;;      (not necessarily the number of months before today!).
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;You have chosen to include Patients who are Inactive.
 ;;
 ;;You may include ALL Patients who are Inactive, or you may
 ;;limit the group of Inactive Patients to those who were made
 ;;Inactive within a specified date range.
 ;;
 ;;Would you like to limit the list of Inactive Patients to a specific
 ;;date range?  In other words, include only patients who were made
 ;;Inactive after a particular date and before a later date?
 ;;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
TEXT4 ;EP
 ;;You have chosen to limit this list to Patients who were
 ;;Automatically Activated.
 ;;
 ;;You may include ALL Patients who were Automatically Activated,
 ;;or you may limit the group to Patients who were Automatically
 ;;Activated within a specified date range.
 ;;
 ;;Would you like to limit the list of Patients who were Automatically
 ;;Activated within a specific date range?  In other words, include only
 ;;patients who were Activated after a particular date and before
 ;;a later date?
 ;;
 D PRINTX("TEXT4")
 Q
 ;
 ;
 ;----------
TEXT5 ;EP
 ;;You have chosen to limit this list to patients who have Refusals
 ;;on record.
 ;;
 ;;You may include patients who have Refusals for ANY vaccine, or
 ;;you may limit the list to refusals for one or more specific vaccines.
 ;;
 ;;Would you like to limit the list to Refusals of one or more specific
 ;;vaccines?
 ;;
 D PRINTX("TEXT5")
 Q
 ;
 ;
 ;----------
TEXT6 ;EP
 ;;You have chosen to limit this list to patients who have Refusals
 ;;on record.
 ;;
 ;;Would you like to limit the list to Refusals that were recorded
 ;;within a specific date range?
 ;;
 D PRINTX("TEXT6")
 Q
 ;
 ;
 ;----------
TEXT7 ;EP
 ;;Ordinarilly Lists & Letters looks only at American Indians and Alaska
 ;;Natives, also known by the Beneficiary Type Code 01.
 ;;
 ;;Would you like to expand the list to include patients of all Beneficiary
 ;;Types (includes Dependents of Comm Officers, Retired Military, etc.)?
 ;;
 D PRINTX("TEXT7")
 Q
 ;
 ;
 ;----------
HELP2 ;EP
 ;;Enter a number which will be the minimum number of months
 ;;PAST DUE for patients to be included in the listing.
 ;;
 ;;For example, if you enter "3", then any patient with at least one
 ;;immunization 3 months or more past due would be included.  A patient
 ;;with an immunization only 2 months past due would not be included.
 ;;
 ;;NOTE: The months PAST DUE will be calculated from the Forecast/
 ;;      Clinic Date you select (not necessarily from today).
 D HELPTX("HELP2")
 Q
 ;
 ;
 ;----------
SEARCH(BITMPL) ;EP
 ;---> Select Search Template of patients.
 ;---> Parameters:
 ;     1 - BITMPL (ret) IEN of Search Template in File #.401, or
 ;                      BITMPL=-1 if lookup failed.
 ;
SEARCH1 ;
 D TITLE^BIUTL5("SEARCH TEMPLATE SELECTION")
 N BIA,BIS S BIPOP=0,BITMPL=""
 S BIA="     Select Patient SEARCH TEMPLATE name: "
 S BIS="I $P(^"_"(0),U,4)=2!($P(^(0),U,4)=9000001)"
 D DIC^BIFMAN(.401,"QEMA",.Y,BIA,,BIS)
 S BITMPL=+Y
 Q:BITMPL<1
 ;
 ;---> Display Template info for confirmation.
 D TITLE^BIUTL5("SEARCH TEMPLATE SELECTION")
 W !!?5,"You have selected the following Patient Search Template: "
 W !!?9,"Name...: ",$P(^DIBT(BITMPL,0),U)
 W !?9,"Created: ",$$TXDT1^BIUTL5($P(^DIBT(BITMPL,0),U,2))
 W " by ",$$PERSON^BIUTL1($P(^DIBT(BITMPL,0),U,5))
 W !?9,"Total..: "
 D
 .N M,N S M=0,N=0
 .F  S N=$O(^DIBT(BITMPL,1,N)) Q:'N  S M=M+1
 .W M," Patient",$S(M>1:"s",1:"")
 W !!?5,"Description: "
 W !?5,"------------ "
 D
 .I '$O(^DIBT(BITMPL,"%D",0)) W !?5,"None." Q
 .N I,N S N=0
 .F I=1:1:7 S N=$O(^DIBT(BITMPL,"%D",N)) Q:'N  D
 ..W !?5,$G(^DIBT(BITMPL,"%D",N,0))
 .D:$O(^DIBT(BITMPL,"%D",N))
 ..W !?5,"(More...see template for full description.)"
 ;
 W !
 N B,BIPOP S BIPOP=0
 S B="     Use this Template for your List? (Yes/No): "
 S B(1)="     Enter Yes to select this Template."
 S B(2)="     Enter No to select another Template."
 D DIR^BIFMAN("YA",.Y,,B,"Yes",B(2),B(1))
 ;
 ;---> Failed to confirm.
 I Y<1 D  G SEARCH1
 .W !?5,"Okay, let's begin again..." D DIRZ^BIUTL3()
 ;
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
HELPTX(BILINL,BITAB) ;EP
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
