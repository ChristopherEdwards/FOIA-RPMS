BDWDWPX ; IHS/CMI/LAB - RPMS report for DW export-3/12/2004 12:46:58 PM ; 30 May 2005  6:52 PM
 ;;1.0;IHS DATA WAREHOUSE;**2**;JAN 23, 2006
 ;
 ;IHS/SD/lwj 4/16/04 
 ; DW team requested changes - routine altered to allow
 ; automate calls and ready for natl dist.
 ; * variables "new"ed for integration
 ; * temp gbl renamed to BDWDWPX for XBGSAVE
 ; * visit info excluded
 ; * merged patients bypassed
 Q    ;IHS/SD/lwj
 ;
INCREP ;EP IHS/SD/lwj 4/20/04 gather information for patients 
 ; whose records have been modified since the last
 ; update export.  This entry point is called from the
 ; DW menu and needs to be run PRIOR to the export.
 W:$D(IOF) @IOF
 W !!,"This option is used to create a registration audit file prior"
 W !,"to generate transactions to send to the data warehouse (GDW option)."
 W !!,"This option should only be run immediately prior to using the GDW"
 W !,"option."
 S BDW("RUN LOCATION")=$P($G(^BDWSITE(1,0)),U)
 I DUZ(2)'=BDW("RUN LOCATION") W !,"You need to be logged in as ",$P(^DIC(4,BDW("RUN LOCATION"),0),U)," in order to do this audit report.",! K BDW Q
 K DIR
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 K ^BDWDWPX($J)
 S ^BDWDWPX($J,0)="H0^"_$P($$DATE^INHUT($$NOW^XLFDT,1),"-")
 N DFN,AGDPT,AGAUPN,AGNAME,AG,AGRCNT,AGFLAG
 S U="^"
 S (AGRCNT,DFN)=0
 W !!,"Now creating the update DW Patient Audit file...."
 F  S DFN=$O(^AUPNDWAF(DFN)) Q:+DFN=0  D
 . I '$D(^AUPNPAT(DFN,0)) Q
 . S AGDPT=$G(^DPT(DFN,0))
 . Q:AGDPT=""
 . Q:$P(AGDPT,U,19)]" "   ;IHS/SD/lwj 4/20/04 merged away flag set
 . S AGAUPN=$G(^AUPNPAT(DFN,0))
 . S AGNAME=$P($G(^DPT(DFN,0)),U)
 . D PROCESS
 . S AGRCNT=AGRCNT+1
 . I AGRCNT#100=0 W "."
 ;
 S:AGRCNT>0 AGFLAG=$$WRITE^BDWDWPX1 ;IHS/CMI/LAB - had to break routine due to size
 I AGRCNT=0  D
 . W !!!,"****  DW INCREMENTAL FILE EMPTY - "
 . W " AUDIT FILE NOT CREATED   ****",!!!
 . H 5
 Q
FULLEP() ;EP IHS/SD/lwj 4/20/04 gather information for all patients
 ; This entry point is called from the BDW1BLR routine, which
 ; is a full patient export for the data warehouse.
 K ^BDWDWPX($J) S ^BDWDWPX($J,0)="H0^"_$P($$DATE^INHUT($$NOW^XLFDT,1),"-")
 N DFN,AGDPT,AGAUPN,AGNAME,AG,AGRCNT,AGFLAG
 S U="^"
 S (DFN,AGRCNT)=0
 W !!,"Now creating the full DW Patient Audit file...."
 F  S DFN=$O(^DPT(DFN)) Q:'+DFN  D
 . S AGDPT=$G(^DPT(DFN,0))
 . Q:$P(AGDPT,U,19)]" "   ;IHS/SD/lwj 4/20/04 merged away flag set
 . S AGAUPN=$G(^AUPNPAT(DFN,0))
 . S AGNAME=$P($G(^DPT(DFN,0)),U)
 . D PROCESS
 . S AGRCNT=AGRCNT+1
 . W:AGRCNT#1000=0 "."
 S AGFLAG=$$WRITE^BDWDWPX1
 Q AGFLAG
PROCESS ; this routine simply acts as the driver for gathering the 
 ; needed information - regardless of a full or partial run
 N AGCCHK,AGUID
 D P1REC      ;demographic info
 D P2REC      ;more demographic info
 D P4REC      ;chart information
 I 'AGCCHK K AG(DFN) Q   ;no chart?  don't continue
 D SAVE       ;save the p1 and p2 records to the global
 D P3REC      ;alias information
 D CARE       ;gather medicare info (p5 record)
 D RAIL       ;gather railroad info (p5 record)
 D CAID       ;gather medicaid info (p5 record)
 D PI         ;gather private insurance info (p5 record)
 D SAVE2      ;save the p3, p4 and p5 records to the global
 K AG(DFN)
 Q
 ;
P1REC ; this routine creates the P1 record
 ; P1^Unique ID^Modication Date^Unique Reg ID^DOB^Date of Death
 ;  ^Cause of Death^Gender^SSN^SSN Verification Code^Father
 ;  ^Mother^Creation Date
 N AGDOB,AGDOD,AGCOD,AGSEX,AGSSN,AGSSNV
 N AGFTHR,AGMTHR,AGCRTDT,AGURID,AGMDT
 S AGUID=$$UID^BDWAID(DFN)  ;Unique ID
 S AGMDT=""
 S:$D(^AUPNDWAF(DFN)) AGMDT=$$DATE^INHUT($P(^AUPNDWAF(DFN,0),U,2))  ;Date/Time of mods
 S AGURID=DFN  ;Unique Reg ID
 S AGDOB=$$DATE^INHUT($P(AGDPT,U,3))  ;DOB
 S AGDOD=$$DATE^INHUT($P($G(^DPT(DFN,.35)),U))  ;DOD
 S AGCOD=$P($G(^AUPNPAT(DFN,11)),U,14)  ;Cause of Death
 ;S:$G(AGCOD)'="" AGCOD=$P($G(^ICD9(AGCOD,0)),"^")  ;cmi/anch/maw 8/27/2007 orig line patch 2
 S:$G(AGCOD)'="" AGCOD=$P($$ICDDX^ICDCODE(AGCOD,AGDOD),"^",2)  ;cmi/anch/maw 8/27/2007 code set versioning patch 2
 S AGSEX=$P(AGDPT,U,2)  ;Gender
 S AGSSN=$P(AGDPT,U,9)  ;SSN
 S AGSSNV=$$GET1^DIQ(9000001,DFN,.23)  ;SSN ver. code
 S AGFTHR=$P($G(^DPT(DFN,.24)),U)  ;father
 S AGMTHR=$P($G(^DPT(DFN,.24)),U,3)  ; mother
 S AGCRTDT=$$DATE^INHUT($P(AGAUPN,U,2))  ;create date
 S AG(DFN,"P1")="P1^"_AGUID_"^"_AGMDT_"^"_AGURID
 S AG(DFN,"P1")=$G(AG(DFN,"P1"))_"^"_AGDOB_"^"_AGDOD_"^"_AGCOD_"^"_AGSEX
 S AG(DFN,"P1")=$G(AG(DFN,"P1"))_"^"_AGSSN_"^"_AGSSNV_"^"_AGFTHR
 S AG(DFN,"P1")=$G(AG(DFN,"P1"))_"^"_AGMTHR_"^"_AGCRTDT
 Q
P2REC ;this subroutine creates the P2 record
 ; P2^Unique ID^Modification Date^Patient^Address^City^State
 ;  ^Zip^Community of Residence^Date Moved^Eligibility
 ;  ^Veteran^Classification^Tribe^Blood Quantum^Rec Status
 N AGPAT,AGSTR,AGCITY,AGST,AGZIP,AGCOM,AGDTM,AGVET,AGCLS
 N AGTRIBE,AGBLD,AGRECS,AGELIG,AGVAL,AGMDT
 S AGMDT=""
 S:$D(^AUPNDWAF(DFN)) AGMDT=$$DATE^INHUT($P(^AUPNDWAF(DFN,0),U,4))  ;Date/Time of mods
 S AGPAT=$P(AGDPT,U)  ;patient
 S AGSTR=$P($G(^DPT(DFN,.11)),U)  ;street
 S AGCITY=$P($G(^DPT(DFN,.11)),U,4)  ;city
 ;S AGST=$P($G(^DPT(DFN,.11)),U,5) S AGST=$S($G(AGST):$P(^DIC(5,AGST,0),U,2),1:"") ;state  IHS/SD/lwj 7/15/04 use VA state code now
 S AGST=$P($G(^DPT(DFN,.11)),U,5) S AGST=$S($G(AGST):$P(^DIC(5,AGST,0),U,2),1:"") ;state   IHS/SD/lwj 7/15/04 using VA state code
 S AGZIP=$P($G(^DPT(DFN,.11)),U,6)  ;zip
 S AGCOM=$P($G(^AUPNPAT(DFN,11)),U,17)  ;community of residence
 S:AGCOM AGCOM=$P($G(^AUTTCOM(AGCOM,0)),U,8)
 S AGDTM=$$DATE^INHUT($P($G(^AUPNPAT(DFN,11)),U,13))  ;date moved to community
 S AGELIG=$P($G(^AUPNPAT(DFN,11)),U,12)  ;eligibility
 S AGVET=$S($D(^DPT(DFN,"VET")):$P($G(^DPT(DFN,"VET")),U),1:"N")  ;veteran elig
 S AGCLS=$S($P($G(^AUPNPAT(DFN,11)),U,11):$P($G(^AUTTBEN($P($G(^AUPNPAT(DFN,11)),U,11),0)),U,2),1:"")  ;class
 S AGTRIBE=$S($P($G(^AUPNPAT(DFN,11)),U,8):$P($G(^AUTTTRI($P($G(^AUPNPAT(DFN,11)),U,8),0)),U,2),1:"")  ;tribe
 S AGVAL=$P($G(^AUPNPAT(DFN,11)),U,10)  ;blood
 D QNTCVT^AGTX1  ;converts quantum to number 1->7
 S AGBLD=Y
 S AGRECS=$P($G(^DPT(DFN,0)),U,19)  ;reg record status
 S AG(DFN,"P2")="P2^"_AGUID_"^"_AGMDT_"^"_AGPAT_"^"_AGSTR_"^"_AGCITY_"^"_AGST_"^"_AGZIP
 S AG(DFN,"P2")=$G(AG(DFN,"P2"))_"^"_AGCOM_"^"_$G(AGDTM)_"^"_AGELIG_"^"_AGVET
 S AG(DFN,"P2")=$G(AG(DFN,"P2"))_"^"_AGCLS_"^"_AGTRIBE_"^"_AGBLD_"^"_AGRECS
 Q
 ;
P3REC ;this subroutine creates the P3 record - Alias
 ; P3^Unique ID^Modification Date^Alais
 N AGALS,AGD0,AGMDT
 S AGMDT=""
 S:$D(^AUPNDWAF(DFN)) AGMDT=$$DATE^INHUT($P(^AUPNDWAF(DFN,0),U,6))  ;Date/Time of mods
 S AGD0=0
 F  S AGD0=$O(^DPT(DFN,.01,AGD0)) Q:AGD0=""  D
 . S AGALS=$P($G(^DPT(DFN,.01,AGD0,0)),U)
 . S AG(DFN,"P3",AGD0)="P3^"_AGUID_"^"_AGD0_"^"_AGMDT_"^"_AGALS
 Q
 ;
P4REC ;this subroutine creates the P4 record - facility/chart info
 ; P4^Unique ID^Modification Date^Facility^Chart^Chart Status
 N AGCFAC,AGCHRT,AGCHRTS,AGD0,AGMDT,AGPAT41
 S AGCCHK=0  ;chart check flag
 S AGMDT=""
 S:$D(^AUPNDWAF(DFN)) AGMDT=$$DATE^INHUT($P(^AUPNDWAF(DFN,0),U,8))  ;Date/Time of mods
 S AGD0=0
 F  S AGD0=$O(^AUPNPAT(DFN,41,AGD0)) Q:+AGD0=0  D
 . Q:$P($G(^AGFAC(AGD0,0)),"^",21)'="Y"   ;only want ORFs
 . S AGCFAC=$P($G(^AUTTLOC(AGD0,0)),U,10)
 . S AGPAT41=$G(^AUPNPAT(DFN,41,AGD0,0))
 . S AGCHRT=$P(AGPAT41,U,2)  ;chart
 . S AGCHRTS=$P(AGPAT41,U,5)  ;chart status
 . S AG(DFN,"P4",AGD0)="P4^"_AGUID_"^"_AGCFAC_"^"_AGMDT_"^"_AGCFAC_"^"_AGCHRT_"^"_AGCHRTS
 . S AGCCHK=1  ;chart found
 Q
 ;
CARE ; Create p5 record - medicare eligibility
 N AGLID,AGDTM,AGCAT,AGCOV,AGBEG,AGPOLN,AGMCDST,AGMCDPLN
 N AGINS,AGEND,AGEIN,AGPRE,AGPOL,AGREL,AGUPDT,AGCNT
 N AGD1,AGMDT
 Q:'$D(^AUPNMCR(DFN))  ;no entry in mcr file
 S AGLID=DFN  ;local ID
 S AGCNT=1
 S AGMDT=""
 S:$D(^AUPNDWAF(DFN)) AGDTM=$$DATE^INHUT($P(^AUPNDWAF(DFN,0),U,11))  ;Date/Time of mods
 S AGCAT="MCR"  ;Ins. Category
 S AGPOLN=$P($G(^AUPNMCR(DFN,0)),U,3)  ;policy number
 S AGPRE=$P($G(^AUPNMCR(DFN,0)),U,4) ;Prefix/Suffix
 S AGMCDST=""  ;MCD state
 S AGMCDPLN=""  ;MCD plan
 S AGEIN=$S($P($G(^AUPNMCR(DFN,0)),U,2):$P($G(^AUTNINS($P($G(^AUPNMCR(DFN,0)),U,2),0)),U,7),1:"")  ;Insurer EIN
 S AGPOL="" I $P($G(^AUPNMCR(DFN,0)),U) S AGPOL=$P($G(^DPT($P($G(^AUPNMCR(DFN,0)),U),0)),"^")  ;Policy Holder
 S AGREL=""  ;Relationship
 S AGUPDT=$$DATE^INHUT($P($G(^AUPNMCR(DFN,0)),U,7))  ;Date of last update
 S AGINS=$S($P($G(^AUPNMCR(DFN,0)),U,2):$P($G(^AUTNINS($P($G(^AUPNMCR(DFN,0)),U,2),0)),U),1:"")  ;Insurer name  cmi/maw 6/30/2004 missing insurer causes sbscr
 I $P($G(^AUPNMCR(DFN,0)),U,4)'="" S AGPRE=$P(^AUTTMCS($P($G(^AUPNMCR(DFN,0)),U,4),0),"^") ;Policy Prefix/Suffix
 S AGD1=0
 F  S AGD1=$O(^AUPNMCR(DFN,11,AGD1)) Q:AGD1=""  D
 . S AGCOV=$P($G(^AUPNMCR(DFN,11,AGD1,0)),U,3)  ;Coverage Type
 . S AGBEG=$$DATE^INHUT($P($G(^AUPNMCR(DFN,11,AGD1,0)),U,1)) ;Begin date
 . S AGEND=$$DATE^INHUT($P($G(^AUPNMCR(DFN,11,AGD1,0)),U,2)) ;End date
 . D P5REC   ;write the p5 record to the array
 Q
 ;
RAIL ; Create p5 record - railroad eligibility
 N AGLID,AGDTM,AGCAT,AGCOV,AGBEG,AGPOLN,AGMCDST,AGMCDPLN
 N AGINS,AGEND,AGEIN,AGPRE,AGPOL,AGREL,AGUPDT,AGCNT
 N AGD1,AGMDT
 S AGCNT=1
 Q:'$D(^AUPNRRE(DFN))
 S AGLID=DFN  ;local ID
 S AGMDT=""
 S:$D(^AUPNDWAF(DFN)) AGDTM=$$DATE^INHUT($P(^AUPNDWAF(DFN,0),U,11))  ;Date/Time of mods
 S AGCAT="RRE"  ;Ins. Category
 S AGPOLN=$P($G(^AUPNRRE(DFN,0)),U,4)  ;policy number
 S AGMCDST=""  ;MCD state
 S AGMCDPLN=""  ;MCD plan
 S AGINS=$P($G(^AUPNRRE(DFN,0)),U,2) ;Insurer pointer
 Q:AGINS=""
 S AGINS=$P($G(^AUTNINS(AGINS,0)),U) ;Insurer name
 S AGEIN=$S($P($G(^AUPNRRE(DFN,0)),U,2):$P($G(^AUTNINS($P($G(^AUPNRRE(DFN,0)),U,2),0)),U,7),1:"")  ;Insurer EIN
 I $P($G(^AUPNRRE(DFN,0)),U,3)'="" S AGPRE=$P(^AUTTRRP($P($G(^AUPNRRE(DFN,0)),U,3),0),"^") ;Policy Prefix/Suffix
 E  S AGPRE=""
 S AGPOL=""  ;Policy Holder
 S AGREL=""  ;Relationship
 S AGUPDT=$$DATE^INHUT($P($G(^AUPNRRE(DFN,0)),U,7))  ;Date of last update
 S AGD1=0  ;IHS/SD/lwj 5/3/04 chged from ""
 F  S AGD1=$O(^AUPNRRE(DFN,11,AGD1)) Q:AGD1=""  D
 . S AGCOV=$P($G(^AUPNRRE(DFN,11,AGD1,0)),U,3) ;Coverage Type
 . S AGBEG=$$DATE^INHUT($P($G(^AUPNRRE(DFN,11,AGD1,0)),U,1)) ;Begin date
 . S AGEND=$$DATE^INHUT($P($G(^AUPNRRE(DFN,11,AGD1,0)),U,2)) ;End date
 . D P5REC    ;write the p5 record to the array
 Q
 ;
CAID ; Create p5 record - medicaid eligibility
 N AGLID,AGDTM,AGCAT,AGCOV,AGBEG,AGPOLN,AGMCDST,AGMCDPLN
 N AGINS,AGEND,AGEIN,AGPRE,AGPOL,AGREL,AGUPDT,AGCNT
 N AGIEN,AGD1
 S AGCNT=1
 S AGDTM=""
 S AGIEN=0
 F  S AGIEN=$O(^AUPNMCD("B",DFN,AGIEN)) Q:AGIEN=""  D
 . S AGLID=AGIEN  ;local ID
 . S:$D(^AUPNDWAF(DFN)) AGDTM=$$DATE^INHUT($P(^AUPNDWAF(DFN,0),U,11))  ;Date/Time of mods
 . S AGCAT="MCD"  ;Ins. Category
 . S AGPOLN=$P($G(^AUPNMCD(AGIEN,0)),"^",3)  ;policy number
 . S AGMCDST=""
 . S:$P($G(^AUPNMCD(AGIEN,0)),U,4) AGMCDST=$P($G(^DIC(5,$P($G(^AUPNMCD(AGIEN,0)),U,4),0)),U,3) ;MCD stateIHS/CMI/LAB - changed piece 2 to piece 3 for state code
 . S AGMCDPLN=$S($P($G(^AUPNMCD(AGIEN,0)),U,10):$P($G(^AUTNINS($P($G(^AUPNMCD(AGIEN,0)),U,10),0)),U),1:"") ;MCD plan
 . S AGINS=$S($P($G(^AUPNMCD(AGIEN,0)),U,2):$P($G(^AUTNINS($P($G(^AUPNMCD(AGIEN,0)),U,2),0)),U),1:"") ;Insurer name
 . S AGEIN=$S($P($G(^AUPNMCD(AGIEN,0)),U,2):$P($G(^AUTNINS($P($G(^AUPNMCD(AGIEN,0)),U,2),0)),U,7),1:"")  ;Insurer EIN
 . S AGPRE=""  ;Policy Prefix/Suffix
 . S AGUPDT=$$DATE^INHUT($P($G(^AUPNMCD(AGIEN,0)),U,8)) ;Date of last update
 . S AGPOL=$S($P($G(^AUPNMCD(AGIEN,0)),U,9):$P($G(^DPT($P($G(^AUPNMCD(AGIEN,0)),U,9),0)),U),1:$P($G(^AUPNMCD(AGIEN,0)),U,5)) ;Policy Holder
 . S AGREL=$S($P($G(^AUPNMCD(AGIEN,0)),U,6):$P($G(^AUTTRLSH($P($G(^AUPNMCD(AGIEN,0)),U,6),0)),U),1:"") ;Relationship
 . S AGD1=0
 . F  S AGD1=$O(^AUPNMCD(AGIEN,11,AGD1)) Q:AGD1=""  D
 .. S AGCOV=$P($G(^AUPNMCD(AGIEN,11,AGD1,0)),U,3)  ;Coverage Type
 .. S AGBEG=$$DATE^INHUT($P($G(^AUPNMCD(AGIEN,11,AGD1,0)),U,1)) ;Begin date
 .. S AGEND=$$DATE^INHUT($P($G(^AUPNMCD(AGIEN,11,AGD1,0)),U,2)) ;End date
 .. D P5REC   ;write the p5 record out to the array
 Q
 ;
PI ; Create p5 record - private eligibility
 N AGLID,AGDTM,AGCAT,AGCOV,AGBEG,AGPOLN,AGMCDST,AGMCDPLN
 N AGINS,AGEND,AGEIN,AGPRE,AGPOL,AGREL,AGUPDT,AGCNT
 N AGPOLI,AGD1,AGPOL0
 S AGCNT=1
 Q:'$D(^AUPNPRVT(DFN))
 S AGD1=0
 F  S AGD1=$O(^AUPNPRVT(DFN,11,AGD1)) Q:AGD1=""!(+AGD1=0)  D
 . Q:$P(^AUPNPRVT(DFN,11,AGD1,0),U)=""
 . S (AGPOL,AGCOV,AGPOLN,AGDTM)=""
 . S AGLID=AGD1  ;local ID
 . S:$D(^AUPNDWAF(DFN)) AGDTM=$$DATE^INHUT($P(^AUPNDWAF(DFN,0),U,11))  ;Date/Time of mods
 . S AGCAT="PVT"  ;Ins. Category
 . S AGBEG=$$DATE^INHUT($P($G(^AUPNPRVT(DFN,11,AGD1,0)),U,6))  ;Begin dt
 . S AGPOLI=$P($G(^AUPNPRVT(DFN,11,AGD1,0)),U,8) ;Policy Hldr 
 . I $G(AGPOLI) D
 .. S AGPOL0=$G(^AUPN3PPH(AGPOLI,0))  ;policy hldr file
 .. S AGPOL=$P(AGPOL0,U)
 .. S AGPOLN=$P(AGPOL0,U,4)  ;policy #
 .. S AGCOV=$P(AGPOL0,U,5)  ;covg type pntr
 .. S:AGCOV'="" AGCOV=$P($G(^AUTTPIC(AGCOV,0)),U) ;Covg Type
 . S AGMCDST=""  ;MCD state
 . S AGMCDPLN=""  ;MCD plan
 . S AGINS=$P($G(^AUTNINS($P($G(^AUPNPRVT(DFN,11,AGD1,0)),U,1),0)),U) ;Insurer name
 . S AGEND=$$DATE^INHUT($P($G(^AUPNPRVT(DFN,11,AGD1,0)),U,7)) ;End date
 . S AGEIN=$S($P($G(^AUPNPRVT(DFN,11,AGD1,0)),U):$P($G(^AUTNINS($P($G(^AUPNPRVT(DFN,11,AGD1,0)),U),0)),U,7),1:"")  ;Insurer EIN
 . S AGPRE=""  ;Policy Prefix/Suffix
 . S AGREL=$S($P($G(^AUPNPRVT(DFN,11,AGD1,0)),U,5):$P($G(^AUTTRLSH($P($G(^AUPNPRVT(DFN,11,AGD1,0)),U,5),0)),U),1:"")  ;Relationship
 . S AGUPDT=""  ;Date of last update
 . D P5REC      ;write the p5 record to the array
 Q
 ;
P5REC ; write the eligibility data to the p5 record in the array   
 ; P5^Unique ID^Modification Date^Category^Coverage Type
 ;  ^Begin Date^Policy Number^Medicaid State^Plan^Insurer
 ;  ^End Date^Insurer EIN^Prefix/Suffix^Policy Holder
 ;  ^Relationship^Last Updated
 S AG(DFN,"P5",AGCAT_AGCNT_AGD1)="P5^"_AGUID_"^"_$G(AGDTM)_"^"_AGCAT_"^"_AGCOV_"^"_AGBEG
 S AG(DFN,"P5",AGCAT_AGCNT_AGD1)=$G(AG(DFN,"P5",AGCAT_AGCNT_AGD1))_"^"_AGPOLN_"^"_AGMCDST_"^"_AGMCDPLN
 S AG(DFN,"P5",AGCAT_AGCNT_AGD1)=$G(AG(DFN,"P5",AGCAT_AGCNT_AGD1))_"^"_AGINS_"^"_AGEND_"^"_AGEIN
 S AG(DFN,"P5",AGCAT_AGCNT_AGD1)=$G(AG(DFN,"P5",AGCAT_AGCNT_AGD1))_"^"_AGPRE_"^"_AGPOL_"^"_AGREL_"^"_AGUPDT
 S AGCNT=AGCNT+1
 Q
 ;
SAVE ; save the p1 and p2 array entries to the temp global 
 N AGTMP,AGTMP1,AGTMP2
 S AGTMP=""
 F AGTMP="P1","P2" D
 .S ^BDWDWPX($J,DFN,AGTMP)=$G(AG(DFN,AGTMP))
 .K AG(DFN,AGTMP)
 Q
 ;
SAVE2 ; save the p3, p4 and p5 array entries (which may be multiples) 
 ; to the temp global
 N AGTMP1,AGTMP2
 S (AGTMP1,AGTMP2)=""
 F AGTMP1="P3","P4","P5" D
 .S AGTMP2=0
 .F  S AGTMP2=$O(AG(DFN,AGTMP1,AGTMP2)) Q:AGTMP2=""  D
 ..S ^BDWDWPX($J,DFN,AGTMP1,AGTMP2)=$G(AG(DFN,AGTMP1,AGTMP2))
 K AG(DFN)
 Q
