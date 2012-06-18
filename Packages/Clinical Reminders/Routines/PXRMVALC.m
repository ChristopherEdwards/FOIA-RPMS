PXRMVALC ; SLC/KR Validate Codes (format/value)    ; 05/16/2000
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 Q
 ;   
 ; Entry points (extrinsic functions)
 ;   
 ;     ICD^PXRMVALC(<code>)   Validate ICD-9-CM Diagnosis Code
 ;     ICP^PXRMVALC(<code>)   Validate ICD-9-CM Procedure Code
 ;     CPT^PXRMVALC(<code>)   Validate CPT-4 Procedure Code
 ;   
 ;  All entry points return:
 ;  
 ;    <validity>^<input>^<output>^<error>^<file #>^<global root>^
 ;    <type of code>^<input IEN>^<input flag>^<output IEN>^
 ;    <output flag>^<description>
 ;   
ICD(X) ; Validate ICD-9-CM Diagnosis Code from file 80
 S X=$G(X),U="^" N CHR,CHKD,CIN,CODE,COUT,DIC,ERR,ES,EXP,FNUM,FORM,IENI,IENO,IFIN,IFOUT,NAME,NUMERIC,PAT,TY,VAL,Y
 S VAL=1,FNUM=80,DIC="ICD9(",(IFIN,IFOUT,NAME)="",CIN=$TR(X,"""",""),U="^"
 S FORM=$S($E(X,1)="E":2,$E(X,1)="V":3,$E(X,1)?1N:1,1:1),TY=$S(FORM=2:"ICD ""E"" code",FORM=3:"ICD ""V"" code",FORM=1:"ICD code",1:"ICD code")
 S ERR="Valid "_TY,CHKD=$S(FORM=2:"ICD-9-CM ""E"" external cause code",FORM=3:"ICD-9-CM ""V"" health factor code",FORM=1:"ICD-9-CM diagnosis code",1:"ICD-9-CM code")
 S PAT=$S(FORM=2:"ENNN.nn",FORM=3:"VNN.nn",FORM=1:"NNN.nn",1:"ENNN.nn, VNN.nn or NNN.nn")
 ; Code transformation
 S CODE=X S:CODE'["." CODE=CODE_"."
 S:FORM=1&($L($P(CODE,".",1))=1)&(+($P(CODE,".",1))>0) $P(CODE,".",1)="00"_$P(CODE,".",1) S:FORM=1&($L($P(CODE,".",1))=2)&(+($P(CODE,".",1))>0) $P(CODE,".",1)="0"_$P(CODE,".",1) S X=CODE
 S CODE=$P(CODE,".",1,2),CODE=$$NEXT^PXRMVALU(CODE,80),COUT=CODE,(IENI,IENO)=""
 I $D(^ICD9("BA")),$D(^ICD9("BA",(COUT_" "))) D
 . S IENO=+($O(^ICD9("BA",(COUT_" "),0))),NAME=$P($G(^ICD9(+IENO,0)),U,3),IFOUT=$P($G(^ICD9(+IENO,0)),U,9)
 S ES="Invalid "_TY_" format "
 ; Format
 ;    not enough digits
 I $E(CIN,1)="E",$L($P($E(CIN,2,$L(CIN)),".",1))<3 D ERR((ES_"(not enough digits, "_PAT_")")) G AQ
 I $E(CIN,1)?1N,$L($P(CIN,".",1))<3 D ERR((ES_"(not enough digits, "_PAT_")")) G AQ
 I $E(CIN,1)="V",$L($P($E(CIN,2,$L(CIN)),".",1))<2 D ERR((ES_"(not enough digits, "_PAT_")")) G AQ
 ;    too many digits
 I $E(CIN,1)="E",$L($P($E(CIN,2,$L(CIN)),".",1))>3 D ERR((ES_"(too many digits, "_PAT_")")) G AQ
 I $E(CIN,1)?1N,$L($P(CIN,".",1))>3 D ERR((ES_"(too many digits, "_PAT_")")) G AQ
 I $E(CIN,1)="V",$L($P($E(CIN,2,$L(CIN)),".",1))>2 D ERR((ES_"(too many digits, "_PAT_")")) G AQ
 ;    missing decimal point
 I CIN'["." D ERR((ES_"(missing decimal point "_PAT_")")) G AQ
 ;    to many decimal points
 I $L(CIN,".")>2 D ERR((ES_"(too many decimal points "_PAT_")")) G AQ
 ;    to many decimal places
 I $L($P(CIN,".",2))>2 D ERR((ES_"(too many decimals places, "_PAT_")")) G AQ
 ;    non-numeric decimal
 I $P(CIN,".",2)'?2N&($P(CIN,".",2)'?1N)&($P(CIN,".",2)'="") D ERR((ES_"(non-numeric decimal, "_PAT_")")) G AQ
 ;    invalid pattern
 I $E(CIN,1)="E",$P(CIN,".",1)'?1U3N D ERR((ES_"("_PAT_")")) G AQ
 I $E(CIN,1)="V",$P(CIN,".",1)'?1U2N D ERR((ES_"("_PAT_")")) G AQ
 I $E(CIN,1)?1N,$P(CIN,".",1)'?3N D ERR((ES_"("_PAT_")")) G AQ
 ; Value
 ;    not found
 I $D(^ICD9("BA")),'$D(^ICD9("BA",(CIN_" "))) D  G AQ
 . N TC D ERR((TY_" not found in the ICD-9 file (#80)"))
 . S TC=COUT S:'$L(TC) TC=CIN I $E(TC,$L(TC))="0" D
 . . N SC,COUT S (SC,COUT)=TC F  S TC=$E(TC,1,($L(TC)-1)) S:$D(^ICD9("BA",(TC_" "))) SC=TC Q:$E(TC,$L(TC))'="0"!(SC'=COUT)  Q:TC=""
 . . S TC="" S:SC'=COUT TC=SC
 . S:$L(TC) COUT=TC
 . S:$D(^ICD9("BA",(CIN_"0 "))) COUT=CIN_"0"
 . I $D(^ICD9("BA")),$D(^ICD9("BA",(COUT_" "))) D
 . . S IENO=+($O(^ICD9("BA",(COUT_" "),0))),NAME=$P($G(^ICD9(+IENO,0)),U,3),IFOUT=$P($G(^ICD9(+IENO,0)),U,9)
 ;    found
 I $D(^ICD9("BA")),$D(^ICD9("BA",(CIN_" "))) D  G AQ
 . D ERR(("Valid "_TY)) S VAL=1,IENI=+($O(^ICD9("BA",(CIN_" "),0)))
 . S NAME=$P($G(^ICD9(+IENI,0)),U,3),IFIN=$P($G(^ICD9(+IENI,0)),U,9) S:(+(IFOUT)+(IFIN))>0 ERR="Inactive "_TY
 G AQ
 ;   
ICP(X) ; Validate ICD-9-CM Procedure Code from file 80.1
 S X=$G(X),U="^" N CHR,CHKD,CIN,CODE,COUT,DIC,ERR,ES,EXP,FNUM,FORM,IENI,IENO,IFIN,IFOUT,NAME,NUMERIC,PAT,TY,VAL,Y
 S FNUM=80.1,DIC="ICD0(",VAL=1,(NAME,IFIN,IFOUT)="",CIN=$TR(X,"""","")
 ; Code transformation
 S CODE=X,TY="ICD Procedure code",PAT="NN.nn",CHKD=TY S:CODE'["." CODE=CODE_"." S:$L($P(CODE,".",1))=1 CODE="0"_CODE S CODE=$$NEXT^PXRMVALU(CODE,80.1),COUT=CODE
 S VAL=1,ERR="Valid "_TY I $D(^ICD0("BA")),$D(^ICD0("BA",(CODE_" "))) S IENO=+($O(^ICD0("BA",(CODE_" "),0))),NAME=$P($G(^ICD0(+IENO,0)),U,4),IFOUT=$P($G(^ICD0(+IENO,0)),U,9)
 S ES="Invalid "_TY_" format "
 ; Format
 ;    not enough digits
 I $L($P(CIN,".",1))<2 D ERR((ES_"(not enough digits, "_PAT_")")) G AQ
 ;    too many digits
 I $L($P(CIN,".",1))>2 D ERR((ES_"(too many digits, "_PAT_")")) G AQ
 ;    missing decimal point
 I CIN'["." D ERR((ES_"(missing decimal point "_PAT_")")) G AQ
 ;    too many decimal points
 I $L(CIN,".")>2 D ERR((ES_"(too many decimal points "_PAT_")")) G AQ
 ;    too many decimal places
 I $L($P(CIN,".",2))>2 D ERR((ES_"(too many decimals places, "_PAT_")")) G AQ
 ;    non-numeric decimal
 I $P(CIN,".",2)'?2N&($P(CIN,".",2)'?1N)&($P(CIN,".",2)'="") D ERR((ES_"(non-numeric decimal, "_PAT_")")) G AQ
 ;    invalid pattern
 I $P(CIN,".",1)'?2N D ERR((ES_"("_PAT_")")) G AQ
 ; Value
 ;    not found
 I $D(^ICD0("BA")),'$D(^ICD0("BA",(CIN_" "))) D  G AQ
 . N TC D ERR((TY_" not found in the ICD-9 file (#80.1)")) S COUT=""
 . S TC=COUT S:'$L(TC) TC=CIN I $E(TC,$L(TC))="0" D
 . . N SC,COUT S (SC,COUT)=TC F  S TC=$E(TC,1,($L(TC)-1)) S:$D(^ICD0("BA",(TC_" "))) SC=TC Q:$E(TC,$L(TC))'="0"!(SC'=COUT)  Q:TC=""
 . . S TC="" S:SC'=COUT TC=SC
 . S:$L(TC) COUT=TC
 . S:$D(^ICD0("BA",(CIN_"0 "))) COUT=CIN_"0"
 . I $D(^ICD0("BA")),$D(^ICD0("BA",(COUT_" "))) D
 . . S IENO=+($O(^ICD0("BA",(COUT_" "),0))),NAME=$P($G(^ICD0(+IENO,0)),U,3),IFOUT=$P($G(^ICD0(+IENO,0)),U,9)
 ;    found
 I $D(^ICD0("BA")),$D(^ICD0("BA",(CIN_" "))) D  G AQ
 . S VAL=1,ERR="Valid "_TY,IENI=+($O(^ICD0("BA",(CIN_" "),0)))
 . S NAME=$P($G(^ICD0(+IENI,0)),U,4),IFIN=$P($G(^ICD0(+IENI,0)),U,9) S:(+(IFOUT)+(IFIN))>0 ERR="Inactive "_TY
 G AQ
 ;            
CPT(X) ; Validate CPT-4 Procedure Code from file 81
 S X=$G(X),U="^"
 N CHR,CHKD,CIN,CODE,COUT,DIC,ERR,ES,EXP,FNUM,FORM,IENI,IENO,IFIN,IFOUT
 N NAME,NUMERIC,PAT,STATUS,TEMP,TY,VAL,Y
 S VAL=1,FNUM=81,DIC="ICPT(",(IFIN,IFOUT,NAME)="",CIN=$TR(X,"""",""),U="^",FORM=$S($E(X,1)?1N:1,$E(X,1)?1U:2,1:1)
 S TY=$S(FORM=1:"CPT-4 code",FORM=2:"HCPCS code",1:"Procedure code")
 S CHKD=$S(FORM=1:"CPT-4 procedure code",FORM=2:"HCPCS procedure code",1:"CPT-4 procedure code")
 S PAT=$S(FORM=1:"NNNNN",FORM=2:"UNNNN",1:"NNNNN or UNNNN")
 S ES="Invalid "_TY_" format "
 ; Code transformation
 ;    HCPCS
 S CODE=X I FORM=2 D
 . N CHR,NUMERIC S CHR=$E(CODE,1),NUMERIC=$E(CODE,2,$L(CODE))
 . S NUMERIC=$TR(NUMERIC,"~!@#$%^&*()_-+=[{]};:\|,./?<>QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm","0000000000000000000000000000000000000000000000000000000000000000000000000000000000")
 . F  Q:$E(NUMERIC,1)'="0"  S NUMERIC=$E(NUMERIC,2,$L(NUMERIC))
 . S NUMERIC=+NUMERIC F  Q:$L(NUMERIC)>3  S NUMERIC="0"_NUMERIC
 . S CODE=CHR_NUMERIC
 ;    CPT-4
 I FORM=1 D
 . N NUMERIC S NUMERIC=CODE,NUMERIC=$TR(NUMERIC,"~!@#$%^&*()_-+=[{]};:\|,./?<>QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm","0000000000000000000000000000000000000000000000000000000000000000000000000000000000")
 . I +NUMERIC>0,$E(NUMERIC,1)'="0",$L(NUMERIC)<5 F  Q:$L(NUMERIC)=5  S NUMERIC="0"_NUMERIC
 . I +NUMERIC>0,$E(NUMERIC,1)="0",$L(NUMERIC)<5 F  Q:$L(NUMERIC)=5  S NUMERIC=NUMERIC_"0"
 . F  Q:$E(NUMERIC,1)'="0"  S NUMERIC=$E(NUMERIC,2,$L(NUMERIC))
 . S NUMERIC=+NUMERIC F  Q:$L(NUMERIC)>4  S NUMERIC="0"_NUMERIC
 . S CODE=NUMERIC
 S CODE=$$NEXT^PXRMVALU(CODE,81),COUT=CODE S (IENI,IENO)=""
 I $L(COUT),$D(^ICPT("B")),$D(^ICPT("B",COUT)) D
 . S IENO=+($O(^ICPT("B",COUT,0)))
 . S TEMP=$$CPT^ICPTCOD(IENO)
 . S NAME=$P(TEMP,U,3)
 . S STATUS=$P(TEMP,U,7)
 . S IFOUT=$S(STATUS:"",1:1)
 ; Format
 ;    not enough characters
 I $L(CIN)<5 D ERR((ES_"(not enough characters)")) G AQ
 ;    too many characters
 I $L(CIN)>5 D ERR((ES_"(too many characters)")) G AQ
 ;    invalid pattern
 ;       CPT-4
 I $E(CIN,1)?1N,CIN'?5N D ERR((ES_"("_PAT_")")) G AQ
 ;       HCPCS
 I $E(CIN,1)?1U,CIN'?1U4N D ERR((ES_"("_PAT_")")) G AQ
 I CIN'?5N&(CIN'?1U.4N) D ERR(("Invalid code format (NNNNN or UNNNN)")) G AQ
 ; Value
 ;    not found
 I $D(^ICPT("B")),'$D(^ICPT("B",CIN)) D ERR((TY_" not found in the CPT file (#81)")) S COUT="" G AQ
 ;    found
 I $D(^ICPT("B")),$D(^ICPT("B",CIN)) D  G AQ
 . S VAL=1,ERR="Valid "_TY,IENI=+($O(^ICPT("B",CIN,0)))
 . S TEMP=$$CPT^ICPTCOD(IENO)
 . S NAME=$P(TEMP,U,3)
 . S STATUS=$P(TEMP,U,7)
 . S IFIN=$S(STATUS:"",1:1)
 . S:(+(IFOUT)+(IFIN))>0 ERR="Inactive "_TY
 G AQ
AQ ; Assemble output string and quit
 S X=$G(VAL)_U_$G(CIN)_U_$G(COUT)_U_$G(ERR)_U_FNUM
 S X=X_U_DIC_U_$G(CHKD)_U_$G(IENI)_U_$G(IFIN)_U_$G(IENO)_U_$G(IFOUT)_U_$G(NAME)
 F  Q:$E(X,$L(X))'="^"  S X=$E(X,1,($L(X)-1))
 Q X
ERR(X) S VAL=0,ERR=$G(X) Q
