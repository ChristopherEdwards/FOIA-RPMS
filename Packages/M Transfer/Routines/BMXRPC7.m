BMXRPC7 ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
WINVAL(BMXRET,BMXWINID) ;EP
 ;Validates user based on Windows Identity
 ;
 ;Return R(0)=DUZ, R(1)=(0=OK, 1,2...=Can't sign-on for some reason)
 ; R(2)=verify needs changing, R(3)=Message, R(4)=0, R(5)=msg cnt, R(5+n)
 ; R(R(5)+6)=# div user must select from, R(R(5)+6+n)=div
 I $$NEWERR^%ZTER N $ETRAP S $ETRAP="" ; IHS/OIT/HMW SAC Exemption Applied For
 N X,BMXUSER,BMXUNOW,BMXUM,BMXUMSG,BMXVCOK
 S %="DUZ" K @%
 S BMXRET(0)=0,BMXRET(5)=0,BMXUM=0,BMXUMSG=0
 S DUZ=0,DUZ(0)="",BMXVCOK=0 D NOW ;IHS/OIT/HMW SAC Exemption Applied For
 S BMXUMSG=$$INHIBIT() I BMXUMSG S BMXUM=1 G VAX ;Logon inhibited
 ;
 S DUZ=$$WINUGET^BMXRPC3(BMXWINID) ;IHS/OIT/HMW SAC Exemption Applied For
 I DUZ>0 D USER(DUZ)
 S BMXUMSG=$$UVALID() G:BMXUMSG VAX
 I DUZ>0 S BMXUMSG=$$POST(1)
VAX S:BMXUMSG>0 DUZ=0 D:DUZ>0 POST2
 S BMXRET(0)=DUZ,BMXRET(1)=BMXUM,BMXRET(2)=BMXVCOK,BMXRET(3)=$S(BMXUMSG:$$TXT(BMXUMSG),1:""),BMXRET(4)=0
 Q
 ;
NOW S U="^",BMXUNOW=$$NOW^XLFDT(),DT=$P(BMXUNOW,".")
 Q
 ;
USER(IX) ;Build USER
 S BMXUSER(0)=$G(^VA(200,+IX,0)),BMXUSER(1)=$G(^(.1))
 Q
 ;
POST(CVC) ;Finish setup partition, I CVC don't log get
 N X,BMXUM
 K ^UTILITY($J),^TMP($J)
 I '$D(USER(0)),DUZ D USER(DUZ)
 S BMXUM=$$USER1A Q:BMXUM>0 BMXUM ;User can't sign on for some reason.
 S BMXRET(5)=0 ;The next line sends the post sign-on msg
 F BMXPT=1:1 Q:'$D(BMXUTEXT(BMXPT))  S BMXRET(5+BMXPT)=$E(BMXUTEXT(BMXPT),2,256),BMXRET(5)=BMXPT
 S BMXRET(5)=0 ;This line stops the display of the msg. Remove this line to allow.
 D:'$G(CVC) POST2
 Q 0
POST2 D:'$D(BMXUNOW) NOW
 D DUZ ;^XUS1A ;,SAVE^XUS1,LOG^XUS1,ABT^XQ12
 K BMXUTEXT,BMXOPT,BMXUER ;XUEON,XUEOFF,XUTT
 Q
 ;
DUZ ;Setup DUZ.  SAC exemption applied for.
 S:'$D(BMXUSER(0)) BMXUSER(0)=^VA(200,DUZ,0) D:$D(BMXOPT)[0 BMXOPT
 S DUZ(0)=$P(BMXUSER(0),U,4),DUZ(1)="",DUZ("AUTO")=$P(BMXOPT,"^",6) ;IHS/OIT/HMW SAC Exemption Applied For
 S DUZ(2)=$S($G(DUZ(2))>0:DUZ(2),1:+$P(BMXOPT,U,17)) ;IHS/OIT/HMW SAC Exemption Applied For
 S X=$P($G(^DIC(4,DUZ(2),99)),U,5),DUZ("AG")=$S(X]"":X,1:$P(^XTV(8989.3,1,0),U,8))
 S DUZ("BUF")=($P(BMXOPT,U,9)="Y"),DUZ("LANG")=$P(BMXOPT,U,7) ;IHS/OIT/HMW SAC Exemption Applied For
 Q
 ;
USER1A() ;
 N BMXPTB,BMXPTE,BMXPTT
 S BMXUTEXT=0,DUZ(2)=0
 F I=0:0 S I=$O(^XTV(8989.3,1,"POST",I)) Q:I'>0  D SET("!"_$G(^(I,0)))
 D SET("!"),BMXOPT
 S BMXPTH=$P($H,",",2)
 D SET("!Good "_$S(BMXPTH<43200:"morning ",BMXPTH<61200:"afternoon ",1:"evening ")_$S($P(BMXUSER(1),U,4)]"":$P(BMXUSER(1),U,4),1:$P(BMXUSER(0),U,1)))
 S BMXI1=$G(^VA(200,DUZ,1.1)),X=(+BMXI1_"0000")
 I X D SET("!     You last signed on "_$S(X\1=DT:"today",X\1+1=DT:"yesterday",1:$$DD(X))_" at "_$E(X,9,10)_":"_$E(X,11,12))
 I $P(BMXI1,"^",2) S I=$P(BMXI1,"^",2) D SET("!There "_$S(I>1:"were ",1:"was ")_I_" unsuccessful attempt"_$S(I>1:"s",1:"")_" since you last signed on.")
 I $P(BMXUSER(0),U,12),$$PROHIBIT(BMXPTH,$P(BMXUSER(0),U,12)) Q 17 ;Time frame
 I +$P(BMXOPT,U,15) S BMXPT=$P(BMXOPT,U,15)-($H-BMXUSER(1)) I BMXPT<6,BMXPT>0 D SET("!     Your Verify code will expire in "_BMXPT_" days")
 S:$P(BMXOPT,"^",5) XUTT=1 S:'$D(DTIME) DTIME=$P(BMXOPT,U,10) ; IHS/OIT/HMW SAC Exemption Applied For
 I ('X)!$P(BMXOPT,U,4) Q 0
 Q 9
 ;
BMXOPT ;Build the BMXOPT string
 N X,I
 S:'$D(BMXOPT) BMXOPT=$G(^XTV(8989.3,1,"XUS"))
 S X=$G(^VA(200,DUZ,200))
 F I=4:1:7,9,10 I $P(X,U,I)]"" S $P(BMXOPT,"^",I)=$P(X,U,I)
 Q
 ;
SET(V) ;Set into BMXUTEXT(BMXUTEXT)
 S BMXUTEXT=$G(BMXUTEXT)+1,BMXUTEXT(BMXUTEXT)=V
 Q
 ;
PROHIBIT(BMXPTT,BMXPTR) ;See if a prohibited time, (Current time, restrict range)
 N XMSG,BMXPTB,BMXPTE
 S BMXPTT=BMXPTT\60#60+(BMXPTT\3600*100),BMXPTB=$P(BMXPTR,"-",1),BMXPTE=$P(BMXPTR,"-",2)
 S XMSG=$P($$FMTE^XLFDT(DT_"."_BMXPTB,"2P")," ",2,3)_" thru "_$P($$FMTE^XLFDT(DT_"."_BMXPTE,"2P")," ",2,3)
 I $S(BMXPTE'<BMXPTB:BMXPTT'>BMXPTE&(BMXPTT'<BMXPTB),1:BMXPTT>BMXPTB!(BMXPTT<BMXPTE)) S BMXUM(0)=XMSG Q 1 ;No
 D SET("!")
 D SET("! Your access is restricted during this time frame "_XMSG)
 Q 0
 ;
INHIBIT() ;Is Logon to this system Inhibited?
 N BMXENV,BMXCI,BMXQVOL,BMXVOL
 D GETENV^%ZOSV S U="^",BMXENV=Y,BMXCI=$P(Y,U,1),BMXQVOL=$P(Y,U,2)
 S X=$O(^XTV(8989.3,1,4,"B",BMXQVOL,0)),BMXVOL=$S(X>0:^XTV(8989.3,1,4,X,0),1:BMXQVOL_"^y^1") S:$P(BMXVOL,U,6)="y" XRTL=BMXCI_","_BMXQVOL
 ;I '$D(BMXQVOL) Q 0
 ;I '$D(BMXVOL) Q 0
 I $G(^%ZIS(14.5,"LOGON",BMXQVOL)) Q 1
 I $D(^%ZOSF("ACTJ")) X ^("ACTJ") I $P(BMXVOL,U,3),($P(BMXVOL,U,3)'>Y) Q 2
 Q 0
 ;
 ;
UVALID() ;EF. Is it valid for this user to sign on?
 I '+$G(BMXWIN) Q 18
 I DUZ'>0 Q 4
 I $P(BMXUSER(0),U,11),$P(BMXUSER(0),U,11)'>DT Q 11 ;Access Terminated
 I $P(BMXUSER(0),U,7) Q 5 ;Disuser flag set
 Q 0
 ;
DD(Y) Q $S($E(Y,4,5):$P("Jan^Feb^Mar^Apr^May^Jun^Jul^Aug^Sep^Oct^Nov^Dec","^",+$E(Y,4,5))_" ",1:"")_$S($E(Y,6,7):+$E(Y,6,7)_",",1:"")_($E(Y,1,3)+1700)
 Q
 ;
TXT(BMXPT) ;
 S BMXPT=$T(ZZ+BMXPT)
 S BMXPT=$P(BMXPT,";",4,9) I BMXPT["|" S BMXPT=$P(BMXPT,"|",1)_$G(BMXUM(0))_$P(BMXPT,"|",2)
 Q BMXPT
ZZ ;;Halt;Error Messages
1 ;;1;Signons not currently allowed on this processor.
2 ;;1;Maximum number of users already signed on to this processor.
3 ;;1;This device has not been defined to the system -- contact system manager.
4 ;;0;Not a valid Windows Identity map value.
5 ;;0;No Access Allowed for this User.
6 ;;0;Invalid device password.
7 ;;0;Device locked due to too many invalid sign-on attempts.
8 ;;1;This device is out of service.
9 ;;0;*** MULTIPLE SIGN-ONS NOT ALLOWED ***
10 ;;1;You don't have access to this device!
11 ;;0;Your access code has been terminated. Please see your site manager!
12 ;;0;VERIFY CODE MUST be changed before continued use.
13 ;;1;This device may only be used outside of this time frame |
14 ;;0;'|' is not a valid UCI!
15 ;;0;'|' is not a valid program name!
16 ;;0;No PRIMARY MENU assigned to user or User is missing KEY to menu!
17 ;;0;Your access to the system is prohibited from |.
18 ;;0;Windows Integrated Security Not Allowed on this port.
