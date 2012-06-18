ABSPOS9 ; IHS/FCS/DRS - NDC # lookup, formatting ;  
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ; Relies on the ^APSAMDF  AWP-MED TRANSACTION file
 ; Several $$ routines called from lots of places.
 ;
 Q
NDC11(N) ;EP - given N?11N
 I '$$FINDNDC(N) Q ""
 Q $$FMTNDC(N,5,4,2) ; must be 5-4-2?
NDC10(N) ;EP - given N?10N, find format and format it
 N M,X,Y,Z
 S M=0_N,X=$$FINDNDC(M,1) ; is it valid in 4-4-2 format?
 I X Q $$FMTNDC(N,4,4,2)
 S M=$E(N,1,5)_0_$E(N,6,10) ; is it valid in 5-3-2 format?
 S X=$$FINDNDC(M,2)
 I X Q $$FMTNDC(N,5,3,2)
 S M=$E(N,1,9)_0_$E(N,10) ; is it valid in 5-4-1 format?
 S X=$$FINDNDC(M,3)
 I X Q $$FMTNDC(N,5,4,1)
 ; No, didn't find it anywhere
 Q ""
FMTNDC(N,A,B,C)    ; given N?1n.n and A-B-C format
 I $D(A) Q $E(N,1,A)_"-"_$E(N,A+1,A+B)_"-"_$E(N,A+B+1,A+B+C)
MAKE11N(X) ;EP - given NDC code with "-", convert to ?11N
 ; it may involve putting an extra 0 in the right place
 I X?5N1"-"4N1"-"2N ; it's okay as-is
 E  I X?4N1"-"4N1"-"2N S $P(X,"-",1)="0"_$P(X,"-",1)
 E  I X?5N1"-"3N1"-"2N S $P(X,"-",2)="0"_$P(X,"-",2)
 E  I X?5N1"-"4N1"-"1N S $P(X,"-",3)="0"_$P(X,"-",3)
 Q $TR(X,"-")
NAME(X) ;EP - return drug name as stored in ^APSAMDF
 N Y I X["-" S Y=$$MAKE11N(X)
 E  S Y=X
 I Y'?11N Q "(can't figure out 11N format?)"
 N Z S Z=$O(^APSAMDF("B",Y,0))
 I Z Q $P($G(^APSAMDF(Z,2)),U)
 ; not in AWP-MED TRANSACTION; try the DRUG file
 S Z=$O(^PSDRUG("ZNDC",$TR(X,"-",""),0))
 I Z Q $P(^PSDRUG(Z,0),U)_" (from DRUG file)"
 Q "("_X_" in neither AWP-MED TRANSACTION nor DRUG file)"
FINDNDC(N,F)         ; return pointer into AWP MED-TRANSACTION
 ; F is optional - if F present, then it must match for this format
 ; returns null if not found
 N X S X=$O(^APSAMDF("B",N,0)) I X="" Q ""
 I '$D(F) Q X
 I $P(^APSAMDF(X,2),U,3)'=F Q "" ; yes, but not in this format
 Q X  ; matches number and format, both
FORMTNDC(N) ;EP - given N?11N, lookup format and put "-" in right places
 I N'?11N S N=$TR($J(N,11)," ","0") I N'?11N Q N
 N X,F S X=$$FINDNDC(N) I 'X Q N
 I X S F=$P($G(^APSAMDF(X,2)),U,3) I 'F Q N
 ; 4-4-2 format
 I F=1,X?1"0"4N4N2N Q $$FMTNDC(N,4,4,2)
 ; 5-3-2 format
 I F=2,X?5N1"0"3N2N Q:$$FMTNDC(N,5,3,2)
 ; 5-4-1 format
 I F=3,X?5N4N1"0"1N Q $$FMTNDC(N,5,4,1)
 ; else 5-4-2 format?
 Q $$FMTNDC(N,5,4,2)
 Q
NDCTEST ;
 W "Comprehensive test of valid NDC #s",!
 S OUTPUT=0
 S NDC=0 F I=1:1 S NDC=$O(^APSAMDF("B",NDC)) Q:'NDC  D NDCTEST0
 Q
NDCTEST0 ;
 N X S X=$$FINDNDC(NDC) I 'X D  Q
 . D IMPOSS^ABSPOSUE("P","T",,,"NDCTEST0",$T(+0))
 N F S F=$P(^APSAMDF(X,2),"^",3)
 Q:F=4  Q:F=5
 D NDCTEST1(NDC)
 I $E(NDC,1)=0 W:OUTPUT "4-4-2 test..." D NDCTEST1($E(NDC,2,11))
 I $E(NDC,6)=0 W:OUTPUT "5-3-2 test..." D NDCTEST1($E(NDC,1,5)_$E(NDC,7,11))
 I $E(NDC,10)=0 W:OUTPUT "5-4-1 test..." D NDCTEST1($E(NDC,1,9)_$E(NDC,11))
 Q
NDCTEST1(NDC) ; given NDC
 N X,F
 I $L(NDC)=11 D  Q
 .S X=$$FINDNDC(NDC)
 .I X D
 ..N F S F=$P(^APSAMDF(X,2),"^",3)
 ..W:OUTPUT $$FMTNDC(NDC,5,4,2)," Format=",F,!
 .E  W NDC," Not found",!
 W:OUTPUT "Test ",NDC,"..."
 I $L(NDC)'=10 D  Q
 . D IMPOSS^ABSPOSUE("P","T","$L(NDC)'=10",NDC,"NDCTEST1",$T(+0))
 N Y,Z
 S X=$$FINDNDC(0_NDC,1) ; is it 4-4-2
 S Y=$$FINDNDC($E(NDC,1,5)_0_$E(NDC,6,10),2) ; is it 5-3-2?
 S Z=$$FINDNDC($E(NDC,1,9)_0_$E(NDC,10),3) ; is it 5-4-1?
 I X&Y!(X&Z)!(Y&Z) W NDC," Ambiguity!",!
 I 'X,'Y,'Z W NDC," Not found!",!
 I X W:OUTPUT $$FMTNDC(NDC,4,4,2),!
 I Y W:OUTPUT $$FMTNDC(NDC,5,3,2),!
 I Z W:OUTPUT $$FMTNDC(NDC,5,4,1),!
 Q
