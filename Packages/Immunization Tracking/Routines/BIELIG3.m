BIELIG3 ;IHS/CMI/MWR - SCAN TO REMOVE VFC FOR IMMS WITH PATS>19YRS; APR 15, 2012
 ;;8.5;IMMUNIZATION;**3**;SEP 10,2012
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  SCAN PATIENT DATABASE FOR PATIENTS <36 MTHS NOT IN IMM DB.
 ;   PATCH 2: This is a completely new routine to scan for and correct any
 ;            immunization visits in which the patient was 19yrs or older
 ;            and erroneously marked as VFC Eligible at the time of the visit.
 ;
 ;   PATCH 3: Scan for any V Imms with a .14 Eligibility=0, change to 8,
 ;            which is the IEN of "Unknown" in the new BI TABLE ELIG File.
 ;            Null values will be left null.                       SCAN+43
 ;
 ;----------
START ;EP
 ;---> Scan for patients in ^AUPNPAT <36 mths not in Imm database ^BIP.
 ;
 D SETVARS^BIUTL5
 D
 .;D PROMPT(.BIPOP)
 .;Q:BIPOP
 .D SCAN
 D EXIT(BIPOP)
 Q
 ;
 ;
 ;----------
PROMPT(BIPOP) ;EP
 ;---> Describe conversion.
 ;     1 - BIPOP (ret) BIPOP=1 If quit, fail, DTOUT, DUOUT.
 ;
 N Z S Z="",BIPOP=0,Z="YES"
 D TITLE,TEXT1
 W ! D DIRZ^BIUTL3(.BIPOP) Q:BIPOP
 Q
 ;
 ;
 ;----------
SCAN ;EP
 ;---> Scan V Imm file of VFC Eligibility inappropriate age.
 ;
 N BICOUNT,BIERR,BIFACT,BIX,BIY,N
 ;
 ;---> Check for DUZ(2).
 I '$G(DUZ(2)) D ERRCD^BIUTL2(105,,1) Q
 ;
 W !!?12,"Please hold..."
 ;
 ;---> Get total number of visits to be checked (for progress bar below).
 S BIFACT=1
 S N=3080901 F  S N=$O(^AUPNVIMM("ADT",N)) Q:'N  D
 .N M S M=0 F  S M=$O(^AUPNVIMM("ADT",N,M)) Q:'M  D
 ..N P S P=0 F  S P=$O(^AUPNVIMM("ADT",N,M,P)) Q:'P  S BIFACT=BIFACT+1
 ;
 S:BIFACT<1 BIFACT=1 S BIFACT=BIFACT\50
 S (BIPOP,BIX,BIY)=0
 ;
 D TITLE
 W !!?12,"Repointing visits with Eligibility Unknown to new table..."
 W !!?12,"0%---10---20---30---40---50---60---70---80---90---100%"
 W !?12,"|"
 ;
 ;
 ;---> Loop through the V Imm global, looking for VFC=Am Indian/AK Native
 ;---> inappropriate for age (19yrs or greater) at time of visit.
 ;
 ;                  date  visit vimm ien
 ;^AUPNVIMM("ADT",3071110,2102,2300)=""
 ;
 ;                   vac dfn visit       vfc(pc14)
 ;^AUPNVIMM(2300,0)="133^6^2102^^^^^^^^^^^"
 ;
 ;^AUPNVSIT(2102,0)="3071110.12^3080508^I^^6^1665^E^^8^^^^3080508^
 ;
 S N=3080901,BICOUNT=0
 F  S N=$O(^AUPNVIMM("ADT",N)) Q:'N  D
 .N M S M=0 F  S M=$O(^AUPNVIMM("ADT",N,M)) Q:'M  D
 ..N P S P=0 F  S P=$O(^AUPNVIMM("ADT",N,M,P)) Q:'P  D
 ...S BIX=BIX+1 I BIFACT,'(BIX#BIFACT)&(BIY<51) W "=" S BIY=BIY+1
 ...N BI0 S BI0=$G(^AUPNVIMM(P,0))
 ...Q:(BI0="")
 ...;********** PATCH 3, v8.5, SEP 10,2012, IHS/CMI/MWR
 ...;---> Repointing visits with Eligibility Unknown to new table.
 ...I $P(BI0,U,14)=0 S $P(^AUPNVIMM(P,0),U,14)=8
 ...Q
 ...;**********
 ...;
 ...;
 ...;---> Quit if Elig Code is not Am In/AK Na.
 ...;Q:($P(BI0,U,14)'=4)
 ...;N BIDATE,BIDFN S BIDATE=N,BIDFN=$P(BI0,U,2)
 ...;---> Quit if age on date of visit was less than 19yrs.
 ...;Q:($$AGE^BIUTL1(BIDFN,1,BIDATE)<19)
 ...;---> Okay, patient was 19yrs or greater and had Elig Code=4, so set
 ...;---> piece 14="" and update BICOUNT.
 ...;S $P(^AUPNVIMM(P,0),U,14)="",BICOUNT=BICOUNT+1
 ;
 N BII F BII=1:1:50-BIY W "="
 W "|",!?33,"Complete"
 ;W !!?12,"Immunization visits corrected for VFC Eligibility: ",BICOUNT
 ;W !!!!!! D DIRZ^BIUTL3(.BIPOP) Q:BIPOP
 W !!!!!! D DIRZ^BIUTL3()
 ;
 Q
 ;
 ;
 ;----------
CHGPTR(BICHG) ;EP
 ;---> Change all records with one vaccine pointer to a different one.
 ;---> Parameters:
 ;     1 - BICHG   (opt) IF BICHG=1 then change entries from 214 to 235.
 ;
 D SETVARS^BIUTL5
 D KGBL^BIUTL8("^MIKE") S ^MIKE(0)=^AUPNVIMM(0)
 N BICOUNT,BIECOUNT,BIN S BIN=0,BICOUNT=0,BIECOUNT=0
 F  S BIN=$O(^AUPNVIMM(BIN)) Q:'BIN  D
 .N BIERR S BIERR=0
 .Q:($P(^AUPNVIMM(BIN,0),U)'=214)
 .S BICOUNT=BICOUNT+1
 .Q:('$G(BICHG))
 .S ^MIKE(BIN,0)=^AUPNVIMM(BIN,0)
 .;
 .;---> Change .01 pointer to VAccine Table.
 .N BIFLD S BIFLD(.01)=235
 .D FDIE^BIFMAN(9000010.11,BIN,.BIFLD,.BIERR)
 .I BIERR=1 S BIECOUNT=BIECOUNT+1,^MIKE("ERR",N)=""  Q
 ;
 W !!,"COUNT: ",BICOUNT
 W !,"ERRORS: ",BIECOUNT
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;
 ;;This program will scan the immunizations recorded in RPMS from
 ;;September 2008 to the present for any VFC Eligibility Codes that
 ;;would have been inappropriate for the patient's age on the day of
 ;;the immunization visit.
 ;;
 ;;For any given immunization visit, if the patient was 19 years of age
 ;;or older and incorrectly recorded as VFC Eligible (American Indian or
 ;;Alaska Native), the Eligibility code for that visit will be permanently
 ;;removed.  All other data will remain unchanged.
 ;;
 ;;This will prevent such visits from causing problems in future reports
 ;;and exports to state registries.
 ;;
 ;;NO other data or immunizations visits are changed by this process.
 ;;
 D PRINTX("TEXT1",5)
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
EXIT(BIPOP) ;EP
 ;---> EOJ Cleanup.
 ;---> Parameters:
 ;     1 - BIPOP   (opt) BIPOP=1 if DTOUT or DUOUT
 ;
 D:$G(BIPOP)
 .W !!?5,"* SCAN ABORTED. *" D DIRZ^BIUTL3()
 N BIPOP
 D KILLALL^BIUTL8(1)
 Q
 ;
 ;
 ;----------
TITLE ;EP
 D TITLE^BIUTL5("UPDATING VISITS WITH ELIGIBILITY UNKNOWN")
 Q
