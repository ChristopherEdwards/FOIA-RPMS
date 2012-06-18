FHIPST7	; HISC/NCA - Annual Report Date Field Conversion ;1/5/94  15:09
	;;5.0;Dietetics;;Oct 11, 1995
EN1	; Check if field for Pat Sat is Date
	D NOW^%DTC S NOW=%\1
	F PRE=0:0 S PRE=$O(^FH(117.3,PRE)) Q:PRE<1  D FIND
	D TF
	K %,%H,%I,%T,FHDTE,FHX1,FHX2,L1,LP,LST,NOW,PRE,TUN,X,ZZ D ^FHXMOV Q
FIND	; Find all data entered pointing to entries 18 and 19 in
	; file 117.4
	I $D(^FH(117.3,PRE,2)) K ^FH(117.3,PRE,2)
	F L1=0:0 S L1=$O(^FH(117.3,PRE,"SPEC",L1)) Q:L1<1  S FHX2=$G(^(L1,0)) I +FHX2=18!(+FHX2=19) D REMOV
	Q
REMOV	; Remove the entries found and the B cross ref
	K ^FH(117.3,PRE,"SPEC",L1,0)
	K ^FH(117.3,PRE,"SPEC","B",+FHX2,L1)
	S ZZ=^FH(117.3,PRE,"SPEC",0) S:$P(ZZ,"^",3)=L1 $P(ZZ,"^",3)=$P(ZZ,"^",3)-1
	S $P(^FH(117.3,PRE,"SPEC",0),"^",3,4)=$P(ZZ,"^",3)_"^"_($P(ZZ,"^",4)-1)
	Q
TF	; Convert Tubefeeding CC/Unit data to Amt/Unit
	F TUN=0:0 S TUN=$O(^FH(118.2,TUN)) Q:TUN<1  S X=$P($G(^(TUN,0)),"^",3) D CHG
	Q
CHG	I X,$E(X,$L(X))'?1U S X=X_"C",$P(^FH(118.2,TUN,0),"^",3)=X
	Q
