BEXRUTL ;IHS/CMI/DAY - Print reports [ 03/02/2010  11:14 AM ] ; 12 Mar 2012  4:21 PM
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**4,5**;MAR 12, 2012;Build 1
 ;
 ;Report Utilities
 ;
 ;IHS/CMI/DAY - 07/26/2011 - Patch 5 - Add Mail/Window field for CMOP
 Q
 ;
PARSE ;EP - Parse BEX Transaction and lookup variables
 ;
 ;Set Patient IEN
 S BEXPTIEN=""
 S BEXPTIEN=$P(BEX(0),U)
 ;
 ;Set Transaction Date/Time
 S BEXTXDAT=""
 S BEXTXDAT=$P(BEX(0),U,2)
 ;
 ;Calculate Transaction Date
 S BEXDAT=$P(BEXTXDAT,".")
 ;
 ;Calculate Transaction Time
 S BEXTIM=$P(BEXTXDAT,".",2)
 ;
 ;Set RX Number
 S BEXRXNUM=""
 S BEXRXNUM=$P(BEX(0),U,3)
 ;
 ;Calculate RX IEN
 S BEXRXIEN=""
 I BEXRXNUM]"" S BEXRXIEN=$O(^PSRX("B",BEXRXNUM,0))
 ;
 ;Calculate Mail/Window
 S BEXMLWIN=""
 I +BEXRXIEN S BEXMLWIN=$P(^PSRX(BEXRXIEN,0),U,11)
 ;
 ;Set Type
 S BEXTYPE=""
 S BEXTYPE=$P(BEX(0),U,4)
 ;
 ;Set Result
 S BEXRESLT=""
 S BEXRESLT=$P(BEX(0),U,5)
 ;Check for invalid result, like ",0"
 I BEXRESLT?1P.E S BEXRESLT=""
 ;
 ;Set Renewal
 S BEXRENWL=""
 S BEXRENWL=$P(BEX(0),U,6)
 ;
 ;Set Division IEN
 S BEXDVIEN=""
 S BEXDVIEN=$P(BEX(0),U,10)
 ;
 ;Set Drug IEN
 S BEXDRIEN=""
 S BEXDRIEN=$P(BEX(0),U,11)
 ;
 ;Calculate Drug IEN if not in Piece 10
 I BEXDRIEN="",+BEXRXIEN S BEXDRIEN=$P(^PSRX(BEXRXIEN,0),U,6)
 ;
 ;Calculate Drug Name
 S BEXDRNAM=""
 I +BEXDRIEN S BEXDRNAM=$P(^PSDRUG(BEXDRIEN,0),U)
 ;
 ;Calculate Refill Date
 ;We want the first date AFTER the transaction date
 S BEXRFDAT=""
 I BEXRXIEN D
 .;
 .S Y=0
 .F  S Y=$O(^PSRX(BEXRXIEN,1,Y)) Q:'Y  D  Q:BEXRFDAT]""
 ..;
 ..;Set Refill Date
 ..S X=$P(^PSRX(BEXRXIEN,1,Y,0),U)
 ..I X<$P(BEXTXDAT,".") Q
 ..I X=$P(BEXTXDAT,".") S BEXRFDAT=X
 ..I X>$P(BEXTXDAT,".") S BEXRFDAT=X
 ..;
 ..;Set Pharmacist
 ..S BEXRPH=""
 ..S BEXRPH=$P(^PSRX(BEXRXIEN,1,Y,0),U,5)
 ..;
 ..;IHS/CMI/DAY - Patch 5 - Add Mail/Window field for CMOP
 ..;Get Mail or Window for CMOP
 S BEXMAIL=$P(BEX(0),U,12)
 ;
 Q
 ;
