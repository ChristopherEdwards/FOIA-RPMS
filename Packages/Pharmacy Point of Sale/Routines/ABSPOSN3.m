ABSPOSN3 ; IHS/FCS/DRS - NCPDP Fms F ILC A/R ;  [ 09/12/2002  10:16 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,10**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;IHS/SD/lwj 03/10/04 patch 10
 ; Routine adjusted to call ABSPFUNC to retrieve
 ; the Prescription Refill NDC value.  At some
 ; point the call needs to be modified to call APSPFUNC.
 ; See ABSPFUNC for details on why call was done.
 ;----------------------------------------------------------------------
 ;
 ; YOU REALLY REALLY REALLY SHOULD GET THIS DATA BY
 ; CALLING ABSPOSQ*
 ; an ABSP(...) array, just like what is done F the point of sale
 ; claims.
PATINFO(PATIEN,PATINFO) ;EP
 ;Manage local variables
 N XDATA
 ;
 Q:$G(PATIEN)=""
 Q:'$D(^DPT(PATIEN,0))
 ;
 S XDATA=$G(^DPT(PATIEN,0))
 S PATINFO("Name")=$P(XDATA,U,1)
 S PATINFO("Sex")=$P(XDATA,U,2)
 S PATINFO("DOB")=$P(XDATA,U,3)
 S PATINFO("SSN")=$P(XDATA,U,9)
 Q
 ;---------------------------------------------------------------------
INSADDR ; Given INSDFN
 N X,Y S X=$G(^AUTNINS(INSDFN,0))
 S INSINFO("INS. Co. Name")=$P(X,U)
 S INSINFO("INS. Co. Addr 1")=$P(X,U,2)
 S INSINFO("INS. Co. Addr 2")=""
 S Y=$P(X,U,4) I Y S Y=$P(^DIC(5,Y,0),U,2)
 S INSINFO("INS. Co. City/State/Zip")=$P(X,U,3)_" "_Y_" "_$P(X,U,5)
 Q
INSINFO(INSDATA,INSINFO,TYPE) ;EP
 I TYPE="INSCOV1" D  Q
 . S (INSINFO("IEN"),INSDFN)=$P(INSDATA(1),U,2)
 . D INSADDR
 . S INSINFO("Cardholder Name")=$P(INSDATA(0),U,3)
 . D INSREL1($P(INSDATA(0),U,13))
 . S INSINFO("Other 3rd Party Coverage")=$$OTHER3RD
 . S INSINFO("Cardholder Number")=$P(INSDATA(0),U,2)
 . ; INSCOV1 has a group number but no group name?
 . ; F now, U the same value F both name and number
 . S INSINFO("Group Name")=$P(INSDATA(0),U,9)
 . S INSINFO("Group Number")=$P(INSDATA(0),U,9)
 N X,Y
 N INSDFN S INSDFN=$P(INSDATA,U,$S(TYPE="CARE":4,1:5))
 S INSINFO("IEN")=$S(INSDFN:INSDFN,1:-1) ; cannot let INSINFO("IEN")=""
 D INSADDR
 S INSINFO("Cardholder Name")=$P(INSDATA,U,$S(TYPE="PRVT":7,TYPE="CAID":6,1:0))
 D INSREL($S(TYPE="PRVT":$P(INSDATA,U,6),1:""))
 S INSINFO("Other 3rd Party Coverage")=$$OTHER3RD
 S INSINFO("Cardholder Number")=$P(INSDATA,U,$S(TYPE="PRVT":2,1:1))
 S INSINFO("Group Name")=$S(TYPE="PRVT":$P(INSDATA,U,10),1:"")
 S INSINFO("Group Number")=$S(TYPE="PRVT":$P(INSDATA,U,11),1:"")
 Q
INSREL(X)          ;
 I 'X S X=$O(^AUTTRLSH("B","SELF",0))
 S INSINFO("Relationship")=X
 Q
INSREL1(X)         ; the INSCOV1 version
 S INSINFO("Relationship")=X ; it's already 1-2-3-4'd
 Q
 ;--------------------------------------------------------------------
OTHER3RD()         ; return true or false ; a best-efFt quickie,
 ; not entirely sure I this works 100% of the time
 ; Also, D they mean "other 3rd party coverage available now"?
 ; And really, what D we D F rollovers?  This is a mess.
 ;
 N RETVAL S RETVAL=0 ; assume not
 ; I there's no second INSCOV, say NO
 N NEXT S NEXT=IADTINS+1
 I $D(^ABSBITMS(9002302,PCNDFN,"INSCOV1")) D  ; N INSCOV1 version
 . I '$D(^ABSBITMS(9002302,PCNDFN,"INSCOV1",NEXT)) Q
 . I ^ABSBITMS(9002302,PCNDFN,"INSCOV1",NEXT,1)["SELF" Q
 . S RETVAL=1
 E  D
 . I '$D(^ABSBITMS(9002302,PCNDFN,"INSCOV",NEXT)) Q
 . ; I the second INSCOV is SELF PAY or SELF, say NO
 . I $O(^ABSBITMS(9002302,PCNDFN,"INSCOV",NEXT,""))["SELF" Q
 . ; Otherwise, there's a second INSCOV and it must be CARE,CAID,PRVT,RR
 . S RETVAL=1
 Q RETVAL ; so "yes", there is other 3rd party coverage
 ; following is another quick and dirty version of it:
OLD3RD() ; this was never actually Ud.  Interesting to see I it agrees
 ; with OTHER3RD, above
 N IADTINS S IADTINS=$P(^ABSBITMS(9002302,PCNDFN,0),U,4)
 I 'IADTINS S IADTINS=1
 I IADTINS=IADTINS+1
 N X S X=$O(^ABSBITMS(9002302,PCNDFN,"INSCOV",IADTINS,""))
 Q $S(X="PRVT":1,X="CAID":1,X="CARE":1,X="RR":1,X["SELF":0,1:0)
PHARINFO(PHARINFO,F57IEN) ;EP
 ; want to create field in PEC/MIS - PHARmacies file
 ; and take it from here
 N PHARM1 S PHARM1=$O(^ABSP(9002313.56,0))
 N PHARM I $G(F57IEN) S PHARM=$P($G(^ABSPTL(F57IEN,1)),U,7)
 I '$G(PHARM) S PHARM=PHARM1
 ;
 S X=$P(^ABSP(9002313.56,PHARM,0),U)
 I X="" S X=$P(^ABSP(9002313.56,PHARM1,0),U)
 I X="" S X=$P($G(^ABSSETUP(9002314,1,50)),U,5)
 S PHARINFO("Name")=X
 ;
 N X S X=$G(^ABSP(9002313.56,PHARM,"ADDR"))
 I X="" S X=$G(^ABSP(9002313.56,PHARM1,"ADDR1"))
 I X="" S X=$G(^ABSSETUP(9002314,1,50)),X=$P(X,U,4)_U_U_$P(X,U,1,3)
 S PHARINFO("Street")=$P(X,U)
 S PHARINFO("City/State/ZIP")=$TR($P(X,U,3,5),U," ")
 ;
 S X=$G(^ABSP(9002313.56,PHARM,"REP"))
 I X="" S X=$G(^ABSP(9002313.56,PHARM1,"REP"))
 I X="" S X="PHARmacy Billing Staff"_U_$P($G(^ABSSETUP(9002314,1,50)),U,6)
 N Y S Y=$P(X,U,2),X=$P(X,U) ; X=rep, Y=phone
 N Z S Z=$R($L(X,"/"))+1 ; randomly choose from among several reps
 S PHARINFO("Phone")=$P(Y,"/",Z)
 S PHARINFO("Representative")=$P(X,"/",Z)
 I PHARINFO("Phone")="",DUZ(2)=1859 D
 . S PHARINFO("Phone")="(907) 966-8433"
 ;
 S X=$P(^ABSP(9002313.56,PHARM,0),U,2)
 I X="" S X=$P(^ABSP(9002313.56,PHARM1,0),U,2)
 I X="" S X=$P($G(^ABSSETUP(9002314,1,"RX")),U,2)
 S PHARINFO("PHARmacy #")=X
 ;
 S X=$P($G(^ABSP(9002313.56,PHARM,"CAID")),U)
 I X="" S X=$P($G(^ABSP(9002313.56,PHARM1,"CAID")),U)
 S PHARINFO("Medicaid PHARmacy #")=X
 ;
 D  ; Tax ID # - some INSurance companies want this printed, INStead
 . S X=$P($G(^ABSP(9002313.56,PHARM,0)),U,5) ; maybe PHARm-specific
 . I X="" S X=$P($G(^ABSSETUP(9002314,1,60)),U) ; else billing setup
 . S PHARINFO("Tax ID #")=X
 Q
 ;--------------------------------------------------------------------
DRUGINFO(VMEDINFO,DRUGN,DRUGINFO) ;EP
 ;Manage local variables
 N VMEDIEN,RXIEN,RXRFIEN,DRUGIEN,PROVIEN,PERIEN,VCPTIEN,F57IEN
 ;
 Q:$G(VMEDINFO)=""
 Q:$G(DRUGN)=""
 ;
 S VMEDIEN=$P(VMEDINFO,U,1)
 S RXIEN=$P(VMEDINFO,U,2)
 S RXRFIEN=$P(VMEDINFO,U,3)
 S F57IEN=$P(VMEDINFO,U,6)
 S DRUGIEN=$P($G(^PSRX(RXIEN,0)),U,6)
 S PROVIEN=$P($G(^PSRX(RXIEN,0)),U,4) ; points to file 200
 S PERIEN=$S(PROVIEN="":"",1:$P($G(^VA(200,PROVIEN,0)),U,1))
 S VCPTIEN=$P(VMEDINFO,U,5)
 ;
 S DRUGINFO("Date Written")=$P(VMEDINFO,U,4)
 ;ZW RXIEN,RXRFIEN R ">>>",%,!
 ; Sadly, it is possible F some of the refills to be deleted
 ; after the fact!  Have to U more $Gs and IFs
 N X I RXRFIEN S X=$P($G(^PSRX(RXIEN,1,RXRFIEN,0)),U)
 E  S X=$P(^PSRX(RXIEN,2),U,2)
 S DRUGINFO("Date Filled")=X ;$P($G(^AUPNVSIT(VSTIEN,0)),U,1)
 S DRUGINFO(DRUGN,"RX Number")=$P($G(^PSRX(RXIEN,0)),U,1)
 ;
 ; THIS REFILL COUNT IS GOING TO BE WRONG I YOU PRINT THE BILL
 ; AFTER THE NEXT REFILL HAS HAPPENED!!!
 ;S X=$P($G(^PSRX(RXIEN,0)),U,9) I X,$L(X<2) S X=0_X
 S X=$$RXRFN^ABSPOSCD(RXIEN,RXRFIEN) ; SO USE THESE-CLAIMS SUBROUTINE INSTEAD
 S DRUGINFO(DRUGN,"N/Refill")=$TR($J(X,2)," ","0") ;$S(X:X,1:"00") K X
 ;S DRUGINFO(DRUGN,"Metric Quantity")=$S(VMEDIEN:$P($G(^AUPNVMED(VMEDIEN,0)),U,6),1:"")
 ;I 'VMEDIEN S DRUGINFO(DRUGN,"Metric Quantity")=$S(RXIEN:$P($G(^PSRX(RXIEN,0)),U,7),1:"")
 I RXRFIEN S X=$P($G(^PSRX(RXIEN,1,RXRFIEN,0)),U,4)
 E  S X=$P(^PSRX(RXIEN,0),U,7)
 S DRUGINFO(DRUGN,"Metric Quantity")=X ; actually Metric Decimal Quantity
 I RXRFIEN S X=$P($G(^PSRX(RXIEN,1,RXRFIEN,0)),U,10)
 E  S X=$P(^PSRX(RXIEN,0),U,8)
 S DRUGINFO(DRUGN,"Days Supply")=X ;$S(VMEDIEN:$P($G(^AUPNVMED(VMEDIEN,0)),U,7),1:"")
 ;I 'VMEDIEN S DRUGINFO(DRUGN,"Days Supply")=$S(RXIEN:$P($G(^PSRX(RXIEN,0)),U,8),1:"")
 ;IHS/SD/lwj 03/10/04 patch 10 rmkd next line out, new line added
 ;I RXRFIEN S X=$P($G(^PSRX(RXIEN,1,RXRFIEN,0)),U,13) ;patch 10
 I RXRFIEN S X=$$NDCVAL^ABSPFUNC(RXIEN,RXRFIEN)  ;patch 10
 E  S X=$P(^PSRX(RXIEN,2),U,7)
 ;IHS/SD/lwj 03/10/04 patch 10 end change
 S DRUGINFO(DRUGN,"NDC Code")=X ;$S(DRUGIEN="":"",1:$P($G(^PSDRUG(DRUGIEN,2)),U,4))
 S DRUGINFO(DRUGN,"DRUG Name")=$S(DRUGIEN="":"",1:$P($G(^PSDRUG(DRUGIEN,0)),U,1))
 S DRUGINFO(DRUGN,"Prescriber")=$S(PERIEN'="":PERIEN,1:"")
 S DRUGINFO(DRUGN,"Presc. DEA #")=$S(PROVIEN'="":$P($G(^VA(200,PROVIEN,"PS")),U,2),1:"")
 S DRUGINFO(DRUGN,"Presc. Mcaid #")=$S(PROVIEN'="":$P($G(^VA(200,PROVIEN,9999999)),U,7),1:"")  ;2/18/2000 DL
 I DRUGINFO(DRUGN,"Presc. Mcaid #")="" D
 . N PHARM S PHARM=$P(^ABSPTL(F57IEN,1),U,7)
 . S DRUGINFO(DRUGN,"Presc. Mcaid #")=$P($G(^ABSP(9002313.56,PHARM,"CAID")),U,2) ; default Medicaid Provider # F this PHARmacy
 I DRUGINFO(DRUGN,"Presc. DEA #")="" D
 . N PHARM S PHARM=$P(^ABSPTL(F57IEN,1),U,7)
 . S DRUGINFO(DRUGN,"Presc. DEA #")=$P(^ABSP(9002313.56,PHARM,0),U,3)
 N X S X=^ABSPTL(F57IEN,5)
 S DRUGINFO(DRUGN,"Disp. Fee")=$P(X,U,4)
 S DRUGINFO(DRUGN,"Total Price")=$P(X,U,5) ;$S(VCPTIEN="":"",1:$P($G(^ABSVCPT(9002301,VCPTIEN,0)),U,5))
 S DRUGINFO(DRUGN,"Ingr. Cost")=$P(X,U,3) ;DRUGINFO(DRUGN,"Total Price")-DRUGINFO(DRUGN,"Disp. Fee")
 ;S:DRUGINFO(DRUGN,"Ingr. Cost")<0 DRUGINFO(DRUGN,"Ingr. Cost")=0
 S DRUGINFO(DRUGN,"Balance")=DRUGINFO(DRUGN,"Total Price")
 Q
