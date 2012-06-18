ACHSAC ; IHS/ITSC/PMF - CANCEL CHS DOCUMENTS ;    [ 02/18/2004  8:49 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**4,7,8**;JUN 11, 2001
 ;ACHS*3.1*4  correct spelling of Cancellation
 ;ACHS*3.1*7 Cancel a document and remove it from E-Sig queue
 ;ACHS*3.1*8 Cancel a document and remove it from E-Sig queue
 ;
 ;
A1 ;
 ;I HATE doing this, but for right now, it's the only answer.
 ;Somehow the user finds a way to enter here so that the basic
 ;vars don't get set.  So we will check for the current fiscal
 ;year and if it is not set, we gonna set it along with the
 ;financial code.   4/13/01   pmf
 I '$D(ACHSCFY) D FY^ACHSUF,FC^ACHSUF
 ;
 D ^ACHSUSC                             ;DISPLAY DOC. CANCEL/SUPP. INFO.
 I $D(DTOUT)!$D(DUOUT)!'$D(ACHSDIEN) D QUIT Q
 W !
 I '$$LOCK^ACHS("^ACHSF(DUZ(2),""D"",ACHSDIEN)","+") D ENDC Q
 ;
 S ACHSX=+$$DOC^ACHS(0,14)               ;FISCAL YEAR DIGIT
 D FYCVT^ACHSFU                          ;COMPUTE FISCAL YEAR
 S ACHSACFY=ACHSY
 S ACHSACWK=+ACHSFYWK(DUZ(2),ACHSACFY)
 ;
 D CKB^ACHSUUP                           ;CHECK BALANCES
 ;
 I $D(ACHSCNC) D ENDC Q                  ;BALANCES OUT OF SYNCH QUIT
B1 ;
 ;
 G C1:$$DIR^XBDIR("Y","Do You Wish To Cancel The Entire Document","NO","","  You May Cancel All ($"_ACHSBAL_") or Part Of The Obligation.","",2)
 I $D(DTOUT) D ENDC Q
 G A1:$D(DUOUT)
 ;
B2 ;
 ;ACHS*3.1*4   4/19/02   pmf  correct spelling
 ;S Y=$$DIR^XBDIR("FO","Amount Of Cancelation","","","Enter The Amount To Be Canceled (e.g.  150.00).","",2)  ;  ACHS*3.1*4
 S Y=$$DIR^XBDIR("FO","Amount Of Cancellation","","","Enter The Amount To Be Canceled (e.g.  150.00).","",2)  ;  ACHS*3.1*4
 ;
 ;
 I $D(DTOUT) D ENDC Q
 G B1:$D(DUOUT)
 ;
 I +Y=0 W *7,"   NO Amount Canceled",!! G A1
 S:Y?1"$".E Y=$E(Y,2,99)
 F I=1:1 S F=$F(Y,",") Q:'F  S Y=$E(Y,1,F-2)_$E(Y,F,99)
 I '(Y?1N.N1"."2N!(Y?1N.N))!($L(Y)>10) W *7,"  ??" G A1
 S Y=$J(Y,1,2)
 I Y'<ACHSBAL W *7,"  ??",!,"  Must Be Less Than $",ACHSBAL,", Which Is the Current Obligation Balance." G B2
 S ACHSESDO=Y,ACHSFULP="P"
 W "   ($",$FN(Y,",",2),")"
 G OK
 ;
C1 ;
 S ACHSESDO=$J(ACHSBAL,1,2),ACHSFULP="F"
 S ACHSCANR=$$DIR^XBDIR("9002080.01,63","","UNKNOWN")
 I $D(DIRUT) D ENDC Q
 G B1:$D(DUOUT)
OK ;
 S Y=$$DIR^XBDIR("Y","Is everything correct","NO","","","",2)
 I $D(DIRUT) D ENDC Q
 G B1:$D(DUOUT)!('Y)
D1 ;
 S T=DT_"^C^"_$G(DFN)_U_ACHSESDO_U_ACHSFULP
 S ACHSESDO=ACHSESDO*-1
 D CKB^ACHSUUP                          ;CHECK BALANCES
 I $D(ACHSCNC) D ENDC Q
 ;
 D SB1                                  ;SET THE NEW TRANSACTION RECORD
 ;
 W !!," *** Document Updated  ***"
 D ACT^ACHSACT(ACHSDIEN,$$NOW^XLFDT,"<CANCELATION>")
 I $$DOC^ACHS(2,7) S ACHSREF=$$DOC^ACHS(2,7) D AUTH^ACHSBMC K ACHSREF
ENDC ;
 I $$LOCK^ACHS("^ACHSF(DUZ(2),""D"",ACHSDIEN)","-")
 I $$DIR^XBDIR("E","Press RETURN...")
QUIT ;
 K X,X1,X2
 D EN^XBVK("ACHS"),^ACHSVAR
 Q
 ;
 ;AGAIN SET THE TRANSACTION RECORD BYPASSING FILEMAN COMPLETELY???????
SB1 ;
 S X=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,0))
 S ACHSLCA=+$P(X,U,16)
 S:'$D(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0)) ^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0)=$$ZEROTH^ACHS(9002080,100,100)
 S Y=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0))
S11 ;
 S M=$P(Y,U,3)+1,$P(Y,U,3)=M,$P(Y,U,4)=M
 G S11:$D(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",M))
 S ^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0)=Y      ;
 S ^ACHSF(DUZ(2),"D",ACHSDIEN,"T",M,0)=T    ;
 S ^ACHSF(DUZ(2),"TB",DT,"C",ACHSDIEN,M)=""
 S ACHSTIEN=M
 S ACHSDCR=-1
 ;
 S $P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",M,0),U,7)=ACHSLCA+1  ;'CANCEL NUMBER'
 S $P(^ACHSF(DUZ(2),"D",ACHSDIEN,0),U,16)=ACHSLCA+1 ;'LAST CANCEL NUMBER'
 S ACHSDCR=$P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,0)),U,19) ;'DCR ACCOUNT NUMBER'
 S $P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",M,0),U,11)=DUZ
 I ACHSDCR<1 W !,"ERROR: No DCR account number in DOCUMENT record... ",!! W:$$DIR^XBDIR("E","Press RETURN...") "" Q
 S ACHS("CHK")=0
 D SBAENT^ACHSUUP                    ;Update Current Advice of
                                     ;Allowance and Total Obligated FYTD
 ;
 D SBQ^ACHSUUP:$$PARM^ACHS(2,6)="Y"  ;PLACE DOCUMENT IN PRINT QUE
                                     ;IF 'PRINT CANCEL DOCUMENTS'
 ;ITSC/SET/JVK ACHS*3.1*7 11.21.03 NXT TWO LINES
 S ACHSTYP=$P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,0)),U,4)
 ;I $D(^ACHSF("EQ",DUZ(2),ACHSTYP,ACHSDIEN,1)) K ^ACHSF("EQ",DUZ(2),ACHSTYP,ACHSDIEN,1)
 ;ITSC/SET/JVK ACHS*3.1*8 1/20/04-LN BELOW
 I $D(^ACHSF("EQ",DUZ(2),ACHSTYP,ACHSDIEN)) K ^ACHSF("EQ",DUZ(2),ACHSTYP,ACHSDIEN)
 ;
 ;SET 'COMMENTS (OPTIONAL)'
 S $P(^ACHSF(DUZ(2),"D",ACHSDIEN,0),U,12)=$S(ACHSFULP="P":2,1:4)
 ;SET 'CANCELLATION REASON'
 I $L($G(ACHSCANR)),$$DIE^ACHS("63////"_ACHSCANR)
 Q
 ;
