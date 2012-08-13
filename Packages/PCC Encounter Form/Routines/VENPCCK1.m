VENPCCK1 ; IHS/OIT/GIS - KNOWLEDGE BASE ;
 ;;2.6;PCC+;;NOV 12, 2007
 ; RPMS DIALOGUE
 ;
 ;
AGE ; EP - DIALOGUE FOR AGE-SEX SPECIFIC ITEMS
 N AGE
 S AGE=1
 D CAT
 Q
 ;
CAT ; EP - GET THE KB CATEGORY
 N DIC,X,Y,Z,%,CIEN,IIEN,DIR,DA,DIK,%Y
 S DIC("A")="Enter the name of the knowledgebase category: "
 S DIC="^VEN(7.11,",DIC(0)="AEQML",DLAYGO=19707.11
 D ^DIC I Y=-1 D ^XBFMK Q
MENU ; EDIT OPTION
 S CIEN=+Y
 I $P(Y,U,3) D ITEM(CIEN) Q
M1 W !!,"What do you want to do next ->"
 W !,?3,"1. Add or edit items in this category."
 W !,?3,"2. Delete this KB category."
 W !,?3,"3. Quit."
 S DIR(0)="N^1:3:0",DIR("A")="Your choice",DIR("B")="1" D ^DIR
 I Y=1 D ITEM(CIEN) Q
 I Y=3!('Y) D ^XBFMK Q
 I Y=2 W !!,"This will DELETE the category and all items associated with it!!!"
 W !,"Are you sure you want to do this"
 S %=2 D YN^DICN
 I %'=1 W ! G M1
 S DIK="^VEN(7.11,",DA=CIEN D ^DIK
 S DA=0,DIK="^VEN(7.12,"
 F  S DA=$O(^VEN(7.12,"B",CIEN,DA)) Q:'DA  D ^DIK ; CLEAN OUT THE ASSOCIATED ITEMS
 W !,"  *** CATEGORY DELETED  ***"
 D ^XBFMK
 Q
 ;
ITEM(CIEN) ; EP - ENTER/EDIT ITEMS FOR A SPECIFIC CATEGORY
 N DIC,DIK,DIR,DA,X,Y,Z,%,TUNIT,FLAG
 I AGE S TUNIT=" "_$P($G(^VEN(7.11,CIEN,0)),U,10)
LOOP W !!,"What do you want to do next ->"
 W !,?3,"1. Add an item"
 W !,?3,"2. Edit an existing item"
 W !,?3,"3. Delete an item"
 W !,?3,"4. Quit"
 S DIR(0)="N^1:4:0",DIR("A")="Your choice",DIR("B")="1" D ^DIR
 I Y=4!('Y) D ^XBFMK Q  ; QUIT
 I Y=2 S FLAG="EDIT"
 I Y=3 S FLAG="DELETE"
 I Y=1 S FLAG="ADD" S IIEN=$$ADD(CIEN) G:'IIEN LOOP D EDIT(IIEN) G LOOP ; KEEP LOOPING
 ; 
LOOKUP S DIC="^VEN(7.12,",DIC(0)="AEQM"
 S DIC("A")="Item: "
 S DIC("S")="I +^(0)=CIEN"
 S %="W "": "",$P($G(^VEN(7.12,Y,0)),U,2)"
 I AGE S %=%_","" (Age: "",$P($G(^VEN(7.12,Y,0)),U,13),""-"",$P($G(^VEN(7.12,Y,0)),U,14),$G(TUNIT),"")"""
 S DIC("W")=%
 D ^DIC I Y=-1 D ^XBFMK G LOOP
 K DIC S IIEN=+Y
 I FLAG="EDIT" D EDIT G LOOP
DELETE W !,"Are you sure you want to delete the item"
 S %=2 D YN^DICN
 I %'=1 W ! G M1
 S DIK="^VEN(7.12,",DA=IIEN D ^DIK
 W !,"  *** ITEM DELETED ***",!
 G LOOP
 ;
EDIT(DA) ; EP - EDIT AN ITEM
 N DIE,DR,X,Y,Z,%
 S DIE="^VEN(7.12,"
 S DR=""
 I AGE D
 . S DR=".02Item name"
 . D ^DIE
 . I '$L($P($G(^VEN(7.12,DA,0)),U,2)) Q  ; REQUIRED FIELD
 . S DR=".04Code;.1Gender screen;.13Starting age (mos);.14Ending age (mos)"
 . D ^DIE
 . Q
 I $D(^VEN(7.12,DA,0)),'$L($P($G(^(0)),U,2)) S DIK="^VEN(7.12," D ^DIK ; REQUIRED FIELD
 D ^XBFMK
 Q
 ;
ADD(CIEN) ; EP - ADD A NEW ITEM
 N DIC,X,Y,%
 S DIC="^VEN(7.12,",DIC(0)="L",DLAYGO=19707.12
 S X="""`"_CIEN_""""
 D ^DIC
 I Y=-1 Q ""
 Q +Y
 ;
 ;
 ; --------------------------------------------------------
 ;
TADD(OUT,IN) ; EP - ADD A KB TO ONE OR MORE TEMPLATES
 S OUT="UPDATE FAILED!"
 S IN=$G(IN) I '$L(IN) Q
 N KIEN,TSTG,TIEN,DIC,DA,X,Y,%,PCE,LEN
 S KIEN=+IN I '$D(^VEN(7.11,KIEN,0)) Q
 S DIC(0)="L",DLAYGO=19707.4116
 S DIC("P")="19707.4116P"
 S X="`"_KIEN
 S TSTG=$P(IN,";",2) S LEN=$L(TSTG,",")
 F PCE=1:1:LEN D
 . S DA(1)=$P(TSTG,",",PCE)
 . I '$D(^VEN(7.41,DA(1),0)) Q
 . S DIC="^VEN(7.41,"_DA(1)_",16,"
 . D ^DIC I Y=-1 Q
 . Q
 D ^XBFMK
 S OUT="TEMPLATE FILE(S) UPDATED SUCCESSFULLY!"
 Q
 ; 
TREM(OUT,IN) ; EP - REMOVE A KB FROM ONE OR MORE TEMPLATES
 S OUT="UNABLE TO REMOVE KB FROM TEMPLATE(S)!"
 S IN=$G(IN) I '$L(IN) Q
 N KIEN,TSTG,TIEN,DIK,DA,X,Y,%,PCE,LEN
 S KIEN=+IN I '$D(^VEN(7.11,KIEN,0)) Q
 S TSTG=$P(IN,";",2) S LEN=$L(TSTG,",")
 F PCE=1:1:LEN D
 . S DA(1)=$P(TSTG,",",PCE)
 . I '$D(^VEN(7.41,DA(1),0)) Q
 . S DIK="^VEN(7.41,"_DA(1)_",16,"
 . S DA=$O(^VEN(7.41,DA(1),16,"B",KIEN,0)) I 'DA Q
 . D ^DIK I Y=-1 Q
 . Q
 D ^XBFMK
 S OUT="KB REMOVED SUCCESSFULLY!"
 Q
 ;
 ; --------------------------------------------------------
 ;
KBG(OUT,IN) ; EP - RPC: VEN PCC+ GET KB GROUPS
 S OUT="BMX ADO SS^VEN KB CATEGORY^^B~~~999999"
 Q
 ; 
KBI(OUT,IN) ; EP-SUBMIT KB GROUP AND RETURN ALL THE ITEMS IN A TABLE
 S OUT=""
 I '$L(IN) Q
 N DIC,X,KGIEN,KIEN,DA
 S KGIEN=$O(^VEN(7.11,"B",IN,0))
 I 'KGIEN D  ; NEED TO ADD NEW GROUP
 . S DIC="^VEN(7.11,",DOC(0)="L"
 . S DLAYGO=19707.11 S X=IN
 . D ^DIC I Y=-1 Q
 . S KGIEN=+Y
 . Q
 D ^XBFMK
 I 'KGIEN Q
 S OUT="BMX ADO SS^VEN KB ITEM^^B~"_KGIEN_"~"_KGIEN_"~999999"
 Q
 ; 
TAX(OUT,IN) ; EP - RPC: VEN PCC+ KB TAXONOMY
 S OUT="BMX ADO SS^VEN KB TAXONOMY^^~~~~~ITAX~VENPCCK~"  ; RETURN ALL TAXONOMIES
 Q
 ;
KBT1(OUT,IN) ; EP - RPC: VEN PCC+ GET KB TEMPLATES
 I $G(IN)="" S OUT="" Q  ; INVALID KB GROUP
 S OUT="BMX ADO SS^VEN KB TEMPLATES^^~~~~~FKBT~VENPCCK~"_IN  ; RETURN ALL TEMPLATES ASSOC W KB GRP
 Q
 ; 
KBT2(OUT,IN) ; EP - RPC: VEN PCC+ GET NON KB TEMPLATES
 I $G(IN)="" S OUT="" Q  ; INVALID KB GROUP
 S OUT="BMX ADO SS^VEN KB TEMPLATES^^~~~~~NKBT~VENPCCK~"_IN  ; RETURN ALL TEMPLATES NOT ASSOC W KB GRP
 Q
 ; 
 ; ------------------------------------------------------------------
 ; 
ITAX(PARAM,IENS,MAX,OUT,TOT) ; EP - RETURN A LIST OF TEMPLATES ASSOCIATED WITH A KB GROUP
 N NAME,DA,STG
 S NAME=""
 F  S NAME=$O(^ATXAX("B",NAME)) Q:NAME=""  D
 . S DA=0
 . F  S DA=$O(^ATXAX("B",NAME,DA)) Q:'DA  D
 .. I $P($G(^ATXAX(DA,0)),U,15)'=80 Q  ; MUST BE AN ICD TAXONOMY
 .. X ("D DATA"_$C(94)_"BMXADOV1(IENS,DA)")
 .. Q
 . Q
 Q ""
 ; 
FKBT(KGIEN,IENS,MAX,OUT,TOT) ; EP - RETURN A LIST OF TEMPLATES ASSOCIATED WITH A KB GROUP
 N MODE S MODE=1
 D FKBTX
 Q ""
 ; 
NKBT(KGIEN,IENS,MAX,OUT,TOT) ; EP - RETURN A LIST OF TEMPLATES THAT ARE NOT ASSOCIATED WITH A KB GROUP
 N MODE S MODE=0
 D FKBTX
 Q ""
 ; 
FKBTX ; FILTERS
 N NAME,DA,STG
 I '$D(^VEN(7.11,+$D(KGIEN),0)) Q
 S NAME=""
 F  S NAME=$O(^VEN(7.41,"B",NAME)) Q:NAME=""  D
 . S DA=0
 . F  S DA=$O(^VEN(7.41,"B",NAME,DA)) Q:'DA  D
 .. I MODE,'$O(^VEN(7.41,DA,16,"B",KGIEN,0)) Q  ; FILTER OUT FORM IF IT IS NOT ASSOCIATED WITH THIS KB GROUP
 .. I 'MODE,$O(^VEN(7.41,DA,16,"B",KGIEN,0)) Q  ; FILTER OUT FORM IF IT IS NOT ASSOCIATED WITH THIS KB GROUP
 .. D DATA^BMXADOV1(IENS,DA)
 .. Q
 . Q
 Q
 ;
KBT3(OUT,IN) ; EP-ASSOCIATE KB GROUP WITH TEMPLATES
 N DIC,X,Y,DA,STG,PCE,KB
 S KB=+$G(IN) I '$D(^VEN(7.11,KB,0)) Q ""
 S DIC("P")="19707.4116P" S DIC(0)="L" S DLAYGO=19707.4116
 S STG=$P(IN,";",2)
 F PCE=1:1:$L(STG,",") D
 . S DA(1)=$P(STG,",",PCE)
 . S X="`"_KB
 . I '$D(^VEN(7.41,DA(1))) Q
 . S DIC="^VEN(7.41,"_DA(1)_",16,"
 . D ^DIC
 . Q
 S OUT="OK" D ^XBFMK
 Q
 ; 
