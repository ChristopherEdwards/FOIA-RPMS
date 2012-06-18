INHULOG ; JC Hrubovcak ; 23 Aug 95 18:35 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ; GIS logon utilities. These utilities are used by the LOGON server
 ;functionality. They are called from the INHVCR* routines and are
 ;specific to a CHCS environment. If the IHS needs to use the 
 ;logon servers, some of the logic must be revised.
 Q
GETDUZ(AC,VC,ZN) ; function, returns User IEN and ^DIC(3,IEN,0), or false on failure
 ; input: AC=Access, VC=Verify, hashed codes (required), ZN=zero node, returned by reference
 S ZN="",AC=$G(AC),VC=$G(VC) Q:'$L(AC)!'$L(VC) "^Required data missing"
 Q:'$D(^DIC(3,"A",AC)) "^Access code not found."
 N A,D,V S D=+$O(^DIC(3,"A",AC,0)) Q:D'>0 "^User not found."
 D SETDT^UTDT S A=$G(^DIC(3,D,0)),V=$G(^(.1)) Q:$P(V,U,2)'=VC "^Verify code mismatch."
 I $P(A,U,11),$P(A,U,11)<DT Q "^Beyond termination date."
 ;
 ; check prohibited times
 S V=$P(A,U,12) I $L(V) S V=$$PROHBTM(V) Q:V "^Prohibited time"
 ;
 S ZN=A Q D   ; success, put zero node into ZN
 ;
SETENV(NEWDUZ,NEWDIV) ; function, setup environment variables, returns false on success
 ; NEWDUZ= User IEN (required), NEWDIV = Division IEN (optional) - Not used.
 S U="^",DUZ=+$G(DUZ)   ; initialization
 Q:$G(NEWDUZ)'>0!(NEWDUZ'=+NEWDUZ) "2^Invalid User IEN"
 Q:DUZ=NEWDUZ 0   ; no action needed
 ; validity checks, user is already "logged on"
 ; The ^XMB7(duz,100,$I) nodes should be defined
 D SETDT^UTDT N %,X S X=$G(^DIC(3,NEWDUZ,0)) Q:'$L(X) "2^User not found"
 S %=$P(X,U,3) Q:'$L(%) "2^No Access Code."
 S %=$P(X,U,4) I %,%<DT Q:"2^Past termination date."
 ; ensure call to XUDIV avoids terminal I/O
 S %=$$DIVCHK(NEWDUZ) Q:'% "2^"_%
 ; now we clean up all the old stuff
 K DUZ,XMDUZ S DUZ=NEWDUZ,DUZ(0)=$P(X,U,4)
 S DTIME=$$DTIME(DUZ) Q:'$L(DTIME) "2^Incomplete User record"
 ;;folloing two lines must definitely be changed for IHS
 ;D DUZAG^XUS1   ; set up agency codes, no user prompts
 ;D ^XUDIV   ; set up division, BEWARE: possible user prompts
 ; set up device variables,if needed
 I '$L($G(IO(0)))!'$L($G(IO)) S IOP="NL:" D ^%ZIS
 K ^DIJUSV(DUZ)
 ; success
 Q 0
 ;
DTIME(INUSR,INDEF) ; function, returns timed-read (in seconds) for INUSR.
 ; Default=300.  For remote systems, result represents the # of seconds
 ; to wait for remote system to communicate before connection is closed.
 ; Input: INUSR  - (req) USER IEN
 ;        INDEF  - (opt) customized default (e.g. for remote systems)
 Q:'$D(^DIC(3,INUSR,0)) ""
 N A S A=+$P($G(^(200)),U,10) Q:A>0 A
 ; use KERNEL SITE PARAMETERS
 S A=+$P($G(^XMB(1,1,"XUS")),U,10)
 Q $S(A>0:A,$G(INDEF):INDEF,1:300)
 ;
DIVCHK(USR,REQDIV) ; $$function - Division validation for USR.
 ; Verify:
 ; - default division exists for USR
 ; - default division is one of USR's allowable divisions (if allowables
 ;   are specified)
 ; - if REQDIV is passed in, verify that requested division:
 ;   - is a valid MEDICAL CENTER DIVISION IEN
 ;   - is one of USR's allowables (if allowables are specified)
 ;
 ; Input:
 ; USR    = (req) USER IEN
 ; REQDIV = (opt) >0 - Requested division
 ;                 0 - ignore all "requested division" validation (not passed in)
 ;
 ; Output:  1 = successful division validation
 ;          Error msg = failed division validation
 ;
 N ALLOWDIV,DEFDIV,DEFOK,REQOK,X
 I $D(REQDIV),$S($G(REQDIV)<1:1,1:'$D(^DG(40.8,REQDIV,0))) Q "Invalid Medical Center Division requested"
 S DEFDIV=$P($G(^DIC(3,USR,0)),U,16),REQDIV=+$G(REQDIV)
 Q:DEFDIV'>0 "Default division is missing for user '"_USR_"'"
 ; ck if allowable divisions exist for USR
 I $O(^DIC(3,USR,2,0)) D  Q:'DEFOK "Default division does not match allowable divisions for user '"_USR_"'"  Q:'REQOK "Requested division '"_REQDIV_"' does not match allowable divisions for user '"_USR_"'"
 . S DEFOK=0,REQOK='REQDIV ; do not ck requested div if not passed in
 . M ALLOWDIV=^DIC(3,USR,2)
 . S X=0 F  S X=$O(ALLOWDIV(X)) Q:'X  S:'DEFOK DEFOK=(DEFDIV=ALLOWDIV(X,0)) S:(REQDIV&'REQOK) REQOK=(REQDIV=ALLOWDIV(X,0)) Q:(DEFOK&REQOK)
 Q 1
 ;
PROHBTM(T) ; boolean function, check for prohibited signon time
 ;return true if prohibited, null if invalid time passed in
 ;T = (required) military time in format: HHMM-HHMM
 Q:T'?4N1"-"4N ""
 ;B=beginning time, E=ending time, H=current time
 N B,E,H S B=$P(T,"-"),E=$P(T,"-",2),H=$P($H,",",2),H=H\60#60+(H\3600*100)
 Q:E=B H=E
 Q:E<B $S(H<B&(H>E):0,1:1)
 Q $S(H>E&(H<B):0,1:1)
 ;
VALIDIP(INBPN,INADDR) ; $$function - Validate remote system IP address.
 ; Verify:
 ; - minimum length
 ; - format = 1-3N.1-3N.1-3N.1-3N
 ; - exists on authorized address list (BACKGROUND PROCESS CONTROL file, 
 ;   Client IP Address multiple)
 ;
 ; Input:
 ; INBPN    - BACKGROUND PROCESS CONTROL IEN
 ; INADDR   - IP Address to be validated
 ;
 ; Output:
 ; 0 = successful validation
 ; "1^Error msg" = failure
 ;
 N X
 Q:$L(INADDR)<3 "1^Fails minimum length requirements"
 Q:INADDR'?1.3N1"."1.3N1"."1.3N1"."1.3N "1^Invalid IP address format"
 ; verify IP adrs is in authorized address list
 S X=$O(^INTHPC(INBPN,6,"B",INADDR,0))
 Q:'X "1^Not found in authorized address list"
 Q:'($G(^INTHPC(INBPN,6,X,0))=INADDR) "1^Inconsistent authorized address list"
 Q 0
 ;
LGNLOG(USR) ; Logon log subroutine, USR=userIEN, T=date&time, D=device ID
 Q:$G(USR)'>0  N D,T  S D=$$DEVID^%ZTOS S:'$L(D) D=$P
 ; one second HANG ensures uniqueness
 F  D SETDT^UTDT S T=$P($H,",",2),T=DT_(T\60#60/100+(T\3600)+(T#60/10000)/100) L +^XUSEC(0,T):0 Q:$T&'$D(^XUSEC(0,T,0))  H 1
 S ^XUSEC(0,T,0)=USR_"^"_D_"^"_$J_"^^"_$G(^%ZOSF("VOL"))_"^"_$S($L($G(ION)):ION,1:$I) L -^XUSEC(0,T)
 K ^ZUTL("XQ",$J) S ^($J,0)=T  ; we use this at Logoff
 S ^XMB7(USR,.1)=T,^(100,D,0)=D_" "_$G(^%ZOSF("VOL"))_" ^"_$J   ; space after ^%ZOSF("VOL") is intended
 Q
 ;
CLRSTOR ; Clear out scratch storage, similar to K2^XUS
 K ^UTILITY("NSR",+$O(^UTILITY($J,"NST",""))),^UTILITY($J),^ZUTL("XQ",$J)
 S %=$C(1) F  K ^UTILITY(%,$J) S %=$O(^UTILITY(%)) Q:'$L(%)  K ^(%,$J)   ; clear all namespaces
 I $G(ORDFN) K ^ORB("AMA",+ORDFN),^ORB("ANEW",+ORDFN)
 K:$L($G(DUZ)) ^DIJUSV(DUZ) K ^DIJUSV($I),^($P)   ; "spacebar return"
 Q
 ;
TICKET() ; function, returns access ticket, 6 to 10 alphanumerics
 N C,L,K,V S V=$H+$P($H,",",2),V=$$RV(.V),V=$$RV(.V),L=$R(V)#5+6,V=$$RV(.V),K=$C($R(V)#26+65)
 F  Q:$L(K)=L  S V=$$RV(.V),V=$$RV(.V),C=$C(V+$E(V,$L(V)-2,255)#127) S:C?1U!(C?1N) K=K_C
 Q K
RV(V) ; random value increment
 Q V+$R(V)+$H+$P($H,",",2)+$E(V,$L(V)-4,99)
