AUXPROV ;[ 03/26/86  3:19 PM ]
 W !,"AUXPROV is running!",!,"Exchanging the Provider names with their entry numbers in ^AUTTPROV global.",!
 S (X,EN)=0
 F L=0:0 S X=$O(^AUTTPROV(X)) Q:'+X  W "." S $P(^(X,0),"^",1)=X,EN=EN+1
 W !,"AUXPROV has completed its task!!",*7
 W !,"A total of ",EN," entry names were exchanged with their entry numbers.",!
 Q
