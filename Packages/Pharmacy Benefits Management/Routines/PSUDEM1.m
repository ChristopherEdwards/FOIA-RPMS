PSUDEM1 ;BIR/DAM - Patient Demographics Extract ; 20 DEC 2001
 ;;3.0;PHARMACY BENEFITS MANAGEMENT;**19,21**;Oct 15, 1998
 ;
 ;DBIA's
 ; Reference to file #27.11  supported by DBIA 2462
 ; Reference to file 2       supported by DBIA 10035, 3504
 ; Reference to file 200     supported by DBIA 10060
 ; Reference to file 55      supported by DBIA 3502
 ; Reference to file 4.3     supported by DBIA 2496, 10091
 ; Reference to file 4       supported by DBIA 10090
 ;
EN ;EN   Routine control module
 ;
 D DAT
 D DEM
 I '$D(^XTMP("PSU_"_PSUJOB,"PSUFLAG")) D XMD
 K ^XTMP("PSU_"_PSUJOB,"PSUXMD")
 ;
 I $G(^XTMP("PSU_"_PSUJOB,"PSUPSUMFLAG"))=1 D
 .S PSUOPTS="1,2,3,4,5,6,7,8,9,10,11"
 .S PSUAUTO=1
 ;
 D PULL^PSUCP
 F I=1:1:$L(PSUOPTS,",") S PSUMOD($P(PSUOPTS,",",I))=""
 ;
 I $D(PSUMOD(10)) D PDSSN^PSUDEM4  ;pt. demographics provider msg
 ;
 K ^XTMP("PSU_"_PSUJOB,"PSUPDFLAG")
 K ^XTMP("PSU_"_PSUJOB,"PSUDM")
 Q
 ;
DAT ;Date Module
 ;
 ;Date extract was run
 S %H=$H
 D YMD^%DTC                   ;Converts $H to FileMan format
 S $P(^TMP("PSUDM",$J),U,3)=X    ;Set extract date in temp global
 ;
 Q
 ;
INST ;EN  Place institution code sending report into temp global.
 ;Institution Mailman info is in file 4.3 
 ;
 S X=$$VALI^PSUTL(4.3,1,217),PSUSNDR=+$$VAL^PSUTL(4,X,99)
 S $P(^XTMP("PSU_"_PSUJOB,"PSUSITE"),U,1)=PSUSNDR
 S PSUSIT=PSUSNDR
 ;
 S X=PSUSNDR,DIC=40.8,DIC(0)="X",D="C" D IX^DIC ;**1
 S X=+Y S PSUDIVNM=$$VAL^PSUTL(40.8,X,.01)
 S $P(^XTMP("PSU_"_PSUJOB,"PSUSITE"),U,2)=PSUDIVNM
 Q
 ;
DEM ;PULL PATIENT DEMOGRAPHICS 
 ;
 N PSUREC
 ;
 S PSUNAM=0
 F  S PSUNAM=$O(^DPT("B",PSUNAM)) Q:PSUNAM=""  D
 .S I=0
 .F  S I=$O(^DPT("B",PSUNAM,I)) Q:I=""  D
 ..Q:'$D(^DPT(I,0))
 ..I $P($G(^DPT(I,0)),U,21)'=1 D
 ...M ^XTMP("PSU_"_PSUJOB,"PSUDM",I)=^TMP("PSUDM",$J)       ;Merge ^TMP info into ^XTMP
 ...S PSUREC=$P($G(^DPT(I,0)),U,2) D REC D
 ....S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,8)=PSUREC             ;Gender in ^XTMP(
 ...S PSUREC=$P($G(^DPT(I,0)),U,9) D REC D
 ....S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,12)=PSUREC            ;SSN in ^XTMP(
 ...S PSUREC=$P($G(^DPT(I,0)),U,3) D REC D
 ....S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,5)=PSUREC             ;DOB in ^XTMP(
 ...S PSUREC=$P($G(^DPT(I,0)),U,16) D REC D
 ....S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,16)=PSUREC          ;Dt pt entered in file
 ...S PSUREC=$P($G(^PS(55,I,0)),U,7) D REC D
 ....S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,17)=PSUREC     ;Dt of first pharmacy service
 ...S PSUREC=$P($G(^PS(55,I,0)),U,8) D REC D
 ....S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,18)=PSUREC     ;Service Actual/Historical
 ...S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,30)=""                ;places "^" at end
 ...S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,2)=PSUSNDR   ;Site sending data
 ...D RACE
 ...D ELIG
 ...D PRIO
 ...D MTS
 ...D MISC
 ...D AGE
 ...D ETH
 ...D ELIM
 Q
 ;
ELIM ;Eliminate records with DOD before 7/1/98
 ;Eliminate test patients with SSN containing 5 leading '0's
 ;
 I $D(^XTMP("PSU_"_PSUJOB,"PSUDM",I)) D
 .I $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,4)'="" D     ;eliminate if DOD<02980701
 ..I $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,4)<02980701 K ^XTMP("PSU_"_PSUJOB,"PSUDM",I)
 ;
 I $D(^XTMP("PSU_"_PSUJOB,"PSUDM",I)) D
 .I $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,12)'="" D    ;eliminate test patients
 ..I $E($P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,12),1,5)="00000" K ^XTMP("PSU_"_PSUJOB,"PSUDM",I)
 Q
 ;
AGE ;patient current age
 ;
 S PSUDOD=$P($G(^XTMP("PSU_"_PSUJOB,"PSUDM",I)),U,4)  ;Date of death
 S DFN=I
 D DEM^VADPT
 S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",DFN),U,6)=VADM(4)  ;Age or age at time of death
 S I=DFN
 ;
 I '$D(^DPT(I,0)) K ^XTMP("PSU_"_PSUJOB,"PSUDM",I)   ;Kill ^XTMP if IEN doesn't exist
 ;
 Q
 ;
RACE ;Pull external format of patient race
 ;
 S DFN=I
 D DEM^VADPT
 S PSUREC=$P($G(VADM(8)),U,2)
 D REC
 S I=DFN
 S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,7)=PSUREC               ;Race in ^XTMP(
 Q
 ;
ELIG ;Pull external format of Primary Eligibility Code
 ;
 S DFN=I
 D ELIG^VADPT
 S PSUREC=$P($G(VAEL(1)),U,2)
 D REC
 S I=DFN
 S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,9)=PSUREC         ;Primary elig code
 Q
 ;
PRIO ;Pull Enrollment Priority
 ;
 S PSUE=0,PSUEC=0
 F  S PSUEC=$O(^DGEN(27.11,"C",I,PSUEC)) Q:PSUEC=""  D
 .S PSUREC=$P($G(^DGEN(27.11,PSUEC,0)),U,7)
 .I PSUREC'="" D
 ..D REC
 ..S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,11)=PSUREC           ;Enrollment
 Q
 ;
MTS ;Pull external format of Means Test Status
 ;
 S DFN=I
 D ELIG^VADPT
 S PSUREC=$P($G(VAEL(9)),U,2) D REC D
 .S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",DFN),U,10)=PSUREC             ;Means Test Status
 S I=DFN
 Q
 ;
MISC ;Pulls miscellaneous additional info via EN^DIQ1 call
 ;Pulls Date of Death, ICN, Primary Care Provider SSN,
 ;Date patient first provided pharmacy care
 ;
 N PSUDATMP,PSUDDTMP,PSUDTMPA
 ;
 S PSUDTMPA=$$OUTPTPR^SDUTL3(I)   ;Prov IEN^EXTERNAL VALUE in temp variable
 S PSUDATMP=$P($G(PSUDTMPA),U)       ;Prov IEN
 S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,15)=PSUDATMP
 I '$D(PSUDATMP)!PSUDATMP=0 S PSUDATMP=99999999999
 S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,14)=$$GET1^DIQ(200,PSUDATMP,9,"I")   ;Prov SSN
 S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,4)=$E($P($G(^DPT(I,.35)),U),1,7)    ;DOD
 D ICN
 Q
 ;
ICN ;Find patient ICN
 ;
 N PSUICN,PSUICN1
 S PSUICN=$$GETICN^MPIF001(I) D
 .I PSUICN'[-1 S PSUICN1=$TR(PSUICN,"V","^") D
 ..S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",I),U,13)=$P(PSUICN1,U,1)    ;ICN
 Q
 ;
ETH ;Ethnicity and multiple race entries
 ;
 S DFN=I
 N PSUETH,PSURAC
 D DEM^VADPT
 S PSUETH=$P($G(VADM(11,1)),U,2) D                    ;Ethnicity
 .S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",DFN),U,19)=PSUETH
 I '$G(VADM(11,1)) S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",DFN),U,19)=""
 ;
 S PSURCE=0,C=20
 F  S PSURCE=$O(VADM(12,PSURCE)) Q:PSURCE=""  D       ;Race multiple
 .S PSURAC=$P($G(VADM(12,PSURCE)),U,2) D
 ..S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",DFN),U,C)=PSURAC
 .I '$G(VADM(12,PSURCE)) S $P(^XTMP("PSU_"_PSUJOB,"PSUDM",DFN),U,C)=""
 .S C=C+1
 S I=DFN
 Q
 ;
REC ;EN    If "^" is contained in any record, replace it with "'"
 ;
 I PSUREC["^" S PSUREC=$TR(PSUREC,"^","'")
 Q
 ;
XMD ;Format mailman message and send.
 ;
 S PSUAB=0,PSUPL=1
 F  S PSUAB=$O(^XTMP("PSU_"_PSUJOB,"PSUDM",PSUAB)) Q:PSUAB=""  D
 .M ^XTMP("PSU_"_PSUJOB,"PSUDM",PSUPL)=^XTMP("PSU_"_PSUJOB,"PSUDM",PSUAB)  ;Global numerical order
 .S PSUPL=PSUPL+1
 ;
 NEW PSUMAX,PSULC,PSUTMC,PSUTLC,PSUMC
 S PSUMAX=$$VAL^PSUTL(4.3,1,8.3)
 S PSUMAX=$S(PSUMAX="":10000,PSUMAX>10000:10000,1:PSUMAX)
 S PSUMC=1,PSUMLC=0
 F PSULC=1:1 S X=$G(^XTMP("PSU_"_PSUJOB,"PSUDM",PSULC)) Q:X=""  D
 .S PSUMLC=PSUMLC+1
 .I PSUMLC>PSUMAX S PSUMC=PSUMC+1,PSUMLC=0,PSULC=PSULC-1 Q  ; +  message
 .I $L(X)<235 S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)=X Q
 .F I=235:-1:1 S Z=$E(X,I) Q:Z="^"
 .S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)=$E(X,1,I)
 .S PSUMLC=PSUMLC+1
 .S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)="*"_$E(X,I+1,999)
 ;
 ;   Count Lines sent
 S PSUTLC=0
 F PSUM=1:1:PSUMC S X=$O(^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUM,""),-1),PSUTLC=PSUTLC+X
 ;
 F PSUM=1:1:PSUMC D PDMAIL^PSUDEM5
 D CONF
 Q
CONF ;Construct globals for confirmation message
 ;
 N PSUDIVIS
 D INST
 S PSUDIVIS=$P(^XTMP("PSU_"_PSUJOB,"PSUSITE"),U,1)
 S PSUSUB="PSU_"_PSUJOB
 S ^XTMP(PSUSUB,"CONFIRM",PSUDIVIS,7,"M")=PSUMC
 S ^XTMP(PSUSUB,"CONFIRM",PSUDIVIS,7,"L")=PSUTLC
 Q
