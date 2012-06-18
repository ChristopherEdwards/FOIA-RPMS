ACRFUFMC ;IHS/OIRM/DSD/AEF - STANDALONE UTILITY TO VERIFY BANK ROUTING NUMBERS [ 05/02/2007   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGMT SYSTEM;**22**;NOV 05, 2001
 ;LOOP THROUGH CORE OPEN DOCUMENT TMP FILE AND FIND MATCH IN ARMS
 ;
 ;Algorithm to validate Bank Routing Number:
 ;The algorithm to check the ABA Routing Number is as follows:
 ;start with a routing number like 789456124.
 ;
 ;Here's how the algorithm works.
 ;First, strip out any non-numeric characters (like dashes or spaces)
 ;and makes sure the resulting string's length is nine digits,
 ;789456124
 ;Then multiply the first digit by 3,
 ;the second by 7, the third by 1, the fourth by 3,
 ;the fifth by 7, the sixth by 1, etc., and add them all up.
 ;
 ;(7 x 3) + (8 x 7) + (9 x 1) +
 ;(4 x 3) + (5 x 7) + (6 x 1) +
 ;(1 x 3) + (2 x 7) + (4 x 1) = 160 
 ;If the resulting number is an integer multiple of 10, then the number is valid.
 ;To calculate what the checksum digit should be,
 ;follow the above algorithm for the first 8 digits.
 ;In the case above, you would come up with 156.
 ;Thus, to make the total number an integer multiple of 10,
 ;the final check digit must be 4.
 ;
EN ;EP;
 K ^ACRZ("BADROUTE")
 N ACRV,ACRV0,ACRR,ACRX,ACRY,ACRZ
 S ACRV=0
 F  S ACRV=$O(^AUTTVNDR(ACRV)) Q:'ACRV  D
 .S ACRV0=$G(^AUTTVNDR(ACRV,0))
 .Q:$P(ACRV0,U,5)                        ;DON'T BOTHER WITH INACTIVE VENDORS
 .S ACRR=$P($G(^AUTTVNDR(ACRV,19)),U,2)
 .Q:ACRR=""                              ;NO BANK ROUTING TO VERIFY
 .I $$RCK(ACRR) Q                        ;PASSES CHECK
 .S ^ACRZ("BADROUTE",ACRV)=ACRV0_U_ACRR
 Q
 ; ****************************************************
RCK(ACRR) ;EP;EXTRINSIC FUNCTION TO CHECKSUM THE EFT BANK ROUTING NUMBER
 ; ENTERS WITH THE ROUTING NUMBER = ACRX
 ;
 ; RETURNS 0 IF BAD
 ;         1 IF GOOD
 N ACRX
 S ACRX=$TR(ACRR," ")
 S ACRX=$TR(ACRX,"-")
 I $L(ACRX)'=9 Q 0                     ;BAD LENGTH
 N I,P,PP,ACRT8,ACRT9,ACRLAST
 S ACRT8=0
 F I=1:1:9 S P(I)=$E(ACRX,I)
 F I=1:3:7 S PP(I)=P(I)*3
 F I=2:3:8 S PP(I)=P(I)*7
 F I=3:3:9 S PP(I)=P(I)*1
 F I=1:1:8 S ACRT8=ACRT8+PP(I)
 S ACRT9=ACRT8+PP(9)
 I ACRT9#10'=0 Q 0                     ;NOT A MULTIPLE OF 10
 S ACRLAST=$E(ACRX,9)
 I ACRT8+ACRLAST'=ACRT9 Q 0            ;BAD CHECKSUM NUMBER
 Q 1
