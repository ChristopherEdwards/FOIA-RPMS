ACDNOTE1 ;IHS/ADC/EDE/KML - NEW FEATURES IN V4 ;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;Routine ACDVIMP has been modified to now call the black box
 ;(i.e., ^%ZISH) so a dos box import should now work just as a
 ;unix import works.
 ;
 ;All reports will now run by state. I did the same exact code
 ;changes/updates as I did with the tribal report changes that
 ;are listed above in routine ACDNOTE
 ;With state codes, many patients in 9000001 seem to be missing
 ;the required field CURRENT COMMUNITY PNT (pnt to ^AUTTCOM) and
 ;if the same holds true in the field, the reports may not be as
 ;accurate as need be.
 ;
 ;ACDVIMP now asks the user importing data which directory to
 ;look in for import files. I no longer assume /usr/spool/uucppublic
 ;and this improves the functionality of the dos import.
 ;
 ;If reports run are the first set ^ACDWDRV1, a restriction of
 ;output by contact type is now asked. The results are on the
 ;header of the report.
 ;
 ;The Financial Data extract utilities and import utilities are
 ;now operational. The extract utilitiy for program data and
 ;for visit data may now be transmitted via mail servers so it
 ;is highly suggested that as part of on site training you help
 ;the sites set up their net mail.
 ;
 ;A procedure has been established for HQ archiving. Code changes
 ;include the ability for HQ to extract data to a host file (i.e.,
 ;ACDF/ACDP910000.214) so any file containing '9' as first digit
 ;will be an archive file. HQ may then delete data from the system
 ;using the appropriate delete option on the supervisor menu.
 ;
 ;There is a new option to preset server domains which are
 ;destination address in which to send CDMIS extracted data.
 ;These servers may run at 100% automation which means that the
 ;area's will not have to import data if they use this feature.
 ;
 ;On the supervisor Menu, all menu text has been changed to
 ;include where the menu item may be run (i.e., area/fac/HQ) and
 ;this will simplify the security key allocation at time of
 ;install of cdmis 4.
 ;
 ;All CDMIS site manager utilities (Most are on the Supervisor Menu)
 ;have been enhanced and improved to make easier the task of managing
 ;the cdmis data base. This includes resetting extract data flags,
 ;purging data, archiving data, deleting data, and installing data.
 ;
 ;All new security keys are being used to simplify the assignment
 ;of /option/key/user. Example: OPTION ACD SUPER0  KEY ACDZSUPER0
 ;                                     ACD SUPER1  KEY ACDZSUPER1
 ;
 ;                                     ACD SUPER9  KEY ACDZSUPER9
 ;                                           etc.
 ;
 ;The July 1995 release of CDMIS version 4.0 has the capability of
 ;generating PCC visits from CDMIS visits.  If this is done bills
 ;can be generated using the IHS 3rd party billing package.
 ;Version 4.0 also has the capability of generating a hardcopy of
 ;each CDMIS visit from which a bill can be created manually.
 ;
 ;The PCC side of the link is not being released until November of
 ;1995 so only alpha/beta test sites will be able to use this
 ;feature.
