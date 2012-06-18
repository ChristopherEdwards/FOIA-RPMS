LR1008P ;HS/DIR/FJE; LR PATCH 8 POST INSTALL ROUTINE [ 07/08/1999  1:22 PM ]
 S ^DD(63.041,.01,1,2,0)="63.041^B"
 S ^DD(63.041,.01,1,2,1)="S ^LR(DA(2),""CH"",DA(1),1,""B"",$E(X,1,30),DA)="""""
 S ^DD(63.041,.01,1,2,2)="K ^LR(DA(2),""CH"",DA(1),1,""B"",$E(X,1,30),DA)"
 W !!,"CH Comment B cross-reference reset..",!,"Post Routine done....",!!
 Q
