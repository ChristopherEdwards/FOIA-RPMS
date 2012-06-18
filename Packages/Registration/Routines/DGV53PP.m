DGV53PP ;alb/mjk - DG Pre-Init Driver for v5.3 ; 3/26/93
 ;;5.3;Registration;;Aug 13, 1993
 ;
EN ; -- main entry point
 D LINE^DGVPP,EN^DGV53PP1 G ENQ:'$D(DIFQ)
 D LINE^DGVPP
ENQ Q
 ;
GL ; -- check if new global is set up
 G GLQ:$D(^XXXX)
 W !,"The new ^XXXX global must be defined using %GLOMAN before the install can start!",!,"Please refer to the Install Guide for details.",*7
 K DIFQ
GLQ Q
