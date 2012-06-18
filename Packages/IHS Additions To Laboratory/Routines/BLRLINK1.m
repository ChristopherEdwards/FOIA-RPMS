BLRLINK1 ;IHS/DIR/MJL - CONT. OF IHS LAB LINK TO PCC ; [ 12/13/2002  10:38 AM ]
 ;;5.2;LR;**1008,1009,1015,1018,1021,1027,1030**;NOV 01, 1997
 ;
 ; parsing of data elements from disk into local arrays and variables
 ; validation of lab data to determine if appropriate to send to PCC
 ;
 ; BLRVAL = array containing elements of ^BLRTXLOG (file # 9009022)
 ;
EP ; EP
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("EP^BLRLINK1 0.0")
 ;
 S BLRVAL(0)=$G(^BLRTXLOG(BLRLOGDA,0))
 S BLRVAL(1)=$G(^BLRTXLOG(BLRLOGDA,1))
 S BLRVAL(2)=$G(^BLRTXLOG(BLRLOGDA,2))
 S BLRVAL(3)=$G(^BLRTXLOG(BLRLOGDA,3))   ;IHS/ITSC/TPF 10/25/02 'SIGN OR SYMPTOM' LAB POV **1015**
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1027
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("EP^BLRLINK1 1.0","BLRVAL")
 NEW IHSLPOV
 ; Reset BLRVAL(3) if Sign or Symptom entry in BLRTXLOG contains an "^"
 I $G(^BLRTXLOG(BLRLOGDA,3))["^" D
 . S IHSLPOV=$P($G(^BLRTXLOG(BLRLOGDA,3)),"^",2)
 . ; S:$G(IHSLABPOV)="" IHSLABPOV=$P($G(^BLRTXLOG(BLRLOGDA,3)),"^")
 . S:$G(IHSLPOV)="" IHSLPOV="`"_$P($G(^BLRTXLOG(BLRLOGDA,3)),"^")  ; IHS/OIT/MKK - LR*5.2*1030
 . S BLRVAL(3)=$G(IHSLPOV)
 ;----- END IHS/OIT/MKK - LR*5.2*1027
 ;
 S BLRVAL(11)=$G(^BLRTXLOG(BLRLOGDA,11))
 S BLRVAL(12)=$G(^BLRTXLOG(BLRLOGDA,12))
 S BLRVAL(13)=$G(^BLRTXLOG(BLRLOGDA,13))
 S BLRVAL(20)=$G(^BLRTXLOG(BLRLOGDA,20))
 S BLRVAL(30)=$G(^BLRTXLOG(BLRLOGDA,30,0))  ;COMMENTS
 ;
 ; DO CHKINHL7  ; IHS/OIT/MKK - LR*5.2*1027
 D CHKINHL7^BLRLINKU    ; IHS/OIT/MKK - LR*5.2*1030
 ;
 F T=1:1 S TEXTSTR=$T(PARSE+T) S BLRSTR=$P(TEXTSTR,";",3) Q:BLRSTR=""  S NAME=$P(BLRSTR,"|"),INDX=$P(BLRSTR,"|",2),FLD=$P(BLRSTR,"|",3),@NAME=$P(BLRVAL(INDX),U,FLD)
 ; S APCDALVR("APCDTLPV")=BLRLPOV  ;IHS/ITSC/TPF 9/24/02 LAB POV **1014**
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1027
 ; NEW IHSLABPOV
 ; I $G(BLRLPOV)["^" S IHSLABPOV=$P(BLRLPOV,"^",2)
 ; S:$G(IHSLABPOV)="" IHSLABPOV=$P(BLRLPOV,"^")
 ; S APCDALVR("APCDTLPV")=IHSLABPOV ; IHS/OIT/MKK LR*5.2*1027
 ; ----- END IHS/OIT/MKK - LR*5.2*1027
 S:$$ICDCHEK^BLRLINKU(BLRLPOV) APCDALVR("APCDTLPV")="`"_BLRLPOV
 ; 
 I BLRPCC'="" S BLRPCC="" D SETNUL^BLRLINK S BLRPCC="" ; reset error flag field in IHS transaction log file
 I BLRSS="" S BLRBUL=2,BLRPCC="Test Subscript not defined",BLRERR=1 W:'BLRQUIET !,BLRPCC,! Q
 ;
 I BLR("SITE")="" S BLRBUL=2,BLRPCC="NO Institution entry",BLRERR=1 W:'BLRQUIET !,"There is no Institution entry in File #44 for this location",!,25,"V file not created" Q
 S:BLRORDL'="" BLRORDL1=$P($G(^SC(BLRORDL,0)),U,4)  ;IHS/DIR TUC/AAB 04/08/98
 S BLRORDL1=$G(BLRORDL1) I +BLRORDL1,BLR("SITE")'=BLRORDL1,BLRVIEN="" D SETTSITE ;IHS/DIR/MJL 09/20/99
 I BLRFILE'=2 D  Q   ;if not a patient in file #2 then processing is not to occur
 .S BLRBUL=$S($P($G(^BLRSITE(BLR("SITE"),0)),U,4):0,1:2)
 .S BLRPCC="Record is from file "_BLRFILE_" - is not Patient File",BLRERR=1
 .W:'BLRQUIET !,BLRPCC,!
 I BLRVADFN="" S BLRBUL=2,BLRPCC="Patient IEN is required",BLRERR=1 W:'BLRQUIET !,BLRPCC,! Q
 ;----- BEGIN IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 I $D(^DPT(BLRVADFN))<10 D  Q     ; Make certain data exists in patient file
 . S BLRBUL=2
 . S BLRPCC="No Data in Patient File for IEN "_BLRVADFN
 . S BLRERR=1
 . W:'BLRQUIET !,BLRPCC,!
 ;----- END IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 I BLRCDT="",BLRSTAT'="O" S BLRBUL=2,BLRPCC="No Collection date",BLRERR=1 W:'BLRQUIET !,BLRPCC,! Q
 ;
 I BLRCDT\1>DT S BLRBUL=0,BLRPCC="Future collection - No update of PCC",BLRERR=1 W:'BLRQUIET !,BLRPCC,! Q  ;IHS/DIR/MJL 09/20/99
 ;
 S BLRNMSPC=$O(^DIC(9.4,"C","LR",""))
 I '$D(^APCCCTRL(BLR("SITE"),11,BLRNMSPC,0)) S BLRBUL=2,BLRPCC="No Lab entry in PCC Master Control file for "_$P($G(^DIC(4,BLR("SITE"),0)),U),BLRERR=1 W:'BLRQUIET !,BLRPCC,! Q
 S PCCVISIT=+BLRVIEN ; set up flag for visit creation
 ;
FAC ; EP
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("FAC^BLRLINK1 0.0")
 S:BLRSDI="" BLRSDI="L"
 ;
 S:BLRCLIN'="" BLRCLIN="`"_BLRCLIN
 S BLRCD=$P(BLRCDT,".")
 ;
 ; S BLRPATCD=BLRVADFN_$P(BLRODT,".")  ;IHS/OIRM TUC/MJL 11/07/2000
 S BLRPATCD=BLRVADFN_$P(BLRCDT,".")    ; LR*5.2*1018 IHS -- Use Collection Date, not Order Date
 I BLRVAL(30)'="" D LCOM
 S SEX=$P($G(^DPT(BLRVADFN,0)),U,2),SEX=$S(SEX="":"",1:SEX),DOB=$P($G(^DPT(BLRVADFN,0)),U,3),AGE=$S($D(DT)&(DOB?7N):DT-DOB\10000,1:0)
 S APCDALVR("APCDPAT")=BLRVADFN
 S APCDALVR("APCDTYPE")=$S($P($G(^APCCCTRL(BLR("SITE"),0)),U,4)'="":$P($G(^(0)),U,4),1:"I")
 S APCDALVR("APCDDATE")=BLRCD
 S APCDALVR("APCDLOC")=BLR("SITE")
 S APCDALVR("APCDCLN")=BLRCLIN
 S APCDALVR("APCDTCLN")=BLRCLIN
 S APCDALVR("APCDCAT")=BLRVCAT
 D PROV Q:BLRERR
 D:BLRSS'="CH" ^BLRSPRSE
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("FAC^BLRLINK1 9.0","APCDALVR","BLR")
 Q
 ;
LCOM ; parse long comments
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("LCOM^BLRLINK1 0.0")
 ;S BLRNCOM=$P(BLRVAL(30),U,4)
 ;S:BLRNCOM>3 BLRNCOM=3
 ;F BLRLCTR=1:1:BLRNCOM S BLRCOM=$G(^BLRTXLOG(BLRIEN,30,BLRLCTR,0)) D
 ;. S BLRCOM(BLRLCTR)=$S($L(BLRCOM)>70:$E(BLRCOM,1,70),1:BLRCOM)
 ;FOLLOWING ADDED BY MARK WILLIAMS **1014**
 S BLRLCTR=0
 S BLRCMDA=0 F  S BLRCMDA=$O(^BLRTXLOG(BLRIEN,30,BLRCMDA)) Q:'BLRCMDA  D
 .S BLRLCTR=BLRLCTR+1
 .S BLRCOM=$G(^BLRTXLOG(BLRIEN,30,BLRCMDA,0))
 .S BLRCOM(BLRLCTR)=$E(BLRCOM,1,70)
 ;END MARK WILLIAMS ADDITION
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("LCOM^BLRLINK1 9.0","BLRCOM")
 Q
 ;
PROV ; check for provider location
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("PROV^BLRLINK1 0.0")
 I +BLROPRV<1 S BLRBUL=2,BLRPCC="No entry in Provider file for the Ordering Provider",BLRERR=1 W:'BLRQUIET !,BLRPCC,! Q  ;IHS/DIR TUC/AAB 3/11/98
 I BLROPRV'="",'BLR200CV S BLROPRV=$P($G(^VA(200,BLROPRV,0)),U,16) I BLROPRV="" S BLRBUL=2,BLRPCC="No entry in Provider file for the Ordering Provider",BLRERR=1 W:'BLRQUIET !,BLRPCC,! Q
 I BLREPRV'="",'BLR200CV S BLREPRV=$P($G(^VA(200,BLREPRV,0)),U,16) I BLREPRV="" S BLRBUL=2,BLRPCC="No entry in Provider file for the Encounter Provider",BLRERR=1 W:'BLRQUIET !,BLRPCC,! Q
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("PROV^BLRLINK1 9.0")
 Q
 ;
PARSE ;
 ;;BLRIEN|0|1;; seq. # (IEN of transaction log file)
 ;;BLRFILE|0|2;;
 ;;BLRDFN|0|3;; patient's ^LR ien
 ;;BLRVADFN|0|4;; patient pointer of IEN of patient file (file #2)
 ;;BLRPNAM|0|5;; patient name
 ;;BLRTLAB|0|6;; test/panel (ien)
 ;;BLRTNAM|0|7;; test/panel name
 ;;BLRSS|0|8;; lab module (CH,BB,MI,SP,AU,CY,OT)
 ;;BLR("SITE")|0|9;; clinic's institution ien [DUZ(2)]
 ;;BLRVCAT|0|10;; inpatient/outpatient category "I"= IP "A"= OP
 ;;BLRPAREN|1|1;; parent pointer to IEN of transaction log file
 ;;BLRSTAT|1|2;; order stat flag (O,R,M,D,A)
 ;;BLREPRV|1|13;; encounter provider pointer (IEN of new person file)
 ;;BLREPNM|1|14;; encounter provider name
 ;;BLRVFN|1|4;; associated V file
 ;;BLRVIEN|1|5;; ien of V file entry
 ;;BLRPCC|1|6;; error flag
 ;;BLRBILL|1|7;; billable item (1 = billable " " = nonbillable)
 ;;BLRCOST|1|8;; lab test cost
 ;;BLRCLIN|1|9;; clinic stop code
 ;;BLRCLNAM|1|10;; clinic stop name
 ;;BLRCPT|1|11;; CPT lab code pointer (IEN of file #9009021)
 ;;BLRSDI|1|15;; source of data input (non-lab or lab)
 ;;BLRCPTST|2|1;; billing CPT string
 ;;BLRODT|11|1;; order date
 ;;BLRORD|11|3;; order number
 ;;BLROPRV|11|4;; ordering provider pointer (IEN of new person file)
 ;;BLROPNM|11|5;; name of provider (used when provider pointer is null)
 ;;BLRORDL|11|6;; clinic (ordering location)
 ;;BLRCDT|12|1;; collected date/time
 ;;BLRACC|12|2;; accession number
 ;;BLRRES|20|1;; results
 ;;BLRABNL|20|2;; result N/A flag
 ;;BLRUNIT|20|3;; units
 ;;BLRSITE|20|4;; site/specimen (ien of file #61)
 ;;BLRSNAM|20|5;; site/specimen name
 ;;BLRRFL|20|8;; reference low
 ;;BLRRFH|20|9;; reference high
 ;;BLRCOLSA|13|7;; collection sample
 ;;BLRCOMDT|13|9;; complete date
 ;;BLRLOINC|13|10;; loinc code pointer
 ;;BLRLPOV|3|1;;  sign or symptom
 ;
 Q
 ;
CHECK ; EP - CHECK MASTER CONTROL FILE
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("CHECK^BLRLINK1 0.0","BLR")
 I '$D(^APCCCTRL(BLR("SITE"),0)) W:'BLRQUIET !,"The ordering facility is not an entry in the PCC Master Control File.",!,?25,"Visit not created" S BLRERR=1 Q
 I '$D(^APCCCTRL(BLR("SITE"),11,BLRNMSPC,0)) W:'BLRQUIET !!,"Entry not made in the PCC Master Control File for Lab for this ordering location ",!,?25,"PCC Visit not created" S BLRERR=1 Q
 I '$P($G(^APCCCTRL(BLR("SITE"),11,BLRNMSPC,0)),U,2) S BLRERR=1 ;; Pass data to PCC not set
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("CHECK^BLRLINK1 9.0","BLR")
 Q
 ;
CKFRSTAT ; EP
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("CKFRSTAT^BLRLINK1 0.0")
 S BLRQ=0,BLRCKP=0 F  Q:BLRQ  S BLRCKP=$O(^BLRTXLOG("AAT",BLRACC,BLRCKP)) Q:'BLRCKP  S BLRCKTN=0 F  S BLRCKTN=$O(^BLRTXLOG("AAT",BLRACC,BLRCKP,BLRCKTN)) Q:'BLRCKTN!BLRQ  D
 .I $P($G(^BLRTXLOG(BLRCKTN,1)),U,5),BLRACC=$P($G(^BLRTXLOG(BLRCKTN,12)),U,2),BLRODT=$P($G(^BLRTXLOG(BLRCKTN,11)),U) S BLR("SITE")=$P($G(^BLRTXLOG(BLRCKTN,0)),U,9),BLRQ=1 Q
 I BLRQ,BLR("SITE")=BLRORDL1 L +^BLRTXLOG(BLRIEN):60 S DIE=9009022,DA=BLRIEN,DR=".09////"_BLR("SITE") D ^DIE L -^BLRTXLOG(BLRIEN)
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("CKFRSTAT^BLRLINK1 9.0","BLR")
 K BLRCKTN,BLRCKP,BLRQ
 Q
 ;
SETTSITE ; EP
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("SETTSITE^BLRLINK1 0.0","BLR")
 S BLR("SITE")=BLRORDL1
 L +^BLRTXLOG(BLRIEN):60 S DIE=9009022,DA=BLRIEN,DR=".09////"_BLR("SITE") D ^DIE L -^BLRTXLOG(BLRIEN)
 Q
