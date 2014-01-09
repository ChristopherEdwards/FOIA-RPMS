DGPTXX2 ; COMPILED XREF FOR FILE #45 ; 10/15/12
 ; 
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,2)
 S X(3)=$P(DIKZ(0),U,11)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X(4)=$P(DIKZ(70),U,22)
 S X(5)=$P(DIKZ(70),U,1)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"",$G(X(3))]"",$G(X(4))]"" D
 . K X1,X2 M X1=X,X2=X
 . S:$D(DIKIL) (X2,X2(1),X2(2),X2(3),X2(4),X2(5))=""
 . D KDGPT9D^DGPTDDCR(.X,.DA,"D SD7")
CR12 S DIXR=377
 K X
 S DIKZ(0)=$G(^DGPT(DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,2)
 S X(3)=$P(DIKZ(0),U,11)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X(4)=$P(DIKZ(70),U,23)
 S X(5)=$P(DIKZ(70),U,1)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"",$G(X(3))]"",$G(X(4))]"" D
 . K X1,X2 M X1=X,X2=X
 . S:$D(DIKIL) (X2,X2(1),X2(2),X2(3),X2(4),X2(5))=""
 . D KDGPT9D^DGPTDDCR(.X,.DA,"D SD8")
CR13 S DIXR=378
 K X
 S DIKZ(0)=$G(^DGPT(DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,2)
 S X(3)=$P(DIKZ(0),U,11)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X(4)=$P(DIKZ(70),U,24)
 S X(5)=$P(DIKZ(70),U,1)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"",$G(X(3))]"",$G(X(4))]"" D
 . K X1,X2 M X1=X,X2=X
 . S:$D(DIKIL) (X2,X2(1),X2(2),X2(3),X2(4),X2(5))=""
 . D KDGPT9D^DGPTDDCR(.X,.DA,"D SD9")
CR14 S DIXR=379
 K X
 S DIKZ(0)=$G(^DGPT(DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,2)
 S X(3)=$P(DIKZ(0),U,11)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X(4)=$P(DIKZ(70),U,10)
 S X(5)=$P(DIKZ(70),U,1)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"",$G(X(3))]"",$G(X(4))]"" D
 . K X1,X2 M X1=X,X2=X
 . S:$D(DIKIL) (X2,X2(1),X2(2),X2(3),X2(4),X2(5))=""
 . D KDGPT9D^DGPTDDCR(.X,.DA,"DXLS")
CR15 S DIXR=390
 K X
 S DIKZ(0)=$G(^DGPT(DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,2)
 S X(3)=$P(DIKZ(0),U,11)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X(4)=$P(DIKZ(70),U,11)
 S X(5)=$P(DIKZ(70),U,1)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"",$G(X(3))]"",$G(X(4))]"" D
 . K X1,X2 M X1=X,X2=X
 . S:$D(DIKIL) (X2,X2(1),X2(2),X2(3),X2(4),X2(5))=""
 . D KDGPT9D^DGPTDDCR(.X,.DA,"PDX")
CR16 K X
END G ^DGPTXX3
