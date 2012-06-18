BDGH05 ; IHS/ANMC/LJF - INTRO TEXT FOR SYSTEM SETUP MENU ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
 Q
 ;
EAP ;EP; intro text for Edit ADT Parameters
 NEW BDGX
 D DISPLAY(5)
 Q
 ;
ICF ;EP; intro text for Initialize Census Files option
 NEW BDGX
 D DISPLAY(3)
 Q
 ;
SAF ;EP; intro text for Setup ADT Files option
 NEW BDGX
 S BDGX(1)="Use this option to add local entries to standard ADT files"
 S BDGX(2)="and to edit local fields in those same files."
 D DISPLAY(2)
 Q
 ;
DISPLAY(N) ; -- display array with N lines
 S BDGX(1,"F")="!!!?5"
 F I=2:1:N S BDGX(I,"F")="!?5"
 S BDGX(N+1,"F")="!!"
 D EN^DDIOL(.BDGX)
 D VAR^BDGVAR      ;makes all options able to run independently
 Q
