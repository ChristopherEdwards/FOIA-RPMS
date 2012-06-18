BIOUTPT5 ;IHS/CMI/MWR - WRITE SUBHEADERS.; AUG 10,2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  WRITE SUBHEADER LINES TO ^TMP FOR REPORTS.
 ;;  v8.4 PATCH 1: Manage subheader Items more than 20.  SUBH+35
 ;
 ;
 ;----------
SUBH(BIAR,BITEM,BITEMS,BIGBL,BILINE,BIERR,BIPC,BITM,BIAPP) ;EP
 ;---> If specific Items were selected (not ALL), then list them
 ;---> in a subheader at the top of the report.
 ;---> Parameters:
 ;     1 - BIAR   (req) Array of Item IENs to be displayed.
 ;     2 - BITEM  (req) Categoric name of Items being displayed.
 ;     3 - BITEMS (opt) Plural form of Categoric Item name.
 ;                      Provide this only if it's an exception.
 ;     4 - BIGBL  (req) Item global OR File#-Field# for Set of Codes.
 ;     5 - BILINE (ret) Line number in ^TMP Listman array.
 ;     6 - BIERR  (ret) Error Code returned, if any.
 ;     7 - BIPC   (opt) Piece of Zero node to display as Item Name;
 ;                      default=1.
 ;     8 - BITM   (opt) Top Margin.
 ;     9 - BIAPP  (opt) Any text to be appended to the list, such as
 ;                      a date range.
 ;
 ;---> EXAMPLE:
 ;   D SUBH^BIOUTPT5("BICC","Community",,"^AUTTCOM(",.BILINE,.BIERR)
 ;
 ;
 ;---> Check/set required variables.
 S BIERR=""
 Q:$$CHECK(.BIERR)
 S:'$G(BITM) BITM=12
 ;
 ;---> Quit and don't write subheader if "ALL" Items were selected
 ;---> (or if NO Items were selected).
 Q:$O(@(BIAR_"(0)"))=""
 Q:$D(@(BIAR_"(""ALL"")"))
 ;
 ;---> Check/set plural form of Item Name.
 I $G(BITEMS)="" D PLURAL^BISELECT(BITEM,.BITEMS)
 ;
 ;
 ;********** PATCH 1, v8.4, AUG 01,2010, IHS/CMI/MWR
 ;---> If more than 20 subheader items and list is to the screen, simply
 ;---> state that and quit.
 N M,N S (M,N)=0
 F  S N=$O(@(BIAR_"(N)")) Q:'N  S M=M+1
 I M>20 I $G(IOSL)<25 D  Q
 .N X S X=" "_BITEMS_": More than 20; Print report or review "_BITEM_" parameter."
 .D WH^BIW(.BILINE,X)
 .D WH^BIW(.BILINE,$$SP^BIUTL5(79,"-"))
 ;**********
 ;
 ;
 ;---> If too much subheader text for screen, return error.
 I (BILINE>BITM)&($G(IOSL)<25) S BIERR=668 Q
 ;
 ;---> Alphabetize list.
 N BIAR1
 D
 .I +BIGBL D  Q
 ..;---> Set of Codes.
 ..N BISET S BISET=$P($G(^DD($P(BIGBL,"-"),$P(BIGBL,"-",2),0)),U,3)
 ..N N S N=0
 ..F  S N=$O(@(BIAR_"(N)")) Q:N=""  D
 ...S BIAR1($P($P(BISET,N_":",2),";"))=""
 .;
 .;---> Entries from a File.
 .S:'$G(BIPC) BIPC=1
 .N N S N=0
 .F  S N=$O(@(BIAR_"(N)")) Q:'N  D
 ..S BIAR1($$NAME(N,BIGBL,BIPC))=""
 ;
 ;---> Set X=string of Items, pieced by "; " (or Z).
 N BIHEAD,I,N,Y,Z
 S N=0,X="",Z="; "
 F I=1:1 S N=$O(BIAR1(N)) Q:N=""  D
 .S:I>1 X=X_Z S X=X_N
 ;---> Append any text such as date range.
 S:$G(BIAPP)]"" X=X_BIAPP
 S BIHEAD=" "_$S(I>2:BITEMS,1:BITEM)_": "
 ;
 ;---> Now write each line with as many Items as will fit on a line
 ;---> (hanging indent under the header "Item Name:").
 S N=1
 F  D  Q:$P(X,Z,I)=""  Q:$G(BIERR)
 .F I=N:1 S Y=$P(X,Z,N,I) Q:$L(Y)>63  Q:$P(X,Z,I)=""
 .I N>1 S BIHEAD=$$SP^BIUTL5($L(BIHEAD))
 .I (BILINE>BITM)&($G(IOSL)<25) S BIERR=668 Q
 .D WH^BIW(.BILINE,BIHEAD_$P(X,Z,N,I-1))
 .S N=I
 ;
 D WH^BIW(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
 ;
 ;
 ;----------
NAME(BIIEN,BIGBL,BIPC) ;EP
 ;---> Return the .01 for this IEN in BIGBL.
 ;---> Parameters:
 ;     1 - BIIEN  (req) IEN of Item.
 ;     2 - BIGBL  (req) Item global.
 ;     3 - BIPC   (opt) Piece of Zero node to display (default=1).
 ;
 Q:'$G(BIIEN) 0  Q:$G(BIGBL)="" 0
 N X S:'$G(BIPC) BIPC=1
 S X=$P(@(BIGBL_BIIEN_",0)"),U,BIPC)
 Q:X="" 0
 Q X
 ;
 ;
 ;---> First, build array sorted by ItemName.
 N BIIEN S BIIEN=0
 F  S BIIEN=$O(@(BIARR1_"(BIIEN)")) Q:'BIIEN  D
 .;
 .;---> If IEN passed does not really exist in the File,
 .;---> remove it from the Selection Array.
 .I '$D(@(BIGBL_"BIIEN,0)")) K @(BIARR1_"(BIIEN)") Q
 .;
 .;---> If (previously stored) IEN does not pass the screen,
 .;---> then remove it from the Selection Array.
 .I BISCRN]"" N Y S Y=BIIEN X BISCRN I '$T K @(BIARR1_"(BIIEN)") Q
 .;
 .N BI0,BINAME,BIIDTX
 .S BI0=@(BIGBL_"BIIEN,0)")
 .S BINAME=$P(BI0,U,BIPIECE)
 .Q:BINAME=""
 Q
 ;
 ;
 ;----------
CHECK(BIERR) ;EP
 ;---> Check required variables.
 ;---> Parameters:
 ;     1 - BIERR (ret) Error Code returned, if any.
 ;
 ;---> Check that Subheader Array name is present.
 I $G(BIAR)="" S BIERR=656 Q 1
 ;
 ;---> Check that Categoric Item name is present.
 I $G(BITEM)="" S BIERR=657 Q 1
 ;
 ;---> Check Item global.
 I $G(BIGBL)="" S BIERR=658 Q 1
 ;
 ;---> Check that the Global or Set of Codes is legitimate.
 S BIERR=""
 D  Q:BIERR 1
 .I +BIGBL D  Q
 ..;---> Test for Set of Codes.
 ..N X,Y S X=$P(BIGBL,"-"),Y=$P(BIGBL,"-",2)
 ..I 'Y S BIERR=665 Q
 ..I '$D(^DD(X,Y,0)) S BIERR=665 Q
 .;
 .;---> Test for global (entries from a file).
 .I '$D(@(BIGBL_"0)")) S BIERR=659 Q
 ;
 Q 0
 ;
 ;
 ;----------
RYEAR(BIYEAR,BIRTN) ;EP
 ;---> Ask the Report Year.
 ;---> Called by Protocol BI OUTPUT REPORT YEAR.
 ;---> Parameters:
 ;     1 - BIYEAR (ret) Report Year in yyyy format.
 ;                (opt) Default Year.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 N DIR,DIRA,DIRB,DIRQ,DIRNOW,BIPOP
 S:$G(BIYEAR) DIRB=+BIYEAR
 D
 .I '$G(DT) S DIRNOW=2050 Q
 .S DIRNOW=1700+$E(DT,1,3)
 S DIRA="   Please enter a Report Year: "
 S:$G(BIYEAR) DIRB=+BIYEAR
 S DIRQ="   Enter a year between 1950 and the present, in the form yyyy"
 D FULL^VALM1
 D TITLE^BIUTL5("SELECT REPORT YEAR")
 D TEXT1 W !
 D DIR^BIFMAN("NAO^1950:"_DIRNOW,.Y,.BIPOP,DIRA,DIRB,DIRQ)
 I $G(BIPOP) D @("RESET^"_BIRTN) Q
 S BIYEAR=+Y
 I Y<1 D @("RESET^"_BIRTN) Q
 ;
 N DIR
 W !!?3,"You may select an End Date of either December 31, ",+BIYEAR
 W " or March 31, ",(+BIYEAR)+1,".",!
 S DIR("A")="   Select December or March: "
 S DIR("B")=$S($P(BIYEAR,U,2)="m":"March",1:"December")
 S DIR(0)="SAM^d:December;m:March"
 D ^DIR K DIR
 I Y=-1!($D(DIRUT)) D @("RESET^"_BIRTN) Q
 ;---> If Y="m" concate to BIYEAR to signify End Date of March 31.  Otherwise,
 ;---> default is 2nd "^"-piece of BIYEAR=""--which is End Date of Dec 31.
 I Y="m" S BIYEAR=BIYEAR_U_"m"
 ;
 D @("RESET^"_BIRTN)
 ;
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;The "Report Year" represents the start of a particular influenza
 ;;season.  So, for example, 2011 will cover the influenza season from
 ;;September 1, 2011 until December 31, 2011 (or until March 31, 2012,
 ;;if that End Date is chosen).
 ;;
 ;;The patient ages in the report will be calculated as of 12/31 of the
 ;;Report Year you select (12/31/2011 in the above example).
 ;;
 D PRINTX("TEXT1")
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
TEXT11(BITEXT) ;EP
 ;;In producing lists and letters, you may select the group of patients
 ;;you wish to include by specifying attributes of this screen, such as
 ;;"DUE" or "ACTIVE."  These attributes may also be used in various
 ;;combinations in order to further specify your patient group.
 ;;(This group may be further limited by the other criteria you select
 ;;on the main IMMUNIZATION LISTS & LETTERS Main Screen, such as Age Range,
 ;;Communities, Lot Numbers, etc.)
 ;;
 ;;                               DUE
 ;;                              -----
 ;;"DUE" will list all Active patients who are DUE for immunizations,
 ;;subject to any other limitations on the Lists & Letters Main Screen,
 ;;such as Age Range, Community, etc..  "DUE" will also necessarily include
 ;;any patients who are "PAST DUE."  By default, "DUE" will only include
 ;;patients who are "ACTIVE" unless you specify "INACTIVE" as one of the
 ;;attributes.
 ;;
 ;;                             PAST DUE
 ;;                            ----------
 ;;"PAST DUE" will only include patients who are past their due dates
 ;;for one or more immunizations.  If you select this attribute, you
 ;;will be given the opportunity to specify how many months past due
 ;;you wish to check for.  By default, "PAST DUE" will only include
 ;;patients who are "ACTIVE" unless you specify "INACTIVE" as one of the
 ;;attributes.
 ;;
 ;;                        ACTIVE and INACTIVE
 ;;                       ---------------------
 ;;The choices of "ACTIVE" and "INACTIVE" will simply list patients in the
 ;;Immunization Database who have the Statuses of Active or Inactive.
 ;;"ACTIVE" and "INACTIVE" may also be used together to produce a list
 ;;of all patients in the Immunization database.
 ;;
 ;;
 ;;                      AUTOMATICALLY ACTIVATED
 ;;                     -------------------------
 ;;"AUTOMATICALLY ACTIVATED" will restrict the list to only those patients
 ;;who were Automatically Activated in the Immunization database.  You may
 ;;combine it with other attributes, such as ACTIVE or DUE, to produce a
 ;;list that is more specific.  For example, you could produce a list of
 ;;patients who were AUTOMATICALLY ACTIVATED and are now PAST DUE.
 ;;
 ;;
 ;;                            REFUSALS
 ;;                           ----------
 ;;"REFUSALS" will restrict the list to only those patients who at some
 ;;point refused an immunization (either the patient or the parent).
 ;;You may combine REFUSALS with other attributes in order to produce a
 ;;list that is more specific.  For example, you could produce a list of
 ;;patients who were both INACTIVE and had REFUSALS on record.
 ;;
 ;;
 ;;                          FEMALES ONLY
 ;;                         --------------
 ;;"FEMALES ONLY" will restrict the list to female patients only.
 ;;NOTE: The list will include both "ACTIVE" and "INACTIVE" female
 ;;patients unless you have specifically chosen Active or Inactive.
 ;;
 ;;
 ;;                        SEARCH TEMPLATES
 ;;                       ------------------
 ;;SEARCH TEMPLATEs are groups of individual patients that have been
 ;;produced and stored by other software, usually QMAN, and saved under
 ;;a Template Name.  If you choose this attribute, you will be asked to
 ;;select from a file of existing Search Templates.
 ;;
 ;;NOTE: A SEARCH TEMPLATE is a pre-defined group of patients and cannot
 ;;be combined with any of the other attributes.
 ;;For more information about Search Templates and how to create your
 ;;own, contact your computer support people for training.
 ;;
 ;;
 ;;Final note: The implications of combining too many restrictive attributes
 ;;can be difficult to predict and may produce few or no results.
 ;;It is best to limit a list to two or three combined attributes.
 ;;
 D LOADTX("TEXT11",,.BITEXT)
 Q
 ;
 ;
 ;----------
LOADTX(BILINL,BITAB,BITEXT) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
 Q
