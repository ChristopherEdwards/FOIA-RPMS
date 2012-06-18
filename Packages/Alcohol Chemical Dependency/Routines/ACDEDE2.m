ACDEDE2 ;IHS/ADC/EDE/KML - DOCUMENTATION FOR V4;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
21 ;Modified followup to drop out of enter mode if unable to obtain
 ;information.
 ;
22 ;Added STATUS field to a couple of dictionaries.  Set as follows:
 ;1=Early Full Remission, 2=Early Partial Remission, 3=Sustained full
 ;remission, 4=Sustained Partial Remission, 5=Maintaining Sobriety
 ;Used for tdc and fu.
 ;
23 ;Created a file to store copy sets of selected client services.  Wrote
 ;logic to allow generating client service records for a copy set
 ;instead of one client service at a time.
 ;
24 ;Reversed smokless tobacco and smoking tobacco to be tobacco
 ;(smokless) and tobacco (smoking) in CDMIS DRUG file.
 ;
25 ;Created new option/routine to display a client's visit and all
 ;associated file entries.
 ;
26 ;Demonstrated system to local psg.  They want to bring it up soon
 ;as Alpha test.
 ;
27 ;Discussed PCC link with Lori and Jim Mccain.  Will propose we
 ;impliment it in version 4.
 ;
28 ;Changed CDMIS PROBLEM file entry DUAL DIAGNOSIS 8 to DUAL DISORDER
 ;8.
 ;
29 ;Created print template for CDMIS QUARTERLY/ANNUAL data.
 ;
30 ;Created new option ACD 2REP to generate annual report using template
 ;from item 29.
 ;
31 ;Modified reports option so ACD 2REP is executed instead of old report
 ;menu.
 ;
32 ;Changed mnemonics for all menus except supervisor menu to be more
 ;meaningful.
 ;
33 ;Modified routines that display a patient's visit history and display
 ;a selected visit with its associated subordiante file entry so that
 ;the output can go to a printer.
 ;
34 ;Made routine changes recommended by Nashville beta test site.
 ;
35 ;Note for v4 distribution:  The following globals are sent via a
 ;^%GS.
 ;
 ;^ACDCASH                    9002173.4
 ;^ACDCCT                     9002173.6
 ;^ACDCOMP                    9002170.1
 ;^ACDDRUG                    9002170.5
 ;^ACDJBDT                    9002174.2
 ;^ACDLOT                     9002170.8
 ;^ACDPLEX                    9002170.4
 ;^ACDPREV(9002170.9          9002170.9
 ;^ACDPROB                    9002170.3
 ;^ACDSERV                    9002170.6
 ;^ACDSTFC                    9002174.1
 ;
36 ;XB routines modified are: XBBPI, XB, XBFMK, XBPFTV
 ;
37 ;Wrote pre-init routine to do the following:
 ;
 ;Repointed fields in CDMIS PREVENTION (9002170.7) and CDMIS CLIENT
 ;SCS (9002172) that pointed to the CDMIS LOCATION (9002170.8) file
 ;to entry NOT IN USE FOR NOW code 10 to point to OTHER code 8.
 ;
 ;Deleted entries in CDMIS INIT/INFO/FU DRUG TYPE multiple that pointed
 ;to entries NOT USED code I, NO DRUGS code 98, NO ALCOHOL code 99, NOT
 ;USED code N, and ALCOHOL code 20 in the CDMIS DRUG TABLE.  Also
 ;deleted those entries from the CDMIS DRUG TABLE.
 ;
 ;Repointed fields in CDMIS PREVENTION (9002170.7) that pointed to the
 ;CDMIS PREVENTION ACTIVITIES (9002170.9) file to entry (NOT TO BE USED)
 ;code 10 to point to OTHER code 20.
 ;
 ;Recomputed age range for all entries in the CDMIS VISIT (9002172.1)
 ;file and the CDMIS CLIENT CATEGORY file.  If age was missing the age
 ;was computed from the patient's DOB.
 ;
38 ;Wrote routine to generate a face sheet from the INITIAL type contact
 ;and created a new option for this purpose. Added the call of this
 ;routine to data entry add routine when an IN is added so face sheet
 ;can be generated at that time.
 ;
39 ;Wrote edit routine and input templates and replaced old edit option
 ;with new edit option.
 ;
40 ;Created new secondary data entry menu and moved low use items to new
 ;menu because main menu was getting cluttered.
