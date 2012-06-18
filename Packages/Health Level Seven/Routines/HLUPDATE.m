HLUPDATE ; IHS/TUC/DLR - UPDATE HL FILE ENTRIES ;   [ 04/02/2003  8:36 AM ]
 ;;1.6;HEALTH LEVEL SEVEN;**1004**;APR 1, 2003
 ;
 ; This routine updates the HL package file entries
 ; to support the current version of the HL7 standard.
 ; It is run from the M prompt, after HLINIT.  It takes
 ; no input variables and produces no output variables.
 ;
 N %,DA,DIC,GBL,I,V,VER,VSET,X,Y
 D ^XBKVAR
 ;
 W !,"Creating New HL7 Message Definitions.",!
 ;
 S X="VXU",DIC="^HL(771.2,",DIC(0)="L",DLAYGO=771.2
 S DIC("DR")="2///Unsolicited Vaccination Record Update"
 D DEFINE I Y<0 D ABTMSG Q
 ;
 S X="V04",DIC="^HL(779.001,",DIC(0)="L",DLAYGO=779.001
 S DIC("DR")="2///Unsolicited Vaccination Record Update"
 D DEFINE I Y<0 D ABTMSG Q
 ;
 S VSET=""
 F I=2.1,2.2,2.3 S VER(I)="",VSET=VSET_$TR(I,".")_":"_I_";"
 ;
 ; update data dictionary for file 869.2
 ;
 I $P(^DD(869.2,200.08,0),U,3)'["2.3" S $P(^(0),U,3)=VSET,^("DT")="2970416"
 ;
 ; update entries in file 771.5
 ;
 S DIC="^HL(771.5,"
 S DIC(0)="L"
 S DLAYGO=771.5
 S DIC("DR")="2///HEALTH LEVEL SEVEN"
 S V=0
 F  S V=$O(VER(V)) Q:'V  S X=V D DEFINE I Y<0 D ABTMSG Q
 Q:(Y<0)
 K DR,DLAYGO,DIC
 ;
 W !,"Adding New HL7 Versions to All Message and Event Types.",!
 ;
 S V=0
 F  S V=$O(VER(V)) Q:'V  S VER(V)=$O(^HL(771.5,"B",V,0)) I 'VER(V) D ABTMSG Q
 Q:V
 ;
 D ADD(771.2,3,"V") Q:(Y<0)
 D ADD(779.001,100,1) Q:(Y<0)
 ;
 W !,"HL File Update is Complete.",!
 Q
 ;
ADD(FILE,FIELD,SUB) ; Add new versions to one file
 ;
 S DIC(0)="L"
 S DIC("P")=$P(^DD(FILE,FIELD,0),U,2)
 S I=0
 F  S I=$O(^HL(FILE,I)) Q:'I  S DA(1)=I,DIC="^HL(FILE,"_DA(1)_","""_SUB_"""," D ADDVER I Y<0 D ABTMSG Q
 Q
 ;
ADDVER ; Add new HL versions to one message or event type  
 ;
 S V=0
 F  S V=$O(VER(V)) Q:'V  S X=VER(V) D DEFINE Q:(Y<0)
 Q
 ;
DEFINE ; define one file entry (if it doesn't already exist)
 ;
 S GBL=DIC_"""B"","""_X_""")"
 I $D(@GBL) S Y=0 Q
 K DD,DO,Y D FILE^DICN
 Q
 ;
ABTMSG ; write abort message  
 ;
 W !,*7,"*** Aborting due to Fileman error ***"
 W !,"*** Update is not complete. ***"
 Q
