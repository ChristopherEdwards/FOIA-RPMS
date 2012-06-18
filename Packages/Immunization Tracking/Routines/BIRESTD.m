BIRESTD ;IHS/CMI/MWR - CHECK AND RESTANDARDIZE VACCINE TABLE.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CHECK IMMUNIZATION (VACCINE) TABLE AGAINST HL7 STANDARD;
 ;;  RESTANDARDIZE IF NECESSARY.
 ;
 ;----------
CHKSTAND(BIERROR) ;EP
 ;---> Check the Vaccine Table (IMMUNIZATION File #9999999.14)
 ;---> against the HL7 Standard Table (BI IMMUNIZATION TABLE
 ;---> HL7 STANDARD File #9002084.94), each entry, piece by piece.
 ;---> If there is an error, return the Error Text and set ^BISITE(-1)
 ;---> to act as a flag for other calls.
 ;---> Parameters:
 ;     1 - BIERROR (ret) BIERROR=Text.
 ;
 S BIERROR=""
 ;
 ;---> If Vaccine globals do not exist, return Error Text and quit.
 I '$D(^AUTTIMM(0))!('$D(^BITN(0))) D  Q
 .D ERRCD^BIUTL2(505,.BIERROR) S ^BISITE(-1)=""
 ;
 ;---> If there are any non-standard entries in the Vaccine Table,
 ;---> return Error Text, set ^BISITE(-1), and quit.
 N N S N=0
 F  S N=$O(^AUTTIMM(N)) Q:'N  D  Q:BIERROR]""
 .I '$D(^BITN(N,0)) D ERRCD^BIUTL2(508,.BIERROR)
 I BIERROR]"" S ^BISITE(-1)="" Q
 ;---> NOTE: If ^AUTTIMM(0) does not exist, set it ="IMMUNIZATION^9999999.14I"
 ;--->       then restandardize.
 ;--->       Likewise, ^BITN(0)="BI IMMUNIZATION TABLE HL7 STANDARD^9002084.94"
 ;
 ;---> Now check every Standard piece of the Vaccine Table.
 ;---> If any Standard piece of data of a Vaccine is non-standard,
 ;---> return Error Text, set ^BISITE(-1), and quit.
 S N=0
 F  S N=$O(^BITN(N)) Q:'N  D  Q:BIERROR]""
 .I '$D(^AUTTIMM(N,0)) D ERRCD^BIUTL2(503,.BIERROR) Q
 .;---> The following fields are copied below in COPYNEW, but are not checked
 .;---> as part of the standard: 7-Active, 13-VIS Def, 16-Include in Forecast,
 .;---> 18-Def Volume.
 .N BIPC F BIPC=1,2,3,8,9,10,11,12,14,15,17,21:1:26 D
 ..I $P(^AUTTIMM(N,0),U,BIPC)'=$P(^BITN(N,0),U,BIPC) D
 ...D ERRCD^BIUTL2(503,.BIERROR)
 I BIERROR]"" S ^BISITE(-1)="" Q
 ;
 ;---> Clear Non-standard flag.
 K ^BISITE(-1)
 Q
 ;
 ;
 ;----------
RESTAND(BIERROR,BIPRMPT) ;EP
 ;---> Restandardize the Vaccine Table (IMMUNIZATION File #9999999.14)
 ;---> by copying from the HL7 Standard Table (BI IMMUNIZATION TABLE
 ;---> HL7 STANDARD File #9002084.94).
 ;---> Parameters:
 ;     1 - BIERROR (ret) BIERROR=Text (Translation Table is corrupt).
 ;     2 - BIPRMPT (opt) If BIPRMPT=1 report "Complete".
 ;
 S:'$G(BIPRMPT) BIPRMPT=""
 S BIERROR=""
 I '$D(^AUTTIMM(0))!('$D(^BITN(0))) D  Q
 .D ERRCD^BIUTL2(505,.BIERROR,1)
 ;
 ;---> First, rebuild ^BITN global.
 D ^BITN
 ;
 ;---> Remove any non-standard entries in the Vaccine Table.
 N N S N=0
 F  S N=$O(^AUTTIMM(N)) Q:'N  D
 .I '$D(^BITN(N,0)) K ^AUTTIMM(N)
 ;
 ;---> Copy every HL7 Standard Table piece to the Vaccine Table.
 D COPYNEW(.BIERROR)
 ;
 ;---> RestandardizE the Vaccine Manufacturer Table.
 Q:BIERROR
 W:BIPRMPT>0 !!?5,"Restandardization of Vaccine Table complete."
 D RESTDMAN(.BIERROR)
 Q:BIERROR  D:BIPRMPT>0
 .W !?5,"Restandardization of Manufacturer Table complete."
 .D DIRZ^BIUTL3()
 ;
 ;---> Clear Non-standard flag.
 K ^BISITE(-1)
 Q
 ;
 ;
 ;----------
COPYNEW(BIPOP) ;EP
 ;---> Copy New Standard to Vaccine Table (IMMUNIZATION File).
 ;---> Parameters:
 ;     1 - BIPOP (ret) BIPOP=1 if Translation Table is corrupt.
 ;
 S BIPOP=0
 I '$O(^BITN(0)) D ERRCD^BIUTL2(505,,1) S BIPOP=1 Q
 N BIN S BIN=0
 F  S BIN=$O(^BITN(BIN)) Q:'BIN  Q:BIPOP  D
 .I '$D(^BITN(BIN,0)) D ERRCD^BIUTL2(505,,1) S BIPOP=1 Q
 .;
 .;---> Copy HL7 Standard Table pieces to the Vaccine Table.
 .;---> Imm v8.3: Remove .07 field, "ACTIVE"; (leave local site setting).  vvv83
 .N BIPC F BIPC=1,2,3,8,9,10,11,12,13,14,15,16,17,18,21:1:26 D
 ..S $P(^AUTTIMM(BIN,0),U,BIPC)=$P(^BITN(BIN,0),U,BIPC)
 .;
 .;---> Set Status, .07, if not already set (i.e., don't overwrite local settings).
 .I $P(^AUTTIMM(BIN,0),U,7)="" S $P(^AUTTIMM(BIN,0),U,7)=$P(^BITN(BIN,0),U,7)
 .;
 .Q:'$D(^BITN(BIN,1))
 .;---> Reset 1 node as well.  Include 1.15 - vvv83.
 .F BIPC=1:1:15 S $P(^AUTTIMM(BIN,1),U,BIPC)=$P(^BITN(BIN,1),U,BIPC)
 ;
 ;---> Now re-index all indices on the file.
 D REIND1
 Q
 ;
 ;
 ;----------
REIND1 ;EP
 ;---> Re-index IMMUNIZATION File, ^AUTTIMM(.
 ;---> First, remove all previous Vaccine Table indices.
 N BIN S BIN="A"
 F  S BIN=$O(^AUTTIMM(BIN)) Q:BIN=""  K @("^AUTTIMM("""_BIN_""")")
 ;
 ;---> Now re-index table.
 S BIN=0
 F  S BIN=$O(^AUTTIMM(BIN)) Q:'BIN  D
 .N DA,DIK S DA=BIN,DIK="^AUTTIMM("
 .D IX1^DIK
 Q
 ;
 ;
 ;----------
RESTDMAN(BIPOP) ;EP
 ;---> Standardardize 100+ Entries in Manufacturer Table, ^AUTTIMAN.
 ;---> Parameters:
 ;     1 - BIPOP (ret) BIPOP=1 Error.
 ;
 S ^AUTTIMAN(0)="IMM MANUFACTURER^9999999.04I"
 N N S N=99
 F  S N=$O(^BIMAN(N)) Q:'N  D
 .S ^AUTTIMAN(N,0)=^BIMAN(N,0)
 D REIND2
 ;
 Q
 ;
 ;
 ;----------
REIND2 ;EP
 ;---> Re-index IMM MANUFACTURER File, ^AUTTIMAN(.
 ;---> First, remove all previous indices.
 N BIN S BIN="A"
 F  S BIN=$O(^AUTTIMAN(BIN)) Q:BIN=""  K @("^AUTTIMAN("""_BIN_""")")
 ;
 ;---> Now re-index table.
 S BIN=0
 F  S BIN=$O(^AUTTIMAN(BIN)) Q:'BIN  D
 .N DA,DIK S DA=BIN,DIK="^AUTTIMAN("
 .D IX1^DIK
 Q
