AQAOX871 ; COMPILED XREF FOR FILE #9002168.7 ; 02/13/06
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^AQAO(7,DA,0))
 S X=$P(DIKZ(0),U,2)
 I X'="" K ^AQAO(7,"C",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^AQAO(7,"B",$E(X,1,30),DA)
END Q
