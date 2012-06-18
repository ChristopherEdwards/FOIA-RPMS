ABSPOSA ; IHS/FCS/DRS - NO DESCRIPTION PROVIDED ;   [ 06/10/2002  10:12 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**2**;JUN 21, 2001
 ;
 ;  ABSPOSA contains a lot of one-liner utility routines
 ;  available for general use in the ABSPOSA* family.
 ;  And maybe other routines, too.
 Q
 ;
 ;  The Dial Out file, 9002313.55
 ; Don't directly refer to 9002313.55 in here - use $$GET55FLD instead.
 ; This resolves defaults.
 ;
 ;IHS/SD/lwj  06/10/02  new logic added to allow the package to work
 ; in a Cache environment.  Changes added to the IO subroutine - 
 ; will now check the system type, and if it is Cache, it will
 ; retrieve the value in the 420.03 field of the ABSP dial Out file
 ; rather than the 420.01 field that is used for standard MSM systems.
 ;
 ;
THEDEF55()         Q $O(^ABSP(9002313.55,"B","DEFAULT",0))
ISDEF55(DIALOUT)   Q $P(^ABSP(9002313.55,DIALOUT,0),U)="DEFAULT"
DEF5599() ;EP - what's the default dial-out as pointed to by 9002313.99?
 Q $P($G(^ABSP(9002313.99,1,"DIAL-OUT DEFAULT")),U)
DEF55(DIALOUT)  ; return pointer to the dial out used to supply defaults
 ; for this given dial-out.  For the DEFAULT dial out, lookup the
 ; pointer in 9002313.99.  For others, they point to the default.
 I $$ISDEF55(DIALOUT) Q $$DEF5599
 Q $$THEDEF55
 ;
GET55FLD(DIALOUT,FIELD) ;EP - get dialout field value; resort to default if necessary
 N X
 S X=$$GET55F1(DIALOUT,FIELD) ; try the dial-out itself first
 I X="" S X=$$GET55F1($$DEF55(DIALOUT),FIELD) ; else go to the default
 Q X
GET55F1(DIALOUT,FIELD)         ;
 Q $$GET1^DIQ(9002313.55,DIALOUT_",",FIELD,"I")
 ;
 ; How to terminate modem commands?
 ;   CR LF has been troublesome in some cases
 ;   Plain old CR seems to work fine.
 ;
TERMATOR(DIALOUT)  ; terminate modem command with what?  CR? LF? CR LF?
 Q $C(13) ; seems to work at ANMC, too.
 ;I $ZV["Windows NT" Q $C(13)
 ;Q $C(13,10)
 ;
 ;  COMMAND issues a command to the modem.
 ;  If it doesn't begin with AT, then this routine supplies it.
 ;
COMMAND(DIALOUT,COMMAND) ;EP - from ABSPOSAB
 I $E(COMMAND,1,2)'="AT" S COMMAND="AT"_COMMAND
 U $$IO(DIALOUT) W COMMAND,$$TERMATOR(DIALOUT) Q
 ;
 ;  STATUS  returns status of the dial out device.
 ;   You hope to get the result 0.
 ;
STATUS(DIALOUT)    ;
 N IO S IO=$$IO(DIALOUT)
 N ZA,ZB,ZC,RET U IO S ZA=$ZA,ZB=$ZB,ZC=$ZC
 I $$TCP(DIALOUT) D
 . S RET=$S(ZB=0:0,ZB=-3:0,1:ZB)
 E  D
 . S RET=ZC
 Q RET
 ;
 ;  MSYSTEM()  used to return the value of the type of M system
 ;    field in 9002313.99.  It's obsolete.  Not used any more.
 ; If you need this functionality, use ^%ZOSF(something)
 ;
 ; SERVER(), PORT(), IO(), TCPSERV(), MODEMTYP() 
 ;    all return information about the current dial out.
 ; It uses $$GET55FLD so as to get the value from the default dial
 ; out, or if not, from the dial out named DEFAULT.
 ;
SERVER(DIALOUT) ;EP -
 Q $$GET55FLD(DIALOUT,2021.01)
PORT(DIALOUT) ;EP -
 Q $$GET55FLD(DIALOUT,2021.02)
IO(DIALOUT) ;EP -
 ;IHS/SD/ljw 06/10/02     routine altered to incorporate changes
 ; needed for Cache.  If the system is Cache, we will retrieve
 ; the device from the 420.03 field - if it's MSM we will use
 ; the 420.01 field - both fields in ABSP Dial Out
 ;
 ; IHS/SD/lwj 06/10/02  begin changes
 ;
 N ABSPOFLD
 ;
 S ABSPOFLD=420.01   ;standard MSM systems device
 I ^%ZOSF("OS")["OpenM" S ABSPOFLD=420.03   ;Cache device
 ;
 ;Q $$GET55FLD(DIALOUT,420.01)  ;remarked out - nxt line added
 Q $$GET55FLD(DIALOUT,ABSPOFLD) ;new quit for either device
 ;
 ;IHS/SD/lwj  06/10/02  end Cache changes
 ;
TCP(DIALOUT) ;EP - 
 N X S X=$$GET55FLD(DIALOUT,420.02) Q X=2!(X=3)
TCPSERV(DIALOUT)   Q $$GET55FLD(DIALOUT,420.02)=2
T1DIRECT(DIALOUT) ;EP -
 Q $$GET55FLD(DIALOUT,420.02)=3
MODEMTYP(DIALOUT) ;EP - 
 Q $$GET55FLD(DIALOUT,.02)
