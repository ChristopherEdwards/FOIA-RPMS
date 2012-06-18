AZXZTST ;NEW PROGRAM [ 05/01/95   1:25 PM ]
 
MAIN ;MAIN
 W !,"Organism Codes",!
 S X=999
 F  S X=$O(^DIZ(1991018,"C",X)) Q:'X  W X," "
 S X=99
 F  S X=$O(^DIZ(1991018,"C",X)) Q:X<99  W X," "
 
 W !,"Speciman Codes",!
 S X=999
 F  S X=$O(^DIZ(1991019,"C",X)) Q:'X  W X," "
 S X=99
 F  S X=$O(^DIZ(1991019,"C",X)) Q:X<99  W X," "
