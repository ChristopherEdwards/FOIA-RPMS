SDVER ;MAN/GRR - SCHEDULING VERSION DISPLAY ; 22 AUG 84  10:48 am
 ;;5.3;Scheduling;**1015**;Aug 13, 1993;Build 21
 S IOP=$S($D(ION):ION,1:"HOME") D ^%ZIS K IOP W !!!,"Scheduling Version ",$P($T(SDVER+1),";",3),!
 Q
