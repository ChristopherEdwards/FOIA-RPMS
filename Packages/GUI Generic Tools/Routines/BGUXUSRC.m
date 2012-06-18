BGUXUSRC ; IHS/OIT/MJL - Request Broker ;
 ;;1.5;BGU;;MAY 26, 2005
 Q  ;No entry from top
 ;
 ;DATA BROKER calls, First parameter is always call-by-reference
 ;
 ;s1=-1^The VERIFY CODE has ....they sign-on.
 ;   |-2|CHOW,SUN&613^FM#Pp^0^1;SELLS HOSPITAL/CLINIC&4585^|
 ;s1=2|-1^The VERIFY CODE has ....they sign-on.
 ;   |CHOW,SUN&613^FM#Pp^0^1;SELLS HOSPITAL/CLINIC&4585^|
 ;--------------- QUERY TAG -----------------------------------
CHGACODE(RESULT,XUH,XUDUZ) ; Excerpts from tag AASK1^XUS2
 ;BGU ACCESSCODE CHANGE- Query to validate the new ACCESS code & store it.
 ;WARNING : This outputs the LOGON info for the user identified by XUDUZ.
 ;!!!!!So BGUSRV OCX needs to know when it wants to use this info to
 ;update the current user.
 ;INPUTS :XUDUZ = the DUZ sent up by the GUI.  If null, use DUZ in partition.
 ;           DA =DUZ
 ;          XUH =the hashed ACCESS code just input by the user.
 N DA,XUERR K RESULT S XUERR=""
 S DA=$G(DUZ)
 I $G(XUDUZ)'="",'$$CKAUTH S XUERR="You are only authorized to change your own ACCESS code!" D SNDER Q
 I DA="" S XUERR="No DUZ, must logon first !!" D SNDER Q
 ;D- S XUU=X,X=$$EN^XUSHSH(X),XUH=X
 S XMB(1)=$O(^VA(200,"A",XUH,0))
 I XMB(1),XMB(1)'=DA S XMB="XUS ACCESS CODE VIOLATION",XMB(1)=$P(^VA(200,XMB(1),0),"^"),XMDUN="Security" D ^XMB
 ;
 ;DB-temp DELETED sothat when testing, I can just use 2 sets of codes.
 ;I $D(^VA(200,"AOLD",XUH))!$D(^VA(200,"A",XUH)) S XUERR="This has been used previously as an ACCESS CODE." D SNDER Q
 ;
 ;I3- File the new ACCESS- assuming no writes in those executes.
 ;And send the security info : Access, Verify, and FAC.
 D AST(XUH) ;Everywhere DA was DUZ
 I $G(DA)>0 S %=$P(^VA(200,DA,0),U)_"&"_DA_U_$P(^VA(200,DA,0),U,4)_U_0_U_$$GETFC^BGUGFAC(DA)_U_"" D ADDRSLT
 E  S XUERR=XUSER("ERR") D SNDER
 Q
CKAUTH() ;
 ;Check if this user may modify ACCESS code for other users.
 ; ( DUZ(0) must include   "@" or "#" )
 S DA=XUDUZ
 I DA'=DUZ,DUZ(0)'["@",DUZ(0)'["#" Q 0
 Q 1
AST(XUH) ;AST^XUS2- Change ACCESS CODE and index.
 ;sets:S $P(^VA(200,DA,0),"^",3)=XUH K ^VA(200,"A",X,DA)
 ;S ^VA(200,"AOLD",X,DA)=+$H,^VA(200,"A",X,DA)=+$H Q
 ;D- W "OK, Access code has been changed!"
 N XUI,XUU,XUWRN
 S XUU=$P(^VA(200,DA,0),"^",3),$P(^VA(200,DA,0),"^",3)=XUH
 I XUU]"" F XUI=0:0 S X=XUU S XUI=$O(^DD(200,2,1,XUI)) Q:XUI'>0  X ^(XUI,2)
 I XUH]"" F XUI=0:0 S X=XUH S XUI=$O(^DD(200,2,1,XUI)) Q:XUI'>0  X ^(XUI,1)
 D VST("",1)
 I $D(^XMB(3.7,DA,0))[0 S Y=DA D NEW^XM ;Make sure USER has a Mailbox
 ;Somehow, needs to send this multi-line msg down:
 S XUWRN="The VERIFY CODE has been deleted as a security measure. "
 S XUWRN=XUWRN_"The user will have to enter a new one the next time they sign-on."
 D SNDWRN
 Q
 ;
 ;--------------- QUERY TAG -----------------------------------
CHGVCODE(RESULT,XUH,XUDUZ) ; Excerpts from tag VASK1^XUS2
 ;WARNING : This outputs the LOGON info for the user identified by XUDUZ.
 ;!!!!! So BGUSRV OCX needs to know when it wants to use this info to
 ;update the current user.
 ;BGU VERIFYCODE CHANGE- Query to validate the new VERIFY code & store it.
 ;In VALIDAV^BGUXUSRB, at end I added a call to $$VCVALID(), and may set
 ;error code=12. When this code 12 is sent to SendSecurityRequest() in
 ;the OCX, it calls sub PopChangeVerifyDlgBox(), which asks user to
 ;input the new VERIFY code, and calls query 'ChangeVerifyCode'.
 ;This Query may also be invoked by the user on demand, from the Application
 ;side(VB).
 ;WARNING : this is for the OWNER to change. If for the site mgr to change
 ;!!!!!!    we need to pass in the DA or DUZ.
 ;INPUTS : XUDUZ = the DUZ sent up by the GUI. If null, use DUZ in partition.
 ;DA =DUZ
 ;XUH =the hashed VERIFY code just input by the user.
 ;R- S XUU=X,X=$$EN^XUSHSH(X),XUH=X
 N XUERR K RESULT S XUERR=""
 S DA=$G(DUZ)
 I $G(XUDUZ)'="",'$$CKAUTH S XUERR="You are only authorized to change your own VERIFY code!" D SNDER Q
 I DA="" S XUERR="No DUZ, must logon first !!" D SNDER Q
 I $D(^VA(200,DA,.1)),XUH=$P(^(.1),U,2) S XUERR="This code is the same as the current one." D SNDER Q
 ;
 ;DB-temp DELETED sothat when testing, I can just use 2 sets of codes.
 ;$D(^VA(200,DA,"VOLD",XUH)) S XUERR="This has been used previously as the VERIFY CODE." D SNDER Q
 I XUH=$P(^VA(200,DA,0),U,3) S XUERR="VERIFY CODE must be different than the ACCESS CODE." D SNDER Q
 ;I3- File the new VERIFY- assuming no writes in those executes.
 ;And send the security info : Access, Verify, and FAC.
 D VST(XUH,1) ;I $G(DUZ)>0 ...
 I $G(DA)>0 S %=$P(^VA(200,DUZ,0),U)_"&"_DUZ_U_$P(^VA(200,DUZ,0),U,4)_U_0_U_$$GETFC^BGUGFAC(DUZ)_U_"" D ADDRSLT
 E  S XUERR=XUSER("ERR") D SNDER
 Q
 ;
VST(XUH,%) ;I- File Verify code change, mod from VST^XUS2
 ;XUH = new VERIFY code hashed. XUU = Old VERIFY code hashed.
 ; DA = 613, IEN
 ;t#'ou,=B7FC%@0ulm{:t=>123SUN
 S XUU=$P($G(^VA(200,DA,.1)),U,2) S $P(^VA(200,DA,.1),"^",1,2)=$H_"^"_XUH
 I XUU]"" F XUI=0:0 S X=XUU,XUI=$O(^DD(200,11,1,XUI)) Q:XUI'>0  X ^(XUI,2)
 I XUH]"" F XUI=0:0 S X=XUH,XUI=$O(^DD(200,11,1,XUI)) Q:XUI'>0  X ^(XUI,1)
 S:DA=DUZ DUZ("NEWCODE")=XUH
 Q
 ;
 ;------------------
ADDRSLT ; Add % as the new entry
 ;RESULT(0.01) = Number of recs FOLLOWING 0.01, (Itself is NOT included.)
 S BGUI=+$G(RESULT(0.01)),BGUI=BGUI+1,RESULT(0.01)=BGUI
 S RESULT(BGUI)=%
 Q
SNDER ;Sends error to GUI
 ;For ERROR, RESULT(0.01)=-1 is required by the system convention.
 ;INPUTS : XUERR = the error msg.
 N BGUI
 S BGUI=+$G(RESULT(0.01)),RESULT(0.01)=-1
 S RESULT(BGUI)="0"_U_XUERR
 Q
SNDWRN ;
 ;For WARNING, RESULT(0.01)=-2 is required by the system convention.
 ;So the format for that is :
 ;RESULT(0.01)= number of lines that follows. (warning text & result)
 ;for each line of warning msg text, = "-1^text line".
 ;for result, then just the result
 ; (so a result may not contain a 1st piece=-1, EX: "-1^...")
 ;INPUTS : XUWRN = the WARNING msg.
 ;LOCALS : BGUN1 = -1 warns GUI code that it is a warning.
 N BGUI,BGUN1
 S BGUI=+$G(RESULT(0.01)),BGUI=BGUI+1,RESULT(0.01)=BGUI
 ;S RESULT(0.01)=-2
 S BGUN1=-1
 S RESULT(BGUI)=BGUN1_U_XUWRN
 Q
 ;=================================================================
 ;=================================================================
