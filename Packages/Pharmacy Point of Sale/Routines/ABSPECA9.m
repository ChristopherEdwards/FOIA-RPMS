ABSPECA9 ; IHS/FCS/DRS - pretty print pharm claim packet ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ; Development utility; not hooked into any option
 ; DO PRINT^ABSPECA9(record,format) ;format defaults based on Bin #
 ; DO PRINTN^ABSPECA9(IEN,JOB) for ^ABSPEC(job,"C",ien,n)
 ;    (job defaults to $J)
 Q
TESTING ;O 51:("TEMP.OUT":"W") U 51
 D PRINTN(17636,4,1)
 ;C 51
 Q
PRINTN(IEN,JOB,DUMP)        ; print from ^ABSPEC(job,"C",ien,n)
 N REC S REC=""
 I $G(JOB)="" S JOB=$J
 N I F I=1:1:^ABSPECX(JOB,"C",IEN,0) S REC=REC_^(I) ; reconstruct
 I $G(DUMP) D
 .N I,J F I=1:20:$L(REC) D
 ..W $J(I,4),"/ "
 ..F J=0:1:19 D
 ...I J=10 W " | "
 ...N X S X=$E(REC,I+J)
 ...I X?.ANP W "'",X," "
 ...E  W $J($A(X),3)
 ..W !
 .
 ; Find Bin number
 N BIN S BIN=$E(REC,4,9)
 N FMT S FMT=$$FINDFMT(BIN)
 I FMT="" W "Cannot find format for Bin# ",BIN,!
 D PRINT(REC,FMT)
 Q
FINDFMT(BIN)       ; given BIN, lookup format and return it
 ; This will work, but beware cases like MedImpact, where you might
 ; have multiple formats using the same bin.  In the Medimpact case,
 ; the only difference between the formats is the Processor Control
 ; Number that is sent in the NDC packet.  
 ;W "FINDFMT(",BIN,")",!
 N STOP
 N A S A="" F  S A=$O(^ABSPF(9002313.92,A)) Q:A=""  D  Q:$G(STOP)
 .N B S B=$G(^ABSPF(9002313.92,A,1)),B=$P(B,U)
 .I B=BIN S STOP=1 ; found it
 Q A
PRINT(REC,FMT)     ; FMT pointer into ^ABSPF(9002313.92,ien) ; defaultable
 ; REC = the assembled record
 ; Caller takes care of IO device, we just write
 N POS S POS=1 ; position in record
 I $E(REC,1,2)="HN" D
 .N X S X=$E(REC,3)
 .I X="*" W "Production mode"
 .E  I X="." W "Test mode"
 .E  W "Mode ",X," unknown?"
 .W !
 .S POS=POS+3
 N TRANCODE ; transaction code
 I '$D(FMT) N FMT S FMT=$$FINDFMT($E(REC,POS,POS+5))
 I '$G(FMT) W "Format unknown",! Q
 N X S X=^ABSPF(9002313.92,FMT,0)
 W "Format: ",$P(X,U),!
 N SECTION F SECTION=10,20 D PRINT1
 N TRANNUM F TRANNUM=1:1:TRANCODE F SECTION=30,40 DO PRINT1
 I $L(REC)+1'=POS W "Mismatch; length of record = ",$L(REC)
 I  W "; +1 = ",$L(REC)+1," '= position ",POS,!
 Q
NAME(X) I X=10 Q "Claim Header - Required"
 I X=20 Q "Claim Header - Optional"
 I X=30 Q "Claim Information "_$S(TRANCODE>1:"#"_TRANNUM_" of "_TRANCODE_")",1:"")_" - Required"
 I X=40 Q "Claim Information - Optional"
 W "X=",X,! ; invalid
 D IMPOSS^ABSPOSUE("P","TI",X,,"NAME",$T(+0))
 Q
PRINT1 ; printing one section
 W " - - - ",$$NAME(SECTION)," - - - at position ",POS," - - -",!
 I SECTION=30 D
 .I $A(REC,POS)=29 S POS=POS+1
 .E  W "Expected $C(29) separator was not found",!
 N FIELD,ORDER S (FIELD,ORDER)=""
 F  D NEXT Q:FIELD=""  D PRINT2
 Q
NEXT ; given SECTION and previous ORDER,        
 ; advance ORDER and return the ncpdp FIELD number
 S ORDER=$O(^ABSPF(9002313.92,FMT,SECTION,"B",ORDER))
 I ORDER="" S FIELD="" Q
 N IEN S IEN=$O(^ABSPF(9002313.92,FMT,SECTION,"B",ORDER,""))
 I 'IEN D IMPOSS^ABSPOSUE("DB","TI",,,"NEXT",$T(+0))
 N X S X=^ABSPF(9002313.92,FMT,SECTION,IEN,0) ; order^field^mode
 N Y S Y=$P(X,U,2) ; ien in the field file
 S FIELD=Y
 Q
PRINT2 ; printing one FIELD  
 N Z S Z=^ABSPF(9002313.91,FIELD,0) ;Number^ID^Name^Format^Length
 N NUMBER S NUMBER=$P(Z,U)
 N ID S ID=$P(Z,U,2)
 N NAME S NAME=$P(Z,U,3)
 N ANFORMAT S ANFORMAT=$P(Z,U,4) ;N,A/N,D
 N LENGTH S LENGTH=$P(Z,U,5)
 W NUMBER ; NCPDP field number
 I ID]"" W "-",ID
 E  W "   "
 N VALUE S VALUE=$$PICKOFF
 I VALUE]"" D
 .W " ",$J($P(VALUE,U),3),"-",$J($P(VALUE,U,2),3),": "
 .S VALUE=$P(VALUE,U,3,$L(VALUE,U))
 W " ",NAME
 I VALUE]"" D
 .W "="
 .I VALUE?.E1" " S VALUE=$$QUOTE(VALUE)
 .W VALUE
 .I VALUE?.E1C.E W " (contains control character(s)!)"
 E  W " not present"
 I NUMBER=103 S TRANCODE=VALUE
 W !
 Q
QUOTE(X) Q """"_X_""""
PICKOFF()          ;given REC and POS within it, pick off data
 ; also given:  field's ID and LENGTH and ANFORMAT
 ; Delimiter is $C(28) - pick it off too, but don't return it
 I $A(REC,POS)=28,$E(REC,POS+1,POS+2)'=ID Q ""
 I $A(REC,POS)=28,$E(REC,POS+1,POS+2)=ID S POS=POS+3
 N FIXED S FIXED=LENGTH ; is it fixed length?
 N END
 I FIXED S END=POS+FIXED-1
 E  D
 .N X F END=POS:1:POS+LENGTH-1 S X=$A(REC,END) Q:X=-1!(X=28)!(X=29)
 N RET S RET=$E(REC,POS,END) ; return up to but not including delimiter
 ;ZW FIXED,LENGTH,POS,END,RET
 ;R ">>>",%,!
 S RET=POS_U_END_U_RET
 S POS=END+1
 Q RET
