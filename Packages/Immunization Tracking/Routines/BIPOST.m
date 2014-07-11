BIPOST ;IHS/CMI/MWR - POST-INIT ROUTINE; OCT 15, 2010
 ;;8.5;IMMUNIZATION;**6**;OCT 15,2013
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PATCH 3: Set MenCY-Hib (148) and Flu-nasal4 (149) and all Skin Tests
 ;;           in the Vaccine Table to Inactive.   START+30
 ;;  PATCH 3: Set all Skin Tests in the Skin Test table to Inactive, except
 ;;           PPD and Tetanus. START+38
 ;;  PATCH 4, v8.5: Update Source options in Imm Lot File.  START+9
 ;;  PATCH 5, v8.5: Remove dash from Eligibility Codes.
 ;;  PATCH 5, v8.5: Add SNOMED Codes to all Contraindications.
 ;;  PATCH 5, v8.5: Restandardize Vaccine Table, with updates from BITN.
 ;;  PATCH 6, v8.5: Restandardize Vaccine Table, with updates from BITN.
 ;
 ;
 ;----------
START ;EP
 ;---> Update software after KIDS installation.
 ;
 D SETVARS^BIUTL5 S BIPOP=0
 ;S IOP=$I D ^%ZIS
 ;
 ;W !!!?3,"Please hold..."
 ;
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Remove dash from Eligibility Codes.
 ;N N S N=0 F  S N=$O(^BIELIG(N)) Q:'N  D
 ;.N X S X=$P($G(^BIELIG(N,0)),U)
 ;.Q:(X="")  Q:(X'["-")
 ;.N Y S Y=$P(X,"-")_$P(X,"-",2)
 ;.;W !,X,"   ",Y Q
 ;.S $P(^BIELIG(N,0),U)=Y
 ;N I F I="AC","B","C","D","E","F","U" K ^BIELIG(I)
 ;S DIK="^BIELIG("
 ;D IXALL^DIK
 ;
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Back-populate SNOMED Codes to all Contraindications.
 ;D
 ;.;---> If BCQM IHS CODE MAPPING Version 1.0 is not loaded, abort back-pop.
 ;.I '($L($T(MM^BCQMAPI))) D  Q
 ;..D TEXT2,DIRZ^BIUTL3()
 ;.D SNOMED^BIUTLFIX
 ;
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Update Manufacturer Table.
 S ^BIMAN(163,0)="Protein Sciences^PSC^1^Protein Sciences"
 S ^BIMAN(155,0)="CSL Behring, Inc.^CSL^1^CSL Behring, Inc."
 S ^BIMAN(164,0)="Grifols^GRF^1^Grifols"
 S ^BIMAN(165,0)="ID Biomedical^IDB^1^ID Biomedical"
 ;
 ;**********
 ;
 ;********** PATCH 4, v8.5, DEC 01,2012, IHS/CMI/MWR
 ;---> Update Source options in Imm Lot File.
 ;N BIX S BIX="^DD(9999999.41,.13,0)"
 ;S @BIX="VACCINE SOURCE^S^v:VFC;n:NON-VFC;o:Other State;i:IHS/Tribal;^0;13^Q"
 ;**********
 ;
 ;---> Reindex any Listman Hidden Menus.
 ;D LISTMENU^BIUTLFIX
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Change Vaccine Group of CVX 148 to Mening.
 ;---> Standardize the Vaccine Table.
 D RESTAND^BIRESTD()
 ;
 ;********** PATCH 2, v8.4, OCT 15,2010, IHS/CMI/MWR
 ;---> Comment out unnecessary post-install routines.
 ;
 ;---> Set NOS (and a couple other) vaccines to Inactive.
 ;N N F N=105,108,110,113,122,124,130,131,139,142,149,155,157,195 D
 ;---> Set older Flu's to Inactive.
 ;N N F N=108,148,149,229 D
 ;.S $P(^AUTTIMM(N,0),U,7)=1
 ;.S $P(^BITN(N,0),U,7)=1
 ;
 ;F N=200,205,212,213,214,218,228,234,238,239 D
 ;.S $P(^AUTTIMM(N,0),U,7)=1
 ;.S $P(^BITN(N,0),U,7)=1
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Set older Flu-Nasal and other new vaccines to Inactive.
 ;F N=148,217,229,254,255,256,257,258,259,260 D
 ;.S $P(^AUTTIMM(N,0),U,7)=1
 ;.S $P(^BITN(N,0),U,7)=1
 ;
 ;---> Set older Flu-Nasal4 to Active.
 ;S $P(^AUTTIMM(253,0),U,7)=0
 ;S $P(^BITN(253,0),U,7)=0
 ;
 ;********** PATCH 3, v8.5, SEP 10,2012, IHS/CMI/MWR
 ;---> Set all Skin Tests in Vaccine Table to Inactive (so that they will be
 ;---> unavailable to select as vaccines in EHR).
 ;---> Set MenCY-Hib (148) and Flu-nasal4 (149) to Inactive.
 ;N N F N=202,203,204,205,252,253 D
 ;.S $P(^AUTTIMM(N,0),U,7)=1
 ;.S $P(^BITN(N,0),U,7)=1
 ;
 ;---> Also set all Skin Tests in the Skin Test file Inactive,
 ;---> except PPD and Tetanus.
 ;N N S N=0 F  S N=$O(^AUTTSK(N)) Q:'N  D
 ;.Q:'$D(^AUTTSK(N,0))
 ;.S $P(^AUTTSK(N,0),U,3)=1
 ;---> Now set PPD and Tetanus to Active.
 ;D
 ;.K N S N=$O(^AUTTSK("B","PPD",0))
 ;.Q:'N
 ;.S $P(^AUTTSK(N,0),U,3)=""
 ;.S N=$O(^AUTTSK("B","TETANUS",0))
 ;.Q:'N
 ;.S $P(^AUTTSK(N,0),U,3)=""
 ;**********
 ;
 ;---> Reset Display Order of Vaccine Groups in BI TABLE VACCINE GROUP File #9002084.93.
 ;S $P(^BISERT(1,0),"^",2)=1
 ;S $P(^BISERT(2,0),"^",2)=3
 ;S $P(^BISERT(3,0),"^",2)=4
 ;S $P(^BISERT(4,0),"^",2)=6
 ;S $P(^BISERT(5,0),"^",2)=5
 ;S $P(^BISERT(6,0),"^",2)=7
 ;S $P(^BISERT(7,0),"^",2)=8
 ;S $P(^BISERT(8,0),"^",2)=2
 ;S $P(^BISERT(9,0),"^",2)=9
 ;S $P(^BISERT(10,0),"^",2)=10
 ;S $P(^BISERT(11,0),"^",2)=12
 ;S $P(^BISERT(12,0),"^",2)=90
 ;S $P(^BISERT(13,0),"^",2)=99
 ;S $P(^BISERT(14,0),"^",2)=95
 ;S $P(^BISERT(15,0),"^",2)=85
 ;S $P(^BISERT(16,0),"^",2)=15
 ;S $P(^BISERT(17,0),"^",2)=18
 ;S $P(^BISERT(18,0),"^",2)=11
 ;
 ;---> Turn off H1N1forecasting.
 ;S $P(^BISERT(18,0),"^",5)=0
 ;
 ;---> Standardize the VT-100 Codes in the Terminal Type File.
 ;D ^BIVT100
 ;---> Set new Immserve Path.
 ;D IMMPATH
 ;---> Check and fix any Lot Numbers with a Status of null.
 ;D NULLACT^BILOT1
 ;---> Reindex killed globals.
 ;D REINDEX
 ;---> Update Taxonomies.
 ;D ^BITX
 ;---> Reindex BI Letter Sample and BI Table Manufactures Files.
 ;D REINDLS
 ;
 ;---> Kill dangling xref to old file.
 ;K ^DIC("B","BI IMMUNIZATION TABLE OLD LOCAL",9002084.95)
 ;
 ;---> Scan for any V Imms with a .14 Eligibility=0, change to 8, which is
 ;---> the IEN of "Unknown" in the new BI TABLE ELIG File.
 ;D ^BIELIG3
 ;
 ;---> Update "Last Version Fully Installed" Field in BI SITE PARAMETER File.
 N N S N=0 F  S N=$O(^BISITE(N)) Q:'N  S $P(^BISITE(N,0),"^",15)=$$VER^BILOGO
 ;
 ;D TEXT2,DIRZ^BIUTL3()
 D TEXT1,DIRZ^BIUTL3()
 ;
 D EXIT
 Q
 ;
 ;
 ;----------
EXIT ;EP
 D KILLALL^BIUTL8(1)
 Q
 ;
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;         - This concludes the Post-Initialization program. -
 ;;
 ;;                       * CONGRATULATIONS! *
 ;;
 ;;          You have successfully installed Immunization v8.56.
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 W @IOF
 D PRINTX("TEXT1")
 Q
 ;**********
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;
 ;;
 ;;
 ;;
 ;;                             * NOTE! *
 ;;
 ;; NOTE: The BCQM IHS CODE MAPPING Version 1.0 has not been loaded on
 ;;       this machine; therefore back-populating of Contraindications
 ;;       with SNOMED Codes has not been performed.
 ;;       This is not critical; however, the process may be completed by
 ;;       reinstalling this patch--Immunization v8.55--at a later date,
 ;;       after the IHS CODE MAPPING software has been installed.
 ;;       (Imm v8.55 may be reinstalled at any time with no adverse affects.)
 ;;
 ;;                             * NOTE! *
 ;;
 ;;
 ;;
 ;;
 ;;
 W @IOF
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 ;---> Print text at specified line label.
 ;
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
IMMPATH ;EP
 ;---> Update path for new Immserve files.
 N N,X,Y S Y=$$VERSION^%ZOSV(1) D
 .I Y["Windows" S X="C:\Program Files\Immserve852\" Q
 .I Y["UNIX" S X="/usr/local/immserve852/"
 ;
 S N=0
 F  S N=$O(^BISITE(N)) Q:'N  D
 .S $P(^BISITE(N,0),"^",18)=X
 Q
 ;
 ;
 ;----------
REINDEX ;EP
 ;---> Not called.  Programmer to use if KIDS fails to index these files.
 ;
 N DIK
 F DIK="^BINFO(","^BILETS(","^BIVT100(","^BIERR(","^BINFO(","^BIEXPDD(","^BISERT(","^BICONT(" D
 .D IXALL^DIK
 .S DIK="^BISERT(" D IXALL^DIK
 Q
 ;
 ;
KEYS ;EP
 ;---> Clean up subordinate keys (there should be none).
 N X,Y
 F X="BIZ EDIT PATIENTS","BIZ MANAGER","BIZMENU" D
 .S Y=$O(^DIC(19.1,"B",X,0)) K @("^DIC(19.1,"""_Y_""",3)")
 Q
 ;
 ;
REINDLS ;EP
 ;---> Reindex BI LETTER SAMPLE File.
 N X,Y
 S DIK="^BILETS("
 D IXALL^DIK
 S DIK="^BIMAN("
 D IXALL^DIK
 Q
