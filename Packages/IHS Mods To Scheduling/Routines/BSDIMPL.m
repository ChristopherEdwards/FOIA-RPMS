BSDIMPL ; IHS/ANMC/LJF - SCHEDULING IMPLEMENTATION ;  [ 01/22/2004  1:11 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 Q
 ;
EN ;EP; called by installer from programmer mode
 ; runs through items on Scheduling Supervisor Menu after install
 ;    while users still off system
 ;
ACTION ; -- choose which action to perform
 NEW BDGACT,BDGA,X,Y,BDGQUIT
 W !!
 F X=1:1:4 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 S Y=$$READ^BDGF("NO^1:4","Choose Implementation Action","","","",.BDGA)
 Q:'Y  I Y=4 S XQH="BSD IMPLEMENT" D EN^XQH G ACTION
 S BDGACT=$P($T(RPT+Y),";;",3) X BDGACT D EN^XBVK("VALM")
 D ACTION
 Q
 ;
RPT ;;
 ;;Edit Scheduling Parameters;;D ^BSDPARM;;
 ;;Update Appointment Slip Letter;;D LETTER^BSDIMPL;;
 ;;View Scheduling Event Driver;;D ^BSDSYS1;;
 ;;On-line Help;;D ^BSDHELP;;
 ;
LETTER ;EP; selects new Appointment Slip Letter for editing
 NEW DIE,DA,DR
 S DA=$O(^VA(407.5,"B","APPOINTMENT SLIP",0))
 I 'DA W !!,"No generic Appointment Slip letter on file" D PAUSE^BDGF Q
 ;
 W !!,"NAME: APPOINMENT SLIP",!
 S DIE=407.5,DR="1:9999999.99" D ^DIE
 Q
