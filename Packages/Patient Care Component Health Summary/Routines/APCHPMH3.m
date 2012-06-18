APCHPMH3 ; IHS/CMI/LAB - Patient Wellness Handout ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
MEDS ;EP - DISPLAY MEDS
 ;Suppress original text per Chris Lamer 11/29/07 *17*
 ;S X="Medicines are important - it helps to know" D S(X,1)
 ;S X="",$E(X,5)="Why you will take it?" D S(X,1)  ;*17*
 ;S X="",$E(X,5)="When to take it?" D S(X)
 ;S X="",$E(X,5)="How much to take?"  D S(X)
 ;S X="",$E(X,5)="What to do if you forget to take it?"  D S(X)
 ;S X="",$E(X,5)="What could happen if you forget or take too much."  D S(X)
 ;S X="Knowing these things will help the medicine work best for you." D S(X,1)  ;*17*
 S X="Medications - here is a list of the medicines you are taking:"  D S(X,1)
 S X="" D S(X)
 ;
 ;get all "active" meds
 S APCHSDLM=$$FMADD^XLFDT(DT,-365),APCHSDLM=9999999-APCHSDLM
 S APCHSIVD=0,APCHSMCT=0 F APCHSQ=0:0 S APCHSIVD=$O(^AUPNVMED("AA",APCHSDFN,APCHSIVD)) Q:APCHSIVD=""!(APCHSIVD>APCHSDLM)  S APCHSMX=0 F APCHSQ=0:0 S APCHSMX=$O(^AUPNVMED("AA",APCHSDFN,APCHSIVD,APCHSMX)) Q:APCHSMX=""  D MEDBLD
 I $G(APCHSMCT)=0 S X="",$E(X,5)="No current meds on file" D S(X)
 S APCHSMED=""
 F  S APCHSMED=$O(APCHSM(APCHSMED)) Q:$G(APCHSMED)']""  D
 .S X="",$E(X,5)=APCHSMED D S(X)
 .K ^UTILITY($J,"W") S APCHSIG=$P($G(APCHSM(APCHSMED)),U,5),X=APCHSIG,DIWL=0,DIWR=58 D ^DIWP
 .S X="",$E(X,7)="Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S(X)
 .I $G(^UTILITY($J,"W",0))>1 F I=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,7)=$G(^UTILITY($J,"W",0,I,0)) D S(X)
 .K ^UTILITY($J,"W")
 .Q
 D HOLD
 I '$D(APCHHM) Q
 S X="Medications ordered, but not yet dispensed" D S(X,1)
 S X="" D S(X)
 S APCHHMED=""
 F  S APCHHMED=$O(APCHHM(APCHHMED)) Q:$G(APCHHMED)']""  D
 .S X="",$E(X,5)=APCHHMED D S(X)
 Q
MEDBLD ;BUILD ARRAY OF MEDICATIONS 
 ;
 K APCHSRXP,APCHSCOT
 Q:'$D(^AUPNVMED(APCHSMX,0))
 S APCHSN=^AUPNVMED(APCHSMX,0)
 Q:'$D(^PSDRUG($P(APCHSN,U,1)))
 S APCHSDTM=-APCHSIVD\1+9999999  ;Visit date from V Med .03 field
 Q:$P(APCHSN,U,8)]""  ;date discontinued
 S APCHSRXP=$S($D(^PSRX("APCC",APCHSMX)):$O(^(APCHSMX,0)),1:0)  ;RX IEN
 I APCHSRXP>0 S RX0=^PSRX(APCHSRXP,0),RX2=^PSRX(APCHSRXP,2) I '$D(^PSRX(APCHSRXP,"STA")) D RXSTAT Q:ST="EXPIRED"!(ST="CANCELLED")!(ST="DELETED")  ;CALCULATE RX STATUS IF V6
 I $G(APCHSRXP)'>0 S APCHSCOT=1  ;may be using COTS or med entered via PCC data entry
 I $P($G(^AUPNVMED(APCHSMX,12)),U,9)]"" S APCHSCOT=1  ;external key present
 S APCHSSTA=$P($G(^PSRX(APCHSRXP,0)),U,15)  ;Active? RX File status
 Q:$G(APCHSSTA)>10  ;status is expired, deleted or cancelled
 I $G(^PSRX(APCHSRXP,"STA"))>10 Q  ;Status is in "STA" node in V 7
 I $G(^PSRX(APCHSRXP,"STA"))=1 Q  ;NON-VERIFIED
 I $G(^PSRX(APCHSRXP,"STA"))=4 Q  ;DRUG INTERACTION
 S APCHSIG=""
 S APCHSIG=$P($G(APCHSN),U,5)
 D SIG  ;get expanded sig
 S APCHSDYS=$P($G(APCHSN),U,7)  ;days supply
 ;Q:APCHSDYS=1  ;quit if only 1 day supply
 I $G(APCHSCOT)=1,$G(APCHSDYS)]"",$$FMDIFF^XLFDT(DT,APCHSDTM)>$G(APCHSDYS) Q
 ;Q:$P($G(^AUPNVMED(APCHSMX,0)),U,6)=1  ;quit if qty=1
 I $P($G(^AUPNVMED(APCHSMX,0)),U,6)=1,APCHSDYS=1 Q  ;quit if qty=1 AND days supply=1  **17**
 S APCHSMFX=$P(^PSDRUG(+APCHSN,0),U)  D  ;compare Drug File .01 field & V Med Name of Non Table Drug
 .Q:$P(APCHSN,U,4)=""
 .I $P($G(APCHSN),U,4)]"",$P($G(APCHSN),U,4)=$P(^PSDRUG(+APCHSN,0),U) Q
 .I $P($G(APCHSN),U,4)]"",$P($G(APCHSN),U,4)'=$P(^PSDRUG(+APCHSN,0),U) S APCHSMFX=$P(APCHSN,U,4)
 .Q
 I $G(APCHSM(APCHSMFX)) Q  ;quit if med already exists
 S APCHSM(APCHSMFX)=+APCHSN_U_APCHSDYS  ;PSDRUG ien^days supply
 I $G(APCHSRXP)>0 S $P(APCHSM(APCHSMFX),U,3)=APCHSRXP  ;^PSRX ien
 S $P(APCHSM(APCHSMFX),U,4)=$G(ST)  ;status from RXSTAT
 S $P(APCHSM(APCHSMFX),U,5)=$G(APCHSSGY)
 S APCHSMCT=APCHSMCT+1  ;number of active meds
 Q
 ;
RXSTAT ;gets status of rx ... TAKEN FROM PSOFUNC ROUTINE
 Q:$D(^PSRX(APCHSRXP,"STA"))  ;USING V7
 Q:$G(APCHSRXP)'>0
 S J=APCHSRXP
 S ST0=+$P(RX0,"^",15) I ST0<12,$O(^PS(52.5,"B",J,0)),$D(^PS(52.5,+$O(^(0)),0)),'$G(^("P")) S ST0=5
 I ST0<12,$P(RX2,"^",6),$P(RX2,"^",6)'>DT S ST0=11
 S ST=$P("ERROR^ACTIVE^NON-VERIFIED^REFILL FILL^HOLD^PENDING DUE TO DRUG INTERACTION^SUSPENDED^^^^^DONE^EXPIRED^CANCELLED^DELETED","^",ST0+2),$P(RX0,"^",15)=ST0
 Q
 ;S ST0=+$P(RX0,"^",15) I ST0<12,$O(^PS(52.5,"B",J,0)),$D(^PS(52.5,+$O(^(0)),0)),'$G(^("P")) S ST0=5
 ;I ST0<12,$P(RX2,"^",6)<DT S ST0=11
 ;S ST=$P("Error^Active^Non-Verified^Refill^Hold^Non-Verified^Suspended^^^^^Done^Expired^Discontinued^Deleted^Discontinued^Discontinued (Edit)^Provider Hold^","^",ST0+2),$P(RX0,"^",15)=ST0
 ;Q
HOLD ;Now get meds in Pharmacy yet to be completed
 Q:'APCHSDFN
 S APCHSDT=DT
 F  S APCHSDT=$O(^PS(55,APCHSDFN,"P","A",APCHSDT)) Q:APCHSDT'=+APCHSDT  D
 .S APCHNMED=0 F  S APCHNMED=$O(^PS(55,APCHSDFN,"P","A",APCHSDT,APCHNMED)) Q:'APCHNMED  D
 ..I $G(^PSRX(APCHNMED,"STA"))=3!($G(^PSRX(APCHNMED,"STA"))=5) D
 ...S APCHHMED=$P(^PSRX(APCHNMED,0),U,6) I $G(APCHHMED)]"" S APCHHMED=$P(^PSDRUG(APCHHMED,0),U)
 ...S APCHHM(APCHHMED)=APCHNMED
 ..Q
 Q
 ; 
SIG ;CONSTRUCT THE FULL TEXT FROM THE ENCODED SIG
 S APCHSSGY="" F APCHSP=1:1:$L(APCHSIG," ") S X=$P(APCHSIG," ",APCHSP) I X]"" D
 . S Y=$O(^PS(51,"B",X,0)) I Y>0 S X=$P(^PS(51,Y,0),"^",2) I $D(^(9)) S Y=$P(APCHSIG," ",APCHSP-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(^(9),"^",1)
 . S APCHSSGY=APCHSSGY_X_" "
 Q
 ; 
 ; 
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("APCHPHS",$J,"PMH",0),U)+1,$P(^TMP("APCHPHS",$J,"PMH",0),U)=%
 S ^TMP("APCHPHS",$J,"PMH",%)=X
 Q
DATE(D) ;EP - convert to slashed date
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
 ;
CLOSE ;EP - Write closing statement per Chris Lamer 11/29/07 *17*
 ;
 S X="* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" D S(X,1)
 S X="",$E(X,5)="This handout is yours to keep and contains information that is in your" D S(X)
 S X="",$E(X,5)="medical record (your chart).  You can keep this handout for your records" D S(X)
 S X="",$E(X,5)="or share the information with other health care workers.  Please let us" D S(X)
 S X="",$E(X,5)="know if anything is wrong or missing from your handout - we want to be" D S(X)
 S X="",$E(X,5)="sure it is correct."  D S(X)
 S X="",$E(X,5)="Thank you and have a healthy day!" D S(X,1)
 Q
