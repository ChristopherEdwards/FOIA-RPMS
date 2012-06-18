ABMER99 ; IHS/ASDST/DMJ - UB92 EMC RECORD 99 (Processor File Control Data) ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;
 ;
 ; ABM*2.4*9 IHS/FCS/DRS 09/21/01 ; Part 12c  09/17/01  IHS/FCS/DRS
 ;   Use same Receiver ID as what is sent in Record Type 01 for Envoy
START ;START HERE
 K ABMREC(99)
 S ABME("RTYPE")=99
 D SET^ABMERUTL,LOOP
 K ABM,ABME,ABMRT
 Q
LOOP ;LOOP HERE
 F I=10:10:110 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),99,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(99)=$G(ABMREC(99))_ABMR(99,I)
 Q
10 ;Record type
 S ABMR(99,10)=99
 Q
20 ;Submitter EIN (SOURCE: FILE=, FIELD=) 
 S ABMR(99,20)=$$FMT^ABMERUTL($G(ABMRT(99,20)),"10NR")
 Q
30 ;Receiver Identification
 I $$ENVOY^ABMEF16 S ABMR(99,30)=$$ENVY^ABMERUTL(ABMP("INS"),ABMP("VTYP"))
 E  S ABMR(99,30)=$P($G(^AUTNINS(ABMP("INS"),0)),"^",8)
 S ABMR(99,30)=$$FMT^ABMERUTL(ABMR(99,30),"5NR")
 Q
40 ;Receiver Sub-Identification
 S ABMR(99,40)=""
 S ABMR(99,40)=$$FMT^ABMERUTL(ABMR(99,40),4)
 Q
50 ;Number of Batches Billed This Tape (Transmission File)
 S ABMR(99,50)=ABMEF("BATCH#")
 S ABMR(99,50)=$$FMT^ABMERUTL(ABMR(99,50),"4NR")
 Q
60 ;Accommodations Total Charges For the File
 S ABMR(99,60)=$$FMT^ABMERUTL(+$G(ABMRT(99,60)),"13NRJ2")
 Q
70 ;Accommodations Non-Covered Charges For The File
 S ABMR(99,70)=$$FMT^ABMERUTL(+$G(ABMRT(99,70)),"13NRJ2")
 Q
80 ;Ancillary Total Charges for the File
 S ABMR(99,80)=$$FMT^ABMERUTL(+$G(ABMRT(99,80)),"13NRJ2")
 Q
90 ;Ancillary Non-Covered Charges for the File
 S ABMR(99,90)=$$FMT^ABMERUTL(+$G(ABMRT(99,90)),"13NRJ2")
 Q
100 ;Filler (National Use)
 S ABMR(99,100)=""
 S ABMR(99,100)=$$FMT^ABMERUTL(ABMR(99,100),58)
 Q
110 ;Filler (Local Use)
 S ABMR(99,110)=""
 S ABMR(99,110)=$$FMT^ABMERUTL(ABMR(99,110),57)
 Q
