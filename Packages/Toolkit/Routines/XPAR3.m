XPAR3 ;ISF/RWF - Remove all parameters for a user ;4/1/02  08:42 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**60**;Apr 25, 1995
 ;
DELUSR(ENT) ;Delete all instances of all parameters for a user (entity).
 ; Should only be called when a user is terminated.
        N DA,DIK
        I ENT'?1N.N S ERR=$$ERR^XPARDD(89895007) Q
        S ENT=ENT_";VA(200,"
        S DA="",DIK="^XTV(8989.5,"
        F  S DA=$O(^XTV(8989.5,"B",ENT,DA)) Q:DA=""  D
        . D ^DIK
        Q
