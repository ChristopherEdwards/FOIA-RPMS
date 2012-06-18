ABMUEAPI ; IHS/SD/SDR - 3PB/UFMS API   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; New routine - v2.5 p12 SDD item 4.5
 ; Checks entries in exclusion table (9002274.44)
 ; BILL tag will return YES/NO if bill should be included or not
 ;
BILL(ABMDUZ,ABMBIEN) ;PEP - Checks if bill should be send to UFMS based on
 ; exclusion table entries
 ; ABMDUZ = DUZ(2) for 3P Bill file
 ; ABMBIEN = 3P IEN
 ;
 ; Returns:
 ;  -1 - Lookup of bill fails
 ;   0 - NO
 ;   1 - YES
 N ABMBVLOC,ABMDADT,ABMBCLN,ABMIIEN,ABMBITYP
 N ABMEDM,ABMTEFDT,ABMTENDT,ABMTCLN,ABMTITYP,ABMTCLN
 S ABMINC=1  ;default to yes
 ;get Bill info
 I +$G(ABMBIEN)=0 S ABMINC="-1" Q ABMINC  ;quit w/fail if no bill found
 I +$G(ABMDUZ)=0 S ABMINC="-1" Q ABMINC  ;quit w/fail if no DUZ(2) sent
 I $G(^ABMDBILL(ABMDUZ,ABMBIEN,0))="" S ABMINC="-1" Q ABMINC
 S ABMBVLOC=$P($G(^ABMDBILL(ABMDUZ,ABMBIEN,0)),U,3)
 S ABMBADT=$P($G(^ABMDBILL(ABMDUZ,ABMBIEN,1)),U,5)
 S ABMBCLN=$P($G(^ABMDBILL(ABMDUZ,ABMBIEN,0)),U,10)
 S ABMIIEN=$P($G(^ABMDBILL(ABMDUZ,ABMBIEN,0)),U,8)
 S ABMBITYP=$P($G(^AUTNINS(ABMIIEN,2)),U)
 ;get table info and compare
 I '$D(^ABMUXCLD(ABMBVLOC)) Q ABMINC  ;quit if no entries for location
 S ABMEDM=0
 F  S ABMEDM=$O(^ABMUXCLD(ABMBVLOC,1,ABMEDM)) Q:+ABMEDM=0  D
 .S ABMTEFDT=$P($G(^ABMUXCLD(ABMBVLOC,1,ABMEDM,0)),U)  ;effective date
 .S ABMTENDT=$P($G(^ABMUXCLD(ABMBVLOC,1,ABMEDM,0)),U,2)  ;end date
 .I (ABMBADT>ABMTEFDT) D
 ..I ABMTENDT=""!(ABMTENDT'=""&((ABMBADT<ABMTENDT))) D  ;bill approved during table entry dates
 ...S ABMTCLN=$P($G(^ABMUXCLD(ABMBVLOC,1,ABMEDM,0)),U,3)  ;clinic
 ...S ABMTITYP=$P($G(^ABMUXCLD(ABMBVLOC,1,ABMEDM,0)),U,4)  ;insurer type
 ...I ABMTCLN'="",(ABMTITYP'=""),(ABMTCLN=ABMBCLN),(ABMBITYP=ABMTITYP) S ABMINC=0
 ...I ABMTCLN'="",(ABMTITYP=""),(ABMTCLN=ABMBCLN) S ABMINC=0
 ...I ABMTCLN="",(ABMTITYP'=""),(ABMTITYP=ABMBITYP) S ABMINC=0
 ;
 Q ABMINC
 ;
TRANSMIT(ABMDUZ,ABMBDFN) ;PEP - Checks if bill has previously been transmitted
 ; to UFMS
 ; ABMDUZ = DUZ(2) for 3P Bill file
 ; BDFN = 3P IEN
 ;
 ; Returns:
 ;  -1 - Lookup of bill fails
 ;   0 - NO - has not been sent
 ;   # - YES - has been sent (returns invoice number it was sent with
 ;
 S ABMINC=0  ;default to no
 ;get Bill info
 I +$G(ABMBDFN)=0 S ABMINC="-1" Q ABMINC  ;quit w/fail if no bill found
 I '$D(^ABMDBILL(ABMDUZ,ABMBDFN,69,0)) Q ABMINC  ;NO entry in 69 multiple
 S ABMXMIT=9999999999
 F  S ABMXMIT=$O(^ABMDBILL(ABMDUZ,ABMBDFN,69,ABMXMIT),-1) Q:+ABMXMIT=0  D  Q:(+ABMINC'=0)
 .I +$P($G(^ABMDBILL(ABMDUZ,ABMBDFN,69,ABMXMIT,0)),U,3)=0 D
 ..S ABMINC=$P($G(^ABMDBILL(ABMDUZ,ABMBDFN,69,ABMXMIT,0)),U,2)
 Q ABMINC
APPRDTTM(ABMDUZ2,ABMBIEN) ;PEP - returns bill date/time approved field
 ; 9002274.4, .15
 Q $P($G(^ABMDBILL(ABMDUZ2,ABMBIEN,1)),U,5)
