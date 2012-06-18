FHIPST17	; HISC/REL - Add Recipe Categories to Meals ;5/2/95  09:53
	;;5.0;Dietetics;;Oct 11, 1995
	F K=0:0 S K=$O(^FH(116.1,K)) Q:K<1  F L=0:0 S L=$O(^FH(116.1,K,"RE",L)) Q:L<1  D
	.S R1=+$G(^FH(116.1,K,"RE",L,0)) Q:'R1
	.S ZZ=$P($G(^FH(116.1,K,"RE",L,0)),"^",3) Q:ZZ
	.S CAT=$P($G(^FH(114,R1,0)),"^",7) Q:'CAT
	.S $P(^FH(116.1,K,"RE",L,0),"^",3)=CAT Q
	K CAT,K,L,R1,ZZ
EN1	; Loop through the Meals and populate the category and pd fields
	F M1=0:0 S M1=$O(^FH(116.1,M1)) Q:M1<1  F REC=0:0 S REC=$O(^FH(116.1,M1,"RE",REC)) Q:REC<1  S X1=$G(^(REC,0)) D:X1'="" GET
	K FHX1,FHX2,M1,REC,STR,X1 Q
GET	S STR=""
	I $P(X1,"^",3),$P(X1,"^",2)'="" S STR=$P(X1,"^",3)_"^"_$P(X1,"^",2)
	I STR'=""  D
	.Q:$D(^FH(116.1,M1,"RE",REC,"R",0))
	.S ^FH(116.1,M1,"RE",REC,"R",0)="^116.12PA^^"
	.S FHX1=$G(^FH(116.1,M1,"RE",REC,"R",0)),FHX2=$P(FHX1,"^",3)+1
	.S $P(^FH(116.1,M1,"RE",REC,"R",0),"^",3,4)=FHX2_"^"_($P(FHX1,"^",4)+1)
	.I '$D(^FH(116.1,M1,"RE",REC,"R",FHX2,0)) S ^FH(116.1,M1,"RE",REC,"R",FHX2,0)=STR,^FH(116.1,M1,"RE",REC,"R","B",+STR,FHX2)=""
	.Q
	Q
