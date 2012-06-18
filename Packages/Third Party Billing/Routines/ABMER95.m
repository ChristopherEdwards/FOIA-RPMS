ABMER95 ; IHS/ASDST/DMJ - UB92 EMC RECORD 90 (Claim Control Screen) ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;
 ;
 ; ABM*2.4*9 IHS/FCS/DRS 09/21/01 ; Part 12b IHS/FCS/DRS  09/17/01
 ; - Use same Receiver ID as what is being sent in Record Type 01
 ;
START ;START HERE
 K ABMREC(95)
 S ABME("RTYPE")=95
 D SET^ABMERUTL,LOOP
 K ABM,ABME,ABMRT(95)
 Q
LOOP ;LOOP HERE
 F I=10:10:130 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),95,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(95)=$G(ABMREC(95))_ABMR(95,I)
 Q
10 ;Record type
 S ABMR(95,10)=95
 Q
20 ;Provider EIN (SOURCE: FILE=, FIELD=) 
 S ABMR(95,20)=$$FMT^ABMERUTL(+$G(ABMRT(95,20)),"10NR")
 Q
30 ;Receiver Identification
 I $$ENVOY^ABMEF16 S ABMR(95,30)=$$ENVY^ABMERUTL(ABMP("INS"),ABMP("VTYP"))
 E  S ABMR(95,30)=$P($G(^AUTNINS(ABMP("INS"),0)),"^",8)
 S ABMR(95,30)=$$FMT^ABMERUTL(ABMR(95,30),"5NR")
 Q
40 ;Receiver Sub-Identification
 S ABMR(95,40)=""
 S ABMR(95,40)=$$FMT^ABMERUTL(ABMR(95,40),4)
 Q
50 ;Type of Batch
 S ABMR(95,50)=ABMP("OBTYP")
 S ABMR(95,50)=$$FMT^ABMERUTL(ABMR(95,50),3)
 Q
60 ;Number of Claims
 S ABMR(95,60)=$$FMT^ABMERUTL(+$G(ABMRT(95,60)),"6NR")
 Q
70 ;Filler (National Use)
 S ABMR(95,70)=""
 S ABMR(95,70)=$$FMT^ABMERUTL(ABMR(95,70),6)
 Q
80 ;Total Charges - Accommodations
 S ABMR(95,80)=$$FMT^ABMERUTL(+$G(ABMRT(95,80)),"12NRJ2")
 Q
90 ;Total Non-Covered Charges
 S ABMR(95,90)=$$FMT^ABMERUTL(+$G(ABMRT(95,90)),"12NRJ2")
 Q
100 ;Total Charges - Ancillary
 S ABMR(95,100)=$$FMT^ABMERUTL(+$G(ABMRT(95,100)),"12NRJ2")
 Q
110 ;Total Non-Covered Charges - Ancillary
 S ABMR(95,110)=$$FMT^ABMERUTL(+$G(ABMRT(95,110)),"12NRJ2")
 Q
120 ;Filler (National Use)
 S ABMR(95,120)=""
 S ABMR(95,120)=$$FMT^ABMERUTL(ABMR(95,120),54)
 Q
130 ;Filler (Local Use)
 S ABMR(95,130)=""
 S ABMR(95,130)=$$FMT^ABMERUTL(ABMR(95,130),54)
 Q
