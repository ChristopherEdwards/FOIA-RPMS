GMRCYP9 ; SLC/PKS-KR Remove Terminated Users ; [2/18/00 3:17pm]
 ;;3.0;CONSULT/REQUEST TRACKING;**9**;Dec 27, 1997
 Q
 ;           
BF ; Remove Entries for all Terminated Users (By File)
 ;              
 ;     FILENUM   File #
 ;     FIELDNUM  Field #
 ;     LCNT      Line Counter
 ;     RTS(      Array of Global Roots
 ;     GTOT      Grand Total Terminated Users
 ;     GMRCMSG   Array for Bulletin Message
 ;     GMRCCNT   Counter Variable
 ;     XMvars    Set for Bulletin Message
 ;            
 D POST ; Rebuild x-refs for REQUEST SERVICES file.
 ;
 N USR,TAG,FILENUM,FIELDNUM,LCNT,NOW,GTOT,RTS,DIFROM,GMRCMSG,GMRCCNT,XMDUZ,XMY,XMTEXT,XMSUB
 S LCNT=0,GTOT=0,GMRCCNT=0,NOW=DT
 F LCNT=1:1 D CHECK  Q:FILENUM=""!(FIELDNUM="")
 ;
 ; Send a bulletin to the user with information on terminations:
 S XMDUZ=.5,XMY(DUZ)="",XMSUB="  Patch GMRC*3*9 Post-Init Notice"
 S XMTEXT="GMRCMSG("
 S GMRCMSG(GMRCCNT+1,0)=""
 S GMRCMSG(GMRCCNT+2,0)="Upon successful completion of installation "
 S GMRCMSG(GMRCCNT+3,0)="of this patch, be sure to delete routines: "
 S GMRCMSG(GMRCCNT+4,0)="     GMRCYP9"
 S GMRCMSG(GMRCCNT+5,0)="     GMRCYP9B"
 S GMRCMSG(GMRCCNT+6,0)=""
 S GMRCMSG(GMRCCNT+7,0)="NOTE: Data for deleted pointers can be "
 S GMRCMSG(GMRCCNT+8,0)="found in the ""Install File Print"" record."
 S GMRCMSG(GMRCCNT+9,0)="The record can be accessed by using the KIDS "
 S GMRCMSG(GMRCCNT+10,0)="""Utility"" menu ""Install File Print"" option."
 S GMRCMSG(GMRCCNT+11,0)=""
 D ^XMD
 ;
 Q
 ;
CHECK ; Check users in <FILE> and <FIELD>
 ;          
 ;     FILENUM   File #
 ;     FIELDNUM  Field #
 ;     LCNT      Line Counter
 ;     RTS(      Array of Global Roots
 ;            
 S FILENUM=$$FILE(LCNT) Q:FILENUM=""
 S FIELDNUM=$$FIELD(LCNT) Q:FIELDNUM=""
 K RTS
 D INFO^GMRCYP9B(FILENUM,FIELDNUM,.RTS) Q:'$D(RTS)
 D:$D(RTS) REMOVE
 Q
 ;
FILE(X) ; Get File Number
 S TAG="DATC" ; For CONSULTS.
 S X=+($G(X)) Q:X="" "" S X=$P($T(@TAG+X),";;",2) Q:X="" ""
 S X=$P(X,";",1) Q X
 ;           
FIELD(X) ; Get Field Number
 S TAG="DATC" ; For CONSULTS.
 S X=+($G(X)) Q:X="" "" S X=$P($T(@TAG+X),";;",2) Q:X="" ""
 S X=$P(X,";",2) Q X
 ;           
REMOVE ; Remove Terminated User
 ;               
 ;     DA        Current DA Array
 ;     DIC       Current Global Root
 ;     LVL       Current Level
 ;     IND       Indentation (for write statements)
 ;     TERM      Terminated Entries Found in File
 ;     TOT       Total Terminated Entries Found
 ;
 N DA,IEN,DIC,LVL,IND,TOT,TERM
 S (TERM,LVL,TOT)=0,IND=2 D REMDAT
 S TOT=+($G(TOT))+($G(TERM)),GTOT=+($G(GTOT))+($G(TOT))
 I +($G(USR))=0 D
 . S GMRCCNT=GMRCCNT+1
 . S:TOT>0 GMRCMSG(GMRCCNT,0)="     "_FILENUM_","_FIELDNUM_": "_TOT_" pointers to terminated users"_" deleted from this field."
 . S:TOT'>0 GMRCMSG(GMRCCNT,0)="     "_FILENUM_","_FIELDNUM_": No pointers to terminated users found in this field."
 Q
 ;
REMDAT ; Get Removal Data (Name and Termination Date)
 ;               
 ;     LVL       Current Level
 ;     RTS(      Array of Global Roots
 ;                    
 S LVL=$O(RTS("DIC",LVL)) D GETDAT
 Q
 ;
GETDAT ; Get Data
 ;               
 ;     DA        Current DA Array
 ;     DIC       Current Global Root
 ;     DICP      Current Global Specifier
 ;     LVL       Current Level
 ;     IEN       Current Internal Entry Number
 ;     RTS(      Array of Global Roots
 ;                    
 S DIC=$G(RTS("DIC",LVL)) Q:'$L(DIC)
 S:$L($G(RTS("DIC",LVL,"P"))) DICP=RTS("DIC",LVL,"P")
 S IEN=0 F  S IEN=$O(@(DIC_IEN_")")) Q:+IEN=0  D  Q:+IEN=0
 . Q:+IEN=0  S DA=IEN
 . D NEXTDAT:+($O(RTS("DIC",LVL)))>0,EXTDAT:+($O(RTS("DIC",LVL)))'>0
 Q
 ;
NEXTDAT ; Next Data (for subfiles)
 ;            
 ;     DA        Current DA Array
 ;     DIC       Current Global Root
 ;     DICP      Current Global Specifier
 ;     LVL       Current Level
 ;     IEN       Current Internal Entry Number
 ;     OLDDA     Previous DA Array
 ;     OLDDIC    Previous Global Root
 ;     OLDLVL    Previous Level
 ;     CNT       Counter
 ;            
 N CNT,OLDDA,OLDLVL,OLDDIC,OLDDICP
 S OLDDA=DA,OLDLVL=LVL,OLDDIC=DIC,OLDDICP=$G(DICP)
 F CNT=1:1:$O(DA(" "),-1) D
 . S:$D(DA(CNT)) OLDDA(CNT)=DA(CNT)
 N DA
 F CNT=1:1:$O(OLDDA(" "),-1) D
 . S:$D(OLDDA(CNT)) DA(CNT+1)=OLDDA(CNT)
 S DA(1)=OLDDA N IEN,LVL,DIC,DICP S LVL=OLDLVL,DIC=OLDDIC D REMDAT
 Q
 ;
EXTDAT ; Extract Data
 ;          
 ;     GMRCERR   Error Message Array
 ;     CDA       DA Counter
 ;     LDA       Last DA
 ;     NODE      Fully Specified Global Node
 ;     NODEDAT   Data Stored at Global Node
 ;     NODESUB   Node Subscript #
 ;     NODELOC   Node Location ($PIECE # of Node)
 ;     GBLLOC    Global Subscript Location  (#;#)
 ;     DIC       Fully Specified Global Root
 ;     DICP      Global Specifier
 ;     USRP      Pointer to New Person File
 ;     USRNAME   User's Name
 ;     USRITD    Internal form of User's Termination Date
 ;     USRETD    External form of User's Termination Date
 ;     USRSTA    User Status
 ;     USRACT    User Action
 ;     GMRCUSRP  Pointer Holder
 ;          
 N GMRCERR,CDA,LDA,NODE,NODEDAT,NODELOC,NODESUB,GBLLOC,USRP,USRNAME,USRITD,USRETD,USRSTA,USRACT,GMRCUSRP
 S GBLLOC=$G(RTS("LOC")) Q:$L($G(GBLLOC),";")'=2
 S NODESUB=$P($G(GBLLOC),";",1),NODELOC=+($P($G(GBLLOC),";",2))
 Q:'$L(NODESUB)  Q:+(NODELOC)'>0  Q:'$L($G(DIC))  Q:+($G(DA))'>0
 Q:'$L($G(NODESUB))  Q:+($G(NODELOC))'>0  Q:DIC["DA("&(+($G(DA(1)))=0)
 Q:'$L($G(DICP))
 S NODE=DIC_DA_","_NODESUB_")" Q:'$D(@NODE)  S NODEDAT=@NODE
 S USRP=+($P(NODEDAT,"^",NODELOC)) Q:USRP=0
 I +($G(USR))>0,$D(^VA(200,+($G(USR)),0)),$L($P($G(^VA(200,+($G(USR)),0)),"^",1)),+($G(USR))'=USRP Q
 S GMRCUSRP=USRP
 K GMRCERR S USRNAME=$$GET1^DIQ(200,GMRCUSRP,.01,"E",,.GMRCERR) Q:$D(GMRCERR)
 K GMRCERR S USRITD=$$GET1^DIQ(200,GMRCUSRP,9.2,"I",,.GMRCERR) Q:$D(GMRCERR)
 S USRSTA=$$TERM^GMRCYP9B(+USRP),USRACT=$P(USRSTA,"^",1),USRSTA=$S(USRACT=2:"Terminated",USRACT=1:"Future Termination",USRACT=0:"Active User",1:"Undetermined")
 S USRETD=$$FMTE^XLFDT(USRITD,1) Q:USRACT'=2  S:USRACT=2 TERM=TERM+1 D:USRACT=2 DEL
 I +($G(USR))>0,$D(^VA(200,+($G(USR)),0)),$L($P($G(^VA(200,+($G(USR)),0)),"^",1)) Q
 S LDA=+($O(DA(" "),-1))
 Q
 ;
DEL ; Delete Entry
 ;          
 ;     DIC       Current Global Root
 ;     OLDDIC    Former DIC (Global Root)
 ;     DIC(0)    Lookup Parameters
 ;     DIC("P")  Subfile Specifiers
 ;     DIC("DR") Data Field String
 ;     OLDDA     Former DA Array
 ;     DA        Current DA Array
 ;                     
 ;     DIE       Global Root
 ;     DIK       Global Root
 ;     DR        Data Field String
 ;     DTOUT     Timeout Flag
 ;     DUOUT     Up-Arrow Out Flag
 ;     DLAYGO    "Learn As You Go" Flag
 ;     OLDDUZ    Former User
 ;     DUZ       Current User
 ;     DUZ(0)    Current User Access
 ;     GL        Fileman Global Location
 ;     UDA       Uppermost DA
 ;     LN        Node to Lock
 ;     VAR       Field Value
 ;     X         Input Data
 ;     Y         Output Data
 ;     I         Counter
 ;          
 Q:'$D(DIC)  Q:'$D(DA)  Q:+($G(RTS("FILE")))=0  Q:+($G(RTS("FIELD")))=0
 ;
 N I,LN,UDA
 S OLDDA=DA,I=0 F  S I=$O(DA(I)) Q:+I=0  S OLDDA(I)=DA(I)
 N DA S DA=OLDDA,I=0 F  S I=$O(OLDDA(I)) Q:+I=0  S DA(I)=OLDDA(I)
 ;
 N DIK,DIE,DR,DLAYGO,DTOUT,DUOUT,X,Y,OLDDIC,OLDDUZ,VAR,GL
 S:$D(DUZ(0)) OLDDUZ=$G(DUZ(0))
 S OLDDIC=$G(DIC)
 N DIC S (DIK,DIE,DIC)=$G(OLDDIC),GL=$G(RTS("DIC",1)) Q:'$D(@(GL_"0)"))
 S UDA=DA S:$D(DA(1))&(+($O(DA(" "),-1))>0) UDA=DA(+($O(DA(" "),-1)))
 Q:+UDA=0  S LN=(GL_UDA_")")
 ;
 S:$D(RTS("DIC",2))&($L($G(DICP))) DIC("P")=$G(DICP)
 S DIC(0)=$G(DIC(0)) S:DIC(0)'["L" DIC(0)=DIC(0)_"L"
 S DLAYGO=+($G(RTS("FILE")))
 S (DR,DIC("DR"))=+($G(RTS("FIELD")))_"///^S X=VAR",VAR="@"
 L +@LN:0
 D ^DIE
 L -@LN
 D MES^XPDUTL("Pointer to "_USRNAME_"/"_+USRP_" deleted from file "_FILENUM_", field "_FIELDNUM_".") ; Installation message to run under Taskman.
 ;
 Q
 ;
DATC ; Data (FILE/FIELDS) for pointer removal (Consults)
 ;;123.5;123.5;ISC-SLC/PKS
 ;;123.5;123.08;ISC-SLC/PKS
 ;;123.54;1;ISC-SLC/PKS
 ;;123.55;.01;ISC-SLC/PKS
 ;;123.555;.01;ISC-SLC/PKS
 ;;
 ;
 Q
 ;
POST ; Further post-install action for patch GMRC*3*9.
 ;
 ; Set variables for Taskman:
 S ZTRTN="RBLDIXS^GMRCYP9"
 S ZTDTH=$H
 S ZTDESC="Consults GMRC*3*9 post-install file ^GMR(123.5 indices rebuild."
 S ZTIO=""
 ;
 ; Call Taskman to run the post-install indices rebuild:
 D ^%ZTLOAD
 Q
 ;
RBLDIXS ; Rebuild indices for ^GMR(123.5 file.
 ;
 N ROOT,IEN,DIK,DA
 S ROOT="^GMR(123.5," ; Common file root for x-refs.
 ;
 S IEN=0
 F  S IEN=$O(^GMR(123.5,IEN)) Q:'IEN  D  ; Each Consults service.
 .S DA(1)=IEN,DIK=ROOT_DA(1)_",123.1,",DIK(1)=.01
 .D ENALL^DIK         ; Rebuild "AST" x-ref.
 .;
 .S DA(1)=IEN,DIK=ROOT_DA(1)_",123.2,",DIK(1)=2
 .D ENALL^DIK         ; Rebuild "ANT" x-ref.
 .;
 .S DA(1)=IEN,DIK=ROOT_DA(1)_",123.31,",DIK(1)=.01
 .D ENALL^DIK         ; Rebuild "AUT" x-ref.
 .;
 .S DA(1)=IEN,DIK=ROOT_DA(1)_",123.34,",DIK(1)=.01
 .D ENALL^DIK         ; Rebuild "AAT" x-ref.
 ;
 Q
 ;