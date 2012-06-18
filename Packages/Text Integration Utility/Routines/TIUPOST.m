TIUPOST ; SLC/JER - Post-init for TIU ;2/17/95  11:15
 ;;1.0;TEXT INTEGRATION UTILITIES;;Jun 20, 1997
 ;IHS/ITSC/LJF 02/28/2003 compile IHS hidden actions protocol
 ;             06/26/2003 list templates now exported via KIDS
 ;             07/10/2003 clean up TIU(8925.1 data item multiple
 ;             08/27/2003 run postinit for VA patch #153 seq 149
 ;             08/28/2003 fix upload error filing code
 ;             11/14/2003 add TIU to PCC file for visit merges
 ;             12/31/2003 record previous TIU patches & fix protocols
 ;
MAIN ; Control branching
 ;D ^TIUIL        ;   Install List Templates;IHS/ITSC/LJF 6/26/2003 not needed
 D COMPILE       ;   Compile hidden menus
 D KILL^TIUDD8   ;   Force recompilation of SEARCH CATEGORIES
 D EN^TIULEXP    ;   Redirect ^LEX( ptr in PROBLEM LINK file
 S $P(^TIU(8925.1,0),U,3)=100  ; Reset file root to fill gaps
 ;
 ;IHS/ITSC/LJF 7/10/2003 clean up item data in TIU Document Definition file
 D CLEAN^BTIUPOS
 ;IHS/ITSC/LJF 8/27/2003 call postinit for patch 153 - clean sup ACLAU and ACLEC xrefs
 D BMES^XPDUTL("Post install code from VA patch 153; cleans up xrefs . . .")
 D EN^TIUPS153
 ;IHS/ITSC/LJF 8/28/2003 fix upload error filing code for progress notes and consults
 D DDMFIX^BTIUPOS
 ;IHS/ITSC/LJF 11/14/2003 add TIU to Module PCC Link Control file for visit merges
 ;                        and add TIU to Visit Tracking Parameters file
 D PCCLNK^BTIUPOS
 D VSTLINK^BTIUPOS
 ;IHS/ITSC/LJF 12/31/2003 record previous TIU patches that OE/RR checks for
 D PATCHES^BTIUPOS2
 ;IHS/ITSC/LJF 12/31/2003 clean up protocols previuosly sent
 D PROTCL^BTIUPOS2
 ;
 Q
COMPILE ; Compile Hidden Menus
 N DIC,XQORM,X,Y
 D BMES^XPDUTL("*** COMPILING HIDDEN PROTOCOL MENUS ***")
 S DIC="^ORD(101,",DIC(0)="X",X="TIU HIDDEN ACTIONS" D ^DIC
 I +Y D
 . D MES^XPDUTL($P(Y,U,2)_".")
 . S XQORM=+Y_";ORD(101,",XQORM(0)="" D ^XQORM
 S DIC="^ORD(101,",DIC(0)="X",X="TIU HIDDEN ACTIONS ADVANCED" D ^DIC
 I +Y D
 . D MES^XPDUTL($P(Y,U,2)_".")
 . S XQORM=+Y_";ORD(101,",XQORM(0)="" D ^XQORM
 S DIC="^ORD(101,",DIC(0)="X",X="TIU HIDDEN ACTIONS OE/RR" D ^DIC
 I +Y D
 . D MES^XPDUTL($P(Y,U,2)_".")
 . S XQORM=+Y_";ORD(101,",XQORM(0)="" D ^XQORM
 S DIC="^ORD(101,",DIC(0)="X",X="TIU HIDDEN ACTIONS BROWSE" D ^DIC
 I +Y D
 . D MES^XPDUTL($P(Y,U,2)_".")
 . S XQORM=+Y_";ORD(101,",XQORM(0)="" D ^XQORM
 ;
 ;IHS/ITSC/LJF 02/28/2003 compile IHS hidden actions protocol
 S DIC="^ORD(101,",DIC(0)="X",X="BTIU HIDDEN ACTIONS" D ^DIC
 I +Y D
 . D MES^XPDUTL($P(Y,U,2)_".")
 . S XQORM=+Y_";ORD(101,",XQORM(0)="" D ^XQORM
 ;
 ; now compile hidden menu from USr package
 S DIC="^ORD(101,",DIC(0)="X",X="USR HIDDEN ACTIONS" D ^DIC
 I +Y D
 . D MES^XPDUTL($P(Y,U,2)_".")
 . S XQORM=+Y_";ORD(101,",XQORM(0)="" D ^XQORM
 ;
 ;IHS/ITSC/LJF 02/28/2003 end of new code
 Q
