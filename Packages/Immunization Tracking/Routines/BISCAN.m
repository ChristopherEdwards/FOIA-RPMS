BISCAN ;IHS/CMI/MWR - SCAN PATIENT DB FOR <36 MTHS, ADD TO IMM DB; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  SCAN PATIENT DATABASE FOR PATIENTS <36 MTHS NOT IN IMM DB.
 ;;  PATCH 1: Correct Age Range in report from 1-36 to 0-35.  REVIEW+9
 ;;           Also disabled PREVINA (no longer stuffing previously inactive).
 ;;           Also "please hold..." prompt while getting patient total. SCAN+11
 ;;           Also do not add patient if Ineligible in Registration.  SCAN+40
 ;
 ;----------
START ;EP
 ;---> Scan for patients in ^AUPNPAT <36 mths not in Imm database ^BIP.
 ;
 D SETVARS^BIUTL5 S BIPOP=0 N BICC
 D
 .D PROMPT(.BICC,.BIPOP) Q:BIPOP
 .Q:BIPOP
 .D SCAN(.BICC,.BIPOP) Q:BIPOP
 .D REVIEW
 D EXIT(BIPOP)
 Q
 ;
 ;
 ;----------
PROMPT(BICC,BIPOP) ;EP
 ;---> Describe conversion.
 ;     1 - BICC  (ret) Current Community array.
 ;     2 - BIPOP (ret) BIPOP=1 If quit, fail, DTOUT, DUOUT.
 ;
 N Z S Z="",BIPOP=0,Z="YES"
 D TITLE,TEXT1 W !
 D DIRZ^BIUTL3(.BIPOP)
 Q:BIPOP
 ;
 ;---> Current Community.
 D CC^BIOUTPT(.BICC,"BISCAN",.BIPOP)
 Q:BIPOP
 ;
 D TITLE W !!
 D DIR^BIFMAN("Y",.Y,.BIPOP,"     Do you wish to continue with the Scan",Z)
 Q:BIPOP
 S:Y<1 BIPOP=1
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> To satisfy return from call to BIOUTPT.
 Q
 ;
 ;
 ;----------
SCAN(BICC,BIPOP) ;EP
 ;---> Convert patients to new file/register.
 ;     1 - BICC  (ret) Current Community array.
 ;     2 - BIPOP (ret) BIPOP=1 If quit, fail, DTOUT, DUOUT.
 ;
 K ^BITMP($J)
 N BIERR,BIFACT,BIX,BIY,N
 ;
 ;---> Check for DUZ(2).
 I '$G(DUZ(2)) D ERRCD^BIUTL2(105,,1) Q
 ;
 ;********** PATCH 1, SEP 21,2006, IHS/CMI/MWR
 ;---> Hold prompt while getting total patient count.
 W !!?12,"Please hold..."
 ;**********
 ;
 ;
 S N=0 F  S N=$O(^AUPNPAT(N)) Q:'N  S BIFACT=N
 S:BIFACT<1 BIFACT=1 S BIFACT=BIFACT\50
 S (BIPOP,BIX,BIY)=0
 ;
 D TITLE
 W !!?12,"Converting Patients to the new Register..."
 W !!?12,"0%---10---20---30---40---50---60---70---80---90---100%"
 W !?12,"|"
 ;
 ;---> Loop through the RPMS Patient global, adding to
 ;---> new BI Patient global.
 ;---> * Consider using DOB xref (time versus reliability?).
 S BIDFN=0,BIPATS=0
 F  S BIDFN=$O(^AUPNPAT(BIDFN)) Q:'BIDFN  Q:$G(BIERR)]""  D
 .;
 .;---> Display bar graph of progress.
 .S BIX=BIX+1 I BIFACT,'(BIX#BIFACT)&(BIY<51) W "=" S BIY=BIY+1
 .;
 .;---> Quit if this patient already exists in the Imm Patient File.
 .Q:$D(^BIP(BIDFN,0))
 .;---> Quit if patient does not have an Active Chart at this site.
 .Q:$$INACTREG^BIUTL1(BIDFN,DUZ(2))
 .;
 .;********** PATCH 1, SEP 21,2006, IHS/CMI/MWR
 .;---> Quit if patient is Ineligible in RPMS Registration.
 .Q:$$INELIG^BIUTL1(BIDFN)
 .;**********
 .;
 .;---> Quit if patient is not less than 36 months.
 .Q:($$AGE^BIUTL1(BIDFN,2,$G(DT))>35)
 .;---> Quit if patient is deceased.
 .Q:$$DECEASED^BIUTL1(BIDFN)
 .;---> Quit If patient does not have one of the selected Current Communities.
 .Q:$$CURCOM^BIEXPRT2(BIDFN,.BICC)
 .;
 .;---> Add patient to ^BIP Imm Database.
 .D ADD(BIDFN,.BIPATS,.BIERR)
 ;
 I $G(BIERR)]"" W !!?3,BIERR D DIRZ^BIUTL3() Q
 ;
 ;---> Update Zero Node of BI PATIENT File #9002084.
 N M,N S (L,N,T)=0 F  S N=$O(^BIP(N)) Q:'N  S L=N,T=T+1
 S $P(^BIP(0),U,3,4)=L_U_T
 ;
 N BII F BII=1:1:50-BIY W "="
 W "|",!?33,"Complete"
 W !!?12,"Patients added to the new Immunization Register: ",BIPATS
 W !!?12,"Total Patients in the new Immunization Register....: ",T
 W !!!!!! D DIRZ^BIUTL3(.BIPOP) Q:BIPOP
 ;
 Q
 ;
 ;
 ;----------
ADD(BIDFN,BIPATS,BIERR) ;EP
 ;---> Add patient to new Immunization database.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIPATS (opt) Bookeeper node, total patients in ^BIP(0)
 ;     3 - BIERR  (ret)   Error text, if any.
 ;
 Q:'$D(^AUPNPAT(BIDFN,0))
 S:'$D(BIPATS) BIPATS=0
 ;
 D ADDPAT^BIPATE(BIDFN,1665,.BIERR,,,1)
 Q:($G(BIERR)]"")
 S ^BITMP($J,BIDFN)="",BIPATS=BIPATS+1
 Q
 ;
 ;
 ;----------
REVIEW ;EP
 ;---> Review/Print List of Patients automatically activated.
 ;
 D TITLE,TEXT2 W !
 N BIPOP S BIPOP=0
 D DIR^BIFMAN("Y",.Y,.BIPOP,"     Review List of Auto Activated now")
 Q:BIPOP
 Q:Y<1
 ;
 ;********** PATCH 1, SEP 21,2006, IHS/CMI/MWR
 ;---> Correct Age Range in report from 1-36 to 0-35.
 ;K BICC S BIPG="5^^^^"_DT_":"_DT,BIAG="1-36"
 K BICC S BIPG="5^^^^"_DT_":"_DT,BIAG="0-35"
 ;**********
 ;
 D ^BIDU
 Q
 ;
 ;
 ;----------
PREVINA ;EP
 ;---> Stuff "Previously Inactivated" in the .16 Field of the BI PATIENT
 ;---> File for any patients who were Inactive prior to v8.1.
 ;
 ;********** PATCH 1, SEP 21,2006, IHS/CMI/MWR
 ;---> No longer stuffing "Previously Inactivated".
 Q
 ;**********
 ;
 N N S N=0
 F  S N=$O(^BIP(N)) Q:'N  D
 .Q:'$P($G(^BIP(N,0)),"^",8)
 .S $P(^BIP(N,0),"^",16)="p"
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;
 ;;This program will scan the RPMS Patient Database for children who
 ;;are less than 36 months old.  Of those children, any who are not in
 ;;the Immunization Database and who live in one of the Communities
 ;;you select will be added to the Immunization Register.
 ;;
 ;;NOTE: This scan program, if interrupted, may be restarted at any time.
 ;;      It may also be rerun at any time.  It will not create duplicates.
 ;;
 ;;The next screen will provide an opportunity to select specific
 ;;communities from which patients will be scanned.  (This is the
 ;;"Current Community" field in RPMS Patient Registration.)  You will have
 ;;the opportunity to automatically use the GPRA set of communities.
 ;;
 ;;
 ;;
 D PRINTX("TEXT1",5)
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;
 ;;You may review the list of Patients who have been Automatically
 ;;Activated today.  Would you like to view that list now?
 ;;
 ;;
 D PRINTX("TEXT2",5)
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
 D TITLE^BIUTL5("SCAN FOR PATIENTS <36 MONTHS")
 Q
