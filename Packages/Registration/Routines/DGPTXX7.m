DGPTXX7 ; COMPILED XREF FOR FILE #45.01 ; 02/13/06
 ; 
 S DA(1)=DA S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^DGPT(DA(1),"S",DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^DGPT(DA(1),"S",DA,0))
 S X=$P(DIKZ(0),U,8)
 I X'="" S ^DGPT(DA(1),"S","AO",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,9)
 I X'="" S ^DGPT(DA(1),"S","AO",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,10)
 I X'="" S ^DGPT(DA(1),"S","AO",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,11)
 I X'="" S ^DGPT(DA(1),"S","AO",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,12)
 I X'="" S ^DGPT(DA(1),"S","AO",$E(X,1,30),DA)=""
 G:'$D(DIKLM) A Q:$D(DISET)
END G ^DGPTXX8
