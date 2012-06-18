PSNDATAE ;BIR/DMA-environment check for data updates ;31 Aug 99 / 11:32 AM
 ;;4.0; NATIONAL DRUG FILE;**1,6,8,9,10,12,14,15,17,18,21,23,24,25,28,31,34**; 30 Oct 98
 I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0,$D(DUZ(0))#2,DUZ(0)="@"
 E  D BMES^XPDUTL("You must be a valid user with DUZ(0)=""@""") S XPDQUIT=2
 N X S X=$P($T(+2),"**",2),X=$P(X,",",$L(X,",")) I X I $$PATCH^XPDUTL("PSN*4.0*"_X) D BMES^XPDUTL("This patch has already been installed") S XPDQUIT=1 Q
 Q
