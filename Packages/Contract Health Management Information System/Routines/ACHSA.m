ACHSA ; IHS/ITSC/PMF - ENTER DOCUMENTS (1/8)-(FY,TOS) ;     [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; ACHSAFLG flags whether the user is confirming/re-entering data
 ; for the current document.I.e., answered "NO" to 'everything correct'.
 ;
 ;CALLED FROM RTN ACHSAI
 ;
 ;I HATE doing this, but for right now, it's the only answer.
 ;Somehow the user finds a way to enter here so that the basic
 ;vars don't get set.  So we will check for the current fiscal
 ;year and if it is not set, we gonna set it along with the
 ;financial code.   2/28/01   pmf
 I '$D(ACHSCFY) D FY^ACHSUF,FC^ACHSUF,^ACHSVAR
 I $G(ACHSFYWK(DUZ(2),ACHSCFY))="" D FY^ACHSUF,FC^ACHSUF,^ACHSVAR
 ;
 S ACHSACFY=ACHSCFY,ACHSAFLG=""
 ;
 ;Once the registers are closed, do NOT create a new PO
 ;until tomorrow.  022801   pmf
 ;
 ;
 I $P($G(^ACHS(9,DUZ(2),"FY",ACHSCFY,"W",+ACHSFYWK(DUZ(2),ACHSCFY),0)),U,2)=DT W !!,*7,"  The Register Has Been CLOSED." S DUOUT=$$DIR^XBDIR("E","Press RETURN...") D END Q
 ;
 ;
A1A ;EP.
 ;
 I $D(ACHSOUT) K ACHSOUT D END Q
 ;
 ;ACHSAFLG IS SET IN ACHSA7
 ;ACHSA7+13    IF "Is this correct?" prompt is answered "NO"
 ;ACHSA7+18    IF funds not available 
 I '$G(ACHSAFLG) S ACHSACFY=ACHSCFY
 E  W !,"CONFIRM / RE-ENTER DATA..." I ACHSACFY'=ACHSCFY W !,"NOTE PRIOR FY!.",!
 ;
 ;IF NOT BLANKET AND NOT SPECIAL OBLIG. AND LINK TO REFERRAL SYSTEM
 ;IS ON
 I '$D(ACHSBLKF),'$D(ACHSSLOC),$$LINK^ACHSBMC S ACHSREF=$G(ACHSREF) D GETREF^ACHSBMC(.ACHSREF) I $D(DUOUT)!$D(DTOUT) D END Q
 ;
FY ; Select FY.
 S ACHSACFY=$$FYSEL^ACHS(1)
 I $D(DTOUT)!$D(DUOUT) D END Q
 I '$D(^ACHS(9,DUZ(2),"FY",ACHSACFY)) W !!,*7,"Fiscal year '",ACHSACFY,"' does not exist. -- TRY AGAIN" G FY
 I ACHSACFY<ACHSCFY W *7 I '$$DIR^XBDIR("Y","Are you sure you want to issue document for a PRIOR FISCAL YEAR","NO","","","",2) G FY
A1C ;
 S ACHSACWK=+ACHSFYWK(DUZ(2),ACHSACFY)
 ;
 D CKB^ACHSUUP                         ;CHECK DCR BALANCES
 ;
 ;IF OUT OF BALANCE QUIT
 I $D(ACHSCNC) S DUOUT=$$DIR^XBDIR("E","Press RETURN...","","","","",1) Q
 ;ASK FOR TYPE OF SERVICE
A3 ;EP.
 S Y=$G(ACHSTYP)
 I Y S Y=$S(Y=1:"Hospital Service",Y=2:"Dental Service",Y=3:"Outpatient Service",1:"")
 S Y=$$DIR^XBDIR("S^43:Hospital Service;57:Dental Service;64:Outpatient Service","Type Of Service",Y,"","","",1)
 G A1A:$D(DUOUT)
 I $D(DTOUT)!('Y) D END Q
 S ACHSTYP=$S(Y=43:1,Y=57:2,Y=64:3,1:"")
 ;
 D ^ACHSA1                          ;DO ENTER DOCUMENT RTN 2 OF 8
 ;
 Q
END ;EP - For fast-out (ACHSQUIT) of initial document.
 K %DT,I,M,P,R,S,Z
 D EN^XBVK("ACHS"),^ACHSVAR
 Q
 ;
