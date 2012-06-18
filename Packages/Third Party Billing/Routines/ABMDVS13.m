ABMDVS13 ; IHS/ASDST/DMJ - PCC VISIT STUFF, V CPT code ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;
 ;
 ; IHS/SD/SDR - 11/04/02 - V2.5 P2 - ZZZ-0301-210046
 ;     Modified to capture modifiers from PCC
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
 Q:ABMIDONE
START ;START
 N ABMDA,ABMCPT,X,ABMCORDI,ABMSRGPR
 K AUPNCPT
 S X=$$CPT^AUPNCPT(ABMVDFN)
 Q:X
 D SURGTAB^ABMDVCK1                  ;Make sure CPT table exists
 S ABMSDT=$P(ABMP("V0"),U)
 N SF
 ;Get corresponding diagnosis
 S ABM=0
 F  S ABM=$O(^AUPNVPRC("AD",ABMVDFN,ABM)) Q:'ABM  D
 .S Y=^AUPNVPRC(ABM,0)
 .Q:$P(Y,U,5)=""
 .Q:$P(Y,U,16)=""
 .S ABMCORDI($P(Y,U,16))=$P(Y,U,5)
 S N=""
 F  S N=$O(AUPNCPT(N)) Q:N=""  D
 .S ABMDA=$P(AUPNCPT(N),U,5)
 .S SF=$P($P(AUPNCPT(N),U,4),".",2)   ;Source file
 .S ABMSRC=SF_"|"_ABMDA_"|CPT"               ;Source file|ien
 .S DA(1)=ABMP("CDFN")
 .S ABMCPT=$P(AUPNCPT(N),U)
 .S ABMMOD1=$P(AUPNCPT(N),"^",6)
 .I $G(ABMMOD1)'="" S ABMMOD1=$P($$MOD^ABMCVAPI(ABMMOD1,"E",ABMP("VDT")),U,2)  ;CSV-c
 .S ABMMOD2=$P(AUPNCPT(N),"^",7)
 .I $G(ABMMOD2)'="" S ABMMOD2=$P($$MOD^ABMCVAPI(ABMMOD2,"E",ABMP("VDT")),U,2)  ;CSV-c
 .;The next line is intended to prevent dupes being stuffed into the
 .;claim file.  It requires that other stuffing rtns put in ABMSRC
 .I $D(^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC)),(ABMCPT<ABMCPTTB("SURGERY","L"))!(ABMCPT>ABMCPTTB("SURGERY","H")) Q
 .; Needs ABMCPT, ABMSDT, ABMSRC, & DA(1) OR ABMP("CDFN")
 .D ^ABMFCPT
 K ABMSDT,N,AUPNCPT,ABMSRC
 Q
