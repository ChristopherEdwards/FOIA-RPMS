A4A7PCH6 ;SFISC/RWF - NEW PERSON PATCH 6 ;10/20/93  16:20
 ;;1.01;A4A7;**6**;JUL 30, 1992
A S U="^" D F200DD,F200A,PFP,F6DD,FE53X,F6XR Q
 ;
F200DD W !,"Remove the X-ref on DEA# and VA# in the New Person file."
 S DIK="^DD(200,53.2,1,",DA(2)=200,DA(1)=53.2,DA=1 D ^DIK
 S DIK="^DD(200,53.3,1,",DA(1)=53.3,DA=1 D ^DIK
 K ^VA(200,"APS1"),^VA(200,"APS2")
 W !,"Remove the 'BS' X-ref from the SSN field in NP."
 I $G(^DD(200,9,1,4,0))["200^BS" S DIK="^DD(200,9,1,",DA=4,DA(1)=9,DA(2)=200 D ^DIK K ^VA(200,"BS")
 W !,"Replace some X-ref in the New Person file."
 D ^A4A7P603,^A4A7P604
 D IX(200,.01),IX(200,8980.16),IX(200,53.2),IX(200,53.3),IX(200,53.4)
 Q
F200A W !,"Make the ALIAS field in file 200 avalable."
 K:$G(^DD(200,10,9))="^" ^DD(200,10,9)
 Q
PFP W !,"Fillin the PERSON FILE POINTER into file 200."
 W !,"Check and match DATE CREATED in file 200."
 F DA=.9:0 S DA=$O(^DIC(3,DA)) Q:DA'>0  D
 . S %=$P($G(^DIC(3,DA,0)),U,16),D3=$P($G(^DIC(3,DA,1)),U,7)
 . S:% $P(^VA(200,DA,0),U,16)=%
 . S D200=$P($G(^VA(200,DA,1)),U,7)
 . Q:D3=D200  S:(D3>0)&(D3'>D200) $P(^VA(200,DA,1),U,7)=D3
 . Q
 F DA=.9:0 S DA=$O(^DIC(16,DA)) Q:DA'>0  S %=$G(^DIC(16,DA,"A3")) I % S ^VA(200,"A16",DA,%)="" ;This may build more that a reindex.
 Q
F6DD W !,"Add X-refs to the provider file to keep file 200 in sync with it."
 D ^A4A7P601,^A4A7P602
 D IX(6,2),IX(6,3),IX(6,5),IX(6,6),IX(6,100)
 Q
FE53X W !,"Build the new X-ref on DEA# and VA#."
 F A4K7="53.2^1","53.3^1" S DIK="^VA(200,",DIK(1)=A4K7 D ENALL^DIK W "."
 Q
F6XR W !,"Now to update the NEW PERSON file with DEA,VA,TYPE,CLASS data from PROVIDER."
 F A4K7="2^1","3^1","5^2","6^2" S DIK="^DIC(6,",DIK(1)=A4K7 D ENALL^DIK W "."
 Q
IX(FILE,FIELD) W "."
 S DA(1)=FILE,DIK="^DD("_FILE_",",DA=FIELD D IX1^DIK
 Q
Q Q
