BCSVDQR ;IHS/SD/SDR - BCSV*1.0 install ; 12/21/2008 00:29
 ;;1.0;BCSV;;APR 23, 2010
 ;
PRECMRG ; EP - This tag should be run to get IHS data into a temp space to
 ; compare with later.  If this isn't done, there won't be anything
 ; to compare to for the report.
CPT ;
 S BCSVI=0
 S BCSVCNT=0
 F  S BCSVI=$O(^ICPT(BCSVI)) Q:'BCSVI  D
 .M ^BCSVTMP("BCSV-CPT",BCSVI)=^ICPT(BCSVI)
 .S BCSVCNT=+$G(BCSVCNT)+1
 W !,"CPT : "_BCSVCNT
ICD0 ;
 S BCSVI=0
 S BCSVCNT=0
 F  S BCSVI=$O(^ICD0(BCSVI)) Q:'BCSVI  D
 .M ^BCSVTMP("BCSV-ICD0",BCSVI)=^ICD0(BCSVI)
 .S BCSVCNT=+$G(BCSVCNT)+1
 W !,"ICD0: "_BCSVCNT
ICD9 ;
 S BCSVI=0
 S BCSVCNT=0
 F  S BCSVI=$O(^ICD9(BCSVI)) Q:'BCSVI  D
 .M ^BCSVTMP("BCSV-ICD9",BCSVI)=^ICD9(BCSVI)
 .S BCSVCNT=+$G(BCSVCNT)+1
 W !,"ICD9: "_BCSVCNT
 ;
 Q
 ;
PRECSV ; EP - Pre-Conversion Report
 D PRECSV^BCSVDQR1
 Q
 ;
MAPCK ; EP - Map Check Report
 D MAPCK^BCSVDQR1
 Q
 ;
POSTCSV ; EP - Post-Conversion Report
 S BCSVANS=1
 I +$$VERSION^XPDUTL("BCSV")<1 D
 .K DIR,DIC,DIE,DA,X,Y
 .S DIR(0)="YA"
 .S DIR("A",1)="The Conversion is not complete at this time so the data reported"
 .S DIR("A",2)="may be inaccurate."
 .S DIR("A")="Are you sure you want to run this report? "
 .S DIR("B")="N"
 .D ^DIR K DIR
 .S BCSVANS=+Y
 Q:BCSVANS'=1  ;they exited out of report
 ;path
 K DIR,DIC,DIE,DA,X,Y
 S DIR(0)="F^Ar"
 S DIR("A")="Enter path"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S BCSVPATH=Y
 ;filename
 K DIR,DIC,DIE,DA,X,Y
 S DIR(0)="F^Ar"
 S DIR("A")="Enter filename"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S BCSVFNAM=Y
 ;
 D OPEN^%ZISH("BCSVFILE",BCSVPATH,BCSVFNAM,"W")
 Q:POP
 U IO(0) W !!,"Writing report...."
 U IO
 D NOW^%DTC
 S Y=%
 D DD^%DT
 W !,"Report:-- POST-CONVERSION DATA QUALITY REPORT  Date: ",Y
 W !,"File:---- ",BCSVFNAM
 ;D CPTADDS  ;counts and writes adds to IHS file
 ;D ICD0ADDS
 ;D ICD9ADDS
 W !,"File^IEN^Code^field^IHS value^VA value"
 D CPTDIFFS
 D CMODDIFF
 D ICD0DIFF
 D ICD9DIFF
 D CLOSE^%ZISH("BCSVFILE")
 Q
CPTDIFFS ;
 S BCSVI=0
 F  S BCSVI=$O(^ICPT(BCSVI)) Q:'BCSVI  D
 .I '$D(^BCSVTMP("BCSV-CPT",BCSVI,0)) W !,"CPT^"_BCSVI_"^"_$P($G(^ICPT(BCSVI,0)),U)_"^Not found(IHS)" Q
 .;
 .I $P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,3)'=$P($G(^ICPT(BCSVI,0)),U,3) D
 ..W !,"CPT^"_BCSVI_"^"_$P($G(^ICPT(BCSVI,0)),U)
 ..W "^CPT Category^"
 ..W $S($P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,3)'="":$P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,3),1:"NONE")
 ..W "^"_$P($G(^ICPT(BCSVI,0)),U,3)
 .;
 .I $P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,4)'=$P($G(^ICPT(BCSVI,0)),U,4) D
 ..W !,"CPT^"_BCSVI_"^"_$P($G(^ICPT(BCSVI,0)),U)
 ..W "^Inactive Flag^"_$P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,4)_"^"_$P($G(^ICPT(BCSVI,0)),U,4)
 .;
 .I $P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,5)'=$P($G(^ICPT(BCSVI,9999999)),U,5) D
 ..W !,"CPT^"_BCSVI_"^"_$P($G(^ICPT(BCSVI,0)),U)
 ..W "^ASC Pymt Grp^"_$P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,5)_"^"_$P($G(^ICPT(BCSVI,9999999)),U,5)
 .;
 .I $P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,6)'=$P($G(^ICPT(BCSVI,9999999)),U,6) D
 ..W !,"CPT^"_BCSVI_"^"_$P($G(^ICPT(BCSVI,0)),U)
 ..W "^Dt Added^"_$P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,6)_"^"_$P($G(^ICPT(BCSVI,9999999)),U,6)
 .;
 .I $P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,7)'=$P($G(^ICPT(BCSVI,9999999)),U,7) D
 ..W !,"CPT^"_BCSVI_"^"_$P($G(^ICPT(BCSVI,0)),U)
 ..W "^Dt Deleted^"_$P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,7)_"^"_$P($G(^ICPT(BCSVI,9999999)),U,7)
 .;
 .I $P($G(^BCSVTMP("BCSV-CPT",BCSVI,9999999)),U,2)'=$P($G(^ICPT(BCSVI,9999999)),U,2) D
 ..W !,"CPT^"_BCSVI_"^"_$P($G(^ICPT(BCSVI,0)),U)
 ..W "^Default Rev. Code^"
 ..W $P($G(^BCSVTMP("BCSV-CPT",BCSVI,9999999)),U,2)_"^"_$P($G(^ICPT(BCSVI,9999999)),U,2)
 .;
 .;short desc check
 .S BCSVMDT=9999999
 .S BCSVMDT=$O(^ICPT(BCSVI,61,"B",BCSVMDT),-1)  ;get most recent entry
 .I BCSVMDT'="" D
 ..S BCSVMIEN=$O(^ICPT(BCSVI,61,"B",BCSVMDT,0))
 ..I BCSVMIEN="" D  Q
 ...W !,"CPT^"_BCSVI_"^"_$P($G(^ICPT(BCSVI,0)),U)
 ...W "^Short Desc^"_$P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,2)_"^NONE"
 ..I $$UPC^ABMERUTL($P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,2))'=$$UPC^ABMERUTL($P($G(^ICPT(BCSVI,61,BCSVMIEN,0)),U,2)) D
 ...W !,"CPT^"_BCSVI_"^"_$P($G(^ICPT(BCSVI,0)),U)
 ...W "^Short Desc^"_$P($G(^BCSVTMP("BCSV-CPT",BCSVI,0)),U,2)_"^"_$P($G(^ICPT(BCSVI,61,BCSVMIEN,0)),U,2)
 .;
 .;desc check
 .S BCSVMDT=9999999
 .S BCSVODSC=""
 .S BCSVNDSC=""
 .S BCSVMDT=$O(^ICPT(BCSVI,62,"B",BCSVMDT),-1)  ;get most recent entry
 .I BCSVMDT'="" D
 ..S BCSVDIEN=$O(^ICPT(BCSVI,62,"B",BCSVMDT,0))
 ..S BCSVMIEN=0
 ..F  S BCSVMIEN=$O(^ICPT(BCSVI,62,BCSVDIEN,1,BCSVMIEN)) Q:'BCSVMIEN  D
 ...S BCSVNDSC=BCSVNDSC_" "_$G(^ICPT(BCSVI,62,BCSVDIEN,1,BCSVMIEN,0))
 ..S BCSVMIEN=0
 ..F  S BCSVMIEN=$O(^BCSVTMP("BCSV-CPT",BCSVI,"D",BCSVMIEN)) Q:'BCSVMIEN  D
 ...S BCSVODSC=BCSVODSC_" "_$G(^BCSVTMP("BCSV-CPT",BCSVI,"D",BCSVMIEN,0))
 ..I $$UPC^ABMERUTL($TR(BCSVNDSC," "))'=$$UPC^ABMERUTL($TR(BCSVODSC," ")) D
 ...W !,"CPT^"_BCSVI_"^"_$P($G(^ICPT(BCSVI,0)),U)_"^Desc^"_BCSVODSC_"^"_BCSVNDSC
 .;
 Q
CMODDIFF ;
 S BCSVI=0
 F  S BCSVI=$O(^DIC(81.3,BCSVI)) Q:'BCSVI  D
 .S BCSVCD=$P($G(^DIC(81.3,BCSVI,0)),U)
 .I '$D(^AUTTCMOD("B",BCSVCD)) W !,"CPT MOD^"_BCSVI_"^^Not found (IHS)" Q
 ;;THIS CODE IS NOT COMPLETE.  NEED CLARIFICATION ON ONE-TO-MANY ISSUE
 ;;VA has multiple entries for some code while IHS only has one
 Q
ICD9DIFF ;
 S BCSVI=0
 F  S BCSVI=$O(^ICD9(BCSVI)) Q:'BCSVI  D
 .I '$D(^BCSVTMP("BCSV-ICD9",BCSVI,0)) W !,"ICD9^"_BCSVI_"^"_$P($G(^ICD9(BCSVI,0)),U)_"^Not found(IHS)" Q
 .;
 .;Identifier
 .I $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,0)),U,2)'=$P($G(^ICD9(BCSVI,0)),U,2) D
 ..W !,"ICD9^"_BCSVI_"^"_$P($G(^ICD9(BCSVI,0)),U)_"^Identifer^"
 ..W $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,0)),U,2)_"^"_$P($G(^ICD9(BCSVI,0)),U,2)
 .;Diagnosis
 .S BCSVMDT=9999999
 .S BCSVMDT=$O(^ICD9(BCSVI,67,"B",BCSVMDT),-1)  ;get most recent entry
 .I BCSVMDT'="" D
 ..S BCSVMIEN=$O(^ICD9(BCSVI,67,"B",BCSVMDT,0))
 ..I BCSVMIEN="" D  Q
 ...W !,"ICD9^"_BCSVI_"^"_$P($G(^ICD9(BCSVI,0)),U)
 ...W "^Diagnosis^"_$P($G(^BCSVTMP("BCSV-ICD9",BCSVI,0)),U,2)_"^NONE"
 ..I $$UPC^ABMERUTL($TR($P($G(^BCSVTMP("BCSV-ICD9",BCSVI,0)),U,3)," "))'=$$UPC^ABMERUTL($TR($P($G(^ICD9(BCSVI,67,BCSVMIEN,0)),U,2)," ")) D
 ...W !,"ICD9^"_BCSVI_"^"_$P($G(^ICD9(BCSVI,0)),U)_"^Diagnosis^"
 ...W $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,0)),U,3)_"^"_$P($G(^ICD9(BCSVI,67,BCSVMIEN,0)),U,2)
 .;Inactive Flag
 .I $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,0)),U,9)'=$P($G(^ICD9(BCSVI,0)),U,9) D
 ..W !,"ICD9^"_BCSVI_"^"_$P($G(^ICD9(BCSVI,0)),U)_"^Inactive Flag^"
 ..W $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,0)),U,9)_"^"_$P($G(^ICD9(BCSVI,0)),U,9)
 .;Inactive Date
 .I $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,0)),U,11)'=$P($G(^ICD9(BCSVI,0)),U,11) D
 ..W !,"ICD9^"_BCSVI_"^"_$P($G(^ICD9(BCSVI,0)),U)_"^Inactive Date^"
 ..W $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,0)),U,11)_"^"_$P($G(^ICD9(BCSVI,0)),U,11)
 .;Lower age
 .I $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,9999999)),U)'=$P($G(^ICD9(BCSVI,0)),U,14) D
 ..W !,"ICD9^"_BCSVI_"^"_$P($G(^ICD9(BCSVI,0)),U)_"^Lower Age^"
 ..W $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,9999999)),U)_"^"_$P($G(^ICD9(BCSVI,0)),U,14)
 .;Upper age
 .I $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,9999999)),U,2)'=$P($G(^ICD9(BCSVI,0)),U,15) D
 ..W !,"ICD9^"_BCSVI_"^"_$P($G(^ICD9(BCSVI,0)),U)_"^Upper Age^"
 ..W $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,9999999)),U,2)_"^"_$P($G(^ICD9(BCSVI,0)),U,15)
 .;Date Added
 .I $P($G(^BCSVTMP("BCSV-ICD9",BCSVI,9999999)),U,4)'=$P($G(^ICD9(BCSVI,0)),U,16) D
 ..W !,"ICD9^"_BCSVI_"^"_$P($G(^ICD9(BCSVI,0)),U)
 ..W "^Date Added^"_$P($G(^BCSVTMP("BCSV-ICD9",BCSVI,9999999)),U,4)_"^"_$P($G(^ICD9(BCSVI,0)),U,16)
 .;Description
 .S BCSVODSC=$P($G(^BCSVTMP("BCSV-ICD9",BCSVI,1)),U)
 .S BCSVMDT=$O(^ICD9(BCSVI,"B",9999999))
 .I BCSVMDT'="" D
 ..S BCSVMIEN=$O(^ICD9(BCSVI,"B",BCSVMDT,0))
 ..S BCSVNDSC=$G(^ICD9(BCSVI,68,BCSVMIEN,1))
 ..I $$UPC^ABMERUTL($TR(BCSVODSC," "))'=$$UPC^ABMERUTL($TR(BCSVNDSC," ")) D
 ...W !,"ICD9^"_BCSVI_"^"_$P($G(^ICD9(BCSVI,0)),U)_"^Desc^"_BCSVODSC_"^"_BCSVNDSC
 Q
 ;
ICD0DIFF ;
 S BCSVI=0
 F  S BCSVI=$O(^ICD0(BCSVI)) Q:'BCSVI  D
 .I '$D(^BCSVTMP("BCSV-ICD0",BCSVI,0)) W !,"ICD0^"_BCSVI_"^"_$P($G(^ICD0(BCSVI,0)),U)_"^Not found(IHS)" Q
 .;
 .;Identifier
 .I $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,0)),U,2)'=$P($G(^ICD0(BCSVI,0)),U,2) D
 ..W !,"ICD0^"_BCSVI_"^"_$P($G(^ICD0(BCSVI,0)),U)_"^Identifer^"
 ..W $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,0)),U,2)_"^"_$P($G(^ICD9(BCSVI,0)),U,2)
 .;Operation/Procedure
 .S BCSVMDT=9999999
 .S BCSVMDT=$O(^ICD0(BCSVI,67,"B",BCSVMDT),-1)  ;get most recent entry
 .I BCSVMDT'="" D
 ..S BCSVMIEN=$O(^ICD0(BCSVI,67,"B",BCSVMDT,0))
 ..I BCSVMIEN="" D  Q
 ...W !,"ICD0^"_BCSVI_"^"_$P($G(^ICD0(BCSVI,0)),U)_"^Diagnosis^"
 ...W $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,0)),U,2)_"^NONE"
 ..I $$UPC^ABMERUTL($TR($P($G(^BCSVTMP("BCSV-ICD0",BCSVI,0)),U,4)," "))'=$$UPC^ABMERUTL($TR($P($G(^ICD0(BCSVI,67,BCSVMIEN,0)),U,2)," ")) D
 ...W !,"ICD0^"_BCSVI_"^"_$P($G(^ICD0(BCSVI,0)),U)_"^Diagnosis^"
 ...W $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,0)),U,4)_"^"_$P($G(^ICD0(BCSVI,67,BCSVMIEN,0)),U,2)
 .;Inactive Flag
 .I $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,0)),U,9)'=$P($G(^ICD0(BCSVI,0)),U,9) D
 ..W !,"ICD0^"_BCSVI_"^"_$P($G(^ICD0(BCSVI,0)),U)_"^Inactive Flag^"
 ..W $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,0)),U,9)_"^"_$P($G(^ICD0(BCSVI,0)),U,9)
 .;Inactive Date
 .I $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,0)),U,11)'=$P($G(^ICD0(BCSVI,0)),U,11) D
 ..W !,"ICD0^"_BCSVI_"^"_$P($G(^ICD0(BCSVI,0)),U)_"^Inactive Date^"
 ..W $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,0)),U,11)_"^"_$P($G(^ICD0(BCSVI,0)),U,11)
 .;Lower age
 .I $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,9999999)),U)'=$P($G(^ICD0(BCSVI,9999999)),U) D
 ..W !,"ICD0^"_BCSVI_"^"_$P($G(^ICD0(BCSVI,0)),U)_"^Lower Age^"
 ..W $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,9999999)),U)_"^"_$P($G(^ICD0(BCSVI,9999999)),U)
 .;Upper age
 .I $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,9999999)),U,2)'=$P($G(^ICD0(BCSVI,9999999)),U,2) D
 ..W !,"ICD0^"_BCSVI_"^"_$P($G(^ICD0(BCSVI,0)),U)_"^Upper Age^"
 ..W $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,9999999)),U,2)_"^"_$P($G(^ICD0(BCSVI,9999999)),U,2)
 .;Date Added
 .I $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,9999999)),U,4)'=$P($G(^ICD0(BCSVI,0)),U,12) D
 ..W !,"ICD0^"_BCSVI_"^"_$P($G(^ICD0(BCSVI,0)),U)_"^Date Added^"
 ..W $P($G(^BCSVTMP("BCSV-ICD0",BCSVI,9999999)),U,4)_"^"_$P($G(^ICD0(BCSVI,0)),U,12)
 .;Description
 .S BCSVODSC=$P($G(^BCSVTMP("BCSV-ICD0",BCSVI,1)),U)
 .S BCSVMDT=$O(^ICD0(BCSVI,"B",9999999))
 .I BCSVMDT'="" D
 ..S BCSVMIEN=$O(^ICD0(BCSVI,"B",BCSVMDT,0))
 ..S BCSVNDSC=$G(^ICD0(BCSVI,68,BCSVMIEN,1))
 ..I $$UPC^ABMERUTL($TR(BCSVODSC," "))'=$$UPC^ABMERUTL($TR(BCSVNDSC," ")) D
 ...W !,"ICD0^"_BCSVI_"^"_$P($G(^ICD0(BCSVI,0)),U)_"^Desc^"_BCSVODSC_"^"_BCSVNDSC
 Q
CPTADDS ;
 S BCSVI=0
 S BCSVCNT=0
 W !,"Look for additions to IHS:"
 W !?5,"IEN",?25,"CPT"
 F  S BCSVI=$O(^ICPT(BCSVI)) Q:'BCSVI  D
 .S BCSVCNT=+$G(BCSVCNT)+1
 .I '$D(^BCSVTMP("BCSV-CPT",BCSVI)) W !?5,BCSVI,?25,$P($G(^ICPT(BCSVI,0)),U)
 Q
 ;
ICD0ADDS ;
 S BCSVI=0
 S BCSVCNT=0
 W !,"ICD0s (PXs) in CSV that aren't in IHS:"
 F  S BCSVI=$O(^ICD0(BCSVI)) Q:'BCSVI  D
 .S BCSVCNT=+$G(BCSVCNT)+1
 .I '$D(^BCSVTMP("BCSV-ICD0",BCSVI,0)) W !?5,BCSVI
 W !,"ICD0: "_BCSVCNT
 Q
ICD9ADDS ;
 S BCSVI=0
 S BCSVCNT=0
 W !,"ICD9s (DXs) in CSV that aren't in IHS:"
 F  S BCSVI=$O(^ICD9(BCSVI)) Q:'BCSVI  D
 .S BCSVCNT=+$G(BCSVCNT)+1
 .I '$D(^BCSVTMP("BCSV-ICD9",BCSVI,0)) W !?5,BCSVI
 W !,"ICD9: "_BCSVCNT
 ;;
 S BCSVI=0
 Q
