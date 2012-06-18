ACDEDE1 ;IHS/ADC/EDE/KML - DOCUMENTATION ON V4;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
0 ;Met with Wilbur Woodis for two days and discussed what needed to be
 ;done to CDMS.
 ;
1 ;Wrote a driver routine for data entry add mode which preasks for key
 ;pieces of information such as component code/type, primary provider,
 ;type contact, and patient, then generates the appropriate visit by
 ;calling FILE^DICN.  Entries are generated in subordinate files by
 ;input templates using file shifts.  The routines does logical checks
 ;such as insuring there is an INITIAL prior to entering other types
 ;of services.  There are other logical checks.  The sequence the items
 ;are asked for is based on the normal mode of processing forms.  Forms
 ;are grouped by component code/type, then by primary provider, then
 ;by type contact and patient if appropriate.
 ;
2 ;Display the visit history for a patient if an illogical entry is
 ;attempted.
 ;
3 ;Display the client service history when a client service visit is
 ;generated or selected.
 ;
4 ;Deleted the option to add additional client services.  This is no
 ;longer needed because of the driver in 1 above.  If there is no
 ;client service one is generated.  If one already exists the new
 ;client services are attached to the existing visit.
 ;
5 ;Modified the data entry routine for client categories to use the
 ;patient demographic logic developed in the driver in 1 above.  Also
 ;added component code/type to the client category dictionary so the
 ;patients being added could be checked for the existence of an INITIAL
 ;type contact.
 ;
6 ;Changed the way the autoduplication of client services works.  It
 ;will now duplicate a new client service visit with or without any
 ;associated client services.  It will now duplicate additional cleint
 ;services added to a visit at a later time.
 ;
7 ;Added a new option to display the visit history of selected patients.
 ;
8 ;Developed a technique to keep track of patients who are temporarily
 ;absent without requiring a transfer or discharge.  Added TP and RTP
 ;to CDMIS SERVICE file.
 ;
9 ;Added OTHER to CDMIS SERVICE file.
 ;
10 ;Deleted 10 NOT IN USE FOR NOW from CDMIS LOCATION file.  This will
 ;require a post-init for the next install.
 ;
11 ;Changed 30 PHYSICAL ABUSE SPOUSE to 30 DOMESTIC VIOLENCE in the CDMIS
 ;PROBLEM file.
 ;
12 ;Deleted 1 NOT USED, 98 NO DRUGS, 99 NO ALCOHOL, and N NOT USED from
 ;CDMIS DRUG TABLE.  This will require a post-init for the next
 ;install.
 ;Add 20 ALCOHOL to above list.
 ;
13 ;Changed VAA to VA & Veterans Admin in the CDMIS COMPONENT file.
 ;
14 ;Changed set in file 9002171 field 19 from
 ;NO FURTHER SVCS REQUIRED,THIS COMP/PROG to
 ;NO FURTHER SVCS REQUIRED/COMPLETED TREATMENT
 ;
15 ;Deleted 1 1 and 10 (NOT TO BE USED) from the CDMIS PREVENTION
 ;ACTIVITIES file.  This will require a post-init for the next install.
 ;
16 ;Add 18 TRANSPORTATION to the CDMIS PREVENTION ACTIVITIES file.
 ;
17 ;Standardized all component type sets to be:
 ; A = ADULT
 ; Y = YOUTH
 ; M = MIXED (ADULT&YOUTH)
 ; F = FAMILY
 ; E = ELDERLY ONLY
 ; W = WOMEN ONLY
 ; S = STAFF
 ;
170 ;Modified ^ACDAGRG (the routine that computes the age range) and all
 ;appropriate dictionaries to: 0-13=1, 14-18=2, 19-24=3, 25-34=4,
 ;                            35-44=5, 45-54=6, 55-64=7, 65-74=8, 75+
 ;This will require a recomputation during the v4 postinit.
 ;
18 ;Resolved problem at PIMC where CDMIS operator could not select the
 ;appropriate patient because he was an employee of PIMC.
 ;
19 ;Resolved problem with Terry Nix in Alaska where he could not do an
 ;extract of version 4 CDMIS data.
 ;
20 ;Added functionality to allow user to edit records just generated.
 ;Can edit init/info/fu, trans/disc/close, and client svcs.
