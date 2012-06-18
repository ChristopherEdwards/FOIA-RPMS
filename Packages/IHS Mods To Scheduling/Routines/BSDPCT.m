BSDPCT ; IHS/ANMC/LJF - SET UP PRIMARY CARE TEAM ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ; ask user to select team
 NEW DIC,DLAYGO,Y,DDSFILE,DA,DR
 S (DIC,DLAYGO)=9009017.5,DIC(0)="AEMQZL" D ^DIC Q:Y<1
 ;
 ; -- call ScreenMan to add/edit parameters
 S DDSFILE=9009017.5,DA=+Y,DR="[BSD PC TEAM EDIT]" D ^DDS
 Q
