BGUXUSRB ; IHS/OIT/MJL - Request Broker ; [ 04/18/2006   2:21 PM ]
 ;;1.5;BGU;**1,2**;MAY 26, 2005
 Q  ;No entry from top
 ;
 ;DATA BROKER calls, First parameter is always call-by-reference
 ;
VALIDAV(RESULT,ACODE,VCODE,BGUETH,BGUAPP,BGUPRM) ;EP Check a users access
 ;Return user's name&DUZ^FM access codes^change code^# facility entries;Default facility&IEN;Facility&IEN;n times^Calling application parameter space holder  -- ihs's
 ;  ACODE=ACCESS CODE ENCRIPTED FROM CLIENT
 ;  VCODE=VERIFY CODE ENCRIPTED FROM CLIENT
 ; BGUETH=ETHERNET HEX ADDRESS OF CLIENT CARD
 ; BGUAPP=APPLICATION ID/VERSION
 ; BGUPRM=SECURITY PARAMETER PASSED BY CLIENT
 ;
 ;1/24/97SWC- tags/externals used :
 ;A1, SET1, $$CHECKAV, $$VCVALID(), $$NO(), $$GETFC^BGUGFAC(DUZ)
 ;S AVCODE=$$DECRYP(AVCODE)
 D A1
 D SET1
 ;N X,XUSER,XUF,%1 S U="^",XUF=0,DUZ=$$CHECKAV^XUS(ACODE,VCODE,XUSER)
 N X,XUSER,XUF,%1,XUERR
 S U="^",XUF=0,XUSER="",DUZ=$$CHECKAV(ACODE,VCODE,.XUSER)
 ;I- RESULT(1) = 0 ^ N1 ^ N2 ^ ERROR-MSG-TEXT
 ;So in OCX, once it is determined that it is an error, I know that if
 ;$P(XUERR,U,2)=0, non-fatal XUERR error.=1, FATAL error. If
 ;$P(XUERR,U,3) =12, then trigger Modify Verify dlgbox.
 ;( Currently, we only care about XUM=12. )
 S VCOK=$$VCVALID()
 I VCOK=1 S XUM=12,XUERR=$$NO() D SNDER Q  ;,RESULT(1)=0_U_XUGUIER
 ;IB- Temp-Insert 1 line, ONLY when TESTING for GUI VERIFY modify
 ;I DUZ=613 S XUM=12,XUERR=$$NO() D SNDER Q  ;me. 604=FJ in [APD,AAA] only.
 ;
 ;I $G(DUZ)>0 S RESULT(1)=$P(^VA(200,DUZ,0),U)_"&"_DUZ_U_$P(^VA(200,DUZ,0),U,4)_U_0_U_"2;SELLS HOSPITAL&4587;SAN XAVIER CLINIC&4585"_U_""
 I $G(DUZ)>0 S RESULT(1)=$P(^VA(200,DUZ,0),U)_"&"_DUZ_U_$P(^VA(200,DUZ,0),U,4)_U_0_U_$$GETFC^BGUGFAC(DUZ)_U_"",$P(^VA(200,DUZ,1.1),U,1)=$$NOW^XLFDT D:$G(WEB) DUZ^XUP(DUZ)
 ; When the Listener isn't running the string returned to the client
 ; is the same as an A/V failure.
 ; The zero is set in the 3rd piece to differentiate between a true A/V
 ; failure and the Listener not running. (This routine isn't called if
 ; the Listener isn't running.)
 E  S RESULT(1)=0_U_XUSER("ERR")_U_0
 Q
 ;
INTRO(RESULT) ;Return INTRO TEXT.
 D INTRO^XUS1A("RESULT")
 Q
 ;
CVC(RESULT,XU1) ;change VC
 S RESULT(1)=0 Q:$G(DUZ)'>0  N XU2 S U="^",XU2=$P(XU1,U,2),XU1=$P(XU1,U)
 ;S XU1=$$DECRYP(XU1),XU2=$$DECRYP(XU2)
 ;Q $$XXCVC^XUS2(XU1,XU2)
 S RESULT(1)=0
 Q
 ;
CAC(RESULT,XU1) ;change AC
 S RESULT(1)=0 Q:$G(DUZ)'>0  N XU2 S U="^",XU2=$P(XU1,U,2),XU1=$P(XU1,U)
 ;S XU1=$$DECRYP(XU1),XU2=$$DECRYP(XU2)
 ;Q $$XXCVC^XUS2(XU1,XU2)
 S RESULT(1)=0
 Q
 ;
CFAC(RESULT,XU1) ; change facility id (DUZ(2))
 S:'$D(DUZ(2)) DUZ(2)=$G(XU1)
 I +DUZ(2)<1 S XUM=4,XUERR=$$NO() D SNDER Q
 S:$D(DUZ("AG")) DUZ("AG")=""
 S:'$D(DUZ("AG")) DUZ("AG")=""
 D:DUZ(2)'=""
 .S BGUX=$P($G(^DIC(4,DUZ(2),99)),"^",5)
 .S:DUZ("AG")="" DUZ("AG")=$S(BGUX'="":BGUX,1:$P($G(^XTV(8989.3,1,0)),"^",8))
 S RESULT(1)=0
 Q
 ;
SETUP(RESULT) ;sets up environment for GUI signon
 D SET1^XUS
 S RESULT(0)=$P(XUENV,U,3) ;server name
 S RESULT(1)=$P(XUVOL,U) ; volume
 S RESULT(2)=XUCI ; uci
 S RESULT(3)=$G(IO) ; device
 Q
 ;
A1 ;Set some basics.
 S U="^",DT=$$DT^XLFDT()
 Q
 ;
CHECKAV(X1,X2,USER) ;Check A/V code return DUZ
 N %,X,Y
 K USER("ERR")
 ;[] ":" is a char in the hashed code. it will have to be
 ;                  changed to something else. Ask for terminal type.
 ;[]D- per Jim- S:X1[":" XUTT=1,X1=$P(X1,":",1)_$P(X1,":",2)
 ;D ^XBKSET ;sets env var and default vt type  fje
 ;[]";",  a char in the hashed code. use $C(30) instead.
 ;              WAIT TILL hORACE CHANGES HIS OCX CODE.
 ;S X=$P(X1,";")
 S X=X1
 Q:X="^" -1
 S:XUF %1="Access: "_X G CHX:X'?1.20ANP
 ;[]D- eliminate these 2 calls.
 ;I- Put back for WEB
 I $G(WEB) D LC^XUS,^XUSHSH
 ;
 I '$D(^VA(200,"A",X)) S USER("ERR")="Invalid Access Code" G CHX
 S %1="",DUZ=$O(^VA(200,"A",X,0)),USER(0)=^VA(200,DUZ,0),USER(1)=$G(^VA(200,DUZ,.1)),XUF(.3)=DUZ
 ;S X=$P(X1,";",2) S:XUF %1="Verify: "_X
 S X=X2 S:XUF %1="Verify: "_X
 ;S X=$P(X1,";")
 ;[]D- Eliminate these 2 calls.
 ;I- Put back for WEB
 I $G(WEB) D LC^XUS,^XUSHSH
 ;
 I $P(USER(1),"^",2)'=X S USER("ERR")="Invalid Verify Code" G CHX
 I '$$ACTIVE^XUSER(DUZ) S USER("ERR")="No Access Allowed for this User." G CHX
 Q DUZ
CHX I DUZ S X=$P($G(^VA(200,DUZ,1.1)),U,2)+1,$P(^(1.1),"^",2)=X
 Q 0
 ;
SET1 ;Setup parameters
 D GETENV^%ZOSV S U="^",XUENV=Y,XUCI=$P(Y,U,1),XQVOL=$P(Y,U,2),XUEON=^%ZOSF("EON"),XUEOFF=^%ZOSF("EOFF")
 ;I- needs XOPT defined - used in NO()
 S XOPT=$S($D(^XTV(8989.3,1,"XUS")):^("XUS"),1:"") F I=2:1:15 I $P(XOPT,U,I)="" S $P(XOPT,U,I)=$P("^5^900^1^1^^^^1^300^^^^N^90",U,I)
 K ^XUTL("XQ",$J) S XUT=0,XUF=0,XUDEV=0,DUZ=0,DUZ(0)="@",%ZIS="L",IOP="HOME" ;D ^%ZIS Q:POP
 ;S XUDEV=IOS,XUIOP=ION
 Q
 ;
 ;----------------------------------------------------------------
 ;-D- VCVALID() ;Check if the Verify code needs changing.
 ;-D- Q:'$G(DUZ) 1
 ;-D- Q $G(^VA(200,DUZ,.1))+$P(^XTV(8989.3,1,"XUS"),"^",15)'>(+$H)
 ;
VCVALID() ;-^XUSRB-Return 1 if Verify code needs changing.
 ;to process error code 12, also prepare for other codes a little.
 Q:'$G(DUZ) 3
 Q:$P($G(^VA(200,DUZ,.1)),U,2)="" 2
 ;FHL 11/5/97
 S BGULIM=+$P($G(^XTV(8989.3,1,"XUS")),"^",15) S:'BGULIM BGULIM=365
 ;Q $G(^VA(200,DUZ,.1))+$P($G(^XTV(8989.3,1,"XUS")),"^",15)'>(+$H)
 Q $G(^VA(200,DUZ,.1))+BGULIM'>(+$H)
 ;--- - NO(), TXT(%), and ZZ are tags modified from ^XUS3.
NO() ;Fail - - modified from ^XUS3
 ;OUTPUTS : returns N1 ^ N2 ^ Error msg text
 ;N1=XUX2 = 0, non-fatal error.=1, fatal error.
 ;N2=XUX1 = Error Msg number.
 N XUEX,XUX1,XUX2,XUTXT
 S XUT=$G(XUT)+1
 ;D- I '$D(XGWIN) W !,"Device: ",$I,!,$$TXT(XUM),!
 ;R- I $D(XGWIN) D ^XGLMSG("W",$$TXT(XUM))
 S XUX1=XUM,XUTXT=$$TXT(XUM)
 ;R- Let GUI know whether this is a FATAL error.
 ;R- I ('XUEX)&(XUT<$P(XOPT,U,2)) Q 0 ;Continue
 S XUX2=1 I ('XUEX)&(XUT<$P(XOPT,U,2)) S XUX2=0 ;Continue - NON FATAL
 Q XUX2_U_XUX1_U_XUTXT
 ;D- Ignore the rest- Assume the number of times user
 ;messed up does not matter for now on GUI.
 ;D- I 'XUEX&(XUM-7) D
 ;D- . I $D(XGWIN) D ^XGLMSG("I",$$TXT(7))
 ;D- . I '$D(XGWIN) W !,$$TXT(7)
 ;D- I XUF S X1=IOS,X2=DT F I=1:1:XUF(.2) S X=XUF(I) D EN^XUSHSHP S XUF(I)=X
 ;D- I '$D(XGWIN)&'XUEX D ^XUSTZ
 ;D- H 4
 ;D- Q XUEX
TXT(%) ; mod from ^XUS3.%=NUM in, %=ERROR MSG out.
 S %=$T(ZZ+%) S:'$D(XUEX) XUEX=$P(%,";",3)
 S %=$P(%,";",4,9) I %["|" S %=$P(%,"|",1)_$G(XUM(0))_$P(%,"|",2)
 Q %
 ;--------------- ----------- -------------------
 ; tag ZZ is USED
ZZ ;;Halt;Error Messages
1 ;;1;Signons not currently allowed on this processor.
2 ;;1;Maximum number of users already signed on to this processor.
3 ;;1;This device has not been defined to the system -- contact system manager.
4 ;;0;Not a valid ACCESS CODE/VERIFY CODE pair.
5 ;;0;No Access Allowed for this User.
6 ;;0;Invalid device password.
7 ;;0;Device locked due to too many invalid sign-on attempts.
8 ;;1;This device is out of service.
9 ;;0;*** MULTIPLE SIGN-ONS NOT ALLOWED ***"
10 ;;1;You don't have access to this device.
11 ;;0;Your access code has been terminated.  Please see your site manager
12 ;;0;VERIFY CODE MUST be changed before continued use.
13 ;;1;This device may only be used outside of this time frame |
14 ;;0;'|' is not a valid UCI!
15 ;;0;'|' is not a valid program name!
 ;
ADDRSLT ; Add % as the new entry
 ;RESULT(0.01) = Number of recs FOLLOWING 0.01, (Itself is NOT included.)
 S BGUI=$G(RESULT(0.01)),BGUI=BGUI+1,RESULT(0.01)=BGUI
 S RESULT(BGUI)=%
 Q
SNDER ;Sends error to GUI
 ;For ERROR, RESULT(0.01)=-1 is required by the system convention.
 ;INPUTS : XUERR = the error msg.
 N BGUN ;K RESULT
 S BGUN=+$G(RESULT(0.01)),RESULT(0.01)=-1
 S RESULT(BGUN)="0"_U_XUERR
 Q
