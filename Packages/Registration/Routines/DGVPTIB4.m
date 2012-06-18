DGVPTIB4 ;alb/mjk - IBCNSC for export with PIMS v5.3; 4/21/93
 ;;5.3;Registration;;Aug 13, 1993
 ;
IBCNSC ;ALB/MRL/AAS - INSURANCE MANAGEMENT - EDIT INSURNACE CO; 13 SEP 88@2200
 ;;Version 1.5 ; INTEGRATED BILLING ;**14**; 29-JUL-92
 ;
 ; -- insurance company edit routine for mas version 5.3
 ;    This will be updated with IB v2.0 to insurance managment option
 ;
1 W !! D Q S DGINS="",DGINSW=1,DIC="^DIC(36,",DIC(0)="AEQMLZ" D ^DIC G Q:Y'>0 S DGINS=+Y D ED G 1
 ;
ED S DIE="^DIC(36,",DR=".01;1;2;.05:.08;.09;.1;.111;S:X="""" Y=.114;.112;S:X="""" Y=.114;.113:.116;.131;.132;.133;",DA=DGINS D ^DIE:DGINSW
 Q
 ;
Q K C,I,J,X,Y,DIC,DIE,DA,DR,DGINSW,DGINS,DGNEW
 Q
